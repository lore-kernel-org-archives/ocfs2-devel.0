From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:21 2008
Subject: [Ocfs2-devel] [PATCH 03/18] ocfs2: Negotiate locking protocol
	versions.
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-4-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit d24fbcda0c4988322949df3d759f1cfb32b32953
Author: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 25 Jan 2008 17:02:21 -0800

Currently, when ocfs2 nodes connect via TCP, they advertise their
compatibility level.  If the versions do not match, two nodes cannot speak
to each other and they disconnect. As a result, this provides no forward or
backwards compatibility.

This patch implements a simple protocol negotiation at the dlm level by
introducing a major/minor version number scheme for entities that
communicate.  Specifically, o2dlm has a major/minor version for interaction
with o2dlm on other nodes, and ocfs2 itself has a major/minor version for
interacting with the filesystem on other nodes.

This will allow rolling upgrades of ocfs2 clusters when changes to the
locking or network protocols can be done in a backwards compatible manner.
In those cases, only the minor number is changed and the negotatied protocol
minor is returned from dlm join. In the far less likely event that a
required protocol change makes backwards compatibility impossible, we simply
bump the major number.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/tcp_internal.h |   11 ++-
 fs/ocfs2/dlm/dlmapi.h           |    7 +-
 fs/ocfs2/dlm/dlmcommon.h        |   24 +++++-
 fs/ocfs2/dlm/dlmdomain.c        |  195 +++++++++++++++++++++++++++++++++-----
 fs/ocfs2/dlm/dlmfs.c            |   15 +++-
 fs/ocfs2/dlm/userdlm.c          |    5 +-
 fs/ocfs2/dlm/userdlm.h          |    3 +-
 fs/ocfs2/dlmglue.c              |   29 ++++++-
 fs/ocfs2/dlmglue.h              |    1 +
 fs/ocfs2/ocfs2.h                |    1 +
 fs/ocfs2/ocfs2_lockingver.h     |   30 ++++++
 fs/ocfs2/super.c                |    1 +
 12 files changed, 288 insertions(+), 34 deletions(-)
 create mode 100644 fs/ocfs2/ocfs2_lockingver.h

diff --git a/fs/ocfs2/cluster/tcp_internal.h b/fs/ocfs2/cluster/tcp_internal.h
index fe1a407..b4c5586 100644
--- a/fs/ocfs2/cluster/tcp_internal.h
+++ b/fs/ocfs2/cluster/tcp_internal.h
@@ -38,6 +38,15 @@
  * locking semantics of the file system using the protocol.  It should 
  * be somewhere else, I'm sure, but right now it isn't.
  *
+ * With version 11, we separate out the filesystem locking portion.  The
+ * filesystem now has a major.minor version it negotiates.  Version 11
+ * introduces this negotiation to the o2dlm protocol, and as such the
+ * version here in tcp_internal.h should not need to be bumped for
+ * filesystem locking changes.
+ *
+ * New in version 11
+ * 	- Negotiation of filesystem locking in the dlm join.
+ *
  * New in version 10:
  * 	- Meta/data locks combined
  *
@@ -66,7 +75,7 @@
  * 	- full 64 bit i_size in the metadata lock lvbs
  * 	- introduction of "rw" lock and pushing meta/data locking down
  */
-#define O2NET_PROTOCOL_VERSION 10ULL
+#define O2NET_PROTOCOL_VERSION 11ULL
 struct o2net_handshake {
 	__be64	protocol_version;
 	__be64	connector_id;
diff --git a/fs/ocfs2/dlm/dlmapi.h b/fs/ocfs2/dlm/dlmapi.h
index cfd5cb6..b5786a7 100644
--- a/fs/ocfs2/dlm/dlmapi.h
+++ b/fs/ocfs2/dlm/dlmapi.h
@@ -193,7 +193,12 @@ enum dlm_status dlmunlock(struct dlm_ctxt *dlm,
 			  dlm_astunlockfunc_t *unlockast,
 			  void *data);
 
-struct dlm_ctxt * dlm_register_domain(const char *domain, u32 key);
+struct dlm_protocol_version {
+	u8 pv_major;
+	u8 pv_minor;
+};
+struct dlm_ctxt * dlm_register_domain(const char *domain, u32 key,
+				      struct dlm_protocol_version *fs_proto);
 
 void dlm_unregister_domain(struct dlm_ctxt *dlm);
 
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index cddf85a..0f6896d 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -142,6 +142,12 @@ struct dlm_ctxt
 	spinlock_t work_lock;
 	struct list_head dlm_domain_handlers;
 	struct list_head	dlm_eviction_callbacks;
+
+	/* The filesystem specifies this at domain registration.  We
+	 * cache it here to know what to tell other nodes. */
+	struct dlm_protocol_version fs_locking_proto;
+	/* This is the inter-dlm communication version */
+	struct dlm_protocol_version dlm_locking_proto;
 };
 
 static inline struct hlist_head *dlm_lockres_hash(struct dlm_ctxt *dlm, unsigned i)
@@ -589,10 +595,24 @@ struct dlm_proxy_ast
 #define DLM_PROXY_AST_MAX_LEN  (sizeof(struct dlm_proxy_ast)+DLM_LVB_LEN)
 
 #define DLM_MOD_KEY (0x666c6172)
-enum dlm_query_join_response {
+enum dlm_query_join_response_code {
 	JOIN_DISALLOW = 0,
 	JOIN_OK,
 	JOIN_OK_NO_MAP,
+	JOIN_PROTOCOL_MISMATCH,
+};
+
+union dlm_query_join_response {
+	u32 intval;
+	struct {
+		u8 code;	/* Response code.  dlm_minor and fs_minor
+				   are only valid if this is JOIN_OK */
+		u8 dlm_minor;	/* The minor version of the protocol the
+				   dlm is speaking. */
+		u8 fs_minor;	/* The minor version of the protocol the
+				   filesystem is speaking. */
+		u8 reserved;
+	} packet;
 };
 
 struct dlm_lock_request
@@ -633,6 +653,8 @@ struct dlm_query_join_request
 	u8 node_idx;
 	u8 pad1[2];
 	u8 name_len;
+	struct dlm_protocol_version dlm_proto;
+	struct dlm_protocol_version fs_proto;
 	u8 domain[O2NM_MAX_NAME_LEN];
 	u8 node_map[BITS_TO_BYTES(O2NM_MAX_NODES)];
 };
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 10b3e60..3cd509b 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -123,6 +123,17 @@ DEFINE_SPINLOCK(dlm_domain_lock);
 LIST_HEAD(dlm_domains);
 static DECLARE_WAIT_QUEUE_HEAD(dlm_domain_events);
 
+/*
+ * The supported protocol version for DLM communication.  Running domains
+ * will have a negotiated version with the same major number and a minor
+ * number equal or smaller.  The dlm_ctxt->dlm_locking_proto field should
+ * be used to determine what a running domain is actually using.
+ */
+static const struct dlm_protocol_version dlm_protocol = {
+	.pv_major = 1,
+	.pv_minor = 0,
+};
+
 #define DLM_DOMAIN_BACKOFF_MS 200
 
 static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
@@ -133,6 +144,8 @@ static int dlm_cancel_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				   void **ret_data);
 static int dlm_exit_domain_handler(struct o2net_msg *msg, u32 len, void *data,
 				   void **ret_data);
+static int dlm_protocol_compare(struct dlm_protocol_version *existing,
+				struct dlm_protocol_version *request);
 
 static void dlm_unregister_domain_handlers(struct dlm_ctxt *dlm);
 
@@ -668,11 +681,45 @@ void dlm_unregister_domain(struct dlm_ctxt *dlm)
 }
 EXPORT_SYMBOL_GPL(dlm_unregister_domain);
 
+static int dlm_query_join_proto_check(char *proto_type, int node,
+				      struct dlm_protocol_version *ours,
+				      struct dlm_protocol_version *request)
+{
+	int rc;
+	struct dlm_protocol_version proto = *request;
+
+	if (!dlm_protocol_compare(ours, &proto)) {
+		mlog(0,
+		     "node %u wanted to join with %s locking protocol "
+		     "%u.%u, we respond with %u.%u\n",
+		     node, proto_type,
+		     request->pv_major,
+		     request->pv_minor,
+		     proto.pv_major, proto.pv_minor);
+		request->pv_minor = proto.pv_minor;
+		rc = 0;
+	} else {
+		mlog(ML_NOTICE,
+		     "Node %u wanted to join with %s locking "
+		     "protocol %u.%u, but we have %u.%u, disallowing\n",
+		     node, proto_type,
+		     request->pv_major,
+		     request->pv_minor,
+		     ours->pv_major,
+		     ours->pv_minor);
+		rc = 1;
+	}
+
+	return rc;
+}
+
 static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				  void **ret_data)
 {
 	struct dlm_query_join_request *query;
-	enum dlm_query_join_response response;
+	union dlm_query_join_response response = {
+		.packet.code = JOIN_DISALLOW,
+	};
 	struct dlm_ctxt *dlm = NULL;
 	u8 nodenum;
 
@@ -690,11 +737,11 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 		mlog(0, "node %u is not in our live map yet\n",
 		     query->node_idx);
 
-		response = JOIN_DISALLOW;
+		response.packet.code = JOIN_DISALLOW;
 		goto respond;
 	}
 
-	response = JOIN_OK_NO_MAP;
+	response.packet.code = JOIN_OK_NO_MAP;
 
 	spin_lock(&dlm_domain_lock);
 	dlm = __dlm_lookup_domain_full(query->domain, query->name_len);
@@ -713,7 +760,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				mlog(0, "disallow join as node %u does not "
 				     "have node %u in its nodemap\n",
 				     query->node_idx, nodenum);
-				response = JOIN_DISALLOW;
+				response.packet.code = JOIN_DISALLOW;
 				goto unlock_respond;
 			}
 		}
@@ -733,30 +780,48 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 			/*If this is a brand new context and we
 			 * haven't started our join process yet, then
 			 * the other node won the race. */
-			response = JOIN_OK_NO_MAP;
+			response.packet.code = JOIN_OK_NO_MAP;
 		} else if (dlm->joining_node != DLM_LOCK_RES_OWNER_UNKNOWN) {
 			/* Disallow parallel joins. */
-			response = JOIN_DISALLOW;
+			response.packet.code = JOIN_DISALLOW;
 		} else if (dlm->reco.state & DLM_RECO_STATE_ACTIVE) {
 			mlog(0, "node %u trying to join, but recovery "
 			     "is ongoing.\n", bit);
-			response = JOIN_DISALLOW;
+			response.packet.code = JOIN_DISALLOW;
 		} else if (test_bit(bit, dlm->recovery_map)) {
 			mlog(0, "node %u trying to join, but it "
 			     "still needs recovery.\n", bit);
-			response = JOIN_DISALLOW;
+			response.packet.code = JOIN_DISALLOW;
 		} else if (test_bit(bit, dlm->domain_map)) {
 			mlog(0, "node %u trying to join, but it "
 			     "is still in the domain! needs recovery?\n",
 			     bit);
-			response = JOIN_DISALLOW;
+			response.packet.code = JOIN_DISALLOW;
 		} else {
 			/* Alright we're fully a part of this domain
 			 * so we keep some state as to who's joining
 			 * and indicate to him that needs to be fixed
 			 * up. */
-			response = JOIN_OK;
-			__dlm_set_joining_node(dlm, query->node_idx);
+
+			/* Make sure we speak compatible locking protocols.  */
+			if (dlm_query_join_proto_check("DLM", bit,
+						       &dlm->dlm_locking_proto,
+						       &query->dlm_proto)) {
+				response.packet.code =
+					JOIN_PROTOCOL_MISMATCH;
+			} else if (dlm_query_join_proto_check("fs", bit,
+							      &dlm->fs_locking_proto,
+							      &query->fs_proto)) {
+				response.packet.code =
+					JOIN_PROTOCOL_MISMATCH;
+			} else {
+				response.packet.dlm_minor =
+					query->dlm_proto.pv_minor;
+				response.packet.fs_minor =
+					query->fs_proto.pv_minor;
+				response.packet.code = JOIN_OK;
+				__dlm_set_joining_node(dlm, query->node_idx);
+			}
 		}
 
 		spin_unlock(&dlm->spinlock);
@@ -765,9 +830,9 @@ unlock_respond:
 	spin_unlock(&dlm_domain_lock);
 
 respond:
-	mlog(0, "We respond with %u\n", response);
+	mlog(0, "We respond with %u\n", response.packet.code);
 
-	return response;
+	return response.intval;
 }
 
 static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
@@ -899,10 +964,11 @@ static int dlm_send_join_cancels(struct dlm_ctxt *dlm,
 
 static int dlm_request_join(struct dlm_ctxt *dlm,
 			    int node,
-			    enum dlm_query_join_response *response)
+			    enum dlm_query_join_response_code *response)
 {
-	int status, retval;
+	int status;
 	struct dlm_query_join_request join_msg;
+	union dlm_query_join_response join_resp;
 
 	mlog(0, "querying node %d\n", node);
 
@@ -910,12 +976,15 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 	join_msg.node_idx = dlm->node_num;
 	join_msg.name_len = strlen(dlm->name);
 	memcpy(join_msg.domain, dlm->name, join_msg.name_len);
+	join_msg.dlm_proto = dlm->dlm_locking_proto;
+	join_msg.fs_proto = dlm->fs_locking_proto;
 
 	/* copy live node map to join message */
 	byte_copymap(join_msg.node_map, dlm->live_nodes_map, O2NM_MAX_NODES);
 
 	status = o2net_send_message(DLM_QUERY_JOIN_MSG, DLM_MOD_KEY, &join_msg,
-				    sizeof(join_msg), node, &retval);
+				    sizeof(join_msg), node,
+				    &join_resp.intval);
 	if (status < 0 && status != -ENOPROTOOPT) {
 		mlog_errno(status);
 		goto bail;
@@ -928,14 +997,41 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 	if (status == -ENOPROTOOPT) {
 		status = 0;
 		*response = JOIN_OK_NO_MAP;
-	} else if (retval == JOIN_DISALLOW ||
-		   retval == JOIN_OK ||
-		   retval == JOIN_OK_NO_MAP) {
-		*response = retval;
+	} else if (join_resp.packet.code == JOIN_DISALLOW ||
+		   join_resp.packet.code == JOIN_OK_NO_MAP) {
+		*response = join_resp.packet.code;
+	} else if (join_resp.packet.code == JOIN_PROTOCOL_MISMATCH) {
+		mlog(ML_NOTICE,
+		     "This node requested DLM locking protocol %u.%u and "
+		     "filesystem locking protocol %u.%u.  At least one of "
+		     "the protocol versions on node %d is not compatible, "
+		     "disconnecting\n",
+		     dlm->dlm_locking_proto.pv_major,
+		     dlm->dlm_locking_proto.pv_minor,
+		     dlm->fs_locking_proto.pv_major,
+		     dlm->fs_locking_proto.pv_minor,
+		     node);
+		status = -EPROTO;
+		*response = join_resp.packet.code;
+	} else if (join_resp.packet.code == JOIN_OK) {
+		*response = join_resp.packet.code;
+		/* Use the same locking protocol as the remote node */
+		dlm->dlm_locking_proto.pv_minor =
+			join_resp.packet.dlm_minor;
+		dlm->fs_locking_proto.pv_minor =
+			join_resp.packet.fs_minor;
+		mlog(0,
+		     "Node %d responds JOIN_OK with DLM locking protocol "
+		     "%u.%u and fs locking protocol %u.%u\n",
+		     node,
+		     dlm->dlm_locking_proto.pv_major,
+		     dlm->dlm_locking_proto.pv_minor,
+		     dlm->fs_locking_proto.pv_major,
+		     dlm->fs_locking_proto.pv_minor);
 	} else {
 		status = -EINVAL;
-		mlog(ML_ERROR, "invalid response %d from node %u\n", retval,
-		     node);
+		mlog(ML_ERROR, "invalid response %d from node %u\n",
+		     join_resp.packet.code, node);
 	}
 
 	mlog(0, "status %d, node %d response is %d\n", status, node,
@@ -1008,7 +1104,7 @@ struct domain_join_ctxt {
 
 static int dlm_should_restart_join(struct dlm_ctxt *dlm,
 				   struct domain_join_ctxt *ctxt,
-				   enum dlm_query_join_response response)
+				   enum dlm_query_join_response_code response)
 {
 	int ret;
 
@@ -1034,7 +1130,7 @@ static int dlm_try_to_join_domain(struct dlm_ctxt *dlm)
 {
 	int status = 0, tmpstat, node;
 	struct domain_join_ctxt *ctxt;
-	enum dlm_query_join_response response = JOIN_DISALLOW;
+	enum dlm_query_join_response_code response = JOIN_DISALLOW;
 
 	mlog_entry("%p", dlm);
 
@@ -1450,10 +1546,38 @@ leave:
 }
 
 /*
- * dlm_register_domain: one-time setup per "domain"
+ * Compare a requested locking protocol version against the current one.
+ *
+ * If the major numbers are different, they are incompatible.
+ * If the current minor is greater than the request, they are incompatible.
+ * If the current minor is less than or equal to the request, they are
+ * compatible, and the requester should run at the current minor version.
+ */
+static int dlm_protocol_compare(struct dlm_protocol_version *existing,
+				struct dlm_protocol_version *request)
+{
+	if (existing->pv_major != request->pv_major)
+		return 1;
+
+	if (existing->pv_minor > request->pv_minor)
+		return 1;
+
+	if (existing->pv_minor < request->pv_minor)
+		request->pv_minor = existing->pv_minor;
+
+	return 0;
+}
+
+/*
+ * dlm_register_domain: one-time setup per "domain".
+ *
+ * The filesystem passes in the requested locking version via proto.
+ * If registration was successful, proto will contain the negotiated
+ * locking protocol.
  */
 struct dlm_ctxt * dlm_register_domain(const char *domain,
-			       u32 key)
+			       u32 key,
+			       struct dlm_protocol_version *fs_proto)
 {
 	int ret;
 	struct dlm_ctxt *dlm = NULL;
@@ -1496,6 +1620,15 @@ retry:
 			goto retry;
 		}
 
+		if (dlm_protocol_compare(&dlm->fs_locking_proto, fs_proto)) {
+			mlog(ML_ERROR,
+			     "Requested locking protocol version is not "
+			     "compatible with already registered domain "
+			     "\"%s\"\n", domain);
+			ret = -EPROTO;
+			goto leave;
+		}
+
 		__dlm_get(dlm);
 		dlm->num_joins++;
 
@@ -1526,6 +1659,13 @@ retry:
 	list_add_tail(&dlm->list, &dlm_domains);
 	spin_unlock(&dlm_domain_lock);
 
+	/*
+	 * Pass the locking protocol version into the join.  If the join
+	 * succeeds, it will have the negotiated protocol set.
+	 */
+	dlm->dlm_locking_proto = dlm_protocol;
+	dlm->fs_locking_proto = *fs_proto;
+
 	ret = dlm_join_domain(dlm);
 	if (ret) {
 		mlog_errno(ret);
@@ -1533,6 +1673,9 @@ retry:
 		goto leave;
 	}
 
+	/* Tell the caller what locking protocol we negotiated */
+	*fs_proto = dlm->fs_locking_proto;
+
 	ret = 0;
 leave:
 	if (new_ctxt)
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index f7e0263..c30fff5 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -60,6 +60,8 @@
 #define MLOG_MASK_PREFIX ML_DLMFS
 #include "cluster/masklog.h"
 
+#include "ocfs2_lockingver.h"
+
 #ifdef SOP_IS_NOT_CONST
 static struct super_operations dlmfs_ops;
 #else
@@ -84,6 +86,16 @@ static struct kmem_cache *dlmfs_inode_cache;
 struct workqueue_struct *user_dlm_worker;
 
 /*
+ * This is the userdlmfs locking protocol version.
+ *
+ * See fs/ocfs2/dlmglue.c for more details on locking versions.
+ */
+static const struct dlm_protocol_version user_locking_protocol = {
+	.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
+	.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
+};
+
+/*
  * decodes a set of open flags into a valid lock level and a set of flags.
  * returns < 0 if we have invalid flags
  * flags which mean something to us:
@@ -431,6 +443,7 @@ static int dlmfs_mkdir(struct inode * dir,
 	struct qstr *domain = &dentry->d_name;
 	struct dlmfs_inode_private *ip;
 	struct dlm_ctxt *dlm;
+	struct dlm_protocol_version proto = user_locking_protocol;
 
 	mlog(0, "mkdir %.*s\n", domain->len, domain->name);
 
@@ -450,7 +463,7 @@ static int dlmfs_mkdir(struct inode * dir,
 
 	ip = DLMFS_I(inode);
 
-	dlm = user_dlm_register_context(domain);
+	dlm = user_dlm_register_context(domain, &proto);
 	if (IS_ERR(dlm)) {
 		status = PTR_ERR(dlm);
 		mlog(ML_ERROR, "Error %d could not register domain \"%.*s\"\n",
diff --git a/fs/ocfs2/dlm/userdlm.c b/fs/ocfs2/dlm/userdlm.c
index 6340da3..2181e75 100644
--- a/fs/ocfs2/dlm/userdlm.c
+++ b/fs/ocfs2/dlm/userdlm.c
@@ -645,7 +645,8 @@ bail:
 	return status;
 }
 
-struct dlm_ctxt *user_dlm_register_context(struct qstr *name)
+struct dlm_ctxt *user_dlm_register_context(struct qstr *name,
+					   struct dlm_protocol_version *proto)
 {
 	struct dlm_ctxt *dlm;
 	u32 dlm_key;
@@ -661,7 +662,7 @@ struct dlm_ctxt *user_dlm_register_context(struct qstr *name)
 
 	snprintf(domain, name->len + 1, "%.*s", name->len, name->name);
 
-	dlm = dlm_register_domain(domain, dlm_key);
+	dlm = dlm_register_domain(domain, dlm_key, proto);
 	if (IS_ERR(dlm))
 		mlog_errno(PTR_ERR(dlm));
 
diff --git a/fs/ocfs2/dlm/userdlm.h b/fs/ocfs2/dlm/userdlm.h
index c400e93..39ec277 100644
--- a/fs/ocfs2/dlm/userdlm.h
+++ b/fs/ocfs2/dlm/userdlm.h
@@ -83,7 +83,8 @@ void user_dlm_write_lvb(struct inode *inode,
 void user_dlm_read_lvb(struct inode *inode,
 		       char *val,
 		       unsigned int len);
-struct dlm_ctxt *user_dlm_register_context(struct qstr *name);
+struct dlm_ctxt *user_dlm_register_context(struct qstr *name,
+					   struct dlm_protocol_version *proto);
 void user_dlm_unregister_context(struct dlm_ctxt *dlm);
 
 struct dlmfs_inode_private {
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index df6a8fd..0ff457c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -43,6 +43,7 @@
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
+#include "ocfs2_lockingver.h"
 
 #include "alloc.h"
 #include "dcache.h"
@@ -258,6 +259,31 @@ static struct ocfs2_lock_res_ops ocfs2_flock_lops = {
 	.flags		= 0,
 };
 
+/*
+ * This is the filesystem locking protocol version.
+ *
+ * Whenever the filesystem does new things with locks (adds or removes a
+ * lock, orders them differently, does different things underneath a lock),
+ * the version must be changed.  The protocol is negotiated when joining
+ * the dlm domain.  A node may join the domain if its major version is
+ * identical to all other nodes and its minor version is greater than
+ * or equal to all other nodes.  When its minor version is greater than
+ * the other nodes, it will run at the minor version specified by the
+ * other nodes.
+ *
+ * If a locking change is made that will not be compatible with older
+ * versions, the major number must be increased and the minor version set
+ * to zero.  If a change merely adds a behavior that can be disabled when
+ * speaking to older versions, the minor version must be increased.  If a
+ * change adds a fully backwards compatible change (eg, LVB changes that
+ * are just ignored by older versions), the version does not need to be
+ * updated.
+ */
+const struct dlm_protocol_version ocfs2_locking_protocol = {
+	.pv_major = OCFS2_LOCKING_PROTOCOL_MAJOR,
+	.pv_minor = OCFS2_LOCKING_PROTOCOL_MINOR,
+};
+
 static inline int ocfs2_is_inode_lock(struct ocfs2_lock_res *lockres)
 {
 	return lockres->l_type == OCFS2_LOCK_TYPE_META ||
@@ -2514,7 +2540,8 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 	dlm_key = crc32_le(0, osb->uuid_str, strlen(osb->uuid_str));
 
 	/* for now, uuid == domain */
-	dlm = dlm_register_domain(osb->uuid_str, dlm_key);
+	dlm = dlm_register_domain(osb->uuid_str, dlm_key,
+				  &osb->osb_locking_proto);
 	if (IS_ERR(dlm)) {
 		status = PTR_ERR(dlm);
 		mlog_errno(status);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 5f17243..1d5b069 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -116,4 +116,5 @@ void ocfs2_wake_downconvert_thread(struct ocfs2_super *osb);
 struct ocfs2_dlm_debug *ocfs2_new_dlm_debug(void);
 void ocfs2_put_dlm_debug(struct ocfs2_dlm_debug *dlm_debug);
 
+extern const struct dlm_protocol_version ocfs2_locking_protocol;
 #endif	/* DLMGLUE_H */
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index b9eafc0..e927d55 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -254,6 +254,7 @@ struct ocfs2_super
 	struct ocfs2_lock_res osb_rename_lockres;
 	struct dlm_eviction_cb osb_eviction_cb;
 	struct ocfs2_dlm_debug *osb_dlm_debug;
+	struct dlm_protocol_version osb_locking_proto;
 
 	struct dentry *osb_debug_root;
 
diff --git a/fs/ocfs2/ocfs2_lockingver.h b/fs/ocfs2/ocfs2_lockingver.h
new file mode 100644
index 0000000..82d5eea
--- /dev/null
+++ b/fs/ocfs2/ocfs2_lockingver.h
@@ -0,0 +1,30 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * ocfs2_lockingver.h
+ *
+ * Defines OCFS2 Locking version values.
+ *
+ * Copyright (C) 2008 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License, version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef OCFS2_LOCKINGVER_H
+#define OCFS2_LOCKINGVER_H
+
+/*
+ * The protocol version for ocfs2 cluster locking.  See dlmglue.c for
+ * more details.
+ */
+#define OCFS2_LOCKING_PROTOCOL_MAJOR 1
+#define OCFS2_LOCKING_PROTOCOL_MINOR 0
+
+#endif  /* OCFS2_LOCKINGVER_H */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 29096b0..f41618d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1411,6 +1411,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_fs_info = osb;
 	sb->s_op = &ocfs2_sops;
 	sb->s_export_op = &ocfs2_export_ops;
+	osb->osb_locking_proto = ocfs2_locking_protocol;
 	sb->s_time_gran = 1;
 	sb->s_flags |= MS_NOATIME;
 	/* this is needed to support O_LARGEFILE */
-- 
1.5.3.4

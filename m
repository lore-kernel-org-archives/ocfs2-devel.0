From: Joel Becker <joel.becker@oracle.com>
Date: Fri Feb 15 18:09:00 2008
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix endian bug in o2dlm protocol
	negotiation.
In-Reply-To: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
References: <1203127653-4617-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1203127653-4617-3-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org

struct dlm_query_join_packet is made up of four one-byte fields.  They
are effectively in big-endian order already.  However, little-endian
machines swap them before putting the packet on the wire (because
query_join's response is a status, and that status is treated as a u32
on the wire).  Thus, a big-endian and little-endian machines will
treat this structure differently.

The solution is to have little-endian machines swap the structure when
converting from the structure to the u32 representation.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlm/dlmcommon.h |   20 +++++----
 fs/ocfs2/dlm/dlmdomain.c |   95 +++++++++++++++++++++++++++++++---------------
 2 files changed, 75 insertions(+), 40 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 9843ee1..1f93963 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -602,17 +602,19 @@ enum dlm_query_join_response_code {
 	JOIN_PROTOCOL_MISMATCH,
 };
 
+struct dlm_query_join_packet {
+	u8 code;	/* Response code.  dlm_minor and fs_minor
+			   are only valid if this is JOIN_OK */
+	u8 dlm_minor;	/* The minor version of the protocol the
+			   dlm is speaking. */
+	u8 fs_minor;	/* The minor version of the protocol the
+			   filesystem is speaking. */
+	u8 reserved;
+};
+
 union dlm_query_join_response {
 	u32 intval;
-	struct {
-		u8 code;	/* Response code.  dlm_minor and fs_minor
-				   are only valid if this is JOIN_OK */
-		u8 dlm_minor;	/* The minor version of the protocol the
-				   dlm is speaking. */
-		u8 fs_minor;	/* The minor version of the protocol the
-				   filesystem is speaking. */
-		u8 reserved;
-	} packet;
+	struct dlm_query_join_packet packet;
 };
 
 struct dlm_lock_request
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index de802a7..e77f5d8 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -723,14 +723,46 @@ static int dlm_query_join_proto_check(char *proto_type, int node,
 	return compatible;
 }
 
+/*
+ * struct dlm_query_join_packet is made up of four one-byte fields.  They
+ * are effectively in big-endian order already.  However, little-endian
+ * machines swap them before putting the packet on the wire (because
+ * query_join's response is a status, and that status is treated as a u32
+ * on the wire).  Thus, a big-endian and little-endian machines will treat
+ * this structure differently.
+ *
+ * The solution is to have little-endian machines swap the structure when
+ * converting from the structure to the u32 representation.  This will
+ * result in the structure having the correct format on the wire no matter
+ * the host endian format.
+ */
+static void dlm_query_join_packet_to_wire(struct dlm_query_join_packet *packet,
+					  u32 *wire)
+{
+	union dlm_query_join_response response;
+
+	response.packet = *packet;
+	*wire = cpu_to_be32(response.intval);
+}
+
+static void dlm_query_join_wire_to_packet(u32 wire,
+					  struct dlm_query_join_packet *packet)
+{
+	union dlm_query_join_response response;
+
+	response.intval = cpu_to_be32(wire);
+	*packet = response.packet;
+}
+
 static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				  void **ret_data)
 {
 	struct dlm_query_join_request *query;
-	union dlm_query_join_response response = {
-		.packet.code = JOIN_DISALLOW,
+	struct dlm_query_join_packet packet = {
+		.code = JOIN_DISALLOW,
 	};
 	struct dlm_ctxt *dlm = NULL;
+	u32 response;
 	u8 nodenum;
 
 	query = (struct dlm_query_join_request *) msg->buf;
@@ -747,11 +779,11 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 		mlog(0, "node %u is not in our live map yet\n",
 		     query->node_idx);
 
-		response.packet.code = JOIN_DISALLOW;
+		packet.code = JOIN_DISALLOW;
 		goto respond;
 	}
 
-	response.packet.code = JOIN_OK_NO_MAP;
+	packet.code = JOIN_OK_NO_MAP;
 
 	spin_lock(&dlm_domain_lock);
 	dlm = __dlm_lookup_domain_full(query->domain, query->name_len);
@@ -770,7 +802,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				mlog(0, "disallow join as node %u does not "
 				     "have node %u in its nodemap\n",
 				     query->node_idx, nodenum);
-				response.packet.code = JOIN_DISALLOW;
+				packet.code = JOIN_DISALLOW;
 				goto unlock_respond;
 			}
 		}
@@ -790,23 +822,23 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 			/*If this is a brand new context and we
 			 * haven't started our join process yet, then
 			 * the other node won the race. */
-			response.packet.code = JOIN_OK_NO_MAP;
+			packet.code = JOIN_OK_NO_MAP;
 		} else if (dlm->joining_node != DLM_LOCK_RES_OWNER_UNKNOWN) {
 			/* Disallow parallel joins. */
-			response.packet.code = JOIN_DISALLOW;
+			packet.code = JOIN_DISALLOW;
 		} else if (dlm->reco.state & DLM_RECO_STATE_ACTIVE) {
 			mlog(0, "node %u trying to join, but recovery "
 			     "is ongoing.\n", bit);
-			response.packet.code = JOIN_DISALLOW;
+			packet.code = JOIN_DISALLOW;
 		} else if (test_bit(bit, dlm->recovery_map)) {
 			mlog(0, "node %u trying to join, but it "
 			     "still needs recovery.\n", bit);
-			response.packet.code = JOIN_DISALLOW;
+			packet.code = JOIN_DISALLOW;
 		} else if (test_bit(bit, dlm->domain_map)) {
 			mlog(0, "node %u trying to join, but it "
 			     "is still in the domain! needs recovery?\n",
 			     bit);
-			response.packet.code = JOIN_DISALLOW;
+			packet.code = JOIN_DISALLOW;
 		} else {
 			/* Alright we're fully a part of this domain
 			 * so we keep some state as to who's joining
@@ -824,14 +856,14 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				 * We're compatible, return our
 				 * minor number
 				 */
-				response.packet.dlm_minor =
+				packet.dlm_minor =
 					dlm->dlm_locking_proto.pv_minor;
-				response.packet.fs_minor =
+				packet.fs_minor =
 					dlm->fs_locking_proto.pv_minor;
-				response.packet.code = JOIN_OK;
+				packet.code = JOIN_OK;
 				__dlm_set_joining_node(dlm, query->node_idx);
 			} else {
-				response.packet.code =
+				packet.code =
 					JOIN_PROTOCOL_MISMATCH;
 			}
 		}
@@ -842,9 +874,10 @@ unlock_respond:
 	spin_unlock(&dlm_domain_lock);
 
 respond:
-	mlog(0, "We respond with %u\n", response.packet.code);
+	mlog(0, "We respond with %u\n", packet.code);
 
-	return response.intval;
+	dlm_query_join_packet_to_wire(&packet, &response);
+	return response;
 }
 
 static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
@@ -980,7 +1013,8 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 {
 	int status;
 	struct dlm_query_join_request join_msg;
-	union dlm_query_join_response join_resp;
+	struct dlm_query_join_packet packet;
+	u32 join_resp;
 
 	mlog(0, "querying node %d\n", node);
 
@@ -996,11 +1030,12 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 
 	status = o2net_send_message(DLM_QUERY_JOIN_MSG, DLM_MOD_KEY, &join_msg,
 				    sizeof(join_msg), node,
-				    &join_resp.intval);
+				    &join_resp);
 	if (status < 0 && status != -ENOPROTOOPT) {
 		mlog_errno(status);
 		goto bail;
 	}
+	dlm_query_join_wire_to_packet(join_resp, &packet);
 
 	/* -ENOPROTOOPT from the net code means the other side isn't
 	    listening for our message type -- that's fine, it means
@@ -1009,10 +1044,10 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 	if (status == -ENOPROTOOPT) {
 		status = 0;
 		*response = JOIN_OK_NO_MAP;
-	} else if (join_resp.packet.code == JOIN_DISALLOW ||
-		   join_resp.packet.code == JOIN_OK_NO_MAP) {
-		*response = join_resp.packet.code;
-	} else if (join_resp.packet.code == JOIN_PROTOCOL_MISMATCH) {
+	} else if (packet.code == JOIN_DISALLOW ||
+		   packet.code == JOIN_OK_NO_MAP) {
+		*response = packet.code;
+	} else if (packet.code == JOIN_PROTOCOL_MISMATCH) {
 		mlog(ML_NOTICE,
 		     "This node requested DLM locking protocol %u.%u and "
 		     "filesystem locking protocol %u.%u.  At least one of "
@@ -1024,14 +1059,12 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 		     dlm->fs_locking_proto.pv_minor,
 		     node);
 		status = -EPROTO;
-		*response = join_resp.packet.code;
-	} else if (join_resp.packet.code == JOIN_OK) {
-		*response = join_resp.packet.code;
+		*response = packet.code;
+	} else if (packet.code == JOIN_OK) {
+		*response = packet.code;
 		/* Use the same locking protocol as the remote node */
-		dlm->dlm_locking_proto.pv_minor =
-			join_resp.packet.dlm_minor;
-		dlm->fs_locking_proto.pv_minor =
-			join_resp.packet.fs_minor;
+		dlm->dlm_locking_proto.pv_minor = packet.dlm_minor;
+		dlm->fs_locking_proto.pv_minor = packet.fs_minor;
 		mlog(0,
 		     "Node %d responds JOIN_OK with DLM locking protocol "
 		     "%u.%u and fs locking protocol %u.%u\n",
@@ -1043,11 +1076,11 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 	} else {
 		status = -EINVAL;
 		mlog(ML_ERROR, "invalid response %d from node %u\n",
-		     join_resp.packet.code, node);
+		     packet.code, node);
 	}
 
 	mlog(0, "status %d, node %d response is %d\n", status, node,
-		  *response);
+	     *response);
 
 bail:
 	return status;
-- 
1.5.3.8

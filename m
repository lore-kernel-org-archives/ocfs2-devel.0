From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 10 15:46:07 2008
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20080310224452.GF27669@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Hi Linus,

Here's a set of Ocfs2 fixes for post-rc5.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/cluster/tcp.c     |    9 ++--
 fs/ocfs2/dlm/dlmcommon.h   |   21 +++++----
 fs/ocfs2/dlm/dlmconvert.c  |    2 +-
 fs/ocfs2/dlm/dlmdomain.c   |  103 ++++++++++++++++++++++++++++----------------
 fs/ocfs2/dlm/dlmmaster.c   |   18 ++++++-
 fs/ocfs2/dlm/dlmrecovery.c |   57 ++++++++++++++++++++----
 fs/ocfs2/dlm/dlmthread.c   |    6 ++-
 fs/ocfs2/dlmglue.c         |    2 +-
 fs/ocfs2/resize.c          |    2 +-
 9 files changed, 151 insertions(+), 69 deletions(-)

Andrew Morton (1):
      fs/ocfs2/dlm/dlmdomain.c: fix printk warning

Jan Engelhardt (1):
      [OCFS2]: constify function pointer tables

Joel Becker (1):
      ocfs2: Fix endian bug in o2dlm protocol negotiation.

Sunil Mushran (5):
      ocfs2/dlm: Add missing dlm_lock_put()s
      ocfs2/dlm: Add missing dlm_lockres_put()s in migration path
      ocfs2/dlm: Add missing dlm_lockres_put()s
      ocfs2/dlm: Print message showing the recovery master
      ocfs2/dlm: dlm_thread should not sleep while holding the dlm_spinlock

Tao Ma (3):
      ocfs2: Use dlm_print_one_lock_resource for lock resource print
      ocfs2: Fix an endian bug in online resize.
      ocfs2: Fix NULL pointer dereferences in o2net

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index ee50c96..b8057c5 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -451,9 +451,9 @@ static void o2net_set_nn_state(struct o2net_node *nn,
 		/* delay if we're withing a RECONNECT_DELAY of the
 		 * last attempt */
 		delay = (nn->nn_last_connect_attempt +
-			 msecs_to_jiffies(o2net_reconnect_delay(sc->sc_node)))
+			 msecs_to_jiffies(o2net_reconnect_delay(NULL)))
 			- jiffies;
-		if (delay > msecs_to_jiffies(o2net_reconnect_delay(sc->sc_node)))
+		if (delay > msecs_to_jiffies(o2net_reconnect_delay(NULL)))
 			delay = 0;
 		mlog(ML_CONN, "queueing conn attempt in %lu jiffies\n", delay);
 		queue_delayed_work(o2net_wq, &nn->nn_connect_work, delay);
@@ -1552,12 +1552,11 @@ static void o2net_connect_expired(struct work_struct *work)
 
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
-		struct o2nm_node *node = nn->nn_sc->sc_node;
 		mlog(ML_ERROR, "no connection established with node %u after "
 		     "%u.%u seconds, giving up and returning errors.\n",
 		     o2net_num_from_nn(nn),
-		     o2net_idle_timeout(node) / 1000,
-		     o2net_idle_timeout(node) % 1000);
+		     o2net_idle_timeout(NULL) / 1000,
+		     o2net_idle_timeout(NULL) % 1000);
 
 		o2net_set_nn_state(nn, NULL, 0, -ENOTCONN);
 	}
diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
index 9843ee1..dc8ea66 100644
--- a/fs/ocfs2/dlm/dlmcommon.h
+++ b/fs/ocfs2/dlm/dlmcommon.h
@@ -176,6 +176,7 @@ struct dlm_mig_lockres_priv
 {
 	struct dlm_lock_resource *lockres;
 	u8 real_master;
+	u8 extra_ref;
 };
 
 struct dlm_assert_master_priv
@@ -602,17 +603,19 @@ enum dlm_query_join_response_code {
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
diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index ecb4d99..75997b4 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -487,7 +487,7 @@ int dlm_convert_lock_handler(struct o2net_msg *msg, u32 len, void *data,
 			       "cookie=%u:%llu\n",
 		     dlm_get_lock_cookie_node(be64_to_cpu(cnv->cookie)),
 		     dlm_get_lock_cookie_seq(be64_to_cpu(cnv->cookie)));
-		__dlm_print_one_lock_resource(res);
+		dlm_print_one_lock_resource(res);
 		goto leave;
 	}
 
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 638d2eb..0879d86 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -713,14 +713,46 @@ static int dlm_query_join_proto_check(char *proto_type, int node,
 	return rc;
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
@@ -737,11 +769,11 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
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
@@ -760,7 +792,7 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 				mlog(0, "disallow join as node %u does not "
 				     "have node %u in its nodemap\n",
 				     query->node_idx, nodenum);
-				response.packet.code = JOIN_DISALLOW;
+				packet.code = JOIN_DISALLOW;
 				goto unlock_respond;
 			}
 		}
@@ -780,23 +812,23 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
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
@@ -807,19 +839,15 @@ static int dlm_query_join_handler(struct o2net_msg *msg, u32 len, void *data,
 			if (dlm_query_join_proto_check("DLM", bit,
 						       &dlm->dlm_locking_proto,
 						       &query->dlm_proto)) {
-				response.packet.code =
-					JOIN_PROTOCOL_MISMATCH;
+				packet.code = JOIN_PROTOCOL_MISMATCH;
 			} else if (dlm_query_join_proto_check("fs", bit,
 							      &dlm->fs_locking_proto,
 							      &query->fs_proto)) {
-				response.packet.code =
-					JOIN_PROTOCOL_MISMATCH;
+				packet.code = JOIN_PROTOCOL_MISMATCH;
 			} else {
-				response.packet.dlm_minor =
-					query->dlm_proto.pv_minor;
-				response.packet.fs_minor =
-					query->fs_proto.pv_minor;
-				response.packet.code = JOIN_OK;
+				packet.dlm_minor = query->dlm_proto.pv_minor;
+				packet.fs_minor = query->fs_proto.pv_minor;
+				packet.code = JOIN_OK;
 				__dlm_set_joining_node(dlm, query->node_idx);
 			}
 		}
@@ -830,9 +858,10 @@ unlock_respond:
 	spin_unlock(&dlm_domain_lock);
 
 respond:
-	mlog(0, "We respond with %u\n", response.packet.code);
+	mlog(0, "We respond with %u\n", packet.code);
 
-	return response.intval;
+	dlm_query_join_packet_to_wire(&packet, &response);
+	return response;
 }
 
 static int dlm_assert_joined_handler(struct o2net_msg *msg, u32 len, void *data,
@@ -937,7 +966,7 @@ static int dlm_send_join_cancels(struct dlm_ctxt *dlm,
 			 sizeof(unsigned long))) {
 		mlog(ML_ERROR,
 		     "map_size %u != BITS_TO_LONGS(O2NM_MAX_NODES) %u\n",
-		     map_size, BITS_TO_LONGS(O2NM_MAX_NODES));
+		     map_size, (unsigned)BITS_TO_LONGS(O2NM_MAX_NODES));
 		return -EINVAL;
 	}
 
@@ -968,7 +997,8 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 {
 	int status;
 	struct dlm_query_join_request join_msg;
-	union dlm_query_join_response join_resp;
+	struct dlm_query_join_packet packet;
+	u32 join_resp;
 
 	mlog(0, "querying node %d\n", node);
 
@@ -984,11 +1014,12 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
 
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
@@ -997,10 +1028,10 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
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
@@ -1012,14 +1043,12 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
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
@@ -1031,11 +1060,11 @@ static int dlm_request_join(struct dlm_ctxt *dlm,
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
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index c92d1b1..ea6b895 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1663,7 +1663,12 @@ way_up_top:
 		dlm_put_mle(tmpmle);
 	}
 send_response:
-
+	/*
+	 * __dlm_lookup_lockres() grabbed a reference to this lockres.
+	 * The reference is released by dlm_assert_master_worker() under
+	 * the call to dlm_dispatch_assert_master().  If
+	 * dlm_assert_master_worker() isn't called, we drop it here.
+	 */
 	if (dispatch_assert) {
 		if (response != DLM_MASTER_RESP_YES)
 			mlog(ML_ERROR, "invalid response %d\n", response);
@@ -1678,7 +1683,11 @@ send_response:
 		if (ret < 0) {
 			mlog(ML_ERROR, "failed to dispatch assert master work\n");
 			response = DLM_MASTER_RESP_ERROR;
+			dlm_lockres_put(res);
 		}
+	} else {
+		if (res)
+			dlm_lockres_put(res);
 	}
 
 	dlm_put(dlm);
@@ -2348,7 +2357,7 @@ int dlm_deref_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 			mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
 		     	"but it is already dropped!\n", dlm->name,
 		     	res->lockname.len, res->lockname.name, node);
-			__dlm_print_one_lock_resource(res);
+			dlm_print_one_lock_resource(res);
 		}
 		ret = 0;
 		goto done;
@@ -2408,7 +2417,7 @@ static void dlm_deref_lockres_worker(struct dlm_work_item *item, void *data)
 		mlog(ML_ERROR, "%s:%.*s: node %u trying to drop ref "
 		     "but it is already dropped!\n", dlm->name,
 		     res->lockname.len, res->lockname.name, node);
-		__dlm_print_one_lock_resource(res);
+		dlm_print_one_lock_resource(res);
 	}
 
 	dlm_lockres_put(res);
@@ -2933,6 +2942,9 @@ static void dlm_remove_nonlocal_locks(struct dlm_ctxt *dlm,
 				dlm_lockres_clear_refmap_bit(lock->ml.node, res);
 				list_del_init(&lock->list);
 				dlm_lock_put(lock);
+				/* In a normal unlock, we would have added a
+				 * DLM_UNLOCK_FREE_LOCK action. Force it. */
+				dlm_lock_put(lock);
 			}
 		}
 		queue++;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 91f747b..bcb9260 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -519,9 +519,9 @@ static int dlm_do_recovery(struct dlm_ctxt *dlm)
 	return 0;
 
 master_here:
-	mlog(0, "(%d) mastering recovery of %s:%u here(this=%u)!\n",
-	     task_pid_nr(dlm->dlm_reco_thread_task),
-	     dlm->name, dlm->reco.dead_node, dlm->node_num);
+	mlog(ML_NOTICE, "(%d) Node %u is the Recovery Master for the Dead Node "
+	     "%u for Domain %s\n", task_pid_nr(dlm->dlm_reco_thread_task),
+	     dlm->node_num, dlm->reco.dead_node, dlm->name);
 
 	status = dlm_remaster_locks(dlm, dlm->reco.dead_node);
 	if (status < 0) {
@@ -1191,7 +1191,7 @@ static int dlm_add_lock_to_array(struct dlm_lock *lock,
 			    (ml->type == LKM_EXMODE ||
 			     memcmp(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN))) {
 				mlog(ML_ERROR, "mismatched lvbs!\n");
-				__dlm_print_one_lock_resource(lock->lockres);
+				dlm_print_one_lock_resource(lock->lockres);
 				BUG();
 			}
 			memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
@@ -1327,6 +1327,7 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 		(struct dlm_migratable_lockres *)msg->buf;
 	int ret = 0;
 	u8 real_master;
+	u8 extra_refs = 0;
 	char *buf = NULL;
 	struct dlm_work_item *item = NULL;
 	struct dlm_lock_resource *res = NULL;
@@ -1404,16 +1405,28 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 		__dlm_insert_lockres(dlm, res);
 		spin_unlock(&dlm->spinlock);
 
+		/* Add an extra ref for this lock-less lockres lest the
+		 * dlm_thread purges it before we get the chance to add
+		 * locks to it */
+		dlm_lockres_get(res);
+
+		/* There are three refs that need to be put.
+		 * 1. Taken above.
+		 * 2. kref_init in dlm_new_lockres()->dlm_init_lockres().
+		 * 3. dlm_lookup_lockres()
+		 * The first one is handled at the end of this function. The
+		 * other two are handled in the worker thread after locks have
+		 * been attached. Yes, we don't wait for purge time to match
+		 * kref_init. The lockres will still have atleast one ref
+		 * added because it is in the hash __dlm_insert_lockres() */
+		extra_refs++;
+
 		/* now that the new lockres is inserted,
 		 * make it usable by other processes */
 		spin_lock(&res->spinlock);
 		res->state &= ~DLM_LOCK_RES_IN_PROGRESS;
 		spin_unlock(&res->spinlock);
 		wake_up(&res->wq);
-
-		/* add an extra ref for just-allocated lockres 
-		 * otherwise the lockres will be purged immediately */
-		dlm_lockres_get(res);
 	}
 
 	/* at this point we have allocated everything we need,
@@ -1443,12 +1456,17 @@ int dlm_mig_lockres_handler(struct o2net_msg *msg, u32 len, void *data,
 	dlm_init_work_item(dlm, item, dlm_mig_lockres_worker, buf);
 	item->u.ml.lockres = res; /* already have a ref */
 	item->u.ml.real_master = real_master;
+	item->u.ml.extra_ref = extra_refs;
 	spin_lock(&dlm->work_lock);
 	list_add_tail(&item->list, &dlm->work_list);
 	spin_unlock(&dlm->work_lock);
 	queue_work(dlm->dlm_worker, &dlm->dispatched_work);
 
 leave:
+	/* One extra ref taken needs to be put here */
+	if (extra_refs)
+		dlm_lockres_put(res);
+
 	dlm_put(dlm);
 	if (ret < 0) {
 		if (buf)
@@ -1464,17 +1482,19 @@ leave:
 
 static void dlm_mig_lockres_worker(struct dlm_work_item *item, void *data)
 {
-	struct dlm_ctxt *dlm = data;
+	struct dlm_ctxt *dlm;
 	struct dlm_migratable_lockres *mres;
 	int ret = 0;
 	struct dlm_lock_resource *res;
 	u8 real_master;
+	u8 extra_ref;
 
 	dlm = item->dlm;
 	mres = (struct dlm_migratable_lockres *)data;
 
 	res = item->u.ml.lockres;
 	real_master = item->u.ml.real_master;
+	extra_ref = item->u.ml.extra_ref;
 
 	if (real_master == DLM_LOCK_RES_OWNER_UNKNOWN) {
 		/* this case is super-rare. only occurs if
@@ -1517,6 +1537,12 @@ again:
 	}
 
 leave:
+	/* See comment in dlm_mig_lockres_handler() */
+	if (res) {
+		if (extra_ref)
+			dlm_lockres_put(res);
+		dlm_lockres_put(res);
+	}
 	kfree(data);
 	mlog_exit(ret);
 }
@@ -1644,7 +1670,8 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
 				/* retry!? */
 				BUG();
 			}
-		}
+		} else /* put.. incase we are not the master */
+			dlm_lockres_put(res);
 		spin_unlock(&res->spinlock);
 	}
 	spin_unlock(&dlm->spinlock);
@@ -1921,6 +1948,7 @@ void dlm_move_lockres_to_recovery_list(struct dlm_ctxt *dlm,
 		     "Recovering res %s:%.*s, is already on recovery list!\n",
 		     dlm->name, res->lockname.len, res->lockname.name);
 		list_del_init(&res->recovering);
+		dlm_lockres_put(res);
 	}
 	/* We need to hold a reference while on the recovery list */
 	dlm_lockres_get(res);
@@ -2130,11 +2158,16 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 	assert_spin_locked(&dlm->spinlock);
 	assert_spin_locked(&res->spinlock);
 
+	/* We do two dlm_lock_put(). One for removing from list and the other is
+	 * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */
+
 	/* TODO: check pending_asts, pending_basts here */
 	list_for_each_entry_safe(lock, next, &res->granted, list) {
 		if (lock->ml.node == dead_node) {
 			list_del_init(&lock->list);
 			dlm_lock_put(lock);
+			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
+			dlm_lock_put(lock);
 			freed++;
 		}
 	}
@@ -2142,6 +2175,8 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 		if (lock->ml.node == dead_node) {
 			list_del_init(&lock->list);
 			dlm_lock_put(lock);
+			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
+			dlm_lock_put(lock);
 			freed++;
 		}
 	}
@@ -2149,6 +2184,8 @@ static void dlm_free_dead_locks(struct dlm_ctxt *dlm,
 		if (lock->ml.node == dead_node) {
 			list_del_init(&lock->list);
 			dlm_lock_put(lock);
+			/* Can't schedule DLM_UNLOCK_FREE_LOCK - do manually */
+			dlm_lock_put(lock);
 			freed++;
 		}
 	}
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index cebd089..4060bb3 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -176,12 +176,14 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 	     res->lockname.name, master);
 
 	if (!master) {
+		/* drop spinlock...  retake below */
+		spin_unlock(&dlm->spinlock);
+
 		spin_lock(&res->spinlock);
 		/* This ensures that clear refmap is sent after the set */
 		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
 		spin_unlock(&res->spinlock);
-		/* drop spinlock to do messaging, retake below */
-		spin_unlock(&dlm->spinlock);
+
 		/* clear our bit from the master's refmap, ignore errors */
 		ret = dlm_drop_lockres_ref(dlm, res);
 		if (ret < 0) {
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index f779430..1f1873b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2409,7 +2409,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct seq_operations ocfs2_dlm_seq_ops = {
+static const struct seq_operations ocfs2_dlm_seq_ops = {
 	.start =	ocfs2_dlm_seq_start,
 	.stop =		ocfs2_dlm_seq_stop,
 	.next =		ocfs2_dlm_seq_next,
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 37835ff..8166968 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -597,7 +597,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		memset(cr, 0, sizeof(struct ocfs2_chain_rec));
 	}
 
-	cr->c_blkno = le64_to_cpu(input->group);
+	cr->c_blkno = cpu_to_le64(input->group);
 	le32_add_cpu(&cr->c_total, input->clusters * cl_bpc);
 	le32_add_cpu(&cr->c_free, input->frees * cl_bpc);
 

From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 21 Aug 2015 14:41:22 -0700
Subject: [Ocfs2-devel] [patch 12/24] ocfs2: optimize error handling in
	dlm_request_join
Message-ID: <55d79b02.a0EXPwJNL5DPTSce%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: "Norton.Zhu" <norton.zhu@huawei.com>
Subject: ocfs2: optimize error handling in dlm_request_join

Currently error handling in dlm_request_join is a little obscure, so
optimize it to promote readability.

If packet.code is invalid, reset it to JOIN_DISALLOW to keep it meaningful. 
It only influences the log printing.

Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   71 ++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-optimize-error-handling-in-dlm_request_join fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-optimize-error-handling-in-dlm_request_join
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1465,39 +1465,46 @@ static int dlm_request_join(struct dlm_c
 	if (status == -ENOPROTOOPT) {
 		status = 0;
 		*response = JOIN_OK_NO_MAP;
-	} else if (packet.code == JOIN_DISALLOW ||
-		   packet.code == JOIN_OK_NO_MAP) {
-		*response = packet.code;
-	} else if (packet.code == JOIN_PROTOCOL_MISMATCH) {
-		mlog(ML_NOTICE,
-		     "This node requested DLM locking protocol %u.%u and "
-		     "filesystem locking protocol %u.%u.  At least one of "
-		     "the protocol versions on node %d is not compatible, "
-		     "disconnecting\n",
-		     dlm->dlm_locking_proto.pv_major,
-		     dlm->dlm_locking_proto.pv_minor,
-		     dlm->fs_locking_proto.pv_major,
-		     dlm->fs_locking_proto.pv_minor,
-		     node);
-		status = -EPROTO;
-		*response = packet.code;
-	} else if (packet.code == JOIN_OK) {
-		*response = packet.code;
-		/* Use the same locking protocol as the remote node */
-		dlm->dlm_locking_proto.pv_minor = packet.dlm_minor;
-		dlm->fs_locking_proto.pv_minor = packet.fs_minor;
-		mlog(0,
-		     "Node %d responds JOIN_OK with DLM locking protocol "
-		     "%u.%u and fs locking protocol %u.%u\n",
-		     node,
-		     dlm->dlm_locking_proto.pv_major,
-		     dlm->dlm_locking_proto.pv_minor,
-		     dlm->fs_locking_proto.pv_major,
-		     dlm->fs_locking_proto.pv_minor);
 	} else {
-		status = -EINVAL;
-		mlog(ML_ERROR, "invalid response %d from node %u\n",
-		     packet.code, node);
+		*response = packet.code;
+		switch (packet.code) {
+		case JOIN_DISALLOW:
+		case JOIN_OK_NO_MAP:
+			break;
+		case JOIN_PROTOCOL_MISMATCH:
+			mlog(ML_NOTICE,
+			     "This node requested DLM locking protocol %u.%u and "
+			     "filesystem locking protocol %u.%u.  At least one of "
+			     "the protocol versions on node %d is not compatible, "
+			     "disconnecting\n",
+			     dlm->dlm_locking_proto.pv_major,
+			     dlm->dlm_locking_proto.pv_minor,
+			     dlm->fs_locking_proto.pv_major,
+			     dlm->fs_locking_proto.pv_minor,
+			     node);
+			status = -EPROTO;
+			break;
+		case JOIN_OK:
+			/* Use the same locking protocol as the remote node */
+			dlm->dlm_locking_proto.pv_minor = packet.dlm_minor;
+			dlm->fs_locking_proto.pv_minor = packet.fs_minor;
+			mlog(0,
+			     "Node %d responds JOIN_OK with DLM locking protocol "
+			     "%u.%u and fs locking protocol %u.%u\n",
+			     node,
+			     dlm->dlm_locking_proto.pv_major,
+			     dlm->dlm_locking_proto.pv_minor,
+			     dlm->fs_locking_proto.pv_major,
+			     dlm->fs_locking_proto.pv_minor);
+			break;
+		default:
+			status = -EINVAL;
+			mlog(ML_ERROR, "invalid response %d from node %u\n",
+			     packet.code, node);
+			/* Reset response to JOIN_DISALLOW */
+			*response = JOIN_DISALLOW;
+			break;
+		}
 	}
 
 	mlog(0, "status %d, node %d response is %d\n", status, node,
_

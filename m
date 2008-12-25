From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:40 -0800
Subject: [Ocfs2-devel] [PATCH 25/35] ocfs2/dlm: Fix a race between migrate
	request and exit domain
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-26-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Sunil Mushran <sunil.mushran@oracle.com>

Patch address a racing migrate request message and an exit domain message.
Instead of blocking exit domains for the duration of the migrate, we ignore
failure to deliver that message. This is because an exiting domain should
not have any active locks and thus has no role to play in the migration.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 44f87ca..92fd1d7 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2949,7 +2949,7 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
 				  struct dlm_node_iter *iter)
 {
 	struct dlm_migrate_request migrate;
-	int ret, status = 0;
+	int ret, skip, status = 0;
 	int nodenum;
 
 	memset(&migrate, 0, sizeof(migrate));
@@ -2966,12 +2966,27 @@ static int dlm_do_migrate_request(struct dlm_ctxt *dlm,
 		    nodenum == new_master)
 			continue;
 
+		/* We could race exit domain. If exited, skip. */
+		spin_lock(&dlm->spinlock);
+		skip = (!test_bit(nodenum, dlm->domain_map));
+		spin_unlock(&dlm->spinlock);
+		if (skip) {
+			clear_bit(nodenum, iter->node_map);
+			continue;
+		}
+
 		ret = o2net_send_message(DLM_MIGRATE_REQUEST_MSG, dlm->key,
 					 &migrate, sizeof(migrate), nodenum,
 					 &status);
-		if (ret < 0)
-			mlog_errno(ret);
-		else if (status < 0) {
+		if (ret < 0) {
+			mlog(0, "migrate_request returned %d!\n", ret);
+			if (!dlm_is_host_down(ret)) {
+				mlog(ML_ERROR, "unhandled error=%d!\n", ret);
+				BUG();
+			}
+			clear_bit(nodenum, iter->node_map);
+			ret = 0;
+		} else if (status < 0) {
 			mlog(0, "migrate request (node %u) returned %d!\n",
 			     nodenum, status);
 			ret = status;
-- 
1.5.6

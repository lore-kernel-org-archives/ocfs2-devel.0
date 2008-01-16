From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan 16 11:33:21 2008
Subject: [Ocfs2-devel] [PATCH 09/20] ocfs2: Add missing "space"
In-Reply-To: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
References: <1200511977-19513-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1200511977-19513-10-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 2759236f8415ccc0f275b57bd8142c2c81fd2177
Author: Joe Perches <joe@perches.com>
Date: Mon, 19 Nov 2007 17:53:34 -0800

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++--
 fs/ocfs2/inode.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index c8e5d84..42ea5af 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -907,7 +907,7 @@ lookup:
 		 * but they might own this lockres.  wait on them. */
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to"
+			mlog(ML_NOTICE, "%s:%.*s:@least one node (%d) to "
 			     "recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
@@ -961,7 +961,7 @@ redo_request:
 		spin_lock(&dlm->spinlock);
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to"
+			mlog(ML_NOTICE, "%s:%.*s:@least one node (%d) to "
 			     "recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 1d5e0cb..9e3e7df 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -863,7 +863,7 @@ static int ocfs2_query_inode_wipe(struct inode *inode,
 	status = ocfs2_try_open_lock(inode, 1);
 	if (status == -EAGAIN) {
 		status = 0;
-		mlog(0, "Skipping delete of %llu because it is in use on"
+		mlog(0, "Skipping delete of %llu because it is in use on "
 		     "other nodes\n", (unsigned long long)oi->ip_blkno);
 		goto bail;
 	}
-- 
1.5.3.4

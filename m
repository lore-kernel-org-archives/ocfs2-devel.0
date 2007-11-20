From: Joe Perches <joe@perches.com>
Date: Tue, 20 Nov 2007 01:54:12 -0000
Subject: [Ocfs2-devel] [PATCH 47/59] fs/ocfs2: Add missing "space"
In-Reply-To: <1195523627-15389-4-git-send-email-joe@perches.com>
References: 1234567 <1195523627-15389-1-git-send-email-joe@perches.com>
	<1195523627-15389-2-git-send-email-joe@perches.com>
	<1195523627-15389-3-git-send-email-joe@perches.com>
	<1195523627-15389-4-git-send-email-joe@perches.com>
Message-ID: <1195523627-15389-5-git-send-email-joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 ++--
 fs/ocfs2/inode.c         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 62e4a7d..a54d33d 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -908,7 +908,7 @@ lookup:
 		 * but they might own this lockres.  wait on them. */
 		bit = find_next_bit(dlm->recovery_map, O2NM_MAX_NODES, 0);
 		if (bit < O2NM_MAX_NODES) {
-			mlog(ML_NOTICE, "%s:%.*s: at least one node (%d) to"
+			mlog(ML_NOTICE, "%s:%.*s:@least one node (%d) to "
 			     "recover before lock mastery can begin\n",
 			     dlm->name, namelen, (char *)lockid, bit);
 			wait_on_recovery = 1;
@@ -962,7 +962,7 @@ redo_request:
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
1.5.3.5.652.gf192c

From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 1 Sep 2015 14:54:08 +0800
Subject: [Ocfs2-devel] ocfs2: clean up redundant NULL checks before kfree
Message-ID: <55E54B90.40601@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NULL check before kfree is redundant and so clean them up.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/alloc.c    | 2 +-
 fs/ocfs2/suballoc.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 5997c00..73f6684 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6175,7 +6175,7 @@ bail:
 		iput(tl_inode);
 	brelse(tl_bh);

-	if (status < 0 && (*tl_copy)) {
+	if (status < 0) {
 		kfree(*tl_copy);
 		*tl_copy = NULL;
 		mlog_errno(status);
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 4479029..68a6a80 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -149,10 +149,8 @@ void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 	brelse(ac->ac_bh);
 	ac->ac_bh = NULL;
 	ac->ac_resv = NULL;
-	if (ac->ac_find_loc_priv) {
-		kfree(ac->ac_find_loc_priv);
-		ac->ac_find_loc_priv = NULL;
-	}
+	kfree(ac->ac_find_loc_priv);
+	ac->ac_find_loc_priv = NULL;
 }

 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac)
-- 
1.8.4.3

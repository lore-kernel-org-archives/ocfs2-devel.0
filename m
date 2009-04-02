From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:46:02 +0800
Subject: [Ocfs2-devel] [PATCH 23/42] ocfs2: Abstract caching info checkpoint.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-23-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In meta downconvert, we need to checkpoint the metadata in an inode.
For refcount tree, we also need it. So abstract the process out.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dlmglue.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index fe76476..68cb674 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3342,11 +3342,11 @@ out:
 	return UNBLOCK_CONTINUE;
 }
 
-static int ocfs2_check_meta_downconvert(struct ocfs2_lock_res *lockres,
-					int new_level)
+static int ocfs2_ci_checkpointed(struct ocfs2_caching_info *ci,
+				 struct ocfs2_lock_res *lockres,
+				 int new_level)
 {
-	struct inode *inode = ocfs2_lock_res_inode(lockres);
-	int checkpointed = ocfs2_ci_fully_checkpointed(INODE_CACHE(inode));
+	int checkpointed = ocfs2_ci_fully_checkpointed(ci);
 
 	BUG_ON(new_level != DLM_LOCK_NL && new_level != DLM_LOCK_PR);
 	BUG_ON(lockres->l_level != DLM_LOCK_EX && !checkpointed);
@@ -3354,10 +3354,18 @@ static int ocfs2_check_meta_downconvert(struct ocfs2_lock_res *lockres,
 	if (checkpointed)
 		return 1;
 
-	ocfs2_start_checkpoint(OCFS2_SB(inode->i_sb));
+	ocfs2_start_checkpoint(OCFS2_SB(ocfs2_metadata_cache_get_super(ci)));
 	return 0;
 }
 
+static int ocfs2_check_meta_downconvert(struct ocfs2_lock_res *lockres,
+					int new_level)
+{
+	struct inode *inode = ocfs2_lock_res_inode(lockres);
+
+	return ocfs2_ci_checkpointed(INODE_CACHE(inode), lockres, new_level);
+}
+
 static void ocfs2_set_meta_lvb(struct ocfs2_lock_res *lockres)
 {
 	struct inode *inode = ocfs2_lock_res_inode(lockres);
-- 
1.6.2.rc2.16.gf474c

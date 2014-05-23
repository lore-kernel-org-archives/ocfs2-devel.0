From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 23 May 2014 18:12:07 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: cleanup unused paramters in
	ocfs2_calc_new_backup_super
Message-ID: <537F1EF7.309@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Parameters new_clusters and first_new_cluster are not used in
ocfs2_update_last_group_and_inode, so remove them.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/resize.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 4261c74..d5da6f6 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -53,8 +53,6 @@
  */
 static u16 ocfs2_calc_new_backup_super(struct inode *inode,
 				       struct ocfs2_group_desc *gd,
-				       int new_clusters,
-				       u32 first_new_cluster,
 				       u16 cl_cpg,
 				       int set)
 {
@@ -127,8 +125,6 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 				     OCFS2_FEATURE_COMPAT_BACKUP_SB)) {
 		backups = ocfs2_calc_new_backup_super(bm_inode,
 						     group,
-						     new_clusters,
-						     first_new_cluster,
 						     cl_cpg, 1);
 		le16_add_cpu(&group->bg_free_bits_count, -1 * backups);
 	}
@@ -167,8 +163,6 @@ out_rollback:
 	if (ret < 0) {
 		ocfs2_calc_new_backup_super(bm_inode,
 					    group,
-					    new_clusters,
-					    first_new_cluster,
 					    cl_cpg, 0);
 		le16_add_cpu(&group->bg_free_bits_count, backups);
 		le16_add_cpu(&group->bg_bits, -1 * num_bits);
-- 
1.8.4.3

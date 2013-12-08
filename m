From: Jeff Liu <jeff.liu@oracle.com>
Date: Sun, 08 Dec 2013 19:35:05 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Return EINVAL if the given range
 to discard is less than block size
Message-ID: <52A45969.10209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

For FITRIM ioctl(2), we should not keep silence if the given range
length ls less than a block size as there is no data blocks would
be discareded.  Hence it should return EINVAL instead.  This issue
can be verified via xfstests/generic/288 which is used for FITRIM
argument handling tests.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/alloc.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index dc7411f..8750ae1 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7260,14 +7260,8 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	start = range->start >> osb->s_clustersize_bits;
 	len = range->len >> osb->s_clustersize_bits;
 	minlen = range->minlen >> osb->s_clustersize_bits;
-	trimmed = 0;
-
-	if (!len) {
-		range->len = 0;
-		return 0;
-	}
 
-	if (minlen >= osb->bitmap_cpg)
+	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
 		return -EINVAL;
 
 	main_bm_inode = ocfs2_get_system_file_inode(osb,
@@ -7293,6 +7287,7 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
 		goto out_unlock;
 	}
 
+	len = range->len >> osb->s_clustersize_bits;
 	if (start + len > le32_to_cpu(main_bm->i_clusters))
 		len = le32_to_cpu(main_bm->i_clusters) - start;
 
@@ -7307,6 +7302,7 @@ int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	last_group = ocfs2_which_cluster_group(main_bm_inode, start + len - 1);
 	last_bit = osb->bitmap_cpg;
 
+	trimmed = 0;
 	for (group = first_group; group <= last_group;) {
 		if (first_bit + len >= osb->bitmap_cpg)
 			last_bit = osb->bitmap_cpg;
-- 
1.8.3.2

From: Tao Ma <tm@tao.ma>
Date: Tue,  8 Mar 2011 23:26:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/3 v2] ocfs2: Add ocfs2_trim_fs for SSD trim
	support.
In-Reply-To: <4D74AD52.4030502@tao.ma>
References: <4D74AD52.4030502@tao.ma>
Message-ID: <1299597974-11971-1-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Changelog from v1 to v2:
1. remove the check for hard ro and soft ro.
2. fix bug found by tristan.
3. if range->len = 0 return 0 instead of -EINVAL.
4. allow minlen = 0 to go ahead instead of returning -EINVAL.

Regards,
Tao


From 9074413a619f1af32c03c5959d66ff465643496c Mon Sep 17 00:00:00 2001
From: Tao Ma <boyu.mt@taobao.com>
Date: Wed, 9 Mar 2011 07:12:10 +0800
Subject: [PATCH 1/3 v2] ocfs2: Add ocfs2_trim_fs for SSD trim support.

Add ocfs2_trim_fs to support trimming freed clusters in the
volume. A range will be given and all the freed clusters greater
than minlen will be discarded to the block layer.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/alloc.c |  156 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/alloc.h |    1 +
 2 files changed, 157 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b27a0d8..0ff46d9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -29,6 +29,7 @@
 #include <linux/highmem.h>
 #include <linux/swap.h>
 #include <linux/quotaops.h>
+#include <linux/blkdev.h>
 
 #include <cluster/masklog.h>
 
@@ -7184,3 +7185,158 @@ out_commit:
 out:
 	return ret;
 }
+
+static int ocfs2_trim_extent(struct super_block *sb,
+			     struct ocfs2_group_desc *gd,
+			     int start, int count)
+{
+	u64 discard;
+
+	count = ocfs2_clusters_to_blocks(sb, count);
+	discard = le64_to_cpu(gd->bg_blkno) +
+			ocfs2_clusters_to_blocks(sb, start);
+
+	return sb_issue_discard(sb, discard, count, GFP_NOFS, 0);
+}
+
+static int ocfs2_trim_group(struct super_block *sb,
+			    struct ocfs2_group_desc *gd,
+			    int start, int max, int minbits)
+{
+	int ret = 0, count = 0, next;
+	void *bitmap = gd->bg_bitmap;
+
+	while (start < max) {
+		start = ocfs2_find_next_zero_bit(bitmap, max, start);
+		if (start >= max)
+			break;
+		next = ocfs2_find_next_bit(bitmap, max, start);
+
+		if ((next - start) >= minbits) {
+			ret = ocfs2_trim_extent(sb, gd,
+						start, next - start);
+			if (ret < 0) {
+				mlog_errno(ret);
+				break;
+			}
+			count += next - start;
+		}
+		start = next + 1;
+
+		if (fatal_signal_pending(current)) {
+			count = -ERESTARTSYS;
+			break;
+		}
+
+		if ((le16_to_cpu(gd->bg_free_bits_count) - count) < minbits)
+			break;
+	}
+
+	if (ret < 0)
+		count = ret;
+
+	return count;
+}
+
+int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range)
+{
+	struct ocfs2_super *osb = OCFS2_SB(sb);
+	u64 start, len, minlen, trimmed, first_group, last_group, group;
+	int ret, cnt, first_bit, last_bit;
+	struct buffer_head *main_bm_bh = NULL;
+	struct inode *main_bm_inode = NULL;
+	struct buffer_head *gd_bh = NULL;
+	struct ocfs2_dinode *main_bm;
+	struct ocfs2_group_desc *gd = NULL;
+
+	start = range->start >> osb->s_clustersize_bits;
+	len = range->len >> osb->s_clustersize_bits;
+	minlen = range->minlen >> osb->s_clustersize_bits;
+	trimmed = 0;
+
+	if (!len) {
+		range->len = 0;
+		return 0;
+	}
+
+	if (minlen >= osb->bitmap_cpg)
+		return -EINVAL;
+
+	main_bm_inode = ocfs2_get_system_file_inode(osb,
+						    GLOBAL_BITMAP_SYSTEM_INODE,
+						    OCFS2_INVALID_SLOT);
+	if (!main_bm_inode) {
+		ret = -EIO;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mutex_lock(&main_bm_inode->i_mutex);
+
+	ret = ocfs2_inode_lock(main_bm_inode, &main_bm_bh, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_mutex;
+	}
+	main_bm = (struct ocfs2_dinode *)main_bm_bh->b_data;
+
+	if (start >= le32_to_cpu(main_bm->i_clusters)) {
+		ret = -EINVAL;
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	if (start + len > le32_to_cpu(main_bm->i_clusters))
+		len = le32_to_cpu(main_bm->i_clusters) - start;
+
+	/* Determine first and last group to examine based on start and len */
+	first_group = ocfs2_which_cluster_group(main_bm_inode, start);
+	if (first_group == osb->first_cluster_group_blkno)
+		first_bit = start;
+	else
+		first_bit = start - ocfs2_blocks_to_clusters(sb, first_group);
+	last_group = ocfs2_which_cluster_group(main_bm_inode, start + len - 1);
+	last_bit = osb->bitmap_cpg;
+
+	for (group = first_group; group <= last_group;) {
+		if (first_bit + len >= osb->bitmap_cpg)
+			last_bit = osb->bitmap_cpg;
+		else
+			last_bit = first_bit + len;
+
+		ret = ocfs2_read_group_descriptor(main_bm_inode,
+						  main_bm, group,
+						  &gd_bh);
+		if (ret < 0) {
+			mlog_errno(ret);
+			break;
+		}
+
+		gd = (struct ocfs2_group_desc *)gd_bh->b_data;
+		cnt = ocfs2_trim_group(sb, gd, first_bit, last_bit, minlen);
+		brelse(gd_bh);
+		gd_bh = NULL;
+		if (cnt < 0) {
+			ret = cnt;
+			mlog_errno(ret);
+			break;
+		}
+
+		trimmed += cnt;
+		len -= osb->bitmap_cpg - first_bit;
+		first_bit = 0;
+		if (group == osb->first_cluster_group_blkno)
+			group = ocfs2_clusters_to_blocks(sb, osb->bitmap_cpg);
+		else
+			group += ocfs2_clusters_to_blocks(sb, osb->bitmap_cpg);
+	}
+	range->len = trimmed * sb->s_blocksize;
+out_unlock:
+	ocfs2_inode_unlock(main_bm_inode, 0);
+	brelse(main_bm_bh);
+out_mutex:
+	mutex_unlock(&main_bm_inode->i_mutex);
+	iput(main_bm_inode);
+out:
+	return ret;
+}
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 3bd08a0..ca381c5 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -239,6 +239,7 @@ int ocfs2_find_leaf(struct ocfs2_caching_info *ci,
 		    struct buffer_head **leaf_bh);
 int ocfs2_search_extent_list(struct ocfs2_extent_list *el, u32 v_cluster);
 
+int ocfs2_trim_fs(struct super_block *sb, struct fstrim_range *range);
 /*
  * Helper function to look at the # of clusters in an extent record.
  */
-- 
1.6.3.GIT

From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 22 Feb 2011 12:59:52 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Add a new code
	'OCFS2_INFO_FREEFRAG' for o2info ioctl.
In-Reply-To: <1298350792-6734-1-git-send-email-tristan.ye@oracle.com>
References: <1298350792-6734-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1298350792-6734-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This new code is a bit more complicated than former ones, the goal is to
show user all statistics required to take a deep insight into filesystem
on how the disk is being fragmentaed.

The goal is achieved by scaning global bitmap from (cluster)group to group
to figure out following factors in the filesystem:

        - How many free chunks in a fixed size as user requested.
        - How many real free chunks in all size.
        - Min/Max/Avg size(in) clusters of free chunks.
        - How do free chunks distribute(in size) in terms of a histogram,
          just like following:
          ---------------------------------------------------------
          Extent Size Range :  Free extents  Free Clusters  Percent
             32K...   64K-  :             1             1    0.00%
              1M...    2M-  :             9           288    0.03%
              8M...   16M-  :             2           831    0.09%
             32M...   64M-  :             1          2047    0.23%
            128M...  256M-  :             1          8191    0.92%
            256M...  512M-  :             2         21706    2.43%
            512M... 1024M-  :            27        858623   96.29%
          ---------------------------------------------------------

Userspace ioctl() call eventually gets the above info returned by passing
a 'struct ocfs2_info_freefrag' with the chunk_size being specified first.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c       |  292 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/ocfs2_ioctl.h |   23 ++++
 2 files changed, 315 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index ae7f89d..a2b562b 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -26,6 +26,7 @@
 #include "sysfile.h"
 #include "dir.h"
 #include "buffer_head_io.h"
+#include "suballoc.h"
 
 #include <linux/ext2_fs.h>
 
@@ -437,6 +438,293 @@ bail:
 	return status;
 }
 
+static void o2ffg_update_histogram(struct ocfs2_info_free_chunk_list *hist,
+				   unsigned int chunksize)
+{
+	int index;
+
+	index = __ilog2_u32(chunksize);
+	if (index >= OCFS2_INFO_MAX_HIST)
+		index = OCFS2_INFO_MAX_HIST - 1;
+
+	hist->fc_chunks[index]++;
+	hist->fc_clusters[index] += chunksize;
+}
+
+static void o2ffg_update_stats(struct ocfs2_info_freefrag_stats *stats,
+			       unsigned int chunksize)
+{
+	if (chunksize > stats->ffs_max)
+		stats->ffs_max = chunksize;
+
+	if (chunksize < stats->ffs_min)
+		stats->ffs_min = chunksize;
+
+	stats->ffs_avg += chunksize;
+	stats->ffs_free_chunks_real++;
+}
+
+void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
+			   unsigned int chunksize)
+{
+	o2ffg_update_histogram(&(ffg->iff_ffs.ffs_fc_hist), chunksize);
+	o2ffg_update_stats(&(ffg->iff_ffs), chunksize);
+}
+
+int ocfs2_info_freefrag_scan_chain(struct ocfs2_super *osb,
+				   struct inode *gb_inode,
+				   struct ocfs2_dinode *gb_dinode,
+				   struct ocfs2_chain_rec *rec,
+				   struct ocfs2_info_freefrag *ffg,
+				   u32 chunks_in_group)
+{
+	int status = 0, used;
+	u64 blkno;
+
+	struct buffer_head *bh = NULL;
+	struct ocfs2_group_desc *bg = NULL;
+
+	unsigned int max_bits, num_clusters;
+	unsigned int offset = 0, cluster, chunk;
+	unsigned int chunk_free, last_chunksize = 0;
+
+	if (!le32_to_cpu(rec->c_free))
+		goto bail;
+
+	do {
+		if (!bg)
+			blkno = le64_to_cpu(rec->c_blkno);
+		else
+			blkno = le64_to_cpu(bg->bg_next_group);
+
+		if (bh) {
+			brelse(bh);
+			bh = NULL;
+		}
+
+		if (o2info_coherent(&ffg->iff_req))
+			status = ocfs2_read_group_descriptor(gb_inode,
+							     gb_dinode,
+							     blkno, &bh);
+		else
+			status = ocfs2_read_blocks_sync(osb, blkno, 1, &bh);
+
+		if (status < 0) {
+			mlog(ML_ERROR, "Can't read the group descriptor # "
+			     "%llu from device.", (unsigned long long)blkno);
+			status = -EIO;
+			goto bail;
+		}
+
+		bg = (struct ocfs2_group_desc *)bh->b_data;
+
+		if (!le16_to_cpu(bg->bg_free_bits_count))
+			continue;
+
+		max_bits = le16_to_cpu(bg->bg_bits);
+		offset = 0;
+
+		for (chunk = 0; chunk < chunks_in_group; chunk++) {
+			/*
+			 * last chunk may be not an entire one.
+			 */
+			if ((offset + ffg->iff_chunksize) > max_bits)
+				num_clusters = max_bits - offset;
+			else
+				num_clusters = ffg->iff_chunksize;
+
+			chunk_free = 0;
+			for (cluster = 0; cluster < num_clusters; cluster++) {
+				used = ocfs2_test_bit(offset,
+						(unsigned long *)bg->bg_bitmap);
+				/*
+				 * - chunk_free counts free clusters in #N chunk.
+				 * - last_chunksize records the size(in) clusters
+				 *   for the last real free chunk being counted.
+				 */
+				if (!used) {
+					last_chunksize++;
+					chunk_free++;
+				}
+
+				if (used && last_chunksize) {
+					ocfs2_info_update_ffg(ffg,
+							      last_chunksize);
+					last_chunksize = 0;
+				}
+
+				offset++;
+			}
+
+			if (chunk_free == ffg->iff_chunksize)
+				ffg->iff_ffs.ffs_free_chunks++;
+		}
+
+		/*
+		 * need to update the info for last free chunk.
+		 */
+		if (last_chunksize)
+			ocfs2_info_update_ffg(ffg, last_chunksize);
+
+	} while (le64_to_cpu(bg->bg_next_group));
+
+bail:
+	brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
+				    struct inode *gb_inode, u64 blkno,
+				    struct ocfs2_info_freefrag *ffg)
+{
+	u32 chunks_in_group;
+	int status = 0, unlock = 0, i;
+
+	struct buffer_head *bh = NULL;
+	struct ocfs2_chain_list *cl = NULL;
+	struct ocfs2_chain_rec *rec = NULL;
+	struct ocfs2_dinode *gb_dinode = NULL;
+
+	if (gb_inode)
+		mutex_lock(&gb_inode->i_mutex);
+
+	if (o2info_coherent(&ffg->iff_req)) {
+		status = ocfs2_inode_lock(gb_inode, &bh, 0);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+		unlock = 1;
+	} else {
+		status = ocfs2_read_blocks_sync(osb, blkno, 1, &bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
+	gb_dinode = (struct ocfs2_dinode *)bh->b_data;
+	cl = &(gb_dinode->id2.i_chain);
+
+	/*
+	 * Chunksize(in) clusters from userspace should be
+	 * less than clusters in a group.
+	 */
+	if (ffg->iff_chunksize > le16_to_cpu(cl->cl_cpg)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
+	memset(&ffg->iff_ffs, 0, sizeof(struct ocfs2_info_freefrag_stats));
+
+	ffg->iff_ffs.ffs_min = ~0U;
+	ffg->iff_ffs.ffs_clusters =
+			le32_to_cpu(gb_dinode->id1.bitmap1.i_total);
+	ffg->iff_ffs.ffs_free_clusters = ffg->iff_ffs.ffs_clusters -
+			le32_to_cpu(gb_dinode->id1.bitmap1.i_used);
+
+	chunks_in_group = le16_to_cpu(cl->cl_cpg) / ffg->iff_chunksize + 1;
+
+	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i++) {
+		rec = &(cl->cl_recs[i]);
+		status = ocfs2_info_freefrag_scan_chain(osb, gb_inode,
+							gb_dinode,
+							rec, ffg,
+							chunks_in_group);
+		if (status)
+			goto bail;
+	}
+
+	if (ffg->iff_ffs.ffs_free_chunks_real)
+		ffg->iff_ffs.ffs_avg = (ffg->iff_ffs.ffs_avg /
+					ffg->iff_ffs.ffs_free_chunks_real);
+bail:
+	if (unlock)
+		ocfs2_inode_unlock(gb_inode, 0);
+
+	if (gb_inode)
+		mutex_unlock(&gb_inode->i_mutex);
+
+	if (gb_inode)
+		iput(gb_inode);
+
+	brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_freefrag(struct inode *inode,
+			       struct ocfs2_info_request __user *req)
+{
+	u64 blkno = -1;
+	char namebuf[40];
+	int status = -EFAULT, type = GLOBAL_BITMAP_SYSTEM_INODE;
+
+	struct ocfs2_info_freefrag *oiff;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *gb_inode = NULL;
+
+	oiff = kzalloc(sizeof(struct ocfs2_info_freefrag), GFP_NOFS);
+	if (!oiff) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
+	if (o2info_from_user(*oiff, req))
+		goto bail;
+	/*
+	 * chunksize from userspace should be power of 2.
+	 */
+	if ((oiff->iff_chunksize & (oiff->iff_chunksize - 1)) ||
+	    (!oiff->iff_chunksize)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
+	if (o2info_coherent(&oiff->iff_req)) {
+		gb_inode = ocfs2_get_system_file_inode(osb, type,
+						       OCFS2_INVALID_SLOT);
+		if (!gb_inode) {
+			mlog(ML_ERROR, "unable to get global_bitmap inode\n");
+			status = -EIO;
+			goto bail;
+		}
+	} else {
+		ocfs2_sprintf_system_inode_name(namebuf, sizeof(namebuf), type,
+						OCFS2_INVALID_SLOT);
+		status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
+						    namebuf,
+						    strlen(namebuf),
+						    &blkno);
+		if (status < 0) {
+			status = -ENOENT;
+			goto bail;
+		}
+	}
+
+	status = ocfs2_info_freefrag_scan_bitmap(osb, gb_inode, blkno, oiff);
+	if (status < 0)
+		goto bail;
+
+	o2info_set_request_filled(&oiff->iff_req);
+
+	if (o2info_to_user(*oiff, req))
+		goto bail;
+
+	status = 0;
+bail:
+	if (status)
+		o2info_set_request_error(&oiff->iff_req, req);
+
+	kfree(oiff);
+
+	return status;
+}
+
 int ocfs2_info_handle_unknown(struct inode *inode,
 			      struct ocfs2_info_request __user *req)
 {
@@ -512,6 +800,10 @@ int ocfs2_info_handle_request(struct inode *inode,
 		if (oir.ir_size == sizeof(struct ocfs2_info_freeinode))
 			status = ocfs2_info_handle_freeinode(inode, req);
 		break;
+	case OCFS2_INFO_FREEFRAG:
+		if (oir.ir_size == sizeof(struct ocfs2_info_freefrag))
+			status = ocfs2_info_handle_freefrag(inode, req);
+		break;
 	default:
 		status = ocfs2_info_handle_unknown(inode, req);
 		break;
diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
index 6b4b39a..18b6770 100644
--- a/fs/ocfs2/ocfs2_ioctl.h
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -152,6 +152,28 @@ struct ocfs2_info_freeinode {
 	__u32 ifi_pad;
 };
 
+#define OCFS2_INFO_MAX_HIST     (32)
+
+struct ocfs2_info_freefrag {
+	struct ocfs2_info_request iff_req;
+	struct ocfs2_info_freefrag_stats { /* (out) */
+		struct ocfs2_info_free_chunk_list {
+			__u32 fc_chunks[OCFS2_INFO_MAX_HIST];
+			__u32 fc_clusters[OCFS2_INFO_MAX_HIST];
+		} ffs_fc_hist;
+		__u32 ffs_clusters;
+		__u32 ffs_free_clusters;
+		__u32 ffs_free_chunks;
+		__u32 ffs_free_chunks_real;
+		__u32 ffs_min; /* Minimum free chunksize in clusters */
+		__u32 ffs_max;
+		__u32 ffs_avg;
+		__u32 ffs_pad;
+	} iff_ffs;
+	__u32 iff_chunksize; /* chunksize in clusters(in) */
+	__u32 iff_pad;
+};
+
 /* Codes for ocfs2_info_request */
 enum ocfs2_info_type {
 	OCFS2_INFO_CLUSTERSIZE = 1,
@@ -162,6 +184,7 @@ enum ocfs2_info_type {
 	OCFS2_INFO_FS_FEATURES,
 	OCFS2_INFO_JOURNAL_SIZE,
 	OCFS2_INFO_FREEINODE,
+	OCFS2_INFO_FREEFRAG,
 	OCFS2_INFO_NUM_TYPES
 };
 
-- 
1.5.5

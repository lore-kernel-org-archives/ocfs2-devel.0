From: Tao Ma <tao.ma@oracle.com>
Date: Mon Dec 17 17:16:03 2007
Subject: [Ocfs2-devel] [PATCH 2/6] Abstract some specific process in resize
	to some individual function.take 3
In-Reply-To: <47671D39.6090509@oracle.com>
Message-ID: <20071218011251.GA23432@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some process may be different for online and offline resize, so move
them to different functions for future change.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 tunefs.ocfs2/resize.c |  248 ++++++++++++++++++++++++++++--------------------
 1 files changed, 145 insertions(+), 103 deletions(-)

diff --git a/tunefs.ocfs2/resize.c b/tunefs.ocfs2/resize.c
index be5ea6b..0466d60 100644
--- a/tunefs.ocfs2/resize.c
+++ b/tunefs.ocfs2/resize.c
@@ -85,15 +85,152 @@ int validate_vol_size(ocfs2_filesys *fs)
 	return 0;
 }
 
+/*
+ * Initalize the group descriptors in the new added cluster range.
+ *
+ * di: global_bitmap's inode info.
+ * first_new_cluster: the start cluster offset.
+ * num_new_cluster: cluster range length.
+ * chain: the chain position of the last group descriptor. the new
+ *        group will be added to the chain after this one.
+ * total_bits and used_bits will be added according to the new groups.
+ */
+static errcode_t init_new_gd(ocfs2_filesys *fs,
+			     struct ocfs2_dinode *di,
+			     uint32_t first_new_cluster,
+			     uint32_t num_new_clusters,
+			     uint16_t chain,
+			     uint32_t *total_bits,
+			     uint32_t *used_bits)
+{
+	errcode_t ret = 0;
+	uint32_t cluster_chunk;
+	uint64_t gd_blkno = 0;
+	struct ocfs2_chain_list *cl = &di->id2.i_chain;
+	struct ocfs2_chain_rec *cr = NULL;
+	struct ocfs2_group_desc *gd = NULL;
+	char *zero_buf = NULL;
+	char *gd_buf = NULL;
+
+	ret = ocfs2_malloc_block(fs->fs_io, &gd_buf);
+	if (ret) {
+		com_err(opts.progname, ret, "while allocating a block during "
+			"volume resize");
+		goto bail;
+	}
+
+	ret = ocfs2_malloc_blocks(fs->fs_io, ocfs2_clusters_to_blocks(fs, 1),
+				  &zero_buf);
+	if (ret) {
+		com_err(opts.progname, ret, "while allocating a cluster during "
+			"volume resize");
+		goto bail;
+	}
+
+	memset(zero_buf, 0, fs->fs_clustersize);
+	gd = (struct ocfs2_group_desc *)gd_buf;
+
+	while(num_new_clusters) {
+		gd_blkno = ocfs2_which_cluster_group(fs, cl->cl_cpg,
+						     first_new_cluster);
+		cluster_chunk = MIN(num_new_clusters, cl->cl_cpg);
+		num_new_clusters -= cluster_chunk;
+		first_new_cluster += cluster_chunk;
+
+		if (++chain >= cl->cl_count)
+			chain = 0;
+
+		ocfs2_init_group_desc(fs, gd, gd_blkno,
+				      fs->fs_super->i_fs_generation, di->i_blkno,
+				      (cluster_chunk *cl->cl_bpc), chain);
+
+		/* Add group to chain */
+		cr = &(cl->cl_recs[chain]);
+		if (chain >= cl->cl_next_free_rec) {
+			cl->cl_next_free_rec++;
+			cr->c_free = 0;
+			cr->c_total = 0;
+			cr->c_blkno = 0;
+		}
+
+		gd->bg_next_group = cr->c_blkno;
+		cr->c_blkno = gd_blkno;
+		cr->c_free += gd->bg_free_bits_count;
+		cr->c_total += gd->bg_bits;
+
+		*used_bits += (gd->bg_bits - gd->bg_free_bits_count);
+		*total_bits += gd->bg_bits;
+
+		fs->fs_clusters += cluster_chunk;
+		fs->fs_blocks += ocfs2_clusters_to_blocks(fs, cluster_chunk);
+
+		/* Initialize the first cluster in the group */
+		ret = io_write_block(fs->fs_io, gd_blkno,
+				     ocfs2_clusters_to_blocks(fs, 1), zero_buf);
+		if (ret) {
+			com_err(opts.progname, ret, "while initializing the "
+				"cluster starting at block %"PRIu64" during "
+				"volume resize", gd_blkno);
+			goto bail;
+		}
+
+		/* write a new group descriptor */
+		ret = ocfs2_write_group_desc(fs, gd_blkno, gd_buf);
+		if (ret) {
+			com_err(opts.progname, ret, "while writing group "
+				"descriptor at block %"PRIu64" during "
+				"volume resize", gd_blkno);
+			goto bail;
+		}
+	}
+
+bail:
+	if (zero_buf)
+		ocfs2_free(&zero_buf);
+	if (gd_buf)
+		ocfs2_free(&gd_buf);
+	return ret;
+}
+
+static errcode_t update_global_bitmap(ocfs2_filesys *fs,
+				      struct ocfs2_dinode *di,
+				      struct ocfs2_group_desc *lgd,
+				      int flush_lgd)
+{
+	errcode_t ret = 0;
+
+	block_signals(SIG_BLOCK);
+	/* Flush that last group descriptor we updated before the new ones */
+	if (flush_lgd) {
+		ret = ocfs2_write_group_desc(fs, lgd->bg_blkno, (char *)lgd);
+		if (ret) {
+			com_err(opts.progname, ret, "while flushing group "
+				"descriptor at block %"PRIu64" during "
+				"volume resize", lgd->bg_blkno);
+			goto bail;
+		}
+	}
+
+	/* write the global bitmap inode */
+	ret = ocfs2_write_inode(fs, di->i_blkno, (char *)di);
+	if (ret) {
+		com_err(opts.progname, ret, "while writing global bitmap "
+			"inode at block %"PRIu64" during volume resize",
+			di->i_blkno);
+	}
+
+bail:
+	block_signals(SIG_UNBLOCK);
+	return ret;
+}
+
 errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 {
 	errcode_t ret = 0;
 	struct ocfs2_dinode *di;
 	uint64_t bm_blkno = 0;
-	uint64_t gd_blkno = 0;
 	uint64_t lgd_blkno = 0;
 	char *in_buf = NULL;
-	char *gd_buf = NULL;
 	char *lgd_buf = NULL;
 	struct ocfs2_chain_list *cl;
 	struct ocfs2_chain_rec *cr;
@@ -106,7 +243,6 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 	uint32_t total_bits;
 	uint32_t num_bits;
 	int flush_lgd = 0;
-	char *zero_buf = NULL;
 
 	ret = ocfs2_malloc_block(fs->fs_io, &in_buf);
 	if (ret) {
@@ -115,13 +251,6 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 		goto bail;
 	}
 
-	ret = ocfs2_malloc_block(fs->fs_io, &gd_buf);
-	if (ret) {
-		com_err(opts.progname, ret, "while allocating a block during "
-			"volume resize");
-		goto bail;
-	}
-
 	ret = ocfs2_malloc_block(fs->fs_io, &lgd_buf);
 	if (ret) {
 		com_err(opts.progname, ret, "while allocating a block during "
@@ -129,16 +258,6 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 		goto bail;
 	}
 
-	ret = ocfs2_malloc_blocks(fs->fs_io, ocfs2_clusters_to_blocks(fs, 1),
-				  &zero_buf);
-	if (ret) {
-		com_err(opts.progname, ret, "while allocating a cluster during "
-			"volume resize");
-		goto bail;
-	}
-
-	memset(zero_buf, 0, fs->fs_clustersize);
-
 	/* read global bitmap */
 	ret = ocfs2_lookup_system_inode(fs, GLOBAL_BITMAP_SYSTEM_INODE, 0,
 					&bm_blkno);
@@ -214,62 +333,10 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 	/* Init the new groups and write to disk */
 	/* Add these groups one by one starting from the first chain after */
 	/* the one containing the last group */
-
-	gd = (struct ocfs2_group_desc *)gd_buf;
-
-	while(num_new_clusters) {
-		gd_blkno = ocfs2_which_cluster_group(fs, cl->cl_cpg,
-						     first_new_cluster);
-		cluster_chunk = MIN(num_new_clusters, cl->cl_cpg);
-		num_new_clusters -= cluster_chunk;
-		first_new_cluster += cluster_chunk;
-
-		if (++chain >= cl->cl_count)
-			chain = 0;
-
-		ocfs2_init_group_desc(fs, gd, gd_blkno,
-				      fs->fs_super->i_fs_generation, di->i_blkno,
-				      (cluster_chunk *cl->cl_bpc), chain);
-
-		/* Add group to chain */
-		cr = &(cl->cl_recs[chain]);
-		if (chain >= cl->cl_next_free_rec) {
-			cl->cl_next_free_rec++;
-			cr->c_free = 0;
-			cr->c_total = 0;
-			cr->c_blkno = 0;
-		}
-
-		gd->bg_next_group = cr->c_blkno;
-		cr->c_blkno = gd_blkno;
-		cr->c_free += gd->bg_free_bits_count;
-		cr->c_total += gd->bg_bits;
-
-		used_bits += (gd->bg_bits - gd->bg_free_bits_count);
-		total_bits += gd->bg_bits;
-
-		fs->fs_clusters += cluster_chunk;
-		fs->fs_blocks += ocfs2_clusters_to_blocks(fs, cluster_chunk);
-
-		/* Initialize the first cluster in the group */
-		ret = io_write_block(fs->fs_io, gd_blkno,
-				     ocfs2_clusters_to_blocks(fs, 1), zero_buf);
-		if (ret) {
-			com_err(opts.progname, ret, "while initializing the "
-				"cluster starting at block %"PRIu64" during "
-				"volume resize", gd_blkno);
-			goto bail;
-		}
-
-		/* write a new group descriptor */
-		ret = ocfs2_write_group_desc(fs, gd_blkno, gd_buf);
-		if (ret) {
-			com_err(opts.progname, ret, "while writing group "
-				"descriptor at block %"PRIu64" during "
-				"volume resize", gd_blkno);
-			goto bail;
-		}
-	}
+	ret = init_new_gd(fs, di, first_new_cluster,
+			  num_new_clusters, chain, &total_bits, &used_bits);
+	if (ret)
+		goto bail;
 
 	di->id1.bitmap1.i_total = total_bits;
 	di->id1.bitmap1.i_used = used_bits;
@@ -279,40 +346,15 @@ errcode_t update_volume_size(ocfs2_filesys *fs, int *changed)
 
 	fs->fs_super->i_clusters = di->i_clusters;
 
-	block_signals(SIG_BLOCK);
-	/* Flush that last group descriptor we updated before the new ones */
-	if (flush_lgd) {
-		ret = ocfs2_write_group_desc(fs, lgd_blkno, lgd_buf);
-		if (ret) {
-			block_signals(SIG_UNBLOCK);
-			com_err(opts.progname, ret, "while flushing group "
-				"descriptor at block %"PRIu64" during "
-				"volume resize", lgd_blkno);
-			goto bail;
-		}
-	}
-
-	/* write the global bitmap inode */
-	ret = ocfs2_write_inode(fs, bm_blkno, in_buf);
-	if (ret) {
-		block_signals(SIG_UNBLOCK);
-		com_err(opts.progname, ret, "while writing global bitmap "
-			"inode at block %"PRIu64" during volume resize",
-			bm_blkno);
+	ret = update_global_bitmap(fs, di, gd, flush_lgd);
+	if (ret)
 		goto bail;
-	}
-
-	block_signals(SIG_UNBLOCK);
 
 	*changed = 1;
 
 bail:
-	if (zero_buf)
-		ocfs2_free(&zero_buf);
 	if (in_buf)
 		ocfs2_free(&in_buf);
-	if (gd_buf)
-		ocfs2_free(&gd_buf);
 	if (lgd_buf)
 		ocfs2_free(&lgd_buf);
 
-- 
gitgui.0.9.0.gd794

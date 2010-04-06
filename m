From: Mark Fasheh <mfasheh@suse.com>
Date: Mon,  5 Apr 2010 18:17:14 -0700
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: increase the default size of local
	alloc windows
In-Reply-To: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
References: <1270516636-12180-1-git-send-email-mfasheh@suse.com>
Message-ID: <1270516636-12180-3-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I have observed that the current size of 8M gives us pretty poor
fragmentation on multi-threaded workloads which do lots of writes.

Generally, I can increase the size of local alloc windows and observe a
marked decrease in fragmentation, even up and beyond window sizes of 512
megabytes. This makes sense for a couple reasons - larger local alloc means
more room for reservation windows. On multi-node workloads the larger local
alloc helps as well because we don't have to do window slides as often.

Also, I removed the OCFS2_DEFAULT_LOCAL_ALLOC_SIZE constant as it is no
longer used and the comment above it was out of date.

To test fragmentation, I used a workload which launched 4 threads that did
4k writes into a series of about 140 alternating files.

With resv_level=2, and a 4k/4k file system I observed the following average
fragmentation for various localalloc= parameters:

localalloc=	avg. fragmentation
	8		48
	32		16
	64		10
	120		7

On larger cluster sizes, the difference is more dramatic.

The new default size top out at 256M, which we'll only get for cluster
sizes of 32K and above.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/localalloc.h |    1 +
 fs/ocfs2/ocfs2.h      |    3 +
 fs/ocfs2/ocfs2_fs.h   |    8 ---
 fs/ocfs2/super.c      |    3 +-
 5 files changed, 118 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 9dc34a6..9b70a02 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -75,10 +75,120 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 					  struct inode *local_alloc_inode);
 
+/*
+ * ocfs2_la_default_mb() - determine a default size, in megabytes of
+ * the local alloc.
+ *
+ * Generally, we'd like to pick as large a local alloc as
+ * possible. Performance on large workloads tends to scale
+ * proportionally to la size. In addition to that, the reservations
+ * code functions more efficiently as it can reserve more windows for
+ * write.
+ *
+ * Some things work against us when trying to choose a large local alloc:
+ *
+ * - We need to ensure our sizing is picked to leave enough space in
+ *   group descriptors for other allocations (such as block groups,
+ *   etc). Picking default sizes which are a multiple of 4 could help
+ *   - block groups are allocated in 2mb and 4mb chunks.
+ *
+ * - Likewise, we don't want to starve other nodes of bits on small
+ *   file systems. This can easily be taken care of by limiting our
+ *   default to a reasonable size (256M) on larger cluster sizes.
+ *
+ * - Some file systems can't support very large sizes - 4k and 8k in
+ *   particular are limited to less than 128 and 256 megabytes respectively.
+ *
+ * The following reference table shows group descriptor and local
+ * alloc maximums at various cluster sizes (4k blocksize)
+ *
+ * csize: 4K	group: 126M	la: 121M
+ * csize: 8K	group: 252M	la: 243M
+ * csize: 16K	group: 504M	la: 486M
+ * csize: 32K	group: 1008M	la: 972M
+ * csize: 64K	group: 2016M	la: 1944M
+ * csize: 128K	group: 4032M	la: 3888M
+ * csize: 256K	group: 8064M	la: 7776M
+ * csize: 512K	group: 16128M	la: 15552M
+ * csize: 1024K	group: 32256M	la: 31104M
+ */
+#define	OCFS2_LA_MAX_DEFAULT_MB	256
+#define	OCFS2_LA_OLD_DEFAULT	8
+unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb)
+{
+	unsigned int la_mb;
+	unsigned int gd_mb;
+	unsigned int megs_per_slot;
+	struct super_block *sb = osb->sb;
+
+	gd_mb = ocfs2_clusters_to_megabytes(osb->sb,
+					    8 * ocfs2_group_bitmap_size(sb));
+
+	/*
+	 * This takes care of files systems with very small group
+	 * descriptors - 512 byte blocksize at cluster sizes lower
+	 * than 16K and also 1k blocksize with 4k cluster size.
+	 */
+	if ((sb->s_blocksize == 512 && osb->s_clustersize <= 8192)
+	    || (sb->s_blocksize == 1024 && osb->s_clustersize == 4096))
+		return OCFS2_LA_OLD_DEFAULT;
+
+	/*
+	 * Leave enough room for some block groups and make the final
+	 * value we work from a multiple of 4.
+	 */
+	gd_mb -= 16;
+	gd_mb &= 0xFFFFFFFB;
+
+	la_mb = gd_mb;
+
+	/*
+	 * Keep window sizes down to a reasonable default
+	 */
+	if (la_mb > OCFS2_LA_MAX_DEFAULT_MB) {
+		/*
+		 * Some clustersize / blocksize combinations will have
+		 * given us a larger than OCFS2_LA_MAX_DEFAULT_MB
+		 * default size, but get poor distribution when
+		 * limited to exactly 256 megabytes.
+		 *
+		 * As an example, 16K clustersize at 4K blocksize
+		 * gives us a cluster group size of 504M. Paring the
+		 * local alloc size down to 256 however, would give us
+		 * only one window and around 200MB left in the
+		 * cluster group. Instead, find the first size below
+		 * 256 which would give us an even distribution.
+		 *
+		 * Larger cluster group sizes actually work out pretty
+		 * well when pared to 256, so we don't have to do this
+		 * for any group that fits more than two
+		 * OCFS2_LA_MAX_DEFAULT_MB windows.
+		 */
+		if (gd_mb > (2 * OCFS2_LA_MAX_DEFAULT_MB))
+			la_mb = 256;
+		else {
+			unsigned int gd_mult = gd_mb;
+
+			while (gd_mult > 256)
+				gd_mult = gd_mult >> 1;
+
+			la_mb = gd_mult;
+		}
+	}
+
+	megs_per_slot = osb->osb_clusters_at_boot / osb->max_slots;
+	megs_per_slot = ocfs2_clusters_to_megabytes(osb->sb, megs_per_slot);
+	/* Too many nodes, too few disk clusters. */
+	if (megs_per_slot < la_mb)
+		la_mb = megs_per_slot;
+
+	return la_mb;
+}
+
 void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb)
 {
 	struct super_block *sb = osb->sb;
-	unsigned int la_default_mb = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
+	unsigned int la_default_mb = ocfs2_la_default_mb(osb);
 	unsigned int la_max_mb;
 
 	la_max_mb = ocfs2_clusters_to_megabytes(sb,
@@ -185,7 +295,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 		     osb->local_alloc_bits, (osb->bitmap_cpg - 1));
 		osb->local_alloc_bits =
 			ocfs2_megabytes_to_clusters(osb->sb,
-						    OCFS2_DEFAULT_LOCAL_ALLOC_SIZE);
+						    ocfs2_la_default_mb(osb));
 	}
 
 	/* read the alloc off disk */
diff --git a/fs/ocfs2/localalloc.h b/fs/ocfs2/localalloc.h
index 04195c6..1be9b58 100644
--- a/fs/ocfs2/localalloc.h
+++ b/fs/ocfs2/localalloc.h
@@ -31,6 +31,7 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb);
 void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb);
 
 void ocfs2_la_set_sizes(struct ocfs2_super *osb, int requested_mb);
+unsigned int ocfs2_la_default_mb(struct ocfs2_super *osb);
 
 int ocfs2_begin_local_alloc_recovery(struct ocfs2_super *osb,
 				     int node_num,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 44b95a9..72e6eef 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -339,6 +339,9 @@ struct ocfs2_super
 	 */
 	unsigned int local_alloc_bits;
 	unsigned int local_alloc_default_bits;
+	/* osb_clusters_at_boot can become stale! Do not trust it to
+	 * be up to date. */
+	unsigned int osb_clusters_at_boot;
 
 	enum ocfs2_local_alloc_state local_alloc_state; /* protected
 							 * by osb_lock */
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 7638a38..d58bc76 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -340,14 +340,6 @@ struct reflink_arguments {
 #define OCFS2_MIN_JOURNAL_SIZE		(4 * 1024 * 1024)
 
 /*
- * Default local alloc size (in megabytes)
- *
- * The value chosen should be such that most allocations, including new
- * block groups, use local alloc.
- */
-#define OCFS2_DEFAULT_LOCAL_ALLOC_SIZE	8
-
-/*
  * Inline extended attribute size (in bytes)
  * The value chosen should be aligned to 16 byte boundaries.
  */
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 6dfcb4e..bca1ed3 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1499,7 +1499,7 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 			   (unsigned) (osb->osb_commit_interval / HZ));
 
 	local_alloc_megs = osb->local_alloc_bits >> (20 - osb->s_clustersize_bits);
-	if (local_alloc_megs != OCFS2_DEFAULT_LOCAL_ALLOC_SIZE)
+	if (local_alloc_megs != ocfs2_la_default_mb(osb))
 		seq_printf(s, ",localalloc=%d", local_alloc_megs);
 
 	if (opts & OCFS2_MOUNT_LOCALFLOCKS)
@@ -2247,6 +2247,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	}
 
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
+	osb->osb_clusters_at_boot = OCFS2_I(inode)->ip_clusters;
 	iput(inode);
 
 	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb) * 8;
-- 
1.6.4.2

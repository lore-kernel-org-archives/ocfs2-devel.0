From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 31 Jul 2008 13:42:00 -0700
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Track local alloc bits internally
In-Reply-To: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
References: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
Message-ID: <1217536922-28328-2-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Do this instead of tracking absolute local alloc size. This avoids
needless re-calculatiion of bits from bytes in localalloc.c. Additionally,
the value is now in a more natural unit for internal file system bitmap
work.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |   34 ++++++++++++----------------------
 fs/ocfs2/ocfs2.h      |   10 +++++++++-
 fs/ocfs2/super.c      |    8 +++++---
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 28e492e..b05ce66 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -47,8 +47,6 @@
 
 #define OCFS2_LOCAL_ALLOC(dinode)	(&((dinode)->id2.i_lab))
 
-static inline int ocfs2_local_alloc_window_bits(struct ocfs2_super *osb);
-
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
 
 static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
@@ -75,21 +73,13 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 					  struct inode *local_alloc_inode);
 
-static inline int ocfs2_local_alloc_window_bits(struct ocfs2_super *osb)
-{
-	BUG_ON(osb->s_clustersize_bits > 20);
-
-	/* Size local alloc windows by the megabyte */
-	return osb->local_alloc_size << (20 - osb->s_clustersize_bits);
-}
-
 /*
  * Tell us whether a given allocation should use the local alloc
  * file. Otherwise, it has to go to the main bitmap.
  */
 int ocfs2_alloc_should_use_local(struct ocfs2_super *osb, u64 bits)
 {
-	int la_bits = ocfs2_local_alloc_window_bits(osb);
+	int la_bits = osb->local_alloc_bits;
 	int ret = 0;
 
 	if (osb->local_alloc_state != OCFS2_LA_ENABLED)
@@ -120,14 +110,16 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	if (osb->local_alloc_size == 0)
+	if (osb->local_alloc_bits == 0)
 		goto bail;
 
-	if (ocfs2_local_alloc_window_bits(osb) >= osb->bitmap_cpg) {
+	if (osb->local_alloc_bits >= osb->bitmap_cpg) {
 		mlog(ML_NOTICE, "Requested local alloc window %d is larger "
 		     "than max possible %u. Using defaults.\n",
-		     ocfs2_local_alloc_window_bits(osb), (osb->bitmap_cpg - 1));
-		osb->local_alloc_size = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
+		     osb->local_alloc_bits, (osb->bitmap_cpg - 1));
+		osb->local_alloc_bits =
+			ocfs2_megabytes_to_clusters(osb->sb,
+						    OCFS2_DEFAULT_LOCAL_ALLOC_SIZE);
 	}
 
 	/* read the alloc off disk */
@@ -190,8 +182,7 @@ bail:
 	if (inode)
 		iput(inode);
 
-	mlog(0, "Local alloc window bits = %d\n",
-	     ocfs2_local_alloc_window_bits(osb));
+	mlog(0, "Local alloc window bits = %d\n", osb->local_alloc_bits);
 
 	mlog_exit(status);
 	return status;
@@ -490,7 +481,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	if (bits_wanted > ocfs2_local_alloc_window_bits(osb)) {
+	if (bits_wanted > osb->local_alloc_bits) {
 		mlog(0, "Asking for more than my max window size!\n");
 		status = -ENOSPC;
 		goto bail;
@@ -803,7 +794,7 @@ static int ocfs2_local_alloc_reserve_for_window(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	(*ac)->ac_bits_wanted = ocfs2_local_alloc_window_bits(osb);
+	(*ac)->ac_bits_wanted = osb->local_alloc_bits;
 
 	status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
 	if (status < 0) {
@@ -849,7 +840,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 		     "one\n");
 
 	mlog(0, "Allocating %u clusters for a new window.\n",
-	     ocfs2_local_alloc_window_bits(osb));
+	     osb->local_alloc_bits);
 
 	/* Instruct the allocation code to try the most recently used
 	 * cluster group. We'll re-record the group used this pass
@@ -859,8 +850,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 	/* we used the generic suballoc reserve function, but we set
 	 * everything up nicely, so there's no reason why we can't use
 	 * the more specific cluster api to claim bits. */
-	status = ocfs2_claim_clusters(osb, handle, ac,
-				      ocfs2_local_alloc_window_bits(osb),
+	status = ocfs2_claim_clusters(osb, handle, ac, osb->local_alloc_bits,
 				      &cluster_off, &cluster_count);
 	if (status < 0) {
 		if (status != -ENOSPC)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 1cb814b..3b3a34e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -250,7 +250,7 @@ struct ocfs2_super
 	struct ocfs2_journal *journal;
 	unsigned long osb_commit_interval;
 
-	int local_alloc_size;
+	unsigned int local_alloc_bits;
 	enum ocfs2_local_alloc_state local_alloc_state;
 	struct buffer_head *local_alloc_bh;
 	u64 la_last_gd;
@@ -552,6 +552,14 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
 	return pages_per_cluster;
 }
 
+static inline unsigned int ocfs2_megabytes_to_clusters(struct super_block *sb,
+						       unsigned int megs)
+{
+	BUILD_BUG_ON(OCFS2_MAX_CLUSTERSIZE > 1048576);
+
+	return megs << (20 - OCFS2_SB(sb)->s_clustersize_bits);
+}
+
 static inline void ocfs2_init_inode_steal_slot(struct ocfs2_super *osb)
 {
 	spin_lock(&osb->osb_lock);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2560b33..392f6a8 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -637,7 +637,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->s_atime_quantum = parsed_options.atime_quantum;
 	osb->preferred_slot = parsed_options.slot;
 	osb->osb_commit_interval = parsed_options.commit_interval;
-	osb->local_alloc_size = parsed_options.localalloc_opt;
+	osb->local_alloc_bits = ocfs2_megabytes_to_clusters(sb, parsed_options.localalloc_opt);
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
@@ -938,6 +938,7 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 {
 	struct ocfs2_super *osb = OCFS2_SB(mnt->mnt_sb);
 	unsigned long opts = osb->s_mount_opt;
+	unsigned int local_alloc_megs;
 
 	if (opts & OCFS2_MOUNT_HB_LOCAL)
 		seq_printf(s, ",_netdev,heartbeat=local");
@@ -970,8 +971,9 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",commit=%u",
 			   (unsigned) (osb->osb_commit_interval / HZ));
 
-	if (osb->local_alloc_size != OCFS2_DEFAULT_LOCAL_ALLOC_SIZE)
-		seq_printf(s, ",localalloc=%d", osb->local_alloc_size);
+	local_alloc_megs = osb->local_alloc_bits >> (20 - osb->s_clustersize_bits);
+	if (local_alloc_megs != OCFS2_DEFAULT_LOCAL_ALLOC_SIZE)
+		seq_printf(s, ",localalloc=%d", local_alloc_megs);
 
 	if (opts & OCFS2_MOUNT_LOCALFLOCKS)
 		seq_printf(s, ",localflocks,");
-- 
1.5.4.1

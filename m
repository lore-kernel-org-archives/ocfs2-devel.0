From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Mar 2010 14:53:15 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Clear undo bits when local alloc
 is freed
In-Reply-To: <20100312023109.GS11402@wotan.suse.de>
References: <20100312023109.GS11402@wotan.suse.de>
Message-ID: <20100318215314.GA8122@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 11, 2010 at 06:31:09PM -0800, Mark Fasheh wrote:
> When the local alloc file changes windows, unused bits are freed back to the
> global bitmap. By defnition, those bits can not be in use by any file. Also,
> the local alloc will never have been able to allocate those bits if they
> were part of a previous truncate. Therefore it makes sense that we should
> clear unused local alloc bits in the undo buffer so that they can be used
> immediatly.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> ---
>  fs/ocfs2/alloc.c        |    4 ++--
>  fs/ocfs2/dir.c          |    2 +-
>  fs/ocfs2/localalloc.c   |    2 +-
>  fs/ocfs2/refcounttree.c |    2 +-
>  fs/ocfs2/suballoc.c     |   44 ++++++++++++++++++++++++++++----------------
>  fs/ocfs2/suballoc.h     |    5 +++--
>  fs/ocfs2/xattr.c        |    2 +-
>  7 files changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index d17bdc7..c9608a5 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -5921,7 +5921,7 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
>  
>  			status = ocfs2_free_clusters(handle, data_alloc_inode,
>  						     data_alloc_bh, start_blk,
> -						     num_clusters);
> +						     num_clusters, 0);

	Seeing all these ', 0' arguments appear, I was confused until I
saw the actual ocfs2_free_clusters change later in the patch.  That made
me worry I would be re-confused coming back to this code six months from
now.
	Here's my shot at leaving ocfs2_free_clusters() and
ocfs2_free_suballoc_bits() intact while providing the same
functionality.

Joel

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 171c691..c983715 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -872,8 +872,10 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 			     (unsigned long long)la_start_blk,
 			     (unsigned long long)blkno);
 
-			status = ocfs2_free_clusters(handle, main_bm_inode,
-						     main_bm_bh, blkno, count);
+			status = ocfs2_release_clusters(handle,
+							main_bm_inode,
+							main_bm_bh, blkno,
+							count);
 			if (status < 0) {
 				mlog_errno(status);
 				goto bail;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 1238b49..adf5e2e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -763,8 +763,18 @@ static inline unsigned int ocfs2_megabytes_to_clusters(struct super_block *sb,
 	return megs << (20 - OCFS2_SB(sb)->s_clustersize_bits);
 }
 
-#define ocfs2_set_bit ext2_set_bit
-#define ocfs2_clear_bit ext2_clear_bit
+static inline void _ocfs2_set_bit(unsigned int bit, unsigned long *bitmap)
+{
+	ext2_set_bit(bit, bitmap);
+}
+#define ocfs2_set_bit(bit, addr) _ocfs2_set_bit((bit), (unsigned long *)(addr))
+
+static inline void _ocfs2_clear_bit(unsigned int bit, unsigned long *bitmap)
+{
+	ext2_clear_bit(bit, bitmap);
+}
+#define ocfs2_clear_bit(bit, addr) _ocfs2_clear_bit((bit), (unsigned long *)(addr))
+
 #define ocfs2_test_bit ext2_test_bit
 #define ocfs2_find_next_zero_bit ext2_find_next_zero_bit
 #define ocfs2_find_next_bit ext2_find_next_bit
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0016503..89196de 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -95,13 +95,6 @@ static inline int ocfs2_block_group_set_bits(handle_t *handle,
 					     struct buffer_head *group_bh,
 					     unsigned int bit_off,
 					     unsigned int num_bits);
-static inline int ocfs2_block_group_clear_bits(handle_t *handle,
-					       struct inode *alloc_inode,
-					       struct ocfs2_group_desc *bg,
-					       struct buffer_head *group_bh,
-					       unsigned int bit_off,
-					       unsigned int num_bits);
-
 static int ocfs2_relink_block_group(handle_t *handle,
 				    struct inode *alloc_inode,
 				    struct buffer_head *fe_bh,
@@ -1978,18 +1971,18 @@ int ocfs2_claim_clusters(struct ocfs2_super *osb,
 				      bits_wanted, cluster_start, num_clusters);
 }
 
-static inline int ocfs2_block_group_clear_bits(handle_t *handle,
-					       struct inode *alloc_inode,
-					       struct ocfs2_group_desc *bg,
-					       struct buffer_head *group_bh,
-					       unsigned int bit_off,
-					       unsigned int num_bits)
+static int ocfs2_block_group_clear_bits(handle_t *handle,
+					struct inode *alloc_inode,
+					struct ocfs2_group_desc *bg,
+					struct buffer_head *group_bh,
+					unsigned int bit_off,
+					unsigned int num_bits,
+					void (*undo_fn)(unsigned int bit,
+							unsigned long *bmap))
 {
 	int status;
 	unsigned int tmp;
-	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
 	struct ocfs2_group_desc *undo_bg = NULL;
-	int cluster_bitmap = 0;
 
 	mlog_entry_void();
 
@@ -1999,20 +1992,18 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 
 	mlog(0, "off = %u, num = %u\n", bit_off, num_bits);
 
-	if (ocfs2_is_cluster_bitmap(alloc_inode))
-		journal_type = OCFS2_JOURNAL_ACCESS_UNDO;
-
+	BUG_ON(undo_fn && !ocfs2_is_cluster_bitmap(alloc_inode));
 	status = ocfs2_journal_access_gd(handle, INODE_CACHE(alloc_inode),
-					 group_bh, journal_type);
+					 group_bh,
+					 undo_fn ?
+					 OCFS2_JOURNAL_ACCESS_UNDO :
+					 OCFS2_JOURNAL_ACCESS_WRITE);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	if (ocfs2_is_cluster_bitmap(alloc_inode))
-		cluster_bitmap = 1;
-
-	if (cluster_bitmap) {
+	if (undo_fn) {
 		jbd_lock_bh_state(group_bh);
 		undo_bg = (struct ocfs2_group_desc *)
 					bh2jh(group_bh)->b_committed_data;
@@ -2023,13 +2014,13 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 	while(tmp--) {
 		ocfs2_clear_bit((bit_off + tmp),
 				(unsigned long *) bg->bg_bitmap);
-		if (cluster_bitmap)
-			ocfs2_set_bit(bit_off + tmp,
-				      (unsigned long *) undo_bg->bg_bitmap);
+		if (undo_fn)
+			undo_fn(bit_off + tmp,
+				(unsigned long *) undo_bg->bg_bitmap);
 	}
 	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
 
-	if (cluster_bitmap)
+	if (undo_fn)
 		jbd_unlock_bh_state(group_bh);
 
 	status = ocfs2_journal_dirty(handle, group_bh);
@@ -2042,12 +2033,14 @@ bail:
 /*
  * expects the suballoc inode to already be locked.
  */
-int ocfs2_free_suballoc_bits(handle_t *handle,
-			     struct inode *alloc_inode,
-			     struct buffer_head *alloc_bh,
-			     unsigned int start_bit,
-			     u64 bg_blkno,
-			     unsigned int count)
+static int _ocfs2_free_suballoc_bits(handle_t *handle,
+				     struct inode *alloc_inode,
+				     struct buffer_head *alloc_bh,
+				     unsigned int start_bit,
+				     u64 bg_blkno,
+				     unsigned int count,
+				     void (*undo_fn)(unsigned int bit,
+						     unsigned long *bitmap))
 {
 	int status = 0;
 	u32 tmp_used;
@@ -2082,7 +2075,7 @@ int ocfs2_free_suballoc_bits(handle_t *handle,
 
 	status = ocfs2_block_group_clear_bits(handle, alloc_inode,
 					      group, group_bh,
-					      start_bit, count);
+					      start_bit, count, undo_fn);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -2113,6 +2106,18 @@ bail:
 	return status;
 }
 
+int ocfs2_free_suballoc_bits(handle_t *handle,
+			     struct inode *alloc_inode,
+			     struct buffer_head *alloc_bh,
+			     unsigned int start_bit,
+			     u64 bg_blkno,
+			     unsigned int count)
+{
+	return _ocfs2_free_suballoc_bits(handle, alloc_inode, alloc_bh,
+					 start_bit, bg_blkno, count,
+					 _ocfs2_set_bit);
+}
+
 int ocfs2_free_dinode(handle_t *handle,
 		      struct inode *inode_alloc_inode,
 		      struct buffer_head *inode_alloc_bh,
@@ -2126,11 +2131,13 @@ int ocfs2_free_dinode(handle_t *handle,
 					inode_alloc_bh, bit, bg_blkno, 1);
 }
 
-int ocfs2_free_clusters(handle_t *handle,
-		       struct inode *bitmap_inode,
-		       struct buffer_head *bitmap_bh,
-		       u64 start_blk,
-		       unsigned int num_clusters)
+static int _ocfs2_free_clusters(handle_t *handle,
+				struct inode *bitmap_inode,
+				struct buffer_head *bitmap_bh,
+				u64 start_blk,
+				unsigned int num_clusters,
+				void (*undo_fn)(unsigned int bit,
+						unsigned long *bitmap))
 {
 	int status;
 	u16 bg_start_bit;
@@ -2157,9 +2164,9 @@ int ocfs2_free_clusters(handle_t *handle,
 	mlog(0, "bg_blkno = %llu, bg_start_bit = %u\n",
 	     (unsigned long long)bg_blkno, bg_start_bit);
 
-	status = ocfs2_free_suballoc_bits(handle, bitmap_inode, bitmap_bh,
-					  bg_start_bit, bg_blkno,
-					  num_clusters);
+	status = _ocfs2_free_suballoc_bits(handle, bitmap_inode, bitmap_bh,
+					   bg_start_bit, bg_blkno,
+					   num_clusters, undo_fn);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
@@ -2173,6 +2180,32 @@ out:
 	return status;
 }
 
+int ocfs2_free_clusters(handle_t *handle,
+			struct inode *bitmap_inode,
+			struct buffer_head *bitmap_bh,
+			u64 start_blk,
+			unsigned int num_clusters)
+{
+	return _ocfs2_free_clusters(handle, bitmap_inode, bitmap_bh,
+				    start_blk, num_clusters,
+				    _ocfs2_set_bit);
+}
+
+/*
+ * Give never-used clusters back to the global bitmap.  We don't need
+ * to protect these bits in the undo buffer.
+ */
+int ocfs2_release_clusters(handle_t *handle,
+			   struct inode *bitmap_inode,
+			   struct buffer_head *bitmap_bh,
+			   u64 start_blk,
+			   unsigned int num_clusters)
+{
+	return _ocfs2_free_clusters(handle, bitmap_inode, bitmap_bh,
+				    start_blk, num_clusters,
+				    _ocfs2_clear_bit);
+}
+
 static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg)
 {
 	printk("Block Group:\n");
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index fa60723..e0f46df 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -127,6 +127,11 @@ int ocfs2_free_clusters(handle_t *handle,
 			struct buffer_head *bitmap_bh,
 			u64 start_blk,
 			unsigned int num_clusters);
+int ocfs2_release_clusters(handle_t *handle,
+			   struct inode *bitmap_inode,
+			   struct buffer_head *bitmap_bh,
+			   u64 start_blk,
+			   unsigned int num_clusters);
 
 static inline u64 ocfs2_which_suballoc_group(u64 block, unsigned int bit)
 {


-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Sep 21 09:36:28 2007
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
Message-ID: <20070921163623.GI21356@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

Here are 4 ocfs2 fixes for post -rc7. All fix regressions, 3 related to
running on kernels greater than 4k page size, and one related to our mount
protocol failing on clusters with a mix of 32 and 64 bit systems.
        --Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/aops.c       |   33 +++++++++++++++++++--------------
 fs/ocfs2/file.c       |    4 ++--
 fs/ocfs2/localalloc.c |    4 +---
 fs/ocfs2/localalloc.h |    2 +-
 fs/ocfs2/suballoc.c   |   29 +++++++++++++++++++++--------
 fs/ocfs2/suballoc.h   |   11 +++++++++++
 fs/ocfs2/vote.c       |    4 ++--
 7 files changed, 57 insertions(+), 30 deletions(-)

Mark Fasheh (3):
      ocfs2: Allow smaller allocations during large writes
      ocfs2: Fix pos/len passed to ocfs2_write_cluster
      ocfs2: Don't double set write parameters

Sunil Mushran (1):
      ocfs2: Pack vote message and response structures

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 50cd8a2..f37f25c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -930,18 +930,11 @@ static void ocfs2_write_failure(struct inode *inode,
 				loff_t user_pos, unsigned user_len)
 {
 	int i;
-	unsigned from, to;
+	unsigned from = user_pos & (PAGE_CACHE_SIZE - 1),
+		to = user_pos + user_len;
 	struct page *tmppage;
 
-	ocfs2_zero_new_buffers(wc->w_target_page, user_pos, user_len);
-
-	if (wc->w_large_pages) {
-		from = wc->w_target_from;
-		to = wc->w_target_to;
-	} else {
-		from = 0;
-		to = PAGE_CACHE_SIZE;
-	}
+	ocfs2_zero_new_buffers(wc->w_target_page, from, to);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
@@ -991,9 +984,6 @@ static int ocfs2_prepare_page_for_write(struct inode *inode, u64 *p_blkno,
 			map_from = cluster_start;
 			map_to = cluster_end;
 		}
-
-		wc->w_target_from = map_from;
-		wc->w_target_to = map_to;
 	} else {
 		/*
 		 * If we haven't allocated the new page yet, we
@@ -1211,18 +1201,33 @@ static int ocfs2_write_cluster_by_desc(struct address_space *mapping,
 				       loff_t pos, unsigned len)
 {
 	int ret, i;
+	loff_t cluster_off;
+	unsigned int local_len = len;
 	struct ocfs2_write_cluster_desc *desc;
+	struct ocfs2_super *osb = OCFS2_SB(mapping->host->i_sb);
 
 	for (i = 0; i < wc->w_clen; i++) {
 		desc = &wc->w_desc[i];
 
+		/*
+		 * We have to make sure that the total write passed in
+		 * doesn't extend past a single cluster.
+		 */
+		local_len = len;
+		cluster_off = pos & (osb->s_clustersize - 1);
+		if ((cluster_off + local_len) > osb->s_clustersize)
+			local_len = osb->s_clustersize - cluster_off;
+
 		ret = ocfs2_write_cluster(mapping, desc->c_phys,
 					  desc->c_unwritten, data_ac, meta_ac,
-					  wc, desc->c_cpos, pos, len);
+					  wc, desc->c_cpos, pos, local_len);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
 		}
+
+		len -= local_len;
+		pos += local_len;
 	}
 
 	ret = 0;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 7e34e66..f3bc365 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -491,8 +491,8 @@ int ocfs2_do_extend_allocation(struct ocfs2_super *osb,
 		goto leave;
 	}
 
-	status = ocfs2_claim_clusters(osb, handle, data_ac, 1,
-				      &bit_off, &num_bits);
+	status = __ocfs2_claim_clusters(osb, handle, data_ac, 1,
+					clusters_to_add, &bit_off, &num_bits);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 545f789..de984d2 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -524,13 +524,12 @@ bail:
 int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 				 handle_t *handle,
 				 struct ocfs2_alloc_context *ac,
-				 u32 min_bits,
+				 u32 bits_wanted,
 				 u32 *bit_off,
 				 u32 *num_bits)
 {
 	int status, start;
 	struct inode *local_alloc_inode;
-	u32 bits_wanted;
 	void *bitmap;
 	struct ocfs2_dinode *alloc;
 	struct ocfs2_local_alloc *la;
@@ -538,7 +537,6 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	mlog_entry_void();
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL);
 
-	bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
 	local_alloc_inode = ac->ac_inode;
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 	la = OCFS2_LOCAL_ALLOC(alloc);
diff --git a/fs/ocfs2/localalloc.h b/fs/ocfs2/localalloc.h
index 385a101..3f76631 100644
--- a/fs/ocfs2/localalloc.h
+++ b/fs/ocfs2/localalloc.h
@@ -48,7 +48,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 				 handle_t *handle,
 				 struct ocfs2_alloc_context *ac,
-				 u32 min_bits,
+				 u32 bits_wanted,
 				 u32 *bit_off,
 				 u32 *num_bits);
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index d9c5c9f..8f09f52 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1486,21 +1486,21 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
  * contig. allocation, set to '1' to indicate we can deal with extents
  * of any size.
  */
-int ocfs2_claim_clusters(struct ocfs2_super *osb,
-			 handle_t *handle,
-			 struct ocfs2_alloc_context *ac,
-			 u32 min_clusters,
-			 u32 *cluster_start,
-			 u32 *num_clusters)
+int __ocfs2_claim_clusters(struct ocfs2_super *osb,
+			   handle_t *handle,
+			   struct ocfs2_alloc_context *ac,
+			   u32 min_clusters,
+			   u32 max_clusters,
+			   u32 *cluster_start,
+			   u32 *num_clusters)
 {
 	int status;
-	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
+	unsigned int bits_wanted = max_clusters;
 	u64 bg_blkno = 0;
 	u16 bg_bit_off;
 
 	mlog_entry_void();
 
-	BUG_ON(!ac);
 	BUG_ON(ac->ac_bits_given >= ac->ac_bits_wanted);
 
 	BUG_ON(ac->ac_which != OCFS2_AC_USE_LOCAL
@@ -1557,6 +1557,19 @@ bail:
 	return status;
 }
 
+int ocfs2_claim_clusters(struct ocfs2_super *osb,
+			 handle_t *handle,
+			 struct ocfs2_alloc_context *ac,
+			 u32 min_clusters,
+			 u32 *cluster_start,
+			 u32 *num_clusters)
+{
+	unsigned int bits_wanted = ac->ac_bits_wanted - ac->ac_bits_given;
+
+	return __ocfs2_claim_clusters(osb, handle, ac, min_clusters,
+				      bits_wanted, cluster_start, num_clusters);
+}
+
 static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 					       struct inode *alloc_inode,
 					       struct ocfs2_group_desc *bg,
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index f212dc0..cafe937 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -85,6 +85,17 @@ int ocfs2_claim_clusters(struct ocfs2_super *osb,
 			 u32 min_clusters,
 			 u32 *cluster_start,
 			 u32 *num_clusters);
+/*
+ * Use this variant of ocfs2_claim_clusters to specify a maxiumum
+ * number of clusters smaller than the allocation reserved.
+ */
+int __ocfs2_claim_clusters(struct ocfs2_super *osb,
+			   handle_t *handle,
+			   struct ocfs2_alloc_context *ac,
+			   u32 min_clusters,
+			   u32 max_clusters,
+			   u32 *cluster_start,
+			   u32 *num_clusters);
 
 int ocfs2_free_suballoc_bits(handle_t *handle,
 			     struct inode *alloc_inode,
diff --git a/fs/ocfs2/vote.c b/fs/ocfs2/vote.c
index 66a13ee..c053585 100644
--- a/fs/ocfs2/vote.c
+++ b/fs/ocfs2/vote.c
@@ -66,7 +66,7 @@ struct ocfs2_vote_msg
 {
 	struct ocfs2_msg_hdr v_hdr;
 	__be32 v_reserved1;
-};
+} __attribute__ ((packed));
 
 /* Responses are given these values to maintain backwards
  * compatibility with older ocfs2 versions */
@@ -78,7 +78,7 @@ struct ocfs2_response_msg
 {
 	struct ocfs2_msg_hdr r_hdr;
 	__be32 r_response;
-};
+} __attribute__ ((packed));
 
 struct ocfs2_vote_work {
 	struct list_head   w_list;

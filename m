From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 18 Sep 2012 17:10:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: modifiy reservation code to
	support discontiguous allocations
In-Reply-To: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
References: <1348013463-23980-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1348013463-23980-2-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently reservation code assumes that bitmap given to it is one contigous
chunk. This patch enhances it to handle a discontigous chunks. It adds new
fields m_bitmap_ext_cnt and m_bitmap_ext_arr. m_bitmap_ext_arr tracks the sizes
of each contigous chunk and m_bitmap_ext_cnt trackes size of m_bitmap_ext_arr

Callers should pass number of discontiguous chunks during ocfs2_resmap_restart
and later call ocfs2_resmap_set_extent_size for every chunk.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/localalloc.c   |    4 +++-
 fs/ocfs2/reservations.c |   39 ++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/reservations.h |    7 ++++++-
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index a9f78c7..53a162f 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1191,9 +1191,11 @@ retry_enospc:
 	memset(OCFS2_LOCAL_ALLOC(alloc)->la_bitmap, 0,
 	       le16_to_cpu(la->la_size));
 
-	ocfs2_resmap_restart(&osb->osb_la_resmap, cluster_count,
+	ocfs2_resmap_restart(&osb->osb_la_resmap, 1, cluster_count,
 			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
 
+	ocfs2_resmap_set_extent_size(&osb->osb_la_resmap, 0, cluster_count);
+
 	trace_ocfs2_local_alloc_new_window_result(
 		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
 		le32_to_cpu(alloc->id1.bitmap1.i_total));
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 41ffd36..e1034ed 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -291,7 +291,7 @@ static void ocfs2_resmap_clear_all_resv(struct ocfs2_reservation_map *resmap)
 	}
 }
 
-void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap,
+void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap, u32 ext_cnt,
 			  unsigned int clen, char *disk_bitmap)
 {
 	if (ocfs2_resmap_disabled(resmap))
@@ -300,12 +300,32 @@ void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap,
 	spin_lock(&resv_lock);
 
 	ocfs2_resmap_clear_all_resv(resmap);
+
+	/* free existing extent array */
+	kfree(resmap->m_bitmap_ext_arr);
+
 	resmap->m_bitmap_len = clen;
 	resmap->m_disk_bitmap = disk_bitmap;
 
+	resmap->m_bitmap_ext_cnt = ext_cnt;
+	resmap->m_bitmap_ext_arr = kmalloc((sizeof(u32) * ext_cnt), GFP_NOFS);
+	if (!resmap->m_bitmap_ext_arr) {
+		mlog_errno(-ENOMEM);
+		resmap->m_osb->osb_resv_level = 0; /* disable reservations */
+	}
+
 	spin_unlock(&resv_lock);
 }
 
+void ocfs2_resmap_set_extent_size(struct ocfs2_reservation_map *resmap,
+				  int indx, u32 sz)
+{
+	if (ocfs2_resmap_disabled(resmap))
+		return;
+
+	resmap->m_bitmap_ext_arr[indx] = sz;
+}
+
 void ocfs2_resmap_uninit(struct ocfs2_reservation_map *resmap)
 {
 	/* Does nothing for now. Keep this around for API symmetry */
@@ -419,21 +439,30 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
 				       unsigned int *rlen)
 {
 	void *bitmap = resmap->m_disk_bitmap;
-	unsigned int best_start, best_len = 0;
+	unsigned int best_start, len, ext, best_len = 0;
 	int offset, start, found;
 
 	trace_ocfs2_resmap_find_free_bits_begin(search_start, search_len,
 						wanted, resmap->m_bitmap_len);
 
-	found = best_start = best_len = 0;
-
+	found = best_start = best_len = ext = 0;
 	start = search_start;
+	len = resmap->m_bitmap_ext_arr[ext++];
+
 	while ((offset = ocfs2_find_next_zero_bit(bitmap, resmap->m_bitmap_len,
-						 start)) != -1) {
+						  start)) != -1) {
 		/* Search reached end of the region */
 		if (offset >= (search_start + search_len))
 			break;
 
+		if (offset >= len) {
+			if (ext >= resmap->m_bitmap_ext_cnt)
+				break;
+			len += resmap->m_bitmap_ext_arr[ext++];
+			found = 1;
+			start = offset + 1;
+		}
+
 		if (offset == start) {
 			/* we found a zero */
 			found++;
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
index 42c2b80..fed3aae 100644
--- a/fs/ocfs2/reservations.h
+++ b/fs/ocfs2/reservations.h
@@ -56,6 +56,8 @@ struct ocfs2_reservation_map {
 	u32			m_bitmap_len;	/* Number of valid
 						 * bits available */
 
+	u32			m_bitmap_ext_cnt;
+	u32			*m_bitmap_ext_arr;
 	struct list_head	m_lru;		/* LRU of reservations
 						 * structures. */
 
@@ -94,6 +96,9 @@ void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
 int ocfs2_resmap_init(struct ocfs2_super *osb,
 		      struct ocfs2_reservation_map *resmap);
 
+void ocfs2_resmap_set_extent_size(struct ocfs2_reservation_map *resmap,
+				  int indx, u32 sz);
+
 /**
  * ocfs2_resmap_restart() - "restart" a reservation bitmap
  * @resmap: reservations bitmap
@@ -107,7 +112,7 @@ int ocfs2_resmap_init(struct ocfs2_super *osb,
  * reservations. A future version will recalculate existing
  * reservations based on the new bitmap.
  */
-void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap,
+void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap, u32 ext_cnt,
 			  unsigned int clen, char *disk_bitmap);
 
 /**
-- 
1.5.4.3

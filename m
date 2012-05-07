From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon,  7 May 2012 16:21:30 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: modify reservation code to support
	discontigous localalloc
In-Reply-To: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <1336432890-18638-4-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently reservation code assumes a bitmap given to it is all one contigous
chunk. This patch enhances it to handle a discontigous chunks. It adds new
fields m_bitmap_ext_cnt and m_bitmap_ext_arr. m_bitmap_ext_arr tracks the sizes
of each contigous free bits and m_bitmap_ext_cnt trackes number of
m_bitmap_ext_arr.

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/reservations.c |   41 ++++++++++++++++++++++++++++++++++-------
 fs/ocfs2/reservations.h |    7 ++++++-
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index 41ffd36..fea93d7 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -291,7 +291,15 @@ static void ocfs2_resmap_clear_all_resv(struct ocfs2_reservation_map *resmap)
 	}
 }
 
-void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap,
+void ocfs2_resmap_set_ext(struct ocfs2_reservation_map *resmap, int arr, u32 sz)
+{
+	if (ocfs2_resmap_disabled(resmap))
+		return;
+
+	resmap->m_bitmap_ext_arr[arr] = sz;
+}
+
+void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap, u32 ext_cnt,
 			  unsigned int clen, char *disk_bitmap)
 {
 	if (ocfs2_resmap_disabled(resmap))
@@ -300,9 +308,21 @@ void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap,
 	spin_lock(&resv_lock);
 
 	ocfs2_resmap_clear_all_resv(resmap);
+
+	/* free existing extent array */
+	if (resmap->m_bitmap_ext_arr)
+		kfree(resmap->m_bitmap_ext_arr);
+
 	resmap->m_bitmap_len = clen;
 	resmap->m_disk_bitmap = disk_bitmap;
 
+	resmap->m_bitmap_ext_cnt = ext_cnt;
+	resmap->m_bitmap_ext_arr = kmalloc((sizeof(u32) * ext_cnt), GFP_NOFS);
+	if (!resmap->m_bitmap_ext_arr) {
+		mlog_errno(-ENOMEM);
+		resmap->m_osb->osb_resv_level = 0;
+	}
+
 	spin_unlock(&resv_lock);
 }
 
@@ -419,20 +439,26 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
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
 	while ((offset = ocfs2_find_next_zero_bit(bitmap, resmap->m_bitmap_len,
-						 start)) != -1) {
+						  start)) != -1) {
 		/* Search reached end of the region */
 		if (offset >= (search_start + search_len))
-			break;
+			goto out;
+
+		if (offset >= len) {
+			len += resmap->m_bitmap_ext_arr[ext];
+			found = 1;
+			start = offset + 1;
+		}
 
 		if (offset == start) {
 			/* we found a zero */
@@ -450,9 +476,10 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
 		}
 
 		if (found >= wanted)
-			break;
+			goto out;
 	}
 
+out:
 	if (best_len == 0)
 		return 0;
 
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
index 42c2b80..bb5e94f 100644
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
 
+void ocfs2_resmap_set_ext(struct ocfs2_reservation_map *resmap, int arr,
+			  u32 sz);
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

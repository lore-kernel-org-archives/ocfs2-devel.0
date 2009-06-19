From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 19 Jun 2009 14:45:54 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: Pin journal head before accessing
	jh->b_committed_data
Message-ID: <1245447958-12996-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds jbd_lock_bh_state() and jbd_unlock_bh_state() around accessses
to jh->b_committed_data.

Fixes oss bugzilla#1131
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1131

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/suballoc.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8439f6b..73a16d4 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -923,14 +923,23 @@ static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
 					 int nr)
 {
 	struct ocfs2_group_desc *bg = (struct ocfs2_group_desc *) bg_bh->b_data;
+	int ret;
 
 	if (ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap))
 		return 0;
-	if (!buffer_jbd(bg_bh) || !bh2jh(bg_bh)->b_committed_data)
+
+	if (!buffer_jbd(bg_bh))
 		return 1;
 
+	jbd_lock_bh_state(bg_bh);
 	bg = (struct ocfs2_group_desc *) bh2jh(bg_bh)->b_committed_data;
-	return !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+	if (bg)
+		ret = !ocfs2_test_bit(nr, (unsigned long *)bg->bg_bitmap);
+	else
+		ret = 1;
+	jbd_unlock_bh_state(bg_bh);
+
+	return ret;
 }
 
 static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
@@ -1885,6 +1894,7 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 	unsigned int tmp;
 	int journal_type = OCFS2_JOURNAL_ACCESS_WRITE;
 	struct ocfs2_group_desc *undo_bg = NULL;
+	int cluster_bitmap = 0;
 
 	mlog_entry_void();
 
@@ -1905,18 +1915,28 @@ static inline int ocfs2_block_group_clear_bits(handle_t *handle,
 	}
 
 	if (ocfs2_is_cluster_bitmap(alloc_inode))
-		undo_bg = (struct ocfs2_group_desc *) bh2jh(group_bh)->b_committed_data;
+		cluster_bitmap = 1;
+
+	if (cluster_bitmap) {
+		jbd_lock_bh_state(group_bh);
+		undo_bg = (struct ocfs2_group_desc *)
+					bh2jh(group_bh)->b_committed_data;
+		BUG_ON(!undo_bg);
+	}
 
 	tmp = num_bits;
 	while(tmp--) {
 		ocfs2_clear_bit((bit_off + tmp),
 				(unsigned long *) bg->bg_bitmap);
-		if (ocfs2_is_cluster_bitmap(alloc_inode))
+		if (cluster_bitmap)
 			ocfs2_set_bit(bit_off + tmp,
 				      (unsigned long *) undo_bg->bg_bitmap);
 	}
 	le16_add_cpu(&bg->bg_free_bits_count, num_bits);
 
+	if (cluster_bitmap)
+		jbd_unlock_bh_state(group_bh);
+
 	status = ocfs2_journal_dirty(handle, group_bh);
 	if (status < 0)
 		mlog_errno(status);
-- 
1.6.0.4

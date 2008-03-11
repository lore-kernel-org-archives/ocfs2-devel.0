From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:18 2008
Subject: [Ocfs2-devel] [PATCH 02/18] ocfs2: Spelling fixes
In-Reply-To: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
References: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1205278329-11111-3-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit c78bad11fbf1272ea021f56458025dc98486d6f4
Author: Joe Perches <joe@perches.com>
Date: Sun, 3 Feb 2008 17:33:42 +0200

This patch includes the ocfs2 relevant changes from the above
mainline commit.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
---
 fs/ocfs2/alloc.c           |    2 +-
 fs/ocfs2/dir.c             |    2 +-
 fs/ocfs2/ocfs1_fs_compat.h |    2 +-
 fs/ocfs2/suballoc.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 834a001..56f17f9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3338,7 +3338,7 @@ static int ocfs2_insert_path(struct inode *inode,
 	if (insert->ins_split != SPLIT_NONE) {
 		/*
 		 * We could call ocfs2_insert_at_leaf() for some types
-		 * of splits, but it's easier to just let one seperate
+		 * of splits, but it's easier to just let one separate
 		 * function sort it all out.
 		 */
 		ocfs2_split_record(inode, left_path, right_path,
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0e45fb8..a448d1e 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1221,7 +1221,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 	down_write(&oi->ip_alloc_sem);
 
 	/*
-	 * Prepare for worst case allocation scenario of two seperate
+	 * Prepare for worst case allocation scenario of two separate
 	 * extents.
 	 */
 	if (alloc == 2)
diff --git a/fs/ocfs2/ocfs1_fs_compat.h b/fs/ocfs2/ocfs1_fs_compat.h
index 0b499bc..dfb313b 100644
--- a/fs/ocfs2/ocfs1_fs_compat.h
+++ b/fs/ocfs2/ocfs1_fs_compat.h
@@ -77,7 +77,7 @@ struct ocfs1_disk_lock
 {
 /*00*/	__u32 curr_master;
 	__u8 file_lock;
-	__u8 compat_pad[3];  /* Not in orignal definition.  Used to
+	__u8 compat_pad[3];  /* Not in original definition.  Used to
 				make the already existing alignment
 				explicit */
 	__u64 last_write_time;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 7e397e2..72c198a 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -646,7 +646,7 @@ bail:
  * sync-data inodes."
  *
  * Note: OCFS2 already does this differently for metadata vs data
- * allocations, as those bitmaps are seperate and undo access is never
+ * allocations, as those bitmaps are separate and undo access is never
  * called on a metadata group descriptor.
  */
 static int ocfs2_test_bg_bit_allocatable(struct buffer_head *bg_bh,
-- 
1.5.3.4

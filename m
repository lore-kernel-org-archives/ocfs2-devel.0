From: Jan Kara <jack@suse.cz>
Date: Thu,  3 Feb 2011 14:16:19 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix estimate of necessary credits for
	mkdir
Message-ID: <1296738979-27791-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the rare case that INLINE_DATA, INDEX_DIR, QUOTA, XATTR features are
disabled and both the allocation of the directory inode and the allocation
of the first directory block need to relink allocation group, there need
not be enough credits reserved in a transaction. Fix the estimate.

CC: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/journal.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

 We've actually seen the assertion failing on an old kernel (and thus
the filesystem had all those features disabled) but it seems to be
theoretically possible with new kernels as well.

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 43e56b9..6180da1 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -405,9 +405,9 @@ static inline int ocfs2_remove_extent_credits(struct super_block *sb)
 	       ocfs2_quota_trans_credits(sb);
 }
 
-/* data block for new dir/symlink, 2 for bitmap updates (bitmap fe +
- * bitmap block for the new bit) dx_root update for free list */
-#define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + 2 + 1)
+/* data block for new dir/symlink, allocation of directory block, dx_root
+ * update for free list */
+#define OCFS2_DIR_LINK_ADDITIONAL_CREDITS (1 + OCFS2_SUBALLOC_ALLOC + 1)
 
 static inline int ocfs2_add_dir_index_credits(struct super_block *sb)
 {
-- 
1.7.1

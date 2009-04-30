From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 29 Apr 2009 18:04:51 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix a missing credit when deleting
	from indexed	directories.
Message-ID: <20090430010449.GE27450@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The ocfs2 directory index updates two blocks when we remove an entry -
the dx root and the dx leaf.  OCFS2_DELETE_INODE_CREDITS was only
accounting for the dx leaf.  This shows up when ocfs2_delete_inode()
runs out of credits in jbd2_journal_dirty_metadata() at
"J_ASSERT_JH(jh, handle->h_buffer_credits > 0);".

The test that caught this was running dirop_file_racer from the
ocfs2-test suite with a 250-character filename PREFIX.  Run on a 512B
blocksize, it forces the orphan dir index to grow large enough to
trigger.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 619dd7f..eb7b763 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -437,8 +437,9 @@ static inline int ocfs2_unlink_credits(struct super_block *sb)
 }
 
 /* dinode + orphan dir dinode + inode alloc dinode + orphan dir entry +
- * inode alloc group descriptor + orphan dir index leaf */
-#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 3)
+ * inode alloc group descriptor + orphan dir index root +
+ * orphan dir index leaf */
+#define OCFS2_DELETE_INODE_CREDITS (3 * OCFS2_INODE_UPDATE_CREDITS + 4)
 
 /* dinode update, old dir dinode update, new dir dinode update, old
  * dir dir entry, new dir dir entry, dir entry update for renaming
-- 
1.6.1.3


-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

From: Jan Kara <jack@suse.cz>
Date: Mon, 11 Nov 2013 22:51:07 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: Simplify ocfs2_invalidatepage() and
	ocfs2_releasepage()
Message-ID: <1384206667-8667-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ocfs2 doesn't do data journalling. Thus its ->invalidatepage and ->releasepage
functions never get called on buffers that have journal heads attached. So
just use standard variants of functions from buffer.c.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/aops.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f37d3c0e2053..04df2ae18592 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -592,26 +592,11 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
 	ocfs2_rw_unlock(inode, level);
 }
 
-/*
- * ocfs2_invalidatepage() and ocfs2_releasepage() are shamelessly stolen
- * from ext3.  PageChecked() bits have been removed as OCFS2 does not
- * do journalled data.
- */
-static void ocfs2_invalidatepage(struct page *page, unsigned int offset,
-				 unsigned int length)
-{
-	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
-
-	jbd2_journal_invalidatepage(journal, page, offset, length);
-}
-
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
 {
-	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
-
 	if (!page_has_buffers(page))
 		return 0;
-	return jbd2_journal_try_to_free_buffers(journal, page, wait);
+	return try_to_free_buffers(page);
 }
 
 static ssize_t ocfs2_direct_IO(int rw,
@@ -2087,7 +2072,7 @@ const struct address_space_operations ocfs2_aops = {
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
 	.direct_IO		= ocfs2_direct_IO,
-	.invalidatepage		= ocfs2_invalidatepage,
+	.invalidatepage		= block_invalidatepage,
 	.releasepage		= ocfs2_releasepage,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate	= block_is_partially_uptodate,
-- 
1.8.1.4

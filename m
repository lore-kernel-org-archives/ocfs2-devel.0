From: Jan Kara <jack@suse.cz>
Date: Fri,  4 Nov 2016 18:08:16 +0100
Subject: [Ocfs2-devel] [PATCH 6/6] fs: Remove unmap_underlying_metadata
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Message-ID: <1478279296-6575-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>, linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>

Nobody is using this function anymore. Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 32 --------------------------------
 include/linux/buffer_head.h |  1 -
 2 files changed, 33 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index f96c079e181d..6d6680c8d306 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1605,38 +1605,6 @@ void create_empty_buffers(struct page *page,
 }
 EXPORT_SYMBOL(create_empty_buffers);
 
-/*
- * We are taking a block for data and we don't want any output from any
- * buffer-cache aliases starting from return from that function and
- * until the moment when something will explicitly mark the buffer
- * dirty (hopefully that will not happen until we will free that block ;-)
- * We don't even need to mark it not-uptodate - nobody can expect
- * anything from a newly allocated buffer anyway. We used to used
- * unmap_buffer() for such invalidation, but that was wrong. We definitely
- * don't want to mark the alias unmapped, for example - it would confuse
- * anyone who might pick it with bread() afterwards...
- *
- * Also..  Note that bforget() doesn't lock the buffer.  So there can
- * be writeout I/O going on against recently-freed buffers.  We don't
- * wait on that I/O in bforget() - it's more efficient to wait on the I/O
- * only if we really need to.  That happens here.
- */
-void unmap_underlying_metadata(struct block_device *bdev, sector_t block)
-{
-	struct buffer_head *old_bh;
-
-	might_sleep();
-
-	old_bh = __find_get_block_slow(bdev, block);
-	if (old_bh) {
-		clear_buffer_dirty(old_bh);
-		wait_on_buffer(old_bh);
-		clear_buffer_req(old_bh);
-		__brelse(old_bh);
-	}
-}
-EXPORT_SYMBOL(unmap_underlying_metadata);
-
 /**
  * clean_bdev_aliases: clean a range of buffers in block device
  * @bdev: Block device to clean buffers in
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index d1ab91fc6d43..d67ab83823ad 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -168,7 +168,6 @@ int inode_has_buffers(struct inode *);
 void invalidate_inode_buffers(struct inode *);
 int remove_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
-void unmap_underlying_metadata(struct block_device *bdev, sector_t block);
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
-- 
2.6.6

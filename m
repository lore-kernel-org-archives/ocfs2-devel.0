From: Jan Kara <jack@suse.cz>
Date: Fri,  4 Nov 2016 18:08:14 +0100
Subject: [Ocfs2-devel] [PATCH 4/6] ext2: Use clean_bdev_aliases() instead of
	iteration
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Message-ID: <1478279296-6575-5-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>, linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>

Use clean_bdev_aliases() instead of iterating through blocks one by one.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index d831e24dc885..eb11f7e2b8aa 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -732,16 +732,13 @@ static int ext2_get_blocks(struct inode *inode,
 	}
 
 	if (IS_DAX(inode)) {
-		int i;
-
 		/*
 		 * We must unmap blocks before zeroing so that writeback cannot
 		 * overwrite zeros with stale data from block device page cache.
 		 */
-		for (i = 0; i < count; i++) {
-			unmap_underlying_metadata(inode->i_sb->s_bdev,
-					le32_to_cpu(chain[depth-1].key) + i);
-		}
+		clean_bdev_aliases(inode->i_sb->s_bdev,
+				   le32_to_cpu(chain[depth-1].key),
+				   count);
 		/*
 		 * block must be initialised before we put it in the tree
 		 * so that it's not found by another thread before it's
-- 
2.6.6

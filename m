From: jiangyiwen <jiangyiwen@huawei.com>
Date: Tue, 18 Nov 2014 14:57:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: do not set filesystem readonly if link
	down
Message-ID: <546AEDE9.90304@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Do not set filesystem readonly if storage link down.
In this case, metadata is not corrupted and only -EIO is returned.
And if it is indeed a corrputed meatadata, it has already called
ocfs2_error in ocfs2_validate_inode_block.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 aops.c | 2 +-
 dir.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/aops.c b/aops.c
index 1ef547e..d9f2229 100644
--- a/aops.c
+++ b/aops.c
@@ -1251,7 +1251,7 @@ static int ocfs2_write_cluster(struct address_space *mapping,
 	ret = ocfs2_extent_map_get_blocks(inode, v_blkno, &p_blkno, NULL,
 					  NULL);
 	if (ret < 0) {
-		ocfs2_error(inode->i_sb, "Corrupting extend for inode %llu, "
+		mlog(ML_ERROR, "Get physical blkno failed for inode %llu, "
 			    "at logical block %llu",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    (unsigned long long)v_blkno);
diff --git a/dir.c b/dir.c
index 0717662..e6dc028 100644
--- a/dir.c
+++ b/dir.c
@@ -744,7 +744,7 @@ restart:
 		if (ocfs2_read_dir_block(dir, block, &bh, 0)) {
 			/* read error, skip block & hope for the best.
 			 * ocfs2_read_dir_block() has released the bh. */
-			ocfs2_error(dir->i_sb, "reading directory %llu, "
+			mlog(ML_ERROR, "reading directory %llu, "
 				    "offset %lu\n",
 				    (unsigned long long)OCFS2_I(dir)->ip_blkno,
 				    block);
-- 
1.8.3.4

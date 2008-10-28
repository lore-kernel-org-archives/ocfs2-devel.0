From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 27 Oct 2008 18:20:18 -0700
Subject: [Ocfs2-devel] [PATCH 03/13] ocfs2: Convenient access to xattr
	bucket data blocks.
In-Reply-To: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1225156828-32189-4-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The xattr code often wants to access the data pointer for blocks in an
xattr bucket.  This is usually found by dereferencing the bh array
hanging off of the ocfs2_xattr_bucket structure.  Rather than do this
all the time, let's provide a nice little macro.  The idea is ripped
from the ocfs2_path code.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7b320b2..7142554 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -155,6 +155,7 @@ static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
 }
 
 #define bucket_blkno(_b) ((_b)->bu_bhs[0]->b_blocknr)
+#define bucket_block(_b, _n) ((_b)->bu_bhs[(_n)]->b_data)
 
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
@@ -796,7 +797,7 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 								i,
 								&block_off,
 								&name_offset);
-			xs->base = xs->bucket.bu_bhs[block_off]->b_data;
+			xs->base = bucket_block(&xs->bucket, block_off);
 		}
 		if (ocfs2_xattr_is_local(xs->here)) {
 			memcpy(buffer, (void *)xs->base +
@@ -2275,11 +2276,11 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 	}
 	xs->bucket.bu_bhs[0] = lower_bh;
 	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)
-					xs->bucket.bu_bhs[0]->b_data;
+					bucket_block(&xs->bucket, 0);
 	lower_bh = NULL;
 
 	xs->header = xs->bucket.bu_xh;
-	xs->base = xs->bucket.bu_bhs[0]->b_data;
+	xs->base = bucket_block(&xs->bucket, 0);
 	xs->end = xs->base + inode->i_sb->s_blocksize;
 
 	if (found) {
@@ -2372,7 +2373,7 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 			goto out;
 		}
 
-		bucket.bu_xh = (struct ocfs2_xattr_header *)bucket.bu_bhs[0]->b_data;
+		bucket.bu_xh = (struct ocfs2_xattr_header *)bucket_block(&bucket, 0);
 		/*
 		 * The real bucket num in this series of blocks is stored
 		 * in the 1st bucket.
@@ -2450,7 +2451,7 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 			if (ret)
 				break;
 
-			name = (const char *)bucket->bu_bhs[block_off]->b_data +
+			name = (const char *)bucket_block(bucket, block_off) +
 				new_offset;
 			ret = ocfs2_xattr_list_entry(xl->buffer,
 						     xl->buffer_size,
@@ -2623,7 +2624,7 @@ static int ocfs2_xattr_update_xattr_search(struct inode *inode,
 
 	xs->bucket.bu_bhs[0] = new_bh;
 	get_bh(new_bh);
-	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)xs->bucket.bu_bhs[0]->b_data;
+	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)bucket_block(&xs->bucket, 0);
 	xs->header = xs->bucket.bu_xh;
 
 	xs->base = new_bh->b_data;
@@ -3846,7 +3847,7 @@ static inline char *ocfs2_xattr_bucket_get_val(struct inode *inode,
 	int block_off = offs >> inode->i_sb->s_blocksize_bits;
 
 	offs = offs % inode->i_sb->s_blocksize;
-	return bucket->bu_bhs[block_off]->b_data + offs;
+	return bucket_block(bucket, block_off) + offs;
 }
 
 /*
-- 
1.5.6.5

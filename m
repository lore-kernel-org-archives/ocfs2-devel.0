From: Joel Becker <joel.becker@oracle.com>
Date: Mon, 27 Oct 2008 18:20:19 -0700
Subject: [Ocfs2-devel] [PATCH 04/13] ocfs2: Convenient access to an xattr
	bucket's header.
In-Reply-To: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
References: <1225156828-32189-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1225156828-32189-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The xattr code often wants to access the ocfs2_xattr_header at the start
of an bucket.  Rather than walk the pointer chains, let's just create
another nice macro.  As a side benefit, we can get rid of the mostly
spurious ->bu_xh element on the bucket structure.  The idea is ripped
from the ocfs2_path code.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7142554..ff1cd6c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -62,7 +62,6 @@ struct ocfs2_xattr_def_value_root {
 
 struct ocfs2_xattr_bucket {
 	struct buffer_head *bu_bhs[OCFS2_XATTR_MAX_BLOCKS_PER_BUCKET];
-	struct ocfs2_xattr_header *bu_xh;
 };
 
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
@@ -156,6 +155,7 @@ static inline u16 ocfs2_xattr_max_xe_in_bucket(struct super_block *sb)
 
 #define bucket_blkno(_b) ((_b)->bu_bhs[0]->b_blocknr)
 #define bucket_block(_b, _n) ((_b)->bu_bhs[(_n)]->b_data)
+#define bucket_xh(_b) ((struct ocfs2_xattr_header *)bucket_block((_b), 0))
 
 static inline const char *ocfs2_xattr_prefix(int name_index)
 {
@@ -793,7 +793,7 @@ static int ocfs2_xattr_block_get(struct inode *inode,
 
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
 			ret = ocfs2_xattr_bucket_get_name_value(inode,
-								xs->bucket.bu_xh,
+								bucket_xh(&xs->bucket),
 								i,
 								&block_off,
 								&name_offset);
@@ -2275,11 +2275,9 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 		bh = NULL;
 	}
 	xs->bucket.bu_bhs[0] = lower_bh;
-	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)
-					bucket_block(&xs->bucket, 0);
 	lower_bh = NULL;
 
-	xs->header = xs->bucket.bu_xh;
+	xs->header = bucket_xh(&xs->bucket);
 	xs->base = bucket_block(&xs->bucket, 0);
 	xs->end = xs->base + inode->i_sb->s_blocksize;
 
@@ -2373,16 +2371,15 @@ static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 			goto out;
 		}
 
-		bucket.bu_xh = (struct ocfs2_xattr_header *)bucket_block(&bucket, 0);
 		/*
 		 * The real bucket num in this series of blocks is stored
 		 * in the 1st bucket.
 		 */
 		if (i == 0)
-			num_buckets = le16_to_cpu(bucket.bu_xh->xh_num_buckets);
+			num_buckets = le16_to_cpu(bucket_xh(&bucket)->xh_num_buckets);
 
 		mlog(0, "iterating xattr bucket %llu, first hash %u\n", blkno,
-		     le32_to_cpu(bucket.bu_xh->xh_entries[0].xe_name_hash));
+		     le32_to_cpu(bucket_xh(&bucket)->xh_entries[0].xe_name_hash));
 		if (func) {
 			ret = func(inode, &bucket, para);
 			if (ret) {
@@ -2437,14 +2434,14 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 	int i, block_off, new_offset;
 	const char *prefix, *name;
 
-	for (i = 0 ; i < le16_to_cpu(bucket->bu_xh->xh_count); i++) {
-		struct ocfs2_xattr_entry *entry = &bucket->bu_xh->xh_entries[i];
+	for (i = 0 ; i < le16_to_cpu(bucket_xh(bucket)->xh_count); i++) {
+		struct ocfs2_xattr_entry *entry = &bucket_xh(bucket)->xh_entries[i];
 		type = ocfs2_xattr_get_type(entry);
 		prefix = ocfs2_xattr_prefix(type);
 
 		if (prefix) {
 			ret = ocfs2_xattr_bucket_get_name_value(inode,
-								bucket->bu_xh,
+								bucket_xh(bucket),
 								i,
 								&block_off,
 								&new_offset);
@@ -2624,8 +2621,7 @@ static int ocfs2_xattr_update_xattr_search(struct inode *inode,
 
 	xs->bucket.bu_bhs[0] = new_bh;
 	get_bh(new_bh);
-	xs->bucket.bu_xh = (struct ocfs2_xattr_header *)bucket_block(&xs->bucket, 0);
-	xs->header = xs->bucket.bu_xh;
+	xs->header = bucket_xh(&xs->bucket);
 
 	xs->base = new_bh->b_data;
 	xs->end = xs->base + inode->i_sb->s_blocksize;
@@ -4313,7 +4309,7 @@ static void ocfs2_xattr_bucket_remove_xs(struct inode *inode,
 					 struct ocfs2_xattr_search *xs)
 {
 	handle_t *handle = NULL;
-	struct ocfs2_xattr_header *xh = xs->bucket.bu_xh;
+	struct ocfs2_xattr_header *xh = bucket_xh(&xs->bucket);
 	struct ocfs2_xattr_entry *last = &xh->xh_entries[
 						le16_to_cpu(xh->xh_count) - 1];
 	int ret = 0;
@@ -4442,7 +4438,7 @@ out:
 static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
 					      struct ocfs2_xattr_bucket *bucket)
 {
-	struct ocfs2_xattr_header *xh = bucket->bu_xh;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 
 	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
 	    xh->xh_entries[0].xe_name_hash) {
@@ -4606,7 +4602,7 @@ static int ocfs2_delete_xattr_in_bucket(struct inode *inode,
 					void *para)
 {
 	int ret = 0;
-	struct ocfs2_xattr_header *xh = bucket->bu_xh;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	u16 i;
 	struct ocfs2_xattr_entry *xe;
 
-- 
1.5.6.5

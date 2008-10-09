From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  9 Oct 2008 23:06:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/xattr: Calculate EA hash only by
	its suffix.
In-Reply-To: <48EE1C11.5030608@oracle.com>
References: <48EE1C11.5030608@oracle.com>
Message-ID: <1223564774-31450-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

According to Christoph Hellwig's advice, the hash value of EA
is only calculated by its suffix.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0f556b0..092a123 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -148,21 +148,13 @@ static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
 }
 
 static u32 ocfs2_xattr_name_hash(struct inode *inode,
-				 char *prefix,
-				 int prefix_len,
-				 char *name,
+				 const char *name,
 				 int name_len)
 {
 	/* Get hash value of uuid from super block */
 	u32 hash = OCFS2_SB(inode->i_sb)->uuid_hash;
 	int i;
 
-	/* hash extended attribute prefix */
-	for (i = 0; i < prefix_len; i++) {
-		hash = (hash << OCFS2_HASH_SHIFT) ^
-		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
-		       *prefix++;
-	}
 	/* hash extended attribute name */
 	for (i = 0; i < name_len; i++) {
 		hash = (hash << OCFS2_HASH_SHIFT) ^
@@ -183,14 +175,9 @@ static void ocfs2_xattr_hash_entry(struct inode *inode,
 				   struct ocfs2_xattr_entry *entry)
 {
 	u32 hash = 0;
-	struct xattr_handler *handler =
-			ocfs2_xattr_handler(ocfs2_xattr_get_type(entry));
-	char *prefix = handler->prefix;
 	char *name = (char *)header + le16_to_cpu(entry->xe_name_offset);
-	int prefix_len = strlen(handler->prefix);
 
-	hash = ocfs2_xattr_name_hash(inode, prefix, prefix_len, name,
-				     entry->xe_name_len);
+	hash = ocfs2_xattr_name_hash(inode, name, entry->xe_name_len);
 	entry->xe_name_hash = cpu_to_le32(hash);
 
 	return;
@@ -2093,18 +2080,6 @@ cleanup:
 	return ret;
 }
 
-static inline u32 ocfs2_xattr_hash_by_name(struct inode *inode,
-					   int name_index,
-					   const char *suffix_name)
-{
-	struct xattr_handler *handler = ocfs2_xattr_handler(name_index);
-	char *prefix = handler->prefix;
-	int prefix_len = strlen(handler->prefix);
-
-	return ocfs2_xattr_name_hash(inode, prefix, prefix_len,
-				     (char *)suffix_name, strlen(suffix_name));
-}
-
 /*
  * Find the xattr extent rec which may contains name_hash.
  * e_cpos will be the first name hash of the xattr rec.
@@ -2395,7 +2370,7 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	struct ocfs2_extent_list *el = &xb_root->xt_list;
 	u64 p_blkno = 0;
 	u32 first_hash, num_clusters = 0;
-	u32 name_hash = ocfs2_xattr_hash_by_name(inode, name_index, name);
+	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0)
 		return -ENODATA;
@@ -4435,8 +4410,8 @@ static int ocfs2_xattr_set_in_bucket(struct inode *inode,
 	size_t value_len;
 	char *val = (char *)xi->value;
 	struct ocfs2_xattr_entry *xe = xs->here;
-	u32 name_hash = ocfs2_xattr_hash_by_name(inode,
-						 xi->name_index, xi->name);
+	u32 name_hash = ocfs2_xattr_name_hash(inode, xi->name,
+					      strlen(xi->name));
 
 	if (!xs->not_found && !ocfs2_xattr_is_local(xe)) {
 		/*
-- 
1.5.4.GIT

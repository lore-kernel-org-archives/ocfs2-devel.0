From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  9 Oct 2008 23:06:14 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2/xattr: Refactor xattr list and
	remove ocfs2_xattr_handler().
In-Reply-To: <48EE1C11.5030608@oracle.com>
References: <48EE1C11.5030608@oracle.com>
Message-ID: <1223564774-31450-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

According to Christoph Hellwig's advice, we really don't need
a ->list to handle one xattr's list. Just a map from index to
xattr prefix is enough. And I also refactor the old list method
with the reference from fs/xfs/linux-2.6/xfs_xattr.c and the
xattr list method in btrfs.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   95 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 60 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 092a123..8f522f2 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -137,14 +137,14 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 static int ocfs2_delete_xattr_index_block(struct inode *inode,
 					  struct buffer_head *xb_bh);
 
-static inline struct xattr_handler *ocfs2_xattr_handler(int name_index)
+static inline const char *ocfs2_xattr_prefix(int name_index)
 {
 	struct xattr_handler *handler = NULL;
 
 	if (name_index > 0 && name_index < OCFS2_XATTR_MAX)
 		handler = ocfs2_xattr_handler_map[name_index];
 
-	return handler;
+	return handler ? handler->prefix : NULL;
 }
 
 static u32 ocfs2_xattr_name_hash(struct inode *inode,
@@ -452,33 +452,56 @@ static int ocfs2_xattr_value_truncate(struct inode *inode,
 	return ret;
 }
 
+static int ocfs2_xattr_list_entry(char *buffer, size_t size,
+				  size_t *result, const char *prefix,
+				  const char *name, int name_len)
+{
+	char *p = buffer + *result;
+	int prefix_len = strlen(prefix);
+	int total_len = prefix_len + name_len + 1;
+
+	*result += total_len;
+
+	/* we are just looking for how big our buffer needs to be */
+	if (!size)
+		return 0;
+
+	if (*result > size)
+		return -ERANGE;
+
+	memcpy(p, prefix, prefix_len);
+	memcpy(p + prefix_len, name, name_len);
+	p[prefix_len + name_len] = '\0';
+
+	return 0;
+}
+
 static int ocfs2_xattr_list_entries(struct inode *inode,
 				    struct ocfs2_xattr_header *header,
 				    char *buffer, size_t buffer_size)
 {
-	size_t rest = buffer_size;
-	int i;
+	size_t result = 0;
+	int i, type, ret;
+	const char *prefix, *name;
 
 	for (i = 0 ; i < le16_to_cpu(header->xh_count); i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
-		struct xattr_handler *handler =
-			ocfs2_xattr_handler(ocfs2_xattr_get_type(entry));
-
-		if (handler) {
-			size_t size = handler->list(inode, buffer, rest,
-					((char *)header +
-					le16_to_cpu(entry->xe_name_offset)),
-					entry->xe_name_len);
-			if (buffer) {
-				if (size > rest)
-					return -ERANGE;
-				buffer += size;
-			}
-			rest -= size;
+		type = ocfs2_xattr_get_type(entry);
+		prefix = ocfs2_xattr_prefix(type);
+
+		if (prefix) {
+			name = (const char *)header +
+				le16_to_cpu(entry->xe_name_offset);
+
+			ret = ocfs2_xattr_list_entry(buffer, buffer_size,
+						     &result, prefix, name,
+						     entry->xe_name_len);
+			if (ret)
+				return ret;
 		}
 	}
 
-	return buffer_size - rest;
+	return result;
 }
 
 static int ocfs2_xattr_ibody_list(struct inode *inode,
@@ -2456,6 +2479,7 @@ out:
 struct ocfs2_xattr_tree_list {
 	char *buffer;
 	size_t buffer_size;
+	size_t result;
 };
 
 static int ocfs2_xattr_bucket_get_name_value(struct inode *inode,
@@ -2481,17 +2505,17 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 				   struct ocfs2_xattr_bucket *bucket,
 				   void *para)
 {
-	int ret = 0;
+	int ret = 0, type;
 	struct ocfs2_xattr_tree_list *xl = (struct ocfs2_xattr_tree_list *)para;
-	size_t size;
 	int i, block_off, new_offset;
+	const char *prefix, *name;
 
 	for (i = 0 ; i < le16_to_cpu(bucket->xh->xh_count); i++) {
 		struct ocfs2_xattr_entry *entry = &bucket->xh->xh_entries[i];
-		struct xattr_handler *handler =
-			ocfs2_xattr_handler(ocfs2_xattr_get_type(entry));
+		type = ocfs2_xattr_get_type(entry);
+		prefix = ocfs2_xattr_prefix(type);
 
-		if (handler) {
+		if (prefix) {
 			ret = ocfs2_xattr_bucket_get_name_value(inode,
 								bucket->xh,
 								i,
@@ -2499,16 +2523,16 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 								&new_offset);
 			if (ret)
 				break;
-			size = handler->list(inode, xl->buffer, xl->buffer_size,
-					     bucket->bhs[block_off]->b_data +
-					     new_offset,
-					     entry->xe_name_len);
-			if (xl->buffer) {
-				if (size > xl->buffer_size)
-					return -ERANGE;
-				xl->buffer += size;
-			}
-			xl->buffer_size -= size;
+
+			name = (const char *)bucket->bhs[block_off]->b_data +
+				new_offset;
+			ret = ocfs2_xattr_list_entry(xl->buffer,
+						     xl->buffer_size,
+						     &xl->result,
+						     prefix, name,
+						     entry->xe_name_len);
+			if (ret)
+				break;
 		}
 	}
 
@@ -2527,6 +2551,7 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 	struct ocfs2_xattr_tree_list xl = {
 		.buffer = buffer,
 		.buffer_size = buffer_size,
+		.result = 0,
 	};
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0)
@@ -2554,7 +2579,7 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 		name_hash = e_cpos - 1;
 	}
 
-	ret = buffer_size - xl.buffer_size;
+	ret = xl.result;
 out:
 	return ret;
 }
-- 
1.5.4.GIT

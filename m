From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 10 Jun 2014 21:13:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: correctly check the return value of
	ocfs2_search_extent_list
Message-ID: <5397047B.6030406@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Yingtai Xie <xieyingtai@huawei.com>

ocfs2_search_extent_list may return -1, so we should check the return
value in ocfs2_split_and_insert, otherwise it may cause array index out
of bound.
And ocfs2_search_extent_list can only return value less than
el->l_next_free_rec, so check if it is equal or larger than
le16_to_cpu(el->l_next_free_rec) is meaningless.

Signed-off-by: Yingtai Xie <xieyingtai@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/alloc.c        | 15 ++++++++++++---
 fs/ocfs2/move_extents.c |  2 +-
 fs/ocfs2/refcounttree.c |  2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b4deb5f..1f435be 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4961,6 +4961,15 @@ leftright:

 		el = path_leaf_el(path);
 		split_index = ocfs2_search_extent_list(el, cpos);
+		if (split_index == -1) {
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+					"Owner %llu has an extent at cpos %u "
+					"which can no longer be found.\n",
+					(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+					cpos);
+			ret = -EROFS;
+			goto out;
+		}
 		goto leftright;
 	}
 out:
@@ -5135,7 +5144,7 @@ int ocfs2_change_extent_flag(handle_t *handle,
 	el = path_leaf_el(left_path);

 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(sb,
 			    "Owner %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
@@ -5491,7 +5500,7 @@ int ocfs2_remove_extent(handle_t *handle,

 	el = path_leaf_el(path);
 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
 			    "Owner %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
@@ -5557,7 +5566,7 @@ int ocfs2_remove_extent(handle_t *handle,

 		el = path_leaf_el(path);
 		index = ocfs2_search_extent_list(el, cpos);
-		if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+		if (index == -1) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
 				    "Owner %llu: split at cpos %u lost record.",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 599eb4c..6219aaa 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -98,7 +98,7 @@ static int __ocfs2_move_extent(handle_t *handle,
 	el = path_leaf_el(path);

 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6ba4bcb..aad45f6 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3110,7 +3110,7 @@ static int ocfs2_clear_ext_refcount(handle_t *handle,
 	el = path_leaf_el(path);

 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(sb,
 			    "Inode %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
-- 
1.8.4.3

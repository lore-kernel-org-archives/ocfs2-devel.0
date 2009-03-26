From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 27 Mar 2009 07:02:35 +0800
Subject: [Ocfs2-devel] [PATCH 29/42] ocfs2: Return extent flags for xattr
	value tree.
In-Reply-To: <49CC86FC.2070906@oracle.com>
References: <49CC86FC.2070906@oracle.com>
Message-ID: <1238108568-23740-29-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

With the new refcount tree, xattr value can also be refcounted
among multiple files. So return the appropriate extent flags
so that CoW can used it later.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/extent_map.c |    6 +++++-
 fs/ocfs2/extent_map.h |    3 ++-
 fs/ocfs2/xattr.c      |    7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 40b5105..843db64 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -541,7 +541,8 @@ static void ocfs2_relative_extent_offsets(struct super_block *sb,
 
 int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 			     u32 *p_cluster, u32 *num_clusters,
-			     struct ocfs2_extent_list *el)
+			     struct ocfs2_extent_list *el,
+			     unsigned int *extent_flags)
 {
 	int ret = 0, i;
 	struct buffer_head *eb_bh = NULL;
@@ -593,6 +594,9 @@ int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 		*p_cluster = *p_cluster + coff;
 		if (num_clusters)
 			*num_clusters = ocfs2_rec_clusters(el, rec) - coff;
+
+		if (extent_flags)
+			*extent_flags = rec->e_flags;
 	}
 out:
 	if (eb_bh)
diff --git a/fs/ocfs2/extent_map.h b/fs/ocfs2/extent_map.h
index 9942f47..e79d41c 100644
--- a/fs/ocfs2/extent_map.h
+++ b/fs/ocfs2/extent_map.h
@@ -55,7 +55,8 @@ int ocfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 int ocfs2_xattr_get_clusters(struct inode *inode, u32 v_cluster,
 			     u32 *p_cluster, u32 *num_clusters,
-			     struct ocfs2_extent_list *el);
+			     struct ocfs2_extent_list *el,
+			     unsigned int *extent_flags);
 
 int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 			   struct buffer_head *bhs[], int flags,
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 291ca13..70ad01c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -699,7 +699,7 @@ static int ocfs2_xattr_shrink_size(struct inode *inode,
 	while (trunc_len) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &phys_cpos,
 					       &alloc_size,
-					       &vb->vb_xv->xr_list);
+					       &vb->vb_xv->xr_list, NULL);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -954,7 +954,7 @@ static int ocfs2_xattr_get_value_outside(struct inode *inode,
 	cpos = 0;
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
-					       &num_clusters, el);
+					       &num_clusters, el, NULL);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
@@ -1192,7 +1192,8 @@ static int __ocfs2_xattr_set_value_outside(struct inode *inode,
 
 	while (cpos < clusters) {
 		ret = ocfs2_xattr_get_clusters(inode, cpos, &p_cluster,
-					       &num_clusters, &xv->xr_list);
+					       &num_clusters, &xv->xr_list,
+					       NULL);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
-- 
1.6.2.rc2.16.gf474c

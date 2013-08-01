From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 1 Aug 2013 17:14:42 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add the missing return value check of
	ocfs2_get_clusters
Message-ID: <51FA2702.5020903@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_attach_refcount_tree() and ocfs2_duplicate_extent_list(), if
error occurs when calling ocfs2_get_clusters(), it will go with
unexpected behavior as local variables p_cluster, num_clusters and
ext_flags are declared without initialization.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/refcounttree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 998b17e..3589ec1 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3886,6 +3886,10 @@ static int ocfs2_attach_refcount_tree(struct
inode *inode,
 	while (cpos < clusters) {
 		ret = ocfs2_get_clusters(inode, cpos, &p_cluster,
 					 &num_clusters, &ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			goto unlock;
+		}

 		if (p_cluster && !(ext_flags & OCFS2_EXT_REFCOUNTED)) {
 			ret = ocfs2_add_refcount_flag(inode, &di_et,
@@ -4057,6 +4061,10 @@ static int ocfs2_duplicate_extent_list(struct
inode *s_inode,
 	while (cpos < clusters) {
 		ret = ocfs2_get_clusters(s_inode, cpos, &p_cluster,
 					 &num_clusters, &ext_flags);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}

 		if (p_cluster) {
 			ret = ocfs2_add_refcounted_extent(t_inode, &et,
-- 
1.7.9.7

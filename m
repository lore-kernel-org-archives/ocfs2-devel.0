From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:05 -0700
Subject: [Ocfs2-devel] [patch 12/22] ocfs2: add missing return value check
	of ocfs2_get_clusters()
Message-ID: <20130827210505.A504B31C129@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: add missing return value check of ocfs2_get_clusters()

In ocfs2_attach_refcount_tree() and ocfs2_duplicate_extent_list(), if
error occurs when calling ocfs2_get_clusters(), it will go with
unexpected behavior as local variables p_cluster, num_clusters and
ext_flags are declared without initialization.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-add-missing-return-value-check-of-ocfs2_get_clusters
+++ a/fs/ocfs2/refcounttree.c
@@ -3854,7 +3854,10 @@ static int ocfs2_attach_refcount_tree(st
 	while (cpos < clusters) {
 		ret = ocfs2_get_clusters(inode, cpos, &p_cluster,
 					 &num_clusters, &ext_flags);
-
+		if (ret) {
+			mlog_errno(ret);
+			goto unlock;
+		}
 		if (p_cluster && !(ext_flags & OCFS2_EXT_REFCOUNTED)) {
 			ret = ocfs2_add_refcount_flag(inode, &di_et,
 						      &ref_tree->rf_ci,
@@ -4025,7 +4028,10 @@ static int ocfs2_duplicate_extent_list(s
 	while (cpos < clusters) {
 		ret = ocfs2_get_clusters(s_inode, cpos, &p_cluster,
 					 &num_clusters, &ext_flags);
-
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
 		if (p_cluster) {
 			ret = ocfs2_add_refcounted_extent(t_inode, &et,
 							  ref_ci, ref_root_bh,
_

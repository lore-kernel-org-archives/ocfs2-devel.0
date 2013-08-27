From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:08 -0700
Subject: [Ocfs2-devel] [patch 15/22] ocfs2: free meta_ac and data_ac when
	ocfs2_start_trans fails in ocfs2_xattr_set()
Message-ID: <20130827210509.094115A42C7@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: free meta_ac and data_ac when ocfs2_start_trans fails in ocfs2_xattr_set()

In ocfs2_xattr_set(), if ocfs2_start_trans failed, meta_ac and data_ac
should be free.  Otherwise, It would lead to a memory leak.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/xattr.c~ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set
+++ a/fs/ocfs2/xattr.c
@@ -3505,7 +3505,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	int ret, credits, ref_meta = 0, ref_credits = 0;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct inode *tl_inode = osb->osb_tl_inode;
-	struct ocfs2_xattr_set_ctxt ctxt = { NULL, NULL, };
+	struct ocfs2_xattr_set_ctxt ctxt = { NULL, NULL, NULL, };
 	struct ocfs2_refcount_tree *ref_tree = NULL;
 
 	struct ocfs2_xattr_info xi = {
@@ -3609,13 +3609,14 @@ int ocfs2_xattr_set(struct inode *inode,
 	if (IS_ERR(ctxt.handle)) {
 		ret = PTR_ERR(ctxt.handle);
 		mlog_errno(ret);
-		goto cleanup;
+		goto out_free_ac;
 	}
 
 	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
 
 	ocfs2_commit_trans(osb, ctxt.handle);
 
+out_free_ac:
 	if (ctxt.data_ac)
 		ocfs2_free_alloc_context(ctxt.data_ac);
 	if (ctxt.meta_ac)
_

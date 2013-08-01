From: Younger Liu <younger.liu@huawei.com>
Date: Thu, 1 Aug 2013 17:02:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free meta_ac and data_ac when
 ocfs2_start_trans fails in ocfs2_xattr_set()
Message-ID: <51FA2436.2050604@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_xattr_set(), if ocfs2_start_trans failed, 
meta_ac and data_ac should be free. 
Otherwise, It would lead to  memory leak.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/xattr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 317ef0a..1c2a892 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
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
-- 
1.7.9.7

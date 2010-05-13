From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 13 May 2010 22:49:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't retry xattr set in case value
	extension fails.
Message-ID: <1273762145-1868-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In normal xattr set, the set sequence is inode, xattr block
and finally xattr bucket if we meet with a ENOSPC. But there
is a corner case.
So consider we will set a xattr whose value will be stored in
a cluster, and there is no xattr block by now. So we will
reserve 1 xattr block and 1 cluster for setting it. Now if we
fail in value extension(in case the volume is almost full and
we can't allocate the cluster because the check in
ocfs2_test_bg_bit_allocatable), ENOSPC will be returned. So
we will try to create a bucket(this time there is a chance that
the reserved cluster will be used), and when we try value extension
again, kernel bug happens. We did meet with it. Check the bug below.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1251

This patch just try to avoid this by adding a set_abort in
ocfs2_xattr_set_ctxt, so in case ENOSPC happens in value extension,
we will check whether it is caused by the real ENOSPC or just the
full of inode or xattr block. If it is the first case, we set set_abort
so that we don't try any further. we are safe to exit directly here
ince it is really ENOSPC.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 60e608e..741f850 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -79,6 +79,7 @@ struct ocfs2_xattr_set_ctxt {
 	struct ocfs2_alloc_context *meta_ac;
 	struct ocfs2_alloc_context *data_ac;
 	struct ocfs2_cached_dealloc_ctxt dealloc;
+	int set_abort;
 };
 
 #define OCFS2_XATTR_ROOT_SIZE	(sizeof(struct ocfs2_xattr_def_value_root))
@@ -2135,6 +2136,7 @@ alloc_value:
 		orig_clusters = ocfs2_xa_value_clusters(loc);
 		rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len, ctxt);
 		if (rc < 0) {
+			ctxt->set_abort = 1;
 			ocfs2_xa_cleanup_value_truncate(loc, "growing",
 							orig_clusters);
 			/*
@@ -2945,7 +2947,7 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		ret = ocfs2_xa_set(&loc, xi, ctxt);
 		if (!ret)
 			xs->here = loc.xl_entry;
-		else if (ret != -ENOSPC)
+		else if ((ret != -ENOSPC) || ctxt->set_abort)
 			goto end;
 		else {
 			ret = ocfs2_xattr_create_index_block(inode, xs, ctxt);
@@ -3307,7 +3309,7 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 				goto out;
 			}
 			ret = ocfs2_xattr_block_set(inode, xi, xbs, ctxt);
-		} else if (ret == -ENOSPC) {
+		} else if ((ret == -ENOSPC) && !ctxt->set_abort) {
 			if (di->i_xattr_loc && !xbs->xattr_bh) {
 				ret = ocfs2_xattr_block_find(inode,
 							     xi->xi_name_index,
-- 
1.5.5

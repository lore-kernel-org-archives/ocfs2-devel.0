From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 17 Oct 2008 12:44:36 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2/xattr: Remove unused
	restore_extent_block.
In-Reply-To: <48F81730.9020809@oracle.com>
References: <48F81730.9020809@oracle.com>
Message-ID: <1224218678-32196-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Since now ocfs2 supports empty bucket, we will never remove
xattr index tree even if all the xattrs are removed, so this
function will never be called. So remove it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   48 ------------------------------------------------
 1 files changed, 0 insertions(+), 48 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8c0041e..f158280 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1809,52 +1809,6 @@ cleanup:
 }
 
 /*
- * When all the xattrs are deleted from index btree, the ocfs2_xattr_tree
- * will be erased and ocfs2_xattr_block will have its ocfs2_xattr_header
- * re-initialized.
- */
-static int ocfs2_restore_xattr_block(struct inode *inode,
-				     struct ocfs2_xattr_search *xs)
-{
-	int ret;
-	handle_t *handle;
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_xattr_block *xb =
-		(struct ocfs2_xattr_block *)xs->xattr_bh->b_data;
-	struct ocfs2_extent_list *el = &xb->xb_attrs.xb_root.xt_list;
-	u16 xb_flags = le16_to_cpu(xb->xb_flags);
-
-	BUG_ON(!(xb_flags & OCFS2_XATTR_INDEXED) ||
-		le16_to_cpu(el->l_next_free_rec) != 0);
-
-	handle = ocfs2_start_trans(osb, OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		goto out;
-	}
-
-	ret = ocfs2_journal_access(handle, inode, xs->xattr_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret < 0) {
-		mlog_errno(ret);
-		goto out_commit;
-	}
-
-	memset(&xb->xb_attrs, 0, inode->i_sb->s_blocksize -
-	       offsetof(struct ocfs2_xattr_block, xb_attrs));
-
-	xb->xb_flags = cpu_to_le16(xb_flags & ~OCFS2_XATTR_INDEXED);
-
-	ocfs2_journal_dirty(handle, xs->xattr_bh);
-
-out_commit:
-	ocfs2_commit_trans(osb, handle);
-out:
-	return ret;
-}
-
-/*
  * ocfs2_xattr_block_set()
  *
  * Set, replace or remove an extended attribute into external block.
@@ -1964,8 +1918,6 @@ out:
 	}
 
 	ret = ocfs2_xattr_set_entry_index_block(inode, xi, xs);
-	if (!ret && xblk->xb_attrs.xb_root.xt_list.l_next_free_rec == 0)
-		ret = ocfs2_restore_xattr_block(inode, xs);
 
 end:
 
-- 
1.5.4.GIT

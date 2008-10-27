From: Tiger Yang <tiger.yang@oracle.com>
Date: Mon, 27 Oct 2008 16:43:06 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: add ocfs2_xattr_set_handle
In-Reply-To: <49057D8B.5040700@oracle.com>
References: <49057D8B.5040700@oracle.com>
Message-ID: <1225096986-29668-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This function used to set xattr in a started transaction.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.h |    4 +++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 20ddf50..3567182 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2065,6 +2065,77 @@ out:
 	return ret;
 }
 
+int ocfs2_xattr_set_handle(handle_t *handle,
+			   struct inode *inode,
+			   struct buffer_head *di_bh,
+			   int name_index,
+			   const char *name,
+			   const void *value,
+			   size_t value_len,
+			   int flags,
+			   struct ocfs2_alloc_context *meta_ac,
+			   struct ocfs2_alloc_context *data_ac)
+{
+	struct ocfs2_dinode *di;
+	u16 i, blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
+	int ret, credits;
+
+	struct ocfs2_xattr_info xi = {
+		.name_index = name_index,
+		.name = name,
+		.value = value,
+		.value_len = value_len,
+	};
+
+	struct ocfs2_xattr_search xis = {
+		.not_found = -ENODATA,
+	};
+
+	struct ocfs2_xattr_search xbs = {
+		.not_found = -ENODATA,
+	};
+
+	struct ocfs2_xattr_set_ctxt ctxt = {
+		.meta_ac = meta_ac,
+		.data_ac = data_ac,
+	};
+
+	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
+	xis.inode_bh = xbs.inode_bh = di_bh;
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+
+	down_write(&OCFS2_I(inode)->ip_xattr_sem);
+
+	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
+	if (ret)
+		goto cleanup;
+	if (xis.not_found) {
+		ret = ocfs2_xattr_block_find(inode, name_index, name, &xbs);
+		if (ret)
+			goto cleanup;
+	}
+
+	credits = ocfs2_calc_xattr_set_credits(inode, &xi, &xis, &xbs);
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto cleanup;
+	}
+
+	ret = __ocfs2_xattr_set_handle(inode, handle, di, &xi,
+				       &xis, &xbs, &ctxt);
+
+cleanup:
+	up_write(&OCFS2_I(inode)->ip_xattr_sem);
+	brelse(xbs.xattr_bh);
+	for (i = 0; i < blk_per_bucket; i++)
+		brelse(xbs.bucket.bhs[i]);
+
+	return ret;
+}
+
 /*
  * ocfs2_xattr_set()
  *
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 1d8314c..8fbdc16 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -37,6 +37,10 @@ extern struct xattr_handler *ocfs2_xattr_handlers[];
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
 int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
 		    size_t, int);
+int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
+			   int, const char *, const void *, size_t, int,
+			   struct ocfs2_alloc_context *,
+			   struct ocfs2_alloc_context *);
 int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 
 #endif /* OCFS2_XATTR_H */
-- 
1.5.4.1

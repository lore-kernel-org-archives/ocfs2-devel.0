From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 30 Oct 2008 19:40:38 +0800
Subject: [Ocfs2-devel] [PATCH 07/15] ocfs2: add ocfs2_xattr_set_handle
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <1225366838-6338-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This function use to set xattr in a started transaction.
It is similar to ocfs2_xattr_set.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/xattr.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.h |    4 ++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0e380c4..8c33a3f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2319,6 +2319,87 @@ out:
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
+		.handle = handle,
+		.meta_ac = meta_ac,
+		.data_ac = data_ac,
+	};
+
+	if (!ocfs2_supports_xattr(OCFS2_SB(inode->i_sb)))
+		return -EOPNOTSUPP;
+
+	xbs.bucket = ocfs2_xattr_bucket_new(inode);
+	if (!xbs.bucket) {
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
+	}
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
+	ret = ocfs2_calc_xattr_set_need(inode, di, &xi, &xis, &xbs,
+					NULL, NULL, &credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto cleanup;
+	}
+
+	ret = ocfs2_extend_trans(handle, credits);
+	if (ret) {
+		mlog_errno(ret);
+		goto cleanup;
+	}
+
+	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
+
+cleanup:
+	up_write(&OCFS2_I(inode)->ip_xattr_sem);
+	brelse(xbs.xattr_bh);
+	ocfs2_xattr_bucket_free(xbs.bucket);
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

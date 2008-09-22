From: wangang wang <wen.gang.wang@oracle.com>
Date: Mon, 22 Sep 2008 16:18:27 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add validation in
	ocfs2_get_dentry()
Message-ID: <200809220818.m8M8IRtT004253@wengang.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

we need do more checking for validation in ocfs2_get_dentry().
1) OCFS2_INODE_DELETED flag
2) i_nlink

the patch is against 1.4 git.

Signed-off-by: Wengang wang <wen.gang.wang@oracle.com>
--
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 649f3c8..36ccf27 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -49,6 +49,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
 {
 	struct ocfs2_inode_handle *handle = vobjp;
 	struct inode *inode;
+	struct ocfs2_inode_info *oi = NULL;
 	struct dentry *result;
 
 	mlog_entry("(0x%p, 0x%p)\n", sb, handle);
@@ -68,6 +69,17 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
 		return ERR_PTR(-ESTALE);
 	}
 
+	oi = OCFS2_I(inode);
+
+	spin_lock(&oi->ip_lock);
+	if ((OCFS2_I(inode)->ip_flags & OCFS2_INODE_DELETED)
+		|| !inode->i_nlink) {
+		spin_unlock(&oi->ip_lock);
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+	spin_unlock(&oi->ip_lock);
+
 	result = d_alloc_anon(inode);
 
 	if (!result) {

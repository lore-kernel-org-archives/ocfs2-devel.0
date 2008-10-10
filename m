From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  9 Oct 2008 17:20:32 -0700
Subject: [Ocfs2-devel] [PATCH 4/6] ocfs2: Move ocfs2_bread() into dir.c
In-Reply-To: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
References: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1223598034-26284-5-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dir.c is the only place using ocfs2_bread(), so let's make it static to
that file.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/inode.c |   51 ---------------------------------------------------
 fs/ocfs2/inode.h |    2 --
 3 files changed, 45 insertions(+), 53 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 00d7ed8..9202525 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -207,6 +207,51 @@ out:
 	return NULL;
 }
 
+static struct buffer_head *ocfs2_bread(struct inode *inode, int block,
+				       int *err, int reada)
+{
+	struct buffer_head *bh = NULL;
+	int tmperr;
+	u64 p_blkno;
+	int readflags = OCFS2_BH_CACHED;
+
+	if (reada)
+		readflags |= OCFS2_BH_READAHEAD;
+
+	if (((u64)block << inode->i_sb->s_blocksize_bits) >=
+	    i_size_read(inode)) {
+		BUG_ON(!reada);
+		return NULL;
+	}
+
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
+	tmperr = ocfs2_extent_map_get_blocks(inode, block, &p_blkno, NULL,
+					     NULL);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
+	if (tmperr < 0) {
+		mlog_errno(tmperr);
+		goto fail;
+	}
+
+	tmperr = ocfs2_read_blocks(inode, p_blkno, 1, &bh, readflags);
+	if (tmperr < 0)
+		goto fail;
+
+	tmperr = 0;
+
+	*err = 0;
+	return bh;
+
+fail:
+	if (bh) {
+		brelse(bh);
+		bh = NULL;
+	}
+	*err = -EIO;
+	return NULL;
+}
+
+
 static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
 					       struct inode *dir,
 					       struct ocfs2_dir_entry **res_dir)
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 00d8493..463c52d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1114,57 +1114,6 @@ void ocfs2_drop_inode(struct inode *inode)
 }
 
 /*
- * TODO: this should probably be merged into ocfs2_get_block
- *
- * However, you now need to pay attention to the cont_prepare_write()
- * stuff in ocfs2_get_block (that is, ocfs2_get_block pretty much
- * expects never to extend).
- */
-struct buffer_head *ocfs2_bread(struct inode *inode,
-				int block, int *err, int reada)
-{
-	struct buffer_head *bh = NULL;
-	int tmperr;
-	u64 p_blkno;
-	int readflags = OCFS2_BH_CACHED;
-
-	if (reada)
-		readflags |= OCFS2_BH_READAHEAD;
-
-	if (((u64)block << inode->i_sb->s_blocksize_bits) >=
-	    i_size_read(inode)) {
-		BUG_ON(!reada);
-		return NULL;
-	}
-
-	down_read(&OCFS2_I(inode)->ip_alloc_sem);
-	tmperr = ocfs2_extent_map_get_blocks(inode, block, &p_blkno, NULL,
-					     NULL);
-	up_read(&OCFS2_I(inode)->ip_alloc_sem);
-	if (tmperr < 0) {
-		mlog_errno(tmperr);
-		goto fail;
-	}
-
-	tmperr = ocfs2_read_blocks(inode, p_blkno, 1, &bh, readflags);
-	if (tmperr < 0)
-		goto fail;
-
-	tmperr = 0;
-
-	*err = 0;
-	return bh;
-
-fail:
-	if (bh) {
-		brelse(bh);
-		bh = NULL;
-	}
-	*err = -EIO;
-	return NULL;
-}
-
-/*
  * This is called from our getattr.
  */
 int ocfs2_inode_revalidate(struct dentry *dentry)
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 3b2eb2a..e189147 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -114,8 +114,6 @@ extern struct kmem_cache *ocfs2_inode_cache;
 
 extern const struct address_space_operations ocfs2_aops;
 
-struct buffer_head *ocfs2_bread(struct inode *inode, int block,
-				int *err, int reada);
 void ocfs2_clear_inode(struct inode *inode);
 void ocfs2_delete_inode(struct inode *inode);
 void ocfs2_drop_inode(struct inode *inode);
-- 
1.5.6.5

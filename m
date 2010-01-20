From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 20 Jan 2010 11:31:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Sync max_inline_data_with_xattr from
	tools.
Message-ID: <1263958271-15826-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2-tools, we have added ocfs2_max_inline_data_with_xattr,
so add it in the kernel's ocfs2_fs.h.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 1a1a679..7638a38 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -1417,9 +1417,16 @@ static inline int ocfs2_fast_symlink_chars(int blocksize)
 	return blocksize - offsetof(struct ocfs2_dinode, id2.i_symlink);
 }
 
-static inline int ocfs2_max_inline_data(int blocksize)
+static inline int ocfs2_max_inline_data_with_xattr(int blocksize,
+						   struct ocfs2_dinode *di)
 {
-	return blocksize - offsetof(struct ocfs2_dinode, id2.i_data.id_data);
+	if (di && (di->i_dyn_features & OCFS2_INLINE_XATTR_FL))
+		return blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data) -
+			di->i_xattr_inline_size;
+	else
+		return blocksize -
+			offsetof(struct ocfs2_dinode, id2.i_data.id_data);
 }
 
 static inline int ocfs2_extent_recs_per_inode(int blocksize)
-- 
1.6.3.3

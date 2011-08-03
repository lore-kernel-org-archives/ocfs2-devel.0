From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Wed, 3 Aug 2011 17:49:04 -0500
Subject: [Ocfs2-devel] [PATCH 1/3] Introduce ocfs2_dx_dir_disable()
Message-ID: <CAJtY7HVkdJ2JEokHxEqTMnT9fQz9=n-oKia7e2jdCqCA8Z4LwQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Disables ocfs2 directory indexing in ocfs2_inode_info. This function is
to be called in case of an error/corruption in index directory traversal.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
 fs/ocfs2/dir.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8582e3f..fdb4ed9 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -163,6 +163,19 @@ static void ocfs2_init_dir_trailer(struct inode *inode,
 	trailer->db_blkno = cpu_to_le64(bh->b_blocknr);
 	trailer->db_free_rec_len = cpu_to_le16(rec_len);
 }
+
+/* Called only when an error occurs with reading indexed directories.
+ * The function just disables the directory indexing in ocfs2_inode_info
+ */
+static void ocfs2_dx_dir_disable(struct inode *dir)
+{
+	struct ocfs2_inode_info *oi = OCFS2_I(dir);
+	mlog(ML_ERROR, "Disabling index for directory <%llu> due to"
+			" corruption. Please execute fsck.ocfs2\n",
+			oi->ip_blkno);
+	oi->ip_dyn_features &= ~OCFS2_INDEXED_DIR_FL;
+}
+
 /*
  * Link an unindexed block with a dir trailer structure into the index free
  * list. This function will modify dirdata_bh, but assumes you've already
-- 
1.7.6

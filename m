From: Jan Kara <jack@suse.cz>
Date: Mon, 27 Jul 2009 19:53:30 +0200
Subject: [Ocfs2-devel] [PATCH 2/8] Provide
	ocfs2_cached_inode_extend_allocation()
In-Reply-To: <1248717216-26617-1-git-send-email-jack@suse.cz>
References: <1248717216-26617-1-git-send-email-jack@suse.cz>
Message-ID: <1248717216-26617-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So far we had only ocfs2_extend_allocation() which read the inode from
disk. Provide also the cached variant.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/ocfs2/ocfs2.h  |    2 +
 libocfs2/extend_file.c |   51 ++++++++++++++++++++++++++---------------------
 2 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/include/ocfs2/ocfs2.h b/include/ocfs2/ocfs2.h
index 4dbbf43..ac16823 100644
--- a/include/ocfs2/ocfs2.h
+++ b/include/ocfs2/ocfs2.h
@@ -505,6 +505,8 @@ errcode_t ocfs2_delete_extent_block(ocfs2_filesys *fs, uint64_t blkno);
  */
 errcode_t ocfs2_extend_allocation(ocfs2_filesys *fs, uint64_t ino,
 				  uint32_t new_clusters);
+/* Ditto for cached inode */
+errcode_t ocfs2_cached_inode_extend_allocation(ocfs2_cached_inode *ci, uint32_t new_clusters);
 /* Extend the file to the new size. No clusters will be allocated. */
 errcode_t ocfs2_extend_file(ocfs2_filesys *fs, uint64_t ino, uint64_t new_size);
 
diff --git a/libocfs2/extend_file.c b/libocfs2/extend_file.c
index a27b478..c2029d4 100644
--- a/libocfs2/extend_file.c
+++ b/libocfs2/extend_file.c
@@ -3764,29 +3764,16 @@ out:
 	return ret;
 }
 
-errcode_t ocfs2_extend_allocation(ocfs2_filesys *fs, uint64_t ino,
-				  uint32_t new_clusters)
+errcode_t ocfs2_cached_inode_extend_allocation(ocfs2_cached_inode *ci,
+					       uint32_t new_clusters)
 {
 	errcode_t ret = 0;
 	uint32_t n_clusters = 0, cpos;
 	uint64_t blkno, file_size;
 	char *buf = NULL;
-	struct ocfs2_dinode* di = NULL;
-
-	if (!(fs->fs_flags & OCFS2_FLAG_RW))
-		return OCFS2_ET_RO_FILESYS;
-
-	ret = ocfs2_malloc_block(fs->fs_io, &buf);
-	if (ret)
-		goto out_free_buf;
-
-	ret = ocfs2_read_inode(fs, ino, buf);
-	if (ret)
-		goto out_free_buf;
-
-	di = (struct ocfs2_dinode *)buf;
+	ocfs2_filesys *fs = ci->ci_fs;
 
-	file_size = di->i_size;
+	file_size = ci->ci_inode->i_size;
 	cpos = (file_size + fs->fs_clustersize - 1) / fs->fs_clustersize;
 	while (new_clusters) {
 		n_clusters = 1;
@@ -3795,23 +3782,41 @@ errcode_t ocfs2_extend_allocation(ocfs2_filesys *fs, uint64_t ino,
 		if (ret)
 			break;
 
-		ret = ocfs2_insert_extent(fs, ino, cpos, blkno, n_clusters,
-					  0);
+		ret = ocfs2_cached_inode_insert_extent(ci, cpos, blkno,
+						       n_clusters, 0);
 		if (ret) {
 			/* XXX: We don't wan't to overwrite the error
 			 * from insert_extent().  But we probably need
 			 * to BE LOUDLY UPSET. */
 			ocfs2_free_clusters(fs, n_clusters, blkno);
-			goto out_free_buf;
+			break;
 		}
 
 	 	new_clusters -= n_clusters;
 		cpos += n_clusters;
 	}
+	return ret;
+}
+
+errcode_t ocfs2_extend_allocation(ocfs2_filesys *fs, uint64_t ino,
+				  uint32_t new_clusters)
+{
+	errcode_t ret;
+	ocfs2_cached_inode *ci = NULL;
+
+	ret = ocfs2_read_cached_inode(fs, ino, &ci);
+	if (ret)
+		goto bail;
+
+	ret = ocfs2_cached_inode_extend_allocation(ci, new_clusters);
+	if (ret)
+		goto bail;
+
+	ret = ocfs2_write_cached_inode(fs, ci);
+bail:
+	if (ci)
+		ocfs2_free_cached_inode(fs, ci);
 
-out_free_buf:
-	if (buf)
-		ocfs2_free(&buf);
 	return ret;
 }
 
-- 
1.6.0.2

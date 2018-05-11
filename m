From: Guozhonghua <guozhonghua@h3c.com>
Date: Fri, 11 May 2018 01:30:51 +0000
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Correct the comments position of
 the structure ocfs2_dir_block_trailer.
Message-ID: <71604351584F6A4EBAE558C676F37CA401071C5FDE@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Correct the comments position of the structure ocfs2_dir_block_trailer.

Signed-off-by: guozhonghua <guozhonghua@h3c.com>
---
 fs/ocfs2/ocfs2_fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h index 5bb4a89..7071ad0 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -807,11 +807,11 @@ struct ocfs2_dir_block_trailer {
 						 * in this block. (unused) */
 /*10*/	__u8		db_signature[8];	/* Signature for verification */
 	__le64		db_reserved2;
-	__le64		db_free_next;		/* Next block in list (unused) */
-/*20*/	__le64		db_blkno;		/* Offset on disk, in blocks */
-	__le64		db_parent_dinode;	/* dinode which owns me, in
+/*20*/	__le64		db_free_next;		/* Next block in list (unused) */
+	__le64		db_blkno;		/* Offset on disk, in blocks */
+/*30*/	__le64		db_parent_dinode;	/* dinode which owns me, in
 						   blocks */
-/*30*/	struct ocfs2_block_check db_check;	/* Error checking */
+	struct ocfs2_block_check db_check;	/* Error checking */
 /*40*/
 };
 
--
1.7.9.5

From: piaojun <piaojun@huawei.com>
Date: Sat, 20 May 2017 09:56:02 +0800
Subject: [Ocfs2-devel] [PATCH] o2image: back-up xattr tree for regular file
Message-ID: <591FA232.3000502@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

when traversing regular file's inode with xattr btree in
traverse_inode(), we will get into traverse_chains() rather than
traverse_xb(). so xattr tree is not back-up actually.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 o2image/o2image.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/o2image/o2image.c b/o2image/o2image.c
index ee62acf..c56bbcf 100644
--- a/o2image/o2image.c
+++ b/o2image/o2image.c
@@ -256,9 +256,16 @@ static errcode_t traverse_inode(ocfs2_filesys *ofs, uint64_t inode)
 	 *
 	 * NOTE: we do need to handle its xattr btree if exists.
 	 */
-	if (!S_ISDIR(di->i_mode) && !(di->i_flags & OCFS2_SYSTEM_FL) &&
-	    !(di->i_dyn_features & OCFS2_HAS_XATTR_FL))
+	if (!S_ISDIR(di->i_mode) && !(di->i_flags & OCFS2_SYSTEM_FL)) {
+		if ((di->i_dyn_features & OCFS2_HAS_XATTR_FL) && di->i_xattr_loc) {
+			/* traverse xattr btree to map bucket leaves */
+			ret = traverse_xb(ofs, di->i_xattr_loc);
+			if (ret)
+				com_err(program_name, ret, "while traversing xattr tree"
+					" %"PRIu64"", inode);
+		}
 		goto out;
+	}

 	/* Read and traverse group descriptors */
 	if (di->i_flags & OCFS2_SYSTEM_FL)
@@ -291,9 +298,6 @@ static errcode_t traverse_inode(ocfs2_filesys *ofs, uint64_t inode)
 		ret = traverse_chains(ofs, &(di->id2.i_chain), dump_type);
 	else if (di->i_flags & OCFS2_DEALLOC_FL)
 		ret = mark_dealloc_bits(ofs, &(di->id2.i_dealloc));
-	else if ((di->i_dyn_features & OCFS2_HAS_XATTR_FL) && di->i_xattr_loc)
-		/* Do need to traverse xattr btree to map bucket leaves */
-		ret = traverse_xb(ofs, di->i_xattr_loc);
 	else {
 		/*
 		 * Don't check superblock flag for the dir indexing
@@ -318,11 +322,9 @@ static errcode_t traverse_inode(ocfs2_filesys *ofs, uint64_t inode)
 	}

 out_error:
-	if (ret) {
+	if (ret)
 		com_err(program_name, ret, "while scanning inode %"PRIu64"",
 			inode);
-		goto out;
-	}
 out:
 	if (buf)
 		ocfs2_free(&buf);
-- 

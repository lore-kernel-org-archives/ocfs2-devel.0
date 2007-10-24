From: Adrian Bunk <bunk@kernel.org>
Date: Wed Oct 24 09:23:27 2007
Subject: [Ocfs2-devel] [2.6 patch] make ocfs2_find_entry_el() static
Message-ID: <20071024162327.GP30533@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>, Joel Becker <joel.becker@oracle.com>, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

ocfs2_find_entry_el() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d7cac5a6c6884a16fe6fac7b6116f4a41ad7f309 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6a2f143..63b28fd 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -208,9 +208,9 @@ out:
 	return NULL;
 }
 
-struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
-					struct inode *dir,
-					struct ocfs2_dir_entry **res_dir)
+static struct buffer_head *ocfs2_find_entry_el(const char *name, int namelen,
+					       struct inode *dir,
+					       struct ocfs2_dir_entry **res_dir)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];

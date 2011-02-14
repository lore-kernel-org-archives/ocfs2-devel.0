From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 14 Feb 2011 00:21:41 -0600
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
Message-ID: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_zero_extend() extends the file from the next page offset
rather from the current file size. zero_extend_page() should
call ocfs2_zero_partial_cluster() to set zero rest of the cluster
when the file size is within the page boundaries.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a665195..5a2223e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -63,6 +63,8 @@
 #include "refcounttree.h"

 #include "buffer_head_io.h"
+static int ocfs2_zero_partial_clusters(struct inode *inode,
+				       u64 start, u64 len);

 static int ocfs2_init_file_private(struct inode *inode, struct file *file)
 {
@@ -960,11 +962,21 @@ int ocfs2_zero_extend(struct inode *inode,
struct buffer_head *di_bh,
 	int ret = 0;
 	u64 zero_start, range_start = 0, range_end = 0;
 	struct super_block *sb = inode->i_sb;
+	u64 current_size = i_size_read(inode), len;

 	zero_start = ocfs2_align_bytes_to_blocks(sb, i_size_read(inode));
 	mlog(0, "zero_start %llu for i_size %llu\n",
 	     (unsigned long long)zero_start,
 	     (unsigned long long)i_size_read(inode));
+
+	len = ocfs2_align_bytes_to_clusters(sb, current_size) - current_size;
+	if (len) {
+		ret = ocfs2_zero_partial_clusters(inode, current_size, len);
+		if (ret)
+			goto out;
+		zero_start = ocfs2_align_bytes_to_clusters(sb, current_size);
+	}
+
 	while (zero_start < zero_to_size) {
 		ret = ocfs2_zero_extend_get_range(inode, di_bh, zero_start,
 						  zero_to_size,
@@ -990,7 +1002,7 @@ int ocfs2_zero_extend(struct inode *inode, struct
buffer_head *di_bh,
 		}
 		zero_start = range_end;
 	}
-
+out:
 	return ret;
 }


-- 
Goldwyn

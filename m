From: Tao Ma <tm@tao.ma>
Date: Mon, 24 Jan 2011 23:23:30 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: optimize ocfs2_check_dir_entry() with
	unlikely() annotations
Message-ID: <1295882610-12542-1-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

In cad3f00, ext4_check_dir_entry was modified by adding some unlikely.
Ted described it as "This function gets called a lot for large
directories, and the answer is almost always 'no, no, there's no problem'.
This means using unlikely() is a good thing."
ext3 added the similar change in commit a4ae309.

So change it accordingly in ocfs2.

Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/dir.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d417b3f..41b356f 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -322,21 +322,23 @@ static int ocfs2_check_dir_entry(struct inode * dir,
 	const char *error_msg = NULL;
 	const int rlen = le16_to_cpu(de->rec_len);
 
-	if (rlen < OCFS2_DIR_REC_LEN(1))
+	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
-	else if (rlen % 4 != 0)
+	else if (unlikely(rlen % 4 != 0))
 		error_msg = "rec_len % 4 != 0";
-	else if (rlen < OCFS2_DIR_REC_LEN(de->name_len))
+	else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
 		error_msg = "rec_len is too small for name_len";
-	else if (((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize)
+	else if (unlikely(
+		 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
 		error_msg = "directory entry across blocks";
 
-	if (error_msg != NULL)
+	if (unlikely(error_msg != NULL))
 		mlog(ML_ERROR, "bad entry in directory #%llu: %s - "
 		     "offset=%lu, inode=%llu, rec_len=%d, name_len=%d\n",
 		     (unsigned long long)OCFS2_I(dir)->ip_blkno, error_msg,
 		     offset, (unsigned long long)le64_to_cpu(de->inode), rlen,
 		     de->name_len);
+
 	return error_msg == NULL ? 1 : 0;
 }
 
-- 
1.7.1

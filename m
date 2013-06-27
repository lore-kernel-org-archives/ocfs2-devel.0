From: Jensen <shencanquan@huawei.com>
Date: Thu, 27 Jun 2013 11:28:47 +0800
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: llseek requires to ocfs2 inode lock
 for the file in SEEK_END
Message-ID: <51CBB16F.6080906@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

llseek requires ocfs2 inode lock for updating the file size in SEEK_END.
because the file size maybe update on another node.
if it not . after call llseek in SEEK_END. the position is old.

this bug can be reproduce the following scenario:
at first ,we dd a test fileA,the file size is 10k.
on NodeA:
---------
1) open the test fileA, lseek the end of file. and print the position.
2) close the test fileA

on NodeB:
1) open the test fileA, append the 5k data to test FileA.
2) lseek the end of file. and print the position.
3) close file.

at first we run the test program1 on NodeA , the result is 10k.
and then run the test program2 on NodeB,  the result is 15k.
at last, we run the test program1 on NodeA again, the result is 10k.

after apply this patch.  the three step result is 15k.

Signed-off-by: Jensen <shencanquan@huawei.com>
---
 fs/ocfs2/file.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ff54014..6ef4f2e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2626,7 +2626,16 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
 	case SEEK_SET:
 		break;
 	case SEEK_END:
-		offset += inode->i_size;
+		/* SEEK_END requires the OCFS2 inode lock for the file
+		 * because it references the file's size.
+		 */
+		ret = ocfs2_inode_lock(inode, NULL, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+		offset += i_size_read(inode);
+		ocfs2_inode_unlock(inode, 0);
 		break;
 	case SEEK_CUR:
 		if (offset == 0) {
-- 
1.7.9.7

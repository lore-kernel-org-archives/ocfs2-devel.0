From: shencanquan <shencanquan@huawei.com>
Date: Wed, 19 Jun 2013 18:38:41 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: llseek need to require ocfs2 inode
 lock for updating the size in SEEK_END
Message-ID: <51C18A31.40008@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The test scenario is following:

There are two node, one is nodeA, another is nodeB
On nodeA, the test program open the file and write some data to the
file and then close the file.
On nodeB, the another test program open the file and llseek the end of
file. we found that the position of file is old.

After apply this patch. it is ok on nodeB. the position of file is
update to date.

Signed-off-by: jensen <shencanquan@huawei.com>
---
 fs/ocfs2/file.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ff54014..f2570ba 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2626,7 +2626,16 @@ static loff_t ocfs2_file_llseek(struct file *file, loff_t offset, int whence)
 	case SEEK_SET:
 		break;
 	case SEEK_END:
+		/* SEEK_END requires the OCFS2 inode lock because
+		 * it uses the inode size.
+		*/
+		ret = ocfs2_inode_lock(inode, NULL, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
 		offset += inode->i_size;
+		ocfs2_inode_unlock(inode, 0);
 		break;
 	case SEEK_CUR:
 		if (offset == 0) {
-- 
1.7.9.7

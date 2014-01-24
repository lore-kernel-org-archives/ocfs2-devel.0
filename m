From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:47:09 -0800
Subject: [Ocfs2-devel] [patch 09/11] ocfs2: llseek requires ocfs2 inode lock
	for the file in SEEK_END
Message-ID: <20140124204709.85C895A4203@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jensen <shencanquan@huawei.com>
Subject: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END

llseek requires ocfs2 inode lock for updating the file size in SEEK_END. 
because the file size maybe update on another node.

This bug can be reproduce the following scenario: at first, we dd a test
fileA, the file size is 10k.

on NodeA:
---------
1) open the test fileA, lseek the end of file. and print the position.
2) close the test fileA

on NodeB:
1) open the test fileA, append the 5k data to test FileA.
2) lseek the end of file. and print the position.
3) close file.

At first we run the test program1 on NodeA , the result is 10k.  And then
run the test program2 on NodeB, the result is 15k.  At last, we run the
test program1 on NodeA again, the result is 10k.

After applying this patch the three step result is 15k.

Signed-off-by: Jensen <shencanquan@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end
+++ a/fs/ocfs2/file.c
@@ -2626,7 +2626,16 @@ static loff_t ocfs2_file_llseek(struct f
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
_

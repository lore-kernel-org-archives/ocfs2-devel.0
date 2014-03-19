From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 19 Mar 2014 14:10:07 -0700
Subject: [Ocfs2-devel] [patch 8/8] ocfs2: llseek requires ocfs2 inode lock
	for the file in SEEK_END
Message-ID: <20140319211007.82EB931C1E1@corp2gmr1-1.hot.corp.google.com>
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

test result: 1000000 times lseek call;
index        lseek with inode lock (unit:us)                lseek without inode lock (unit:us)
  1                   1168162                                    555383
  2                   1168011                                    549504
  3                   1170538                                    549396
  4                   1170375                                    551685
  5                   1170444                                    556719
  6                   1174364                                    555307
  7                   1163294                                    551552
  8                   1170080                                    549350
  9                   1162464                                    553700
 10                   1165441                                    552594
 avg                  1168317                                    552519

avg with lock - avg without lock = 615798
(avg with lock - avg without lock)/1000000=0.615798 us

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
@@ -2637,7 +2637,16 @@ static loff_t ocfs2_file_llseek(struct f
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

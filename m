From: shencanquan <shencanquan@huawei.com>
Date: Mon, 17 Jun 2013 22:48:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek need to inode cluster lock and
 unlock for update the inode size in SEEK_END.
Message-ID: <51BF21D6.9080008@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>
Cc: linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

We found that llseek has a bug when in SEEK_END.  it need to add the 
inode lock and unlock.
This bug can be reproduce the following scenario:
On one nodeA, open the file and then write some data to file and close 
the file .
On another nodeB , open the file and llseek the end of file . the 
position of file is old.

Signed-off-by: jensen <shencanquan@huawei.com>
---
  file.c |    7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/file.c b/file.c
index ff54014..4ee7c80 100644
--- a/file.c
+++ b/file.c
@@ -2626,6 +2626,13 @@ static loff_t ocfs2_file_llseek(struct file 
*file, loff_t offset, int whence)
      case SEEK_SET:
          break;
      case SEEK_END:
+        /*need to inode lock and unlock for update the inode size.*/
+        ret = ocfs2_inode_lock(inode, NULL, 0);
+        if (ret < 0) {
+            mlog_errno(ret);
+            goto out;
+        }
+        ocfs2_inode_unlock(inode, 0);
          offset += inode->i_size;
          break;
      case SEEK_CUR:
-- 
1.7.9.7

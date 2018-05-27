From: Changwei Ge <gechangwei@live.cn>
Date: Sun, 27 May 2018 03:16:52 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix a misuse a of brelse after failing
 ocfs2_check_dir_entry
Message-ID: <HK2PR06MB04522E81177A3E01EF47A828D56F0@HK2PR06MB0452.apcprd06.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "mark@fasheh.com" <mark@fasheh.com>, "jiangqi903@gmail.com" <jiangqi903@gmail.com>, "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>
Cc: Changwei Ge <ge.changwei@h3c.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>

From: Changwei Ge <ge.changwei@h3c.com>

Somehow, file system metadata was corrupted, which causes
ocfs2_check_dir_entry() to fail in function ocfs2_dir_foreach_blk_el().

According to the original design intention, if above happens we should
skip the problematic block and continue to retrieve dir entry. But there
is obviouse misuse of brelse around related code.

After failure of ocfs2_check_dir_entry(), currunt code just moves to next
position and uses the problematic buffer head again and again during
which the problematic buffer head is released for multiple times. I
suppose, this a serious issue which is long-lived in ocfs2. This may
cause other file systems which is also used in a the same host insane.

So we should also consider about bakcporting this patch into
linux -stable.

Suggested-by: Changkuo Shi <shi.changkuo@h3c.com>
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index b048d4f..c121abb 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1897,8 +1897,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 				/* On error, skip the f_pos to the
 				   next block. */
 				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
-				brelse(bh);
-				continue;
+				break;
 			}
 			if (le64_to_cpu(de->inode)) {
 				unsigned char d_type = DT_UNKNOWN;
-- 
2.7.4

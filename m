From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 16 Apr 2010 13:59:25 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reset status if we want to restart
	file extension.
Message-ID: <1271397565-13104-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In __ocfs2_extend_allocation, we will restart our file extension
if ((!status) && restart_func). But there is a bug that the
status is still left as -EGAIN. This is really an old bug,
but it is masked by the return value of ocfs2_journal_dirty.
So it show up when we make ocfs2_journal_dirty void.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 19d16f2..6342f42 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -678,6 +678,7 @@ restarted_transaction:
 		if (why == RESTART_META) {
 			mlog(0, "restarting function.\n");
 			restart_func = 1;
+			status = 0;
 		} else {
 			BUG_ON(why != RESTART_TRANS);
 
-- 
1.5.5

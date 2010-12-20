From: Tao Ma <tm@tao.ma>
Date: Mon, 20 Dec 2010 16:21:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Release buffer_head in case of error
	in ocfs2_double_lock.
Message-ID: <1292833271-9834-1-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

In ocfs2_double_lock, when ocfs2_inode_lock for inode1 fails, we
just unlock inode2 and return without releasing buffer we get from
inode_lock(inode2). The good thing is that it is freed by the only
caller ocfs2_rename when it exits.

But I don't think this is a right way for error handling. We should
free the buffer_head we get in ocfs2_double_lock before exit so that
the caller doesn't need to take care of it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/namei.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index ff5744e..ca35f81 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1017,8 +1017,11 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 		 * An error return must mean that no cluster locks
 		 * were held on function exit.
 		 */
-		if (oi1->ip_blkno != oi2->ip_blkno)
+		if (oi1->ip_blkno != oi2->ip_blkno) {
 			ocfs2_inode_unlock(inode2, 1);
+			brelse(*bh2);
+			*bh2 = NULL;
+		}
 
 		if (status != -ENOENT)
 			mlog_errno(status);
-- 
1.6.3.GIT

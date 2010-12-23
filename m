From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:58 +0800
Subject: [Ocfs2-devel] [PATCH 15/34] ocfs2: Little refactoring against
	ocfs2_iget.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-15-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <boyu.mt@taobao.com>

ocfs2_iget is used to get/create inode. Only iget5_locked
will give us an inode = NULL. So move this check ahead of
ocfs2_read_locked_inode so that we don't need to check
inode before we read and unlock inode. This is also helpful
for trace event(see the next patch).

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ocfs2/inode.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f5c0f34..361efd3 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -152,16 +152,16 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 	/* inode was *not* in the inode cache. 2.6.x requires
 	 * us to do our own read_inode call and unlock it
 	 * afterwards. */
-	if (inode && inode->i_state & I_NEW) {
-		mlog(0, "Inode was not in inode cache, reading it.\n");
-		ocfs2_read_locked_inode(inode, &args);
-		unlock_new_inode(inode);
-	}
 	if (inode == NULL) {
 		inode = ERR_PTR(-ENOMEM);
 		mlog_errno(PTR_ERR(inode));
 		goto bail;
 	}
+	if (inode->i_state & I_NEW) {
+		mlog(0, "Inode was not in inode cache, reading it.\n");
+		ocfs2_read_locked_inode(inode, &args);
+		unlock_new_inode(inode);
+	}
 	if (is_bad_inode(inode)) {
 		iput(inode);
 		inode = ERR_PTR(-ESTALE);
-- 
1.7.0.4

From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 17 Feb 2009 04:39:28 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use the right access_* method in ctime
	update of xattr.
Message-ID: <1234816768-8571-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ctime updating of xattr, it use the wrong type of access for
inode, so use ocfs2_journal_access_di instead.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 915039f..e393315 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2592,8 +2592,9 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 
 	if (!ret) {
 		/* Update inode ctime. */
-		ret = ocfs2_journal_access(ctxt->handle, inode, xis->inode_bh,
-					   OCFS2_JOURNAL_ACCESS_WRITE);
+		ret = ocfs2_journal_access_di(ctxt->handle, inode,
+					      xis->inode_bh,
+					      OCFS2_JOURNAL_ACCESS_WRITE);
 		if (ret) {
 			mlog_errno(ret);
 			goto out;
-- 
1.5.5

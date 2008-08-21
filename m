From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 14:14:27 +0800
Subject: [Ocfs2-devel] [PATCH] Go to the right place when we fail in
	ocfs2_expand_inline_dir.
Message-ID: <1219299267-11640-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we fail to insert extent in ocfs2_expand_inline_dir, we should
go to out_commit, not out.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8a18758..8e9c4a4 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1310,7 +1310,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 				  NULL);
 	if (ret) {
 		mlog_errno(ret);
-		goto out;
+		goto out_commit;
 	}
 
 	ret = ocfs2_journal_dirty(handle, di_bh);
@@ -1336,7 +1336,7 @@ static int ocfs2_expand_inline_dir(struct inode *dir, struct buffer_head *di_bh,
 					  len, 0, NULL);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto out_commit;
 		}
 	}
 
-- 
1.5.4.1

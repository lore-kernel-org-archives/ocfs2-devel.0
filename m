From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 24 Oct 2008 07:57:28 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/xattr: Fix check of return value of
	ocfs2_start_trans().
Message-ID: <1224806248-4405-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	this should be in your xattr-28 branch I think.

On failure, ocfs2_start_trans() returns values like ERR_PTR(-ENOMEM),
so we should check whether handle is NULL. Fix them to use IS_ERR().
Jan has made the patch for other part in ocfs2(thank Jan for it), so
this is just the fix for fs/ocfs2/xattr.c. 

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 789fb70..a371c01 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4092,7 +4092,7 @@ static int ocfs2_xattr_value_update_size(struct inode *inode,
 	handle_t *handle = NULL;
 
 	handle = ocfs2_start_trans(osb, 1);
-	if (handle == NULL) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
@@ -4259,7 +4259,7 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (handle == NULL) {
+	if (IS_ERR(handle)) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
 		goto out;
-- 
1.5.4.GIT

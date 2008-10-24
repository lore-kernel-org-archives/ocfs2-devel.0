From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:08:12 +0200
Subject: [Ocfs2-devel] [PATCH 19/29] ocfs2: Fix check of return value of
	ocfs2_start_trans()
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <12248861042458-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On failure, ocfs2_start_trans() returns values like ERR_PTR(-ENOMEM).
Thus checks for !handle are wrong. Fix them to use IS_ERR().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8d3225a..e135da1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -247,8 +247,8 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	mlog_entry_void();
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -312,8 +312,8 @@ static int ocfs2_simple_size_update(struct inode *inode,
 	handle_t *handle = NULL;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1056,8 +1056,8 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1260,8 +1260,8 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1353,8 +1353,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
 		goto out;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
-- 
1.5.2.4

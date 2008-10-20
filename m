From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:51 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix check of return value of
	ocfs2_start_trans()
In-Reply-To: y
References: y
Message-ID: <12245234424005-git-send-email-jack@suse.cz>
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
index ec2ed15..89dc20e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -246,8 +246,8 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	mlog_entry_void();
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -311,8 +311,8 @@ static int ocfs2_simple_size_update(struct inode *inode,
 	handle_t *handle = NULL;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1209,8 +1209,8 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1412,8 +1412,8 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1505,8 +1505,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
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

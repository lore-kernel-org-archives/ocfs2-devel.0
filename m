From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 13 Jan 2009 17:47:06 -0800
Subject: [Ocfs2-devel] [PATCH 01/15] ocfs2: Fix check of return value of
	ocfs2_start_trans()
In-Reply-To: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
References: <1231897640-31410-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1231897640-31410-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jan Kara <jack@suse.cz>

Mainline commit fa38e92cb34e27e60d0faf1035934eb9b44aa1d4

On failure, ocfs2_start_trans() returns values like ERR_PTR(-ENOMEM).
Thus checks for !handle are wrong. Fix them to use IS_ERR().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/file.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6877dea..2871b45 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -252,8 +252,8 @@ int ocfs2_update_inode_atime(struct inode *inode,
 	mlog_entry_void();
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -317,8 +317,8 @@ static int ocfs2_simple_size_update(struct inode *inode,
 	handle_t *handle = NULL;
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1212,8 +1212,8 @@ static int __ocfs2_write_remove_suid(struct inode *inode,
 		   (unsigned long long)OCFS2_I(inode)->ip_blkno, inode->i_mode);
 
 	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1415,8 +1415,8 @@ static int __ocfs2_remove_inode_range(struct inode *inode,
 	}
 
 	handle = ocfs2_start_trans(osb, OCFS2_REMOVE_EXTENT_CREDITS);
-	if (handle == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
 		mlog_errno(ret);
 		goto out;
 	}
@@ -1508,8 +1508,8 @@ static int ocfs2_zero_partial_clusters(struct inode *inode,
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
1.5.6.3

From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:54 -0800
Subject: [Ocfs2-devel] [PATCH 17/18] ocfs2: Use proper journal_access
	function in xattr.c
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-18-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Change the rest of the naked ocfs2_journal_access() calls in
fs/ocfs2/xattr.c to use the appropriate ocfs2_journal_access_*() call
for their metadata type.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 7b61c1c..b75522e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1894,8 +1894,8 @@ int ocfs2_xattr_remove(struct inode *inode, struct buffer_head *di_bh)
 		mlog_errno(ret);
 		goto out;
 	}
-	ret = ocfs2_journal_access(handle, inode, di_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_di(handle, inode, di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
@@ -2103,8 +2103,8 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 	int ret;
 
 	if (!xs->xattr_bh) {
-		ret = ocfs2_journal_access(handle, inode, xs->inode_bh,
-					   OCFS2_JOURNAL_ACCESS_CREATE);
+		ret = ocfs2_journal_access_di(handle, inode, xs->inode_bh,
+					      OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto end;
@@ -2121,8 +2121,8 @@ static int ocfs2_xattr_block_set(struct inode *inode,
 		new_bh = sb_getblk(inode->i_sb, first_blkno);
 		ocfs2_set_new_buffer_uptodate(inode, new_bh);
 
-		ret = ocfs2_journal_access(handle, inode, new_bh,
-					   OCFS2_JOURNAL_ACCESS_CREATE);
+		ret = ocfs2_journal_access_xb(handle, inode, new_bh,
+					      OCFS2_JOURNAL_ACCESS_CREATE);
 		if (ret < 0) {
 			mlog_errno(ret);
 			goto end;
@@ -3383,8 +3383,8 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	 */
 	down_write(&oi->ip_alloc_sem);
 
-	ret = ocfs2_journal_access(handle, inode, xb_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_xb(handle, inode, xb_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
@@ -4222,8 +4222,8 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 
 	ocfs2_init_xattr_tree_extent_tree(&et, inode, root_bh);
 
-	ret = ocfs2_journal_access(handle, inode, root_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_xb(handle, inode, root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto leave;
@@ -4816,8 +4816,8 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 		goto out;
 	}
 
-	ret = ocfs2_journal_access(handle, inode, root_bh,
-				   OCFS2_JOURNAL_ACCESS_WRITE);
+	ret = ocfs2_journal_access_xb(handle, inode, root_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_commit;
-- 
1.5.6.5

From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  1 Sep 2008 08:45:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: bug-fix for journal extend in xattr.
Message-ID: <1220229918-14728-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_extend_trans, when we can't extend the current
transaction, it will commit current transaction and restart
a new one. So if the previous credits we have allocated are't
used(the block isn't dirtied before our extend), we will not
have enough credits for any future operation(it will cause jbd
complain and bug out). So check this and re-extend it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f87bbf1..0f18e60 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1352,8 +1352,9 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
 	}
 
 	if (!(flag & OCFS2_INLINE_XATTR_FL)) {
-		/*set extended attribue in external blcok*/
+		/* set extended attribute in external block. */
 		ret = ocfs2_extend_trans(handle,
+					 OCFS2_INODE_UPDATE_CREDITS +
 					 OCFS2_XATTR_BLOCK_UPDATE_CREDITS);
 		if (ret) {
 			mlog_errno(ret);
@@ -3750,6 +3751,18 @@ static int ocfs2_add_new_xattr_cluster(struct inode *inode,
 		}
 	}
 
+	if (handle->h_buffer_credits < credits) {
+		/*
+		 * The journal has been restarted before, and don't
+		 * have enough space for the insertion, so extend it
+		 * here.
+		 */
+		ret = ocfs2_extend_trans(handle, credits);
+		if (ret) {
+			mlog_errno(ret);
+			goto leave;
+		}
+	}
 	mlog(0, "Insert %u clusters at block %llu for xattr@%u\n",
 	     num_bits, block, v_start);
 	ret = ocfs2_insert_extent(osb, handle, inode, &et, v_start, block,
-- 
1.5.4.GIT

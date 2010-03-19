From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 19 Mar 2010 15:04:24 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Init meta_ac properly in
	ocfs2_create_empty_xattr_block.
In-Reply-To: <1268982264-28121-1-git-send-email-tao.ma@oracle.com>
References: <1268982264-28121-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1268982264-28121-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Init ctxt.meta_ac properly in ocfs2_create_empty_xattr_block.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 82c2a0b..3e77730 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6528,13 +6528,11 @@ static int ocfs2_create_empty_xattr_block(struct inode *inode,
 					  int indexed)
 {
 	int ret;
-	struct ocfs2_alloc_context *meta_ac;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_xattr_set_ctxt ctxt = {
-		.meta_ac = meta_ac,
-	};
+	struct ocfs2_xattr_set_ctxt ctxt;
 
-	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &meta_ac);
+	memset(&ctxt, 0, sizeof(ctxt));
+	ret = ocfs2_reserve_new_metadata_blocks(osb, 1, &ctxt.meta_ac);
 	if (ret < 0) {
 		mlog_errno(ret);
 		return ret;
@@ -6556,7 +6554,7 @@ static int ocfs2_create_empty_xattr_block(struct inode *inode,
 
 	ocfs2_commit_trans(osb, ctxt.handle);
 out:
-	ocfs2_free_alloc_context(meta_ac);
+	ocfs2_free_alloc_context(ctxt.meta_ac);
 	return ret;
 }
 
-- 
1.5.5

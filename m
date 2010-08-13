From: mfasheh at suse.com <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 15:15:15 -0700
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: split out inode alloc code from
	ocfs2_mknod_locked
In-Reply-To: <1281737719-27008-1-git-send-email-mfasheh@suse.com>
References: <1281737719-27008-1-git-send-email-mfasheh@suse.com>
Message-ID: <1281737719-27008-2-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Mark Fasheh <mfasheh@suse.com>

Do this by splitting the bulk of the function away from the inode allocation
code at the very tom of ocfs2_mknod_locked(). Existing callers don't need to
change and won't see any difference. The new function created,
__ocfs2_mknod_locked() will be used shortly.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/namei.c |   55 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f171b51..2aa66b6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -472,32 +472,23 @@ leave:
 	return status;
 }
 
-static int ocfs2_mknod_locked(struct ocfs2_super *osb,
-			      struct inode *dir,
-			      struct inode *inode,
-			      dev_t dev,
-			      struct buffer_head **new_fe_bh,
-			      struct buffer_head *parent_fe_bh,
-			      handle_t *handle,
-			      struct ocfs2_alloc_context *inode_ac)
+static int __ocfs2_mknod_locked(struct inode *dir,
+				struct inode *inode,
+				dev_t dev,
+				struct buffer_head **new_fe_bh,
+				struct buffer_head *parent_fe_bh,
+				handle_t *handle,
+				struct ocfs2_alloc_context *inode_ac,
+				u64 fe_blkno, u64 suballoc_loc, u16 suballoc_bit)
 {
 	int status = 0;
+	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_extent_list *fel;
-	u64 suballoc_loc, fe_blkno = 0;
-	u16 suballoc_bit;
 	u16 feat;
 
 	*new_fe_bh = NULL;
 
-	status = ocfs2_claim_new_inode(handle, dir, parent_fe_bh,
-				       inode_ac, &suballoc_loc,
-				       &suballoc_bit, &fe_blkno);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
 	/* populate as many fields early on as possible - many of
 	 * these are used by the support functions here and in
 	 * callers. */
@@ -591,6 +582,34 @@ leave:
 	return status;
 }
 
+static int ocfs2_mknod_locked(struct ocfs2_super *osb,
+			      struct inode *dir,
+			      struct inode *inode,
+			      dev_t dev,
+			      struct buffer_head **new_fe_bh,
+			      struct buffer_head *parent_fe_bh,
+			      handle_t *handle,
+			      struct ocfs2_alloc_context *inode_ac)
+{
+	int status = 0;
+	u64 suballoc_loc, fe_blkno = 0;
+	u16 suballoc_bit;
+
+	*new_fe_bh = NULL;
+
+	status = ocfs2_claim_new_inode(handle, dir, parent_fe_bh,
+				       inode_ac, &suballoc_loc,
+				       &suballoc_bit, &fe_blkno);
+	if (status < 0) {
+		mlog_errno(status);
+		return status;
+	}
+
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+				    parent_fe_bh, handle, inode_ac,
+				    fe_blkno, suballoc_loc, suballoc_bit);
+}
+
 static int ocfs2_mkdir(struct inode *dir,
 		       struct dentry *dentry,
 		       int mode)
-- 
1.6.4.2

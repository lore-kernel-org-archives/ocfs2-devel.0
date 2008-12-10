From: Joel Becker <joel.becker@oracle.com>
Date: Tue,  9 Dec 2008 17:09:53 -0800
Subject: [Ocfs2-devel] [PATCH 16/18] ocfs2: Pass value buf to
	ocfs2_remove_value_outside().
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1228871395-10273-17-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_remove_value_outside() needs to know the type of buffer it is
looking at.  Pass in an ocfs2_xattr_value_buf.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a33e2df..7b61c1c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1699,7 +1699,7 @@ out:
 }
 
 static int ocfs2_remove_value_outside(struct inode*inode,
-				      struct buffer_head *bh,
+				      struct ocfs2_xattr_value_buf *vb,
 				      struct ocfs2_xattr_header *header)
 {
 	int ret = 0, i;
@@ -1720,17 +1720,13 @@ static int ocfs2_remove_value_outside(struct inode*inode,
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
 
 		if (!ocfs2_xattr_is_local(entry)) {
-			struct ocfs2_xattr_value_buf vb = {
-				.vb_bh = bh,
-				.vb_access = ocfs2_journal_access,
-			};
 			void *val;
 
 			val = (void *)header +
 				le16_to_cpu(entry->xe_name_offset);
-			vb.vb_xv = (struct ocfs2_xattr_value_root *)
+			vb->vb_xv = (struct ocfs2_xattr_value_root *)
 				(val + OCFS2_XATTR_SIZE(entry->xe_name_len));
-			ret = ocfs2_xattr_value_truncate(inode, &vb, 0, &ctxt);
+			ret = ocfs2_xattr_value_truncate(inode, vb, 0, &ctxt);
 			if (ret < 0) {
 				mlog_errno(ret);
 				break;
@@ -1752,12 +1748,16 @@ static int ocfs2_xattr_ibody_remove(struct inode *inode,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_xattr_header *header;
 	int ret;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = di_bh,
+		.vb_access = ocfs2_journal_access_di,
+	};
 
 	header = (struct ocfs2_xattr_header *)
 		 ((void *)di + inode->i_sb->s_blocksize -
 		 le16_to_cpu(di->i_xattr_inline_size));
 
-	ret = ocfs2_remove_value_outside(inode, di_bh, header);
+	ret = ocfs2_remove_value_outside(inode, &vb, header);
 
 	return ret;
 }
@@ -1767,11 +1767,15 @@ static int ocfs2_xattr_block_remove(struct inode *inode,
 {
 	struct ocfs2_xattr_block *xb;
 	int ret = 0;
+	struct ocfs2_xattr_value_buf vb = {
+		.vb_bh = blk_bh,
+		.vb_access = ocfs2_journal_access_xb,
+	};
 
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		struct ocfs2_xattr_header *header = &(xb->xb_attrs.xb_header);
-		ret = ocfs2_remove_value_outside(inode, blk_bh, header);
+		ret = ocfs2_remove_value_outside(inode, &vb, header);
 	} else
 		ret = ocfs2_delete_xattr_index_block(inode, blk_bh);
 
-- 
1.5.6.5

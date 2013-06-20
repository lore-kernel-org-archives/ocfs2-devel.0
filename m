From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Thu, 20 Jun 2013 14:17:36 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: xattr: fix inlined xattr reflink
Message-ID: <1371709057-11469-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Inlined xattr shared free space of inode block with inlined data
or data extent record, so the size of the later two should be
adjusted when inlined xattr is enabled. See ocfs2_xattr_ibody_init().
But this isn't done well when reflink. For inode with inlined data,
its max inlined data size is adjusted in ocfs2_duplicate_inline_data(),
no problem. But for inode with data extent record, its record count isn't
adjusted. Fix it, or data extent record and inlined xattr may overwrite
each other, then cause data corruption or xattr failure.

Cc: <stable@kernel.org>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/xattr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2e3ea30..3bb0708 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6499,6 +6499,16 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
 	}
 
 	new_oi = OCFS2_I(args->new_inode);
+	/*
+	 * Adjust extent record count to reserve space for extended attribute.
+	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
+	 */
+	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		&& !(ocfs2_inode_is_fast_symlink(new_inode))) {
+		struct ocfs2_extent_list *el = &new_di->id2.i_list;
+		le16_add_cpu(&el->l_count, -(inline_size /
+					sizeof(struct ocfs2_extent_rec)));
+	}
 	spin_lock(&new_oi->ip_lock);
 	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
 	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
-- 
1.7.9.5

From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  5 Dec 2008 06:20:56 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: bug fix for credits of
	creating index block.
In-Reply-To: <4938C737.9060504@oracle.com>
References: <4938C737.9060504@oracle.com>
Message-ID: <1228429256-9308-3-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When creating a xattr index block, the old calculation forget
to add credits for the meta change of the alloc file. So add
more credits and more comments to explain it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 34c6850..6860134 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2310,13 +2310,21 @@ meta_guess:
 		} else
 			xb = (struct ocfs2_xattr_block *)xbs->xattr_bh->b_data;
 
+		/*
+		 * If there is already an xattr tree, good, we can calculate
+		 * like other b-trees. Otherwise we may have the chance of
+		 * create a tree, the credit calculation is borrowed from
+		 * ocfs2_calc_extend_credits with root_el = NULL. And the
+		 * new tree will be cluster based, so no meta is needed.
+		 */
 		if (le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED) {
 			struct ocfs2_extent_list *el =
 				 &xb->xb_attrs.xb_root.xt_list;
 			meta_add += ocfs2_extend_meta_needed(el);
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     el, 1);
-		}
+		} else
+			credits += OCFS2_SUBALLOC_ALLOC + 1;
 
 		/*
 		 * This cluster will be used either for new bucket or for
-- 
1.5.4.GIT

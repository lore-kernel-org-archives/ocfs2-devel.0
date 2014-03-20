From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Wed, 19 Mar 2014 18:08:00 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] allow for more than one data extent when
	creating xattr
Message-ID: <1395277680-13033-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Orabug: 18108070

ocfs2_xattr_extend_allocation() hits panic when creating xattr during
data extent alloc phase. The problem occurs if due to local alloc
fragmentation, clusters are spread over multiple extents.  In this case
ocfs2_add_clusters_in_btree() finds no space to store more than one extent
record and therefore fails returning RESTART_META.  The situation is
anticipated for xattr update case but not xattr create case. This fix
simply ports that code to create case.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
---
 fs/ocfs2/xattr.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 185fa3b..4217fed 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3200,8 +3200,15 @@ meta_guess:
 			clusters_add += 1;
 		}
 	} else {
-		meta_add += 1;
 		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
+		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
+			struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
+			meta_add += ocfs2_extend_meta_needed(el);
+			credits += ocfs2_calc_extend_credits(inode->i_sb,
+							     el);
+		} else {
+			meta_add += 1;
+		}
 	}
 out:
 	if (clusters_need)
-- 
1.7.1

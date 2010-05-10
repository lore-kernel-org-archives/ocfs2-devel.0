From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 10 May 2010 18:09:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Reset xattr value size after
	xa_cleanup_value_truncate.
Message-ID: <1273486187-1898-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_prepare_xattr_entry, if we fail to xa_cleanup_value_truncate,
we need to reset its value size in case we don't remove the xattr
entry. This resolves oss bug 1247.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a1cf195..e87130f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2135,15 +2135,18 @@ alloc_value:
 		orig_clusters = ocfs2_xa_value_clusters(loc);
 		rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len, ctxt);
 		if (rc < 0) {
-			/*
-			 * If we tried to grow an existing external value,
-			 * ocfs2_xa_cleanuP-value_truncate() is going to
-			 * let it stand.  We have to restore its original
-			 * value size.
-			 */
-			loc->xl_entry->xe_value_size = orig_value_size;
 			ocfs2_xa_cleanup_value_truncate(loc, "growing",
 							orig_clusters);
+			/*
+			 * If we were growing an existing value,
+			 * ocfs2_xa_cleanup_value_truncate() won't remove
+			 * the entry. We need to restore the original value
+			 * size.
+			 */
+			if (loc->xl_entry) {
+				BUG_ON(!orig_value_size);
+				loc->xl_entry->xe_value_size = orig_value_size;
+			}
 			mlog_errno(rc);
 		}
 	}
-- 
1.5.5

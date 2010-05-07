From: Tao Ma <tao.ma@Oracle.COM>
Date: Fri,  7 May 2010 14:17:34 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/xattr: Reset xattr value size in
	cleanup_truncate.
Message-ID: <1273213054-1672-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_xa_prepare_entry, if we fail to allocate in
ocfs2_xa_value_truncate, we call ocfs2_xa_cleanup_value_truncate
to handle the clean up. And before calling this fucntion, we
reset xe_value_size to original_value_size.
This has a problem. If original_value_size = 0, we will bug out in
ocfs2_xa_cleanup_value_truncate when we call ocfs2_xa_value_clusters.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1247.

So this patch try to resolve it by adding the original_value_size to
ocfs2_xa_cleanup_value_truncate and let it handle it. So xe_value_size
will only be reset in case we want to reserve the xe entry. There is
also a side effect that we can remove the fat comment before we set
the xe_value_size in ocfs2_xa_prepare_entry.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/xattr.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 38a55ff..ac55a44 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1947,7 +1947,8 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
  */
 static void ocfs2_xa_cleanup_value_truncate(struct ocfs2_xa_loc *loc,
 					    const char *what,
-					    unsigned int orig_clusters)
+					    unsigned int orig_clusters,
+					    __le64 orig_value_size)
 {
 	unsigned int new_clusters = ocfs2_xa_value_clusters(loc);
 	char *nameval_buf = ocfs2_xa_offset_pointer(loc,
@@ -1968,13 +1969,15 @@ static void ocfs2_xa_cleanup_value_truncate(struct ocfs2_xa_loc *loc,
 		     loc->xl_entry->xe_name_len, nameval_buf,
 		     new_clusters - orig_clusters);
 		ocfs2_xa_remove_entry(loc);
-	} else if (new_clusters > orig_clusters)
+	} else if (new_clusters > orig_clusters) {
 		mlog(ML_ERROR,
 		     "Unable to grow xattr %.*s safely.  %u new clusters "
 		     "have been added, but the value will not be "
 		     "modified\n",
 		     loc->xl_entry->xe_name_len, nameval_buf,
 		     new_clusters - orig_clusters);
+		loc->xl_entry->xe_value_size = orig_value_size;
+	}
 }
 
 static int ocfs2_xa_remove(struct ocfs2_xa_loc *loc,
@@ -1997,7 +2000,8 @@ static int ocfs2_xa_remove(struct ocfs2_xa_loc *loc,
 			if (orig_clusters != ocfs2_xa_value_clusters(loc))
 				rc = 0;
 			ocfs2_xa_cleanup_value_truncate(loc, "removing",
-							orig_clusters);
+						orig_clusters,
+						loc->xl_entry->xe_value_size);
 			if (rc)
 				goto out;
 		}
@@ -2065,7 +2069,8 @@ static int ocfs2_xa_reuse_entry(struct ocfs2_xa_loc *loc,
 
 		if (rc) {
 			ocfs2_xa_cleanup_value_truncate(loc, "reusing",
-							orig_clusters);
+						orig_clusters,
+						loc->xl_entry->xe_value_size);
 			goto out;
 		}
 	}
@@ -2113,8 +2118,9 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 			if (rc) {
 				mlog_errno(rc);
 				ocfs2_xa_cleanup_value_truncate(loc,
-								"overwriting",
-								orig_clusters);
+						"overwriting",
+						orig_clusters,
+						loc->xl_entry->xe_value_size);
 				goto out;
 			}
 		}
@@ -2135,15 +2141,9 @@ alloc_value:
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
-							orig_clusters);
+						orig_clusters,
+						orig_value_size);
 			mlog_errno(rc);
 		}
 	}
-- 
1.5.5

From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 1 Sep 2009 18:51:59 -0700
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation in
 ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <20090901202111.GH3826@mail.oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
	<4A9CE168.6050107@oracle.com>
	<20090901202111.GH3826@mail.oracle.com>
Message-ID: <20090902015158.GA9165@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2009 at 01:21:12PM -0700, Joel Becker wrote:
> 	This leads to the real question: what do we do when we have a
> problem?  There are multiple problems to have.

	Ok, here's a full error handling patch.  It's 15th in the
series.  It sits atop a couple of changes I've ma to support it
(separating ocfs2_xa_remove_entry() from the truncate and having
ocfs2_xa_remove() that does truncate+wipe).  The latest xa_loc in
ocfs2.git has all this.

From b6be52624330a9fa735e31a9ea867988d24c103e Mon Sep 17 00:00:00 2001
From: Joel Becker <joel.becker@oracle.com>
Date: Tue, 1 Sep 2009 18:38:27 -0700
Subject: [PATCH] ocfs2: Handle errors while setting external xattr values.

ocfs2 can store extended attribute values as large as a single file.  It
does this using a standard ocfs2 btree for the large value.  However,
the previous code did not handle all error cases cleanly.

There are multiple problems to have.

1) We have trouble allocating space for a new xattr.  This leaves us
   with an empty xattr.
2) We overwrote an existing local xattr with a value root, and now we
   have an error allocating the storage.  This leaves us an empty xattr.
   where there used to be a value.  The value is lost.
3) We have trouble truncating a reused value.  This leaves us with the
   original entry pointing to the truncated original value.  The value
   is lost.
4) We have trouble extending the storage on a reused value.  This leaves
   us with the original value safely in place, but with more storage
   allocated when needed.

This doesn't consider storing local xattrs (values that don't require a
btree).  Those only fail when the journal fails.

Case (1) is easy.  We just remove the xattr we added.  We leak the
storage because we can't safely remove it, but otherwise everything is
happy.  We'll print a warning about the leak.

Case (4) is easy.  We still have the original value in place.  We can
just leave the extra storage attached to this xattr.  We return the
error, but the old value is untouched.  We print a warning about the
storage.

Case (2) and (3) are hard because we've lost the original values.  In
the old code, we ended up with values that could be partially read.
That's not good.  Instead, we just wipe the xattr entry and leak the
storage.  It stinks that the original value is lost, but now there isn't
a partial value to be read.  We'll print a big fat warning.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/xattr.c |  141 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index f62985a..20323bb 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1861,6 +1861,17 @@ static const struct ocfs2_xa_loc_operations ocfs2_xa_bucket_loc_ops = {
 	.xlo_fill_value_buf	= ocfs2_xa_bucket_fill_value_buf,
 };
 
+static unsigned int ocfs2_xa_value_clusters(struct ocfs2_xa_loc *loc)
+{
+	struct ocfs2_xattr_value_buf vb;
+
+	if (ocfs2_xattr_is_local(loc->xl_entry))
+		return 0;
+
+	ocfs2_xa_fill_value_buf(loc, &vb);
+	return le32_to_cpu(vb.vb_xv->xr_clusters);
+}
+
 static int ocfs2_xa_value_truncate(struct ocfs2_xa_loc *loc, u64 bytes,
 				   struct ocfs2_xattr_set_ctxt *ctxt)
 {
@@ -1897,17 +1908,87 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
 	}
 }
 
+/*
+ * If we have a problem adjusting the size of an external value during
+ * ocfs2_xa_prepare_entry() or ocfs2_xa_remove(), we may have an xattr
+ * in an intermediate state.  For example, the value may be partially
+ * truncated.
+ *
+ * If the value tree hasn't changed, the extend/truncate went nowhere.
+ * We have nothing to do.  The caller can treat it as a straight error.
+ *
+ * If the value tree got partially truncated, we now have a corrupted
+ * extended attribute.  We're going to wipe its entry and leak the
+ * clusters.  Better to leak some storage than leave a corrupt entry.
+ *
+ * If the value tree grew, it obviously didn't grow enough for the
+ * new entry.  We're not going to try and reclaim those clusters either.
+ * If there was already an external value there (orig_clusters != 0),
+ * the new clusters are attached safely and we can just leave the old
+ * value in place.  If there was no external value there, we remove
+ * then entry.
+ *
+ * This way, the xattr block we store in the journal will be consistent.
+ * If the size change broke because of the journal, no changes will hit
+ * disk anyway.
+ */
+static void ocfs2_xa_cleanup_value_truncate(struct ocfs2_xa_loc *loc,
+					    const char *what,
+					    unsigned int orig_clusters)
+{
+	unsigned int new_clusters = ocfs2_xa_value_clusters(loc);
+	char *nameval_buf = ocfs2_xa_offset_pointer(loc,
+				le16_to_cpu(loc->xl_entry->xe_name_offset));
+
+	if (new_clusters < orig_clusters) {
+		mlog(ML_ERROR,
+		     "Partial truncate while %s xattr %.*s.  Leaking "
+		     "%u clusters and removing the entry\n",
+		     what, loc->xl_entry->xe_name_len, nameval_buf,
+		     orig_clusters - new_clusters);
+		ocfs2_xa_remove_entry(loc);
+	} else if (!orig_clusters) {
+		mlog(ML_ERROR,
+		     "Unable to allocate an external value for xattr "
+		     "%.*s safely.  Leaking %u clusters and removing the "
+		     "entry\n",
+		     loc->xl_entry->xe_name_len, nameval_buf,
+		     new_clusters - orig_clusters);
+		ocfs2_xa_remove_entry(loc);
+	} else if (new_clusters > orig_clusters)
+		mlog(ML_ERROR,
+		     "Unable to grow xattr %.*s safely.  %u new clusters "
+		     "have been added, but the value will not be "
+		     "modified\n",
+		     loc->xl_entry->xe_name_len, nameval_buf,
+		     new_clusters - orig_clusters);
+}
+
 static int ocfs2_xa_remove(struct ocfs2_xa_loc *loc,
 			   struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int rc;
+	unsigned int orig_clusters;
 
 	if (!ocfs2_xattr_is_local(loc->xl_entry)) {
+		orig_clusters = ocfs2_xa_value_clusters(loc);
 		rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
 		if (rc) {
 			mlog_errno(rc);
-			goto out;
+			/*
+			 * Since this is remove, we can return 0 if
+			 * ocfs2_xa_cleanup_value_truncate() is going to
+			 * wipe the entry anyway.  So we check the
+			 * cluster count as well.
+			 */
+			if (orig_clusters != ocfs2_xa_value_clusters(loc))
+				rc = 0;
+			ocfs2_xa_cleanup_value_truncate(loc, "removing",
+							orig_clusters);
 		}
+
+		if (rc)
+			goto out;
 	}
 
 	ocfs2_xa_remove_entry(loc);
@@ -1937,6 +2018,7 @@ static int ocfs2_xa_reuse_entry(struct ocfs2_xa_loc *loc,
 {
 	int rc = 0;
 	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
+	unsigned int orig_clusters;
 	char *nameval_buf;
 	int xe_local = ocfs2_xattr_is_local(loc->xl_entry);
 	int xi_local = xi->xi_value_len <= OCFS2_XATTR_INLINE_SIZE;
@@ -1952,23 +2034,27 @@ static int ocfs2_xa_reuse_entry(struct ocfs2_xa_loc *loc,
 		if (!xi_local)
 			ocfs2_xa_install_value_root(loc);
 	} else {
+		orig_clusters = ocfs2_xa_value_clusters(loc);
 		if (xi_local) {
 			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
-			if (rc < 0) {
+			if (rc < 0)
 				mlog_errno(rc);
-				goto out;
-			}
-			memset(nameval_buf + name_size, 0,
-			       namevalue_size_xe(loc->xl_entry) -
-			       name_size);
+			else
+				memset(nameval_buf + name_size, 0,
+				       namevalue_size_xe(loc->xl_entry) -
+				       name_size);
 		} else if (le64_to_cpu(loc->xl_entry->xe_value_size) >
 			   xi->xi_value_len) {
 			rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len,
 						     ctxt);
-			if (rc < 0) {
+			if (rc < 0)
 				mlog_errno(rc);
-				goto out;
-			}
+		}
+
+		if (rc) {
+			ocfs2_xa_cleanup_value_truncate(loc, "reusing",
+							orig_clusters);
+			goto out;
 		}
 	}
 
@@ -1993,6 +2079,8 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 				  struct ocfs2_xattr_set_ctxt *ctxt)
 {
 	int rc = 0;
+	unsigned int orig_clusters;
+	__le64 orig_value_size = 0;
 
 	rc = ocfs2_xa_check_space(loc, xi);
 	if (rc)
@@ -2000,6 +2088,7 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 
 	if (loc->xl_entry) {
 		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
+			orig_value_size = loc->xl_entry->xe_value_size;
 			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
 			if (rc)
 				goto out;
@@ -2007,9 +2096,13 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 		}
 
 		if (!ocfs2_xattr_is_local(loc->xl_entry)) {
+			orig_clusters = ocfs2_xa_value_clusters(loc);
 			rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
 			if (rc) {
 				mlog_errno(rc);
+				ocfs2_xa_cleanup_value_truncate(loc,
+								"overwriting",
+								orig_clusters);
 				goto out;
 			}
 		}
@@ -2027,9 +2120,20 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
 
 alloc_value:
 	if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
+		orig_clusters = ocfs2_xa_value_clusters(loc);
 		rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len, ctxt);
-		if (rc < 0)
+		if (rc < 0) {
+			/*
+			 * If we tried to grow an existing external value,
+			 * ocfs2_xa_cleanuP-value_truncate() is going to
+			 * let it stand.  We have to restore its original
+			 * value size.
+			 */
+			loc->xl_entry->xe_value_size = orig_value_size;
+			ocfs2_xa_cleanup_value_truncate(loc, "growing",
+							orig_clusters);
 			mlog_errno(rc);
+		}
 	}
 
 out:
@@ -2079,25 +2183,30 @@ static int ocfs2_xa_set(struct ocfs2_xa_loc *loc,
 		goto out;
 	}
 
+	/*
+	 * From here on out, everything is going to modify the buffer a
+	 * little.  Errors are going to leave the xattr header in a
+	 * sane state.  Thus, even with errors we dirty the sucker.
+	 */
+
 	/* Don't worry, we are never called with !xi_value and !xl_entry */
 	if (!xi->xi_value) {
 		ret = ocfs2_xa_remove(loc, ctxt);
-		goto out;
+		goto out_dirty;
 	}
 
 	ret = ocfs2_xa_prepare_entry(loc, xi, name_hash, ctxt);
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
-		goto out;
+		goto out_dirty;
 	}
 
 	ret = ocfs2_xa_store_value(loc, xi, ctxt);
-	if (ret) {
+	if (ret)
 		mlog_errno(ret);
-		goto out;
-	}
 
+out_dirty:
 	ocfs2_xa_journal_dirty(ctxt->handle, loc);
 
 out:
-- 
1.6.3.3

-- 

"Sometimes I think the surest sign intelligent
 life exists elsewhere in the universe is that
 none of it has tried to contact us."
                                -Calvin & Hobbes

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 1 Sep 2009 13:21:12 -0700
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation in
 ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <4A9CE168.6050107@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
	<4A9CE168.6050107@oracle.com>
Message-ID: <20090901202111.GH3826@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2009 at 04:55:04PM +0800, Tao Ma wrote:
> >+		} else if (le64_to_cpu(loc->xl_entry->xe_value_size) >
> >+			   xi->xi_value_len) {
> >+			rc = ocfs2_xa_value_truncate(loc, xi->xi_value_len,
> >+						     ctxt);
> From your comments above, we don't allocate space. I am just curious
> why we can't extend it here if value_size < xi->xi_value_len?

	Because we extend in ocfs2_xa_prepare_entry().  No point in
doing it two places.  The flow is cleaner here, and if we need to change
the extend code, we only change it once.

> > static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
> > 				  struct ocfs2_xattr_info *xi,
> >-				  u32 name_hash)
> >+				  u32 name_hash,
> >+				  struct ocfs2_xattr_set_ctxt *ctxt)
> > {
> > 	int rc = 0;
> >-	int name_size = OCFS2_XATTR_SIZE(xi->xi_name_len);
> >-	char *nameval_buf;
> > 	if (!xi->xi_value) {
> > 		ocfs2_xa_remove_entry(loc);
> >@@ -2044,13 +1990,10 @@ static int ocfs2_xa_prepare_entry(struct ocfs2_xa_loc *loc,
> > 	if (loc->xl_entry) {
> > 		if (ocfs2_xa_can_reuse_entry(loc, xi)) {
> >-			nameval_buf = ocfs2_xa_offset_pointer(loc,
> >-				le16_to_cpu(loc->xl_entry->xe_name_offset));
> >-			memset(nameval_buf + name_size, 0,
> >-			       namevalue_size_xe(loc->xl_entry) - name_size);
> >-			loc->xl_entry->xe_value_size =
> >-				cpu_to_le64(xi->xi_value_len);
> >-			goto out;
> >+			rc = ocfs2_xa_reuse_entry(loc, xi, ctxt);
> >+			if (rc)
> >+				goto out;
> >+			goto alloc_value;
> As I said above in xa_reuse_entry, if we have already "alloc value"
> in ocfs2_xa_reuse_entry, we don't need to goto it again?

	Because this way if we have to handle allocation errors, we only
handle them in one place.  Also flow of ocfs2_prepare_entry() is
straightforward.  First we find an entry, then we allocate any new
storage for it.  One of the spaghetti problems of the previous code was
the seven different ways to end up allocating the storage ;-)

> >@@ -2336,28 +2195,6 @@ static int ocfs2_xattr_set_entry(struct inode *inode,
> > 	if (ret < 0)
> > 		mlog_errno(ret);
> >-	if (!ret && xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
> >-		/*
> >-		 * Set value outside in B tree.
> >-		 * This is the second step for value size > INLINE_SIZE.
> >-		 */
> >-		size_t offs = le16_to_cpu(xs->here->xe_name_offset);
> >-		ret = ocfs2_xattr_set_value_outside(inode, xi, xs, ctxt,
> >-						    &vb, offs);
> >-		if (ret < 0) {
> >-			int ret2;
> >-
> >-			mlog_errno(ret);
> >-			/*
> >-			 * If set value outside failed, we have to clean
> >-			 * the junk tree root we have already set in local.
> >-			 */
> >-			ret2 = ocfs2_xattr_cleanup(inode, ctxt->handle,
> >-						   xi, xs, &vb, offs);
> you just removed this part which will remove the entry if we fail in
> cluster extension. I haven't seen some new implementation like that.
> Am I missing something here?

	No, you're not.  ocfs2_xattr_cleanup() was broken anyway - it
never freed the storage, just zeroed out the value root.  Plus, it only
worked for entries at the end of the entry list.  Now, the old code was
safe in that it would only call ocfs2_xattr_cleanup() for an entry at
the end of the entry list.  But the old code never cleaned up a reused
entry.  So if it was reusing an entry and had a problem truncating to a
smaller size or growing to a larger size, it would leave the entry in
place.
	So my current code has the latter behavior.  You get
half-initialized xattrs in the case of error.  But it's consistent - you
get that for new entries and reused ones!
	This leads to the real question: what do we do when we have a
problem?  There are multiple problems to have.

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

	For the sake of argument, I'm going to ignore problems storing
local xattrs, as that can only really be journal aborts, and those are
horrible anyway :-)
	Condition (1) is where the original ocfs2_xattr_cleanup() wiped
the entry and leaked the storage.  We can certainly try to wipe the
entry and cleanup the storage.  Case (4) can either be ignored or we can
re-truncate back to the original size.  Cases (2) and (3) are the hard
ones.  The values are already lost.  Do we just leave the partial values
in place?  That sucks.  Do we remove the entries?  Well that means a
failed set is just like a delete.  Ugh!
	Anyone have any ideas?

Joel

-- 

"Sometimes one pays most for the things one gets for nothing."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

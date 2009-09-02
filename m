From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Sep 2009 01:05:46 -0700
Subject: [Ocfs2-devel] [PATCH 10/14] ocfs2: Allocation in
 ocfs2_xa_prepare_entry() values in ocfs2_xa_store_value()
In-Reply-To: <4A9DFBBF.1010102@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-11-git-send-email-joel.becker@oracle.com>
	<4A9CE168.6050107@oracle.com>
	<20090901202111.GH3826@mail.oracle.com>
	<20090902015158.GA9165@mail.oracle.com>
	<4A9DFBBF.1010102@oracle.com>
Message-ID: <20090902080544.GA10257@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 02, 2009 at 12:59:43PM +0800, Tao Ma wrote:
> >Case (2) and (3) are hard because we've lost the original values.  In
> >the old code, we ended up with values that could be partially read.
> >That's not good.  Instead, we just wipe the xattr entry and leak the
> >storage.  It stinks that the original value is lost, but now there isn't
> >a partial value to be read.  We'll print a big fat warning.
> actually case (2) is rarely to happen since we should have already
> reserved enough clusters before we start the transaction. As for
> (3), the only chance is that the b-tree is corrupted. And in this
> case, I think remove the corrupted b-tree root is OK for me.

	Both case (2) and (3) are unlikely, because we've already tried
to reserve everything we need.  Errors there should be EIO, btree
corruption, or journal abort.

> > static int ocfs2_xa_remove(struct ocfs2_xa_loc *loc,
> > 			   struct ocfs2_xattr_set_ctxt *ctxt)
> > {
> > 	int rc;
> >+	unsigned int orig_clusters;
> > 	if (!ocfs2_xattr_is_local(loc->xl_entry)) {
> >+		orig_clusters = ocfs2_xa_value_clusters(loc);
> > 		rc = ocfs2_xa_value_truncate(loc, 0, ctxt);
> > 		if (rc) {
> > 			mlog_errno(rc);
> >-			goto out;
> >+			/*
> >+			 * Since this is remove, we can return 0 if
> >+			 * ocfs2_xa_cleanup_value_truncate() is going to
> >+			 * wipe the entry anyway.  So we check the
> >+			 * cluster count as well.
> >+			 */
> >+			if (orig_clusters != ocfs2_xa_value_clusters(loc))
> >+				rc = 0;
> >+			ocfs2_xa_cleanup_value_truncate(loc, "removing",
> >+							orig_clusters);
> > 		}
> >+
> >+		if (rc)
> >+			goto out;
> move this after ocfs2_xa_cleanup_value_truncate. No need to check it
> twice. And even if you set rc = 0 above, in
> ocfs2_xa_cleanup_value_truncate(new_clusters < orig_clusters) we
> will remove the entry I think. So we don't need to call
> ocfs2_xa_remove_entry below.

	Yeah, you're right, it can go inside the if block.

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

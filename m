From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 1 Sep 2009 01:45:59 -0700
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: Introduce ocfs2_xa_loc
In-Reply-To: <20090901082652.GA3826@mail.oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-2-git-send-email-joel.becker@oracle.com>
	<4A9CB1F5.3050809@oracle.com>
	<20090901082652.GA3826@mail.oracle.com>
Message-ID: <20090901084558.GE3826@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2009 at 01:26:54AM -0700, Joel Becker wrote:
> On Tue, Sep 01, 2009 at 01:32:37PM +0800, Tao Ma wrote:
> > Joel Becker wrote:
> > >+static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
> > >+					   int offset)
> > >+{
> > >+	struct buffer_head *bh = loc->xl_storage;
> > >+
> > >+	BUG_ON(offset >= bh->b_size);
> > >+	return bh->b_data + offset;
> > >+}
> > It looks that the "offset" is from the start of the buffer, while in
> > your description above "offset" is from "loc->xl_header". In both
> > inline and block case, header != buffer_start. xl_size seems to be
> > against xl_header, so I would guess here you need to change somehow.
> 
> 	Doh!  That's a bug.  The description matches reality -
> xe_name_offset is from the start of the header, not the block, right?
> So this function is just wrong!

	What about this delta?

Joel


diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d485932..abc8043 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -1442,6 +1442,7 @@ static void ocfs2_xa_journal_dirty(handle_t *handle, struct ocfs2_xa_loc *loc)
 /* Give a pointer into the storage for the given offset */
 static void *ocfs2_xa_offset_pointer(struct ocfs2_xa_loc *loc, int offset)
 {
+	BUG_ON(offset >= loc->xl_size);
 	return loc->xl_ops->xlo_offset_pointer(loc, offset);
 }
 
@@ -1552,10 +1553,7 @@ static void ocfs2_xa_block_journal_dirty(handle_t *handle,
 static void *ocfs2_xa_block_offset_pointer(struct ocfs2_xa_loc *loc,
 					   int offset)
 {
-	struct buffer_head *bh = loc->xl_storage;
-
-	BUG_ON(offset >= bh->b_size);
-	return bh->b_data + offset;
+	return (char *)loc->xl_header + offset;
 }
 
 static int ocfs2_xa_block_can_reuse(struct ocfs2_xa_loc *loc,
@@ -1712,8 +1710,7 @@ static void *ocfs2_xa_bucket_offset_pointer(struct ocfs2_xa_loc *loc,
 	struct ocfs2_xattr_bucket *bucket = loc->xl_storage;
 	int block, block_offset;
 
-	BUG_ON(offset >= OCFS2_XATTR_BUCKET_SIZE);
-
+	/* The header is at the front of the bucket */
 	block = offset >> loc->xl_inode->i_sb->s_blocksize_bits;
 	block_offset = offset % loc->xl_inode->i_sb->s_blocksize;
 

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

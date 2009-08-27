From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 27 Aug 2009 02:28:49 -0700
Subject: [Ocfs2-devel] [PATCH 01/14] ocfs2: Introduce ocfs2_xa_loc
In-Reply-To: <4A963A43.70009@oracle.com>
References: <1250711679-12441-1-git-send-email-joel.becker@oracle.com>
	<1250711679-12441-2-git-send-email-joel.becker@oracle.com>
	<4A963A43.70009@oracle.com>
Message-ID: <20090827092848.GB29402@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 27, 2009 at 03:48:19PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >+	u64 value_size = le64_to_cpu(entry->xe_value_size);
> >+
> >+	namevalue_size = OCFS2_XATTR_SIZE(entry->xe_name_len);
> >+	if (value_size > OCFS2_XATTR_INLINE_SIZE)
> >+		namevalue_size += OCFS2_XATTR_ROOT_SIZE;
> >+	else
> >+		namevalue_size += OCFS2_XATTR_SIZE(value_size);
> A minor issue. I see a similar part in the function in
> ocfs2_xa_block_wipe_namevalue, so can we create a inline function
> for it? maybe ocfs2_xe_name_value_size?

	See patch 5 :-)

> >@@ -1376,7 +1586,14 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
> > {
> > 	size_t name_len = strlen(xi->name);
> > 	int i;
> >+	struct ocfs2_xa_loc loc;
> >+	if (xs->xattr_bh == xs->inode_bh)
> >+		ocfs2_init_dinode_xa_loc(&loc, inode, xs->inode_bh,
> >+					 xs->not_found ? NULL : xs->here);
> >+	else
> >+		ocfs2_init_xattr_block_xa_loc(&loc, xs->xattr_bh,
> >+					      xs->not_found ? NULL : xs->here);
> > 	if (xi->value && xs->not_found) {
> > 		/* Insert the new xattr entry. */
> > 		le16_add_cpu(&xs->header->xh_count, 1);
> >@@ -1415,9 +1632,9 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
> > 			       xi->value_len);
> > 			return;
> > 		}
> >+
> > 		/* Remove the old name+value. */
> >-		memmove(first_val + size, first_val, val - first_val);
> >-		memset(first_val, 0, size);
> >+		ocfs2_xa_wipe_namevalue(&loc);
> > 		xs->here->xe_name_hash = 0;
> > 		xs->here->xe_name_offset = 0;
> > 		ocfs2_xattr_set_local(xs->here, 1);
> >@@ -1425,23 +1642,16 @@ static void ocfs2_xattr_set_entry_local(struct inode *inode,
> > 		min_offs += size;
> >-		/* Adjust all value offsets. */
> >-		last = xs->header->xh_entries;
> >-		for (i = 0 ; i < le16_to_cpu(xs->header->xh_count); i++) {
> >-			size_t o = le16_to_cpu(last->xe_name_offset);
> >-
> >-			if (o < offs)
> >-				last->xe_name_offset = cpu_to_le16(o + size);
> >-			last += 1;
> >-		}
> >-
> > 		if (!xi->value) {
> > 			/* Remove the old entry. */
> >-			last -= 1;
> >+			i = le16_to_cpu(xs->header->xh_count);
> >+			i--;
> any reason why not "i = le16_to_cpu(xs->header->xh_count) - 1"?

	No good one.  I moved these couple lines around a bit, so I
probably was just adjusting.

> >+			last = &xs->header->xh_entries[i - 1];
> here is a bug. last should be "&xs->header->xh_entries[i]". In the
> old implementation, the above "for" loop ends with last =
> xh_entries[xh_count].

	My brain wants to protest, but every time I walk the logic you
come out right.  Maybe this used to be above the i-- or something.
Good catch.

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

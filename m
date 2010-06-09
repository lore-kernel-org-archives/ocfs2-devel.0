From: Nick Piggin <npiggin@suse.de>
Date: Wed, 09 Jun 2010 09:38:21 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the deprecated
	inode_setattr.
In-Reply-To: <4C0F5F01.8010807@oracle.com>
References: <1276073300-7360-1-git-send-email-tao.ma@oracle.com>
	<20100609091604.GX26335@laptop> <4C0F5F01.8010807@oracle.com>
Message-ID: <20100609093804.GY26335@laptop>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Jun 09, 2010 at 05:29:37PM +0800, Tao Ma wrote:
> Hi Nick,
> 	Thanks for the quick response.
> On 06/09/2010 05:16 PM, Nick Piggin wrote:
> >On Wed, Jun 09, 2010 at 04:48:20PM +0800, Tao Ma wrote:
> >>@@ -1052,17 +1052,17 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
> >>  	}
> >>
> >>  	/*
> >>-	 * This will intentionally not wind up calling simple_setsize(),
> >>-	 * since all the work for a size change has been done above.
> >>-	 * Otherwise, we could get into problems with truncate as
> >>-	 * ip_alloc_sem is used there to protect against i_size
> >>-	 * changes.
> >>+	 * Since all the work for a size change has been done above,
> >>+	 * we only need to call simple_setsize to update i_size.
> >>  	 */
> >>-	status = inode_setattr(inode, attr);
> >>-	if (status<  0) {
> >>-		mlog_errno(status);
> >>-		goto bail_commit;
> >>+	if (attr->ia_valid&  ATTR_SIZE) {
> >>+		status = simple_setsize(inode, attr->ia_size);
> >>+		if (status<  0) {
> >>+			mlog_errno(status);
> >>+			goto bail_commit;
> >>+		}
> >>  	}
> >>+	generic_setattr(inode, attr);
> >>
> >>  	status = ocfs2_mark_inode_dirty(handle, inode, bh);
> >>  	if (status<  0)
> >
> >simple_setsize of course calls inode_newsize_ok, which may fail. If
> >you're committing your on-disk truncates at this point, you will
> >prefer to hoist that check as early as possible so you cannot fail
> >here.
> >
> We have a inode_newsize_ok check at the top of ocfs2_setattr when we
> do the real work of truncate(it is far above, so the patch can't
> have it. ;) ). So we don't need to worry about that actually.

OK, can you comment that or just open-code the truncate part of
simple_setsize? It should be helpful for example with Christoph's
truncate cleanup work.

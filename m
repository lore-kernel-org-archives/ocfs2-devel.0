From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Mon, 28 Nov 2016 10:24:20 -0800
Subject: [Ocfs2-devel] [PATCH 6/7] ocfs2: implement the VFS clone_range,
 copy_range, and dedupe_range features
In-Reply-To: <20161125081822.GB22465@infradead.org>
References: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
	<147987580233.2678.3884516221182271613.stgit@birch.djwong.org>
	<20161125081822.GB22465@infradead.org>
Message-ID: <20161128182420.GH16807@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: mfasheh@versity.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, darwin.xupt@gmail.com, zren@suse.com, ocfs2-devel@oss.oracle.com

On Fri, Nov 25, 2016 at 12:18:22AM -0800, Christoph Hellwig wrote:
> > +static ssize_t ocfs2_file_copy_range(struct file *file_in,
> > +				     loff_t pos_in,
> > +				     struct file *file_out,
> > +				     loff_t pos_out,
> > +				     size_t len,
> > +				     unsigned int flags)
> > +{
> > +	int error;
> > +
> > +	error = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> > +					  len, false);
> > +	if (error)
> > +		return error;
> > +	return len;
> > +}
> 
> Meh, another dummy copy_range implementation, they now officially
> outnumber the real ones.  I've had a patch to move this shim to common
> code forever, but the complete lack of copy_range testing kept me from
> sending it.  I guess I should finally bite the bullet and we should move
> it to the front of your series.

Yeah.  Once ocfs2 gets its implementation it'll be time to clean up a
few things, starting with your patch, moving on to inode_reflink_ok and
making a common "check the pages of these two files" helper for
xfs/ocfs2 dedupe.

(I'm not sure why btrfs reads in the entire data range of both files,
locks the extents, does the compare, shares the extents, and only then
releases the locks and then the pages.  I'd probably just leave it
alone.)

> > +/* Lock an inode and grab a bh pointing to the inode. */
> > +static int ocfs2_reflink_inodes_lock(struct inode *s_inode,
> > +				     struct buffer_head **bh1,
> > +				     struct inode *t_inode,
> > +				     struct buffer_head **bh2)
> > +{
> > +	struct inode *inode1;
> > +	struct inode *inode2;
> > +	struct ocfs2_inode_info *oi1;
> > +	struct ocfs2_inode_info *oi2;
> > +	bool same_inode = (s_inode == t_inode);
> > +	int status;
> > +
> > +	/* First grab the VFS and rw locks. */
> > +	inode1 = s_inode;
> > +	inode2 = t_inode;
> > +	if (inode1->i_ino > inode2->i_ino)
> > +		swap(inode1, inode2);
> > +
> > +	inode_lock(inode1);
> 
> For the VFS inode lock this should use lock_two_nondirectories.

OK.

> > +	ret = -ETXTBSY;
> > +	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
> > +		goto out_unlock;
> > +
> > +	/* Don't reflink dirs, pipes, sockets... */
> > +	ret = -EISDIR;
> > +	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> > +		goto out_unlock;
> > +	ret = -EINVAL;
> > +	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
> > +		goto out_unlock;
> > +	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> > +		goto out_unlock;
> > +
> > +	/* Are we going all the way to the end? */
> > +	isize = i_size_read(inode_in);
> > +	if (isize == 0) {
> 
> It seems like most of this should be factored into a
> inode_reflink_ok() helper so that it can be shared between
> implementations.  Or maybe even inode_prepare_reflink if we can
> move the pagecache flushing and extent compare for the clone case
> into it as well.

<nod>

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

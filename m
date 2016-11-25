From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 25 Nov 2016 00:18:22 -0800
Subject: [Ocfs2-devel] [PATCH 6/7] ocfs2: implement the VFS clone_range,
 copy_range, and dedupe_range features
In-Reply-To: <147987580233.2678.3884516221182271613.stgit@birch.djwong.org>
References: <147987576127.2678.7138661302696363830.stgit@birch.djwong.org>
	<147987580233.2678.3884516221182271613.stgit@birch.djwong.org>
Message-ID: <20161125081822.GB22465@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mfasheh@versity.com, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, darwin.xupt@gmail.com, zren@suse.com, ocfs2-devel@oss.oracle.com

> +static ssize_t ocfs2_file_copy_range(struct file *file_in,
> +				     loff_t pos_in,
> +				     struct file *file_out,
> +				     loff_t pos_out,
> +				     size_t len,
> +				     unsigned int flags)
> +{
> +	int error;
> +
> +	error = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> +					  len, false);
> +	if (error)
> +		return error;
> +	return len;
> +}

Meh, another dummy copy_range implementation, they now officially
outnumber the real ones.  I've had a patch to move this shim to common
code forever, but the complete lack of copy_range testing kept me from
sending it.  I guess I should finally bite the bullet and we should move
it to the front of your series.

> +/* Lock an inode and grab a bh pointing to the inode. */
> +static int ocfs2_reflink_inodes_lock(struct inode *s_inode,
> +				     struct buffer_head **bh1,
> +				     struct inode *t_inode,
> +				     struct buffer_head **bh2)
> +{
> +	struct inode *inode1;
> +	struct inode *inode2;
> +	struct ocfs2_inode_info *oi1;
> +	struct ocfs2_inode_info *oi2;
> +	bool same_inode = (s_inode == t_inode);
> +	int status;
> +
> +	/* First grab the VFS and rw locks. */
> +	inode1 = s_inode;
> +	inode2 = t_inode;
> +	if (inode1->i_ino > inode2->i_ino)
> +		swap(inode1, inode2);
> +
> +	inode_lock(inode1);

For the VFS inode lock this should use lock_two_nondirectories.

> +	ret = -ETXTBSY;
> +	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
> +		goto out_unlock;
> +
> +	/* Don't reflink dirs, pipes, sockets... */
> +	ret = -EISDIR;
> +	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> +		goto out_unlock;
> +	ret = -EINVAL;
> +	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
> +		goto out_unlock;
> +	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> +		goto out_unlock;
> +
> +	/* Are we going all the way to the end? */
> +	isize = i_size_read(inode_in);
> +	if (isize == 0) {

It seems like most of this should be factored into a
inode_reflink_ok() helper so that it can be shared between
implementations.  Or maybe even inode_prepare_reflink if we can
move the pagecache flushing and extent compare for the clone case
into it as well.

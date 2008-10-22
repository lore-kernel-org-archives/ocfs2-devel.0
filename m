From: Jan Kara <jack@suse.cz>
Date: Wed, 22 Oct 2008 16:08:07 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Implementation of local and	global
	quota file handling
In-Reply-To: <20081021231046.GH2871@mail.oracle.com>
References: <12245234431180-git-send-email-jack@suse.cz>
	<20081021231046.GH2871@mail.oracle.com>
Message-ID: <20081022140807.GJ13868@duck.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue 21-10-08 16:10:46, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:57PM +0200, Jan Kara wrote:
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> 	The commit message could maybe use a little discussion of what
> quota bits go in the local file and what goes in the global.  It seems
> like less is written to the global file, but I might be wrong about
> that (eg, generic quota code might be writing there).
  Well, global file is actually more complicated, but generic code handles
that. In terms of frequency, we write more often to the local file, that is
right. It is a good idea to add there a description what goes where to the
changelog. I'll do that.

> > diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
> > new file mode 100644
> > index 0000000..33b47eb
> > --- /dev/null
> > +++ b/fs/ocfs2/quota.h
> > @@ -0,0 +1,182 @@
> > +/*
> > + * quota.h for OCFS2
> > + *
> > + * On disk quota structures for local and global quota file, in-memory
> > + * structures.
> 
> 	I'm thinking the on-disk structures belong in ocfs2_fs.h, which
> is where we define the disk format, and the in-memory structures belong
> here.
  OK, will do.

> > +/* Information header of local quota file (immediately follows the generic
> > + * header) */
> > +struct ocfs2_local_disk_dqinfo {
> > +	__le32 dqi_flags;	/* Flags for quota file */
> > +	__le32 dqi_chunks;	/* Number of chunks of quota structures
> > +				 * with a bitmap */
> > +	__le32 dqi_blocks;	/* Number of blocks allocated for quota file */
> > +};
> 
> 	Also, we'd love the on-disk structures to have the size/offset
> annotations we put in ocfs2_fs.h.  Yes, some of the smaller structures
> are pretty obvious, but having the hexadecimal values in the header
> often helps reading binary dumps.
  Will do.

> > +	while (toread > 0) {
> > +		tocopy = min(sb->s_blocksize - offset, toread);
> > +		bh = ocfs2_bread(gqinode, blk, &err, 0);
> > +		if (!bh) {
> > +			mlog_errno(err);
> > +			return err;
> > +		}
> 
> 	Fair warning - you use ocfs2_bread() a lot in here, but
> ocfs2_bread() is going away.  Before I realized you were going to use it
> (and conceptually that makes sense), it moved into fs/ocfs2/dir.c.  Then
> it morphed into ocfs2_read_dir_block()as part of my read-metadata branch
> at
> http://oss.oracle.com/git/jlbec/linux-2.6.git/?p=jlbec/linux-2.6.git;a=shortlog;h=read-metadata
> 	In the end, this code will be doing ocfs2_read_quota_block(), or
> perhaps different variations thereof (if there are different types of
> blocks in the quota file).  I'm going to refactor ocfs2_read_dir_block()
> and introduce the function ocfs2_read_virt_blocks().  It will look
> exactly like ocfs2_read_blocks() does in my read-metadata branch, except
> that it will take virtual block numbers rather than physical ones.
> Thus, you'll be able to write ocfs2_read_quota_block() as a thin
> wrapper around it, and replace your ocfs2_bread() calls easily.
> 	Obviously, you don't have to worry too much until this code
> moves atop the latest kernel code.  And I'm happy to help.
  I am warned ;) Seriously, when this happens it's trivial to fix and for
SLES11 I need a working version on top of 2.6.27... So I'll change this
later when integrating the patches upstream.

> > +/* Write bufferhead into the fs */
> > +static int ocfs2_modify_bh(struct inode *inode, struct buffer_head *bh,
> > +		void (*modify)(struct buffer_head *, void *), void *private)
> > +{
> > +	struct super_block *sb = inode->i_sb;
> > +	handle_t *handle;
> > +	int status;
> > +
> > +	handle = ocfs2_start_trans(OCFS2_SB(sb), 1);
> > +	if (IS_ERR(handle)) {
> > +		status = PTR_ERR(handle);
> > +		mlog_errno(status);
> > +		return status;
> > +	}
> > +	status = ocfs2_journal_access(handle, inode, bh,
> > +				      OCFS2_JOURNAL_ACCESS_WRITE);
> > +	if (status < 0) {
> > +		mlog_errno(status);
> > +		ocfs2_commit_trans(OCFS2_SB(sb), handle);
> > +		return status;
> > +	}
> > +	lock_buffer(bh);
> > +	modify(bh, private);
> > +	unlock_buffer(bh);
> > +	status = ocfs2_journal_dirty(handle, bh);
> > +	if (status < 0) {
> > +		mlog_errno(status);
> > +		ocfs2_commit_trans(OCFS2_SB(sb), handle);
> > +		return status;
> > +	}
> 
> 	ocfs2_journal_dirty() can't sanely return an error, because
> journal_dirty() can't either.  Someday it will become void.  You can
> take out all the error checking of your ocfs2_journal_dirty() calls.
  Thanks for letting me know. I'm not sure if I'll change that for the
first version but I'll put that on my todo list.

> 	Is this modify_bh() function the reason you need nested
> transactions?  The callers can't be audited for their transaction state?
  No, modify_bh() is just a helper for updating quota file block headers,
I don't think it's ever called when the trasaction is already started.
There are more subtle reasons why I wanted nested transactions as I
described in one of my previous emails...
  Thanks for the review.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

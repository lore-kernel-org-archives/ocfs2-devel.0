From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 14 Oct 2008 17:36:27 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Wrap inode block reads in a
	dedicated function.
In-Reply-To: <20081015001716.GL15154@wotan.suse.de>
References: <20081015001716.GL15154@wotan.suse.de>
Message-ID: <20081015003627.GE8025@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[Oops, properly Cc'd now]

On Tue, Oct 14, 2008 at 05:17:16PM -0700, Mark Fasheh wrote:
> On Mon, Oct 13, 2008 at 06:16:15PM -0700, Joel Becker wrote:
> > @@ -232,25 +231,17 @@ int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
> 
> These changes to ocfs2_populate_inode() look great.

	I thought you'd like that ;-)

> > +int ocfs2_read_inode_block(struct inode *inode, u64 blkno,
> > +			   struct buffer_head **bh)
> > +{
> 
> Can we get rid of the blkno argument here, and just get it from
> OCFS2_I(inode)->ip_blkno? Getting it out of ocfs2_read_inode_block_full()
> might be nice too, but not as big a deal since it isn't called as much.

	I did that patch right before the concall.  I just had to verify
my hunch that all callers had a valid ip_blkno.  Attached ;-)

> API-wise, this is a very nice change. It makes the checks we have more
> consistent. I think it'd be worth the time though to figure out how to
> execute the validation code only when we've actually read the disk.

	I'm glad you like the API (I'm almost done with group
descriptors now too).  Regarding 'only on read', when I have the
callback in ocfs2_read_blocks() to handle that, I can easily lift all of
the validation there (instead of just the checksum).  Basically, I'm
refactoring all the metadata reads before I do the read_blocks() hook.
It seems a much easier to follow series.

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-Callers-of-ocfs2_read_inode_block-don-t-nee.patch
Type: text/x-diff
Size: 0 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081014/e55f6a24/attachment.bin 

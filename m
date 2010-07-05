From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 05 Jul 2010 11:51:44 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Zero the tail cluster when
 extending past i_size v2
In-Reply-To: <20100703213219.GB21262@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<20100629015615.GZ6590@dastard>
	<20100629020420.GE24343@mail.oracle.com>
	<20100629022757.GA6590@dastard>
	<20100629071817.GA4150@mail.oracle.com>
	<20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
Message-ID: <4C3156D0.5090001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>

Hi Joel,

On 07/04/2010 05:32 AM, Joel Becker wrote:
> 	Here's the second version of my corruption fix.  It fixes two
> bugs:
>
> 1) i_size can obviously be at a place that is a hole, so don't BUG on
>     that.
> 2) Fix an off-by-one when checking whether the write position is within
>     the tail allocation.
>
> This version passes my tail corruption test as well as the kernel
> compile that exposed the two bugs above.
>
> Joel
>
> ---------------------------------------------------------------
>
> ocfs2's allocation unit is the cluster.  This can be larger than a block
> or even a memory page.  This means that a file may have many blocks in
> its last extent that are beyond the block containing i_size.
>
> When ocfs2 grows a file, it zeros the entire cluster in order to ensure
> future i_size growth will see cleared blocks.  Unfortunately,
> block_write_full_page() drops the pages past i_size.  This means that
> ocfs2 is actually leaking garbage data into the tail end of that last
> cluster.
>
> We adjust ocfs2_write_begin_nolock() and ocfs2_extend_file() to detect
> when a write or truncate is past i_size.  If there is any existing
> allocation between the block containing the current i_size and the
> location of the write or truncate, zeros will be written to that
> allocation.
>
> This is only for sparse filesystems.  Non-sparse filesystems already get
> this via ocfs2_extend_no_holes().
>
> Signed-off-by: Joel Becker<joel.becker@oracle.com>
> ---
>   fs/ocfs2/aops.c |   22 ++++----
>   fs/ocfs2/file.c |  154 +++++++++++++++++++++++++++++++++++++++++++++++++------
>   fs/ocfs2/file.h |    2 +
>   3 files changed, 150 insertions(+), 28 deletions(-)
>
<snip>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6a13ea6..7fca78d 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -848,6 +848,137 @@ out:
>   	return ret;
>   }
>
> +/*
> + * This function is a helper for ocfs2_zero_tail().  It calculates
> + * what blocks need zeroing and does any CoW necessary.
> + */
> +static int ocfs2_zero_tail_prepare(struct inode *inode,
> +				   struct buffer_head *di_bh,
> +				   loff_t pos, u64 *start_blkno,
> +				   u64 *blocks)
> +{
> +	int rc = 0;
> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
> +	u32 tail_cpos, pos_cpos, p_cpos;
> +	u64 tail_blkno, pos_blkno, blocks_to_zero;
> +	unsigned int num_clusters = 0;
> +	unsigned int ext_flags = 0;
> +
> +	/*
> +	 * The block containing i_size has already been zeroed, so our tail
> +	 * block is the first block after i_size.  The block containing
> +	 * pos will be zeroed.  So we only need to do anything if
> +	 * tail_blkno is before pos_blkno.
> +	 */
> +	tail_blkno = (i_size_read(inode)>>  inode->i_sb->s_blocksize_bits) + 1;
> +	pos_blkno = pos>>  inode->i_sb->s_blocksize_bits;
> +	mlog(0, "tail_blkno = %llu, pos_blkno = %llu\n",
> +	     (unsigned long long)tail_blkno, (unsigned long long)pos_blkno);
> +	if (pos_blkno<= tail_blkno)
> +		goto out;
> +	blocks_to_zero = pos_blkno - tail_blkno;
> +
> +	/*
> +	 * If tail_blkno is in the cluster past i_size, we don't need
> +	 * to touch the cluster containing i_size at all.
> +	 */
> +	tail_cpos = i_size_read(inode)>>  osb->s_clustersize_bits;
> +	if (ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)>  tail_cpos)
> +		tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
> +						     tail_blkno);
Can we always set tail_cpos in one line?
	tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)?
tail_cpos is either the same cluster as i_size or the next cluster and 
both works for tail_blkno I guess?
> +
> +	rc = ocfs2_get_clusters(inode, tail_cpos,&p_cpos,&num_clusters,
> +				&ext_flags);
> +	if (rc) {
> +		mlog_errno(rc);
> +		goto out;
> +	}
> +
> +	/* Is there a cluster to zero? */
> +	if (!p_cpos)
> +		goto out;
For unwritten extent, we also need to clear the pages? If yes, the 
solution doesn't complete if we have 2 unwritten extent, one contains 
i_size while one passes i_size. Here we only clear the pages for the 1st 
unwritten extent and leave the 2nd one untouched.
> +
> +	pos_cpos = pos>>  osb->s_clustersize_bits;
> +	mlog(0, "tail_cpos = %u, num_clusters = %u, pos_cpos = %u, tail_blkno = %llu, pos_blkno = %llu\n",
> +	     (unsigned int)tail_cpos, (unsigned int)num_clusters,
> +	     (unsigned int)pos_cpos, (unsigned long long)tail_blkno,
> +	     (unsigned long long)pos_blkno);
 From here to the call of CoW is a bit hard to understand. In 'if', 
num_clusters is set for CoW and in 'else', blocks_to_zero is set. So it 
isn't easy for the reader to tell why these 2 clauses are setting 
different values. So how about my code below? It looks more 
straightforward I think.
> +	if ((tail_cpos + num_clusters)>  pos_cpos) {
> +		num_clusters = pos_cpos - tail_cpos;
> +		if (pos_blkno>
> +		    ocfs2_clusters_to_blocks(inode->i_sb, pos_cpos))
> +			num_clusters += 1;
> +	} else {
> +		blocks_to_zero =
> +			ocfs2_clusters_to_blocks(inode->i_sb,
> +						 tail_cpos + num_clusters);
> +		blocks_to_zero -= tail_blkno;
> +	}
> +
> +	/* Now CoW the clusters we're about to zero */
> +	if (ext_flags&  OCFS2_EXT_REFCOUNTED) {
> +		rc = ocfs2_refcount_cow(inode, di_bh, tail_cpos,
> +					num_clusters, UINT_MAX);
> +		if (rc) {
> +			mlog_errno(rc);
> +			goto out;
> +		}
> +	}
	/* Decrease blocks_to_zero if there is some hole after extent */
	if (tail_cpos + num_clusters <= pos_cpos) {
		blocks_to_zero =
			ocfs2_clusters_to_blocks(inode->i_sb,
						 tail_cpos + num_clusters);
		blocks_to_zero -= tail_blkno;
	}

	/* Now CoW if we have some refcounted clusters. */
	if (ext_flags & OCFS2_EXT_REFCOUNTED) {
		/*
		 * We add one more cluster here since it will be
		 * written shortly and if the pos_blkno isn't aligned
		 * to the cluster size, we have to zero the blocks
		 * before it.
		 */
		if (tail_cpos + num_clusters > pos_cpos)
			num_clusters = pos_cpos - tail_cpos + 1;

		rc = ocfs2_refcount_cow(inode, di_bh, tail_cpos,
					num_clusters, UINT_MAX);
		if (rc) {
			mlog_errno(rc);
			goto out;
		}

	}
> +
> +	*start_blkno = tail_blkno;
> +	*blocks = blocks_to_zero;
> +	mlog(0, "start_blkno = %llu, blocks = %llu\n",
> +	     (unsigned long long)(*start_blkno),
> +	     (unsigned long long)(*blocks));
> +
> +out:
> +	return rc;
> +}

Regards,
Tao

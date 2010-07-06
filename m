From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 06 Jul 2010 15:54:58 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Zero the tail cluster when
 extending past i_size v2
In-Reply-To: <20100706071741.GF13023@mail.oracle.com>
References: <20100628173529.GA10573@mail.oracle.com>
	<20100629002421.GY6590@dastard>
	<20100629005403.GC24343@mail.oracle.com>
	<20100629015615.GZ6590@dastard>
	<20100629020420.GE24343@mail.oracle.com>
	<20100629022757.GA6590@dastard>
	<20100629071817.GA4150@mail.oracle.com>
	<20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
	<4C3156D0.5090001@oracle.com>
	<20100706071741.GF13023@mail.oracle.com>
Message-ID: <4C32E152.1090902@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>

Hi Joel,

On 07/06/2010 03:17 PM, Joel Becker wrote:
> On Mon, Jul 05, 2010 at 11:51:44AM +0800, Tao Ma wrote:
>>> +	/*
>>> +	 * If tail_blkno is in the cluster past i_size, we don't need
>>> +	 * to touch the cluster containing i_size at all.
>>> +	 */
>>> +	tail_cpos = i_size_read(inode)>>   osb->s_clustersize_bits;
>>> +	if (ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)>   tail_cpos)
>>> +		tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
>>> +						     tail_blkno);
>> Can we always set tail_cpos in one line?
>> 	tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)?
>> tail_cpos is either the same cluster as i_size or the next cluster
>> and both works for tail_blkno I guess?
>
> 	I had the same thought on Friday, but the current version passes
> testing and I was wary of changing that.
ok, so as you wish.
>
>>> +	/* Is there a cluster to zero? */
>>> +	if (!p_cpos)
>>> +		goto out;
>> For unwritten extent, we also need to clear the pages? If yes, the
>> solution doesn't complete if we have 2 unwritten extent, one
>> contains i_size while one passes i_size. Here we only clear the
>> pages for the 1st unwritten extent and leave the 2nd one untouched.
>
> 	We probably don't need to zero unwritten extents.  We cannot
> have an extent past i_size, can we?
we can. AFAICS, ocfs2_change_file_space will allocate unwritten extents 
and does't change i_size.
>
>>  From here to the call of CoW is a bit hard to understand. In 'if',
>> num_clusters is set for CoW and in 'else', blocks_to_zero is set. So
>> it isn't easy for the reader to tell why these 2 clauses are setting
>> different values. So how about my code below? It looks more
>> straightforward I think.
>>> +	if ((tail_cpos + num_clusters)>   pos_cpos) {
>>> +		num_clusters = pos_cpos - tail_cpos;
>>> +		if (pos_blkno>
>>> +		    ocfs2_clusters_to_blocks(inode->i_sb, pos_cpos))
>>> +			num_clusters += 1;
>>> +	} else {
>>> +		blocks_to_zero =
>>> +			ocfs2_clusters_to_blocks(inode->i_sb,
>>> +						 tail_cpos + num_clusters);
>>> +		blocks_to_zero -= tail_blkno;
>>> +	}
>>> +
>>> +	/* Now CoW the clusters we're about to zero */
>>> +	if (ext_flags&   OCFS2_EXT_REFCOUNTED) {
>>> +		rc = ocfs2_refcount_cow(inode, di_bh, tail_cpos,
>>> +					num_clusters, UINT_MAX);
>>> +		if (rc) {
>>> +			mlog_errno(rc);
>>> +			goto out;
>>> +		}
>>> +	}
>> 	/* Decrease blocks_to_zero if there is some hole after extent */
>> 	if (tail_cpos + num_clusters<= pos_cpos) {
>> 		blocks_to_zero =
>> 			ocfs2_clusters_to_blocks(inode->i_sb,
>> 						 tail_cpos + num_clusters);
>> 		blocks_to_zero -= tail_blkno;
>> 	}
>
> 	Not a bad split-out here.
>
>> 	/* Now CoW if we have some refcounted clusters. */
>> 	if (ext_flags&  OCFS2_EXT_REFCOUNTED) {
>> 		/*
>> 		 * We add one more cluster here since it will be
>> 		 * written shortly and if the pos_blkno isn't aligned
>> 		 * to the cluster size, we have to zero the blocks
>> 		 * before it.
>> 		 */
>> 		if (tail_cpos + num_clusters>  pos_cpos)
>> 			num_clusters = pos_cpos - tail_cpos + 1;
>
> 	But you dropped the check for pos_blkno alignment.
> Unconditionally adding the +1 doesn't seem like a good idea.
You can add it as you wish.
I just thought that you add one more extra cluster if pos_blkno isn't 
aligned so as to zero blocks in [pos_cpos_start_block, pos_blkno).
But As I said in the comments, you will soon write pos_blkno(it also 
needs to be CoW since it is within this refcounted extent), so if we can 
CoW it out now, maybe we have a chance to not call ocfs2_refcount_cow later.

Regards,
Tao

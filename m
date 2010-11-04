From: tristan <tristan.ye@oracle.com>
Date: Thu, 04 Nov 2010 10:56:09 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add a new code
 'OCFS2_INFO_FREEFRAG' for o2info ioctl.
In-Reply-To: <20101104012949.GB14640@mail.oracle.com>
References: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
	<1288782126-13007-2-git-send-email-tristan.ye@oracle.com>
	<20101104012949.GB14640@mail.oracle.com>
Message-ID: <4CD220C9.20907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Nov 03, 2010 at 07:02:06PM +0800, Tristan Ye wrote:
>> This new code is a bit more complicated than former ones, the goal is to
>> show user all statistics required to take a deep insight into filesystem
>> on how the disk is being fragmentaed.
>>
>> The goal is achieved by scaning global bitmap from (cluster)group to group
>> to figure out following factors in the filesystem:
>>
>> 	- How many free chunks in a fixed size as user requested.
>> 	- How many real free chunks in all size.
>
> 	Let me see if I understand the above requirements.  In the same
> call, you are going build a list of free chunk sizes.  Then you will
> also count how many chunks of a user-specified size.  Why can't the user
> just take the list and look at the size they want?  What do they get
> from specifying a size to the ioctl(2)?
Actually, the original idea was borrowed from ext4, while it only did 
this in userspace however.

Let me try to explain this in a detailed way, I'm not surprised that 
you'll be confused a little bit;-)

I did maintain some lists, while they're not lists of free chunk sizes, 
the list was indexed by size range, see:
-------------------------------------------------------------------------------------------
Extent Size Range : Free extents Free Clusters Percent
4K... 8K- : 9 9 0.00%
8K... 16K- : 12 31 0.00%
16K... 32K- : 45 249 0.03%
32K... 64K- : 376 4654 0.59%
8M... 16M- : 2 5180 0.66%
16M... 32M- : 5 27556 3.50%
32M... 64M- : 1 16087 2.04%
64M... 128M- : 24 733653 93.17%
-------------------------------------------------------------------------------------------
Here I maintained two lists fc_chunks and fc_clusters, the former one 
records the number of chunks whose size was within
the size range, while the latter one keeps the number of free clusters 
in that range.


While the user-specified chunksize is brand-new concept here;), it 
splits the whole bitmap from chunk to chunk sequentially.
and then to see how many of this sequential/fixed-size chunks are free. 
it sounds like the concept of page frame for main memory.
When a user is doing I/Os in a very size-fixed fashion, they may be 
happy to see how many chunks were fully free there.

Besides, we also keep track of the number/min_size/max_size/avg_size of 
free chunks in all size being counted.


Goal here is to provide user a deep insight into fs's fragmentation.

>
>   
>> +void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg, __u32 chunksize)
>> +{
>> +	int index;
>> +
>> +	index = __ilog2_u32(chunksize);
>> +	if (index >= OCFS2_INFO_MAX_HIST)
>> +		index = OCFS2_INFO_MAX_HIST - 1;
>> +
>> +	ffg->iff_ffs.ffs_fc_hist.fc_chunks[index]++;
>> +	ffg->iff_ffs.ffs_fc_hist.fc_clusters[index] += chunksize;
>> +
>> +	if (chunksize > ffg->iff_ffs.ffs_max)
>> +		ffg->iff_ffs.ffs_max = chunksize;
>> +
>> +	if (chunksize < ffg->iff_ffs.ffs_min)
>> +		ffg->iff_ffs.ffs_min = chunksize;
>> +
>> +	ffg->iff_ffs.ffs_avg += chunksize;
>> +	ffg->iff_ffs.ffs_free_chunks_real++;
>> +}
>
> 	I'm sorry, but this is just unreadable.  I get that we can only
> abbreviate 'free-frag-scan' so many ways, but there is no way people
> will understand this.
> 	I don't think renaming helps too much.  These names are always
> going to be bad.  I think we *can* reduce the long structure strings,
> mostly with helper functions.
> 	For example, here we could have:
>
> static void o2ffg_update_histogram(struct ocfs2_info_free_chunk_list *hist,
>                                    unsigned int chunksize)
> {
> 	int index;
>
> 	index = __ilog2_u32(chunksize);
> 	if (index >= OCFS2_INFO_MAX_HIST)
> 		index = OCFS2_INFO_MAX_HIST - 1;
>
> 	hist->fc_chunks[index]++;
> 	hist->fc_clusters[index] += chunksize;
> }
>
> static void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
>                                   unsigned int chunksize)
> {
> 	o2ffg_update_histogram(&ffg->iff_ffs.ffs_fc_hist, chunksize);
>
>  	...
> }
>
> and so on.  Btw, the chunksize can be an unsigned int, as the calling
> function uses that type and not the more specific __u32.

Make sense.

>
>> +int ocfs2_info_freefrag_scan_bitmap(struct inode *gb_inode,
>> +				    struct ocfs2_info_freefrag *ffg)
>> +{
>> +	__u32 chunks_in_group;
>> +	int status = 0, unlock = 0, i;
>> +
>> +	struct buffer_head *bh = NULL;
>> +	struct ocfs2_chain_list *cl = NULL;
>> +	struct ocfs2_chain_rec *rec = NULL;
>> +	struct ocfs2_dinode *gb_dinode = NULL;
>> +
>> +	mutex_lock(&gb_inode->i_mutex);
>> +
>> +	if (!(ffg->iff_req.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
>> +		status = ocfs2_inode_lock(gb_inode, &bh, 0);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto bail;
>> +		}
>> +		unlock = 1;
>> +	} else {
>> +		status = ocfs2_read_inode_block(gb_inode, &bh);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto bail;
>> +		}
>> +	}
>
> 	Same thoughts about ocfs2_ilookup() here.

Why we need to think about ocfs2_ilookup? since we're just trying to get 
a inode block here, not a cached VFS inode.

>
> Joel
>

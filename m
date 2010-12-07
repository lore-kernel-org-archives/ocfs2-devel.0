From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 07 Dec 2010 09:45:38 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEFRAG' for o2info ioctl.
In-Reply-To: <20101207011159.GN16687@mail.oracle.com>
References: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
	<1289902422-3315-4-git-send-email-tristan.ye@oracle.com>
	<20101207011159.GN16687@mail.oracle.com>
Message-ID: <4CFD91C2.1070605@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Nov 16, 2010 at 06:13:42PM +0800, Tristan Ye wrote:
>> +static void o2ffg_update_histogram(struct ocfs2_info_free_chunk_list *hist,
>> +				   unsigned int chunksize)
>> +{
>> +	int index;
>> +
>> +	index = __ilog2_u32(chunksize);
>> +	if (index >= OCFS2_INFO_MAX_HIST)
>> +		index = OCFS2_INFO_MAX_HIST - 1;
>> +
>> +	hist->fc_chunks[index]++;
>> +	hist->fc_clusters[index] += chunksize;
>> +}
>> +
>> +static void o2ffg_update_stats(struct ocfs2_info_freefrag_stats *stats,
>> +			       unsigned int chunksize)
>> +{
>> +	if (chunksize > stats->ffs_max)
>> +		stats->ffs_max = chunksize;
>> +
>> +	if (chunksize < stats->ffs_min)
>> +		stats->ffs_min = chunksize;
>> +
>> +	stats->ffs_avg += chunksize;
>> +	stats->ffs_free_chunks_real++;
>> +}
>
> 	MUCH more readable.
>
>> +int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
>> +				    struct inode *gb_inode, u64 blkno,
>> +				    struct ocfs2_info_freefrag *ffg)
>> +{
>> +	u32 chunks_in_group;
>> +	int status = 0, unlock = 0, i;
>> +
>> +	struct buffer_head *bh = NULL;
>> +	struct ocfs2_chain_list *cl = NULL;
>> +	struct ocfs2_chain_rec *rec = NULL;
>> +	struct ocfs2_dinode *gb_dinode = NULL;
>> +
>> +	if (gb_inode)
>> +		mutex_lock(&gb_inode->i_mutex);
>> +
>> +	if (o2info_coherent(*ffg)) {
>> +		status = ocfs2_inode_lock(gb_inode, &bh, 0);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto bail;
>> +		}
>> +		unlock = 1;
>> +	} else {
>> +		status = ocfs2_read_blocks_sync(osb, blkno, 1, &bh);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto bail;
>> +		}
>> +	}
>> +
>> +	gb_dinode = (struct ocfs2_dinode *)bh->b_data;
>> +	cl = &(gb_dinode->id2.i_chain);
>
> 	This is safe because we never remove a chain entry from an
> inode.  However, if we ever shrink disks, we'll need to coordinate with
> this code.  Perhaps we should comment that.

    Alright, and the recoordination only would be needed for 
none-coherency case, right?

Fully-coherent case will be holding the inode lock, and never allow disk 
to be shrinked during the inquiry.

    Oh, Wait, an arbitrary 'fdisk' can shrink the disk regardless of 
cluster-coherency.

>
> Joel
>

From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 12 Jul 2008 08:42:18 +0800
Subject: [Ocfs2-devel] [PATCH 12/15] Add xattr find process for xattr
 index btree.v2
In-Reply-To: <20080711235914.GD9557@wotan.suse.de>
References: <48648B3E.6050808@oracle.com>
	<20080627070235.GA20375@tma-pc2.cn.oracle.com>
	<20080711235914.GD9557@wotan.suse.de>
Message-ID: <4877FDEA.4090801@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:
> On Fri, Jun 27, 2008 at 03:02:35PM +0800, Tao Ma wrote:
>> +/*
>> + * Find the specided xattr entry in a series of buckets.
>> + * This series start from p_blkno and last for num_clusters.
>> + * The ocfs2_xattr_header.xh_reserved1 of the first bucket contains
>> + * the num of the valid buckets.
>> + *
>> + * Return the buffer_head this xattr should reside in. And if the xattr's
>> + * hash is in the gap of 2 buckets, return the lower bucket.
>> + */
>> +static int ocfs2_xattr_bucket_find(struct inode *inode,
>> +				   int name_index,
>> +				   const char *name,
>> +				   u32 name_hash,
>> +				   u64 p_blkno,
>> +				   u32 first_hash,
>> +				   u32 num_clusters,
>> +				   struct ocfs2_xattr_search *xs)
>> +{
>> +	int ret, found = 0;
>> +	struct buffer_head *bh = NULL;
>> +	struct buffer_head *last_bh = NULL;
>> +	struct buffer_head *lower_bh = NULL;
>> +	struct ocfs2_xattr_header *xh = NULL;
>> +	struct ocfs2_xattr_entry *xe = NULL;
>> +	u16 xh_count, xe_index = 0;
>> +	u16 block_in_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
>> +	int low_bucket = 0, bucket, high_bucket;
>> +	int blocksize = inode->i_sb->s_blocksize;
>> +	u32 last_hash;
>> +	u64 blkno;
>> +
>> +	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), p_blkno,
>> +			       &bh, OCFS2_BH_CACHED, inode);
>> +	if (ret)
>> +		goto out;
>> +	xh = (struct ocfs2_xattr_header *)bh->b_data;
>> +	high_bucket = le16_to_cpu(xh->xh_reserved1) - 1;
>> +
>> +	while (low_bucket <= high_bucket) {
>> +		brelse(bh);
>> +		bh = last_bh = NULL;
>> +		bucket = (low_bucket + high_bucket) / 2;
>> +
>> +		blkno = p_blkno + bucket * block_in_bucket;
>> +
>> +		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
>> +				       &bh, OCFS2_BH_CACHED, inode);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>> +		xh = (struct ocfs2_xattr_header *)bh->b_data;
>> +		xe = &xh->xh_entries[0];
>> +		if (name_hash < le32_to_cpu(xe->xe_name_hash)) {
>> +			high_bucket = bucket - 1;
>> +			continue;
>> +		}
> 
> This function looks like it's doing a lot of random I/O. What about sucking
> up some large numbers of (contiguous) blocks with a readahead request before
> going into this function? The beauty of how our readhead works is that you
> wouldn't have to change a single line of code here..
Do you mean add OCFS2_BH_READAHEAD in read_block flag?
Not sure whether readahead can help us much. We normally only read the 
header of a bucket, as for bs=1K, we only read 1 block for every 4 
blocks, so most of readahead is useless. And even worse, with binary 
search, we really don't know which block we will read before the search. 
So can readahead help us in this issue? I am not familiar with IO 
readahead, so please be patient and explain it to you if you have time. ;)

Regards,
Tao

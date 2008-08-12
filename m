From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 12 Aug 2008 14:42:30 -0700
Subject: [Ocfs2-devel] [PATCH 12/15] Add xattr find process for xattr
	index btree.v3
In-Reply-To: <1218061894-7693-10-git-send-email-tao.ma@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-10-git-send-email-tao.ma@oracle.com>
Message-ID: <20080812214230.GJ21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 07, 2008 at 06:31:32AM +0800, Tao Ma wrote:
> +
> +/*
> + * Find the specided xattr entry in a series of buckets.
"specified"

> + * This series start from p_blkno and last for num_clusters.
> + * The ocfs2_xattr_header.xh_num_buckets of the first bucket contains
> + * the num of the valid buckets.
> + *
> + * Return the buffer_head this xattr should reside in. And if the xattr's
> + * hash is in the gap of 2 buckets, return the lower bucket.
> + */
> +static int ocfs2_xattr_bucket_find(struct inode *inode,
> +				   int name_index,
> +				   const char *name,
> +				   u32 name_hash,
> +				   u64 p_blkno,
> +				   u32 first_hash,
> +				   u32 num_clusters,
> +				   struct ocfs2_xattr_search *xs)
> +{
> +	int ret, found = 0;
> +	struct buffer_head *bh = NULL;
> +	struct buffer_head *lower_bh = NULL;
> +	struct ocfs2_xattr_header *xh = NULL;
> +	struct ocfs2_xattr_entry *xe = NULL;
> +	u16 index = 0;
> +	u16 blk_per_bucket = ocfs2_blocks_per_xattr_bucket(inode->i_sb);
> +	int low_bucket = 0, bucket, high_bucket;
> +	u32 last_hash;
> +	u64 blkno;
> +
> +	ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), p_blkno,
> +			       &bh, OCFS2_BH_CACHED, inode);
> +	if (ret) {
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
> +	xh = (struct ocfs2_xattr_header *)bh->b_data;
> +	high_bucket = le16_to_cpu(xh->xh_num_buckets) - 1;
> +
> +	while (low_bucket <= high_bucket) {
> +		brelse(bh);
> +		bh = NULL;
> +		bucket = (low_bucket + high_bucket) / 2;
> +
> +		blkno = p_blkno + bucket * blk_per_bucket;
> +
> +		ret = ocfs2_read_block(OCFS2_SB(inode->i_sb), blkno,
> +				       &bh, OCFS2_BH_CACHED, inode);
> +		if (ret) {
> +			mlog_errno(ret);
> +			goto out;
> +		}
> +
> +		xh = (struct ocfs2_xattr_header *)bh->b_data;
> +		xe = &xh->xh_entries[0];
> +		if (name_hash < le32_to_cpu(xe->xe_name_hash)) {
> +			high_bucket = bucket - 1;
> +			continue;
> +		}
> +
> +		/*
> +		 * Check whether the hash of the last entry in our
> +		 * bucket is larger than the search one.
> +		 */
> +		xe = &xh->xh_entries[le16_to_cpu(xh->xh_count) - 1];
> +		last_hash = le32_to_cpu(xe->xe_name_hash);
> +
> +		/* record lower_bh which may be the insert place. */
> +		brelse(lower_bh);
> +		lower_bh = bh;
> +		bh = NULL;
> +
> +		if (name_hash > le32_to_cpu(xe->xe_name_hash)) {
> +			low_bucket = bucket + 1;
> +			continue;
> +		}
> +
> +		/* the searched xattr should reside in this bucket if exists. */
> +		ret = ocfs2_find_xe_in_bucket(inode, lower_bh,
> +					      name_index, name, name_hash,
> +					      &index, &found);

'ret' isn't checked here, and it's overwritten unconditionally below, so I
assume you meant to check it for error at least...
	--Mark

--
Mark Fasheh

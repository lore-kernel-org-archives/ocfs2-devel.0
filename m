From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 12 Jul 2008 07:52:25 +0800
Subject: [Ocfs2-devel] [PATCH 11/15] Add xattr bucket iteration for
 large numbers of	EAs.v2
In-Reply-To: <20080711203255.GB9557@wotan.suse.de>
References: <48648B3E.6050808@oracle.com>
	<20080627070217.GA20369@tma-pc2.cn.oracle.com>
	<20080711203255.GB9557@wotan.suse.de>
Message-ID: <4877F239.9090906@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Mark Fasheh wrote:
> [ patches 9, 10 look great ]
> 
> On Fri, Jun 27, 2008 at 03:02:17PM +0800, Tao Ma wrote:
>> We use bucket in ocfs2 to store large numbers of EAs, and list
>> xattrs will iterate all the buckets and list all the names one by
>> one. This patch add the iteration for the xattr bucket. For how
>> xattr bucket looks like and their disk layout, please see
>> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedEATrees.
>>
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>> +/*
>> + * Find the xattr extent rec which may contains name_hash.
>> + * e_cpos will be the first name hash of the xattr rec.
>> + * el must be the ocfs2_xattr_header.xb_attrs.xb_root.xt_list.
>> + */
>> +static int ocfs2_xattr_get_rec(struct inode *inode,
>> +			       u32 name_hash,
>> +			       u64 *p_blkno,
>> +			       u32 *e_cpos,
>> +			       u32 *num_clusters,
>> +			       struct ocfs2_extent_list *el)
>> +{
>> +	int ret = 0, i;
>> +	struct buffer_head *eb_bh = NULL;
>> +	struct ocfs2_extent_block *eb;
>> +	struct ocfs2_extent_rec *rec = NULL;
>> +	u64 e_blkno = 0;
>> +
>> +	if (el->l_tree_depth) {
>> +		ret = ocfs2_find_leaf(inode, el, name_hash, &eb_bh);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>> +		eb = (struct ocfs2_extent_block *) eb_bh->b_data;
>> +		el = &eb->h_list;
>> +
>> +		if (el->l_tree_depth) {
>> +			ocfs2_error(inode->i_sb,
>> +				    "Inode %lu has non zero tree depth in "
>> +				    "xattr tree block %llu\n", inode->i_ino,
>> +				    (unsigned long long)eb_bh->b_blocknr);
>> +			ret = -EROFS;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>> +		rec = &el->l_recs[i];
>> +
>> +		if (le32_to_cpu(rec->e_cpos) <= name_hash) {
>> +			e_blkno = le64_to_cpu(rec->e_blkno);
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!e_blkno) {
>> +		ocfs2_error(inode->i_sb, "Inode %lu has bad extent "
>> +			    "record (%u, %u, 0) in xattr", inode->i_ino,
>> +			    le32_to_cpu(rec->e_cpos),
>> +			    ocfs2_rec_clusters(el, rec));
>> +		ret = -EROFS;
> 
> So, is it illegal to ask this function to find a value which doesn't exist?
> 
> From the way it's called below, it seems like it ought to just be returning
> -ENOENT when it doesn't find anything...
Actually we will never meet with -ENOENT. The first extent rec start 
with 0, and we will return the extent record whose start number is less 
than the name hash we want. And this function only return the *maybe* 
extent rec. The really find process will be in the next patch. ;)
>> +	struct buffer_head **bhs = NULL;
>> +	int blocksize = inode->i_sb->s_blocksize;
>> +
>> +	mlog(0, "iterating xattr buckets in %u clusters starting from %llu\n",
>> +	     clusters, blkno);
>> +
>> +	bhs = kcalloc(block_num, sizeof(struct buffer_head *), GFP_NOFS);
>> +	if (!bhs)
>> +		return -ENOMEM;
>> +
>> +	if (block_num > 1) {
>> +		bucket = kmalloc(OCFS2_XATTR_BUCKET_SIZE,  GFP_NOFS);
>> +		if (!bucket) {
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
>> +		alloc_bucket = 1;
>> +	}
>> +
>> +	for (i = 0; i < bucket_num; i++, blkno += block_num) {
>> +		ret = ocfs2_read_blocks(OCFS2_SB(inode->i_sb), blkno, block_num,
>> +					bhs, OCFS2_BH_CACHED, inode);
>> +		if (ret) {
>> +			mlog_errno(ret);
>> +			goto out;
>> +		}
>> +
>> +		if (block_num > 1) {
>> +			buf = bucket;
>> +			for (j = 0; j < block_num; j++, buf += blocksize)
>> +				memcpy(buf, bhs[j]->b_data, blocksize);
> 
> Hmm, this is going to be expensive when we have lots of xattrs. The alloc
> above is less of a concern, but if we could avoid doing it for every bucket,
> that would be good too. How performance critical is this function?
> 
> What if we change it so that the callback just gets the arrray of bh's? Then
> how to interpret them is up to the caller. If
> ocfs2_xattr_tree_list_index_block() can cope with this overhead, then we
> could do the kcalloc up in the parent function, pass it down as a parameter,
> and let ocfs2_list_xattr_bucket() do the memcpy().
Yeah, a very good idea. So the iteration buckets will only do the 
read_bucket work and let the caller do the rest. We will move all the 
_what they want to do_ to themselves.Cool, I will modify this.

> 
> 
> 
>> +		} else
>> +			bucket = bhs[0]->b_data;
>> +
>> +		xh = (struct ocfs2_xattr_header *)bucket;
>> +		/*
>> +		 * The real bucket num in this series of blocks is stored
>> +		 * in the 1st bucket.
>> +		 */
>> +		if (i == 0)
>> +			bucket_num = le16_to_cpu(xh->xh_reserved1);
> 
> Do you really mean "xh_reserved1" here? If so, please just give that field a
> useful name ;) *_reserved* usually indicates that it's unused...
In your design doc 
http://oss.oracle.com/osswiki/OCFS2/DesignDocs/IndexedEATrees you said 
"We can store the current number of contiguous, non-empty buckets by 
storing it in the 16 bit xh_reserved1 field. " So do I misread it(you 
mean use this field and change it to another name)?

Regards,
Tao

From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 15 Aug 2008 15:17:29 +0800
Subject: [Ocfs2-devel] [PATCH 03/15] Abstract ocfs2_extent_tree
 in	b-tree operations.
In-Reply-To: <20080814195522.GA28875@mail.oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-3-git-send-email-tao.ma@oracle.com>
	<20080814195522.GA28875@mail.oracle.com>
Message-ID: <48A52D89.6090306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
>
>> +struct ocfs2_extent_tree_operations {
>> +	void (*set_last_eb_blk) (struct ocfs2_extent_tree *et, u64 blkno);
>> +	u64 (*get_last_eb_blk) (struct ocfs2_extent_tree *et);
>> +	void (*update_clusters) (struct inode *inode,
>> +				 struct ocfs2_extent_tree *et,
>> +				 u32 new_clusters);
>> +	int (*sanity_check) (struct inode *inode, struct ocfs2_extent_tree *et);
>> +};
> 
> 	Can we please prefix these?  et_set_last_eb_blk,
> et_update_clusters, etc.
ok.
> 
>> +struct ocfs2_extent_tree {
>> +	enum ocfs2_extent_tree_type type;
>> +	struct ocfs2_extent_tree_operations *eops;
>> +	struct buffer_head *root_bh;
>> +	struct ocfs2_extent_list *root_el;
>> +};
> 
> 	And these too?  et_type, et_ops, et_root_bh, et_root_el.
ok.
> 
>>  int ocfs2_num_free_extents(struct ocfs2_super *osb,
>>  			   struct inode *inode,
>> -			   struct buffer_head *bh)
>> +			   struct buffer_head *root_bh,
>> +			   enum ocfs2_extent_tree_type type)
>>  {
>>  	int retval;
>> -	struct ocfs2_extent_list *el;
>> +	struct ocfs2_extent_list *el = NULL;
>>  	struct ocfs2_extent_block *eb;
>>  	struct buffer_head *eb_bh = NULL;
>> -	struct ocfs2_dinode *fe = (struct ocfs2_dinode *)bh->b_data;
>> +	u64 last_eb_blk = 0;
>>  
>>  	mlog_entry_void();
>>  
>> -	if (!OCFS2_IS_VALID_DINODE(fe)) {
>> -		OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
>> -		retval = -EIO;
>> -		goto bail;
>> +	if (type == OCFS2_DINODE_EXTENT) {
>> +		struct ocfs2_dinode *fe =
>> +				(struct ocfs2_dinode *)root_bh->b_data;
>> +		if (!OCFS2_IS_VALID_DINODE(fe)) {
>> +			OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
>> +			retval = -EIO;
>> +			goto bail;
>> +		}
>> +
>> +		if (fe->i_last_eb_blk)
>> +			last_eb_blk = le64_to_cpu(fe->i_last_eb_blk);
>> +		el = &fe->id2.i_list;
> 
> 	Why isn't this using ocfs2_new_extent_tree() and then
> ocfs2_get_last_eb_lock()?  You do that every other place, and it keeps
> you from having to special case each type here.
yes, you are right. Will modify it. Thanks.

Regards,
Tao

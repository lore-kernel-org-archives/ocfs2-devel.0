From: tao.ma <tao.ma@oracle.com>
Date: Sun Dec  2 18:08:31 2007
Subject: [Ocfs2-devel] [PATCH 3/3] Implement "GROUP_ADD" for online	resize,
	take 2
In-Reply-To: <20071130232004.GF28607@ca-server1.us.oracle.com>
References: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
	<20071127082149.GA4486@tma-pc1.cn.oracle.com>
	<20071130232004.GF28607@ca-server1.us.oracle.com>
Message-ID: <475364A8.10000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
>> +static int ocfs2_check_new_group(struct inode *inode,
>> +				 struct ocfs2_dinode *di,
>> +				 struct ocfs2_new_group_input *input)
>> +{
>> +	int ret;
>> +	struct ocfs2_group_desc *gd;
>> +	struct buffer_head *group_bh = NULL;
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
>> +	u64 cr_blkno;
>> +	unsigned int max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) *
>> +				le16_to_cpu(di->id2.i_chain.cl_bpc);
>> +
>> +	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
>> +	if (ret < 0)
>> +		goto out;
>>     
>
> You should pass the inode so that the group gets added to the caching info.
> We're fine if the checks here fail and userspace tries again since this read
> (that doesn't use the caching flag) always goes to disk.
>   
Just a question. We can cache the group information even if the block 
isn't in this inode, right?
I used to think of that we *only* cache the block which is already in 
the inode.

>> +	else if (le64_to_cpu(gd->bg_next_group) != cr_blkno)
>> +		mlog(0, "Group descriptor # %llu has next group set as %llu "
>> +		     "while the chain head has  %llu set\n",
>> +		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
>> +		     le64_to_cpu(gd->bg_next_group), cr_blkno);
>>     
>
> The 1st block pointer in a chain can change when we re-link groups during
> allocation, so this check is invalid.
>   
I don't realize it until I read suballoc.c today. :)
>
>   
>> +static int ocfs2_verify_group_input(struct inode *inode,
>> +				    struct ocfs2_dinode *di,
>> +				    struct ocfs2_new_group_input *input)
>> +{
>> +	u16 cl_count = le16_to_cpu(di->id2.i_chain.cl_count);
>> +	u16 cl_cpg = le16_to_cpu(di->id2.i_chain.cl_cpg);
>> +	u16 next_free = le16_to_cpu(di->id2.i_chain.cl_next_free_rec);
>> +	u32 cluster = ocfs2_blocks_to_clusters(inode->i_sb, input->group);
>> +	u32 total_clusters = le32_to_cpu(di->i_clusters);
>> +	int ret = -EINVAL;
>> +
>> +	if (cluster < total_clusters)
>> +		mlog(0, "add a group which is in the current volume.\n");
>> +	else if (input->chain >= cl_count)
>> +		mlog(0, "input chain exceeds the limit.\n");
>> +	else if (next_free != cl_count && next_free != input->chain)
>> +		mlog(0, "the add group should be in chain %u\n", next_free);
>>     
>
> If I read this properly, then it's insisting that new groups always be added
> to the rightmost chain... I'm not sure that's correct - we want to fill
> chains which have fewer groups than the others first.
>   
We want to fill the chains first, Instead of growing the chain? This is 
the mechanism in offline resize. So not suitable for online?
> Anyway, weren't we trying to avoid enforcing group placement policy in the
> kernel, short of making sure that the requested chain is a valid one?
>   
Sorry for my poor English( ;) Keep improving). Do you mean we should 
enforce group placement policy in the user space, or vice versa?
>   
>> +
>> +	if (input->chain == le16_to_cpu(cl->cl_next_free_rec)) {
>> +		le16_add_cpu(&cl->cl_next_free_rec, 1);
>> +		memset(cr, 0, sizeof(struct ocfs2_chain_rec));
>> +	}
>> +
>> +	cr->c_blkno = le64_to_cpu(input->group);
>>     
>
> Before this, you need to set the new group descriptors bg_next_group value
> to cr->c_blkno.
>
> By the way, this probably means you need to read the group descriptor near
> the top of this function instead of within ocfs2_check_new_group().
>   
>
I used to write the group descriptors in the user space to avoid the 
group write in the kernel, so the cr->c_blkno is already set in the 
bg_next_group in tunefs.ocfs2.
But from all your 3 comments above, it seems that we *have to* write the 
new group descriptor in the kernel.

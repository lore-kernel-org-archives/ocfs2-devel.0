From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 01 May 2009 14:47:23 +0800
Subject: [Ocfs2-devel] [PATCH 04/39] ocfs2: Basic tree root operation.
In-Reply-To: <20090430233348.GJ2762@mail.oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-4-git-send-email-tao.ma@oracle.com>
	<20090430233348.GJ2762@mail.oracle.com>
Message-ID: <49FA9AFB.8060901@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker Wrote:
> On Thu, Apr 30, 2009 at 06:58:16AM +0800, Tao Ma wrote:
>   
>> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
>> index 08196e0..bfd5942 100644
>> --- a/fs/ocfs2/journal.h
>> +++ b/fs/ocfs2/journal.h
>> @@ -482,6 +482,9 @@ static inline int ocfs2_calc_dxi_expand_credits(struct super_block *sb)
>>  	return credits;
>>  }
>>  
>> +#define OCFS2_REFCOUNT_TREE_CREATE_CREDITS (OCFS2_INODE_UPDATE_CREDITS + \
>> +					    + OCFS2_SUBALLOC_ALLOC + 1)
>> +#define OCFS2_REFCOUNT_TREE_SET_CREDITS (OCFS2_INODE_UPDATE_CREDITS + 1)
>>     
>
> 	Please put comments on these credits defines.  We want to know
> what each credit is for.
>   
Will do.
>   
>> +	BUG_ON(oi->ip_dyn_features & OCFS2_HAS_REFCOUNT_FL);
>> +	BUG_ON(di->i_refcount_loc);
>>     
>
> 	Don't BUG_ON(di->i_refcount_loc).  That's an on-disk structure
> that could be garbage, and there's no point in crashing becasue of it.
> We actually don't care if it is zero, because we know we're safe to
> attach the new refcount tree.  The same goes for set_tree.
>   
OK.
>   
>> +	rb = (struct ocfs2_refcount_block *)ref_root_bh->b_data;
>> +	le32_add_cpu(&rb->rf_count, 1);
>>     
>
> 	I see you have no locking for the refcount tree right now
> (spinlock or cluster lock).  I assume that's coming in a later patch.
>   
yeah, there will be a lock in the later patch.
>   
>> +int ocfs2_remove_refcount_tree(struct inode *inode, struct buffer_head *di_bh)
>> +{
>> +	int ret;
>> +	handle_t *handle = NULL;
>> +	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>> +	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> +	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +	struct ocfs2_refcount_block *rb;
>> +	struct inode *alloc_inode = NULL;
>> +	struct buffer_head *alloc_bh = NULL;
>> +	struct buffer_head *blk_bh = NULL;
>> +	int credits = OCFS2_INODE_UPDATE_CREDITS + 1;
>>     
>
> 	This should be an OCFS2_REFCOUNT_TREE_REMOVE_CREDITS define,
> with appropriate comment.
>   
OK.

Regards,
Tao

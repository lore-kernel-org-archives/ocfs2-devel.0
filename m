From: tao.ma <tao.ma@oracle.com>
Date: Thu Feb 28 17:11:41 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing
	for	ocfs2_reserve_new_inode.V2
In-Reply-To: <20080228233042.GW27865@ca-server1.us.oracle.com>
References: <20080228063438.GA27318@tma-pc1.cn.oracle.com>
	<20080228070026.GA29377@tma-pc1.cn.oracle.com>
	<20080228233042.GW27865@ca-server1.us.oracle.com>
Message-ID: <47C75B74.2090009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Thu, Feb 28, 2008 at 03:00:26PM +0800, tao.ma wrote:
>> Add inode stealing for ocfs2_reserve_new_inode. Now the whole process is:
>> 1. Allocate from its own inode_alloc:000X
>>    1) If we can reserve, OK.
>>    2) If fails, try to allocate a large chunk and reserve once again.
>> 2. If 1 fails, try to allocate from the ocfs2_super->inode_steal_slot.
>>    This time, Just try to reserve, we don't go for global_bitmap if
>>    this inode also can't allocate the inode.
>> 3. If 2 fails, try the node next until we reach that steal slot again.
>>
>> ocfs2_super->inode_steal_slot is initalized as the node next to our own
>> slot. And once the inode stealing successes, we will refresh it with
>> the slot we steal inode from.
> 
>> It will also be reinitalized when the local
>> truncate log or local alloc recovery is flushed in which case the global
>> bitmap may be refreshed.
> 
> How about when we free an inode from our slots allocator?
As I always start to allocate from my own slot first, so this should not 
be a problem since if we free an inode, this block can be allocated 
again to the new request.
>>  int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>>  			    struct ocfs2_alloc_context **ac)
>>  {
>> @@ -542,6 +577,17 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>>  	status = ocfs2_reserve_suballoc_bits(osb, *ac,
>>  					     INODE_ALLOC_SYSTEM_INODE,
>>  					     osb->slot_num, ALLOC_NEW_GROUP);
>> +	if (status >= 0) {
>> +		status = 0;
>> +		goto bail;
>> +	} else if (status < 0 && status != -ENOSPC) {
>> +		mlog_errno(status);
>> +		goto bail;
>> +	}
>> +
>> +	ocfs2_free_ac_resource(*ac);
>> +
>> +	status = ocfs2_steal_inode_from_other_nodes(osb, *ac);
> 
> Does this mean we always search our own first, even if we know it's not
> likely to have anything in it? Wouldn't it be better to ignore once it's
> full until we get to one of the spots where you've inserted a call to
> ocfs2_init_inode_steal_slot)?
I am worried about the situation that the global bitmap is flushed by 
other nodes and how the current node notice this and use its own local 
allocator again. Or should it notice this?
Another thing is that what if the inode which is owned by this slot 
deleted by other slots? We should have the ability to allocate the inode 
from our own slot now.

From: Tao Ma <tao.ma@oracle.com>
Date: Mon Mar  3 18:47:14 2008
Subject: [Ocfs2-devel] [PATCH 3/3] Add inode stealing
	for	ocfs2_reserve_new_inode.V3
In-Reply-To: <47CCB2F8.3040702@oracle.com>
References: <20080303091251.GA18140@tma-pc1.cn.oracle.com>
	<47CCB2F8.3040702@oracle.com>
Message-ID: <47CCB7E0.6000402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> Change comment to:
> /* Start to steal inodes from the first slot after ours. */
> 
>> +    if (slot == OCFS2_INVALID_SLOT)
>> +        slot = osb->slot_num + 1;
>> +
>> +    for (i = 0; i < osb->max_slots; i++, slot++) {
>> +        if (slot == osb->max_slots)
>> +            slot = 0;
>> +
>> +        if (slot == osb->slot_num)
>> +            continue;
>> +
>> +        status = ocfs2_reserve_suballoc_bits(osb, ac,
>> +                             INODE_ALLOC_SYSTEM_INODE,
>> +                             slot, NOT_ALLOC_NEW_GROUP);
>> +        if (status >= 0) {
>> +            ocfs2_set_inode_steal_slot(osb, slot);
>> +            break;
>> +        }
>> +
>> +        ocfs2_free_ac_resource(ac);
>> +    }
>> +
>> +    return status;
>> +}
>> +
> if (slot == OCFS2_INVALID_SLOT)
> slot = (osb->slot_num + 1 == osb->max_slots) ? 0 : osb->slot_num + 1;
> 
> while (slot != osb->slot_num) {
> status = ocfs2_reserve_suballoc_bits(osb, ....);
> ...
> ocfs2_free_ac_resource(ac);
> slot = (slot + 1 == osb->max_slots) ? 0 : slot + 1;
> }
> 
> Not that your code is incorrect. Other option is to not use "i"
> and replace continue with a break.
I use "i" because I am always worried about if I can't handle the 
condition carefully. :( So you think using "i" is not gracefully, or not 
easy to understand, or any other reason?
> 
>>  int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
>>                  struct ocfs2_alloc_context **ac)
>>  {
>>      int status;
>> +    s16 slot = ocfs2_get_inode_steal_slot(osb);
>> +#define OCFS2_INODE_STEAL_TIMES 10
>> +    static atomic_t inode_steal_times = ATOMIC_INIT(0);
> 
> Can you rename inode_steal_times to num_inodes_stolen. BTW, this
> will be for all mounts which is not what we want. Why don't you
> add this to ocfs2_super? s_num_inodes_stolen. In that case, protect
> it using osb_lock.
I forget about this issue and used to think of it is only used in this 
function. :( I Will modify it. Thanks.

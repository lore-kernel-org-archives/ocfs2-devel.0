From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 07 Jan 2009 08:29:19 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Optimize inode allocation by
 remembering last group.
In-Reply-To: <20090106190245.GQ17410@wotan.suse.de>
References: <492F946F.1060409@oracle.com>
	<1227826725-13107-1-git-send-email-tao.ma@oracle.com>
	<20090106190245.GQ17410@wotan.suse.de>
Message-ID: <4963F75F.30309@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Mark Fasheh wrote:

>> @@ -1602,6 +1606,21 @@ int ocfs2_claim_new_inode(struct ocfs2_super *osb,
>>  	BUG_ON(ac->ac_bits_wanted != 1);
>>  	BUG_ON(ac->ac_which != OCFS2_AC_USE_INODE);
>>  
>> +	/*
>> +	 * Try to allocate inodes from some specific group.
>> +	 *
>> +	 * If the parent dir has recorded the last group used in allocation,
>> +	 * cool, use it. Otherwise if we try to allocate new inode from the
>> +	 * same slot the parent dir belongs to, use the same chunk.
>> +	 */
>> +	if (OCFS2_I(dir)->ip_last_used_group &&
>> +	    OCFS2_I(dir)->ip_last_used_slot == ac->ac_alloc_slot)
>> +		ac->ac_last_group = OCFS2_I(dir)->ip_last_used_group;
>> +	else if (le16_to_cpu(parent_fe->i_suballoc_slot) ==
>> +		 ac->ac_alloc_slot)
>> +		ac->ac_last_group = le64_to_cpu(parent_fe->i_blkno) -
>> +				    le16_to_cpu(parent_fe->i_suballoc_bit);
> 
> You should use ocfs2_which_suballoc_group() here, instead of open coding the
> math to get ac_last_group.
yeah, you are right. It looks that I am still not familiar with all 
those helpful functions. ;)
> 
> Also, would it be possible for us to put this block in it's own function so
> that it's easier to play with the logic in the future?
No problem. I will wrap it with a function.
> 
> 
> One last thing - can you add to the comment:
> 
> *
> * We are very careful here to avoid the mistake of setting ac_last_group to
> * a group descriptor from a different (unlocked) slot.
> */
OK, thanks.

Regards,
Tao

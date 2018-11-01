From: Larry Chen <lchen@suse.com>
Date: Thu, 1 Nov 2018 20:39:26 +0800
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: fix dead lock caused by
 ocfs2_defrag_extent
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E37301277DE397@H3CMLB12-EX.srv.huawei-3com.com>
References: <20181101071422.14470-1-lchen@suse.com>
	<c07c65cb-8492-d866-6a1f-ffa64b293ea0@gmail.com>
	<63ADC13FD55D6546B7DECE290D39E37301277DE397@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <24a08d67-dd33-7fc1-628a-af55cd2de1fe@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changwei Ge <ge.changwei@h3c.com>, Joseph Qi <jiangqi903@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Hi Joseph,

On 11/1/18 7:52 PM, Changwei Ge wrote:
> Hello Joseph,
> 
> On 2018/11/1 17:01, Joseph Qi wrote:
>> Hi Larry,
>>
>> On 18/11/1 15:14, Larry Chen wrote:
>>> ocfs2_defrag_extent may fall into deadlock.
>>>
>>> ocfs2_ioctl_move_extents
>>>       ocfs2_ioctl_move_extents
>>>         ocfs2_move_extents
>>>           ocfs2_defrag_extent
>>>             ocfs2_lock_allocators_move_extents
>>>
>>>               ocfs2_reserve_clusters
>>>                 inode_lock GLOBAL_BITMAP_SYSTEM_INODE
>>>
>>> 	  __ocfs2_flush_truncate_log
>>>                 inode_lock GLOBAL_BITMAP_SYSTEM_INODE
>>>
>>> As backtrace shows above, ocfs2_reserve_clusters() will call inode_lock
>>> against the global bitmap if local allocator has not sufficient cluters.
>>> Once global bitmap could meet the demand, ocfs2_reserve_cluster will
>>> return success with global bitmap locked.
>>>
>>> After ocfs2_reserve_cluster(), if truncate log is full,
>>> __ocfs2_flush_truncate_log() will definitely fall into deadlock because it
>>> needs to inode_lock global bitmap, which has already been locked.
>>>
>>> To fix this bug, we could remove from ocfs2_lock_allocators_move_extents()
>>> the code which intends to lock global allocator, and put the removed code
>>> after __ocfs2_flush_truncate_log().
>>>
>>> ocfs2_lock_allocators_move_extents() is referred by 2 places, one is here,
>>> the other does not need the data allocator context, which means this patch
>>> does not affect the caller so far.
>>>
>>> Change log:
>>> 1. Correct the function comment.
>>> 2. Remove unused argument from ocfs2_lock_meta_allocator_move_extents.
>>>
>>> Signed-off-by: Larry Chen <lchen@suse.com>
>>> ---
>>>    fs/ocfs2/move_extents.c | 47 ++++++++++++++++++++++++++---------------------
>>>    1 file changed, 26 insertions(+), 21 deletions(-)
>>>
> 
>> IMO, here clusters_to_move is only for data_ac, since we change this
>> function to only handle meta_ac, I'm afraid clusters_to_move related
>> logic has to been changed correspondingly.
> 
> I think we can't remove *clusters_to_move* from here as clusters can be reserved latter outsides this function, but we
> still have to reserve metadata(extents) in advance.
> So we need that argument.
> 

Yeah, I think clusters_to_move should be reserved, in order to keep the 
original logic as it was.

But I'm curious about why max_recs_needed should be equal to
2 * extents_to_split + cluster_to_move?
Does that mean that each cluster might form an extent??

Thanks,
Larry


> Thanks,
> Changwei
> 
>>
>> Thanks,
>> Joseph
>>>    					u32 extents_to_split,
>>>    					struct ocfs2_alloc_context **meta_ac,
>>> -					struct ocfs2_alloc_context **data_ac,
>>>    					int extra_blocks,
>>>    					int *credits)
>>>    {
>>> @@ -192,13 +188,6 @@ static int ocfs2_lock_allocators_move_extents(struct inode *inode,
>>>    		goto out;
>>>    	}
>>>    
>>> -	if (data_ac) {
>>> -		ret = ocfs2_reserve_clusters(osb, clusters_to_move, data_ac);
>>> -		if (ret) {
>>> -			mlog_errno(ret);
>>> -			goto out;
>>> -		}
>>> -	}
>>>    
>>>    	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el);
>>>    
>>> @@ -257,10 +246,10 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
>>>    		}
>>>    	}
>>>    
>>> -	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, *len, 1,
>>> -						 &context->meta_ac,
>>> -						 &context->data_ac,
>>> -						 extra_blocks, &credits);
>>> +	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
>>> +						*len, 1,
>>> +						&context->meta_ac,
>>> +						extra_blocks, &credits);
>>>    	if (ret) {
>>>    		mlog_errno(ret);
>>>    		goto out;
>>> @@ -283,6 +272,21 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
>>>    		}
>>>    	}
>>>    
>>> +	/*
>>> +	 * Make sure ocfs2_reserve_cluster is called after
>>> +	 * __ocfs2_flush_truncate_log, otherwise, dead lock may happen.
>>> +	 *
>>> +	 * If ocfs2_reserve_cluster is called
>>> +	 * before __ocfs2_flush_truncate_log, dead lock on global bitmap
>>> +	 * may happen.
>>> +	 *
>>> +	 */
>>> +	ret = ocfs2_reserve_clusters(osb, *len, &context->data_ac);
>>> +	if (ret) {
>>> +		mlog_errno(ret);
>>> +		goto out_unlock_mutex;
>>> +	}
>>> +
>>>    	handle = ocfs2_start_trans(osb, credits);
>>>    	if (IS_ERR(handle)) {
>>>    		ret = PTR_ERR(handle);
>>> @@ -600,9 +604,10 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
>>>    		}
>>>    	}
>>>    
>>> -	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
>>> -						 &context->meta_ac,
>>> -						 NULL, extra_blocks, &credits);
>>> +	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
>>> +						len, 1,
>>> +						&context->meta_ac,
>>> +						extra_blocks, &credits);
>>>    	if (ret) {
>>>    		mlog_errno(ret);
>>>    		goto out;
>>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 

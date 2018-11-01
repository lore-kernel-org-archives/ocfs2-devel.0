From: Larry Chen <lchen@suse.com>
Date: Thu, 1 Nov 2018 12:12:05 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: fix dead lock caused by
 ocfs2_defrag_extent
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E37301277DDF02@H3CMLB12-EX.srv.huawei-3com.com>
References: <20180902091455.23862-1-lchen@suse.com>
	<20181031142632.c523108bc137caa8cb1c6282@linux-foundation.org>
	<63ADC13FD55D6546B7DECE290D39E37301277DDF02@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <c01c0e95-0964-aab1-1758-a66439e619ba@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changwei Ge <ge.changwei@h3c.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

Hi Changwei,

Thanks for your review, I'll improve my patch and resend it later.

Thanks
Larry

On 11/1/18 11:11 AM, Changwei Ge wrote:
> Hi Larry,
> 
> I still have a few tiny comments for your patch, please refer to them.
> 
> On 2018/11/1 5:28, Andrew Morton wrote:
>>
>> Folks, could we please review this patch for upstream inclusion?
>>
>> Thanks.
>>
>>
>> From: Larry Chen <lchen@suse.com>
>> Subject: ocfs2: fix deadlock caused by ocfs2_defrag_extent
>>
>> ocfs2_defrag_extent may fall into deadlock.
>>
>> ocfs2_ioctl_move_extents
>>     ocfs2_ioctl_move_extents
>>       ocfs2_move_extents
>>         ocfs2_defrag_extent
>>           ocfs2_lock_allocators_move_extents
>>
>>             ocfs2_reserve_clusters
>>               inode_lock GLOBAL_BITMAP_SYSTEM_INODE
>>
>> 	  __ocfs2_flush_truncate_log
>>               inode_lock GLOBAL_BITMAP_SYSTEM_INODE
>>
>> As backtrace shows above, ocfs2_reserve_clusters() will call inode_lock
>> against the global bitmap if local allocator has not sufficient cluters.
>> Once global bitmap could meet the demand, ocfs2_reserve_cluster will
>> return success with global bitmap locked.
>>
>> After ocfs2_reserve_cluster(), if truncate log is full,
>> __ocfs2_flush_truncate_log() will definitely fall into deadlock because it
>> needs to inode_lock global bitmap, which has already been locked.
>>
>> To fix this bug, we could remove from ocfs2_lock_allocators_move_extents()
>> the code which intends to lock global allocator, and put the removed code
>> after __ocfs2_flush_truncate_log().
>>
>> ocfs2_lock_allocators_move_extents() is refered by 2 places, one is here,
>> the other does not need the data allocator context, which means this patch
>> does not affect the caller so far.
>>
>> [lchen at suse.com: rename ocfs2_lock_allocators_move_extents() to ocfs2_lock_meta_allocator_move_extents(), add some comments]
>>     Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_20180902091455.23862-2D1-2Dlchen-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=K8aRgOiMescamJW-IuHq-cW4mWedGQv2JTT-2KPy1RI&s=3fQHFtwgixirPeQ5Px4fRBnd_UcSx3rvSsLKLidwESo&e=
>> Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_20180827080121.31145-2D1-2Dlchen-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=K8aRgOiMescamJW-IuHq-cW4mWedGQv2JTT-2KPy1RI&s=PQOJREyeElsg_1IlINdSGefNqA6w_cUrI1ezdVxyi7o&e=
>> Signed-off-by: Larry Chen <lchen@suse.com>
>> Cc: Mark Fasheh <mark@fasheh.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Cc: Junxiao Bi <junxiao.bi@oracle.com>
>> Cc: Joseph Qi <jiangqi903@gmail.com>
>> Cc: Changwei Ge <ge.changwei@h3c.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>    fs/ocfs2/move_extents.c |   40 +++++++++++++++++++++++---------------
>>    1 file changed, 25 insertions(+), 15 deletions(-)
>>
>> --- a/fs/ocfs2/move_extents.c~fix-dead-lock-caused-by-ocfs2_defrag_extent
>> +++ a/fs/ocfs2/move_extents.c
>> @@ -162,7 +162,7 @@ out:
>>     * in some cases, we don't need to reserve clusters, just let data_ac
>>     * be NULL.
>>     */
>> -static int ocfs2_lock_allocators_move_extents(struct inode *inode,
>> +static int ocfs2_lock_meta_allocator_move_extents(struct inode *inode,
>>    					struct ocfs2_extent_tree *et,
>>    					u32 clusters_to_move,
>>    					u32 extents_to_split,
> 
> After removing 'reserving clusters logic' out of this function, I suggest to also change the function header comments.
> And I think there is no need for arguments _data_ac_ now.
> Otherwise this patch looks sane to me.
> 
> Thanks,
> Changwei
> 
>> @@ -192,13 +192,6 @@ static int ocfs2_lock_allocators_move_ex
>>    		goto out;
>>    	}
>>    
>> -	if (data_ac) {
>> -		ret = ocfs2_reserve_clusters(osb, clusters_to_move, data_ac);
>> -		if (ret) {
>> -			mlog_errno(ret);
>> -			goto out;
>> -		}
>> -	}
>>    
>>    	*credits += ocfs2_calc_extend_credits(osb->sb, et->et_root_el);
>>    
>> @@ -257,10 +250,11 @@ static int ocfs2_defrag_extent(struct oc
>>    		}
>>    	}
>>    
>> -	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, *len, 1,
>> -						 &context->meta_ac,
>> -						 &context->data_ac,
>> -						 extra_blocks, &credits);
>> +	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
>> +						*len, 1,
>> +						&context->meta_ac,
>> +						&context->data_ac,
>> +						extra_blocks, &credits);
>>    	if (ret) {
>>    		mlog_errno(ret);
>>    		goto out;
>> @@ -283,6 +277,21 @@ static int ocfs2_defrag_extent(struct oc
>>    		}
>>    	}
>>    
>> +	/*
>> +	 * Make sure ocfs2_reserve_cluster is called after
>> +	 * __ocfs2_flush_truncate_log, otherwise, dead lock may happen.
>> +	 *
>> +	 * If ocfs2_reserve_cluster is called
>> +	 * before __ocfs2_flush_truncate_log, dead lock on global bitmap
>> +	 * may happen.
>> +	 *
>> +	 */
>> +	ret = ocfs2_reserve_clusters(osb, *len, &context->data_ac);
>> +	if (ret) {
>> +		mlog_errno(ret);
>> +		goto out_unlock_mutex;
>> +	}
>> +
>>    	handle = ocfs2_start_trans(osb, credits);
>>    	if (IS_ERR(handle)) {
>>    		ret = PTR_ERR(handle);
>> @@ -600,9 +609,10 @@ static int ocfs2_move_extent(struct ocfs
>>    		}
>>    	}
>>    
>> -	ret = ocfs2_lock_allocators_move_extents(inode, &context->et, len, 1,
>> -						 &context->meta_ac,
>> -						 NULL, extra_blocks, &credits);
>> +	ret = ocfs2_lock_meta_allocator_move_extents(inode, &context->et,
>> +						len, 1,
>> +						&context->meta_ac,
>> +						NULL, extra_blocks, &credits);
>>    	if (ret) {
>>    		mlog_errno(ret);
>>    		goto out;
>> _
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
> 

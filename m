From: alex chen <alex.chen@huawei.com>
Date: Fri, 24 Nov 2017 18:06:56 +0800
Subject: [Ocfs2-devel] [PATCH] Bug#841144: kernel BUG at
	/build/linux-Wgpe2M/linux-4.8.11/fs/ocfs2/alloc.c:1514!
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED7F056@H3CMLB14-EX.srv.huawei-3com.com>
References: <1511204090.3644.6.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CB51@H3CMLB14-EX.srv.huawei-3com.com>
	<1511232309.3644.14.camel@nixnuts.net>
	<63ADC13FD55D6546B7DECE290D39E373CED7CDDB@H3CMLB14-EX.srv.huawei-3com.com>
	<1511298301.2735.1.camel@nixnuts.net> <5A17B220.5030909@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373CED7F056@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5A17EF40.7000800@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Changwei,

Thanks for your reviews.

On 2017/11/24 15:03, Changwei Ge wrote:
> Hi Alex,
> I just reviewed your patch and a few questions were come up with.
> 
> On 2017/11/24 13:49, alex chen wrote:
>> Hi John,
>>
>> I think a better method to solve this problem.
>>
>> On 2017/11/22 5:05, John Lightsey wrote:
>>> On Tue, 2017-11-21 at 05:58 +0000, Changwei Ge wrote:
>>>
>>>> Can your tell me how did you format your volume?
>>>> What's your _cluster size_ and _block size_?
>>>> Your can obtain such information via debugfs.ocfs2 <your volume> -R
>>>> 'stats' | grep 'Cluster Size'
>>>>
>>>> It's better for you provide a way to reproduce this issue so that we
>>>> can
>>>> perform some test.
>>>>
>>>
>>> The issue recurred in our cluster today, so at best my patch is just
>>> decreasing the frequency of the crashes.
>>
>> We need to check the free number of the records in each loop to mark extent written,
>> because the last extent block may be changed through many times marking extent written
>> and the num_free_extents also be changed. In the worst case, the num_free_extents may
>> become less than at the beginning of the loop. So we should not estimate the free
>> number of the records at the beginning of the loop to mark extent written.
>>
> 
>  From John's description, ::dw_zero_count was not calculated properly 
> and your patch seems not to address this issue. Do you agree that it's 
> possible that we get a wrong ::dw_zero_count?

Yes, the old dw_zero_count is not calculated properly, but we don't use it because
we just need know the max needed number of splinting the one extent.
> 
>> I'd appreciate it if you could test the following patch and feedback the result.
>>
>> Signed-off-by: Alex Chen <alex.chen@huawei.com>
>> ---
>>   fs/ocfs2/aops.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++---------
>>   1 file changed, 64 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index d151632..80725f2 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2272,6 +2272,35 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
>>   	return ret;
>>   }
>>
>> +static int ocfs2_dio_should_restart(struct ocfs2_extent_tree *et,
>> +		struct ocfs2_alloc_context *meta_ac, int max_rec_needed)
>> +{
>> +	int status = 0, free_extents;
>> +
>> +	free_extents = ocfs2_num_free_extents(et);
>> +	if (free_extents < 0) {
>> +		status = free_extents;
>> +		mlog_errno(status);
>> +		return status;
>> +	}
>> +
>> +	/*
>> +	 * there are two cases which could cause us to EAGAIN in the
>> +	 * we-need-more-metadata case:
>> +	 * 1) we haven't reserved *any*
>> +	 * 2) we are so fragmented, we've needed to add metadata too
>> +	 *    many times.
> 
> What does point 2 mean?

The point 2 mean we have reserved metadata, but the left bit in allocate context
is not enough for allocating a new extent block.

> 
>> +	 */
>> +	if (free_extents < max_rec_needed) {
>> +		if (!meta_ac || (ocfs2_alloc_context_bits_left(meta_ac)
>> +				< ocfs2_extend_meta_needed(et->et_root_el)))
>> +			status = 1;
>> +	}
>> +
>> +	return status;
>> +}
>> +
>> +#define OCFS2_MAX_REC_NEED_SPLIT 2
> 
> Um, I don't figure why the Maximum value is 2, I suppose this is less 
> than previously estimated one.

the max needed number of splinting the one extent in the worst case - that we're writing in
the middle of the extent.

> 
>>   static int ocfs2_dio_end_io_write(struct inode *inode,
>>   				  struct ocfs2_dio_write_ctxt *dwc,
>>   				  loff_t offset,
>> @@ -2281,14 +2310,13 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>   	struct ocfs2_extent_tree et;
>>   	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>   	struct ocfs2_inode_info *oi = OCFS2_I(inode);
>> -	struct ocfs2_unwritten_extent *ue = NULL;
>> +	struct ocfs2_unwritten_extent *ue = NULL, *tmp_ue;
>>   	struct buffer_head *di_bh = NULL;
>>   	struct ocfs2_dinode *di;
>> -	struct ocfs2_alloc_context *data_ac = NULL;
>>   	struct ocfs2_alloc_context *meta_ac = NULL;
>>   	handle_t *handle = NULL;
>>   	loff_t end = offset + bytes;
>> -	int ret = 0, credits = 0, locked = 0;
>> +	int ret = 0, credits = 0, locked = 0, restart_func = 0;
> 
> I think _ restart_func_ is not named properly. Can we change it into 
> realloc or something like that?
> 
>>
>>   	ocfs2_init_dealloc_ctxt(&dealloc);
>>
>> @@ -2330,8 +2358,9 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>
>>   	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
>>
>> -	ret = ocfs2_lock_allocators(inode, &et, 0, dwc->dw_zero_count*2,
>> -				    &data_ac, &meta_ac);
>> +restart_all:
>> +	ret = ocfs2_lock_allocators(inode, &et, 0, OCFS2_MAX_REC_NEED_SPLIT,
>> +				    NULL, &meta_ac);
>>   	if (ret) {
>>   		mlog_errno(ret);
>>   		goto unlock;
>> @@ -2343,7 +2372,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>   	if (IS_ERR(handle)) {
>>   		ret = PTR_ERR(handle);
>>   		mlog_errno(ret);
>> -		goto unlock;
>> +		goto free_ac;
>>   	}
>>   	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
>>   				      OCFS2_JOURNAL_ACCESS_WRITE);
>> @@ -2352,7 +2381,17 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>   		goto commit;
>>   	}
>>
>> -	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
>> +	list_for_each_entry_safe(ue, tmp_ue, &dwc->dw_zero_list, ue_node) {
>> +		ret = ocfs2_dio_should_restart(&et, meta_ac,
>> +				OCFS2_MAX_REC_NEED_SPLIT * 2);
> 
> Why extent block's free record number would change during marking 
> written, which compels code path has to re-alloc.
> 

One way to set the last extent block is as following:
ocfs2_mark_extent_written
 ocfs2_change_extent_flag
  ocfs2_split_extent
   ocfs2_try_to_merge_extent
    ocfs2_rotate_tree_left
     __ocfs2_rotate_tree_left
      ocfs2_et_set_last_eb_blk


Thanks,
Alex

> Thanks,
> Changwei
> 
>> +		if (ret < 0) {
>> +			mlog_errno(ret);
>> +			break;
>> +		} else if (ret == 1) {
>> +			restart_func = 1;
>> +			break;
>> +		}
>> +
>>   		ret = ocfs2_mark_extent_written(inode, &et, handle,
>>   						ue->ue_cpos, 1,
>>   						ue->ue_phys,
>> @@ -2361,24 +2400,37 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>>   			mlog_errno(ret);
>>   			break;
>>   		}
>> +
>> +		dwc->dw_zero_count--;
>> +		list_del_init(&ue->ue_node);
>> +		spin_lock(&oi->ip_lock);
>> +		list_del_init(&ue->ue_ip_node);
>> +		spin_unlock(&oi->ip_lock);
>> +		kfree(ue);
>>   	}
>>
>> -	if (end > i_size_read(inode)) {
>> +	if (!restart_func && end > i_size_read(inode)) {
>>   		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>>   		if (ret < 0)
>>   			mlog_errno(ret);
>>   	}
>> +
>>   commit:
>>   	ocfs2_commit_trans(osb, handle);
>> +free_ac:
>> +	if (meta_ac) {
>> +		ocfs2_free_alloc_context(meta_ac);
>> +		meta_ac = NULL;
>> +	}
>> +	if (restart_func) {
>> +		restart_func = 0;
>> +		goto restart_all;
>> +	}
>>   unlock:
>>   	up_write(&oi->ip_alloc_sem);
>>   	ocfs2_inode_unlock(inode, 1);
>>   	brelse(di_bh);
>>   out:
>> -	if (data_ac)
>> -		ocfs2_free_alloc_context(data_ac);
>> -	if (meta_ac)
>> -		ocfs2_free_alloc_context(meta_ac);
>>   	ocfs2_run_deallocs(osb, &dealloc);
>>   	if (locked)
>>   		inode_unlock(inode);
>>
> 
> 
> .
> 

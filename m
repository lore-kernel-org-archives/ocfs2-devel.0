From: Eric Ren <zren@suse.com>
Date: Wed, 6 Jul 2016 16:56:32 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: retry on ENOSPC if sufficient
 space in truncate log
In-Reply-To: <577C8746.2040705@huawei.com>
References: <1466586469-5541-1-git-send-email-zren@suse.com>
	<577C8746.2040705@huawei.com>
Message-ID: <577CC7C0.1080704@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 07/06/2016 12:21 PM, Joseph Qi wrote:
> NAK, if ocfs2_try_to_free_truncate_log fails, it will lead to double
> ocfs2_inode_unlock and then BUG.

Thanks for pointing out this! Will fix this and resend.

Eric

>
> On 2016/6/22 17:07, Eric Ren wrote:
>> The testcase "mmaptruncate" in ocfs2 test suite always fails with
>> ENOSPC error on small volume (say less than 10G). This testcase
>> creates 2 threads T1/T2 which race to "truncate"/"extend" a same
>> file repeatedly. Specifically, T1 truncates 1/2 size of a small file
>> while T2 extend to 100% size. The main bitmap will quickly run out
>> of space because the "truncate" code prevent truncate log from being
>> flushed by ocfs2_schedule_truncate_log_flush(osb, 1), while truncate
>> log may have cached lots of clusters.
>>
>> So retry to allocate after flushing truncate log when ENOSPC is
>> returned. And we cannot reuse the deleted blocks before the transaction
>> committed. Fortunately, we already have a function to do this -
>> ocfs2_try_to_free_truncate_log(). Just need to remove the "static"
>> modifier and put it into a right place.
>>
>> Signed-off-by: Eric Ren <zren@suse.com>
>> ---
>>   fs/ocfs2/alloc.c    | 37 +++++++++++++++++++++++++++++++++++++
>>   fs/ocfs2/alloc.h    |  2 ++
>>   fs/ocfs2/aops.c     | 37 -------------------------------------
>>   fs/ocfs2/suballoc.c | 17 ++++++++++++++++-
>>   4 files changed, 55 insertions(+), 38 deletions(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 460c0ce..7dabbc3 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -6106,6 +6106,43 @@ void ocfs2_schedule_truncate_log_flush(struct ocfs2_super *osb,
>>   	}
>>   }
>>
>> +/*
>> + * Try to flush truncate logs if we can free enough clusters from it.
>> + * As for return value, "< 0" means error, "0" no space and "1" means
>> + * we have freed enough spaces and let the caller try to allocate again.
>> + */
>> +int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
>> +					unsigned int needed)
>> +{
>> +	tid_t target;
>> +	int ret = 0;
>> +	unsigned int truncated_clusters;
>> +
>> +	inode_lock(osb->osb_tl_inode);
>> +	truncated_clusters = osb->truncated_clusters;
>> +	inode_unlock(osb->osb_tl_inode);
>> +
>> +	/*
>> +	 * Check whether we can succeed in allocating if we free
>> +	 * the truncate log.
>> +	 */
>> +	if (truncated_clusters < needed)
>> +		goto out;
>> +
>> +	ret = ocfs2_flush_truncate_log(osb);
>> +	if (ret) {
>> +		mlog_errno(ret);
>> +		goto out;
>> +	}
>> +
>> +	if (jbd2_journal_start_commit(osb->journal->j_journal, &target)) {
>> +		jbd2_log_wait_commit(osb->journal->j_journal, target);
>> +		ret = 1;
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
>>   static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>>   				       int slot_num,
>>   				       struct inode **tl_inode,
>> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
>> index f3dc1b0..4a5152e 100644
>> --- a/fs/ocfs2/alloc.h
>> +++ b/fs/ocfs2/alloc.h
>> @@ -188,6 +188,8 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
>>   			      u64 start_blk,
>>   			      unsigned int num_clusters);
>>   int __ocfs2_flush_truncate_log(struct ocfs2_super *osb);
>> +int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
>> +				   unsigned int needed);
>>
>>   /*
>>    * Process local structure which describes the block unlinks done
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index c034edf..1802aef 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -1645,43 +1645,6 @@ static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
>>   	return ret;
>>   }
>>
>> -/*
>> - * Try to flush truncate logs if we can free enough clusters from it.
>> - * As for return value, "< 0" means error, "0" no space and "1" means
>> - * we have freed enough spaces and let the caller try to allocate again.
>> - */
>> -static int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
>> -					  unsigned int needed)
>> -{
>> -	tid_t target;
>> -	int ret = 0;
>> -	unsigned int truncated_clusters;
>> -
>> -	inode_lock(osb->osb_tl_inode);
>> -	truncated_clusters = osb->truncated_clusters;
>> -	inode_unlock(osb->osb_tl_inode);
>> -
>> -	/*
>> -	 * Check whether we can succeed in allocating if we free
>> -	 * the truncate log.
>> -	 */
>> -	if (truncated_clusters < needed)
>> -		goto out;
>> -
>> -	ret = ocfs2_flush_truncate_log(osb);
>> -	if (ret) {
>> -		mlog_errno(ret);
>> -		goto out;
>> -	}
>> -
>> -	if (jbd2_journal_start_commit(osb->journal->j_journal, &target)) {
>> -		jbd2_log_wait_commit(osb->journal->j_journal, target);
>> -		ret = 1;
>> -	}
>> -out:
>> -	return ret;
>> -}
>> -
>>   int ocfs2_write_begin_nolock(struct address_space *mapping,
>>   			     loff_t pos, unsigned len, ocfs2_write_type_t type,
>>   			     struct page **pagep, void **fsdata,
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 2f19aee..9f7f3b6 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1164,7 +1164,8 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
>>   					     int flags,
>>   					     struct ocfs2_alloc_context **ac)
>>   {
>> -	int status;
>> +	int status, ret = 0;
>> +	int retried = 0;
>>
>>   	*ac = kzalloc(sizeof(struct ocfs2_alloc_context), GFP_KERNEL);
>>   	if (!(*ac)) {
>> @@ -1189,7 +1190,21 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
>>   	}
>>
>>   	if (status == -ENOSPC) {
>> +retry:
>>   		status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
>> +		/* Retry if there is sufficient space cached in truncate log */
>> +		if (status == -ENOSPC && !retried) {
>> +			retried = 1;
>> +			ocfs2_inode_unlock((*ac)->ac_inode, 1);
>> +			inode_unlock((*ac)->ac_inode);
>> +
>> +			ret = ocfs2_try_to_free_truncate_log(osb, bits_wanted);
>> +			if (ret == 1)
>> +				goto retry;
>> +
>> +			if (ret < 0)
>> +				mlog_errno(ret);
>> +		}
>>   		if (status < 0) {
>>   			if (status != -ENOSPC)
>>   				mlog_errno(status);
>>
>
>
>

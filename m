From: Gang He <ghe@suse.com>
Date: Thu, 27 Dec 2018 22:07:19 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush truncate log when main
 bitmap run out of space
In-Reply-To: <5C257CCD.4010806@huawei.com>
References: <75d7f03e-61cd-60c9-dd2c-2cef8bbc214e@huawei.com>
	<5C257CCD.4010806@huawei.com>
Message-ID: <5C25AF87020000F90004A693@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



>>> On 2018/12/28 at 9:30, in message <5C257CCD.4010806@huawei.com>, jiangyiwen
<jiangyiwen@huawei.com> wrote:
> On 2018/12/27 19:10, Jia Guo wrote:
>> Truncate log problem has been described in
>> commit 50308d813bf2 ("ocfs2: Try to free truncate log when meeting
>> ENOSPC in write.") and
>> commit 2070ad1aebff ("ocfs2: retry on ENOSPC if sufficient space in
>> truncate log"), but the following situations cannot be solved:
>> 
>> case 1:
>> Main bitmap has been updated, but the transaction of the deleted blocks has
>> not been committed completely. In this case, function
>> ocfs2_reserve_cluster_bitmap_bits() returns success while function
>> __ocfs2_claim_clusters return ENOSPC because we cannot reuse the deleted
>> blocks before the transaction committed(test by function
>> ocfs2_test_bg_bit_allocatable()). One can reproduce this by following
>> steps:
>> a, prepare a file which size is 50G, and volume still have 30G free space
>> b, open the file with O_TRUNC flag
>> c, sleep 5 seconds
>> e, fallocate a 50G file.
>> 
>> case 2:
>> Main bitmap doesn't have enough free bits, so does truncate log. But main
>> bitmap plus truncate log has enough free bits. We are not gonging to try
>> flush truncate log in this case, which is not reasonable.
>> 
>> So force commit the transaction when flushing the truncate log for case 1.
>> For case 2, the value of osb->truncated_clusters doesn't seem to make
>> sense, do the flush whenever we run out of space seems to be more
>> reasonable.
>> 
>> Signed-off-by: Jia Guo <guojia12@huawei.com>
> 
> Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Gang He <ghe@suse.com>

By the way, maybe we also can take the other nodes' truncate log back to main BM file.

Thanks
Gang


> 
>> ---
>>  fs/ocfs2/alloc.c    | 43 +++----------------------------------------
>>  fs/ocfs2/alloc.h    |  2 --
>>  fs/ocfs2/aops.c     |  4 ++--
>>  fs/ocfs2/ocfs2.h    |  5 -----
>>  fs/ocfs2/suballoc.c |  6 +++---
>>  5 files changed, 8 insertions(+), 52 deletions(-)
>> 
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index d1cbb27..8b6938d 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -5921,7 +5921,6 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
>> 
>>  	ocfs2_journal_dirty(handle, tl_bh);
>> 
>> -	osb->truncated_clusters += num_clusters;
>>  bail:
>>  	return status;
>>  }
>> @@ -5940,6 +5939,7 @@ static int ocfs2_replay_truncate_records(struct 
> ocfs2_super *osb,
>>  	struct inode *tl_inode = osb->osb_tl_inode;
>>  	struct buffer_head *tl_bh = osb->osb_tl_bh;
>>  	handle_t *handle;
>> +	tid_t target;
>> 
>>  	di = (struct ocfs2_dinode *) tl_bh->b_data;
>>  	tl = &di->id2.i_dealloc;
>> @@ -5989,8 +5989,8 @@ static int ocfs2_replay_truncate_records(struct 
> ocfs2_super *osb,
>>  		ocfs2_commit_trans(osb, handle);
>>  		i--;
>>  	}
>> -
>> -	osb->truncated_clusters = 0;
>> +	if (jbd2_journal_start_commit(osb->journal->j_journal, &target))
>> +		jbd2_log_wait_commit(osb->journal->j_journal, target);
>> 
>>  bail:
>>  	return status;
>> @@ -6102,43 +6102,6 @@ void ocfs2_schedule_truncate_log_flush(struct 
> ocfs2_super *osb,
>>  	}
>>  }
>> 
>> -/*
>> - * Try to flush truncate logs if we can free enough clusters from it.
>> - * As for return value, "< 0" means error, "0" no space and "1" means
>> - * we have freed enough spaces and let the caller try to allocate again.
>> - */
>> -int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
>> -					unsigned int needed)
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
>>  static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>>  				       int slot_num,
>>  				       struct inode **tl_inode,
>> diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
>> index 250bcac..b343a6f 100644
>> --- a/fs/ocfs2/alloc.h
>> +++ b/fs/ocfs2/alloc.h
>> @@ -188,8 +188,6 @@ int ocfs2_truncate_log_append(struct ocfs2_super *osb,
>>  			      u64 start_blk,
>>  			      unsigned int num_clusters);
>>  int __ocfs2_flush_truncate_log(struct ocfs2_super *osb);
>> -int ocfs2_try_to_free_truncate_log(struct ocfs2_super *osb,
>> -				   unsigned int needed);
>> 
>>  /*
>>   * Process local structure which describes the block unlinks done
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index eb1ce30..a9ca7cc 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -1893,8 +1893,8 @@ int ocfs2_write_begin_nolock(struct address_space 
> *mapping,
>>  		 */
>>  		try_free = 0;
>> 
>> -		ret1 = ocfs2_try_to_free_truncate_log(osb, clusters_need);
>> -		if (ret1 == 1)
>> +		ret1 = ocfs2_flush_truncate_log(osb);
>> +		if (!ret1)
>>  			goto try_again;
>> 
>>  		if (ret1 < 0)
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 4f86ac0..f913647 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -440,11 +440,6 @@ struct ocfs2_super
>>  	struct buffer_head		*osb_tl_bh;
>>  	struct delayed_work		osb_truncate_log_wq;
>>  	atomic_t			osb_tl_disable;
>> -	/*
>> -	 * How many clusters in our truncate log.
>> -	 * It must be protected by osb_tl_inode->i_mutex.
>> -	 */
>> -	unsigned int truncated_clusters;
>> 
>>  	struct ocfs2_node_map		osb_recovering_orphan_dirs;
>>  	unsigned int			*osb_orphan_wipes;
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index f7c972f..d086bb9 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -1187,14 +1187,14 @@ static int ocfs2_reserve_clusters_with_limit(struct 
> ocfs2_super *osb,
>>  	if (status == -ENOSPC) {
>>  retry:
>>  		status = ocfs2_reserve_cluster_bitmap_bits(osb, *ac);
>> -		/* Retry if there is sufficient space cached in truncate log */
>> +		/* Retry after flush truncate log */
>>  		if (status == -ENOSPC && !retried) {
>>  			retried = 1;
>>  			ocfs2_inode_unlock((*ac)->ac_inode, 1);
>>  			inode_unlock((*ac)->ac_inode);
>> 
>> -			ret = ocfs2_try_to_free_truncate_log(osb, bits_wanted);
>> -			if (ret == 1) {
>> +			ret = ocfs2_flush_truncate_log(osb);
>> +			if (!ret) {
>>  				iput((*ac)->ac_inode);
>>  				(*ac)->ac_inode = NULL;
>>  				goto retry;
>> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

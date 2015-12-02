From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 2 Dec 2015 14:52:05 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix BUG due to uncleaned
 localalloc during mount
In-Reply-To: <565D542F.1020609@oracle.com>
References: <5654684A.1070305@huawei.com> <565D542F.1020609@oracle.com>
Message-ID: <565E9515.1090808@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,
On 2015/12/1 16:02, Junxiao Bi wrote:
> Hi Joseph,
> 
> On 11/24/2015 09:38 PM, Joseph Qi wrote:
>> Tariq has reported a BUG before and posted a fix at:
>> https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010696.html
>>
>> This is because during umount, localalloc shutdown relies on journal
>> shutdown. But during journal shutdown, it just stops commit thread
>> without checking its result. So it may happen that localalloc shutdown
>> uncleaned during I/O error and after that, journal then has been marked
>> clean if I/O restores.
> The above is a storage issue. In this condition, io error can even
> happen to journal commit, some transactions may have wrong data. Let fs
> go without a fsck may cause corruption.
> I am thinking whether we can fail the mount and mark the journal dirty
> again. Then we can do fsck to it withoug a fsck patch.
> 
Can you explain which situation would cause file system corruption. I think
if IO error happens to journal commit and commit block have not reach the disk,
the whole transactions is skipped while recovering the journal. So file system
is still consistent.
Thanks,
Xuejiufei

> Thanks,
> Junxiao.
> 
>> Then during mount, localalloc won't be recovered because of clean
>> journal and then trigger BUG when claiming clusters from localalloc.
>>
>> In Tariq's fix, we have to run fsck offline and a separate fix to fsck
>> is needed because it currently does not support clearing out localalloc
>> inode. And my way to fix this issue is checking localalloc before
>> actually loading it during mount. And this is somewhat online.
>>
>> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>> ---
>>  fs/ocfs2/localalloc.c | 19 ++++++++++++-------
>>  fs/ocfs2/localalloc.h |  2 +-
>>  fs/ocfs2/super.c      | 17 ++++++++++++++---
>>  3 files changed, 27 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>> index 0a4457f..ceebaef 100644
>> --- a/fs/ocfs2/localalloc.c
>> +++ b/fs/ocfs2/localalloc.c
>> @@ -281,7 +281,7 @@ bail:
>>  	return ret;
>>  }
>>
>> -int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>> +int ocfs2_load_local_alloc(struct ocfs2_super *osb, int check, int *recovery)
>>  {
>>  	int status = 0;
>>  	struct ocfs2_dinode *alloc = NULL;
>> @@ -345,21 +345,26 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb)
>>  	if (num_used
>>  	    || alloc->id1.bitmap1.i_used
>>  	    || alloc->id1.bitmap1.i_total
>> -	    || la->la_bm_off)
>> +	    || la->la_bm_off) {
>>  		mlog(ML_ERROR, "Local alloc hasn't been recovered!\n"
>>  		     "found = %u, set = %u, taken = %u, off = %u\n",
>>  		     num_used, le32_to_cpu(alloc->id1.bitmap1.i_used),
>>  		     le32_to_cpu(alloc->id1.bitmap1.i_total),
>>  		     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
>> +		status = -EINVAL;
>> +		*recovery = 1;
>> +		goto bail;
>> +	}
>>
>> -	osb->local_alloc_bh = alloc_bh;
>> -	osb->local_alloc_state = OCFS2_LA_ENABLED;
>> +	if (!check) {
>> +		osb->local_alloc_bh = alloc_bh;
>> +		osb->local_alloc_state = OCFS2_LA_ENABLED;
>> +	}
>>
>>  bail:
>> -	if (status < 0)
>> +	if (status < 0 || check)
>>  		brelse(alloc_bh);
>> -	if (inode)
>> -		iput(inode);
>> +	iput(inode);
>>
>>  	trace_ocfs2_load_local_alloc(osb->local_alloc_bits);
>>
>> diff --git a/fs/ocfs2/localalloc.h b/fs/ocfs2/localalloc.h
>> index 44a7d1f..a913841 100644
>> --- a/fs/ocfs2/localalloc.h
>> +++ b/fs/ocfs2/localalloc.h
>> @@ -26,7 +26,7 @@
>>  #ifndef OCFS2_LOCALALLOC_H
>>  #define OCFS2_LOCALALLOC_H
>>
>> -int ocfs2_load_local_alloc(struct ocfs2_super *osb);
>> +int ocfs2_load_local_alloc(struct ocfs2_super *osb, int check, int *recovery);
>>
>>  void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb);
>>
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 2de4c8a..4004b29 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2428,6 +2428,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>  	int status;
>>  	int dirty;
>>  	int local;
>> +	int la_dirty = 0, recovery = 0;
>>  	struct ocfs2_dinode *local_alloc = NULL; /* only used if we
>>  						  * recover
>>  						  * ourselves. */
>> @@ -2449,6 +2450,16 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>  	 * recover anything. Otherwise, journal_load will do that
>>  	 * dirty work for us :) */
>>  	if (!dirty) {
>> +		/* It may happen that local alloc is unclean shutdown, but
>> +		 * journal has been marked clean, so check it here and do
>> +		 * recovery if needed */
>> +		status = ocfs2_load_local_alloc(osb, 1, &recovery);
>> +		if (recovery) {
>> +			printk(KERN_NOTICE "ocfs2: local alloc needs recovery "
>> +					"on device (%s).\n", osb->dev_str);
>> +			la_dirty = 1;
>> +		}
>> +
>>  		status = ocfs2_journal_wipe(osb->journal, 0);
>>  		if (status < 0) {
>>  			mlog_errno(status);
>> @@ -2477,7 +2488,7 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>  				JBD2_FEATURE_COMPAT_CHECKSUM, 0,
>>  				JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT);
>>
>> -	if (dirty) {
>> +	if (dirty || la_dirty) {
>>  		/* recover my local alloc if we didn't unmount cleanly. */
>>  		status = ocfs2_begin_local_alloc_recovery(osb,
>>  							  osb->slot_num,
>> @@ -2490,13 +2501,13 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
>>  		 * ourselves as mounted. */
>>  	}
>>
>> -	status = ocfs2_load_local_alloc(osb);
>> +	status = ocfs2_load_local_alloc(osb, 0, &recovery);
>>  	if (status < 0) {
>>  		mlog_errno(status);
>>  		goto finally;
>>  	}
>>
>> -	if (dirty) {
>> +	if (dirty || la_dirty) {
>>  		/* Recovery will be completed after we've mounted the
>>  		 * rest of the volume. */
>>  		osb->dirty = 1;
>>
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> .
> 

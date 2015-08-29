From: Joseph Qi <joseph.qi@huawei.com>
Date: Sat, 29 Aug 2015 10:38:09 +0800
Subject: [Ocfs2-devel] [patch 11/28] ocfs2: extend enough credits for
 freeing one truncate record while replaying truncate records
In-Reply-To: <20150828235543.GQ1145@wotan.suse.de>
References: <55de39a4.mm24W9YHh8D6r9FS%akpm@linux-foundation.org>
	<20150828235543.GQ1145@wotan.suse.de>
Message-ID: <55E11B11.8000701@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

On 2015/8/29 7:55, Mark Fasheh wrote:
> On Wed, Aug 26, 2015 at 03:11:48PM -0700, Andrew Morton wrote:
>> From: Xue jiufei <xuejiufei@huawei.com>
>> Subject: ocfs2: extend enough credits for freeing one truncate record while replaying truncate records
>>
>> Now function ocfs2_replay_truncate_records() first modifies tl_used, then
>> calls ocfs2_extend_trans() to extend transactions for gd and alloc inode
>> used for freeing clusters.  jbd2_journal_restart() may be called and it
>> may happen that tl_used in truncate log is decreased but the clusters are
>> not freed, which means these clusters are lost.  So we should avoid
>> extending transactions in these two operations.
>>
>> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
>> Cc: Mark Fasheh <mfasheh@suse.com>
>> Cc: Joel Becker <jlbec@evilplan.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  fs/ocfs2/alloc.c |   19 ++++++++-----------
>>  1 file changed, 8 insertions(+), 11 deletions(-)
>>
>> diff -puN fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records fs/ocfs2/alloc.c
>> --- a/fs/ocfs2/alloc.c~extend-enough-credits-for-freeing-one-truncate-record-while-replaying-truncate-records
>> +++ a/fs/ocfs2/alloc.c
> 
> <looks good>
> 
>> @@ -6063,7 +6060,7 @@ int __ocfs2_flush_truncate_log(struct oc
>>  		goto out_mutex;
>>  	}
>>  
>> -	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_UPDATE);
>> +	handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
>>  	if (IS_ERR(handle)) {
>>  		status = PTR_ERR(handle);
>>  		mlog_errno(status);
> 
> Why is this particular change here?
> 	--Mark
> 
I think Joyce wants to get enough credits at first and then call
ocfs2_replay_truncate_records.

Thanks
Joseph

> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 

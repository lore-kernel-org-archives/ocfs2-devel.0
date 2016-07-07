From: Eric Ren <zren@suse.com>
Date: Thu, 7 Jul 2016 17:59:12 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: retry on ENOSPC if sufficient
 space in truncate log
In-Reply-To: <577DA9C5.1050503@huawei.com>
References: <1467802651-12461-1-git-send-email-zren@suse.com>
	<577DA9C5.1050503@huawei.com>
Message-ID: <577E27F0.2010700@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 07/07/2016 09:00 AM, Joseph Qi wrote:
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
>> @@ -1189,7 +1190,24 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
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
>> +			if (ret < 0) {
>> +				mlog_errno(ret);
>> +				inode_lock((*ac)->ac_inode);
>> +				ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
>> +			}
> Here not only the case error occurs in ocfs2_try_to_free_truncate_log,
> but also have tried to free truncate log but still no space, you have
> already unlocked inode and it will still call ocfs2_free_alloc_context
> and unlock again.
> I suggest here we consider a bit code refactoring but not just lock
> again.

Oh, yes! "< 0" means error and "0" means no space. I also considered the 
possibility of refactoring somehow. But it needs plenty of changes
because of DLM glue layer doesn't keep track of the lock holder@
process level. I know it looks ugly and inefficient, but fortunately
the chance of hitting here is very little, so I think it doesn't worth
a refactor. Any suggestions?

Eric

>
> Thanks,
> Joseph
>
>> +		}
>>   		if (status < 0) {
>>   			if (status != -ENOSPC)
>>   				mlog_errno(status);

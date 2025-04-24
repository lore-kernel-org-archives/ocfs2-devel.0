Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFE2701BA
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 01:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745456629; cv=none; b=Kl5xJqcbOecLAReWD+/+EEFVSiF22YZNFOsaA3Z+v5x1GLVLTsY6kBcNmn+Zxp1UPUeUfivuGBqYBeAKblPbzy/q+M89RJDsiURIa8AVT7aTwSJGTIk2KVXxmmkBR1JAsuls/pdPNXwkfiGRGT336KkTzjWNBKQizhJ/mhBjHNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745456629; c=relaxed/simple;
	bh=YFGWLdK3kSMqzzXcwACZKitLyw+p+o68qMxK7GXmvps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWXFvfvEP4nU7vJAfqpk2ZzGdZjp7uUuiDWxaz7+/Ulsv9LIifCgAo7dvs7EpoGRmiy+usON1W2x5JSNyLBJeb+0UGxDwvRSi+Q9POWU4gmp2DMBXbwd9cY0j9vGBzrGVuUeWXgXfdfN0PNa3dHC9dmSLMTONs118ebQYKFU75E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=nI2UP96M; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="nI2UP96M"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1745456623; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HVgCJUzyQJ4uYNbn4njqnNHyeOnBEF5sAOrZpUsNj/Y=;
	b=nI2UP96MLblccTcy+9dcrDTiqyPp+7GQsnm5nwhVA20U1M5RPFp9OmQQMm4be54JHkwJBRAUztT8qf5g0h8Il6LvVA8mKOZ7eP9HsUIpklWpsuaXVqXj0pZYQe2rwo01cQqMy7mg2bDXgEQTZ5Inq0TdylgphxAGcHYBiHmWslM=
Received: from 30.221.144.173(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WXw5AOC_1745456621 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Apr 2025 09:03:42 +0800
Message-ID: <5159afef-26f6-4c5e-8b6a-8e4e388a41cb@linux.alibaba.com>
Date: Thu, 24 Apr 2025 09:03:41 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ocfs2: Implement handshaking with ocfs2 recovery
 thread
To: Heming Zhao <heming.zhao@suse.com>, Jan Kara <jack@suse.cz>,
 akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, Murad Masimov <m.masimov@mt-integration.ru>,
 Shichangkuo <shi.changkuo@h3c.com>
References: <20250422123709.15078-1-jack@suse.cz>
 <20250422124138.26027-5-jack@suse.cz>
 <b02b1fd4-893f-47bf-91df-40bc88d6ad9f@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <b02b1fd4-893f-47bf-91df-40bc88d6ad9f@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/4/22 22:45, Heming Zhao wrote:
> On 4/22/25 20:41, Jan Kara wrote:
>> We will need ocfs2 recovery thread to acknowledge transitions of
>> recovery_state when disabling particular types of recovery. This is
>> similar to what currently happens when disabling recovery completely,
>> just more general. Implement the handshake and use it for exit from
>> recovery.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Thanks for the v2 patch, and I got your code meaning.
> I also tested the new patch.
> 
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> Tested-by: Heming Zhao <heming.zhao@suse.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
>> ---
>>   fs/ocfs2/journal.c | 52 +++++++++++++++++++++++++++++++---------------
>>   fs/ocfs2/ocfs2.h   |  4 ++++
>>   2 files changed, 39 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 8986e813ab2c..7511db5a46cd 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -190,31 +190,48 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
>>       return 0;
>>   }
>>   -/* we can't grab the goofy sem lock from inside wait_event, so we use
>> - * memory barriers to make sure that we'll see the null task before
>> - * being woken up */
>>   static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
>>   {
>> -    mb();
>>       return osb->recovery_thread_task != NULL;
>>   }
>>   -void ocfs2_recovery_exit(struct ocfs2_super *osb)
>> +static void ocfs2_recovery_disable(struct ocfs2_super *osb,
>> +                   enum ocfs2_recovery_state state)
>>   {
>> -    struct ocfs2_recovery_map *rm;
>> -
>> -    /* disable any new recovery threads and wait for any currently
>> -     * running ones to exit. Do this before setting the vol_state. */
>>       mutex_lock(&osb->recovery_lock);
>> -    osb->recovery_state = OCFS2_REC_DISABLED;
>> +    /*
>> +     * If recovery thread is not running, we can directly transition to
>> +     * final state.
>> +     */
>> +    if (!ocfs2_recovery_thread_running(osb)) {
>> +        osb->recovery_state = state + 1;
>> +        goto out_lock;
>> +    }
>> +    osb->recovery_state = state;
>> +    /* Wait for recovery thread to acknowledge state transition */
>> +    wait_event_cmd(osb->recovery_event,
>> +               !ocfs2_recovery_thread_running(osb) ||
>> +                osb->recovery_state >= state + 1,
>> +               mutex_unlock(&osb->recovery_lock),
>> +               mutex_lock(&osb->recovery_lock));
>> +out_lock:
>>       mutex_unlock(&osb->recovery_lock);
>> -    wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
>>   -    /* At this point, we know that no more recovery threads can be
>> -     * launched, so wait for any recovery completion work to
>> -     * complete. */
>> +    /*
>> +     * At this point we know that no more recovery work can be queued so
>> +     * wait for any recovery completion work to complete.
>> +     */
>>       if (osb->ocfs2_wq)
>>           flush_workqueue(osb->ocfs2_wq);
>> +}
>> +
>> +void ocfs2_recovery_exit(struct ocfs2_super *osb)
>> +{
>> +    struct ocfs2_recovery_map *rm;
>> +
>> +    /* disable any new recovery threads and wait for any currently
>> +     * running ones to exit. Do this before setting the vol_state. */
>> +    ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
>>         /*
>>        * Now that recovery is shut down, and the osb is about to be
>> @@ -1569,7 +1586,8 @@ static int __ocfs2_recovery_thread(void *arg)
>>         ocfs2_free_replay_slots(osb);
>>       osb->recovery_thread_task = NULL;
>> -    mb(); /* sync with ocfs2_recovery_thread_running */
>> +    if (osb->recovery_state == OCFS2_REC_WANT_DISABLE)
>> +        osb->recovery_state = OCFS2_REC_DISABLED;
>>       wake_up(&osb->recovery_event);
>>         mutex_unlock(&osb->recovery_lock);
>> @@ -1585,13 +1603,13 @@ void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
>>       int was_set = -1;
>>         mutex_lock(&osb->recovery_lock);
>> -    if (osb->recovery_state < OCFS2_REC_DISABLED)
>> +    if (osb->recovery_state < OCFS2_REC_WANT_DISABLE)
>>           was_set = ocfs2_recovery_map_set(osb, node_num);
>>         trace_ocfs2_recovery_thread(node_num, osb->node_num,
>>           osb->recovery_state, osb->recovery_thread_task, was_set);
>>   -    if (osb->recovery_state == OCFS2_REC_DISABLED)
>> +    if (osb->recovery_state >= OCFS2_REC_WANT_DISABLE)
>>           goto out;
>>         if (osb->recovery_thread_task)
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index e713361939f0..70b2d5c8c228 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -310,6 +310,10 @@ void ocfs2_initialize_journal_triggers(struct super_block *sb,
>>     enum ocfs2_recovery_state {
>>       OCFS2_REC_ENABLED = 0,
>> +    OCFS2_REC_WANT_DISABLE,
>> +    /*
>> +     * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
>> +     */
>>       OCFS2_REC_DISABLED,
>>   };
>>   


Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2BEF50F
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 06:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303539; cv=none; b=BnvE6C+zUk2GCC6KKmeM3ZAlzCyObj4KkMXxa5R4Je1PjvUfRdnRV8ki1k9tiivIRsEpCSsRA1qfj8HBH/zcmHpDNwEOArmiO6tTIhkP6zTOBymTSdl53/uun36nJjTineiV/XClTlbvmOvmecpJ+G33oHvxUxv8oYUOoUGWqMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303539; c=relaxed/simple;
	bh=UsDOaPJVAntM2BD+8tMRNYs6mQlXa1CWmgfJmkG6F9c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=eM727QXwD8FoElyF92co2SzZQqerYO+aq85YXiVht/TVrEncoW6/N/5RKEKwYWPO33McnCqnef2SaZTIPdNNDRzlYRV1jkNt6tEIGNLbgGrq5MqkGaYNu/7NJ7CsuyJA5vGiq1drpBBEoZWMl9hPL4aFfm/WgmrtuGgA3r5vZQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IUJ6OlJr; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IUJ6OlJr"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e616736458so713306a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 21 Apr 2025 23:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745303535; x=1745908335; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aaIaJRGRjt0SabrMVwxBemRKTHd5OnbNC3yNGaGmz7I=;
        b=IUJ6OlJrbZ7dNqU0ImwduxvHt1mlqINVtpuuD5ZVou66Y8XYYYHV2t7XYHNQ+36q9N
         mQocEYSbtOTbWXQuIGmd4vPmifiFXvW2fPktKhUoH/qpUk0EztU2DXMwigL+JaN/Pl8V
         txtOKlXpPI5nqlvs+vvPa73XoechTp7f61X1XlmnEeWox+HFBsBoBKQdSipMIc5K73TU
         1Lfdbrz5LDY0DmAUkn7qmuuhXCKqEkx6Ss5PVQivDdzv2MPwU0m/Q8e4gwQPAb2FjHoZ
         atL+uiSOMW8oSOdKPR32Ap/MN2gqbsiO+praLKNpSJxenn+l/BQzB1K+Bag809RkZMuZ
         x3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745303535; x=1745908335;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aaIaJRGRjt0SabrMVwxBemRKTHd5OnbNC3yNGaGmz7I=;
        b=koZ8TYHsTYNUWdgh7ytW+DnfGGN9a+1chJouAQHZaiAgs21b4cjLcoSxYii6yOfxSt
         gbtOkO9aYYuiCW3xoBIkmcllhUkVvDwQt86JbK/KWnsL4AvdRxwlsGPA+x4HpbUHac5Q
         BM71fSKGqev1eWTwSsGZ3b4B5QzkF6zbBq3I75kbKaPLHSlZAVtc91yHDo9RcWdsZtnC
         YQoWZa1wc/BAgEwZBzKEs+ucwRfnxg3NRkojisgkDB7F9/Ha9HUBl2kD6oDUEKmS+EzL
         VRgvpLZA6aQfANYEeULMLq5N9dc0bUTMW/U+xvfGVknRCP+dSoCPpVXlPYdgaqbKRRi0
         hZfw==
X-Forwarded-Encrypted: i=1; AJvYcCVhjHe8M9N4gpgISF+jFnImQcgnlCzJ6dS3/5uFNktu5QOEOtA8nlOmF7avCxfeFJ5BkTpsNeSkaSxvng==@lists.linux.dev
X-Gm-Message-State: AOJu0YzTQztDX8H6UxalRG1Nu1Ei4p0ooP9T5KikAbVse92ssOiZPqCi
	+02z94XLVqQI0cLjx4ej3BGExtLc5Uk+YxdabC8N9362ulGkv2keYvFqnreOg1U=
X-Gm-Gg: ASbGnct7s8xk2BHBLrYpJGqkM120iWAPV+O+smtteh5GXdbcSvvrJnyWGCXUD8X+Pag
	XtBPpPspECMBfMhwgJtet4rPZKcbORWGiVxRxCM6qvy43ZyQmCUTkU7yRwZpigKVldKpOOmfIPO
	UglV2+HqS2wWkSaZrg8JHlv9jK1EtOZ4i2luKHEZxUcSkVDU7PenjfoY7QLq87lTBE8CdqyaUXT
	/zFNmE5rYpsT78FLQMxKDfQ5XLg2W8RFyUMPmaNsPkgs0QtjyEDqMlUeuIQE78zRRp700csdpMj
	ZOk219qEmT63pHsC8yjTdt1Bo0/fLL8EQjARMlm60A3X9HU=
X-Google-Smtp-Source: AGHT+IEjA39VzefiX//IzizN3f2SmedA2qY8hX/d8xXl6wvqzTU23CqnD0aklwbVAUIYJ7A/Cb9P3g==
X-Received: by 2002:a17:906:5ad5:b0:acb:7de1:28b9 with SMTP id a640c23a62f3a-acb7de12b80mr345872466b.5.1745303535243;
        Mon, 21 Apr 2025 23:32:15 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8bf75csm7780669b3a.6.2025.04.21.23.32.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 23:32:14 -0700 (PDT)
Message-ID: <15334c3e-53ce-45e5-877e-d41758b568fd@suse.com>
Date: Tue, 22 Apr 2025 14:32:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ocfs2: Implement handshaking with ocfs2 recovery
 thread
From: Heming Zhao <heming.zhao@suse.com>
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>, ocfs2-devel@lists.linux.dev
References: <20250403112908.13750-1-jack@suse.cz>
 <20250403113250.20572-5-jack@suse.cz>
 <a0c7e040-d953-40bc-8c84-a2984b8c381e@suse.com>
Content-Language: en-US
In-Reply-To: <a0c7e040-d953-40bc-8c84-a2984b8c381e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Jan,

On 4/22/25 12:08, Heming Zhao wrote:
> On 4/3/25 19:32, Jan Kara wrote:
>> We will need ocfs2 recovery thread to acknowledge transitions of
>> recovery_state when disabling particular types of recovery. This is
>> similar to what currently happens when disabling recovery completely,
>> just more general. Implement the handshake and use it for exit from
>> recovery.
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>   fs/ocfs2/journal.c | 52 +++++++++++++++++++++++++++++++---------------
>>   fs/ocfs2/ocfs2.h   |  4 ++++
>>   2 files changed, 39 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
>> index 8986e813ab2c..bed57687cc60 100644
>> --- a/fs/ocfs2/journal.c
>> +++ b/fs/ocfs2/journal.c
>> @@ -190,31 +190,48 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
>>       return 0;
>>   }
>> -/* we can't grab the goofy sem lock from inside wait_event, so we use
>> - * memory barriers to make sure that we'll see the null task before
>> - * being woken up */
>>   static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
>>   {
>> -    mb();
>>       return osb->recovery_thread_task != NULL;
>>   }
>> -void ocfs2_recovery_exit(struct ocfs2_super *osb)
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
>> -    /* At this point, we know that no more recovery threads can be
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
>>       /*
>>        * Now that recovery is shut down, and the osb is about to be
>> @@ -1569,7 +1586,8 @@ static int __ocfs2_recovery_thread(void *arg)
>>       ocfs2_free_replay_slots(osb);
>>       osb->recovery_thread_task = NULL;
>> -    mb(); /* sync with ocfs2_recovery_thread_running */
>> +    if (osb->recovery_state == OCFS2_REC_WANT_DISABLE)
>> +        osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;
> 
> OCFS2_REC_QUOTA_DISABLED is defined in [patch 3/3], so the
> above line will make gcc unhappy.
> All other code looks good to me.
> 
> - Heming

If you are busy with other affairs, I can do the code adjustment for you.
The adjustment only involves copying the OCFS2_REC_QUOTA_DISABLED
definition from [patch 3/3].

- Heming

> 
>>       wake_up(&osb->recovery_event);
>>       mutex_unlock(&osb->recovery_lock);
>> @@ -1585,13 +1603,13 @@ void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
>>       int was_set = -1;
>>       mutex_lock(&osb->recovery_lock);
>> -    if (osb->recovery_state < OCFS2_REC_DISABLED)
>> +    if (osb->recovery_state < OCFS2_REC_WANT_DISABLE)
>>           was_set = ocfs2_recovery_map_set(osb, node_num);
>>       trace_ocfs2_recovery_thread(node_num, osb->node_num,
>>           osb->recovery_state, osb->recovery_thread_task, was_set);
>> -    if (osb->recovery_state == OCFS2_REC_DISABLED)
>> +    if (osb->recovery_state >= OCFS2_REC_WANT_DISABLE)
>>           goto out;
>>       if (osb->recovery_thread_task)
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index e713361939f0..70b2d5c8c228 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -310,6 +310,10 @@ void ocfs2_initialize_journal_triggers(struct super_block *sb,
>>   enum ocfs2_recovery_state {
>>       OCFS2_REC_ENABLED = 0,
>> +    OCFS2_REC_WANT_DISABLE,
>> +    /*
>> +     * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
>> +     */
>>       OCFS2_REC_DISABLED,
>>   };
> 


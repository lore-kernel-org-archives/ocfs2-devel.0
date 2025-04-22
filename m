Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B406828CF59
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333120; cv=none; b=jLkb9gypbmlToBW+pr3Wok85pPAG+y7psjz7An3IH1oTKkOJj+YKbvW00dvmZfIpMhmlQ7a4hmNogVie5NvRSHq2q8bIgAzZWj88FUwJNp1BrcKvDXuM6hm8ZkpgutR9o/HAUKUuPyfW8begFtDBvk9lyLh7qpKChn0OBR/ZVHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333120; c=relaxed/simple;
	bh=IBx/F1wyR411hSGqHwbyasPocz1nQSjgByReN3OAIAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+wwIAOtJIRyhaX5tMph694fACebiNFgfHCi05cVT+4MvWxAB6puo768pPNMRHe6VRz5iapQWeTgpJfI8BOONq/HkfWC6R48DjiBlM0lqvEJtmNRtz4lrTxRsBDtM57wNhbpvCnSTBwiZNSNHP/KUoY1kEMWE36W6uwggbVfXJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VG23qoax; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VG23qoax"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5f623af283fso555075a12.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 07:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745333116; x=1745937916; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9twW9LOc4Edv2P6bcksLT8eakDNlr09MjfCVcxkTUs=;
        b=VG23qoax+f9H2d+S6X7MoQqOXOLErdRtTsbPD0OhCml/F3fwy0/VNf3IR+a2QKWESB
         /KtSSHPP93lyZBIDomTEeKUVQgDCdcwTLyDGSUkz/CJsNOCfRRFxt6sLubB2sSkYasae
         M9CyxDk2J2B5V929CjfaDSV0l1V9KeZxZ48XIdVI2iSjXC0aPOKu5J2sACxMtAFzq+Ax
         T1zVNyOObQIzIZicvZFc0s/asEZeDfYg+GTKmhUJ2akXFzCPjsLjlGle23iDAFDstQA1
         7/+VDHiHIZYZPpJz+MfwW5GLcoo/rBm0VvPA6RqZMEz8zJ6LRxDWkLpMQbfpj9pJseVu
         5Fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745333116; x=1745937916;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a9twW9LOc4Edv2P6bcksLT8eakDNlr09MjfCVcxkTUs=;
        b=t4L0WEuwpG6eo2Gc0Qu4ajqi8pOb+0hJKajGjQL3Qve149EZEestURCOEfil+mWjzg
         ne+ooCROoQaMJTntyLKBKLjaF5FvoodD8AbGt6J3rlzq2d5HDkXapCmSi3GImEDftpTZ
         08wDJcgUljWfONY2eqR6LtT/YbTxbGEjiq29hAbKNNPkyMmbh3OpnjZ5XLfKP0LD+FGc
         wkLu48gyRbeeb1kk6fem5JXMnZBPbmqJLO2bP6oXNJJexRNhdaUdWRhCGm/bjeElzU8g
         rdtiDzgNXsfkG6xkgPhkhDUhyrlMgcF/ycchI2et18xNpcZPeebvU8NXXHwJr8JxsQwI
         1EYQ==
X-Gm-Message-State: AOJu0YwqZZ+okPt5LARr78+TJiJNCqHHeB81WHSaOTzwRGkCqkFkUh8J
	4aoXhdr8BI7qUtaKT50e10Cd2nb3IRtRUBw3h1fvoR6QkszaI1yHsb/PGSvY8rXYGNAQ+rKC/en
	L
X-Gm-Gg: ASbGncuvBwLvwxdrirfArYoHGga3Sno32o2kZ/D8aEDAssbfg29MrlQDr+fMfhsk0PY
	VlEBHry5pFiXPCGkJwZ3pNi2lrYQA7F7SQFhoM7wGF3SUdlrbJ5TCuIHU3Ra7v7bdrxxP984KNz
	Lblq7G1pPiazhXZ+2yCEpbSzdu3wXE17vs4gAVc/feXGmxGkU6mO8rTnCeGU08K8x5pZlnwUj4+
	ux7pRpwAx89FgZ9IIjGZDhI4E1lL0auQ5WBjmTGCUBul3vnLh15zZGtvADAHC6GxTh6s/7ai1PS
	/AJ0TZ7bsiPYf/A+Ns+px+pb5cjcVuj40xbrBB5/WLEbXHo=
X-Google-Smtp-Source: AGHT+IFMQPFQl+qUCYWXRPTAqAHUdRF55QVAeiQCMg2AgykGT8YN9rluUKw1rMwSWrURbmZsIwJ0LA==
X-Received: by 2002:a05:6402:270d:b0:5f6:261e:db8c with SMTP id 4fb4d7f45d1cf-5f628536a65mr4255291a12.4.1745333115856;
        Tue, 22 Apr 2025 07:45:15 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbfa588d4sm8990840b3a.96.2025.04.22.07.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 07:45:15 -0700 (PDT)
Message-ID: <b02b1fd4-893f-47bf-91df-40bc88d6ad9f@suse.com>
Date: Tue, 22 Apr 2025 22:45:12 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ocfs2: Implement handshaking with ocfs2 recovery
 thread
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, Murad Masimov <m.masimov@mt-integration.ru>,
 Shichangkuo <shi.changkuo@h3c.com>
References: <20250422123709.15078-1-jack@suse.cz>
 <20250422124138.26027-5-jack@suse.cz>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250422124138.26027-5-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/25 20:41, Jan Kara wrote:
> We will need ocfs2 recovery thread to acknowledge transitions of
> recovery_state when disabling particular types of recovery. This is
> similar to what currently happens when disabling recovery completely,
> just more general. Implement the handshake and use it for exit from
> recovery.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks for the v2 patch, and I got your code meaning.
I also tested the new patch.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>

> ---
>   fs/ocfs2/journal.c | 52 +++++++++++++++++++++++++++++++---------------
>   fs/ocfs2/ocfs2.h   |  4 ++++
>   2 files changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 8986e813ab2c..7511db5a46cd 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -190,31 +190,48 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
>   	return 0;
>   }
>   
> -/* we can't grab the goofy sem lock from inside wait_event, so we use
> - * memory barriers to make sure that we'll see the null task before
> - * being woken up */
>   static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
>   {
> -	mb();
>   	return osb->recovery_thread_task != NULL;
>   }
>   
> -void ocfs2_recovery_exit(struct ocfs2_super *osb)
> +static void ocfs2_recovery_disable(struct ocfs2_super *osb,
> +				   enum ocfs2_recovery_state state)
>   {
> -	struct ocfs2_recovery_map *rm;
> -
> -	/* disable any new recovery threads and wait for any currently
> -	 * running ones to exit. Do this before setting the vol_state. */
>   	mutex_lock(&osb->recovery_lock);
> -	osb->recovery_state = OCFS2_REC_DISABLED;
> +	/*
> +	 * If recovery thread is not running, we can directly transition to
> +	 * final state.
> +	 */
> +	if (!ocfs2_recovery_thread_running(osb)) {
> +		osb->recovery_state = state + 1;
> +		goto out_lock;
> +	}
> +	osb->recovery_state = state;
> +	/* Wait for recovery thread to acknowledge state transition */
> +	wait_event_cmd(osb->recovery_event,
> +		       !ocfs2_recovery_thread_running(osb) ||
> +				osb->recovery_state >= state + 1,
> +		       mutex_unlock(&osb->recovery_lock),
> +		       mutex_lock(&osb->recovery_lock));
> +out_lock:
>   	mutex_unlock(&osb->recovery_lock);
> -	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
>   
> -	/* At this point, we know that no more recovery threads can be
> -	 * launched, so wait for any recovery completion work to
> -	 * complete. */
> +	/*
> +	 * At this point we know that no more recovery work can be queued so
> +	 * wait for any recovery completion work to complete.
> +	 */
>   	if (osb->ocfs2_wq)
>   		flush_workqueue(osb->ocfs2_wq);
> +}
> +
> +void ocfs2_recovery_exit(struct ocfs2_super *osb)
> +{
> +	struct ocfs2_recovery_map *rm;
> +
> +	/* disable any new recovery threads and wait for any currently
> +	 * running ones to exit. Do this before setting the vol_state. */
> +	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
>   
>   	/*
>   	 * Now that recovery is shut down, and the osb is about to be
> @@ -1569,7 +1586,8 @@ static int __ocfs2_recovery_thread(void *arg)
>   
>   	ocfs2_free_replay_slots(osb);
>   	osb->recovery_thread_task = NULL;
> -	mb(); /* sync with ocfs2_recovery_thread_running */
> +	if (osb->recovery_state == OCFS2_REC_WANT_DISABLE)
> +		osb->recovery_state = OCFS2_REC_DISABLED;
>   	wake_up(&osb->recovery_event);
>   
>   	mutex_unlock(&osb->recovery_lock);
> @@ -1585,13 +1603,13 @@ void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
>   	int was_set = -1;
>   
>   	mutex_lock(&osb->recovery_lock);
> -	if (osb->recovery_state < OCFS2_REC_DISABLED)
> +	if (osb->recovery_state < OCFS2_REC_WANT_DISABLE)
>   		was_set = ocfs2_recovery_map_set(osb, node_num);
>   
>   	trace_ocfs2_recovery_thread(node_num, osb->node_num,
>   		osb->recovery_state, osb->recovery_thread_task, was_set);
>   
> -	if (osb->recovery_state == OCFS2_REC_DISABLED)
> +	if (osb->recovery_state >= OCFS2_REC_WANT_DISABLE)
>   		goto out;
>   
>   	if (osb->recovery_thread_task)
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index e713361939f0..70b2d5c8c228 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -310,6 +310,10 @@ void ocfs2_initialize_journal_triggers(struct super_block *sb,
>   
>   enum ocfs2_recovery_state {
>   	OCFS2_REC_ENABLED = 0,
> +	OCFS2_REC_WANT_DISABLE,
> +	/*
> +	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
> +	 */
>   	OCFS2_REC_DISABLED,
>   };
>   


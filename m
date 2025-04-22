Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB1428382
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 04:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745294916; cv=none; b=B14v7g7kmfeU3GtjIXSBc1djNXsQHDZpOJkgb24mZXe6SIFhIMPzkDOoaGzFqfupRxjpUKAV8z5AMPLnq0soHBANVGZRBkXDcD1BNh8DlnXuWMnItP/CGDlcptRDL8otTMO0iuTXykDl5nl3n2BAeXSpEcwE8fzWMDg9C+vNqSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745294916; c=relaxed/simple;
	bh=mzIfYtzU5UWNHKulpBMuHNmRw4IaBpNEJyvGlQ+2GMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tsrqhl9qZ9RcCrnscR/mydPL3/4g42pdZTa211/SZC/Qa3lEJdHXKo1tzVJohndpmgQN0qsdg1ejytxK6atDAovJ8yJKHn8uZbsSb3xkVV36L5u0OeSq00Us2bCFYg5JksAUppNYYfTDh5sLhMuigSbCRyN0HCqMIdkbJFNhVPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A2U1ByAG; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A2U1ByAG"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5ded500589aso727792a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 21 Apr 2025 21:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745294912; x=1745899712; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8ZbMsE2t43fhmZT6Zbgw4MV6IaXdZwto+tWRRJzp2Zw=;
        b=A2U1ByAGc1FsHo6CfJdksSMXqg1i6xikNw2Z1LNAP4r/yMcTn6C3PW66OvaZyyGmv/
         mVIBwPG4lpLsJktFYHe4wfDEMFHQO3OuZ4EJto02zJLKjPNf2G5u47D3oZwTlx+u9btW
         BxB/FerFnGnjDvLdhiqjLlqMnVhkNpSI8l0yrzbwQ+kTjS+Zj9nRUJZZVILxzRvqwVAR
         jNd3xiYNb/VLvoOEVDYxF2ZqRA8OK9bRfNIgAGNdXpuwBaUtYVPQnGl/PnAW5ifJPjki
         scTYR9LRaDSMsPH7Y1kb5BtYvy8nbzztAs6ObcyPhmACfBLRq5m3xmDR3uvEXRptnaug
         X7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745294912; x=1745899712;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZbMsE2t43fhmZT6Zbgw4MV6IaXdZwto+tWRRJzp2Zw=;
        b=idLkgXcQq5UvGAp5902HDQ0wKfiOekmPyVU12SJP1sS3axAPjyDyLgo3Ut9Tun03rv
         QeIOEXi3A3l88ahiVeaVwEIlsNO5slKti/Vcaba7tgJeENGon/sFrAIheTn6Fkt63hVv
         xo1mQrf92cslXt53raij+1oysMVyKkxp4S+FfmnGIAMEmobEzxmz6aTIz9OGbra7F2yP
         pkaqp3QNJAZNlqRAv7zAK9kdKpOfxLR9LEsnlRUMhE5VCIOaYrfprRHsxyMB5BcYFZuu
         4YKv9Vk9YU6F/r2/uMHKdrKrH9ORBIinrZEbEFCgLZjO6MZjbGhGJewiE3PaJbnilk7R
         HSdw==
X-Forwarded-Encrypted: i=1; AJvYcCW2yEUcbpNX5VV6nzmTWzsk9/pK4OhOGXHNOlLIRtD4mUMaca1D2Jfa7PgNuYpaAlR4kbmxnv6mm/B/aQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YybhyDG6uEV2K4OUq753xfM7buHyTlqPLav69cetsMVSxAqr3Wz
	PFbTC/yYkmZZL1ytu0rBExP8JgPSwGg2hiOkciVbyx82LJ3DKm+/S4GWt1uID90=
X-Gm-Gg: ASbGncv9TCSjG0TIk4+crZpyCZkIqHamOujg4jS7a7nWHi64pku4zPhGZVYKWcixh+y
	d+zGBo5e0Plr8Ze67qutGdPSRpHYXOmET+oNtpzpEnNM0eEqYN+mGtD/c7BvNCE/N4OoOUDmNXP
	IAxNZOV7h5ZoYQtEZ3WxIB0W1w1EjbXFLHFxT/nPTAah5XPuHve6FH85yd2JtG8L5FWyX884nT9
	XFlbCY0PjXC3uDuyMaEonN8JHhmvyG2KDZh1PkbFuTXQdD82kSZPHjtKnKAqHFMgWzwt52X7uwG
	f+VuBuRdYHhbZiY/d8aJg+OASEZG6/x1BPFzmqushscegCw=
X-Google-Smtp-Source: AGHT+IGBhqld8rK5DwcFZ8JOqyG9y0d9qMiKDk1ZeAdY6Il7DZBjyGMUzlNkhAYOoWiE10kdMkxrxA==
X-Received: by 2002:a05:6402:510f:b0:5de:ce71:badf with SMTP id 4fb4d7f45d1cf-5f6285e4dfdmr4059080a12.6.1745294912064;
        Mon, 21 Apr 2025 21:08:32 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8bf5d5sm7753934b3a.11.2025.04.21.21.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 21:08:31 -0700 (PDT)
Message-ID: <a0c7e040-d953-40bc-8c84-a2984b8c381e@suse.com>
Date: Tue, 22 Apr 2025 12:08:28 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] ocfs2: Implement handshaking with ocfs2 recovery
 thread
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>, ocfs2-devel@lists.linux.dev
References: <20250403112908.13750-1-jack@suse.cz>
 <20250403113250.20572-5-jack@suse.cz>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250403113250.20572-5-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 19:32, Jan Kara wrote:
> We will need ocfs2 recovery thread to acknowledge transitions of
> recovery_state when disabling particular types of recovery. This is
> similar to what currently happens when disabling recovery completely,
> just more general. Implement the handshake and use it for exit from
> recovery.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   fs/ocfs2/journal.c | 52 +++++++++++++++++++++++++++++++---------------
>   fs/ocfs2/ocfs2.h   |  4 ++++
>   2 files changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 8986e813ab2c..bed57687cc60 100644
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
> +		osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;

OCFS2_REC_QUOTA_DISABLED is defined in [patch 3/3], so the
above line will make gcc unhappy.
All other code looks good to me.

- Heming

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


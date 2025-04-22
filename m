Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113F128382
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 04:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745294743; cv=none; b=pMk2clVvlLn34l9jKYtTfBhGYi2wTLMCl+80kt1pRTjhG7owaxqiGHylizuvX2qUb1CJpLCaq2TiyVAsfhp0RKNW79f99J1GYxYKSQSk67KRsHt2Bw5jzBWKxtEMyxi7rbYTmGJ1uWYDe6ZR+xCrlUhiRaOshkx0F3jkjyzpszw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745294743; c=relaxed/simple;
	bh=jdrWiRfttbjkoEnxX8G1Cgcih1JYDdbRZAJMFz0ole4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=modi/SqxocBEpE2q7I1A0mb/ka1iLo6QfagLCji1NyHsM4sE8Mn0r+STabTX/tFh1sHBFmchIzXymJ6zoFEX07DHDQL2tVD3T1nw2LAWo9F+mpG7XB9B5muybKJkIEunNpFpvs5KnxnpZVnOCrQLIv639l2G3/ehVzde0m8pIVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tvybz4No; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tvybz4No"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39127effa72so555750f8f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 21 Apr 2025 21:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745294739; x=1745899539; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zpkH7I16fAWCeUVWGrOS4GHBfIbhHWuHvfEUaCDxRM0=;
        b=Tvybz4No1QRY6sjcSHmXCH7QhL/pyTJgl3mQDgOm74kpS20hhDo0uynIm19npHDLS7
         jRe0OMZQW1Gb0C+hFM18KbHGB2InnKKYe2biDXffTTpoiJNpnOQB4lfJS7e50Yk/vlom
         JavIWwuem9wr2NRqzAjI2yyWqAf4/uSViwM+SZ0zOpw2j8M3MnNj4I/D7hX87A4iEVf9
         s7KIeK8xp+2dmbdby+QLjgMKCIwN0a0t9A2Tjg3ZBSN9F8Abz7TbOs3WvQP4NqLZjo74
         FMZKVxsD+w2/8sM3TvrHd8kzjhhcuNdibd4mu9dwYSLT9t3ezs07TRWZavA3aXflO7/x
         UHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745294739; x=1745899539;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zpkH7I16fAWCeUVWGrOS4GHBfIbhHWuHvfEUaCDxRM0=;
        b=ruI8DuPH7YX0cgA1Tde3FKPyUewoapkcImKh1mI91VX9i38/qb39B0w/TB7JU9nIs1
         lylVZ4HAIuWBtaIX4/pVrONA3FjAnAd6pyEznR++BKCx8qe5UwJlct5/WMwjQVx4kwb1
         ChR5WALK3CBwewNn5zj6c8ysTduSh5dMx+7o4s7SshafhH4r2FCpsw+NO8lZxi1re1ff
         c77yhS8nD+aRuYsgBiv3oS7MF3ZjScaoShfE+Bh+CpMWjlFRsymRRQ7Tw35LJO5av6gS
         FrfByCXuuRUBF7NfZGwGdu3lToghxi8lo/Bzx3rFMXsWd1khr4plXjD0+4B2CLhU8Dz0
         V2cg==
X-Forwarded-Encrypted: i=1; AJvYcCUW0jtyN4e2gRTzuzT2tbCN1fbiXa5K4E2CLClsCTYNaHBKUTQ5bCmyTxVyzDprfVYXfb5wjqIWrzVMnw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4ZeExIfqyg4jiTAMF06fh8qjUq2IwZjpg1TFm3O9gsOQ5hXuE
	wWsEsodtUjIxSGx+P5KdXDASjIOHiRFQVaUhM39UJ842G+uH5mJ/VknYc1VKzSepdKzwOrm5Qwn
	U
X-Gm-Gg: ASbGnctKfhadQSz4RTPp+eiufzLqCmtXQCBvy0JlomYl4r5Hz8f10YqjtV3eqZG4osN
	/Lm+WPsLTFBQQPBKDBWwgMK/BRNfenbaVItNKALpx2MYeUHfBuwR7HJxr6kPDuOMxHecYegKgmX
	savB+9DR0NzRbD5Q0zEEseIGOpRiDNJdBlbb1aZldirwulGdggxsc286axQZPLgumtMYffWioTj
	Ov7DwaGT0qiW33d8ugXjQ6QtnsuRUtRZCpnJANdvstYSeV9swXgqN+OsAnyhYieSOluoimiNLz/
	e+HSQXCGusD8TbWEMOeDm1MrQtpepMXpAHtanNK29iQPXDw=
X-Google-Smtp-Source: AGHT+IETdqsy5jvbhUavo2NyAbB3W8tYKiOiWynpMTP5FbnoUWr2b+HiH6Kec9eESf+YvAGMdJJyjA==
X-Received: by 2002:a05:6000:430c:b0:39c:1258:17d7 with SMTP id ffacd0b85a97d-39efbb0ebd4mr3546038f8f.16.1745294739206;
        Mon, 21 Apr 2025 21:05:39 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50bdac20sm74415375ad.2.2025.04.21.21.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 21:05:38 -0700 (PDT)
Message-ID: <eeb8eb45-0a45-431b-9066-aa0ac75f99e7@suse.com>
Date: Tue, 22 Apr 2025 12:05:37 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ocfs2: Switch osb->disable_recovery to enum
To: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>, ocfs2-devel@lists.linux.dev
References: <20250403112908.13750-1-jack@suse.cz>
 <20250403113250.20572-4-jack@suse.cz>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250403113250.20572-4-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 19:32, Jan Kara wrote:
> We will need more recovery states than just pure enable / disable to fix
> deadlocks with quota recovery. Switch osb->disable_recovery to enum.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   fs/ocfs2/journal.c | 14 ++++++++------
>   fs/ocfs2/ocfs2.h   |  7 ++++++-
>   2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index f1b4b3e611cb..8986e813ab2c 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -174,7 +174,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
>   	struct ocfs2_recovery_map *rm;
>   
>   	mutex_init(&osb->recovery_lock);
> -	osb->disable_recovery = 0;
> +	osb->recovery_state = OCFS2_REC_ENABLED;
>   	osb->recovery_thread_task = NULL;
>   	init_waitqueue_head(&osb->recovery_event);
>   
> @@ -206,7 +206,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
>   	/* disable any new recovery threads and wait for any currently
>   	 * running ones to exit. Do this before setting the vol_state. */
>   	mutex_lock(&osb->recovery_lock);
> -	osb->disable_recovery = 1;
> +	osb->recovery_state = OCFS2_REC_DISABLED;
>   	mutex_unlock(&osb->recovery_lock);
>   	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
>   
> @@ -1582,14 +1582,16 @@ static int __ocfs2_recovery_thread(void *arg)
>   
>   void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
>   {
> +	int was_set = -1;
> +
>   	mutex_lock(&osb->recovery_lock);
> +	if (osb->recovery_state < OCFS2_REC_DISABLED)
> +		was_set = ocfs2_recovery_map_set(osb, node_num);
>   
>   	trace_ocfs2_recovery_thread(node_num, osb->node_num,
> -		osb->disable_recovery, osb->recovery_thread_task,
> -		osb->disable_recovery ?
> -		-1 : ocfs2_recovery_map_set(osb, node_num));
> +		osb->recovery_state, osb->recovery_thread_task, was_set);
>   
> -	if (osb->disable_recovery)
> +	if (osb->recovery_state == OCFS2_REC_DISABLED)
>   		goto out;
>   
>   	if (osb->recovery_thread_task)
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 51c52768132d..e713361939f0 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -308,6 +308,11 @@ enum ocfs2_journal_trigger_type {
>   void ocfs2_initialize_journal_triggers(struct super_block *sb,
>   				       struct ocfs2_triggers triggers[]);
>   
> +enum ocfs2_recovery_state {
> +	OCFS2_REC_ENABLED = 0,
> +	OCFS2_REC_DISABLED,
> +};
> +
>   struct ocfs2_journal;
>   struct ocfs2_slot_info;
>   struct ocfs2_recovery_map;
> @@ -370,7 +375,7 @@ struct ocfs2_super
>   	struct ocfs2_recovery_map *recovery_map;
>   	struct ocfs2_replay_map *replay_map;
>   	struct task_struct *recovery_thread_task;
> -	int disable_recovery;
> +	enum ocfs2_recovery_state recovery_state;
>   	wait_queue_head_t checkpoint_event;
>   	struct ocfs2_journal *journal;
>   	unsigned long osb_commit_interval;


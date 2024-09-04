Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C3E13DBB6
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Sep 2024 07:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725435208; cv=none; b=Lz2IvwKP3MROVmRLkcjTsrlBRVNV/oG91YWAYvCKmNKUjqCWizWv23FxNvKEXoBA1EJv6NR9ojk4wZ0SnrYD5hnZCbcpq4u0Wt+1hO9F6tRmKrURBTvlZGX68O12jCm2R8ZLjWCK7oaYVZtD8P3To1awvIxttehrqIYn4aje4Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725435208; c=relaxed/simple;
	bh=kjIAHlj0EDBWM636Dd4zr8xoJZaVLjDUxE61JT+ORBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F+4wDhrVXKqP2v1GUSH7KmUyXjkNR6iPBuFsqHgrMexW4AHptPAwcc6HthfDrvP0pf8u2P+NGl/DcWNF1DwU12s9jkfOc/Hpp/j2VJnplUslQwERQEYguc2/oSRB1oAzi9fNZwGgM/JtQORyyhSAgV+E7W3gJ2CJU5KAEWOzqvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aYauDwPV; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aYauDwPV"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42c53379a3fso5637175e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Sep 2024 00:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725435204; x=1726040004; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hfkKF7no0L6k1YDWkMmS7m+5OSP6YGibpWHQWa7OBGM=;
        b=aYauDwPVEHrXDM9LDWv0EAL9sDvtd4WUQoKTwuYnZxN1hnWMX20/xEykSqK4VnnbT+
         AUG9ong0T4vGgmWOFpK1Y3pnjGIqhCCQAanwLkkePLRp4Kjc20FZ9x6BG+UZ0RCa025x
         29VPEXNikreLlNj12x38sOqVox5RrMPv3XXAmQT2ikRVOrBjrwNY5nI5fwiO3Wr7usPf
         FBnXjpp23FN3tQnao1HtrUK7VwcMmhpDzEmBWGNNsDcJCzni/nq3W4FV2L9EEHZzcscJ
         Az0y6G/L673+YN0TClXWsKUNi18HHBdl36Buuartf2kJb3qmK9brjMCAra6jsVhEq0oT
         seIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725435204; x=1726040004;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hfkKF7no0L6k1YDWkMmS7m+5OSP6YGibpWHQWa7OBGM=;
        b=Xx7wxXpKBQztK7Ob3kuzaTuGMx8Wce4AZs32Ob44kK4CHJ4qhPW2xM5/BnupHRjCHX
         cLoXxnON1dPVvOVsWDmjd5y0GRLAHOrJ8VAQvmmho99WlbpHwhL7ZyGxlRwBjU1yhIm5
         vg6jttVK3LKtoD/QzQ/1iClanf75S+UwHqpMvzbOX8sVdzrVJujehpMFf+fGImqn478+
         nYd9Z4myrHl6bFizj2FZOrFHq/AGq3lFuduBfGwwBp5AVWycEkloCTDF1ZgW8CqxBBOM
         tEtXLteI5Lth7qx20+zh1XM72GQVj3Q57zeloLOhqyOD3Iul6+l3CnlLW9q1YqCVOswT
         UyaA==
X-Gm-Message-State: AOJu0Yz5tK8hUJ6lHZdZ9JV5BxGNKUPV+bA2qrK9ec6vnA9PdXHmHTUM
	EcD4xfJAOenu3sO0hhvS8+OrhMs6xy1VSH5/sSncPxNGCCqQAUzKL3/yynaWW7M8affs0MbQY4F
	SrSI=
X-Google-Smtp-Source: AGHT+IGTDHNmRY27FGRkvlr1FFv3Cwz3KxeqpbLT6HtZpUFNvLImVB4OWYlUp7zXggyCxWHrji7snQ==
X-Received: by 2002:a5d:5987:0:b0:374:c4c9:d502 with SMTP id ffacd0b85a97d-374c4c9d93fmr4813460f8f.9.1725435203237;
        Wed, 04 Sep 2024 00:33:23 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2da53740084sm3649505a91.32.2024.09.04.00.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 00:33:22 -0700 (PDT)
Message-ID: <7c468963-56a8-4d78-b691-ddf0793f40bf@suse.com>
Date: Wed, 4 Sep 2024 15:33:18 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ocfs2: cancel dqi_sync_work before freeing oinfo
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
References: <20240904071004.2067695-1-joseph.qi@linux.alibaba.com>
Content-Language: en-US
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20240904071004.2067695-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/4/24 15:10, Joseph Qi wrote:
> ocfs2_global_read_info() will initialize and schedule dqi_sync_work at
> the end, if error occurs after successfully reading global quota, it
> will trigger the following warning with CONFIG_DEBUG_OBJECTS_* enabled:
> 
> ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c
> 
> This blames there is an active delayed work when freeing oinfo in error
> handling, so cancel dqi_sync_work first. BTW, return status instead of
> -1 when .read_file_info fails.
> 
> Link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
> Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
> Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
> Fixes: 171bf93ce11f ("ocfs2: Periodic quota syncing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
>   fs/ocfs2/quota_local.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 8ce462c64c51..73d3367c533b 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -692,7 +692,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>   	int status;
>   	struct buffer_head *bh = NULL;
>   	struct ocfs2_quota_recovery *rec;
> -	int locked = 0;
> +	int locked = 0, global_read = 0;
>   
>   	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
>   	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
> @@ -700,6 +700,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>   	if (!oinfo) {
>   		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
>   			       " info.");
> +		status = -ENOMEM;
>   		goto out_err;
>   	}
>   	info->dqi_priv = oinfo;
> @@ -712,6 +713,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>   	status = ocfs2_global_read_info(sb, type);
>   	if (status < 0)
>   		goto out_err;
> +	global_read = 1;
>   
>   	status = ocfs2_inode_lock(lqinode, &oinfo->dqi_lqi_bh, 1);
>   	if (status < 0) {
> @@ -782,10 +784,12 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
>   		if (locked)
>   			ocfs2_inode_unlock(lqinode, 1);
>   		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
> +		if (global_read)
> +			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
>   		kfree(oinfo);
>   	}
>   	brelse(bh);
> -	return -1;
> +	return status;
>   }
>   
>   /* Write local info to quota file */

Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E90C3C17
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Sep 2024 07:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725435229; cv=none; b=PM+ojA8fT6N1BbHmVJPZPTSBKTmwdhtNPbRIXXRhlqC7VHswXBaXg3uE/tRclCZHlI+XGT/fjhh3RyRBSLqCij/E4C0iNe43y7QdjD6mSCeTGTlUPz/8LaYNUPqBv6k65PGqfgy4dvWg0RSQhXPeZ/xiJH8AGW68wPmZxtkvbLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725435229; c=relaxed/simple;
	bh=XfuFXzHuvHgfON9TmVxUj/PkKi7outOSrO18o9M42n0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FPLdJCFk77NOoOaaGOLWPwKqgWxhG4fbvClGCqh/gHB3V0NsmapEPf5HKA7Q1gAsmGHXkS0W5WZ0uLjEBeNM2rpMol0GrnhkpwuPVqpqImcQsYzXEvILVVUu3vlRumbBp8OZHMDaqCSmue9vVRNRJKZbQ0i1u0cVmcfdpbPFxlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dA3wXKux; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dA3wXKux"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42c7bc972a5so5338145e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Sep 2024 00:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725435225; x=1726040025; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lacV3LebicVP+vvxt81DAyEUrVBZ6FLlzY3Nkr6d5vk=;
        b=dA3wXKuxNlP8wujevNKMu+AMc4cPItXXJ2XQHGzsWKfi/VEV2WxiwAClGBXDg5bMQP
         O65MBZZo9DefbTzzyZtD6T8yk+TS5yHWYPbVMm1RjTSQf1BTT5zlOnTO0H/mGuxlDN9w
         jjSGNjngK+NQpTute3PVINd7l5xD09pRZWQywYI6eVUCkMghGJ6uP0lL3W3bTAbZu4C9
         203zFi3ALdumBdvDVCMt0lNECrWo7t4GD63pU+IBENn7GOQscINd2aL+DFi3t+XzM3Fa
         2RafWNfT0pj5dIV1zeNzWAIeqKRJKaeBQ5HR1fbqwhrUiDxXCH9C3Rzv5kZSlyDLREL+
         vw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725435225; x=1726040025;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lacV3LebicVP+vvxt81DAyEUrVBZ6FLlzY3Nkr6d5vk=;
        b=JXMYvbO7Ec1tzG20Ybk7GaQzY7w8/WR3GjL0y1FRz5IrusxJGjeeTytxvo9RpEIezY
         W8BDMQNhuMIJkdRcnp7QHA3LVCqaiarZ4ukVEo9Y9uWZPNQSQBgH9illP/wgaCl5KwuE
         FqdqTVNm1twsK3JcN09Wu/8ngGYPLySfQgPQyEe8U9lNNmAOZWikZeFdeXIbQHzPD9Du
         bjdw5Wzwa7wW/QBwnqSW+yyswZ0HPA7RGyac6zVlQjqXbBLP9NEMs9KLKh7y7QnBP9O6
         8KxKoYv169tl+GkSnoHQtv2zY+2OMZmIW5Oo1cxlgWDTjf0UjJH6ysgh/wUsczKJKo8E
         /4Ng==
X-Gm-Message-State: AOJu0Yz3BoEIM7EE0f7kivEJfv2YvLfVACLjg6ftK+oOCJyI16A6kHEM
	mQG+3XVUAttmByJO5FcpMBqQE7epXmlxQHSYhoEuDvMPqmmp6CM/qQHxOCNLIJY=
X-Google-Smtp-Source: AGHT+IG4OUx3NwMXDIrjN3lxQ/fGEdvOmLhh9jx1pGGzR4cOdaxUgu4cr6jYXPW85asreHt/IjkRcQ==
X-Received: by 2002:a5d:64ae:0:b0:374:cd01:8b73 with SMTP id ffacd0b85a97d-374cd018ecamr2982249f8f.10.1725435224588;
        Wed, 04 Sep 2024 00:33:44 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2da53740084sm3649505a91.32.2024.09.04.00.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 00:33:44 -0700 (PDT)
Message-ID: <9f551194-6e86-41ae-86f7-e9387fbc4871@suse.com>
Date: Wed, 4 Sep 2024 15:33:42 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ocfs2: cleanup return value and mlog in
 ocfs2_global_read_info()
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
References: <20240904071004.2067695-1-joseph.qi@linux.alibaba.com>
 <20240904071004.2067695-2-joseph.qi@linux.alibaba.com>
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20240904071004.2067695-2-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/4/24 15:10, Joseph Qi wrote:
> Return 0 instead of sizeof(ocfs2_global_disk_dqinfo) that .quota_read
> returns in normal case.
> Also cleanup mlog to make code more readable.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Looks good to me.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
>   fs/ocfs2/quota_global.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index 0575c2d060eb..2b0daced98eb 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -371,12 +371,16 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>   
>   	status = ocfs2_extent_map_get_blocks(oinfo->dqi_gqinode, 0, &oinfo->dqi_giblk,
>   					     &pcount, NULL);
> -	if (status < 0)
> +	if (status < 0) {
> +		mlog_errno(status);
>   		goto out_unlock;
> +	}
>   
>   	status = ocfs2_qinfo_lock(oinfo, 0);
> -	if (status < 0)
> +	if (status < 0) {
> +		mlog_errno(status);
>   		goto out_unlock;
> +	}
>   	status = sb->s_op->quota_read(sb, type, (char *)&dinfo,
>   				      sizeof(struct ocfs2_global_disk_dqinfo),
>   				      OCFS2_GLOBAL_INFO_OFF);
> @@ -404,12 +408,11 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
>   	schedule_delayed_work(&oinfo->dqi_sync_work,
>   			      msecs_to_jiffies(oinfo->dqi_syncms));
>   
> -out_err:
> -	return status;
> +	return 0;
>   out_unlock:
>   	ocfs2_unlock_global_qf(oinfo, 0);
> -	mlog_errno(status);
> -	goto out_err;
> +out_err:
> +	return status;
>   }
>   
>   /* Write information to global quota file. Expects exclusive lock on quota

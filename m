Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD69B1C6B5
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 06:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724221400; cv=none; b=EG5uw4CwzqFVCPSyvX1o4iYL/PDyT2XITYjpK1xFCPLM3QkdiFSSw8UHa6O1KTUUAAfg8NczH9tPl7acXvSSNn05gRF2xijz3ijijhvETYh5UR+6ZSftt+NDJnzAI/YeLDfls+X/iyk/mIcEMQs6Jl5DvcRmSAhavTFWXnEvcn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724221400; c=relaxed/simple;
	bh=xv0AJvJdUF0KnKGoGQ8i9Sum+9GGB9bH1fNVehw1E1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3RCuH8k6PZE7V6ZhvPWrAflXyIUhe3Ilj6bcFSgW2cuO52IwSUZsjWDMiExjU+SAYdjr8RHVJvGpP9Z01Ie12DJL4/Dr4yz629v8OHeXNh5dBxrrpyAupyPkNVy+lLzxjwa1D3z19kdcugzTUihHqzfEOB+AASPmgBhLK3dx/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GwE5IfSw; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GwE5IfSw"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42808a69a93so804625e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 23:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724221395; x=1724826195; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0qG4SWY2Kohg76lS5TYD26kdocNak1OXtrtTBUr3UoU=;
        b=GwE5IfSw4lrQeio7Cw654hyaMJLPpbwAXPhXSo8Luv4ra84885I2Wdzg6EqgQgxqfl
         eDAyp02elty9txtR/3+jlMeqa4MYGy0UhmfY3l/SQTYjUiYW6E7JzE2q6k7H/1OAj1FX
         IM6huR6WlP/k6SPKQNOXH7saXxXBWGiqLpcuI+L3tqwZIZEfxd2xEt/xOe+Ku+xppQbf
         5VBjm4HQ0pHMdKYKLtsthAHuvh2tQZ0l93JqHf1q2sKVtagcHqo3weQfg5Fs6269gw+r
         qqp/CQFf9n5InpCrQl8FCH46oV+9mf3vSIxaOHR4cRuWfGrVuuD8NhIsMbpvB1c+gklI
         rHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724221395; x=1724826195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0qG4SWY2Kohg76lS5TYD26kdocNak1OXtrtTBUr3UoU=;
        b=TxMpyyUsswky7oPObTOOGGxheTWRKR53sUo420ZWGTMPw7XDRDPw3V4r8+PDTriVD7
         XPwkuk2523U+t+KA2Y/2D2+Y5dIuZznRTs4OWL7bqb0uhG+/9/1Jj7XdNd6tvG68jRPi
         900fU17hm/n9+bwg6MuSsNvo52OuwAfVklQ7p+9oBQbw+oQ0+kPrLJ+mIUTOvwCzUt4k
         H9W5y1YjriT7GcZfDbY6N9IGgs+amTkpbDqOgRA1e//NKneI7pQpiZxSMI28Fldps+U9
         f20nDMB9EEOhxNfrCAFI6r0LXdtShhMtJ38eP3OLAeNRKUmPdQPPCiePwvuNHmQBB49m
         5sGg==
X-Forwarded-Encrypted: i=1; AJvYcCWtczvl94dIbQ3uqQMXT20ikVJMlLxUAsajQmQ/Lp7KlYYVncC4AA31rBqDGPogEq6zmIQP0XuR3wAblQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyHFeAZz2BV11Qc0yuM+55mgXEIAMdGKsHCwVFerCxCrxZBEJ1W
	WeKuLMmpm14Ok3el3cWC2jBKI9FkH3ihh7ZEcHAIzDEmuCPr+Dh8vyHJSoqwCFc=
X-Google-Smtp-Source: AGHT+IEerjdUpSf5oD4V1rld+yGYKxBwJIf7ozzrycC1U+AOqIYaXn8DI2ScMBFAZEqXXKgOQJdq/Q==
X-Received: by 2002:a5d:5f89:0:b0:371:733c:7882 with SMTP id ffacd0b85a97d-372fd929895mr414959f8f.10.1724221394582;
        Tue, 20 Aug 2024 23:23:14 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eba263f0sm811398a91.33.2024.08.20.23.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 23:23:14 -0700 (PDT)
Message-ID: <0dd1d1b4-5e83-449e-af48-3811abd2e6a4@suse.com>
Date: Wed, 21 Aug 2024 14:23:08 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] ocfs2: Fix possible null-ptr-deref in
 ocfs2_set_buffer_uptodate
Content-Language: en-US
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <20240821055546.3254888-1-lizhi.xu@windriver.com>
 <20240821061450.3478602-1-lizhi.xu@windriver.com>
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <20240821061450.3478602-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Where is my "Reviewed-by" tag, and where is [patch 1/2]?

On 8/21/24 14:14, Lizhi Xu wrote:
> When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
> NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
> bh is NULL.
> 
> Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
> V3 -> V4: Update comments and subject> 
>   fs/ocfs2/buffer_head_io.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index e62c7e1de4eb..8f714406528d 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -388,7 +388,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>   		/* Always set the buffer in the cache, even if it was
>   		 * a forced read, or read-ahead which hasn't yet
>   		 * completed. */
> -		ocfs2_set_buffer_uptodate(ci, bh);
> +		if (bh)
> +			ocfs2_set_buffer_uptodate(ci, bh);
>   	}
>   	ocfs2_metadata_cache_io_unlock(ci);
>   

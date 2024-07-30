Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39714A11
	for <ocfs2-devel@lists.linux.dev>; Tue, 30 Jul 2024 01:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302703; cv=none; b=blah1+ZHv27YsTPy67JaU4O9jiB6HxLH1Br4Bek4Rsy6L5PERfHBq03io3jUFCck4XSFdblszi4V62OU0fgocb+IC9L3kfUZiz4d803+9oReJRDq/OxfZJPRl6tCYG9ynk/RJBvjRvogVm3XXBGE+eyl6c1L5eWAsQOdzP7lB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302703; c=relaxed/simple;
	bh=jmppVpz9rtCW+HKwmoC+eX5xeWhMVEcfxTmCLoP80yc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=seUbc6gan2ZuANavdHrPaiMfM+/oeYx7Mbs3a5NEiu/CQjEtOKSTZSHnNqcb+F1fbBVOASYEibbGtz1lwMwb5eqDsOdnCqpnXlq4PEk6S0mmdmMY0YyevtVyE5s9NT6FNsa++btaA8eG/y5D1ZSoM1G1l5NVBU+UMlrLx+ijlYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G1oaYTmh; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G1oaYTmh"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42809d6e719so21853165e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 18:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722302699; x=1722907499; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O8CK8Yt2Ubr/DRzlYfrTm9pK7jRdx23Ed2vM2rdOiZk=;
        b=G1oaYTmhbVHVtUt+oy0s/Yh9C9o4eeaqcWabPwFzUSM+1YuBae32fDNvptGNAZnYPy
         LePnrZlr2d+Rw9HKnzDHQi7uE1SEWIp1JD7dL9tkHULmH/mQlVirdZLYHOLnWWxq69lf
         +QzzDfplXMOkmRx2vWQfBgLeolv1bPoUt/aTYdUoSkRuRbJDMFNidyBO33GRxLXDVG8y
         ngtM2kO+epCdbTaROekbXplbCnshSilXkfCKkvCvcAFUKK3zjHS77dx/HrHeCHfXGYHT
         w66has0uP1OVUzxqps+2+Yr+RyeUdnK+1O3Rp+AFT7dCEEjeovUwNkRgQgJcBDGQnx6C
         y4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722302699; x=1722907499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8CK8Yt2Ubr/DRzlYfrTm9pK7jRdx23Ed2vM2rdOiZk=;
        b=OAH0EK3kQmHNTWgLSrS45H/WaZUaANBHBy7LxOIQOpiPx52zTLxG3JE9mHUuSTF/Wc
         9AbvAomL13QAKm2d5GDGqw93Jf91BSG/ylpx8FHQe4tyIyxzvy0el8TeF5oKgdvUSYol
         4Fx6Lv9dbN3vI7agZ3D/61OgCNWQQEHgJi2zmhemIJrD9jRX1VgoAi69xehfbnwEaZT9
         46aersD3VyNvqfTDBo1WzQq0V1fTcCG/ubXR8p3FPYsAB0FARoyO84vd8h9kHddsTvfT
         to6hxska5h7FQ6UoJ/9RBVHVIAsmQq71wncwUoP4AEV0/GHd/443Vuqmvlg26UwPROO5
         TKYQ==
X-Gm-Message-State: AOJu0Yw1HJB4GrpCmBlYvGpn+cvHvH7PdVI7OAv6l1GgZQKtlMZLF0xp
	BixUkmFLyZKTHsiBAf336RR7KjK5+riuYP7oCCCcr7MqcywDnYgtvy90nVcdrCU=
X-Google-Smtp-Source: AGHT+IFmjK+LZZQ92l6YyBgI2dpbJPh40kWgdZfwpd1wlM+o16Z3BtvltJDbFzu6KtPNK8eeBUsA1Q==
X-Received: by 2002:adf:f7ca:0:b0:367:892a:b32 with SMTP id ffacd0b85a97d-36b5d0ddf34mr6078568f8f.60.1722302698754;
        Mon, 29 Jul 2024 18:24:58 -0700 (PDT)
Received: from [192.168.2.179] ([2406:4440:0:105::28:b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb73efdf2sm11238270a91.29.2024.07.29.18.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 18:24:58 -0700 (PDT)
Message-ID: <1a2d6309-9730-44d0-80da-781a88af1ca4@suse.com>
Date: Tue, 30 Jul 2024 09:24:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ocfs2: detect released suballocator bg for
 fh_to_[dentry|parent]
To: Heming Zhao <heming.zhao@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240729080454.12771-1-heming.zhao@suse.com>
 <20240729080454.12771-3-heming.zhao@suse.com>
Content-Language: en-US
From: Su Yue <glass.su@suse.com>
In-Reply-To: <20240729080454.12771-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/7/29 16:04, Heming Zhao wrote:
> After ocfs2 has the ability to reclaim suballoc free bg, the
> suballocator block group may be released. This change makes xfstest
> case 426 failed.
> 
> The existed code call stack:
> 
> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
>   ocfs2_get_dentry
>    ocfs2_test_inode_bit
>     ocfs2_test_suballoc_bit
>      ocfs2_read_group_descriptor
>       + read released bg, triggers validate fails, then cause -EROFS
> 
> how to fix:
> The read bg failure is expectation, we should ignore this error.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

LGTM:
Reviewed-by: Su Yue <glass.su@suse.com>
> ---
>   fs/ocfs2/suballoc.c | 27 ++++++++++++++++++---------
>   1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 1b64f4c87607..dc421f55ed8f 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -3037,7 +3037,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>   	struct ocfs2_group_desc *group;
>   	struct buffer_head *group_bh = NULL;
>   	u64 bg_blkno;
> -	int status;
> +	int status, quiet = 0;
>   
>   	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
>   				      (unsigned int)bit);
> @@ -3053,11 +3053,16 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>   
>   	bg_blkno = group_blkno ? group_blkno :
>   		   ocfs2_which_suballoc_group(blkno, bit);
> -	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
> +	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
>   					     &group_bh);
>   	if (status < 0) {
> -		mlog(ML_ERROR, "read group %llu failed %d\n",
> -		     (unsigned long long)bg_blkno, status);
> +		if (status == -EIDRM) {
> +			quiet = 1;
> +			status = -EINVAL;
> +		} else {
> +			mlog(ML_ERROR, "read group %llu failed %d\n",
> +					(unsigned long long)bg_blkno, status);
> +		}
>   		goto bail;
>   	}
>   
> @@ -3067,7 +3072,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>   bail:
>   	brelse(group_bh);
>   
> -	if (status)
> +	if (status && (!quiet))
>   		mlog_errno(status);
>   	return status;
>   }
> @@ -3087,7 +3092,7 @@ static int ocfs2_test_suballoc_bit(struct ocfs2_super *osb,
>    */
>   int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>   {
> -	int status;
> +	int status, quiet = 0;
>   	u64 group_blkno = 0;
>   	u16 suballoc_bit = 0, suballoc_slot = 0;
>   	struct inode *inode_alloc_inode;
> @@ -3129,8 +3134,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>   
>   	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>   					 group_blkno, blkno, suballoc_bit, res);
> -	if (status < 0)
> -		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> +	if (status < 0) {
> +		if (status == -EINVAL)
> +			quiet = 1;
> +		else
> +			mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
> +	}
>   
>   	ocfs2_inode_unlock(inode_alloc_inode, 0);
>   	inode_unlock(inode_alloc_inode);
> @@ -3138,7 +3147,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>   	iput(inode_alloc_inode);
>   	brelse(alloc_bh);
>   bail:
> -	if (status)
> +	if (status && !quiet)
>   		mlog_errno(status);
>   	return status;
>   }

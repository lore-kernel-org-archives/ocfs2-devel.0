Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E7B155398
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Dec 2024 04:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733285293; cv=none; b=R+dWikITxSLNn1+4/ZBjvXTq0nvCocnRdhJD1kdnsvNlBQhugcfOa9wTir2gJOICb+xrO9EQGdfSdyQKHJseFO5NK53wEvz5y6S57u622js0l7jF6wXEQa2E8upT336Zp26nwu7BFqcJ0IcTi8K6qDe/nj/kDAM08MqBqfKUHSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733285293; c=relaxed/simple;
	bh=TZQBrheMnsgYnQVhKxCW0PTfByccTObNkN4XCut593w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRt7P1KSHnT+WbktSob7Cjmncnn20SgorNxcUCvXg7ahiq7duwDsTGq4J/F9cRxd5B7Nv4gxg23Y9CrRNYATfgmSWwowZfbq3RcBGpMtCI46yr7FVurwAaXJG1C4+yN3QnE6p+qUcaYUCDk0N1TGsTMRa539keGK8zQuNF6s/Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HRgB1A47; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HRgB1A47"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4348f65e373so7403945e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Dec 2024 20:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733285288; x=1733890088; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x2ON5vU3fLSgPL/E2zKUe48MfnIXCn/Dg1fGkNj/V0I=;
        b=HRgB1A47XvcS9y3srcQttVB/dBShOJQjLI78dp1r/+Lb0zvO3EdnHFQA/FdSSj2tDS
         Nhd+Uvhni7ISkjH3yaigjblxxmkNXB8OK17v0l7ZE3Q0GGI18YV5b4Jr9YV+WJNAJ19y
         G71r7a2sb67G9uH4hCuQmv0AnihG4ojztCcJIdvHvkGDz70G+snRChLa1yb+b9A7nlR7
         JDOUwfvnsfU/67UIFQ85mVKy7JvuJPDQZi92iMJOqqdlu5osonCG/DLMZC92V3XAmYbY
         Zz/8fpWc3Qt9/lXrJHYRKojWo+LzVnieCHdoLS9PxIfAcz2GR/NPn4uf3VI1PC3uMxDI
         lwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733285288; x=1733890088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x2ON5vU3fLSgPL/E2zKUe48MfnIXCn/Dg1fGkNj/V0I=;
        b=sPT2a4v1tfgiyVK7yigNoCtRh9Y/XJxKC7NB9lSEVvMAlXOtEr64oQM30GnJ/Hvqj4
         7UxxHO+zKJZN2e0/MuVVTHmgAUw9tKuV6v1QCZLvHY2AxCSzE9NXl0OzjktlcQZxqc+W
         NIxmFteC1jYoCYu39bonV5h/6tgaho6cqvpibZn8CLPuUHZzr/ZaDi6HeW6tshl2Onwk
         Mpjgl6iKoONUFPfTUZNq4o42SjCdnNwkjhKKBwOwnVszaLeIEDIwxFTJSuZehY74VkeA
         yQ/oFzJoE3CJMBRf2praz8eFSeQflMNyOeHkhm9VhCycx8qXAhybQaPT/c/eirSuitu9
         7HcA==
X-Forwarded-Encrypted: i=1; AJvYcCXl5Rm68OlRRRw2UQMb8R6x8v4LvuI59QVrZ5TFxAfi2C09TLQrnHj53QVrHP8e9TubMWPqm8iC9xUy8A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzQncn6qEMQ1OgPXeDpZTpP3XVWTqn7zjRPnbe/ptRpXRhz2Ged
	P8Eo/qLKan15bReR/B/tJG4tIkIfbnZhGTQZTk3vhkG0+7Zj/OMKU0SPbrS5xWg=
X-Gm-Gg: ASbGncue3gJDPhx6Xx9cxt2tO07CqYdT0L9oSUr50IxndhN+MXbShEosM2YhjQ56kgi
	FQ16tWK5ar1G0OfK+zJsXO3snTrWWHzq/KhE4QtmUiEGfXhh3FHIztoXUciVcNTRWqhoPy6trDP
	yRD8SppXveVVwrS1UUMW8LMFafQpZyfd4nxdlVC/mP7x9IwiPkqeixZ6wcU3KnKNHwYKqkHhv4s
	XZLivwDk1BiGltU0NYE/yYKqBJSWBHJyqxiXmZcSZqR8aL56ynZug==
X-Google-Smtp-Source: AGHT+IGHxvkiCBB4NiaPLH6M0SGztZMFIbJXXT9ig9h0h8STLB/tXqB8/nl4xw6BPF3PioI3NBI78A==
X-Received: by 2002:a5d:6d08:0:b0:385:df73:2f43 with SMTP id ffacd0b85a97d-385fd3c2f57mr1572855f8f.2.1733285288539;
        Tue, 03 Dec 2024 20:08:08 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725417fbac2sm11301175b3a.96.2024.12.03.20.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 20:08:07 -0800 (PST)
Message-ID: <a785bbf5-7fa4-4c22-b4db-32df21695073@suse.com>
Date: Wed, 4 Dec 2024 12:08:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: fix the la space leak when unmounting an ocfs2
 volume
To: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 gregkh@linuxfoundation.org
References: <20241204033243.8273-1-heming.zhao@suse.com>
 <20241204033243.8273-3-heming.zhao@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20241204033243.8273-3-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/24 11:32, Heming Zhao wrote:
> This bug has existed since the initial OCFS2 code.  The code logic in
forgot revise commit, very stupid mistake.

> ocfs2_sync_local_to_main() is wrong, as it ignores the last contiguous
> free bits, which causes an OCFS2 volume to lose the last free clusters of
> LA window on each umount command.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
> ---
>   fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5df34561c551..8ac42ea81a17 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>   		start = bit_off + 1;
>   	}
>   
> +	/* clear the contiguous bits until the end boundary */
> +	if (count) {
> +		blkno = la_start_blk +
> +			ocfs2_clusters_to_blocks(osb->sb,
> +					start - count);
> +
> +		trace_ocfs2_sync_local_to_main_free(
> +				count, start - count,
> +				(unsigned long long)la_start_blk,
> +				(unsigned long long)blkno);
> +
> +		status = ocfs2_release_clusters(handle,
> +				main_bm_inode,
> +				main_bm_bh, blkno,
> +				count);
> +		if (status < 0)
> +			mlog_errno(status);
> +	}
> +
>   bail:
>   	if (status)
>   		mlog_errno(status);


Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54797566A
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jul 2024 13:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721224472; cv=none; b=nKar9MNZYJJJZAnAiyfFo0+hsq8MKJ2KOsmv4Ysk5T/TKEky9qcqcrvhEXJvNASphr8CT/w3tKA92sUda86nc3ZMwOTYPJ8BFeYabMXdN8Lcq1gk9ZYPEek0YcJJTk1wFRjr05yEOAjtiwmiuYSzq9KJu5+cQCRy8B0GbdPJuQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721224472; c=relaxed/simple;
	bh=wm/nY/MXd6rDvfYcNhcyScEI9JaBFg7Qo1vbquTh5IQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eCY9/s+om/uIbEXsmxRW5O+C+4ffJZTUWY62Lo8s4jiwLq7NR70JmnFpzjnt2LXGUrhf00qkpR94hxmqrtMm+E4H9/ctn5uoyp1hUPAnCXrKV3DC9dDDgRuYRpUfgA1zhoNDF94/H9V1Xm+mYXSNSalRUppHTppT1fWDSQ1+38w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QTETz22g; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QTETz22g"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so1591326a12.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jul 2024 06:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721224468; x=1721829268; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WMpWHaGrX+PYyYhWhaWRqYltJ8RE7RJy2Q7DV5Aj6JI=;
        b=QTETz22gKaxU2orGnEFJ0SZ5Aqho4RQCrDaPrVGg1cEja9zW900QWTLGqhDTF5KlS6
         2UYXjZmT0xsJc9joE63pMF2v3RakIGX3xseEq0EWbbDNyLIWCxU/WvvfrIEtwn6ewAkp
         c60eKchhq7atDmTsvsvFqXnvwmjGqSP/0mpuTQFPfHmv1TNgKSP5omS3rKtpPzsazTH3
         AupXF2FjFaWHSfYiTZO0bx37uLJahIo/xQmJN4i7+nYRPyHYShjjUEGfu9jr29tB6cun
         Sr7+g3Pk7F+KGDlNx32CCQDCK9462K+NVAMkUlIpNmUpWJ9y685oZqDK1FIivdjplw7G
         japA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721224468; x=1721829268;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WMpWHaGrX+PYyYhWhaWRqYltJ8RE7RJy2Q7DV5Aj6JI=;
        b=B9J4Fb+eGPqlMmG+FMFZvudRb5dXXDwB2RylgBEc3LE/8QxDgECUTV57PHT6543qCw
         4cVJ7mKD/FL77gb8pxsbkDNpe6n+ScCzjZm9zGf2B3AI5pHN1q5Hm1JqdJ/30sqcummq
         2kQ+GbxmbmvUG1IzXZRTHF/vdz8dsksuNSa8l7preVS+30XVOUAooJFNguo//F9iFYW1
         F9OCslv6emvYB5YIR8/vINP+e3hcnHbrsGW29L27a5EIBD+yekprJ52k4UGS1yZJ80Xf
         PZXzxOt0gXn9naygjcYoig3ErdJGLkJrRDSC/LWhFRsWbsfK+IAQQ4AwvfDb/kcfJHCr
         E4Og==
X-Gm-Message-State: AOJu0Ywd4NwClaTIeZgeyx1EycDwHMKmYuirF0+Vbp5Iux4r62fMrTrv
	RXbteF/sA6iufv9mmY1UOJXAQsWNLfN1DDIJXFHbwq0QnHUKsKqYNvSUj8GZDq24qfYu8XxFWMC
	iAB8=
X-Google-Smtp-Source: AGHT+IHOkT7Cl5buvNrmXuNi8C4jh1kZHnlwm2dfGlLOq5cwcGdGurK/f7c2INU08KQhv17zBYZoXA==
X-Received: by 2002:a17:906:be9:b0:a77:e152:a8e with SMTP id a640c23a62f3a-a79edcf5211mr499556066b.26.1721224468505;
        Wed, 17 Jul 2024 06:54:28 -0700 (PDT)
Received: from [192.168.2.144] ([2406:4440:0:105::28:b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0bb72243sm76043115ad.47.2024.07.17.06.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 06:54:28 -0700 (PDT)
Message-ID: <1eda17b9-113a-481b-b5a8-a3c7173a5476@suse.com>
Date: Wed, 17 Jul 2024 21:54:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ocfs2: fix the la space leak when unmounting an ocfs2
 volume
To: Heming Zhao <heming.zhao@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240717064424.11090-1-heming.zhao@suse.com>
Content-Language: en-US
From: Su Yue <glass.su@suse.com>
In-Reply-To: <20240717064424.11090-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[resent because gmail webapp appended html content after plain text]

On 2024/7/17 14:44, Heming Zhao wrote:
> This bug has existed since the initial OCFS2 code. The code logic
> in ocfs2_sync_local_to_main() is wrong, as it ignores the last
> contiguous free bits, which causes an OCFS2 volume to lose the
> LA window size space on each umount command.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

LGTM:
Reviewed-by: Su Yue <glass.su@suse.com>
One nitpick below.

> ---
>   fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 5df34561c551..0c45b139d9b9 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>   		start = bit_off + 1;
>   	}
>   
> +	/* clear the contiguous bits until the end boundary */
> +	if (count && (start <= left)) {

IMO if (count) is enough. start can not be left + 1 as start is 
calculated from bit_off + 1 in the above loop. So start - count is safe.

-- 
Su


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

Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398112FFDF4
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 06:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656126; cv=none; b=a0ARho/00fDcLnPIj2+daw+5LM6Vz2pXLsG+pI0LUh0Idcl+uOjEq301zJWWCv9SSeLALJosjWsRSVCXhJnvIp4R1xIceo+u1jWaxP8++ZaLL9hpxabobrJM2iuD2S9pXA1bO9sMfHXRK3ybgolLx+lNSVRTW6ZnyKkUhqGS8tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656126; c=relaxed/simple;
	bh=D5ODAxN1b2DSDH8fzGeg8TqJmEEgXt+e2+pyNKPx9g0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LD5XgUDPYRgBW31E/ZF89/EtFGtz95pSco8zA0mYUt0pS5EkQ1NIRZ8H2Nr9Ec78R/lxns1eFDl4O+CMmu58+/KAMXSPbjx9ymzV5TQal47uZOlbccNUcq81pFfjwn+J28w3wHKwtRO/9AaymI6Kft9riA2LowbR/QnBv5JQRxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CD4bKLIn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CD4bKLIn"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47798f4059fso6397325e9.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 22:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764656121; x=1765260921; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TBGPdqpCBcrxzODxroidUmQ4NEXfU86gdHs1LmLr3Pc=;
        b=CD4bKLIntCeLQj/v0M/OC2xreuf4Kv/YFg/eyWy0ezrFRzFKEdn7uZ1UPu8uHQ9QRG
         lo0zej07bDzYQeNb77HCLpBXcD6LWdt+X/6GFynOXCsr5daMUkHD8bU3tqOyNmboeBSi
         CnELrOImKFSW/wU538rnwmPsElMbtmBYM/wPXnlaZ3ZsZvy4VO8hZGJVjpuad106FwYc
         8FliJTRiEAJW9fAXZrH/qYWfF1pMuNEonKFX47nppx+EqmzvuwzMPNsKcXn94ZFYh3ZD
         d/Adm3g97jp4OaT3UTLGZH8wLsyS8tttpSUQ4R72EdUAzdcxIjuhTgbarVqas4hZEJkO
         v7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764656121; x=1765260921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TBGPdqpCBcrxzODxroidUmQ4NEXfU86gdHs1LmLr3Pc=;
        b=I0hlS2TmcKdaejRRwiSEDqgZd8tPJk0NPPPA/SdnGHrKkeeFCInXMHLh/i+zbhQmrP
         QddL5Amlv+72a1S1LKxPhp1lowrOYbhPFGbYDadryR2ZmkewziLnHR6JnfxGd25kmp6n
         AD9tNOrHNpHCoovvfzIIvYLU/P/6vjdlq76xYY/742Nv9B2+jd2g7WXNjBhXAfJ6P7ZC
         yQRd2K4esnJ4cfQIK/+7c38l9hwiiu3+FA5PaFs1z+lEqzqr8ji+UIb82ehB6J+ul8F/
         bY8MngnB34VTREyM6b8UErGiYiF3NqwnlU/AwHpOWgv1fsqNnKwQIEY/BaEylbWWkZ00
         vI+A==
X-Forwarded-Encrypted: i=1; AJvYcCUtom60ndmzBqhgKqtEr+ln8UTGsKGO1r2Cr66ZatbfIfy3xpy8W/KjYol+HQuBtd7X555t99obd6EhUw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz54nn52tQmgirw1qFXW9uwjPAYBhsDZVkNeLHjJNq0TnYkjPg8
	p1ILVc1UnpELzfLgTAlb5w7CSjwUlgxxHbGFp9K8bemZ13dbULZU0JHz1qGVNHWkF9k=
X-Gm-Gg: ASbGncsu8MIixHajtburon9qie5YNnumyPbj1QSJME6UoHPuM87lxkSZggZYSB5cGEY
	Cr7R7xBokZ8cpX58SMe8WTDLx48Sx6TrZVUfscUtzOYTh042eNh4++qzDTU7oMpnNez4EETzNYp
	c/aVhQoC4YYiecRliSvpJ4rkzqGq+VC1i18NKhGKVVcOEqQkxRwMVBD+BhVA47sCSZEthA89tIS
	oLRTmWGpvVYC2v9ZsuOi7OxPcmrg9LaCCdNo5arznCEj61E4KyFneQ2nZcUiFLjkHpr1claTB/e
	QBmwRLJkiaNgpNzIrIYA0Bz31T9VYu3BjN34HzDXRqIonuXEvn3PHoOKAJ2rQdTQIB12pJyoUV0
	Y/3fSMrmptkubYOiohwSe/kAzF3wBOr1+1rAmYQuh4Bpy206j/nQkkOVmtaV7NJREVC3gpH0Mou
	a+HTdZeBy04Q==
X-Google-Smtp-Source: AGHT+IErXBGyQqOwaTCuibDFjKTOPTSD4wQllf/Udnw6BvlgS4bCG7WmCSC/g50yNc7yb+FzXZHGKg==
X-Received: by 2002:a05:600c:19cd:b0:477:a203:66dd with SMTP id 5b1f17b1804b1-477c016c83emr213486025e9.2.1764656121508;
        Mon, 01 Dec 2025 22:15:21 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d14b870a4dsm15722471b3a.0.2025.12.01.22.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 22:15:20 -0800 (PST)
Date: Tue, 2 Dec 2025 14:15:18 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH v5] ocfs2: Invalidate inode if i_mode is zero after block
 read
Message-ID: <r3mqyzrky6pamao7b4tsobdqqybhmyt6dg7jao76ho24kph3aq@wfwbzjqzury5>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251202035213.633096-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202035213.633096-2-eraykrdg1@gmail.com>

On Tue, Dec 02, 2025 at 06:52:14AM +0300, Ahmet Eray Karadag wrote:
> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
> 
> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
> even after ocfs2_validate_inode_block successfully validates a block
> that structurally looks okay (passes checksum, signature etc.) but
> contains semantically invalid data (specifically i_mode=0). The current
> validation function doesn't check for i_mode being zero.
> 
> This results in an in-memory inode with i_mode=0 being added to the VFS
> cache, which later triggers the panic during unlink.
> 
> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
> make_bad_inode(), correctly preventing the zombie inode from entering
> the cache.
> 
> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
> ---
> v2:
>  - Only checking either i_links_count == 0 or i_mode == 0
>  - Not performing le16_to_cpu() anymore
>  - Tested with ocfs2-test
> ---
> v3:
>  - Add checking both high and low bits of i_links_count
> ---
> v4:
>  - Reading i_links_count hi and low bits without helper function
>   to save few cpu cycles
> ---
> v5:
>  - Clear i_links_count check
>  - Log the actual i_nlink/i_mode
> ---
>  fs/ocfs2/inode.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 14bf440ea4df..08ce0846289c 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1456,6 +1456,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
> +		mlog(ML_ERROR, "Invalid dinode #%llu: "
> +			"Corrupt state (nlink = %u or mode = %u) detected!\n",
> +		        (unsigned long long)bh->b_blocknr,
> +			(di->i_links_count_hi | di->i_links_count), di->i_mode);

The '|' logic is meaningless here. Because the error case is rare, you can simply
call ocfs2_read_links_count(di).

- Heming
> +		rc = -EFSCORRUPTED;
> +		goto bail;
> +	}
>  	/*
>  	 * Errors after here are fatal.
>  	 */
> -- 
> 2.43.0
> 
> 

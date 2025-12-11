Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB3328D8DF
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765464674; cv=none; b=ixsWKGo8PHpzzHJo1gjKtv5vjOFKHdwG/gxu+b9X02OtmGvLtJsJyYrxo5oHpX2dr0gk/eNB52WTEiWywltqBpqwbYoKHZtuBUGTv9ffAY/4SCegS+Bv6p7mOdVlPr7J1Klfnc1dUWU3WOKAomUVknLTOGoEMHomPRYhTzFRl0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765464674; c=relaxed/simple;
	bh=GaUgbGvyF2x5g5cOrbKbhlaYJel/H3JXbOScwzYa9YQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DilbV/MfLH212HT1GhwXIun3JJDi4+q6NzW9EWDXcBWlusocF4Qec+phvHEj4OzzkWnDQSKkuY3yR4NPwCmzykR80M7eAre/GHeqSrp18/GrYnUAS9FlUsNIlhVKgZr/tTGgFirYDTGV44Cziwn9ydzPLx05AwZGvDQw65pStYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CN8MmL8x; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CN8MmL8x"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779b49d724so453435e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 06:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765464670; x=1766069470; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HyOWep6Z+3l/4huZPXFl9941sB3JmGErDJCXMCXIk50=;
        b=CN8MmL8xrkDy9KTnXAZrMjkuzES8E6hacUM8J2pqt4SRrDtfq1EaJEEBBbdgR6x+/+
         bxgGz0HA7BlQjsmas+wpyslFp/dWoxnZQTHNv+mVG/hoqvki14be1wpdW4J88Uffg8uB
         zDSCbPmjwUHRVgrJyZXT2Y195a6Jr33S2BWi7UJ6kKdFhaMvPOAMR/GCcRdgpd0nHpST
         6/yUmgjpM2BE/iv1D+mHOjgLF22QaQd0cN+fsHQcCh0tLURjUptUmunJcjHm6x+sp3En
         HB9eXynD3qGA5kPYYywEuTfXTY+NYWZm2sLJoDefCdhFa2u7GH3JpwGwmofsMRBUZRNA
         sRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765464670; x=1766069470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HyOWep6Z+3l/4huZPXFl9941sB3JmGErDJCXMCXIk50=;
        b=hgFlcPnQHYLVQYOQArzflbsAm5h84kKcfpKNPl/WQH9rMG+U84sPBV+ndYOJLs2x39
         7zRSvJtcjhVa//0DFocsLIkDvNQSbz9chAqf+ShZMT/f30eW/LWO8pLjtvj5NvAKJ5vi
         oK/vVG6Bp/pRGjx4Hc34rpFBlY42DhcYxEeeN53jDyYudyLArszpRczlS5OzDMRAuuIQ
         teH2XJ3yHrWNu5NyL92xBmFYlJ0r7jWnpuV5hOuFbFzekkU9dVt2Q38indKollE3Pt+m
         ZQUSEwXMfyJemJwV42ZkB7B3vzCPXlhcg9nDxa3yn601dfH37EMcVAUboRs04pGc3iEV
         wMRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRhhP9NR6cUm+FuUq7Eqw75LFemIB4TknEhR797yTVzleCjuF3yE5BoLhNFM4/L+HoXRH3I1KFK4Q4qw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzl6rbpUHj+kvXJaoMCUCbZyBlTgbUQGcxg/p1O5auM1Jfi1+yU
	HkUC8VQ+G/mu1rd6zlIKq1cw3zmcgyPEEJoA5zlhemxbpXQTUacwojwSaSWFSMUPJK0=
X-Gm-Gg: AY/fxX7vt/AMb/6f6Z0iBSi5mt2wkA0wTukKNek4hMWsLSrt5jMIhsG7KlzzBMR5iBW
	beG1amDFZ8rjdQxoy17dQ+yc2ueT+h3ekaPXvK/DGrfzFLa/jPcOLZm+cYOY2QKcs2A4+MxzFJw
	rdXBjeeaslAItEp5tFGKZfyxDzVoKv4YcMdz28Q6te3Jit5QNz3AD+tycnzKsLATnR3uUx1MPhF
	emUnso5G5NKE2JwerWhxwT2PY2SvIKRJqWqNrInjUafli//XsIGmX9YOX+otQaOkpqinZSgj8Sl
	b/xNUzDLFRZvJY6+5QLXuH0ShZEbytWf1K45n/VBRx5hNB9e1y/9PPqZ0FZodYCXNtzJlTVgS6Z
	256e48j4mEIdk/sqOd4HQ/JhO0Mnz10CSpn1KsgSM0UW+xMEnW+HsfSbJoiSyI777S7HQdVBM2S
	xZKCxQ+Chb3Q==
X-Google-Smtp-Source: AGHT+IGCDJmIBka64qw7XQLh8lncOPi3VNKakaTXueo2a9IY6YuqbZ8xrM2Pyp4mI9EzjDxSTHBr0g==
X-Received: by 2002:a05:600c:b93:b0:477:a203:66dd with SMTP id 5b1f17b1804b1-47a898d2dd9mr16906085e9.2.1765464670332;
        Thu, 11 Dec 2025 06:51:10 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c4ab52aasm2750610b3a.38.2025.12.11.06.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 06:51:09 -0800 (PST)
Date: Thu, 11 Dec 2025 22:51:06 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: validate i_refcount_loc when refcount flag is set
Message-ID: <syaaw5p5nyx3bgp4xrzzb4zze5ljelesfaxzuify7pgo7f3m2n@ooxqgjji73ri>
References: <20251208084407.3021466-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208084407.3021466-1-kartikey406@gmail.com>

On Mon, Dec 08, 2025 at 02:14:07PM +0530, Deepanshu Kartikey wrote:
> Add validation in ocfs2_validate_inode_block() to check that if an
> inode has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid
> i_refcount_loc. A corrupted filesystem image can have this inconsistent
> state, which later triggers a BUG_ON in ocfs2_remove_refcount_tree()
> when the inode is being wiped during unlink.
> 
> Catch this corruption early during inode validation to fail gracefully
> instead of crashing the kernel.
> 
> Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
> Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ocfs2/inode.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 78f81950c9ee..dd56407fc056 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1484,6 +1484,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if ((di->i_dyn_features & cpu_to_le16(OCFS2_HAS_REFCOUNT_FL)) &&
> +	    !di->i_refcount_loc) {
> +		rc = ocfs2_error(sb, "Invalid dinode #%llu: refcount flag set but i_refcount_loc is zero\n",
> +		      (unsigned long long)bh->b_blocknr);
> +		goto bail;
> +	}
> +

The code logic looks good to me, but please run "kernel/scripts/checkpatch.pl"
on the patch before sending it out. We can see that the line length is too long.

Thanks,
Heming
>  	rc = 0;
>  
>  bail:
> -- 
> 2.43.0
> 
> 

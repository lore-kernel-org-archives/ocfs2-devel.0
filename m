Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351EC32572F
	for <ocfs2-devel@lists.linux.dev>; Mon, 22 Dec 2025 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766416879; cv=none; b=AGtVxAqnKBc/6DxfWZA3A/2sNrGQQBI78GlHYYxZadLGMmZHaMfU/YYFDtlZAH8Rqt8eyDreLETXx4XzKxXo8YvInyFd1uyzr99dh2/yD5i7UnNyBrS/2h1FOd86JVZPkfGlSDAn472cz0+cWPYcRz4apKIZTtniW9raXLl8T7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766416879; c=relaxed/simple;
	bh=jilGuhvtiRhmxes00FcFwryTusKzzs0Qxj5IRewUsb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2LuTpxXsiUB2rx1b8MgdgFII40Bc5aMLpDaI/Ql0N+IPPa8rHgsjNZS+xNDhYEMa0SN63mE6g/EjN46BPi6qt1Hk27MFZDRhn1g6DhjKepMZJFke24+MV5Njk2YBK/5Sedspg/C+hYFK0i86tIHHNJLWIA3lGLGxjoTCx3PcVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IBLEe9vs; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IBLEe9vs"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b55ba1e62so277763f8f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 22 Dec 2025 07:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766416875; x=1767021675; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=67683Yp4DfWYCEQ61cFljypiXMZpqTDwo/WPQ4r3APU=;
        b=IBLEe9vsolvFlLlKzqrRAbDtbmGCx7T8B2HrSUtiweVIxxD8IwUQGvjBo4A3Ugos7I
         /t9esqtJqyvstHD8HLDCBVzCwy7GFOZVFYig+6etX4WhxkHvrY8gPFpG9m6XnB6fTLDL
         ojIgGJmVxw43Y5CCf8KwWkgm8NAlEEKI8mOM2gATM3q8MrBkbdJINHQZOjJssJkGA18t
         iUxIOlCZwpJ5ALbxy8WSBq2ISsSapO97FzwcFNNxTgsGd8taTs6+aEWjA8Miqrqkp6PV
         9tHk4+7Z3+oP1nt/r0Ly3IBxfWLdMPjC8XXKJj6H5vNjYxi/LmAfYvTN1EeMzCHqM4+H
         +A3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766416875; x=1767021675;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67683Yp4DfWYCEQ61cFljypiXMZpqTDwo/WPQ4r3APU=;
        b=kdXr1Vgu1C26CSYwUDGgwZDEe79Y7kvynC21X0PjKwG+BHdbDwIs4Mh+2jYBZpHhr3
         OJs473myplal6M115nDwWyPQxxb6e0hQtdUIaDxinJ6WFcQ9gGPxe6NuGt+p5EtcY37k
         PHSI/3x2WsHJ2t1j2LNslHmSiyNMUcSkLlPTlxDQUAhthsfMzaa2GaIsVpKViq5YGkg3
         M1Ds+pL19CeB+/jNcNcMDqbjE0jmMjoyMu/AekY+yEjl+Zbvm64VQiylGUPBXNrbBB8w
         KUkE7OZT4E3qrX4Yfqa2AfGLyWh+P+mfH2e7ErNbyiWhygH+P8p/53kN+GEmWxoF4ZDh
         jWjg==
X-Forwarded-Encrypted: i=1; AJvYcCWg2mTTjVQ48jBIARt4S54AkLeY2f+2QqeQ1cBk3g2WycdZHVMh21djgr2U2adMFH5VasgAlpbXpF0HYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyV4ucySrIyuV1f3OhWUyZOgvULtkZ67WIN4wfayl2BPvQ5asMi
	OtRGYR4XdYDYN2b/mZb3l21pYnHxngHVIVBU2VrgRVZPPIz87Y3sT3RWEwl/t+iITr5fmC5S24g
	sxlnys2Q=
X-Gm-Gg: AY/fxX4SmiB+ElOPhxkOMUuhMxRQcrg8igXh9lRG5iO0CakP9g0iRqbIxp1qNnxwvot
	HaZDJtUHwZgs87cB/y/Su5kc2Ml1ogQ+WuN2hlFsTa5CqNAhkO++DiR7m0UzyR9sVzhW5yRqWqa
	r3iGfEa0hgaC2CZoRaiUiGL9C2mR9vU2x9dmNFnOU8r0AoWavbuKuEn4U3QGxLd/S/a4ui7CR9p
	QylT1dd7VUvTK7c/fXFx3CoUZw6VeLAs44KPelSZI2ZeO3C3K9UfrrNkh6xbwogCiBDtIPacZfN
	Xuo3f1Kv27hoMpHQcVItOkbhHnt/nST1onEllu8RAYKcvMbCl3mPmkiax4QNtk5HztHD3gBskhG
	b2HylvRTUD6pvnPPzgJz4O6D7lFh3UdZanLuGhAR8ZMiPIO7qUaZ0EK5LHFTb5FZWdc/ygL0kCL
	9YFFSO6+4FiA==
X-Google-Smtp-Source: AGHT+IF1MMLXn8cF9gQ8Kub0saoElqwqDv43cL2DbrA9klBBpsVnAtBkl/8MYrLlslInXIb7mvfraA==
X-Received: by 2002:a05:600c:848c:b0:471:1387:377e with SMTP id 5b1f17b1804b1-47d195a0ccemr60957825e9.6.1766416875083;
        Mon, 22 Dec 2025 07:21:15 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d428sm100198035ad.73.2025.12.22.07.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 07:21:14 -0800 (PST)
Date: Mon, 22 Dec 2025 23:21:11 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Prithvi Tambewagh <activprithvi@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	khalid@kernel.org, syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Add check for total number of chains in chain list
Message-ID: <dcbfbwivj2pgid24lp7xynsli5v44fw5lskyg6r6yodr223irp@alqswzjnxmmu>
References: <20251220094928.134849-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220094928.134849-1-activprithvi@gmail.com>

On Sat, Dec 20, 2025 at 03:19:28PM +0530, Prithvi Tambewagh wrote:
> The functions ocfs2_reserve_suballoc_bits(), ocfs2_block_group_alloc(),
> ocfs2_block_group_alloc_contig() and ocfs2_find_smallest_chain() trust
> the on-disk values related to the allocation chain. However, KASAN bug
> was triggered in these functions, and the kernel panicked when accessing
> redzoned memory. This occurred due to the corrupted value of `cl_count`
> field of `struct ocfs2_chain_list`. Upon analysis, the value of `cl_count`
> was observed to be overwhemingly large, due to which the code accessed
> redzoned memory.
> 
> The fix introduces an if statement which validates value of `cl_count`
> (both lower and upper bounds). Lower bound check ensures the value of
> `cl_count` is not zero and upper bound check ensures that the value of
> `cl_count` is in the range such that it has a value less than the total
> size of struct ocfs2_chain_list and maximum number of chains that can be
> present, so as to fill one block.
> 
> Reported-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=af14efe17dfa46173239
> Tested-by: syzbot+af14efe17dfa46173239@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index f7b483f0de2a..7ea63e9cc4f8 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -671,6 +671,21 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>  	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
>  
>  	cl = &fe->id2.i_chain;
> +	unsigned int block_size = osb->sb->s_blocksize;
> +	unsigned int max_cl_count =
> +	(block_size - offsetof(struct ocfs2_chain_list, cl_recs)) /
> +	sizeof(struct ocfs2_chain_rec);
> +
> +	if (!le16_to_cpu(cl->cl_count) ||
> +	    le16_to_cpu(cl->cl_count) > max_cl_count) {
> +		ocfs2_error(osb->sb,
> +			    "Invalid chain list: cl_count %u "
> +			    "exceeds max %u",
> +			    le16_to_cpu(cl->cl_count), max_cl_count);
> +		status = -EIO;
> +		goto bail;
> +	}
> +
>  	status = ocfs2_reserve_clusters_with_limit(osb,
>  						   le16_to_cpu(cl->cl_cpg),
>  						   max_block, flags, &ac);
> 
> base-commit: 36c254515dc6592c44db77b84908358979dd6b50
> -- 
> 2.34.1
> 

Since 'fe' is read by ocfs2_read_inode_block(), the validation function
ocfs2_validate_inode_block() is the appropriate place to perform this sanity
check.

Please follow the pattern in commit e1c70505ee81 ("ocfs2: add extra consistency
checks for chain allocator dinodes") when adding your code.

btw, I am a little bit confused, it seems commit e1c70505ee81 is enough to fix
this syzbot issue.

Thanks,
Heming

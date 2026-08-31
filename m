Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB414BB5BB
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184959; cv=none; b=gAyXFd0FE34tZLctT6NGe4WBbSWuGADTScY4zvq14VR9cfALlUw5fPNYz4s9m33rehhQtJVyo+BiF/kMDwaW96x+vXFfXzPsLpgqI/lHAslhceJAJk1s1OstmmFvnW8eUTcvhUt1ugrJUFAX00ZksFscA3gWT37B0csSyoRU+L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184959; c=relaxed/simple;
	bh=j0rR9MGESIIEuqcISsQKYNt5XVOHewIyabitt0SxDbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lzrew8YC1WeeG1dclvBlJg9bqS5jgzzMaWtPqFG0zNRLQehreQXA62tLscOGx9V4+NTF2RgY03wB44sJsbVCeEtxdgRcwiAlT9e/i5GEBpb27h3u7ZHaqwab73bdfqd+o4d7OLsVSPEJlaj90lgJqFWWlA1pjn49WPYz7b7LGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UKrvGuO6; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UKrvGuO6"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39c68f1e863so1931371fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 07:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788184954; x=1788789754; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+6NgNBrKED1HZLTTfXtmSzKHM84oxFz3evM2YzN+h9A=;
        b=UKrvGuO6OVDmcInuUD0syNCJO8LR8mRlZ1BVSrNGJ9+F1i9p8aYbvSmeXL3WGODnr1
         WPid7gZ/5Z4HvL8r+OxmjvdiuFAxqZWWltq8rt0zS0SQ7Z3Ykba9aalL0QBYP7uKQ2Um
         cnPNwgGXImuCw85SPPN3NGpDvJ4z7yXr3WTRQb1n9WNlufoVDM0g5pgOEV2fF+yiXqjG
         35GhcKDIbTwJY+XuSnFd7tP/ik5l/72L0Hlm174cpL01dLhQm49uZC9NMnNWqsrKQqsR
         A+S/3/14V0LJDtwA9uAcUKik5DfQO1xwwyFyOgM4RhG7sm6hBaHykmHjfRfb0fhG6oi9
         XMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788184954; x=1788789754;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+6NgNBrKED1HZLTTfXtmSzKHM84oxFz3evM2YzN+h9A=;
        b=cjMaHHqcfPpTlm3lDtntqS/Y0XSlwH4v91CxLF/p1W9wEp/gLtZiPAeSQkAuEJadGa
         8jl+Hc36c7sjVyy8aAuNgwpvUyts32F3H+VmBNR8HhRWSXjUAWCDHX4EsHGltzCCU1A+
         DIhu6XHztg2WmQzAIsdBVAg296SeMRQfZyvW6qR5emjBVFkCRgWlNhNUR0hy4CrzDAws
         smBYwnU1fKi1cUKT2tn33lzjgGijEJW90IGjWp/tM6VatBCo0c7Ln/tUgOJwHahoFm1g
         nLSRhInETo09IgmSSnJJamdHejLXbArcmTb7NyKrJsySJ904IdBgF2ink3mG7V3a5/8V
         gY/w==
X-Forwarded-Encrypted: i=1; AKwUvBzYFMZxHk64ksv5f7ujOwVJUzmd4hv7d6vjIlSlz9od3YhH3ebaKVANqjMc8X3fW6Au0EOsb2wqISb1Sg==@lists.linux.dev
X-Gm-Message-State: AFuF++mBvUUfYTfLE813FPs1M0tVagWG61nCH8LEdE3v4r4qm8nrn/E0
	hXcG5eo9CaQKbNLhZ12H5yoeX282a03m85PWkfU6g+xmNGnSYlI3Y5swiCbwM9q6ajA=
X-Gm-Gg: AYBFou2Y0U0OcXkDisvIxxsKWIwCfPc4XM+m9LpqnTYA5um0nLhorud6OzRHbEZX7Gt
	h7qeAnQvBCD1uPrsPvSuEKn8xoT7qj8sF1eEJ4RseHiBnhteGzV4rDz4LN3UEl1o6g3z0Lm8w13
	oCwWEwYO74vYRjvuh2xts2zOUMjz7aeZUwB2JZ5lv8crhaG/oUbOU1F3UuOJgflCqWXEZAGE+6i
	RjZQLB0w2Wlwv8wfDcUtHYKIKdNpuvTzDJV37jIWhI5Oqa2Gd1M0sOZm4aqWd/lCNNtnNrtStIN
	U6/TM44svLINxe/ZVwg/H0nAo0RwZlcYrgocd/NzP4c0IAlGYAr//3wMwn99St9zI4uOVmY1ipg
	D4AEQObdjpkPg6GbK4ncuLiSe1R1B0zsdtMoFyDiQjH+vhwEQ+PlR+vnE+UznMtBc0iP+LR/q3F
	7FsYwcHtNgXhjSxrBkNd8XhsfvJyjKer7MRYpprat42H2TS8gq8JhCoSsUYEE=
X-Received: by 2002:a05:651c:a107:10b0:3a3:38e2:aea1 with SMTP id 38308e7fff4ca-3a338e2b1eamr1597451fa.2.1788184954189;
        Mon, 31 Aug 2026 07:02:34 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396d77f7643sm5961747a91.3.2026.08.31.07.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 07:02:32 -0700 (PDT)
Date: Mon, 31 Aug 2026 22:02:30 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to
 system inodes
Message-ID: <apWJLyCNwqfdiRQb@p15>
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
 <20260831062848.2743436-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831062848.2743436-2-joseph.qi@linux.alibaba.com>

On Mon, Aug 31, 2026 at 02:28:45PM +0800, Joseph Qi wrote:
> ocfs2_validate_inode_block() currently permits i_suballoc_slot to be
> OCFS2_INVALID_SLOT for any dinode.  Only system inodes created by
> mkfs.ocfs2 are allocated from the global allocator and thus
> legitimately carry this value; regular inodes are always allocated
> from a per-slot suballocator and hence must have a valid slot.
> 
> If a corrupted regular inode with OCFS2_INVALID_SLOT is accepted,
> ocfs2_remove_inode() will pass the slot to ocfs2_get_system_file_inode()
> and get_local_system_inode() will hit BUG_ON(slot == OCFS2_INVALID_SLOT)
> when the inode is deleted.  This can be triggered by an unprivileged
> user unlinking such a corrupted file.
> 
> Reject OCFS2_INVALID_SLOT for non-system dinodes during validation,
> while still accepting it for system inodes.
> 
> Fixes: fe7a283b3916 ("ocfs2: add suballoc slot check in ocfs2_validate_inode_block()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index 180107a11046..eda50f13ffb5 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1520,8 +1520,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> -	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
> -	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
> +	/*
> +	 * Only system inodes created by mkfs.ocfs2 are allocated from the
> +	 * global allocator and thus legitimately carry OCFS2_INVALID_SLOT.
> +	 * Regular inodes are always allocated from a per-slot suballocator.
> +	 * If a regular inode with OCFS2_INVALID_SLOT was accepted here,
> +	 * deleting it would pass the slot to get_local_system_inode() via
> +	 * ocfs2_remove_inode() and trigger BUG_ON(slot == OCFS2_INVALID_SLOT).
> +	 */
> +	if (le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT) {
> +		if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)) {
> +			rc = ocfs2_error(sb,
> +					 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
> +					 (unsigned long long)bh->b_blocknr,
> +					 le16_to_cpu(di->i_suballoc_slot));
> +			goto bail;
> +		}
> +	} else if ((u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
>  		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
>  				 (unsigned long long)bh->b_blocknr,
>  				 le16_to_cpu(di->i_suballoc_slot));
> -- 
> 2.39.3
> 

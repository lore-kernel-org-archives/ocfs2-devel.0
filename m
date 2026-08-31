Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A94D48A2BC
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185105; cv=none; b=W4D3XoVyVjhnLLvq9nrMDM8Dk/4v9jK049YSfurIAOYExyrTDXZXEFycpZxoa4yzhrzg8vZBzwSfsnyZVmU4d/eov3Cm115nwEoeuzcvehForwVlJgiW5r4rwVUxxBi+hrDLp+UrqNek4y51gGVodVxO/6dBPsfNb/FhZBi2vxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185105; c=relaxed/simple;
	bh=mUau29xgzygq4fLzKQ7yDYbdE24apwyfC2Kpji4fqBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXQFRO2IuRERs4Y9W3Y9ZJlRjwzPf1H1A1XPh9tyInkpAcZ9DLxYypMOiiFQcmlA9tKWFDeSqcCOSt9GcKkCIn1CltPIGDfImhYx6kJFPMCuSBjwPa9jsBkG1DPCGIiZdVOARpfjD3LtWOVTHo1zfScs3bvREaDiV09O5tODNjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KmdpPEjV; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KmdpPEjV"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954c08a7c8so3390165e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 07:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788185102; x=1788789902; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A3FIxIPh31Oscj7vvNnw/qXBHaaHBzjQMK/QOq0Mhqg=;
        b=KmdpPEjVj4lVyHC8zjealmw4PpsCBYECJyd+2bbI0DBqge+xLe1+bsVLwiSqqnOhOn
         lOcoO8BjUJkm0KHJxPFswaI7DJdqDliKhc78p2Hrbid9IIZLmmiLAdp/LJYwMWswZFma
         L5hoES4HdxPjvgfu+jp5NrCIRn1KIMDgaA2jnEasnfYHH0TiG5m/sYE8KOb70+8qv2g2
         A2mRWWuUwGQXi0p9JSFc84SBegoNwDCOWh33e5c0H+y5GR9fWypDDajBF+J/I6p0v5lz
         QlFhoG/K5lZGHCTq/ZjNHwnfld64NKhLpf0ldMK9EABaAHi1uMs1mubBGPndPlg0KhNf
         KTBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788185102; x=1788789902;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A3FIxIPh31Oscj7vvNnw/qXBHaaHBzjQMK/QOq0Mhqg=;
        b=rdeVS1UOck8+HM2Zf5d5badYEvrzSHqQAJSSfXhQV13ASgJfc7YEnH979g7he6/U30
         jP7rrb7o9N26QvsDZQEKl9oqQ70XwKSpOp8knAN3gMGnvMxw7E1MZbhXZz2zhGiLB2/4
         +1qmnKHhBWXcIhOVvQdyXlOB3tnqF10IRJOxa32yeyR+VfIotL3FkkjhPc34iHv/IQfU
         UI0Yb0TZwq94nu7JnYuEKe9rW/ZkSb0bTRTAkK63YQypN4VHCPsmrg5WmcmN6bI4xFjG
         ldaTCOmLxHYhGzb4YJnJ2ZZPmkBEFfgxpwv97B3bW7PSr8ykVuEkZF6Dqjet4f1Qn/6x
         xGfg==
X-Forwarded-Encrypted: i=1; AHgh+RoxGXvkmqrwHS+6Q0/JKZApHu+GTa/v/+2x5fT1UzqDak5I0EkS1srBZbmvVnUH5A486CMiPMSdXtTXfQ==@lists.linux.dev
X-Gm-Message-State: AFuF++mVhKvLmDf6CNOphM5Pl+YmcGtesc1/jg6hf/L6WDC0wBXP7pCS
	GA1UvH0idm35SchsO1CNuTPokxFXUC1/J7uEdcTmm5WJmYmVS7kIMPYm2mqGOfPUC3A=
X-Gm-Gg: AR+sD13QOn/p/OzjNrd9oM7hqM3BdfZ2Cyk2/f+tnsYwC/dYvdTfAQ+RJ2F2NBdHArT
	JlssP/SSkpYnPlPjQZYwONTm8sCHDWu6jGiErd16UQc/Yaf8vxxTF8ufHozfJIgN2W3TOL4g/xM
	uC2uk5q2zuypauE+LOq3pPOdJ/aYBppNywCKjbzViIkFyO8HBBsTyRejVhHMkPweNHJZgBdwb/B
	EmnPbeYkUnOcs03LWyZ3w5d4mH4O8JB834PRnX6uo808w8yIGIIx5T0ZGmWifB84fMfzoBi4hic
	cOYidFkDnhTYNglSOfDvfe609rNM5rPPK5yu8k+RSqKUPkBMdIvNuIS69/RFKH5EwcQ1QwYjDjp
	iEf8MduCvNFIxKtzY3vNFALlCiVbjx8VnJfNQ7JAzhLWh8gjbkpbI+gCIB/MufLtiE1kW34GWwN
	RimUn6IKZwXzX5cbME5T4sVsACy7MfzTReg5QqVF6cAMkgQoOPKy8HB3I1fRymLCdgGZvJgQ==
X-Received: by 2002:a05:600c:868f:b0:49b:9241:7ff0 with SMTP id 5b1f17b1804b1-49b924181aamr132951965e9.0.1788185101570;
        Mon, 31 Aug 2026 07:05:01 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a359515dsm3959953b3a.48.2026.08.31.07.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 07:05:00 -0700 (PDT)
Date: Mon, 31 Aug 2026 22:04:57 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ocfs2: validate suballoc slot of extent blocks
Message-ID: <apWJ8Jr9YSC03zqr@p15>
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
 <20260831062848.2743436-5-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831062848.2743436-5-joseph.qi@linux.alibaba.com>

On Mon, Aug 31, 2026 at 02:28:48PM +0800, Joseph Qi wrote:
> ocfs2_validate_extent_block() does not validate h_suballoc_slot against
> the mounted filesystem's slot range.  Since extent blocks are allocated
> from a per-slot suballocator at runtime, their suballoc slot must be
> within range.
> 
> Otherwise a corrupted image can carry an out-of-range slot.  When the
> extent block is freed, ocfs2_cache_extent_block_free() caches it and
> ocfs2_free_cached_blocks() later passes the unvalidated slot to
> ocfs2_get_system_file_inode(), so get_local_system_inode() will either
> hit BUG_ON(slot == OCFS2_INVALID_SLOT) or compute an out-of-bounds
> index into the local_system_inodes array.
> 
> Reject out-of-range suballoc slots during validation.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/alloc.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index be09e766ac1f..2abd242a438f 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -925,6 +925,20 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * Extent blocks are allocated from a per-slot suballocator, so the
> +	 * slot must be in range.  Otherwise freeing the block passes it to
> +	 * get_local_system_inode(), which hits BUG_ON() for
> +	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
> +	 */
> +	if ((u32)le16_to_cpu(eb->h_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
> +		rc = ocfs2_error(sb,
> +				 "Extent block #%llu has an invalid h_suballoc_slot of %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(eb->h_suballoc_slot));
> +		goto bail;
> +	}
> +
>  	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
>  		rc = ocfs2_error(sb,
>  				 "Extent block #%llu has invalid l_count %u (expected %u)\n",
> -- 
> 2.39.3
> 

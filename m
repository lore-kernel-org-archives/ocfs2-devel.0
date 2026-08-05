Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E3F3DFC74
	for <ocfs2-devel@lists.linux.dev>; Wed,  5 Aug 2026 07:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785915497; cv=none; b=Yx+M9dMh03+MFdadp8c7uCNWp5SbcF7eOlFWBcQkL1vQiT8X/PJt5c+izt154fk1iCRLk9A+xmfUvbWIgH9yaTKaQe0t971ImKE5pTixTGOlPaSkTvkIChnIF5p7F0maChUBCJElpaX4jrYxZTbG+fGXIorCkfwSGnz4Y6w6rAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785915497; c=relaxed/simple;
	bh=XI4hTAnrlqQ1zIjV9q/lYkTlrEMba7KvOf/Kq4845i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7YYWXB+OFfMc6+BEHnetUnMFHOZ2452GaBDxQcKA4KoFxCABcKWL+i1nDlDWeBbTKE9x/4fN98F033sw87KIMtuH8t0My18TAy3BqVbT0UIBk3iQeprjl1b1ycGBbIv8KoXt1LgnEZoNwUyPV0D7oqtDOieq4Epo35e3Z2YKSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XHx3ROJQ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XHx3ROJQ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4994d41ceb9so446335e9.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 00:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785915494; x=1786520294; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pryAcCweidUP055MOdKbB8yhGrbTMfIHwq/HAZxy2+E=;
        b=XHx3ROJQ4dKwCSTIKiu/FRiOfjMC3ahRMWfyY896Bj5/AeQIkoHX4IlLYJ1oKAVb0x
         BZWIV7BSblMangAk7gS86qclimD9xovntHJ+hD8kVRNwSvlEF0QKp/tKlNw31GmZyHH5
         TaMfadG9hX/fLsfbff7cZFGxPVqYHFQaeKpdGdFBkRl2tpuNNRvF2V/PCBg0K6c/4TCo
         ifzr2HcOX4cNvMRrH4fdoxdJw8spDqCLZnoYM6k4RLdTVz9sYvvhuRjNdFQHbfTXZHQF
         vliJv9wD11Hx7ku50mxBTYq5/r3fjUMFasI1TazfPaLyKW6aJ+fc+xonARkOCEE2nMXg
         P7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785915494; x=1786520294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pryAcCweidUP055MOdKbB8yhGrbTMfIHwq/HAZxy2+E=;
        b=Lr/hkaezI9YAa9w1f2GBULBpjxYciNq51DmWyZV8qcozp626RhyTfS04x3yFJSzb01
         NCwn5C+9Hz7AWdCaOPzEl+H1Fw6KGkez7fKTMWuEFMa7hd8+d/Vz/uaWNJzFWEUxs8wF
         LX6RbqYrXHYG0DBNDu9l+ASUlGfF3J9zWiVj5OZZNFXZpTDyJezuaWf3tQp09gCp7h89
         eJ2IQMfkNrhnYtD1M9LIDp1mY2f402WPEPwoN8EX9Dm79y9+OeyT6TZIxr/0GyZSDM59
         tIL2HN57HTeY7YoWpDyfLjmb9I8Ipvt00i9pf5xVJ01AT7bxwX8k7R/eLxRnArCEytFZ
         xYgw==
X-Gm-Message-State: AOJu0Yxu1mRitEbxo300PhYnwQeBKzuxRDRz6Aim1dJFTA87wXOTkn82
	GzInf8ZqOGpMS66SKHCQwNYTLd5asUz0gaO7cX/ap9eN0gBBXv8boC2DEbePZsrBZt/NkLgM2fR
	JgF47cqFQPQ==
X-Gm-Gg: AR+sD13WX2n/StC5Mk6HRaRYVJy0E9fkyIXjRNPDTX6jCdN3OhZ4Mgm4r4dq2fH8uFW
	uMXVt0otE+kNxOXLhGW48xNxm16oddVIk1IuW+GKs0cfV3B93AjgTrJUXOEguGnEmp0j1iVt2ES
	aDJwJLBE/WArEOsU3bg8OG0dudmBi5oXJoVcE1PV0AzcBz/oCav86YU+2qOucFcYmiqRtU0Kqt2
	R3+/Quh3+JXs/Pd7h10xR6tdLLLiiZgIoLm/nVrCsaoPtwuyjmTf2Tn4vmzQMeuxl4RvjcT57/9
	iB1/ijtkDhPtyuIW19bkGbGfKXxRvAWUpr5ZcV4xuHifxuyFoXeThR+DFIu2DYeXc894UrY+5fj
	U1MFWgRXL6Ayhmwtlx+mH2rXyhJ2ATbGoK6ogt5whr7uWH7/6sIGn4D2cm0uePbNPa3tiEVfyPh
	4zdSRe3572YaZ/nbHoQZ7P4tzZCt80UMoLrBmWuqTm9iNIDU6v/7tk/D7a5TE6DZZud5UCzHU=
X-Received: by 2002:a05:600c:1c22:b0:495:71ff:598d with SMTP id 5b1f17b1804b1-4994edf895dmr18352885e9.1.1785915494092;
        Wed, 05 Aug 2026 00:38:14 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe709094fasm892080a12.27.2026.08.05.00.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 00:38:13 -0700 (PDT)
Date: Wed, 5 Aug 2026 15:38:05 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, glass.su@suse.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix cached cluster count after suballocator
 reclaim
Message-ID: <anLkDGTDDzVDMijK@p15>
References: <20260805070837.3390148-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805070837.3390148-1-matthias.goergens@gmail.com>

Hello Matthias,

Could you share your test case, I want to reproduce the issue and verify the
fix.

Thanks,
Heming
On Wed, Aug 05, 2026 at 03:08:37PM +0800, Matthias Goergens wrote:
> When reclaiming a suballocator block group, first reduce the on-disk
> cluster count by cl_cpg.  The current code then subtracts that new count
> from the old cached count.
> 
> For an allocator with N groups, that leaves the cache at
> 
>     N * cl_cpg - (N - 1) * cl_cpg = cl_cpg
> 
> regardless of N.  This happens to be correct when reclaiming from two
> groups, but undercounts the clusters from three groups onwards.  The
> incorrect cache value is also used immediately to update i_blocks.
> 
> Assign the updated on-disk count to the cache, matching the allocation and
> inode refresh paths.
> 
> In a QEMU test using a clean 256 MiB OCFS2 image and a 10,000-file
> create/delete workload, the first buggy reclaim left the on-disk and cached
> counts at 2048 and 512 clusters respectively; later reclaims underflowed
> the cache.  With this change, the cache matched the on-disk count across
> all four reclaims: 2048, 1536, 1024, and 512 clusters.
> 
> Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
>  fs/ocfs2/suballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index a4a2b87a45fe3..20c3aec6b9873 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -2759,7 +2759,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
>  	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
>  
>  	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
> -	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
> +	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
>  	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
>  					     le32_to_cpu(fe->i_clusters)));
>  	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
> -- 
> 2.55.0
> 

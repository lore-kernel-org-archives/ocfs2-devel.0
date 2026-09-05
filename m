Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A689E37F338
	for <ocfs2-devel@lists.linux.dev>; Sat,  5 Sep 2026 01:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788570974; cv=none; b=uCQeC/LQsJkZoSD/SkMDD8J/SE9cSe+iN6aXGIggCeI1wuAAPmy6lnQKorN38mrBXhxjnZfc1rRrFTlTa3X1wF9Wig0RqT2S+efevGMvawtWB3TNSga79kGzo2Ama+Wp5RZg311QwytYRGji71pAMOrf8TK2f4T7/NV2tmWjDxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788570974; c=relaxed/simple;
	bh=44o5L83IczclB7yfnMXyiOpfAS6soUBWv6nwnzN+OQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qn4YfO2e7BmxUtoz116CO4zwP6UUQ1FDeWIN+DKafd2kiogZEs6ky99kg/Rs8jDW+f4GAdQiVcmPIDyA7jVckjGmzea9B5MePWDbSNat7H8dXrG2pRixIO3Roe0Iyk0vE/dyLZ4mzkVLmg7MP3nF5PisDvl/2DoVWCUJNliHJ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yajgt/6v; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yajgt/6v"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b0dd3e1d0so274575e9.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 04 Sep 2026 18:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788570971; x=1789175771; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jn7XKIWs6Fs0qmRNaN3GYeUgeHyycuW+XViXWerqMTE=;
        b=Yajgt/6vVA5M37pUexwnnZSuKgylki41XB70kPnu8IJyV669waK/SN09iVq2g6a2r4
         HyBM+AU9VmuUkqTQBZB/kz35EImKddMVNup3pGXhqmX9EnabLtrgSqMjw/GJQJXErQ7x
         rypWhXZdafCPotlN1aBg0CpdtNx5kMIOsG3XTke+vIcOIVHb/5Dc2J8mnqBgvFTqPCtF
         ZQ386EE89ohAxI1A/poHkVSkEcJleOVpUXDsuhWYUO5k0+Q/7SQnU2AZ0PLgHTHgf3lp
         9IxigX6tNCjjAdbymqy+619DTYG8DLHLymf9RB38c0//TjDndTCMv4F+8qQOg+CuCOT3
         Pb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788570971; x=1789175771;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jn7XKIWs6Fs0qmRNaN3GYeUgeHyycuW+XViXWerqMTE=;
        b=DchxbL+Pp7gqB/YPYbZbWy1j4L+VSw6XuRUcUfAFDHEK422RFmBvYNUB9AQBcsSb6v
         gikG+6RKZMx8BG1KEYXuuPc+uXsD4WE3e+tUldYb+n3a9YhKRES3MNzxg6tCFW9N0ujc
         iqvkGU4n8o6qT1VZt0kILNNDYnw3EVYkZtW4J4fr+MLKDofWt0EzcB5fD/CtAZSho/mx
         joLgfOBPTe1tISx1cX6KftbJQoTdEptsc1fqVXupUqrNJ1AbQvVpQCl06y2Q/JFi5ArN
         y0IhexS6z9BJiqHQDvZh14dtZBthpvstWRQfdYSbR32yioj+tTSaMeyEOrwzaXH3f2FF
         m0Gw==
X-Forwarded-Encrypted: i=1; AKwUvByll0Ypd9mxmt5pb80CLTgvKVqfU6az2c6uLuP47qj4KkXLxNliClwW3m7hoUDraLEJdWouHvrM/uxz3w==@lists.linux.dev
X-Gm-Message-State: AFuF++mRMrUgiIfOnPEtNX7tpae3EoB6RDMCRlONYnvIrwJPBkKW9V9I
	sd3O0sxl0x30d8CSK+LAW+I1Lthu7du/QXRwARB4unlw/rX5ZmjYAL5mFUvSZS5pJPc=
X-Gm-Gg: AYBFou2Gk4vUmaMeU5Rmr10RYQ/imoojeHNJatMpAZXF+06gnGHfVXyRbgeMvdGCcKA
	yiIoU8o0eWQnXSzd5bn2Vxj4sG9Qc2djXgqKW7zhsLZPVxMifGlce5V0163ZS58Meeb7xDfwpYj
	gN0Iz5Bd3s62pHqrART5eN6XL7la9glCzfHAKXjbhOgIqjAbgUOSxUFTIu7U3INdVECv1d+qVA7
	UgmCQ2CJlb0zE6D1C93rgO2i4ZCeQl/8ol/ahoPHBIOfOVeTt0jU7PaL+joYkzfcdBH3Zp8d2DK
	7P4r/uf79L0avjs3TA62uT9AovG75lMTFAnE7Zb9ZrxZ+mroTssE7a6qLzXqKHPzAsfgZGS9oPE
	TsrzRRHSbtPXOw/v53BA2hTK3TozzZkBbAvQV8YTV6rIWni/mFxL6RfBOwNuA7ODY/4Y0yN8w/Y
	14YaPvGAIKb3mJEBYUEzKAo2HzRJGqdhW0cm2WsfnYmoerz1q733DqvDpMWvk=
X-Received: by 2002:a05:600c:860b:b0:49c:f9b8:bae0 with SMTP id 5b1f17b1804b1-49d01dd6b62mr15477395e9.2.1788570970872;
        Fri, 04 Sep 2026 18:16:10 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2612ba2bsm6682976a91.14.2026.09.04.18.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 18:16:09 -0700 (PDT)
Date: Sat, 5 Sep 2026 09:16:06 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ocfs2: validate dr_fs_generation of dir index root blocks
Message-ID: <aptshupcOW_f6wma@p15>
References: <20260904111551.371150-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904111551.371150-1-joseph.qi@linux.alibaba.com>

On Fri, Sep 04, 2026 at 07:15:51PM +0800, Joseph Qi wrote:
> ocfs2_validate_dx_root() does not verify dr_fs_generation against the
> superblock generation, unlike the extent and xattr block validators
> which check h_fs_generation and xb_fs_generation respectively.  The
> field is documented as "Must match super block".
> 
> Without the check, a stale dir index root block left on the device from
> a previously formatted filesystem at the same physical block number can
> pass validation as long as its signature, dr_blkno and checksum match.
> Its index entries and suballocator information would then be used in
> the new filesystem context.
> 
> Reject dir index root blocks whose dr_fs_generation does not match the
> mounted filesystem, like the extent and xattr block validators do.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/dir.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 6bb6aa133f01..329680b46227 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -613,6 +613,14 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	if (le32_to_cpu(dx_root->dr_fs_generation) != OCFS2_SB(sb)->fs_generation) {
> +		ret = ocfs2_error(sb,
> +				  "Dir Index Root # %llu has an invalid dr_fs_generation of #%u\n",
> +				  (unsigned long long)bh->b_blocknr,
> +				  le32_to_cpu(dx_root->dr_fs_generation));
> +		goto bail;
> +	}
> +
>  	/*
>  	 * Dir index root blocks are allocated from a per-slot suballocator,
>  	 * so the slot must be in range.  Otherwise removing the index passes
> -- 
> 2.39.3
> 

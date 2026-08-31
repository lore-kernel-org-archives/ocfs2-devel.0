Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E3E48BD2B
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 14:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185074; cv=none; b=gTpKxKAaVLa61/paF/VDxvvyzqF5IMteE+VIzr85vs1UltN+ZaMTKM8SbH7zA7sbA1FJpswzfy+lZSKPVfr/Ow4ZM3XcNFIhdSXsoTVl/Ah9m4DuCh0u2nF5///CNDCLVBToS3XiQVpjxXpQt18BhxI89vV65p3ov0PuYjHVU9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185074; c=relaxed/simple;
	bh=bsO0Lz6NalUUi/xtQJR4DcUiPJ+Y3NID7uVGeE2DMH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txLiFThdyMv99IsHLUJ1qZqL99ZHSdQ9rTR39HhIhiOK2n0oKVg+4MG4CBj3aFby7rCpvsoLT70KVLo0j/nv3oRGJhMwJD75tHaZDCSO3Hmp2phm1FdGXYHizFhHX92gjGwGsqY6JriigubvuhBS7qSbRj5cAHm4eb0oEhq2bCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gvr4ec+F; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gvr4ec+F"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4957952e0f8so2367835e9.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 07:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788185070; x=1788789870; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n01oHYb01qW4w3RHhJYkHOqlZfqUwQaVGvitMYTsJNc=;
        b=gvr4ec+F7PfGu6azuf6+Y74KPecpJ9GI15107RTft05UISTt7D7m8W1My0UMOz4/fL
         WSz0It38ILK/jmhsJ/IcZtYnUlwX6X1utOS/ACYB7SCwMjwFUK5pm772MUmXgK99c7GL
         XMyJ4oqAnqHRkErf8m4A5scjjILDJW63cNJ1MSuhScwpalf6UDcLkRcT7/RRYQKGnPR1
         wj77KTlOdjV6tMRDzh5IUQ4dkNGbiG8n0Xp6pp5fMRGzvwn2n47XvnTU119T+oJqkUW2
         Flb7B4fiXdEoEstmHOeMuRu8gnG8vmHudp3iym7S9CxX9lULf8bPoHQZsuA4F+u8Dju2
         8gSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788185070; x=1788789870;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n01oHYb01qW4w3RHhJYkHOqlZfqUwQaVGvitMYTsJNc=;
        b=TmVQc/ZzC8MtoIBc1JI7LkOD52IZT7xPD89xshQqXmctuHHGiKbnFHctfhy4SGN3YT
         JPXzrMN6J10pdF6ynYxzPG22SjctBkT7BKPrR1aNAVi6PeoOQ1vZVgpbsgqXLxMaBX+o
         GkuGIP4Tda942ZCTe9zlN99jsIX1shNVJCO6npV3PwyJmDvSR55qTnkfDuARyYD+22XV
         Hgx6spDZoA89ksbTLHs1+xru1FBoHGDfca7qu40l95qvMJdvNh7VmCNy0Z1FElvEMuG8
         HxmEnNdaXeJVTYP9/lkO/eiCUHPKSbP9uegqm/YFOE4xqk4xCUECmL+jYCNipT+1nScx
         P9Fw==
X-Forwarded-Encrypted: i=1; AHgh+Roc2EoclhiwH9G6icfVwVKGVMwa/M6OnWaQatI8/RnGsl+Pjp34Gq9gTOBQpF3j4k3Y1t0fCajco/TjGA==@lists.linux.dev
X-Gm-Message-State: AFuF++lxxAO9NuZBEHhB7igOvrGo1W8yk9e7vIvGtZtwcTZUTgVNj94j
	TGpclR4bkWRpMidcvOaTwbukghVzYI2Qf2sbn2SSw4l0kHLiUf4Rg4FD8cVkf3F87/E=
X-Gm-Gg: AR+sD11WRBGaJtOTeFjlVM98dYSaWZXQCdxjMw1jERS46TFrtK7nChtJHKHxLsHtkTG
	CCwlhtzm6ArkqTeiAtyYFkI9PxM/rW+4baFfq8h/L7G0ZRFjo09XCobMmX58yB/5KNy4MGyJHYe
	fpflx2j9DDUPlSNuHoA0lkMR7qyT2scMA+nokERQIHDgyYRfnw/EuzrA52mygw7HpCfg4CTHwW2
	ZpJ50zqSCNCGy7wJTk0HevpqojoX8lxqrNyUD3j93qzWpw489aLR3uaLmHRSU3JCVA9VuzYvNC8
	U89fayQyVWMT9PcTE2lE5s1cFRJnkE7iyPeJT/TC0TofKMXqrKVVt4gTDt0k1jX6RM6Hxf77x83
	mGIaEMsyMrlD8fkPRdDt7PGNYoEmmJ+cnUfY6EEBK6IX0PBPwhcpTELCa+tWkROCG8RlJYLSCcL
	JVra3aO8Lwvr6cu+WQoAXzX8Gdgu/UwHZeCU5dersjtT4yWLL4hs/6mx06RAQ=
X-Received: by 2002:a05:600c:c0c2:b0:49c:cbf4:572b with SMTP id 5b1f17b1804b1-49ccbf4575cmr112530775e9.2.1788185068963;
        Mon, 31 Aug 2026 07:04:28 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda36a53sm17432747a91.3.2026.08.31.07.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 07:04:27 -0700 (PDT)
Date: Mon, 31 Aug 2026 22:04:25 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ocfs2: validate suballoc slot of xattr and dir index
 blocks
Message-ID: <apWJxbUk2gk5Kq9o@p15>
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
 <20260831062848.2743436-4-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831062848.2743436-4-joseph.qi@linux.alibaba.com>

On Mon, Aug 31, 2026 at 02:28:47PM +0800, Joseph Qi wrote:
> ocfs2_validate_xattr_block() and ocfs2_validate_dx_root() do not
> validate xb_suballoc_slot and dr_suballoc_slot against the mounted
> filesystem's slot range.  Since xattr blocks and dir index root blocks
> are allocated from a per-slot suballocator at runtime, their suballoc
> slots must be within range.
> 
> Otherwise a corrupted image can carry an out-of-range slot.  When the
> xattr block or dir index is removed, ocfs2_xattr_block_remove() or
> ocfs2_dx_dir_remove_index() passes the unvalidated slot to
> ocfs2_get_system_file_inode() and get_local_system_inode() will either
> hit BUG_ON(slot == OCFS2_INVALID_SLOT) or compute an out-of-bounds
> index into the local_system_inodes array.
> 
> Reject out-of-range suballoc slots during validation.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM, thanks for the contribution.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/dir.c   | 14 ++++++++++++++
>  fs/ocfs2/xattr.c | 13 +++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 0075e1624310..eb9850610ba3 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -605,6 +605,20 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * Dir index root blocks are allocated from a per-slot suballocator,
> +	 * so the slot must be in range.  Otherwise removing the index passes
> +	 * it to get_local_system_inode(), which hits BUG_ON() for
> +	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
> +	 */
> +	if ((u32)le16_to_cpu(dx_root->dr_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
> +		ret = ocfs2_error(sb,
> +				  "Dir Index Root # %llu has invalid dr_suballoc_slot %u\n",
> +				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
> +				  le16_to_cpu(dx_root->dr_suballoc_slot));
> +		goto bail;
> +	}
> +
>  	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
>  		struct ocfs2_extent_list *el = &dx_root->dr_list;
>  
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 0062cbeb1e8b..5acc8091d06f 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -517,6 +517,19 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
>  				   le32_to_cpu(xb->xb_fs_generation));
>  	}
>  
> +	/*
> +	 * Xattr blocks are allocated from a per-slot suballocator, so the
> +	 * slot must be in range.  Otherwise freeing the block passes it to
> +	 * get_local_system_inode(), which hits BUG_ON() for
> +	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
> +	 */
> +	if ((u32)le16_to_cpu(xb->xb_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
> +		return ocfs2_error(sb,
> +				   "Extended attribute block #%llu has an invalid xb_suballoc_slot of %u\n",
> +				   (unsigned long long)bh->b_blocknr,
> +				   le16_to_cpu(xb->xb_suballoc_slot));
> +	}
> +
>  	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
>  		size_t region_offset =
>  			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
> -- 
> 2.39.3
> 

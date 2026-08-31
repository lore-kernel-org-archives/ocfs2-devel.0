Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3534BAA1C
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185029; cv=none; b=eoNI35E2Hj/Kq20Uc1tsQOiokIdLfkqbRDEy8YghHOuQ8N2pWPZi+Jk0XK6NGYb9/lUEqJtmeUxkbvmxSgxHEHVZcAupf/UKDQ6sCNG31WT2B0HHa4O99kDbjF0sWFXg5SISbwVkuCHZnQIYW4DMnngtvF3aD5WPCHAu/ndGMY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185029; c=relaxed/simple;
	bh=tstv+r2paNW8AO7BDltcvGIkV9VrLmRskx/CX906V+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O21jvkcCQ+PwzSNd7LjC/0YGXCVDAQgxTULr7wjV6YoPbF81My9zbcxbP6n2fbXEZaUZ0EKaFB4lRcfHdsa66O15pZuwsfLrWd5cIM30qJ3f1XeoKgX5aTwhapxEgvMpm62cXkeApnqOZqbazisVW/OnHbOOVRwEUcoEwjXyNmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O2KNyM7c; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O2KNyM7c"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954c08a7c8so3388535e9.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 07:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788185025; x=1788789825; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D4pF9XPfC8+Fsp7YVqDDtQsmYtPC7Lz+HA1yR/JLKDM=;
        b=O2KNyM7c5CretnWE9CcAqLozg5pBo/dqifarwdAPtkaU9e1VLO4nYc1i793L/MyWoC
         RCNO6q7eZ4sCZV+WvUTibtTIxsoaFWua0OuO4g1/Co1M4FSfGwFr4dOEwAH02sh2QIcx
         Impsixm6VbUs/ffBjlMLi5HNnxxNP9GUY+d82vAbAIfobmZhdBThyEpRtOgxWS2X6n2q
         6Bn8kUbSnUADiH+guOd2Ys4QTiYMG21OdLWpARR39RzApTcr5MwL7/ZREvrNsZGNq+sT
         VYQu2hfuA3WIretfv1kNKZyQ78pLWXiA2iUkAYiUKveyw6VpZsmhy0ISLuNxl42zOirI
         TZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788185025; x=1788789825;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D4pF9XPfC8+Fsp7YVqDDtQsmYtPC7Lz+HA1yR/JLKDM=;
        b=UDy+Hrl/sd6Yq2sRAF+2fj2gP6CsZCpyfG5PRLYZARJ6ucB2YL1t7yhRHYsCQukHxN
         V0zrXCndCvQXC9gX7olpiJ6ca5P2uUKTZb0iJdzrfuyzNUr5FL/wlb/Qnvm+2Dd23abP
         8SmmUGxnKXHJEIw+wzwDpZn9CE3wrtGgvoJueuyz1O9n0OYw6ohB0DCgLbQBBSKWZp9b
         WDf8h/85wzDD9BHQR21SvE3lxGJM58DIKEhAkyNnpKXa6PxeTIp6ZZ5k0m3i0lIz6Kc4
         +4i2Px0H6XfGNhMLeRqkojgYwCB2kXSF7Z9theWu8VkKFM0bzWEu2yWkGTaEkw2x5m8q
         OxWA==
X-Forwarded-Encrypted: i=1; AHgh+RoBnneXXy/8pfP6s2YrAEQjPdwAEGQK2KvHSP94OzIHb8XFvZ5CGfgC9Sa8lPMGvlMImfb8neA3bhq6bQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lr8fxOpUZlkGwu0dBpaBevm9Re+1OKrZzlVxzbavW4UcNam/9G
	RqnNXz6dp7hGvf7f0WLuI8+erGfEEmW8ckubP6zf3d+zosTrb2a6BrkRR05Z/LBBeK9skgl9LoP
	mnBeY2q8=
X-Gm-Gg: AR+sD10VKxUoOrw8ToRT5bBJwE8H/RJaNVeYyRsVpcH5DgtUcmfWZLl1mVb6DYXYaug
	cQ5YmPH/PQQuGIZXXMnbgBYmVFfECHcnkb5d3WAWw6ibLMn4nreNpDKO19e4U5Ke7HArZFLWd2V
	U5HeJiMRBA4hjsHUn3uhUhGEa4dijUN0i4bv9CUoHgxZnk36vs40lOcx0a+RxHzO3kzkj+deGui
	UOVmWyPwqvHxLP3i4ysnVrQJQnqxLW2LBaRFvd44vPEMrFpBhu/d2oLuDCNVu/dlPpf2Q6NvwjD
	dCtw4irkRaVygOeIeCXrYQ2fFDpVJcIo9/+PGmRz8fPG1VO5GN+fqWVqZW+dDiNWL12bXqlynoW
	ymtPEZ4hx9+RcYwtaP5PDbu5Igjbu0G/G8zqlEJb9BaSgKiIM2ct5A5drkeI22u8dxes17IZyeI
	NMbCav80MlRjkIe7klDzWanbHjR/ecLVb/PDrqoKc+GIEV8EFfd/clMs/OCeNp
X-Received: by 2002:a05:600c:868f:b0:49b:9241:7ff0 with SMTP id 5b1f17b1804b1-49b924181aamr132881005e9.0.1788185025340;
        Mon, 31 Aug 2026 07:03:45 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a397c0a7sm3908762b3a.49.2026.08.31.07.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 07:03:44 -0700 (PDT)
Date: Mon, 31 Aug 2026 22:03:41 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ocfs2: validate suballoc bit during inode read
Message-ID: <apWJqcgBV5UPqJYM@p15>
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
 <20260831062848.2743436-3-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831062848.2743436-3-joseph.qi@linux.alibaba.com>

On Mon, Aug 31, 2026 at 02:28:46PM +0800, Joseph Qi wrote:
> i_suballoc_bit of a dinode is currently not validated at all.  A
> corrupted dinode can carry an abnormally large i_suballoc_bit, which
> bypasses ocfs2_validate_inode_block().  When the inode is deleted,
> ocfs2_remove_inode() calls ocfs2_free_dinode(), which passes the
> unvalidated bit to _ocfs2_free_suballoc_bits() and triggers
> BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)).
> 
> Since suballocator block group bitmaps are contained in a single
> block, a valid suballoc bit must be smaller than the number of bits
> per block.  Reject oversized i_suballoc_bit values during dinode
> validation.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/inode.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> index eda50f13ffb5..a982c99a9678 100644
> --- a/fs/ocfs2/inode.c
> +++ b/fs/ocfs2/inode.c
> @@ -1543,6 +1543,20 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> +	/*
> +	 * A suballocator block group bitmap is contained in a single block,
> +	 * so a valid suballoc bit can never exceed the number of bits per
> +	 * block.  Otherwise deleting the inode will pass the oversized bit
> +	 * to _ocfs2_free_suballoc_bits() via ocfs2_free_dinode() and trigger
> +	 * BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)).
> +	 */
> +	if (le16_to_cpu(di->i_suballoc_bit) >= sb->s_blocksize * 8) {
> +		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc bit %u\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(di->i_suballoc_bit));
> +		goto bail;
> +	}
> +
>  	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
>  	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
>  		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
> -- 
> 2.39.3
> 

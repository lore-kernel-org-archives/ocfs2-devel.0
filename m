Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC0534F483
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 15:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574044; cv=none; b=WpdMfqv+ZkcGwgVRXav8d0I1J3U5/0X3HXDm2Xu+rZMfXOVOOStrXKrx6PQGWzFRuNluVJzYx3Dr8RpsjB1fyntvVuTgbodNBJ51KUo2odcSZ5Lu9UPbxtzYYOwKDjs5c93Bb0zzSxq/yxQSVxhgvC+GFj/wZlrY/XlbGVe6MDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574044; c=relaxed/simple;
	bh=T0k1olEMtuYZS9GBOnYRA62HSqx3Gndx+11vyVJy2wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5AV5BRya8l48jCz0J9sDudLF3av/tjEi+3EZhPd/GZTeALY8HufTJZtcg4JdI50MJn6yPt7MKEQgdw5A63am4zvVFUUCE7dS9ByXwqD85+bIbMIuPzY2ujh/rrKqxKAU2aovrHc4Ct7iGL03mP4l26Ur/FqwUEkfnoFREc8a+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BYzzrvmt; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BYzzrvmt"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4830b67aa6bso6219215e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Apr 2026 08:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775574041; x=1776178841; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dFYIhcwPVA/l1kNdW1cqN5HcGRIMzXkvEdZn9TpPqUg=;
        b=BYzzrvmtwTUpTVd/Ek8ofVnv6klwGP+Or0j4HlxBRAJ8TUdWSTW+MVCZTy/fnkBPpG
         JMzp9MA7aFpV+o0/IWWQmYxebiFQyu29QCtE2z+JaeaM1rgQBqnJXt34gEfXPKJ94Vd1
         1qXKYFIrgHbyDo1aGn2HzxWRUn9rEv6Fffyp6WQxocuJkAYV+VzNN5/mYB93gpcI/0Uj
         fsiyb6QPEmcUw4vcxU14izEl0mUh73hfTT3OC5PJt7QVrv4mAiI2MenQpFXi2VHaL/pM
         QkpJUo9S/j1UxqcQEobj0VQ8kxY0vX+5iqe0mPzucq+YP2rXBka4VBeSNdP4f+RuAhrm
         QcFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775574041; x=1776178841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dFYIhcwPVA/l1kNdW1cqN5HcGRIMzXkvEdZn9TpPqUg=;
        b=b4Mj8m9lxhdicszrX6L/dL4u47Ok1NxjX45+QN2d29t6hb6Wc7KV2xFHHcc4R6j1dN
         jDqG/Qqzr5Rvxv08YHwBiZAzA0fXeJrh7xSPiX9wfYo7tsPpaQqYDV9hiolA8VGscak+
         GdJBFqxWemRdXpvoQN0hkYtpi4nMzS7Hgy0/HNcRYvRm8ksHZZPK7bj/ISFKkx7p7fOj
         2KW0r8mJ56KriSsYQrsMXIGNnVn+37nCGDPddoC9RhJcjx9xV8I5WhYImOGVd99ubC2j
         MffDAq+KlEA7J7sRv0U+G/D571RTXPPYvgfWwi8ve0VlLmoPV1F3TBa1xWC0F7knBvBx
         qsDw==
X-Forwarded-Encrypted: i=1; AJvYcCXE1Hcad4QmizL/RMctJkxiwn02xa1VtCjmTTSDCcJYoIebNfoIKzID2RN1M7U4Aj2DdSxdSX5v8aAP3g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxvT9UopANBwtshZiy7CMOvITUaR0/9eHJwY8dJGIDuUwMHBGEy
	USpfSAFvdm4wpCyuhALK7GUwBz+zcKRENdP34s/7xazLALyDxQWkj0lanirmjIH8P6A=
X-Gm-Gg: AeBDiet4cX+5KdEPLrvhq1irp3/aeuXD3pZ0d+8g0t97Qja5dkmNUNIXYjHrTgdvKzr
	oDPoKfmxW+mIwDieWs/YN3if0vjLlVfr660p1QAQX3OegXS2DkUVGRvmyI9xSKe4drl/Db3dc7O
	gxecRWFeaLUNfhBnR5Pa17nHTERa82fW2FHbcO7OakxC/kfX0Vbxm8R2TkvVxmVEIEt8Vq2GrB1
	ZNHG+e7gz8N8WWuL7ckkX9DD5Dxmu/n7mnZyQtdiJ3hxwswiUm3iFtMzTN1mJikfjnxKRDut4vC
	hRCHMeNnWbylXqvVLrPDsSm4U094OdrCMdsXvZcKeTkwp+JwnJlgm9MECY3zeJr0ykHZONYs1k7
	ykidYvZw6RgDIm3wvo3orw5E5Mh9PfRF8uSXEkt74ejEnSmqIkp1zaOBH9DFRoZjIVA9ZSxEPns
	sDUNl6di4aADHGGOFxEBndJg==
X-Received: by 2002:a05:600c:3549:b0:485:3bc7:a224 with SMTP id 5b1f17b1804b1-488997d5b38mr111128925e9.6.1775574040925;
        Tue, 07 Apr 2026 08:00:40 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749794e8sm184759555ad.53.2026.04.07.08.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 08:00:39 -0700 (PDT)
Date: Tue, 7 Apr 2026 23:00:37 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ocfs2: validate extent block list fields during
 block read
Message-ID: <nv7f5mikcxti4p2lsgfjfmzebwponpsmfuwfjc42taxvzcxwgt@or6nssmvmstv>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
 <20260403090803.3860971-4-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403090803.3860971-4-joseph.qi@linux.alibaba.com>

On Fri, Apr 03, 2026 at 05:08:02PM +0800, Joseph Qi wrote:
> Add extent list validation to ocfs2_validate_extent_block() so that
> corrupted on-disk fields are caught early at block read time rather
> than during extent tree traversal.
> 
> Two checks are added:
> 
>   - l_count must equal the expected value from
>     ocfs2_extent_recs_per_eb(), catching blocks with a corrupted record
>     count before any array iteration.
> 
>   - l_next_free_rec must not exceed l_count, preventing out-of-bounds
>     access when iterating over extent records.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/alloc.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 344fd4d95fbc..8639806bcbb8 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -917,11 +917,32 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
>  		goto bail;
>  	}
>  
> -	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation)
> +	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
>  		rc = ocfs2_error(sb,
>  				 "Extent block #%llu has an invalid h_fs_generation of #%u\n",
>  				 (unsigned long long)bh->b_blocknr,
>  				 le32_to_cpu(eb->h_fs_generation));
> +		goto bail;
> +	}
> +
> +	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
> +		rc = ocfs2_error(sb,
> +				 "Extent block #%llu has invalid l_count %u (expected %u)\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(eb->h_list.l_count),
> +				 ocfs2_extent_recs_per_eb(sb));
> +		goto bail;
> +	}
> +
> +	if (le16_to_cpu(eb->h_list.l_next_free_rec) > le16_to_cpu(eb->h_list.l_count)) {
> +		rc = ocfs2_error(sb,
> +				 "Extent block #%llu has invalid l_next_free_rec %u (l_count %u)\n",
> +				 (unsigned long long)bh->b_blocknr,
> +				 le16_to_cpu(eb->h_list.l_next_free_rec),
> +				 le16_to_cpu(eb->h_list.l_count));
> +		goto bail;
> +	}
> +
>  bail:
>  	return rc;
>  }
> -- 
> 2.39.3
> 

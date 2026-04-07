Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0692C08AB
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573938; cv=none; b=JUj81sNnyWD8xr+Or39KZzXPFHMcyITIekBODs42O5LIaI64RHYlh4R2V6FAwHshSkrgbPFpmGwVf1YSbjCNzpyyMlLJSe7AHFyWbXP3Q83xMR3F5X7d097LRIeRy0uLD6MV08nXx+kw71+NJyB86vazfYPrpwuxr7dmyyTOI3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573938; c=relaxed/simple;
	bh=I3U4Rkz6xcjX1LaikQkQC8WzJfqaYkWi3iCoanNg5CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iknymczpm9gj8MuEBRL+EHQFwB6r288mFwOwAkZACzmC7uDHGFS1S1dOm8ajizy6+qDLwt6dQ0Bb/9sYY5UyCJEPcb5mYh2Pdl/CwtCORKdRakATaqvK8IxYcl4KLq25Fi+ntlAS8YM+X9lItnI/BZjxGoMXLwRCXipfep/fbtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NwN2MoZV; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NwN2MoZV"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4836fc075d2so6486525e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Apr 2026 07:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775573933; x=1776178733; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T6SFlJcGJUoTobrDq/Ifrg5q33AM9QXRjUl5zgkUQvc=;
        b=NwN2MoZVXYKqe0PzRoLdw72LavGrpw/OTjz8eHAP3OJOOKbfAzzX4LPRrHtxm0DpSc
         Xx2XUo5aiXej/yuTvFI3ETCUSw8Tvr4HisQCUBE/tdD/g+fZeQw+BFWFgMUX8wWlMT0I
         XsGCZrEkg60DQXYZsQAQyTwGMOAdnZyP/Tc2gUj5sml3VA6hHn0Clml0zazaOwPX5WGy
         DqcUfh20X0uazHBOSJV/cT09euwNxX+lMnN6f/uThAcn43Cv8kB99IKLtlSnjiFbUJg8
         x9Rrb+/v3RNzau4/sHa4oZE8AUX78FEBISBPE6UB6kz4A0DJyiAf+emAjId+Wp2mUzhT
         wDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775573933; x=1776178733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6SFlJcGJUoTobrDq/Ifrg5q33AM9QXRjUl5zgkUQvc=;
        b=OCLrSOZlo3HOPq1QtO3A/bpyueaPWHLQFnTB3SWk2YQ8N5xehSl8y7YniLOantI/0n
         YMWs1oeSruOGSiKOMAaTIayU+zDe+lhSXTbChG42yxRVHOGC+SimoQIMY0H7wi9vEcS0
         VZEHlOvv0zdvZUTsG9FZvDppSSLalihD/HrWH4jKC1JeezyUErrxfLNkRdyhT6KXaTuZ
         E4/sjAPipcsiaTedA3edDhX7rEaOCpM49ouv9TvJB6+enUfAFpSV24yUjW2A03Yy2dzE
         wzZyf2UlGBpxy6qvtuZvaL2adJh1XZgia9Xgv5JZwXhXjb/GsdwIzoabTrK3BO/mlU6F
         56Wg==
X-Forwarded-Encrypted: i=1; AJvYcCUPew6V5yb5m4rSW0IGMqfehf55Y3Ib8mLaPaABy1jWOZRixmR4Q7OYWN2YkNuk0LJqih98+PtMQe9qoA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyX1WcpvA6eY92dhCYO3DQg82T19DAxNS7FRyIRF+Eb+bkzk1e3
	t3QtLUTZ+7Y1xxfwvIrRflI2mlhwRq14Oucl5UuiQzcRK7uc7iUANLFlp9bxtiSHoL4=
X-Gm-Gg: AeBDiesBXr+/BD8xc1tBfaAe95PTrCGJi2T0A9tuhAomPvE5JdyfNHiOa542Sd/3aJg
	21aZ93uk6m4i0mE6g5jXtQ4EUnMuSZrnlN6v9z9GqYDMBuLY0HSe8Zz0t/O9+prwC04O1v0B47H
	z3xiV7Jz6i7Ho6/iTGIlCFydsz8/VFIgFCBBI0zyj9RZH4dDPB60a7Yf8WuMXmvraq6vOPqFzZU
	k1jwJ77n1FtegFzpDtYiTSdgmGT0uvt0lZvbTjI2NYrEKoSTQmHvLvcP0GBFvcocJBZyy7OciE/
	SWONJGj1KuOSvOQKexuq8N15FaZ7AWb/tkHJnXcKNMAXgvBNqUwx+YtQl/vSinwmWPXN2DCwV9t
	3IR5lHXH+HdZjQ0rQKDIJbnJmL2dAbZWBI8PUqIwd+8ps2QWxxgn1caE+W71ooBmMHXXbA9vOCp
	HT4mEBifzabqCC84XDxnuakQ==
X-Received: by 2002:a05:600c:a43:b0:488:9e7e:e1e3 with SMTP id 5b1f17b1804b1-4889e7eefaamr116783585e9.2.1775573932756;
        Tue, 07 Apr 2026 07:58:52 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c65991a8sm16913153a12.28.2026.04.07.07.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:58:51 -0700 (PDT)
Date: Tue, 7 Apr 2026 22:58:48 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ocfs2: validate dx_root extent list fields during
 block read
Message-ID: <7xxyxgd6lomzalhigpp255b25rvpewf2dhwqvt4yr65mshunjn@sbxp4juiw6qp>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
 <20260403090803.3860971-2-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403090803.3860971-2-joseph.qi@linux.alibaba.com>

On Fri, Apr 03, 2026 at 05:08:00PM +0800, Joseph Qi wrote:
> Move the extent list l_count validation from ocfs2_dx_dir_lookup_rec()
> into ocfs2_validate_dx_root(), so that corrupted on-disk fields are
> caught early at block read time rather than during directory lookups.
> 
> Additionally, add a l_next_free_rec <= l_count check to prevent
> out-of-bounds access when iterating over extent records.
> 
> Both checks are skipped for inline dx roots (OCFS2_DX_FLAG_INLINE),
> which use dr_entries instead of dr_list.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/dir.c | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 1c8abf2c592c..82e720c8ba32 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -593,7 +593,7 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
>  		mlog(ML_ERROR,
>  		     "Checksum failed for dir index root block %llu\n",
>  		     (unsigned long long)bh->b_blocknr);
> -		return ret;
> +		goto bail;
>  	}
>  
>  	if (!OCFS2_IS_VALID_DX_ROOT(dx_root)) {
> @@ -601,8 +601,32 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
>  				  "Dir Index Root # %llu has bad signature %.*s\n",
>  				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
>  				  7, dx_root->dr_signature);
> +		goto bail;
> +	}
> +
> +	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
> +		struct ocfs2_extent_list *el = &dx_root->dr_list;
> +
> +		if (le16_to_cpu(el->l_count) != ocfs2_extent_recs_per_dx_root(sb)) {
> +			ret = ocfs2_error(sb,
> +					  "Dir Index Root # %llu has invalid l_count %u (expected %u)\n",
> +					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
> +					  le16_to_cpu(el->l_count),
> +					  ocfs2_extent_recs_per_dx_root(sb));
> +			goto bail;
> +		}
> +
> +		if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
> +			ret = ocfs2_error(sb,
> +					  "Dir Index Root # %llu has invalid l_next_free_rec %u (l_count %u)\n",
> +					  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
> +					  le16_to_cpu(el->l_next_free_rec),
> +					  le16_to_cpu(el->l_count));
> +			goto bail;
> +		}
>  	}
>  
> +bail:
>  	return ret;
>  }
>  
> @@ -791,14 +815,6 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  	struct ocfs2_extent_block *eb;
>  	struct ocfs2_extent_rec *rec = NULL;
>  
> -	if (le16_to_cpu(el->l_count) !=
> -	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
> -		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has invalid extent list length %u\n",
> -				  inode->i_ino, le16_to_cpu(el->l_count));
> -		goto out;
> -	}
> -
>  	if (el->l_tree_depth) {
>  		ret = ocfs2_find_leaf(INODE_CACHE(inode), el, major_hash,
>  				      &eb_bh);
> -- 
> 2.39.3
> 

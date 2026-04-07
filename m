Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38560359703
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574078; cv=none; b=fmTfUa4Hiux//pjCPgVeqPgmsSr4neQwnrvwe60QTb8R0+ET7ObRUzAwkVQiNNYaNd5OR4VxoiMYxYgo7zJEwamHnCYAFY8h0LKrZ18SYnl0PqjpL69SfwoTy6Fmc6LKmLB4OitgDo7IfRFxNlj134M63T0Jgdy4YJqgSJ84bQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574078; c=relaxed/simple;
	bh=Q3X8EBa5eOlknXFYMLyiAN5rqm/iIt1r9mQUEAakAvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCdSKAQyGBG6ybiytiwuJbUgrbpIKezWQK8zSQ1Jfejb3HfcZ/eoddgrgOT+VUEwmagmmj/+/3pg7Bg39mUaVrx+BILN7345ifW/g/SXuMnripFaCRWXbhL1dMNZc/4DbhvIO0M1K8nI+kxeHpF9o0o5uqyHlJiZ1DjYUl0JANM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SU38ZATu; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SU38ZATu"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488965bc979so5758125e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Apr 2026 08:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775574076; x=1776178876; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnQJe/2Qqzku4LCZB7LeYUwE6AbjRd/7m6cjwdw/Ryw=;
        b=SU38ZATu4rmQnVUOP64MenCJHLEDlSXgTuUwSRCkgMHWVYM3VfpM7DRO/EhmxjBuy9
         Eh4Q2LSuVvFbS1/04D0NLba8V04D8ikbFgAlNJq8GhhI/K1jprAsriFUmv8zYHJbaWBN
         J9RD3bfsXXZJDHoD2hCJatGoXP07bhysV9PmdIoWsXRazby0TZ1WnYnNmsO4Iom7/ttE
         ov7oeApaqEBRhn2NOsE9RQpUaOnQdotzvZhvkqu/rT6DPwKU/8oBvRA5mt8AYFIL4i4M
         RX4IuIZznaEhm/IyUppO1U+r3BQLCkHS0fzlEh5O+VVolq5agFePO2qJBu1R0DyzQae+
         HJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775574076; x=1776178876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnQJe/2Qqzku4LCZB7LeYUwE6AbjRd/7m6cjwdw/Ryw=;
        b=AzfIuqYkdkkXebVB+ElKCjzU5vZ91T8ar03NJ1lqdk+6WxrBbUeD5DQ19g6yhH23Jc
         IA6omga+TR3WNiQeQSiSZBYJiDhTTAutQcc9b5sl0DggEVPRshgMmDb0vS7bJFH/j+OE
         I6XwtO1Ftii9yTrpI2YTW83txz7oYCs7wn4PeCGGacqQLPtJkkQCSpitbFSHyC9tWQbp
         Cnmpfjh6WO3W3ps3qpgCIRJLFSlZBGEpRtBOWUq110sCQ+3hI8iHPOeSOqz4V34hc9EZ
         cp4X5rfmImJ13SAvitRTXMoQnLGnEent/nutsMiBvDYXJrAUWfTkHAUPtnlUmmrikp2H
         6eDw==
X-Forwarded-Encrypted: i=1; AJvYcCV+766HiZPril3FD+Z+I/rDbMPaK6E0jTrm40VYepILccPAOKlfsau0JOgM6wHwm1cHELmGQ0OhBoEv0Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzjY7N6YQGEXc84350s01LBKly/GxDLJB3yp6MAT5uf2jN0CJ4w
	k5SASDm5YxVTEpBZ23EqudpVJOnhUX+rew+AEQ3uSuDA7AzuyF2j2Ykgdmr3Pb3QVaZ/nKa5IM8
	2BJeZDQk=
X-Gm-Gg: AeBDieuAV7/q73TvX3hn24ZOUN73CqGFMlRHrzP+TOIePA5Kf1iRvQyG+lAK1+AnDAA
	WPhWxKLYauga1b+5VkbQcnRBbiTDL63QYtCK2zR9IeUULHv/YfOYVAy4hGtppa1xoBJKAoym7o0
	nn7nA8hQYP3YOKSO6pS/4Stdr0h8K+gKXKzMqBnPb2T8fKd3X00knk9kzxd/w0LmiWOu/0R6qwW
	93liZCW5cv8jSGVXKO0t6cfbCqhuSuupL5kDAz+xWVSPK1+nLlqRvlY7j0+0zjTqXSceznp1sMi
	ff94hLo4T+RqTMh7nn56jeq716ad6Qcn38FFMleWDm2udqfR987fHZROZ1vIIleXKUc5f2uNN8H
	2Az4OhqPQBKw9aA+o2HadrTdYIsUT+3xKXVAndcdeBNKDnJSRrzxZC0Pn7NSu4uvqEmxpXskxob
	iiXnjDhQmdbB3RF1Y5nOQ1Xg==
X-Received: by 2002:a05:600c:a43:b0:488:9e7e:e1e3 with SMTP id 5b1f17b1804b1-4889e7eefaamr116865675e9.2.1775574075479;
        Tue, 07 Apr 2026 08:01:15 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dd35fa93asm22322814a91.8.2026.04.07.08.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 08:01:13 -0700 (PDT)
Date: Tue, 7 Apr 2026 23:01:10 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ocfs2: remove redundant l_next_free_rec check in
 __ocfs2_find_path()
Message-ID: <ebg5txalbyfeelaquerctyxekvamwvd7ajycg674ig23f66pcx@arfhma2kojqm>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
 <20260403090803.3860971-5-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403090803.3860971-5-joseph.qi@linux.alibaba.com>

On Fri, Apr 03, 2026 at 05:08:03PM +0800, Joseph Qi wrote:
> The l_next_free_rec > l_count check after ocfs2_read_extent_block() in
> __ocfs2_find_path() is now redundant, as ocfs2_validate_extent_block()
> already performs this validation at block read time.
> 
> Remove the duplicate check to avoid maintaining the same validation in
> two places.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/alloc.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 8639806bcbb8..08e137928080 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -1878,18 +1878,6 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
>  		eb = (struct ocfs2_extent_block *) bh->b_data;
>  		el = &eb->h_list;
>  
> -		if (le16_to_cpu(el->l_next_free_rec) >
> -		    le16_to_cpu(el->l_count)) {
> -			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
> -				    "Owner %llu has bad count in extent list at block %llu (next free=%u, count=%u)\n",
> -				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
> -				    (unsigned long long)bh->b_blocknr,
> -				    le16_to_cpu(el->l_next_free_rec),
> -				    le16_to_cpu(el->l_count));
> -			ret = -EROFS;
> -			goto out;
> -		}
> -
>  		if (func)
>  			func(data, bh);
>  	}
> -- 
> 2.39.3
> 

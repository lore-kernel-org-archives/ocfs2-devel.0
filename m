Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6962F259C9C
	for <ocfs2-devel@lists.linux.dev>; Tue,  7 Apr 2026 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573972; cv=none; b=ss3dbqFEAeR3j/oWGwV0iufLnJuNAaOlDEC+j9jdojznrOEbXq9Aq6pmVGb9LDgqBxNZcPKsoh4rjvV2LQaA0+5nonv4LJbyYXfZAiD6QzSXaVLGRNNTx7IIBI6+AkgoCCuii2d2g0VDhU2a7/1UwzbLYR3stIcSbpYHhQ+sDpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573972; c=relaxed/simple;
	bh=/X84+yHVdHkyU33xHuaRlZsUgWwE5VdWB28sm24zV9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rtj7N4deV+c5W/ZcFWg00qnU0YLaCKi9BaUV2sVNWcA1whNzkt7iYGjIk6hhdK+eLyGr7nOctwyw+LNZwaxu4ooOVQuVANuiRNeHEJQBfdfCl2Jnhaj/ewlJrkbLOywo9FTHRXKquEGwqYwwqN6NKobXb7+9vZTcTgcfKyOo9p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KqW29e0r; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KqW29e0r"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488965bc979so5755295e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Apr 2026 07:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775573970; x=1776178770; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PRhC2WlJKz2CjZWrJ483l/aUZpwufOOpOooWNoXZ+zM=;
        b=KqW29e0rXIbR8PEFdSRdCKqL6uao9zbgPmHMiTzTHcBtMgAc1OpJMSHO1YjgvqFLlG
         TqmTIakf29hOH0H+TvdqB+SGObDo/yrP165LSm7wS59+qWoBJP/hsQp2TEl9jTEosv/V
         ieZRC3savwtZGTs/9NHmrEZqwYUiNC5Eff7s6wH+doZJAIpd2Lcte103QmWQpHErvamJ
         hspjsjLJ5DsQJy6Xxn5kyu+IbH84+nNnoy4MKtwwikHYoRL/zJ2kbzur/+SnH92wZq6q
         z960ywgFACDrgPasTAZptu3lfFphL+8ME/z5njep79pROzEoaBMMYyKcR9CZSnLYi0Ud
         bztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775573970; x=1776178770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PRhC2WlJKz2CjZWrJ483l/aUZpwufOOpOooWNoXZ+zM=;
        b=W73sZr2Eq3uhiN/gxCzOrfNxPv/7nH7GT7HvBKgmpWSbzjdzPtPqE1M9D1jWyo4Ame
         phc5l3E/MzYkMm8DVOuacqJbQ/X/+B2PrwxTc72mUh1TRfVs14enhkg8vmh7e2J/a0BI
         xW9oUQYYclBRbCS5N0ToHpClcIiNRACq8b4eg1yUVIsr3JdThlA629XmE7QXBtCfcxhx
         tIEnzmcIiXE+k4wOdZfs+ndQTuYGtzugvf7cuhQGMZfoaS6JSnsse/MhSpwZmgMJSr8U
         /NP4pqcqRVd21Fsmp67Ht7r8/9XDuV1x/6DmDdOvfNUORr8pXlgjM/oDFmFInZOHXjZm
         hqTw==
X-Forwarded-Encrypted: i=1; AJvYcCXb9op46r2HabNePnqwd9sUUeXb3Y6+m/zGAitLaME5mFPHN5LJpIxPcZModzfiYtcOvLPLfsRdgPz/Kg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5p18yUkoc9BKqQEyZGEN858bX0zgutHD+bQB+T9FPR6WzqN4M
	zvqEFEJQ6k5J8kGjoOHjlmgkOsfW1hAQOz3FidTxv+XEDleOxY1NU1tf1aSUz1GuD9+gu0eRI/L
	5HTIERGM=
X-Gm-Gg: AeBDiesNFooTGo32k1dGsVuBmKaAooXuxxUetat72KMzBJZBMR4HDRNQyZpqE+kbgCN
	ayFQu22kngUoR02NLKcGSE5BSwFXdJnLPlCPt0CCH9/aFNr0A9m4iI3cwVluphvFmBHNy0k78t3
	M5gSg+o2nfT7rr2m8CYm0hsgWrp8lKi4ZNLJBn1AvBA1v/h+7rixhZGXj67z7fECcot3YmZ4Wl9
	sZ8GTbZh93oHtqdgCqSMAd9algDqYReCrF5lPUkqSEDaQwhdsgyzVF0V4Smw+7EzvhBNLPa/mQU
	hU/SjZjY4KAwDBxNzxYV9xGsTAyqz04ZhUIIxsLfa8CP1O2ubmhbL/IcMZUMJo0Y3qCFvGD0pNZ
	GkFsOwO2JEQi4c5LuwpX5KYjutizbWhCuTK+v4yrswr1N/sYU4FZI6Wl+ELJNzVQflo3RPvWBok
	XH9ElvoRIoyIt3fiLI32cv4A==
X-Received: by 2002:a05:600c:34d5:b0:488:afb4:b98c with SMTP id 5b1f17b1804b1-488afb4bab3mr67213815e9.3.1775573969802;
        Tue, 07 Apr 2026 07:59:29 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9ca1f28sm18489527b3a.57.2026.04.07.07.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:59:28 -0700 (PDT)
Date: Tue, 7 Apr 2026 22:59:26 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	ZhengYuan Huang <gality369@gmail.com>, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ocfs2: remove empty extent list check in
 ocfs2_dx_dir_lookup_rec()
Message-ID: <4x7tuyncmpm36ebkp7hccw47fxwhdqgtxwu2lulvcy7cjyt25r@knp63pjqsg6n>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
 <20260403090803.3860971-3-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403090803.3860971-3-joseph.qi@linux.alibaba.com>

On Fri, Apr 03, 2026 at 05:08:01PM +0800, Joseph Qi wrote:
> The full extent list check is introduced by commit 44acc46d182f, which
> is to avoid NULL pointer dereference if a dirent is not found.
> 
> Reworking the error message to not reference rec. Instead, report
> major_hash being looked up and l_next_free_rec, which naturally covers
> both failure cases (empty extent list and no matching record) without
> needing a separate l_next_free_rec == 0 guard.
> 
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/dir.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 82e720c8ba32..d94595a49923 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -835,14 +835,6 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  		}
>  	}
>  
> -	if (le16_to_cpu(el->l_next_free_rec) == 0) {
> -		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has empty extent list at depth %u\n",
> -				  inode->i_ino,
> -				  le16_to_cpu(el->l_tree_depth));
> -		goto out;
> -	}
> -
>  	found = 0;
>  	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
>  		rec = &el->l_recs[i];
> @@ -855,10 +847,9 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
>  
>  	if (!found) {
>  		ret = ocfs2_error(inode->i_sb,
> -				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
> -				  inode->i_ino,
> -				  le32_to_cpu(rec->e_cpos),
> -				  ocfs2_rec_clusters(el, rec));
> +				  "Inode %lu has no extent record for hash %u in btree (next_free_rec %u)\n",
> +				  inode->i_ino, major_hash,
> +				  le16_to_cpu(el->l_next_free_rec));
>  		goto out;
>  	}
>  
> -- 
> 2.39.3
> 

Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E11B262FC0
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 03:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765509728; cv=none; b=l/SaGa5U5RBJ+IfqtB5rAzUqrw4MbxW0on5sakuFYEYztzPXqmMoFVXiUQhQh6sd1hkanV6MyWNu8JauhZ1n0c5ENvbTcgemA77xIff4Fq321MJl5+DWGpMoasVqACnKJjpU1ysHg2P4tUwQFuvmJnsOrBYyGpN7XYR82cXo7x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765509728; c=relaxed/simple;
	bh=okPn29NkxqPHEnqI/dp6yQKqmzeDW/BBjZua74aooBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uge/SEVbQMAf49CLp+d0V5CTwfkYqnc3i7S+UwV6iRnmzSdX+VT0RDl8VbhJaCWPvYAqKYmGz6h7kG4QfMsEH2cR3doj0h3E6rucJoIVWKNY0NK0quHCrBz1RhPME3IfkDeynYLJQvUIEZ0tIsfzawWAe6FJWT5nro54Zh0nuGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fqtOtN1p; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fqtOtN1p"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779ebfa91aso216805e9.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 19:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765509706; x=1766114506; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wOAo+brAgj4mzmQwcJBXt8+nZYg/SQ90RjYJCigZHJI=;
        b=fqtOtN1pS9k0VJbsK7oDHPJxHQ0vA9KQlLJuVpQ1OHE9GhSdv7gu6LGJXk4+w5ZUBm
         fOQ00NlWRYqWQFdDgwUvElPUI4rOm0pmTKGG+PHqip3Tq1XJiuQ6MYEJYg1w5FK+OMuJ
         Ogl6BCDPUED1IJZmzMY8pn/AjlNPdacaOYWnHvZzc5VBGzilqMKQ7JM+k2OIldJ8ELCH
         zVUvDGL5noexcd5IRhiZjedZZUmSIgf83EQvmuehv378JOtdJOIrH1ZqwrXejq/e0dGi
         k0ogfd1Wp/gC9T6VtcuxHvxK1mUp5Y8AY41nAQN14kW4FBxHw80y5E9MhloCdRBeIly3
         coAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765509706; x=1766114506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wOAo+brAgj4mzmQwcJBXt8+nZYg/SQ90RjYJCigZHJI=;
        b=csdeRmHvmriBV0AcmvlaON7LLRafpuJ2155+yes5rRLNiI0jqJ0KlGquLiAxztjLy1
         /WdyNvFFmL+S+CePpKrnTqzlatFqgCJp8PnZQva4NTMwZBl+aZAqF/oENIZab+pukIM0
         QrMEPelO9p4nCFd5YHiuGsn5e1HLWFJHQNR/0Um+egLxnG7zcwPrcTVpMorideJbokc5
         TrDWthyWwlzC6s4U9jjJESupqAjxHfTZIiAsylAuyb78wkg4Q6rNSs5AjBO+bWRDsTzZ
         xO8Ej4dMWgQRinvKHpvCJr4jxeDmoYv3VAZT6jbk8Sklb6rzDWMsBv+ct41qtF30XHGf
         HwQw==
X-Forwarded-Encrypted: i=1; AJvYcCURHxPZ2Mea3LxSFRpxIp4/klhXDexI106U0yqM8bIwFN4DbYF8zVVjxx+rV+cZRQDCJudw3ige+tfctg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7WSU9PH12SCiQP4dBsptl4L0aqOder8ybzRR2V8nnSGBBXHhr
	FSgLfh9murxYb3oa+bUgGjHOBgGHzC7vs/fGaR4BAfgYPdx8bCxjdXctWTn1JB0TX2U=
X-Gm-Gg: AY/fxX6h2nQ1q+JYTGYzmDxucD+wgYp7eG3DRqsnDwC44Xp0aYpCLvFHNGvgpr6SOfS
	gBPHciUG1b7RB5uSQz+mojnCPB7kUULkhKdegGtoqUoNNc7NxBKLzm37WxZB/9UGbb2ovpKlkox
	J18XYh39kHG91JC4ptE6htFlJpxvcu+iyjYy17ZcESWa71MRlDuWU2hpR+xSjvpkOU5idDOn96p
	KB2nZ6or3X6cDu9jZ1efT0AaXtWaQ0qqanPEG1xG3PTb0UsD0sg0txYuqO3agJvGEb23Opcp29b
	rWiLWRvm1rHzYlnIpSInuRzjHjd6igP+BTN0TlDlrwQlR/DGpsQR5EDETfDb2TV2OJ0/ybNdHVV
	Dc4b9+AvMe6fRIEG1Bj6G0olFrtpbb5Pk2QcqKep9o7aZQa6sokBCzXK+Vw1cQfnmlRbsHb+y/y
	/j5EWYLK4jghUFe/Lk2GTG
X-Google-Smtp-Source: AGHT+IG2hNr9Qy+4HgeMoaKz6d+AG/HLrLLSFUFDrYC09OVFigawiZ+ZDCYSak4kmb27/7hyBom6jw==
X-Received: by 2002:a05:600c:3495:b0:477:5b01:7d49 with SMTP id 5b1f17b1804b1-47a8f903087mr2589045e9.4.1765509706220;
        Thu, 11 Dec 2025 19:21:46 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe129a87sm389154a91.0.2025.12.11.19.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 19:21:45 -0800 (PST)
Date: Fri, 12 Dec 2025 11:21:42 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Deepanshu Kartikey <kartikey406@gmail.com>, 
	ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org, 
	syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN
 boundary checks
Message-ID: <4ttnx34q3ispjgdeoezr4tuxbuezs6qhzpocidc6sdbrf6feeh@i65rsj2nv5tb>
References: <lhnx6meceuvndkxjpxaapwkiqvlp6recho77b4yjirznjn62jr@fu5gq2gsg2yu>
 <20251211155949.774485-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211155949.774485-1-dmantipov@yandex.ru>

On Thu, Dec 11, 2025 at 06:59:49PM +0300, Dmitry Antipov wrote:
> After introducing 2f26f58df041 ("ocfs2: annotate flexible array members
> with __counted_by_le()"), syzbot has reported the following issue:
> 
> UBSAN: array-index-out-of-bounds in fs/ocfs2/xattr.c:1955:3
> index 2 is out of range for type 'struct ocfs2_xattr_entry[]
> __counted_by(xh_count)' (aka 'struct ocfs2_xattr_entry[]')
> ...
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
>  __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
>  ocfs2_xa_remove_entry+0x36d/0x3e0 fs/ocfs2/xattr.c:1955
>  ...
> 
> To address this issue, 'xh_entries[]' member removal should be performed
> before actually changing 'xh_count', thus making sure that all array
> accesses matches the boundary checks performed by UBSAN.
> 
> Reported-by: syzbot+cf96bc82a588a27346a8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=cf96bc82a588a27346a8
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>

> ---
> v2: adjust commit metadata per Heming's notices
> ---
>  fs/ocfs2/xattr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index dc1761e84814..de99276d12f0 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -1941,8 +1941,7 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>  	ocfs2_xa_wipe_namevalue(loc);
>  	loc->xl_entry = NULL;
>  
> -	le16_add_cpu(&xh->xh_count, -1);
> -	count = le16_to_cpu(xh->xh_count);
> +	count = le16_to_cpu(xh->xh_count) - 1;
>  
>  	/*
>  	 * Only zero out the entry if there are more remaining.  This is
> @@ -1957,6 +1956,8 @@ static void ocfs2_xa_remove_entry(struct ocfs2_xa_loc *loc)
>  		memset(&xh->xh_entries[count], 0,
>  		       sizeof(struct ocfs2_xattr_entry));
>  	}
> +
> +	xh->xh_count = cpu_to_le16(count);
>  }
>  
>  /*
> -- 
> 2.52.0
> 

Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7901E0DD8
	for <ocfs2-devel@lists.linux.dev>; Tue, 25 Nov 2025 02:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764039521; cv=none; b=HbcnROlLbNc5lchmQFozTJkxvKRibBqhgHADWDkZIM3KieXk0DUcDfc03KyYlxVomTebamyscjua9wVk1kkXOtEZ3216QMTTvaS067d2GZCaAeeTxK8FnvJPs4L85/3RGfnIGasv7P1PqJX0KJTE0mT4VnotKlJVmllgiZtTHlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764039521; c=relaxed/simple;
	bh=QABqSJ4HWCjEylKLo95wVGGAwYdB/KR7lzvhLo7b5Y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/DHGWfXB6L6FTFyS5dbDcfV3vKE+VksaXVOav8hNgxRzC68Xog7ZF5UmzgpUHJqG/dIAltetKivcKwj4s4v8WjKc01I2HtWvSaucBwI1v129P9Yh64PYXzNx6khENNh7cPca9ugQTWcZCzKb2b2zw6KAbip0nUemIYqF+z0kFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XUfnMtbV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XUfnMtbV"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b54f690b0so454906f8f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 24 Nov 2025 18:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764039516; x=1764644316; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d/Pzf9UYa5PwIhf94ONdrKuS0DUy2kpf16Ikmd9F/qw=;
        b=XUfnMtbVGZrzoHid6AR/aLyiaM+q2k+0s2y+ymJ+gZ0v38iwBQF0InOE6F1QxAWUgP
         9Wy7dtPcPaMGjJbnCUAtbc/Uufl+41omUPTsWmmUwvhSQWbtceUpHXMKBO/kx2r+tgQ/
         WvtGMB8jKDD+IBGnwaYAsazzdnbMEkxpxBBpdqc9+3Em+y1Ni1R1v/gEFoGxF0rkc/p6
         c0RwQdt5V7Dt+fAPkoaE+0DzZbIJ/HPrpWrEXcRW+/H+h1LVdigJV6k/TdevjoM+Ya4k
         cdTyLXm+Hs1S3eNslQiBci+xBiVCCB837uySDSmw0oWUMGKoJ9QpQUjszHyZWV/fUszB
         /Kkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764039516; x=1764644316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d/Pzf9UYa5PwIhf94ONdrKuS0DUy2kpf16Ikmd9F/qw=;
        b=jFvHMIZlMZG4D1VEcif4OBramXSi1ZiSy8HuxgMOLaS+SU6j+RPFG43CNLDKK5Eho9
         GA65GvxzsSpneT4iDU5dD8YBr4qFhvoH1sR/3kPXw2DhnNhQgyJAD50X4kXQ3dV7Xvfr
         HA0kzi7S/pW1qfulaSfX18xMveqblMOJpMPMDPb8ejmxG7Kdcbbqo3lIYQRpF+gooFSo
         wOKOBMDZg60IyeXGPVMC7+lGb5YF+sPGDjsLUlEoxftbfoSS51y+5DgMF2Jna8hDshxe
         4W29FyP646h8qle3WEPfRII+SMOWvlreAc5AafLV5zyRNEFsNKTay8gGpYdvxo4S20dW
         70gw==
X-Forwarded-Encrypted: i=1; AJvYcCV3W0fgFWsk8EDTxCXwmjLPO7sokqEuJMYXPykXiA1IyOvNUj/8WtjELCsU/b2/Ws7xdyHPYhBXztnCYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyahKxWuqDHJxHbm1Og+9W91sb03zVV1yugpB1tXvW+ZDwGvMiC
	qZXj8MMYjBE03OjiPqfildiAScgV9ixzNzNnHZ9M13yBtpliMSDgPJsISbigalQvvLI=
X-Gm-Gg: ASbGncvn6bDvshL5aSxVUXq700iluOJEjwSfmstrfmWGo7AB2FStwoJQb3eVw29iBWd
	FOE+uSEPxiwqIHkhM2v8T4yL+mtgyHy9pgG4ZxCaXPIRbWXvK+JqghtbJtl5Q+/xc/twFpi9HDa
	MUYnZ64XJS3xeUC1jjCiEVBJGPGMX0hrQn4nXqiamjEb8UjEMDW4ehDkbApDMxoNVpkqTytTnPI
	IwJ9JwnWYbFi9JA46U/ftZbQKKTLH2qfa8LzVQEpb2EY2YVGcwqMaVNeApgJXGxZiTJan+Q9U4V
	MIgMzmT7SBypZYL9fKwC1TQ9QpvLgM796in7nhAGcpzZD0su8PeOEiGEBSAR7KrZk0KaTlp8gIX
	WWRHUtmsyH9rYmanyxuslV7XMkTKXI1FIATmS2PE8xrS+mUpB8AYglsS6g03jUmf3dSS6MpRIiA
	TTV16hxRxzIw==
X-Google-Smtp-Source: AGHT+IG2zE2SetCC61F38vEtzD/sJKdYl/GsqIYeKdAvr6ONQJn7LR6fm5J2E0tHAZlUg0WuTiy37A==
X-Received: by 2002:a05:600c:46c3:b0:477:aed0:f402 with SMTP id 5b1f17b1804b1-477c020242cmr72232445e9.8.1764039516318;
        Mon, 24 Nov 2025 18:58:36 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f095ea28sm16091385b3a.47.2025.11.24.18.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 18:58:35 -0800 (PST)
Date: Tue, 25 Nov 2025 10:58:32 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH 1/2] ocfs2: Add ocfs2_emergency_state helper and apply to
 setattr
Message-ID: <ykvzskyxtwsy42lxxin6avihe6lbub75ywvn7e6zod6m45dpyy@6xkfaynjpuos>
References: <cover.1763337347.git.eraykrdg1@gmail.com>
 <f60d7b3669ee3bebc11895795bf1bc9c990fecea.1763337347.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f60d7b3669ee3bebc11895795bf1bc9c990fecea.1763337347.git.eraykrdg1@gmail.com>

On Tue, Nov 18, 2025 at 03:26:44AM +0300, Ahmet Eray Karadag wrote:
> To centralize error checking, follow the pattern of other filesystems
> like ext4 (which uses `ext4_emergency_state()`), and prepare for
> future enhancements, this patch introduces a new helper function:
> `ocfs2_emergency_state()`.
> 
> The purpose of this helper is to provide a single, unified location
> for checking all filesystem-level emergency conditions. In this
> initial implementation, the function only checks for the existing
> hard and soft read-only modes, returning -EROFS if either is set.
> 
> This provides a foundation where future checks (e.g., for fatal error
> states returning -EIO, or shutdown states) can be easily added in
> one place.
> 
> This patch also adds this new check to the beginning of
> `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> (which triggered the original BUG) fail-fast with -EROFS when the
> filesystem is already in a read-only state.
> 
> Suggested-by: Heming Zhao <heming.zhao@suse.com>
> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> ---
>  fs/ocfs2/file.c  | 6 ++++++
>  fs/ocfs2/ocfs2.h | 8 ++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 21d797ccccd0..03a98985ac92 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1137,6 +1137,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  					from_kgid(&init_user_ns, attr->ia_gid) : 0);
>  
>  	/* ensuring we don't even attempt to truncate a symlink */
> +	status = ocfs2_emergency_state(osb);
> +	if (status < 0) {
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +

I prefer the ext4_emerency_state() style, using "if (unlikely(status))" here.

>  	if (S_ISLNK(inode->i_mode))
>  		attr->ia_valid &= ~ATTR_SIZE;
>  
> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> index 6aaa94c554c1..2ac16632dd19 100644
> --- a/fs/ocfs2/ocfs2.h
> +++ b/fs/ocfs2/ocfs2.h
> @@ -680,6 +680,14 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
>  	return ret;
>  }
>  
> +static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
> +{
> +	if (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)) {
> +		return -EROFS;
> +	}
> +	return 0;
> +}
> +

calling ocfs2_is_[soft|hard]_readonly() is a little expensive because it
involves acquiring the spinlock osb->osb_lock twice. In my view, we could
introduce a new function, such as ocfs2_is_readonly():

```
static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
{
        int ret;

        spin_lock(&osb->osb_lock);
        ret = osb->osb_flags & (OCFS2_OSB_SOFT_RO | OCFS2_OSB_HARD_RO);
        spin_unlock(&osb->osb_lock);

        return ret
}
```

Thanks,
Heming

>  static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
>  {
>  	return (osb->s_feature_incompat &
> -- 
> 2.43.0
> 

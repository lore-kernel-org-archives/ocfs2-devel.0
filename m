Received: from mail-ej2-f13.google.com (mail-ej2-f13.google.com [74.125.228.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33B244A406
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 07:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543805; cv=none; b=IfqMd8YvoBBd3L/ctgKUlo5EgTE+BUqsXU8RtWuajUz/wQRH8HASYoxjM5vaTZaPmvYeWzZE3NkTtlK6LnSwUxyKv0GDdhdHuEmK2TXX8nJHuUuiYrufZtRHy614JylKAsT3SNTJn1J3bXBe5mnh+qVbwwuh1fV0OkSG5cFHq3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543805; c=relaxed/simple;
	bh=bmmtTqNINt0Ys7otl8qQIKrpJEF4Ec2i5M8l0wtuXWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BF7CCgRbol7ULaI/UFIP9EkmTH3iUt8siaec8jXjACOBq5+cJAlAduT0Vs/+APS/QxSd02ruONzhYhiaFQ7mORJN0tQxmgulwYyzOJIi9YFvY5weU/zvDS9+Lxc8/pz4tLJKcH8hoABA0/8mcSOdsvlWo8rAOaGLWcqfGk0Yt2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LLeVbnWQ; arc=none smtp.client-ip=74.125.228.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LLeVbnWQ"
Received: by mail-ej2-f13.google.com with SMTP id a640c23a62f3a-c252fb14159so7805766b.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 00:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789543784; x=1790148584; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R8y6AgD1DWAa0DwP9jnsCXImYYgKSkF2Ce/d73expsA=;
        b=LLeVbnWQNvtCAfMHFjOe9itiEOOMqDJHKCSEAzDXA71l+EQeoiz7YCXBFYmV2R8vnh
         zUJx36MQeR4fIBooGd75IsOQBWVxH4rnX+JGncxx8ugURhY87jkfzQdcLuwoCce5onHL
         /4ISZ296VVG8mO+hn1d4rGOn8x9V/xN2mmunYOt1kN/3jmUO5GBGBE1wImeMg/Y/Ezww
         9Zb2OqXKq2rqKx28E0u1IBD8NjThMn6X4BqCxoNbkeBXrsU3pH0pXvHNmSLmytztxPvP
         ITlLPw6GT+MEKOHfR8Ctq5PdNqaUVXrTVL8su1k0hUgrBWG/Q0GuSXvDYjUd2w2Kz4O4
         /U0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789543784; x=1790148584;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R8y6AgD1DWAa0DwP9jnsCXImYYgKSkF2Ce/d73expsA=;
        b=hgSqn8JxlDPuELew40AWOshkm4dVh1ABRjt9YLeohbTeg6TFyAbVOH+LcyHgdrqmq6
         WbA3RUSnPsdCpMSSjZ6mYT6PwsCJSQ83EeDhnAlvJvK7SGnyWDQjhTYguRuWHTa3oy8L
         FXPXwd53ZpFWGjogRgLD5buYh2liACBfhDppGl0opT9bjnfboDMPDHCOOO2XrZnq+4cr
         4/oSEZFxcgGauZw1rhT9FrT8vYvC7sJcLZNQ3UTT5eLWJ+XstFc9pSWTVvrA+Mnd+7FP
         GaPNw7851hkxFH/IB2KV5m6JlmYi1L1mdtzAB24FPrV9wOuyEHTwEbCvCscTNDYTvJrb
         Rllg==
X-Forwarded-Encrypted: i=1; AKwUvByryb5nQpQAkvfgdip/mkBLVIR8ZVGzXmpFoX83uPD3A+2SUgk1F60gI/oXbU7RtEqnFZkpnidMjuy+iw==@lists.linux.dev
X-Gm-Message-State: AFuF++kjT7kkGdeH3WV0kSM91F+I+VbwsOVrvPGnYJ8AqlsOn6cOrsox
	ltvFpSRG7VDTBKk9OcC6uu9geKvVUSdam9Ntp3CTERL6U3jssVopDhxNYBYBlLnHKUE=
X-Gm-Gg: AYBFou0o93yjvLzm+0oVrLfg3296xudAaARk8Bbbm6f678Td1G9Kj/zMtR6CyFLU/J6
	QMWgca6pd7wFDGqMZIv/d/6sPTdcaaODGxmuFfXjzv6jK7TRfXeEmO9DCSjoElM6FT29yJBqACM
	2Y4LtSA1/64We+M0w+wJMLwfNV+qxY3CEjLFa/jK0vkAXuqgCDeSJz7rSEDAIiBdeCu1/7Tq1/j
	2C2yakqnckud30186UooszcV0SKS6ylJ2HHZnHnuGzIq9nmNrYI2zkFhmbDMVwdnk0Cg8vyHa3A
	BmigjCKRtmDTt9qPMQDAEPr0DWAiIzFLmXmKfIb5BoNwtppkatZqFuOFcML6vSdREY0wDi/SdhB
	clH0ljPnQGpz91UG8BCzrpngEmaIxxK2B2VcSd8CseVjeDf3fx9aGKq5D0YFjtpv5FdoWtjRF3e
	eR5r20ztX3DoUQ+OM/yR3QR9rzWkNp/VH6crWvi9XBj3ViwAIBwjxypYfhhZEjJQWVWg9xGVs=
X-Received: by 2002:a17:907:c05:b0:c29:5637:ed76 with SMTP id a640c23a62f3a-c29e52c0dc3mr93106966b.2.1789543784244;
        Wed, 16 Sep 2026 00:29:44 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89ee75c9sm6672175ad.57.2026.09.16.00.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 00:29:43 -0700 (PDT)
Date: Wed, 16 Sep 2026 15:29:40 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Daniel Borkmann <daniel@iogearbox.net>, joseph.qi@linux.alibaba.com
Cc: alexei.starovoitov@gmail.com, brauner@kernel.org, dwindsor@gmail.com, 
	john.fastabend@gmail.com, memxor@gmail.com, kpsingh@kernel.org, matt@bobrowski.net, 
	bpf@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>, 
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in
 ocfs2_initxattrs
Message-ID: <aqpFJ6qeEBYBu7is@p15>
References: <20260915150739.284189-1-daniel@iogearbox.net>
 <20260915150739.284189-2-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915150739.284189-2-daniel@iogearbox.net>

On Tue, Sep 15, 2026 at 05:07:32PM +0200, Daniel Borkmann wrote:
> ocfs2_mknod() and ocfs2_symlink() ask for the security xattr up front
> through a struct ocfs2_security_xattr_info, so that they can size the
> transaction before setting it. ocfs2_initxattrs() duplicates the value
> since the array security_inode_init_security() hands is freed on return,
> but keeps the name pointer as-is, given so far every LSM stored a string
> constant there. bpf_inode_init_xattr() places the name in the same
> allocation as the value, which security_inode_init_security() frees on
> its way out. Copy the name alongside the value and free both together.
> This is the only special case wrt xattrs in the bpf_inode_init_xattr()
> context.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: ocfs2-devel@lists.linux.dev
> ---
>  fs/ocfs2/namei.c | 2 ++
>  fs/ocfs2/xattr.c | 5 +++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index e9c7774ccf91..e24f0e337a56 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -480,6 +480,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
>  
>  	brelse(new_fe_bh);
>  	brelse(parent_fe_bh);
> +	kfree(si.name);
>  	kfree(si.value);
>  
>  	ocfs2_acl_init_release(&acl_state);
> @@ -2068,6 +2069,7 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
>  
>  	brelse(new_fe_bh);
>  	brelse(parent_fe_bh);
> +	kfree(si.name);
>  	kfree(si.value);
>  	ocfs2_free_dir_lookup_result(&lookup);
>  	if (inode_ac)
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607..d83840b6bed9 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -7524,8 +7524,9 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
>  				    GFP_KERNEL);
>  		if (!si->value)
>  			return -ENOMEM;
> -
> -		si->name = xattr_array->name;
> +		si->name = kstrdup(xattr_array->name, GFP_KERNEL);
> +		if (!si->name)
> +			return -ENOMEM;
>  		si->value_len = xattr_array->value_len;
>  		return 0;
>  	}
> -- 
> 2.43.0
> 
> 

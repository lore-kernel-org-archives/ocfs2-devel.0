Received: from mail-ed2-f42.google.com (mail-ed2-f42.google.com [74.125.228.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B68225A2DD
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 02:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789526871; cv=none; b=HPRw9iop3SpQ21hCLNopEbGTv3A9KB1XjhpFwX/D1a0uy6cR64Zf9BSLWwGuUVGb2MLXBGZadYm5UMFRHpFopasx3XEu/waeXtLwDiSrgr1fxWGhC+97KgIpq/YgJBzwkmUs93HyeyRTGtx/bTar0Z83FzRxfrfQhHybDnxhu0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789526871; c=relaxed/simple;
	bh=wtd/03GFBPFtGkGnsixWJf5NJHyKunU5GA2TDNHK0mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DB+yrcSZn83lOAMzhkN6hRZDkvOVJzWwrNTYPwHfcAiMDw8OKeHrAM1r4JQrzOB7sMVNvDZnVNtbS75WHNLcB/8UOhXWRGammhE0HKFVRs+YD30iR8AxTtW3xCWRV5Gvvcn78SoLBsDtObvHGo5xtDY6pJJF8QwKp9ql0HPAor0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BlKhgwjq; arc=none smtp.client-ip=74.125.228.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BlKhgwjq"
Received: by mail-ed2-f42.google.com with SMTP id 4fb4d7f45d1cf-6a5d8ff627eso58259a12.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 15 Sep 2026 19:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789526868; x=1790131668; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mbykP5/XyMLit0cz7WlaiYBiK+Q7B+6nW+jCiDoN2jo=;
        b=BlKhgwjqs2o4ZPHYc2K02cwbavuQHjyW6ECsPxl0dSwNhI+CtcPPBu4S2erqgwWrym
         Ty6bwjGmIxfjKmiqmpU9mdmu3nuOSl+nK242knj8hLUV0UHL82Y12/K1UbVI4yROBHyd
         2hGJ/DQwDhScXptO8C2CB2NJLjJ5ZxTVCbLuUgCz1hok5547RztJjeAMJLm1T9/MJ0Ld
         aFE6kveLtIopQ36crZb424sGocGEnqaGfZ1MY6aHQHy2jBN22sKUMmMHClE4vGivkBLS
         1BC4STIGNG2XVWDPGiAjF0kP0Gp9BhB38fTvCE/8N03eMvPWV+XpWArFoqvsH7Uysu5t
         hgvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789526868; x=1790131668;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mbykP5/XyMLit0cz7WlaiYBiK+Q7B+6nW+jCiDoN2jo=;
        b=vd9ZWtlgT3lCX+x86fwFGld/uLzxpWihNjJ+K6sFm35SwRL8qhGcajrT9UPjNp7+gK
         +8Qp+NeiTPQoOwXFK2LHnld3LJirdJDmSZ67jx2l+0lROKWYxKW7fEAf4v+F/qX8Daij
         uOBBdSuxM9DtLbYaD+CbJjmgZmvX0tylyjb6i/dJuvNGC/Yz4b/+lGB/2JWfJ8ZAYfDq
         3y6NUlQfDLMIHlGDAtSH2x2EPwCGwNu0xgf0nTHLl5mqy8Ed2qpjtVzPqIkCoQqWDDyT
         AblQaCVhGagANwERknKiud3R7DumWa1PAk00cR47V+v8N00Huy2XpGa3WPAZTewhXQLc
         hogg==
X-Forwarded-Encrypted: i=1; AKwUvBz9boVmnnaXMPVUiN5tJQqDRSU3nDDuSNhpG3e6nrDshXKWjoDuvpmo4cuKnEzhDR+AZxqGz1ZklB/vTw==@lists.linux.dev
X-Gm-Message-State: AFuF++kJYMu7C6PI/uLiqlJacojd0IrIG9PkNE7OE2WxL9MCbVo36HI3
	vM020xO2llq8NeuN5qLsslHkq0Ly2oGiTSBs8FjMi5Sj/q2rIQZ5K9veZwfs5JfSAtc=
X-Gm-Gg: AYBFou1vRj0tnuoFOE7KT430kQgj7wuLeZgj4VYDyfLNP/V+YXynHxNqxer1wrZ2ysz
	p/Hpnq4+QihQOlN3licnVIsI1MQPnBYyPxGvd0KGE1Lzb0vqsnzOuhQfrMao4iqL/1I9epRXT4w
	4HmzL586/EE90ltZFJ+uDPQYaGcnbu/6xg7HYZCs5iI+vac2LiyJIU7e50kyTKAK3G9zU+N3DWr
	5KPzDP7omCgPcOEI/cSrCFo/dmREief1sKi+sI2WxBxoliybb6IEfgE8OhNsE4W29Hajewbkgr3
	/v5rjl8YeXcXLzzJ5K5VTNVOMP/ZDQLo3RSB90VRb9Yu13ngh7bENOLyFshDE748WiWReofQvF+
	Rl6O4KE68edEKY/ZLCy45dJd7xg+/X9G9bUL+UxBaYABkR3RpuCiG1/U8h8wC8skli8vq4yPRBX
	dSZYZ0BzXA91DQoQ61E1EIh2azTClpETCSLp5yFfBFgWS6N0UTMA/JoVnddJ5jdG8D7vm81w==
X-Received: by 2002:a17:907:3f99:b0:c29:cfce:1933 with SMTP id a640c23a62f3a-c29e530d7c9mr41736766b.2.1789526868385;
        Tue, 15 Sep 2026 19:47:48 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89d8fd37sm3839675ad.3.2026.09.15.19.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 19:47:47 -0700 (PDT)
Date: Wed, 16 Sep 2026 10:47:43 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: alexei.starovoitov@gmail.com, brauner@kernel.org, dwindsor@gmail.com, 
	john.fastabend@gmail.com, memxor@gmail.com, kpsingh@kernel.org, matt@bobrowski.net, 
	bpf@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in
 ocfs2_initxattrs
Message-ID: <aqoCVQ78KOo2GZ8S@p15>
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

Typo? I am not familiar with BPF, but I only found inode_init_security in
include/linux/lsm_hook_defs.h.

> allocation as the value, which security_inode_init_security() frees on
> its way out. Copy the name alongside the value and free both together.
> This is the only special case wrt xattrs in the bpf_inode_init_xattr()
> context.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
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

The ->name is a constant string (i.e., XATTR_NAME_SELINUX). We can refer to
ext4_initxattrs() => ext4_xattr_set_handle(), which also uses '=' to assign ->name.

Thanks,
Heming
>  		si->value_len = xattr_array->value_len;
>  		return 0;
>  	}
> -- 
> 2.43.0
> 
> 

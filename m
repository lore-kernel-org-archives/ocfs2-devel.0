Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810C8442B3B
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543728; cv=none; b=UO53cz3uKkY253P2HWz//TswHb4HO86X29U14st0sbMAOxMRW/uZz2eJmXmF99q8r0KEnwlgEuAu6GYwRFJjPcjsbCf2QBQFUZPUoT4D6Sq8SVV2DjDAD/eqpKa10QhJZDwfL313U1lg82HJMZBLd9ZK7UAlCWSO/XEPfFZfni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543728; c=relaxed/simple;
	bh=IC/3z8Hy6TaGkc5gtqi+JgSvdwlyuX/Ckb5Lj0+8K78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBtXFdLgtGDzcixtYsecsjfWT93/VLkPsT0UeLqaRi22GsUGVqb78DU4ZtvtTzVhaCX/wpWc12ZJCDIrbL2VQzh11WsxGzdLj3nPWnRF9I9mvHRbEF0SkaHxytdW0/MckMkMIAM17gUOCl+H7HWC0LFNQyiHcj5LxbVx+ikitDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U4Vd+O5X; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U4Vd+O5X"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c25331b31e8so8920266b.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 16 Sep 2026 00:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789543715; x=1790148515; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1uZ+Ugw6iVFEpPAYFuF70IRw1n6Gz3zCvuDx5V84fpQ=;
        b=U4Vd+O5XtAFBYa7JuvQZpIWLf9gQ7gQ9apyT8Mo4ZiWxUTHL+sn7LFYjIe+J65GSc8
         sbGicIM9H2Ew+f0AFdwRqEFmKV4Ws4EZ9gKF/mjuwrIIsGC5wfeJfDN/aFLf3iG4Ym5y
         HtkS5zXtlPy3H14UYSU0+Db1d9qVSpzfTmd9AxPGTWNOptuZEnYqcntd44Sf2vLGIY8h
         fzfoji2n3t53e4cdjPPZvjkZWI4uHRvJ7tZ3cgzuMKtFSjmYh2NSCu6Dw906dnjj6CZR
         WlU6LNukmBk1/VXPfuhWGz6O+TolKfI8t1k41816FonPkAZd0zxs12qbP/0uzW7dUD/U
         Ri+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789543715; x=1790148515;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1uZ+Ugw6iVFEpPAYFuF70IRw1n6Gz3zCvuDx5V84fpQ=;
        b=rdKKZPsy/hMOKKzaCOn8vbdb2gL/1VKVbwjeDsUdjp5BS0DOA87/xLTY/r79mDRVPC
         HdhgQAWNcUo4DK1XIGvDuEKTt8/Vlao2YB1H+V954/i6CdtVuYYjX2I17bLE5ME1o9LL
         r+dP5T6kALtJSdS3jnKJ1i2N4KWukp9y+Xj27F+7MRPm7Cg6InAHLceY+v48zOYAyYHT
         tN8ACJ3hxqUA7hR/eZbkDhEU2iuylDMmLbSdb+wfeWw3qwoJAGZC9QnBQEqhUPEI+dx9
         CeMN2ZQcIruFsJdUuBZaCHCqkXey9YIMxX0Nac7Vpob/+bPV6sbnHt9atyOD22VN38kT
         s7aA==
X-Forwarded-Encrypted: i=1; AKwUvBx3gphKlSGM43p8sr/Bjd988tARHNqpNpvXUJO/AD/a0TCNnM1NYViQXxxz+gEYfglMG/Lk6y58h6HzLw==@lists.linux.dev
X-Gm-Message-State: AFuF++knz7R0QzDmaiAJb+/A2OjXRLzJCn3eJ0IGPRoRcHOzRJ43MNgH
	YVFlw2DsxOkYiq3WF1WhRJXAI9EaLpteBTITdhzr6hTqaFpMbSkB9VQ7uKXAH7PX0fA=
X-Gm-Gg: AYBFou21EYtt1I3zhxPxFodrUPRcv43tOeH8K6tKafmjlRWNLjZfiybGFfeLm6Do69v
	4d9U2d5qfcNzxLGPGv9MVyVEDW4pOgnUiq+MIG1XX0T9Rg8hw3UdI1/WuH0IvTiSQ7nUDvhC+Xc
	12dQ8JKhezBdodgsiBsWJl4qERK16taXu133HYJMtCh3uYH3m5WeS27wi/+98hROdQc/KKFkirU
	7QGaklzPxgx7xy/3gjTfy+8cUgU0V9POFWc1aP30cG2m225gv8IHGyez+ZRPAb3t9nAMCZk0+Wu
	aUGUoSJQz5x0WkjzuFG2GnLbwCeR2rEcaRF7c0+rFEBhDMPbzDqyC0jZPGWnfKw3OKYcL5z1H3I
	nxMUrJqJuXMOgOFiGxS2eo4RQpWIGSaGlwDw/jlRMJVQAd/yRWr1xKrHkVnLu7mKAashtAG/A7z
	OcCJLoDMiz/MVKlXYkx+ZWFRTPQGv98gpd3T/Z76KQK5/NBZoWzFAaSBo7V7K+8uFS+27sAA==
X-Received: by 2002:a17:907:3f1a:b0:c15:c651:f28f with SMTP id a640c23a62f3a-c29e53aa447mr104464766b.3.1789543714645;
        Wed, 16 Sep 2026 00:28:34 -0700 (PDT)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e1d0be48csm822599a91.3.2026.09.16.00.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 00:28:32 -0700 (PDT)
Date: Wed, 16 Sep 2026 15:28:29 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: alexei.starovoitov@gmail.com, brauner@kernel.org, dwindsor@gmail.com, 
	john.fastabend@gmail.com, memxor@gmail.com, kpsingh@kernel.org, matt@bobrowski.net, 
	bpf@vger.kernel.org, Zhan Xusheng <zhanxusheng@xiaomi.com>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH bpf-next 1/8] ocfs2: Copy the xattr name in
 ocfs2_initxattrs
Message-ID: <aqpEvwAtkyohFrRQ@p15>
References: <20260915150739.284189-1-daniel@iogearbox.net>
 <20260915150739.284189-2-daniel@iogearbox.net>
 <aqoCVQ78KOo2GZ8S@p15>
 <f05cc7fb-9766-4b2d-9422-45ea1822578a@iogearbox.net>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f05cc7fb-9766-4b2d-9422-45ea1822578a@iogearbox.net>

On Wed, Sep 16, 2026 at 09:07:13AM +0200, Daniel Borkmann wrote:
> On 9/16/26 4:47 AM, Heming Zhao wrote:
> > On Tue, Sep 15, 2026 at 05:07:32PM +0200, Daniel Borkmann wrote:
> > > ocfs2_mknod() and ocfs2_symlink() ask for the security xattr up front
> > > through a struct ocfs2_security_xattr_info, so that they can size the
> > > transaction before setting it. ocfs2_initxattrs() duplicates the value
> > > since the array security_inode_init_security() hands is freed on return,
> > > but keeps the name pointer as-is, given so far every LSM stored a string
> > > constant there. bpf_inode_init_xattr() places the name in the same
> > 
> > Typo? I am not familiar with BPF, but I only found inode_init_security in
> > include/linux/lsm_hook_defs.h.
> 
> Its part of the series here; should have added "upcoming" in front:
> 
>   https://lore.kernel.org/bpf/20260915150739.284189-1-daniel@iogearbox.net/
> 
> > > allocation as the value, which security_inode_init_security() frees on
> > > its way out. Copy the name alongside the value and free both together.
> > > This is the only special case wrt xattrs in the bpf_inode_init_xattr()
> > > context.
> > > 
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > > Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
> > > Cc: ocfs2-devel@lists.linux.dev
> > > ---
> > >   fs/ocfs2/namei.c | 2 ++
> > >   fs/ocfs2/xattr.c | 5 +++--
> > >   2 files changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> > > index e9c7774ccf91..e24f0e337a56 100644
> > > --- a/fs/ocfs2/namei.c
> > > +++ b/fs/ocfs2/namei.c
> > > @@ -480,6 +480,7 @@ static int ocfs2_mknod(struct mnt_idmap *idmap,
> > >   	brelse(new_fe_bh);
> > >   	brelse(parent_fe_bh);
> > > +	kfree(si.name);
> > >   	kfree(si.value);
> > >   	ocfs2_acl_init_release(&acl_state);
> > > @@ -2068,6 +2069,7 @@ static int ocfs2_symlink(struct mnt_idmap *idmap,
> > >   	brelse(new_fe_bh);
> > >   	brelse(parent_fe_bh);
> > > +	kfree(si.name);
> > >   	kfree(si.value);
> > >   	ocfs2_free_dir_lookup_result(&lookup);
> > >   	if (inode_ac)
> > > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > > index 35bcbb0ff607..d83840b6bed9 100644
> > > --- a/fs/ocfs2/xattr.c
> > > +++ b/fs/ocfs2/xattr.c
> > > @@ -7524,8 +7524,9 @@ static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array
> > >   				    GFP_KERNEL);
> > >   		if (!si->value)
> > >   			return -ENOMEM;
> > > -
> > > -		si->name = xattr_array->name;
> > > +		si->name = kstrdup(xattr_array->name, GFP_KERNEL);
> > > +		if (!si->name)
> > > +			return -ENOMEM;
> > 
> > The ->name is a constant string (i.e., XATTR_NAME_SELINUX). We can refer to
> > ext4_initxattrs() => ext4_xattr_set_handle(), which also uses '=' to assign ->name.
> ext4 is not affected since nothing is used outside security_inode_init_security
> callback. ocfs2 is the only case in the tree affected, see this sashiko report
> which this small patch is addressing:
> 
>   https://lore.kernel.org/bpf/CAEXv5_gTJcP5BkSysZujLxiUcjbbBNi_NNbAnOJsQQVLyO9HoQ@mail.gmail.com/
> 
> Thanks,
> Daniel

Got it, the patch looks good to me.

Thanks,
Heming

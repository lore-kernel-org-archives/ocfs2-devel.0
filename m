Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61EB2C0271
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 07:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764575048; cv=none; b=LsQiJEb+CyZzuM7P75kPv2ZzHWgCOMZAuIewKu4v6WFeYj/OT9j0BCNHt65iOYkGp1a4llhaxpj0zWIn4IbZIXFwrasMoYvWVBfpkrHBxtYPROX0rPr+W5tg+bynZaGQLkLf/9pqxmnU7q1zVF3Jlfc/NhTILT5LUxj2KD8cLls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764575048; c=relaxed/simple;
	bh=MYPkkd2I3qKs690DXl8qoZ4c8+B0efzd2KQLrD67fjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDwRg+BRtJmTDw8lNovvqGYGQB20LmQfr3dnGd43caQhalaxVm7ZdLljQK6ZB08gwg5AJl9nIyplXG2l2WyBGxdueJ3SgI1gFcvz2qqmEPuHhUFQtKMphjrwipOSnh2mxrSjfjIH7XZ3i7za0S7uRTSgPnRx9OeOHEBd4ueq4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aoeyQaA8; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aoeyQaA8"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477985aea2bso4595915e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 23:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764575043; x=1765179843; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g85Dl+7l9Gr4y8dbBg1YndgJfs5lKrz0uw5y5VwIyY8=;
        b=aoeyQaA8YDKueHH1TppzhxovqPsBRqZLAP+jGJy43dhK5g2RqbOh9aHx10KIAysrva
         X5x7Z+wJwXk09n7EYVXhYZMO7ulY8p8hdrehLFqLNTAuwi/rqhCpq9tZPP6NG/1X4H0C
         BztzT0K0wbhdfHqB9z8MK9xBEvQFQEMdjLKXitIBl/xau6dj7ArxcIZz4OoY48jjT6JS
         OIoP3Q1vAfVF31p7LeOW12SQSkdNK3Q379VdmvX6ZXnV9FM6MWtAJq0Zerp2DwrPx/Pe
         53YeM+QauwQwRXaZBYRv2Und49Kb7Jv8eddUTwEUX3tX8SgEr0NA9r5qpRRkMBLl+tQG
         jzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764575043; x=1765179843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g85Dl+7l9Gr4y8dbBg1YndgJfs5lKrz0uw5y5VwIyY8=;
        b=CqWHIUlJH97TjDgvOfiOjP+xxCaT4v6RgRpC6IDiD2696VdShrIF36F8df5D6Y7lQH
         Y/NgtCqUz1sXfer69sgi4GD1Qq3nzWIn7oJ2VBglBwh3kXfg2Be1MAXfKCG4CQ0GpFPu
         +GYNz2G6fTKfEdhP9WWv8YFLP9EsU15Hzc9MuEIVW9W5YCJOcoJSQRyWbyaQamyYHECn
         A4KHxc/ZNoGGH4pZUhD+9om6kAztz/3VaMgvE+NdDB4QWGTMFb7XuW5Sfy4fcZEkV2vv
         xxhPilsbnjcIx4lAAZfa0oT2ugQHmL9YhaiCdln2ybTbHwGFxSEn52MIMAbZ4oytneuh
         qeaA==
X-Forwarded-Encrypted: i=1; AJvYcCVHyfqoaXnnLHXGCZSdT1h5Y+sLdtATYCzmMYMS3bUr1Nk5RDJJ742eo530j+AmiKdF/U1f9YcVOkRi9A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyN1oGAnzgC9PrRW4ebBJbjmhH70dZ33dvI41AKbq9AtIATxmkm
	k8ke9fIGtVUTbHdD7lMqvnFlrko4ddWz7zkzL2PL0ZQ4J3YkM9b+tjeodaIsVrjvqsQ=
X-Gm-Gg: ASbGncu6n+XnwNm/rGkI1moM4Uo72oidIQNkqb/1Me8aqVRML6hL9gumeXK5qTYl3iY
	gPZMbm/wZXLhLNwnHGZQ2DL1mBGVu24kW9TPPJKPbDEgi0Q/BaPMgzNBwzyhoFIHuL3ctmWeFvW
	fpeKFohZvQlS+n/Og8xfZpa/Ph+G1DUr0pEr0FHVqc3NX+8lXEXeOmplv8279ZB+SnXF5BJii5i
	1lUBllY4MhCrBfsaxdsstPAVBLaQ8h2ND/AyGygkv4pmRUdQkjJPX9c9IImlwhSkIKBVt+InL88
	EcUexPuO0Ie7oInsRQlgZ9o2mHDO6J4lX87uNT7lIMukjUCkNpEeUcDSy60Z2JlhF7WxSvX87LM
	UQCNuBJ6DVNLU703OH3B/aQdwU34odItk++ljpW8i84pKNtd0xUx0y5Q+p/uRFy24GAraKA9Hpi
	0ecj4qdwjWUA==
X-Google-Smtp-Source: AGHT+IGvB4eFsFib82gxstsOShQqNIy84FhuCU0E2+LF6qmWPxEg/HHgZX9yvAbDMVQVFkZLps12lQ==
X-Received: by 2002:a05:600c:444e:b0:477:9a4d:b92d with SMTP id 5b1f17b1804b1-477c314a201mr232599775e9.5.1764575042757;
        Sun, 30 Nov 2025 23:44:02 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-347600c9180sm7251879a91.13.2025.11.30.23.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 23:44:02 -0800 (PST)
Date: Mon, 1 Dec 2025 15:43:59 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com, 
	skhan@linuxfoundation.org, Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH 1/2] ocfs2: Add ocfs2_emergency_state helper and apply to
 setattr
Message-ID: <ehstl65oxyl2nmckl5axluz2arhz7dm6k63mlddtqb4qf2o7m2@ler4qv6wnbj2>
References: <cover.1763337347.git.eraykrdg1@gmail.com>
 <f60d7b3669ee3bebc11895795bf1bc9c990fecea.1763337347.git.eraykrdg1@gmail.com>
 <ykvzskyxtwsy42lxxin6avihe6lbub75ywvn7e6zod6m45dpyy@6xkfaynjpuos>
 <aSlmFFFxQfbnaRWV@eray-kasa>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSlmFFFxQfbnaRWV@eray-kasa>

On Fri, Nov 28, 2025 at 12:06:28PM +0300, Ahmet Eray Karadag wrote:
> On Tue, Nov 25, 2025 at 10:58:32AM +0800, Heming Zhao wrote:
> > On Tue, Nov 18, 2025 at 03:26:44AM +0300, Ahmet Eray Karadag wrote:
> > > To centralize error checking, follow the pattern of other filesystems
> > > like ext4 (which uses `ext4_emergency_state()`), and prepare for
> > > future enhancements, this patch introduces a new helper function:
> > > `ocfs2_emergency_state()`.
> > > 
> > > The purpose of this helper is to provide a single, unified location
> > > for checking all filesystem-level emergency conditions. In this
> > > initial implementation, the function only checks for the existing
> > > hard and soft read-only modes, returning -EROFS if either is set.
> > > 
> > > This provides a foundation where future checks (e.g., for fatal error
> > > states returning -EIO, or shutdown states) can be easily added in
> > > one place.
> > > 
> > > This patch also adds this new check to the beginning of
> > > `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> > > (which triggered the original BUG) fail-fast with -EROFS when the
> > > filesystem is already in a read-only state.
> > > 
> > > Suggested-by: Heming Zhao <heming.zhao@suse.com>
> > > Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > > Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > > Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> > > ---
> > >  fs/ocfs2/file.c  | 6 ++++++
> > >  fs/ocfs2/ocfs2.h | 8 ++++++++
> > >  2 files changed, 14 insertions(+)
> > > 
> > > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > > index 21d797ccccd0..03a98985ac92 100644
> > > --- a/fs/ocfs2/file.c
> > > +++ b/fs/ocfs2/file.c
> > > @@ -1137,6 +1137,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> > >  					from_kgid(&init_user_ns, attr->ia_gid) : 0);
> > >  
> > >  	/* ensuring we don't even attempt to truncate a symlink */
> > > +	status = ocfs2_emergency_state(osb);
> > > +	if (status < 0) {
> > > +		mlog_errno(status);
> > > +		goto bail;
> > > +	}
> > > +
> > 
> > I prefer the ext4_emerency_state() style, using "if (unlikely(status))" here.
> > 
> > >  	if (S_ISLNK(inode->i_mode))
> > >  		attr->ia_valid &= ~ATTR_SIZE;
> > >  
> > > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > > index 6aaa94c554c1..2ac16632dd19 100644
> > > --- a/fs/ocfs2/ocfs2.h
> > > +++ b/fs/ocfs2/ocfs2.h
> > > @@ -680,6 +680,14 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
> > >  	return ret;
> > >  }
> > >  
> > > +static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
> > > +{
> > > +	if (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)) {
> > > +		return -EROFS;
> > > +	}
> > > +	return 0;
> > > +}
> > > +
> > 
> > calling ocfs2_is_[soft|hard]_readonly() is a little expensive because it
> > involves acquiring the spinlock osb->osb_lock twice. In my view, we could
> > introduce a new function, such as ocfs2_is_readonly():
> In ext4, the helper functions check read-only flags without acquiring a lock.
> Would it be problematic to do the same in ocfs2?

Comparing with the ext4 code, in my view, OCFS2 incorrectly mixes the normal
read-only state with the emergency read-only state. For the minimal code change,
we must currently acquire the spinlock to access osb->osb_flags.

Thanks,
Heming
> > 
> > ```
> > static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
> > {
> >         int ret;
> > 
> >         spin_lock(&osb->osb_lock);
> >         ret = osb->osb_flags & (OCFS2_OSB_SOFT_RO | OCFS2_OSB_HARD_RO);
> >         spin_unlock(&osb->osb_lock);
> > 
> >         return ret
> > }
> > ```
> > 
> > Thanks,
> > Heming
> > 
> > >  static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
> > >  {
> > >  	return (osb->s_feature_incompat &
> > > -- 
> > > 2.43.0
> > > 
> I agree with the other comments. We will send v2.

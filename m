Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789492FD66A
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Nov 2025 09:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764320795; cv=none; b=eY0SeadGorPNYpwa/KdocZsaqqKmbUCuw4EvUJofZkTx7idnTvTbdw7AxOKRqYuXLmBRqHtJ30xQyObKepX9mCCAP3wEWvo9Osq9tUUo1lrsJa6BdYTOVopYk2Q8ytwO/f9RRv+MpUXsBLlY6Mxy7rj1Q/WnS1kjnQvbGHZn5Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764320795; c=relaxed/simple;
	bh=x2avRk/dKm+mCLueN8oiQHD739LXkYF2Blewq9ceHyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsFKE+p5cjeqNVInrnJVG74p4o9Ug6wReBQ1UeJx4K5dxgKNK/d3wjj+rJc6IY+aGPPBYBRLnUdImqToBReJso/FPAd2virAd2kWXfGY99X8ZJwF7+4B2hYlNNcmjMyLYe+4h6FX/QTI3YSnB6MZWc8SdKRYHP0sLW21i2tK6Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fXg66O8t; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXg66O8t"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6418738efa0so2788628a12.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 28 Nov 2025 01:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764320792; x=1764925592; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fybugla5irn7/5MQulh1PMDITgT+aYZ/+S7WGxnXfR4=;
        b=fXg66O8tIIbQvR+FX4Aq6DUCNnpeVd4SupraX5E1Oiee4+IYxmNsZpc0ubd2Da3zln
         4TITRSSTJNzbHV/r4uuUFj5q8Zg/Nz3HOWqmrV/+MZB8DEcSupzdFDfyU2cVTMZqA1mM
         Hv36xgA1Pv0SizuHqs5FwM3KRvJy5nUigY7l3uSC+nmh2FKblowOSXsdR51SkBZ7bgf0
         3pb60OxTSC2l1bqibB1JkvEpFgXpcHZkum5q4CMsO+MEWoBxp2IvKbovcRDJ5jHXryAb
         36mpWhLo1tuSHtI9Bs8qPsENtEjV4F+TfmFodgcG6cchE20Eya4zT8FpWdYnsIQVWtPt
         nYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764320792; x=1764925592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fybugla5irn7/5MQulh1PMDITgT+aYZ/+S7WGxnXfR4=;
        b=uwpMn/R0T1v7otfD/2gMZXeHN4djKwTLidLI/iBWV8ibiFcRqnIVyoR2HkYDSon9he
         1mqRp3VKlt+gSvB11OhPwsD8A1SSnZhkmh3Ngqyfw+IF5sXKK82gE3HXuSXohYiMioCs
         hQ9lea+r2j7pmYqh4Ngqiea2p7Ca7SINw5Q657M5vYSbbZeylRFEN93pzJVy0iQUuDEt
         DmJSco24FYQrdDhA+F78y2jZdi1+IVP54NQDPY/WDeraXZntlK3qaNqhmvn4JlBF3d+W
         HGR3DrdMoI7TEDORC79JoX+hhH4gkPZg1tJMzommIJqINGYNsdIlQGmkw5olejKAjuCe
         KUtA==
X-Forwarded-Encrypted: i=1; AJvYcCXlsbxq0DiSKQfIVPbrDet76fc4tOOxKo5oJURhkVNbCQ69JHCPhZlHXBKbUs+aOTXvnQTOv0EjsmSVew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxn8kvDBunOdGy0+HJFLFDR9mC0q3Sbs/c+F8uELPrIxkOYsiUH
	cShC9GV9Gcr16/CisYD7cVlNYbHxPozVSwiAzwkClM9uLnp0ztbnGeI4
X-Gm-Gg: ASbGncsAUT0ol64d1dxp21eJ4UMW6d27VsD3NiKczktcDDZnSSTC0vCCK1uwXDpUQag
	qLsOQxjmZkxnNqr3MjsPVIjIeeG0HaaPs+IcXL1i1kmqKvIcX1Iv9+6GIUpM62eQisZsqj34FZV
	OxA/34JlXIxJzaxvFDOlAIhp+QPOJDJdXbE0swM6/4wuLAPwU5lc79KohFIPr+wNyqVbYuq5SY0
	EHuSljty47No/H3iLfoPe7JbvBcwZoBEFgZ1F0alHwmdSgB/sIep9qhJbo0BXqoOo8Qf/AdGKRB
	8gVUtFi4MAXE8lLstvUr776XHI4qPx07/TcbNINbwWOO3emOCwCyzdVZqd0PVMVJllnadQaS9dv
	M+IJGRO8Q5kOugIFUpDQAnJOdTCkBregmF9n1Ww8cA8YDn6Iv4Vz/91XGbN5YJaMT1NlLr4qOqu
	G752WlCNTVEQ==
X-Google-Smtp-Source: AGHT+IEh9wemANzw5MUsk3gYyvmUha3wASsp1y4xGHyQ+NAl08Ru0AZk39iUNvmhAhoJJEswEeJRbQ==
X-Received: by 2002:a17:907:db16:b0:b73:6474:1ee8 with SMTP id a640c23a62f3a-b7671565a7cmr2818527266b.14.1764320791320;
        Fri, 28 Nov 2025 01:06:31 -0800 (PST)
Received: from eray-kasa ([2a02:4e0:2d05:16ab:8837:f306:fdf3:a46b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5199852sm400094666b.15.2025.11.28.01.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 01:06:31 -0800 (PST)
Date: Fri, 28 Nov 2025 12:06:28 +0300
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: Re: [PATCH 1/2] ocfs2: Add ocfs2_emergency_state helper and apply to
 setattr
Message-ID: <aSlmFFFxQfbnaRWV@eray-kasa>
References: <cover.1763337347.git.eraykrdg1@gmail.com>
 <f60d7b3669ee3bebc11895795bf1bc9c990fecea.1763337347.git.eraykrdg1@gmail.com>
 <ykvzskyxtwsy42lxxin6avihe6lbub75ywvn7e6zod6m45dpyy@6xkfaynjpuos>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ykvzskyxtwsy42lxxin6avihe6lbub75ywvn7e6zod6m45dpyy@6xkfaynjpuos>

On Tue, Nov 25, 2025 at 10:58:32AM +0800, Heming Zhao wrote:
> On Tue, Nov 18, 2025 at 03:26:44AM +0300, Ahmet Eray Karadag wrote:
> > To centralize error checking, follow the pattern of other filesystems
> > like ext4 (which uses `ext4_emergency_state()`), and prepare for
> > future enhancements, this patch introduces a new helper function:
> > `ocfs2_emergency_state()`.
> > 
> > The purpose of this helper is to provide a single, unified location
> > for checking all filesystem-level emergency conditions. In this
> > initial implementation, the function only checks for the existing
> > hard and soft read-only modes, returning -EROFS if either is set.
> > 
> > This provides a foundation where future checks (e.g., for fatal error
> > states returning -EIO, or shutdown states) can be easily added in
> > one place.
> > 
> > This patch also adds this new check to the beginning of
> > `ocfs2_setattr()`. This ensures that operations like `ftruncate`
> > (which triggered the original BUG) fail-fast with -EROFS when the
> > filesystem is already in a read-only state.
> > 
> > Suggested-by: Heming Zhao <heming.zhao@suse.com>
> > Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> > ---
> >  fs/ocfs2/file.c  | 6 ++++++
> >  fs/ocfs2/ocfs2.h | 8 ++++++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > index 21d797ccccd0..03a98985ac92 100644
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -1137,6 +1137,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> >  					from_kgid(&init_user_ns, attr->ia_gid) : 0);
> >  
> >  	/* ensuring we don't even attempt to truncate a symlink */
> > +	status = ocfs2_emergency_state(osb);
> > +	if (status < 0) {
> > +		mlog_errno(status);
> > +		goto bail;
> > +	}
> > +
> 
> I prefer the ext4_emerency_state() style, using "if (unlikely(status))" here.
> 
> >  	if (S_ISLNK(inode->i_mode))
> >  		attr->ia_valid &= ~ATTR_SIZE;
> >  
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index 6aaa94c554c1..2ac16632dd19 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -680,6 +680,14 @@ static inline int ocfs2_is_soft_readonly(struct ocfs2_super *osb)
> >  	return ret;
> >  }
> >  
> > +static inline int ocfs2_emergency_state(struct ocfs2_super *osb)
> > +{
> > +	if (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)) {
> > +		return -EROFS;
> > +	}
> > +	return 0;
> > +}
> > +
> 
> calling ocfs2_is_[soft|hard]_readonly() is a little expensive because it
> involves acquiring the spinlock osb->osb_lock twice. In my view, we could
> introduce a new function, such as ocfs2_is_readonly():
In ext4, the helper functions check read-only flags without acquiring a lock.
Would it be problematic to do the same in ocfs2?
> 
> ```
> static inline int ocfs2_is_readonly(struct ocfs2_super *osb)
> {
>         int ret;
> 
>         spin_lock(&osb->osb_lock);
>         ret = osb->osb_flags & (OCFS2_OSB_SOFT_RO | OCFS2_OSB_HARD_RO);
>         spin_unlock(&osb->osb_lock);
> 
>         return ret
> }
> ```
> 
> Thanks,
> Heming
> 
> >  static inline int ocfs2_clusterinfo_valid(struct ocfs2_super *osb)
> >  {
> >  	return (osb->s_feature_incompat &
> > -- 
> > 2.43.0
> > 
I agree with the other comments. We will send v2.

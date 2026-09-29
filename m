Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3D442586F
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Sep 2026 19:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710665; cv=pass; b=aI9scxitMQBxqI5YchhFZnpHrgD4EsiCEigTdoYgAsq9yBlMb2xFW2z6lrsKuPUF4cxNZdcS5Jh4RNDt9trZog6e8GsWekemg9ry/MX/1GJGAiaRQBszRraO/0I4+Qssja5CRV19tevPH7wmG2j29lD4PtJgboZiM5UAUfDipIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710665; c=relaxed/simple;
	bh=zPOl7hZyApEXshKMSylpZ2BULcyQnFZvV6/jjsZB5Iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z4rmHwmjBYx+g0FqhInyj3V3d3adoE3Dfl0MVmaRwgGj2m1VxcFl1HiwsoHDsFORXQt9xwnXfq1QqFTjz5J1xBNFVOR9qRyAc8eCZDjKDw9TqzYb5UziZqWvEW9Crp+ssLPfDDWDWoexLUCYDMmBzEJJoI48lX8ZV0wAz+lQCZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E5OwKHAY; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5OwKHAY"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672f4b7091dso2437245d50.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 29 Sep 2026 12:37:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790710663; cv=none;
        d=google.com; s=arc-20260327;
        b=LZV5F8/7RP3+y55fTV2c15oV6JAIBVnIYV8ogWaMAg1xOBzaG5J+9i4hJNoT7Sr7mm
         reMWKxYRz5Vtx0bAlyuGG8j/thMyaUfyg47GRslrc9yYl5IYOwhCmvXXWTZZUsMi4+j5
         UmiOLytkaHTtvG3IzqHVeoRBWoyjZ3m/ZCw+lY36PgQsosch4BDk1892IAOf9/GKvNq4
         rM2aQyo9AriWUroM3tNaQDaQ52HShPIEg7Bzo26yrv6tffFmi/LL1mmu+7gLBsMFY58Z
         8zQkufDgM5TeS4gu5eCFr1SMeWsV0rM0e0Z71gNy9l19gXReqmuS7onTQdgj6VeZaguX
         7htg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GX+Eejk6Gbdd0dI1GiNKkTeKVvseDXezn0hf+TkyYJ4=;
        fh=rSAMAiStr+3O6i6LbMAJGnX8Hbuz1oY+5Upm83256s4=;
        b=Hoo0jFcJO5E4CVC4NQp/N93/+bFLruNgBSJ04x8+r/k6BGVXD0/4CbMtiv3EvQ9YB/
         NDV94DOsj4TJkSLtbC2eerK1e66V2obbtGH8eDJ34+x0LZlPMUhANKkLhvA6SFh6D328
         +h4gyIRdG15puoRNUpp4C+8kFaEqir/BqDhEgQb4+7r35duaSFMUH3dTuj31YYeHEtEa
         a7HPfbum8RE0972hR93DjRtt2pZXi24fRe1iFLwfTe6Ah8ky/3j0whUdPkCvCJhgs2TY
         7upjkXw9xnbv51jpuf/lJ6Dqft30FZCFthlA91muDuCqqLbJyWzu50fxE0UIO9WIgjMD
         hTpA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790710663; x=1791315463; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GX+Eejk6Gbdd0dI1GiNKkTeKVvseDXezn0hf+TkyYJ4=;
        b=E5OwKHAYLuSSV/Tj2b71Ih7q2GVuJLFPPZCDWWralkPR9bIl3SWh/HMZLFRIMSDnnt
         rh0eX5ONbG5W7c3dUTCxAW+fJCh95jJsk7iTidrQZU7SjNKUukGW7MyZE1BjaQkQ4Jt+
         Ykqp1GZNsrhaDx4z6Lft3P8PaThYP9CXN6DtcUyGBqtgJDeDNs/SvKprXIvqa7tNa391
         F6iZ3ELW8CES8Y8SIDytT9WWIZyzOj6ujTS0cfxCYLvzp3R0uXPOvHAMsmOA8pVHDMrc
         alLh6WxS9wLj8PG1kP1hj95q1Ah/yUiXMUukhtSrlAlboMyj9UD/IfmtgieeL4ns5DKH
         zeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790710663; x=1791315463;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GX+Eejk6Gbdd0dI1GiNKkTeKVvseDXezn0hf+TkyYJ4=;
        b=P9cZ9/ogiw3XvBBwHpye+FawvV+Su98w+VH4cmroVScSTlTThS3JMs6SW1IlovOjKw
         NBDMrR1VRdloAMEbjv9gIfyj0UtCEbxZkcT7A5RWahMUh5wuk4Kr8qcCcn3pOw07g1OA
         fHgQgKdSJew/YeRHwhX3ejcMnWqv99ozVFjbLJ52Fr+nA1hgTtMBeN5QKzRDMpXbMmu2
         W3xazVONhs6eHKHtPlk1JgYal7Zdj1oBkLYuxeGPGcuyptbBAQ5x377/Hpx+0typiO8Z
         /v/Eyu4oWGqsmau/8XtDkDX+LdRagccw0TIMWWqq6XV5TCtBU7qjwinNm78hNIsa7PgG
         UejA==
X-Forwarded-Encrypted: i=1; AKwUvBwWRxrIttjcFSC9DuvLUZLA6DDAAZOVPFXYfO0rAQwcF0Kn4V/2LH/h0mL6DyGy13PESgxkESRFwCRc1Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYJUKQOytivcWB6nugf2pQuL8x+cSnqQSKnPmz++HAm4zmDqt4fR
	ma83kQuDEaPdNjnZP8ciDcYyT3ZNJyc1aAuRVok59LcP+im3LedqBw0tWRV0fLCAz6kiHgvciKQ
	KSXPrOIt93P6dxVUu0ABuGBu5q+TBiUg=
X-Gm-Gg: AYBFou2IMmE9STihazdYFv+4GZ27NLJEu23UsIf5BU9GLLPnxO7QdTQnUM2UPnKuZwV
	beG15eiwDTz+Ev8d+vePsFISQBNs6ywlNDd53ySjE1OF5RRKzkFUlexmSOMgzrCg4lCVRqrhAEY
	XBckIPHSqzDOAH5Q/o0nuhF8CC+uDvSTV8WUBue1xaDFPo8xtyzNqT3j8hs4vO6gAZpUbEEIelZ
	nc++YCKuNofov/YytHLNqGi/A/l93au7cPd0GQE0ZW0bT15eF5M4Rd5DvAYXU0YnUTMJltCe3Hr
	nY2EbexpY7X58IZHEe43u1Cnqa7YWbZVfHa/EbVh/Fm6lERP1B7ncMM=
X-Received: by 2002:a05:690e:4889:10b0:674:1556:4979 with SMTP id
 956f58d0204a3-6763ab23a59mr82376d50.7.1790710662756; Tue, 29 Sep 2026
 12:37:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922060048.13158-1-ginger.jzllee@gmail.com> <arsnHB6Ak3q4Ztsn@p15>
In-Reply-To: <arsnHB6Ak3q4Ztsn@p15>
From: Ginger <ginger.jzllee@gmail.com>
Date: Tue, 29 Sep 2026 21:37:29 +0200
X-Gm-Features: AclHuK8HGiKwNFs3_ik20qNDsJApVWkeRh7QZ2qvciJw1z2DCH5ZiX4SeXHtWbA
Message-ID: <CAGp+u1apjPVOkk0zkaPbbkFbtkNOU=RrMN9947xWgT_LdabOhw@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: Protect local_alloc_state updates in load/shutdown
To: Heming Zhao <heming.zhao@suse.com>, Markus Elfring <Markus.Elfring@web.de>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Heming and Markus,

Thanks for checking this patch. According to Heming's response, I
think this patch is not necessary.

Sincerely,
Ginger

On Tue, Sep 29, 2026 at 4:59=E2=80=AFAM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> On Tue, Sep 22, 2026 at 02:00:48PM +0800, Ginger Li wrote:
> > My static analyzer identified a potential issue in 'fs/ocfs2/localalloc=
.c':
> > osb->local_alloc_state is documented as protected by osb->osb_lock in
> > struct ocfs2_super, and most of the code follows that rule:
> > ocfs2_local_alloc_seen_free_bits(), ocfs2_la_enable_worker() and
> > ocfs2_recalc_la_window() all update the field with the lock held.
> >
> > ocfs2_load_local_alloc() and ocfs2_shutdown_local_alloc() update
> > local_alloc_state, and local_alloc_bh next to it, without taking osb_lo=
ck, so
> > those stores can race with the reads and writes done by the local alloc
> > reserve path.  Those two writers predate the locking convention and wer=
e
> > never converted.
> >
> > Take osb->osb_lock when updating both fields.
> >
> > Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesyst=
em")
> > Signed-off-by: Ginger Li <ginger.jzllee@gmail.com>
> > ---
> >  fs/ocfs2/localalloc.c | 6 ++++++
> >  1 file changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> > --- a/fs/ocfs2/localalloc.c
> > +++ b/fs/ocfs2/localalloc.c
> > @@ -342,8 +342,10 @@ int ocfs2_load_local_alloc(struct ocfs2_super *osb=
)
> >               goto bail;
> >       }
> >
> > +     spin_lock(&osb->osb_lock);
> >       osb->local_alloc_bh =3D alloc_bh;
> >       osb->local_alloc_state =3D OCFS2_LA_ENABLED;
> > +     spin_unlock(&osb->osb_lock);
> >
>
> This function is triggered during the mount phase. The la (localalloc) is=
 only
> active after this point, and the fs is still in the initialization state,=
 so no
> inodes can be created. Therefore, we don't need to worry about any race c=
onditions.
>
> >  bail:
> >       if (status < 0)
> > @@ -392,7 +394,9 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super =
*os
> >               goto out;
> >       }
> >
> > +     spin_lock(&osb->osb_lock);
> >       osb->local_alloc_state =3D OCFS2_LA_DISABLED;
> > +     spin_unlock(&osb->osb_lock);
> >
> >       ocfs2_resmap_uninit(&osb->osb_la_resmap);
> >
> > @@ -441,8 +445,10 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super=
 *os
> >       ocfs2_journal_dirty(handle, bh);
> >
> >       brelse(bh);
> > +     spin_lock(&osb->osb_lock);
> >       osb->local_alloc_bh =3D NULL;
> >       osb->local_alloc_state =3D OCFS2_LA_UNUSED;
> > +     spin_unlock(&osb->osb_lock);
> >
> >       status =3D ocfs2_sync_local_to_main(osb, handle, alloc_copy,
> >                                         main_bm_inode, main_bm_bh);
> > --
> > 2.43.0
> >
>
> When the code enters the umount phase, the VFS layer ensures that there a=
re
> no other references to the fs, so no race can occur at this time.
>
> At last, if you have reproducible steps, please provide them to help us
> understand the issue better.
>
> Thanks,
> Heming

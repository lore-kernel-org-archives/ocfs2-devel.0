Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF8337418B
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 20:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769889787; cv=pass; b=Modn1vqHLffZm99URvACa/ImEHqOC1XXgwoBHGk7F9Z2IzejnxkBqME9E68VBF+vtGdQCvCYQ/fylliwzyGV5DURLMoUIADFG55x36ycCrMQgRURxeLN6kvsSbhy/NP9GsTGUz1NWKo52Id9dKY0XGu3xFRLA9x2MAYls5iM9t0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769889787; c=relaxed/simple;
	bh=7+gpJ1XTqfyvqD906j489jah9H9uwbfvoMkXE6cDPuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m4CSSAlb4GgHzn1hAo9n2EM6cPvcxLgUP+l+gJYd3kAjy2p+HCbBy2IaE8n/r7oAEKtTO/gcrO2eWKlhjhmMqIlD6+sRKuhilVKBQAK6nZcC734GTQZwZDN2CIqryKEKV3OS+wQOtj3Fd/Z3HSItzquTieTFc7lpLa2Rc7/uW7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AVhOdM6F; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AVhOdM6F"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-658d4059b79so4512104a12.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 12:03:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769889783; cv=none;
        d=google.com; s=arc-20240605;
        b=Ia0iqGHtEKcPNcWrJJ6rXa9jFDi9ta3R1F2gul34YGD0/QsWyzrs/m/PzyCqZswBGM
         pFXmgw6PuhHEJkwMxQHCq9qNhNo/OdWbWRCLgd1vO0uOzFz1J6/XmhJ2gqZzYxLctzCE
         P5Oey7FKabPngj/JZIwl0Hsn9LuZbtM4lm2R/bJe/hxut/xNYDeFybHwkIRs1sIPDlq9
         TuekYiIBKmzVn1l++Wll9wn1lcVecMv5lUkcL9buZIj+giirH8wXSq3T7FavS9uqJcg8
         0ck9SHKst2Pv9Ymec4h20umXn/i8/vlfCvC7LGZ8ixNwAphyJdaNnX+3OEP78anGIOk2
         DXEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
        fh=VyMIUNjci2xI9wsyvAwILhniHImFRhaOYuhK9V4wQ3k=;
        b=V4FEHgevdeqhQNdSX7OL1Ba7zIrDfzWNMbXdP04+BKlhtMf5wnb4fmWoykHaCXbL3b
         CpwvsYclxGWhEySmhEtK4ySLIpPmo8gEFkFOtAoRe/gGuIT4Pyn1YgMQNsr+CllLCyvc
         ECFuRCAuQ5GS5pGo9n6b9bCEmP56oq8VMiHY8oTzV1a+icAFH7ne6nUoBGAGmvgEzSW+
         97y00YKFYQg/SBADB3xwJX7Qe8/bBmIrS84A4Br/h1L82+LALv2LoWc2G9Sx3X77HBWT
         Ua9m91o1tRMwCnAR7mY1JkG9bIBwIysfKpSCiu80Kh1sIoiQ1xpsw0qDu0LnFcXpM/sG
         SflA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769889783; x=1770494583; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
        b=AVhOdM6F5UPYmUOqRibP3WKUM41g7dfq6uj3MWRVd4dfA0Q9BdzoTZDA4cycwNQNSJ
         dBYZINwdv0j3uCtIpxFsaGGm770bkZNogGJqfSQnalMgnC1ukfNgz3eWdUjq9FIxUyih
         Ah3g/PDNETkbv7K3kpsbBlraM6p7+3h1bkP2siNNixvvRTI5U35TpLK6eqW1bNjJdehc
         c6+agBCtq/QFAfcIYGjsoS6vDEJ9FZLED3uCO0YO7XIJQiJHzmeGluq1uzibemKSXn1W
         6EwF1VHm5R12vWI8OozJI6CqRIyZ4Xl8v2klPzZ0XTEIGRoFLi0Ur4nPDNj3dvfjjYeL
         nbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769889783; x=1770494583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
        b=m+1N//W4MgrbpqyOyfx2bQXgzvfKFNugnv2dqp1fWDNFnDXiXR/HhI/s3nZdTu+YD+
         z9zWPjMTl4aho2nMfuoAqJMguQ++bdKiToGfO0GVHyq/VI2AIhNlSl0EIHyZSKf9Ka+q
         hatggs9rpknZSVJ8Wk9CKloKpxauf4Wc5GT3xtMD7QPee2r1AKkXMI4S6izYxCtxPsV3
         yFYeW7plESM43fhLPZfYD2X+a1YowRfl2Fm5CPDzV9wifSIQ6i9qOjlEhKqxrodCkj84
         2ZOhe9svvqh6/o5cSRWTO4WZ/01L/wcAihSusPShbXnDdVW6IdO0s+S6AvbA3WNQYYPR
         v+VQ==
X-Forwarded-Encrypted: i=1; AJvYcCW01MmtGU6+1E3z/33WM8QDcTfvkeZKJrmmUNkKp8rP3a+MWuBk76HnBsvCiD+RWj+l86RyE7jcTLF8Tw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4al9mg4BIakLyy49FYDzt609XyqZw6RE0Qtk8/ZMluxYkeC9M
	P4AKZ9zq4FyfttZRDalE9rx4wVKzClSzWauOXJWPJwGcnakZtk5+B9uggvQZxyTEAhZzx3qPtN2
	jxDBOhUrxsk/O8CEALu4aWwN4U5zyxqRm5ebfvce5
X-Gm-Gg: AZuq6aJ3HG5govS+c/VNM2iHfpL4mT6YFbESdti1aDECPSf7CEI/o6myXoSRdIU2TzM
	WYvXcbhkHayWhLKUS7V2q2JcgOCf+jBuGTl7fJwxJxKnOGub77DpU+8CrvNgBl2PyflQps+G2Qg
	Pv/XBqYHOlla+GFXv/vW/n9WhmC6Zfs625fniM381Aa48Ao6Ukm9lBb5R0IwrKDrUrSVzGbN/bg
	v9kGLXFeHcdGCqsUWc2WO7seZwgfO+JSYOKqxNNq0SdDu0zuD3Tqr7ea2C38Rg9Z5QY
X-Received: by 2002:a17:906:d555:b0:b87:2675:9eaa with SMTP id
 a640c23a62f3a-b8dff56a89dmr396045166b.15.1769889782950; Sat, 31 Jan 2026
 12:03:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com> <CAEiyvppoiL2EiSmVvNV3DEkr7wwyC1Fbwhm14h7Rfus4Z8uP7g@mail.gmail.com>
In-Reply-To: <CAEiyvppoiL2EiSmVvNV3DEkr7wwyC1Fbwhm14h7Rfus4Z8uP7g@mail.gmail.com>
From: Samuel Wu <wusamuel@google.com>
Date: Sat, 31 Jan 2026 12:02:51 -0800
X-Gm-Features: AZwV_QhcEbOb_GQTelufeNwJJCU6MsAWKA6Gjz0fMmR9BpLj1Kmi7hMzQGebBBY
Message-ID: <CAG2KctoHRG+4J0ujC9162n-Ndgn3nKMu_s5jh0-c-B_P6EOk6Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Krishna Kurapati PSSNV <krishna.kurapati@oss.qualcomm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, 
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, linux-usb@vger.kernel.org, paul@paul-moore.com, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 31, 2026 at 6:58=E2=80=AFAM Krishna Kurapati PSSNV
<krishna.kurapati@oss.qualcomm.com> wrote:
>
> On Fri, Jan 30, 2026 at 6:46=E2=80=AFAM Samuel Wu <wusamuel@google.com> w=
rote:
> >
> > On Thu, Jan 29, 2026 at 2:52=E2=80=AFPM Al Viro <viro@zeniv.linux.org.u=
k> wrote:
> >
>
> [...]
>
> > I'm exploring a few other paths, but not having USB access makes
> > traditional tools a bit difficult. One thing I'm rechecking and is
> > worth mentioning is the lockdep below: it's been present for quite
> > some time now, but I'm not sure if it would have some undesired
> > interaction with your patch.
> >
> > [ BUG: Invalid wait context ]
> > 6.18.0-rc5-mainline-maybe-dirty-4k
> > -----------------------------
> > irq/360-dwc3/352 is trying to lock:
> > ffffff800792deb8 (&psy->extensions_sem){.+.+}-{3:3}, at:
> > __power_supply_set_property+0x40/0x180
> > other info that might help us debug this:
> > context-{4:4}
> > 1 lock held by irq/360-dwc3/352:
> >  #0: ffffff8017bb98f0 (&gi->spinlock){....}-{2:2}, at:
> > configfs_composite_suspend+0x28/0x68
> > Call trace:
> >  show_stack+0x18/0x28 (C)
> >  __dump_stack+0x28/0x3c
> >  dump_stack_lvl+0xac/0xf0
> >  dump_stack+0x18/0x3c
> >  __lock_acquire+0x794/0x2bec
> >  lock_acquire+0x148/0x2cc
> >  down_read+0x3c/0x194
> >  __power_supply_set_property+0x40/0x180
> >  power_supply_set_property+0x14/0x20
> >  dwc3_gadget_vbus_draw+0x8c/0xcc
> >  usb_gadget_vbus_draw+0x48/0x130
> >  composite_suspend+0xcc/0xe4
> >  configfs_composite_suspend+0x44/0x68
> >  dwc3_thread_interrupt+0x8f8/0xc88
> >  irq_thread_fn+0x48/0xa8
> >  irq_thread+0x150/0x31c
> >  kthread+0x150/0x280
> >  ret_from_fork+0x10/0x20
> >
>
> Hi Samuel,
>
>  Not sure if it helps, but Prashanth recently pushed a patch to
> address this vbus_draw kernel panic:
>  https://lore.kernel.org/all/20260129111403.3081730-1-prashanth.k@oss.qua=
lcomm.com/
>
>  Can you check if it fixes the above crash in vbus_draw.
>
> Regards,
> Krishna,

Tested above patch, and it didn't fix the device enumerating on
lsusb/ADB issue. Seems like usb dwc3 lockdep was a red herring.

I'll respond on that thread with what I'm observing.

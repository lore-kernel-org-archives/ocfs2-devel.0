Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A83533031C
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 01:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769735795; cv=pass; b=Lg+gSPAvFPqgE76YU7XzY+KrQ6ycP5/JvSYumMN0QEGaRGacbfnKJgzpaWfVOcE3VNPaoYcDei2iQtVMpE95v7jEDZTDs0mgVhdI13S/TRTyzpsKI9OCMZnSo8bqS/ksJ1qm4a1HlSeFWyuemSn3h+cQ0e6334qHZZekrmOod3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769735795; c=relaxed/simple;
	bh=qynRfaO2IfQHcVC7rjEM4LJol2rxXEFXu0TZsMkojdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pvCQXd6Qbq0NEVnFXyzJg3WRvGL6pIl1tzYaBcr+tV77d4r/JnMcS0wpKe7CEyniaQw22wHMud6ahgKjFvKn04oS0UGWD8Q7tQEoR6LPORaUE7FjUSjpYDKmFjLRr0w4IkaMIbY9cOD8E1JhbWumXxpYw4V176fhpAKLCGpPb30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oyA8mS9q; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oyA8mS9q"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8d7f22d405so268476766b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 29 Jan 2026 17:16:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769735792; cv=none;
        d=google.com; s=arc-20240605;
        b=FV4QUy7eOZPc65VY562+o0cH6OBMLdipr/m+rhusv0xgMQKUbUoEns99m4Jjlr5pNr
         GKqkVigrazH080drBbco5OWYUSkZHNWZ/bZOeLBwYQjJ9MM1CjgeqREe0OavxVf5XVn5
         Ik1ahUue8hPMilJUxT7KtqHLzWY7CPFQW1WW36E5M0DN64RNPKr/y4PZecPZWHk5shN3
         tnOIVekaVMRzviF+4llzQM808Sft+p64N4UHJuJy1Zn8DP9SHelhjxpxGja0uKPKEr1L
         JUJQvbXVCZ6nn4mPnhdJP2jUPJGeJ8o4tGF4KULhh1MBKv6KlC9L94Toi+vmz0vjNbMB
         yxRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TDFRbEmoo50qM27MYVAAAo2rNiUVkc6+HtDETmMWn38=;
        fh=YlPZIrOw4VDgDwQXniS4N+T9yUKRuTgKJWGYVULjgis=;
        b=NmygJI7DRsDGaE+MG/n6MSPup8CXFh1dY7n3gxd18PGaROJ8ghxW/sJxWcuOkrtus1
         BTfi3g7YSb5d9zkqv7o2InhxG1d+rl2yXnhodc98XIFhXHE1kiI8U4I9TfLF9E5m13la
         UcKcyAjLhWiiwgfYNeAx7CBDZs034UoUpUBD5ia1jFrzn0nu4DY9llUFxGdDyUwsWwvG
         Bg5g0suW82v7xL2AkPqZamQwF6waI6OAQybMff5zFf330bHu3TRmO9pbhEWAkGuyY9Hc
         essdGkJP8mT5iaud3e9g14sBgCqd6VK05SPmd+0TJZO6JDICLvV7TtOH7LJng/keakxX
         P8Hw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769735792; x=1770340592; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDFRbEmoo50qM27MYVAAAo2rNiUVkc6+HtDETmMWn38=;
        b=oyA8mS9q4p1Qf6KsbOLs8OywYKGPTqtFXJtIiqxJqHT4qwbqjWWp+KhC/Q6/iSQgfF
         ALE2A1wAH+oofW8McXh/xZk5NOb+WL1K0773mxU3Ed2q2MLNcAu7i/f6byz/z9ccHlBv
         C9eaUTas2G7nAncfuDGUzC5C+XWT4X5JaGiep1si6mrNBUaW2IfRD9eOlmx47JEE81N3
         w5/U+1Dr015nRcKzOfVmcMfaPZNoEF+HgXBYYJqbWEwTHd9yytP96CF+RsjnwOWG84vd
         xAZmzBBj0lsxffn4IfC2pzsjCzffQT+TuOlYwAgCA3GFiAUgZD9KEJzr5F5eDnOEAaFS
         hDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769735792; x=1770340592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TDFRbEmoo50qM27MYVAAAo2rNiUVkc6+HtDETmMWn38=;
        b=XzoPg1S4gqnDqRqYofNMW+IQLtgcLZixdMNsUL9Y7qW4Pf7h9JrcOvZ7HbioK+8ulB
         P3eP6syr0Vq9E4QuSIeh5eeBfkXxdEI+msKba+Xab50NdfZwLJIyo7WZAsbEWf/Mjnky
         nMnatYJ1yIBqPcYw6oCXFm4scExNth3NVnPGT6NsYDpWtJTluGrCc73sHCRtYAlrKcDH
         wz68TfCaonapqz3DTUCCe52Lg4tAJfimEipqLi0A508Neiv1PXgFEcsI0RZF5slpu/TA
         JYRtnPEcLzXdzoXlIarJOW6vuGuhXeqmMjSj1oLF1ZucnbnMsZopS0ATNrrdKALEJJ6X
         Uq7Q==
X-Forwarded-Encrypted: i=1; AJvYcCURqAU+h3uBwBV/+zRMUwUXeGAAMzm1XewJTvk0yWmI4MxiKpGvfcrYVHzydQw63MaAEXqNPAe+jvGLvA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1BGfNRBX9BPdY6Oq3pV6lQu0C+IbJ9aiIPVCr1EVKjWfjbnih
	uBja75xyROqxY+PIx+9iyQMwcm6f+fnrVTnDpVZ1olcn1rrBobqTTtHZ+YBU27is8qDHiDNqiIp
	kt2OakXtfPn8MhEKLLvER6r0PJTzF/ue9PCJMWUcl
X-Gm-Gg: AZuq6aLmBvj++Gmb9H0uhrLQAu6AedoFVaHywGSagEQaABi3rc/iUh3AbA2xpPBMkAl
	410yWEYFlmX7rfRtSS9G3Dg/RqIEd9/wjFtxhmaUZ0J/qSqpF6d1BS5gl2tO8Vas3wV/721tyBp
	3ic9teu7Z7WTfPPkrmBkAFnzOCuNkckFHNwD74N7RgLkByuOMlJ+VzfrTMggOvdqlpLJA37vd3p
	lAvOVmKHiICWMz2M64r+4SV0QzB2XlC47OUwgGo9G+4b4Vg76LkvCZunrxhGhojvHKKEM7F4JDy
	LzKJSKC4LVplAWaCaN9uumrFTWtejQ==
X-Received: by 2002:a17:906:eecb:b0:b88:31f9:1d9a with SMTP id
 a640c23a62f3a-b8dff71fbbcmr62042966b.62.1769735792220; Thu, 29 Jan 2026
 17:16:32 -0800 (PST)
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
In-Reply-To: <20260129225433.GU3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Thu, 29 Jan 2026 17:16:20 -0800
X-Gm-Features: AZwV_Qio50GdQN1165WVg9oPRvbdMSYV2LeALjhPJoJWlsc8zYrp7Hv8KsFMrXk
Message-ID: <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 2:52=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:

> > Sorry, I hadn't been clear enough: if you do
> > git switch --detach 1544775687f0
> > and build the resulting tree, does the breakage reproduce?  What I want
> > to do is to split e5bf5ee26663 into smaller steps and see which one
> > introduces the breakage, but the starting point would be verify that
> > there's no breakage prior to that.

Ultimately, same conclusion as before: 6.18-rc5 with patches up to
1544775687f0 works, but adding e5bf5ee26663 breaks it.

> > PS: v6.19-rc7 contains fc45aee66223 ("get rid of kill_litter_super()"),
> > and reverting 6ca67378d0e7 ("convert functionfs") would reintroduce
> > the call of that function in ffs_fs_kill_sb(), so the resulting tree
> > won't even build on any configs with functionfs enabledd; are you sure
> > that you'd been testing v6.19-rc7 + reverts of just these 3 commits?

I also could have been more clear- I had to
s/kill_anon_super/kill_litter_super/ as part of the revert of
6ca67378d0e7 to properly build. That felt like an appropriate change,
but if not, adding patches on top of 6.18-rc5 is perfectly fine for
testing this.

> Could you try your reproducer on mainline with the following delta applie=
d?
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/func=
tion/f_fs.c
> index 05c6750702b6..6c6d55ba0749 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -646,12 +646,11 @@ static int ffs_ep0_open(struct inode *inode, struct=
 file *file)
>         if (ret < 0)
>                 return ret;
>
> -       ffs_data_opened(ffs);
>         if (ffs->state =3D=3D FFS_CLOSING) {
> -               ffs_data_closed(ffs);
>                 mutex_unlock(&ffs->mutex);
>                 return -EBUSY;
>         }
> +       ffs_data_opened(ffs);
>         mutex_unlock(&ffs->mutex);
>         file->private_data =3D ffs;
>

This didn't work on either build variant (6.18-rc5 and 6.19-rc7).

I'm exploring a few other paths, but not having USB access makes
traditional tools a bit difficult. One thing I'm rechecking and is
worth mentioning is the lockdep below: it's been present for quite
some time now, but I'm not sure if it would have some undesired
interaction with your patch.

[ BUG: Invalid wait context ]
6.18.0-rc5-mainline-maybe-dirty-4k
-----------------------------
irq/360-dwc3/352 is trying to lock:
ffffff800792deb8 (&psy->extensions_sem){.+.+}-{3:3}, at:
__power_supply_set_property+0x40/0x180
other info that might help us debug this:
context-{4:4}
1 lock held by irq/360-dwc3/352:
 #0: ffffff8017bb98f0 (&gi->spinlock){....}-{2:2}, at:
configfs_composite_suspend+0x28/0x68
Call trace:
 show_stack+0x18/0x28 (C)
 __dump_stack+0x28/0x3c
 dump_stack_lvl+0xac/0xf0
 dump_stack+0x18/0x3c
 __lock_acquire+0x794/0x2bec
 lock_acquire+0x148/0x2cc
 down_read+0x3c/0x194
 __power_supply_set_property+0x40/0x180
 power_supply_set_property+0x14/0x20
 dwc3_gadget_vbus_draw+0x8c/0xcc
 usb_gadget_vbus_draw+0x48/0x130
 composite_suspend+0xcc/0xe4
 configfs_composite_suspend+0x44/0x68
 dwc3_thread_interrupt+0x8f8/0xc88
 irq_thread_fn+0x48/0xa8
 irq_thread+0x150/0x31c
 kthread+0x150/0x280
 ret_from_fork+0x10/0x20

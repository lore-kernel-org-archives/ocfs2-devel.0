Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31C6326936
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 02:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769825355; cv=pass; b=rg8saEwEuy020kd7iMxj6+V7KzCx3vZ1vtl5oce3X3lOS86cnHeEcYoviJT5aHCPBc2GoEzePiUj3algGGgsosvnnN7KjpRsI0A4JU4yyR2FMPwXZAI/KfX3gpA2Rf8WeLiszu+X1xSldGjgiD9FDLUw3w7SqY7yYiE4yRPH614=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769825355; c=relaxed/simple;
	bh=q1+m69AC8OyppS+g1qL0airmm2fN+rGF7m5h75RejBg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P+BNFxKREAIksMawfrwwigPe+MVvdOInoTicJAwuGW86jXZQ1QyidN13r5mmyils9jrHsUyhaCbX9qNABf58+KzH3101FfdRSQEem61aeiGVKjeyphl1HgqVzC47NLL3sp3bqsCA2yGWYvz7WCWJ15ppfPsTbVk9lrQ36Y719m8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ex7rJR8H; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ex7rJR8H"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b884ad1026cso433892466b.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 18:09:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769825352; cv=none;
        d=google.com; s=arc-20240605;
        b=NgEHqcdnIKIYptzIM3id0rLPxj5sHEtr3DFRtH4lNnQmGBzvksrsAgXaBdS9z7e736
         2XzOByobIcVwwywVJ4ZXarh8QLYC0Eqo9+G5oV9XDGio29O7dcJ20Nms9VJ1ULuV6NZF
         8yxPb9MsvZTWOVhuQuqY/8uKhJspBk134lQ3YevaaD4snqyPcqY5HbQoxz/Dt9Mt8+sY
         dkT9PHYc3wWROm2HshsxIX8mnjwqQc416+4ryI8x6MGPGCGxww1AXid2eYKUz/7nAtnA
         Q7D69IGQcsuENr1B3OBMBvr91BhwEe4v/uVxIZ8thW5uH5sWuxSlaOmNm22uK1zJU1jY
         p4/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fXBSGIys3SzCpVetTGHBAjMTb+eZCN0LoIysZIFKUFQ=;
        fh=P6h9ThI+jhrvKqPZG9dfT8/QMxSIlZiP8BSrWTZgPdA=;
        b=FTpZVLnWvaxOouMRML9A0WYVztoJXCH+pUnaPiHDp+7F9Z4uiYHeSkhgr049Cqizq8
         32GsQq9xeSIJjWM50bsoOWL7YblgH/q8hyY+MR0UVkSQdqqj5T0MXGhDutBHP6yeRFz7
         sEB4Ji9u25G/jFIM3ZsRhGIbFFIE9WS3D8HCBKF8PwYklt3PMg6qT3y+iGik1m5MSzzk
         22DIj/vpv53iPEBkh3vpSMYYSbwmJyTrWi3sw78lipHhBi14bijRVZFW/W6dFj60uXlp
         rOtB40+VZSJW6Zbiq/63ikVsoHSQp5Fbx9ZV1wHvLbHvay35V3CbTrQ5/Qo/zOw6bfRX
         LlNg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769825352; x=1770430152; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXBSGIys3SzCpVetTGHBAjMTb+eZCN0LoIysZIFKUFQ=;
        b=ex7rJR8HgodfIkcKo9UnccsUjb+U6qyqgh4FOghU59IGHMsNrVLRpYQ+ER4OPWfWK4
         9/l8ak0VxmJkt2SV+CVXnPGQnE1I/qj8kqm2PKRR36GGF29XP3NC73UpcRrue2/KCa+R
         Q4qJye0ZAp1AGI0DRV3AxUxItBhWpzBKVrz5RBDzNfhE7TZ088wmGGqGUwXTBylF8IJp
         5eppS6G6V/AWRPSAqQXqmF46H5GxjWBu/MULP1KN+7XXf+GyeLOwjIyRTCo2o0Z4J44H
         usXIKOhrVoFr8zW3uJje1P77FKRCsujfVNjEvVwYFNXzfRvrY9evcLZVaEr5aNMU+/dj
         w8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769825352; x=1770430152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fXBSGIys3SzCpVetTGHBAjMTb+eZCN0LoIysZIFKUFQ=;
        b=Y2LdeyJZcp0NGE1ckMSk/LfIVvmfizUQfGOf7S9sYDkmruBUeObO/7Tt5a54pECybs
         VyFoj4bjy0DdCkHsbIb7erZ6NJajl6ukfcihtn33MXPKy3BBL0+SJrofpnCS6IjM0dDP
         tFjRtXEEz7SSGFUt73xamnxFrIIxuN4F2dkIp53MxKJQ6oVYdgSa9r9GT9NEsdQyg79/
         rj3WvZ0UFY6clFdaeOMz956x0X3xw3j5TtR4MHax4MwgQyXtRmkkKdkhcKOJzIjrOAQL
         sEi+KV2rJ3vthKiTdCN+Yi2+9DC2dhBSJy9cz/SQtS2UWqQ+R7gjuDFF69cRw43Vs65y
         ykTw==
X-Forwarded-Encrypted: i=1; AJvYcCXf2oa/I8gRUdG+sywysn5V7D4jAEJiSg6ggRqR+xO4zmvsFvvFSwkTPUz3B7N493HSRtUJ3VAJ9iCCdA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzWZmjStrASGewtEjcUUaxL5XTCMRhfd5c4C5w8PBKN2rC2uOpD
	b0mJdUe0MqXndyRGbwVtpnVfYgOg/Cc7J6dj6RhBSURBJFMDSjJusWmVDIse+sIluXCYubI/F4H
	7tF0U4l5/Jz0x1YkApzzdbaXW5vtWfmap2YUmDnV1
X-Gm-Gg: AZuq6aLJft5Fj0uNrJ46LHC5YdAG+Twvm4fNX9Bd5B031aMSLoV1xaH1ZDAOkdMlyFj
	LD8eynAHD/RVVR40e6AteGt2klIO4ZO3Psw5+Mky5g3NyPdEmWe0u7GGrsSmGQVCUlKpsgmfbLw
	b/pXXKlagNncFoW+PGziO4NbOis7x+Fu3mQp9dLFQefGHwtmOz7s51uZL/NXODoUlFe+d3xFNMT
	u9HzK3uuSBjSITG38dy29SscYg88nRAzRzoHe5yNrvCQ78EhBPqEgCMrszvgF42SYl2ZxrQIlz8
	1WQ=
X-Received: by 2002:a17:906:f5a8:b0:b74:984c:a3de with SMTP id
 a640c23a62f3a-b8dff5d84a1mr304116566b.28.1769825351931; Fri, 30 Jan 2026
 18:09:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV> <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
 <20260131011831.GZ3183987@ZenIV>
In-Reply-To: <20260131011831.GZ3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Fri, 30 Jan 2026 18:09:00 -0800
X-Gm-Features: AZwV_QgpcNm32QTyYTJNZ2e8MpZD_azq4tiS_evKebHi_xWHPJAAyFUDpR04HdE
Message-ID: <CAG2KctoKDsfbyopQYq3-nJBg3fG+7Nrer17S6HqQ+nCWEcHeWQ@mail.gmail.com>
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

On Fri, Jan 30, 2026 at 5:16=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> On Fri, Jan 30, 2026 at 05:05:34PM -0800, Samuel Wu wrote:
>
> > > How lovely...  Could you slap
> > >         WARN_ON(ret =3D=3D -EAGAIN);
> > > right before that
> > >         if (ret < 0)
> > >                 return ret;
> >
> > Surprisingly ret =3D=3D 0 every time, so no difference in dmesg logs wi=
th
> > this addition.
>
> What the hell?  Other than that mutex_lock(), the only change in there
> is the order of store to file->private_data and call of ffs_data_opened()=
;
> that struct file pointer is not visible to anyone at that point...

Agree, 09e88dc22ea2 (serialize ffs_ep0_open() on ffs->mutex) in itself
is quite straightforward. Not familiar with this code path so just
speculating, but is there any interaction with previous patches (e.g.
refcounting)?

> Wait, it also brings ffs_data_reset() on that transition under ffs->mutex=
...
> For a quick check: does
> git fetch git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-=
wsamuel2
> git switch --detach FETCH_HEAD
> demonstrate the same breakage?

Had to adjust forward declaration of ffs_data_reset() to build, but
unfortunately same breakage.

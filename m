Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1779318EED
	for <ocfs2-devel@lists.linux.dev>; Sat, 31 Jan 2026 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769821549; cv=pass; b=jXN6EeWwcjmFOy9m+wQyw825IKaY2XFdDRfBX6zQCdNiJUx3i5yQ+q/7nhX/dklASvnx6L2mEv28bXSrlq2v2qHWVhqGJLGcOEt6PDItq2+H9vimfq6BSXBVHlPH6ZSaLCO5W5XMLfQRATmxvgJbLsDGYEUQdxLbrJWK2mrWuXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769821549; c=relaxed/simple;
	bh=xauAVDrNEqxXuQQDfkuXjcLzA9iR5d/8KDCLj8SlAUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YDltHPvMioGoQDdjwGqQvGWchvZkN/V8ydBjc7aNjWscTi97C5s3IpgsADXDD7Wns9A3KGgsOGGilDyaiDM22JepMNZ7jDkN4QyzjyO2R2qF7cZF8SyP5gvwWE5UfJ6PoxegRDIU6It4DKZ9Ne3Q14bfyRKsz+9tbe2o7I8Vzuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lt0A6OcB; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lt0A6OcB"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8849dc12f6so402784366b.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jan 2026 17:05:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769821546; cv=none;
        d=google.com; s=arc-20240605;
        b=NyCtKXOb54lgOhdBCPNcRqBQQTkh8z9vmN1qFDs29kkqsIkSZbOYGAC1CKQ3dmaOnD
         65Azt3DtDHPOIhLBcgjGgM6boSxyG0nyrxtKF/o9ejxKLuMH9QnM5GVdJT/xQK005vQu
         i5IISaOvUTA88BtkE5jccoTqS4c70xgXdeOZhs3grWyiZ3prCZDtcKVHYTkP9s9IMtmO
         GzUzNx5+H+bi3z1PklxaAlsW0ZdwXeNRQ1GcPIXiRVRJDtBhl8fsO46e+UWb7TgMKNHk
         KZgYO3uT4nrY9z7UxebxjPKFLS8PR7QyVX8JliVL7RxqolGBzEYZbJe7xe/SSCXCcgJl
         uufQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WR8rpY2KGV4n5Wdzx9LxUGbuZ8iHOgSWcj67TDHRUAg=;
        fh=XvOu+3q8eZHKhqU8m611eSqaR42uMKBqYJ3ik7K/0AA=;
        b=VlARYUjLMApf5lNlKpUqhLW4gEaVm3jdt1kD8Drwdt94iLJcNK7BbaqK9JR8a72Lz7
         /YR3IYock8W0LaO71O2p1Oy2PzPZFsqWgloAm0E+EQ1dZqwOsbTPEqc1jJi+hpMKCIEH
         nBxeuhju9kqLyQ9AbBzfz5012LghOzkFv9ZsdvgtAkPggL2YFMiY4t55jWX5x72814uD
         f5gxOrVyRCvi3lBM0muMoiOdKjMTqJoGyMbswJNR1pyANKBwPXjaH95uCqn+RhjisXsq
         z9/Uqfqutbn6DXlfPmmXNLZ7NnRqpzY1R21nqVotc79MACtcsMFDxTnc5t5YJ1Qf5CHA
         OAXQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769821546; x=1770426346; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WR8rpY2KGV4n5Wdzx9LxUGbuZ8iHOgSWcj67TDHRUAg=;
        b=Lt0A6OcBppL03G7SKynJAB1NIes3312xH8tS1PhsaanneTg6fLcxSgYybl5KqTHXed
         PuS9vbL3XhgibknNNPN9ReQ7I1I6YGUG9736iQHvDOgmHfWu+DfJZAsS+1hSjqTs3FA3
         l41oS0NSsYBn3DBbCcMqfkewFBriNAAov9qHv7QdZZsm6iMYd2IwhnTE993tumxtZtpK
         0gMTU7drAWMzb3PbPqfQqHtr8vjG9kJrHGsm00Iy+psAMRp3d3LmhWHqB0WTLf3QVVkV
         hC/cAGu/+8kMnpjrhNadHQu7ifebYfSYs4nKLqMaupGGxML4VbgorsWD1Q6+a3gAmmF7
         Hq3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769821546; x=1770426346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WR8rpY2KGV4n5Wdzx9LxUGbuZ8iHOgSWcj67TDHRUAg=;
        b=JYRb4/S3jgpq/CqDby5otDpkj8p19TJh4E4DxZ8b7GNW5Oy3Ye4IADulcfUoe5/1RY
         GuAIU8FGvzBigdguroYPV+KDfgtciyi56XWbJuncyrUr7giV9NetsLOpT1uuTXCvghCz
         PNz4K76r4bkfs8X9XAeb9m+FnD5ubsgE/FVhk5I6QTdoLmXO0u0LSTOjwh8rLelJ5EO3
         81cH+Sw7yxcKE4wGQR1XnFYGc+YDyQFcY0uDOX1hHkCHR7BCGGGawoLpI8CiY4x8uQLJ
         0bOONysW2CBRZ3YbYbIWks53tG15b9YXoA/GRw//Kd3lREUFUXyk/520pyTcLLYKMn11
         fFcw==
X-Forwarded-Encrypted: i=1; AJvYcCWMbC4IP+lvercretP8GgSBeC4y6SMZnMmAHmai3U3sZonGqcsIYs6Z8MgQjF2p3xX0856wNjpI4yH9Cg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzKAw4LSb28f0kDER4sWIHuNDrSUHu8I1e/WBVmSeh1lxqz3U2d
	xiDR6cZlesxGdmsIzDn15WdsiY0er054h1DGq6/pRJY03ADRhlpzxF+1JY1l9iMt7NAhT5VA4w+
	z3GOITaCx/jBBz0AkoMdBbvo0Imau87Ot5qE4mOOk
X-Gm-Gg: AZuq6aLjI/scrRdz3A1NPxu8Tp0UilnbnuZjM/lSSrFsndWsL1TDUvdWClZO0CxS1xv
	F4Usa2aPPIdEjplWh6Wq37WI0svBE8whBwAe5YogfT0T2sCADN/F4jVlEcxb4TziGajDKGjbAhL
	gUkJl0mOyEw+WHIrp7rv+OMiszifUSVRPF26j2M8cIlRYGS7jXNTJUtyAhNDXXelo1hN1E3aEWs
	QpNzhBMDh26bMhPn2H3Dq5SXey6HRzjHU2M2niYx3YXvZTaOB+nRAlOUbUTlIiiLESoSV2+6OcY
	E1E=
X-Received: by 2002:a17:907:3e0d:b0:b87:322d:a8bc with SMTP id
 a640c23a62f3a-b8dff696c0fmr254282166b.31.1769821545900; Fri, 30 Jan 2026
 17:05:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
In-Reply-To: <20260130235743.GW3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Fri, 30 Jan 2026 17:05:34 -0800
X-Gm-Features: AZwV_Qi-TVApb-UR_yhUuzDZcqy8acCYfKVdTsorIhJOL99wmGwpM0Som40uK5A
Message-ID: <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
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

On Fri, Jan 30, 2026 at 3:55=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:

> So we have something that does O_NDELAY opens of ep0 *and* does not retry=
 on
> EAGAIN?
>
> How lovely...  Could you slap
>         WARN_ON(ret =3D=3D -EAGAIN);
> right before that
>         if (ret < 0)
>                 return ret;

Surprisingly ret =3D=3D 0 every time, so no difference in dmesg logs with
this addition.

> in there and see which process is doing that?  Regression is a regression=
,
> odd userland or not, but I would like to see what is that userland actual=
ly
> trying to do there.
>
> *grumble*
>
> IMO at that point we have two problems - one is how to avoid a revert of =
the
> tail of tree-in-dcache series, another is how to deal with quite real
> preexisting bugs in functionfs.
>
> Another thing to try (not as a suggestion of a fix, just an attempt to fi=
gure
> out how badly would the things break): in current mainline replace that
>         ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK)
> in ffs_ep0_open() with
>         ffs_mutex_lock(&ffs->mutex, false)
> and see how badly do the things regress for userland.  Again, I'm not say=
ing
> that this is a fix - just trying to get some sense of what's the userland
> is doing.

Ergo this didn't make a difference either.

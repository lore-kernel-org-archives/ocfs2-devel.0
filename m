Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627A719994D
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 13:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724246018; cv=none; b=I1st/8Ve5PhhgJsQ62uH/t4Mp45tBg3x79HwcYdl2LWEXc/TAf354aPxXC+kPni/Ih9Av6OuA2Wmy5Vz/V6Ie7+C19/PITWHmK6gOlKVVD9xQeinzbszehVY2mUe3y0HnzeGeU4XsysqX2zIpoKVdcw4WhIktM9AURp/+S8BJfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724246018; c=relaxed/simple;
	bh=VxdnQRQ9RoJiHroH7aL12ZENbeWU8OgMK4PjHewMYIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F8k0m+QAnX6Oyx9iwyZ9oZB+6+8gJVQanVrmEgwzrPIlxn9DZ0UoNM4W6UzRioQ7XXX4J8EaHwYuJBRp6q822v7SeevyQCwjfuv0wqZyRv0znjPU70x/Zz+G5hDZSXQ/Gl+0Q2F6TY79UmZlt/9dSi4l7zsjTjPeJPxUk5P2LyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DY9JGeAz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DY9JGeAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724246016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VxdnQRQ9RoJiHroH7aL12ZENbeWU8OgMK4PjHewMYIM=;
	b=DY9JGeAz9K87/d9DgzpkrWDycbq5Tn3K1G+LlQTmYiW0/xgOmirOYkM2lyq1fFRjLvo0Qt
	ZpDIDiDlznwaeuS0FkbalVBVu9edYXl0uL+cD9GCcdDzsIf2bJyrBaLQ5f3UUNqfVyqFVZ
	GsBzvMO/3zzRCLkjgzYQnAZXdYtlmx8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-tqXYFU7xOp-VQkwxPDb7Cg-1; Wed, 21 Aug 2024 09:13:34 -0400
X-MC-Unique: tqXYFU7xOp-VQkwxPDb7Cg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ef3133ca88so56509641fa.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 06:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724246013; x=1724850813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VxdnQRQ9RoJiHroH7aL12ZENbeWU8OgMK4PjHewMYIM=;
        b=SJ/YjAPJmvR0NpfY7IY06uaJcOVMpktRYr6phJ0aHRWqICrN67GQMP/JldtPgnghKb
         kGWu1AVABcX5UgEXH1Q30kMIny2G876fJjaYuBimt21O54w8XNthOmoYr4za6MEYXuTw
         NXcwKzTmxOHz5SC8p9nC0oYEo2XOwWwVMUyBncnWEDM9O+jf0OF896+5QyBcxmenVTN7
         BZM7zrIp51Cqqy8vzU8E9i5mvxrtd9SmodejencA4Xi/EOYAxssJX16Klc8Thj/2ZpAW
         K98qYwIXDe7dLHLuHJC9U5/+eItJmQVns6pkMTiyKyAbGP4ds+asaBtCx2HxbTugemER
         QprA==
X-Forwarded-Encrypted: i=1; AJvYcCUByPO0PW/mPIedAaCBuoigpsSzxBpRbx0oqhnC2HJmvKBcsmwQ/ckXrigEzWTB3kyYum1coqfsxsIXmQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyj5AaFKgCVZbZcKt5/6HXsBM/p3QwOvuFfxPFYTNDWeJaPcBrx
	iV/cXI1pOlWvKZcxLSx2Vlum+/5GvOo+JPg49jZGkEEOHe9Be47hA6zLsoS+l4lvdrwjigGcFAd
	N8OA9KkF/R08z/7lf3LkmfYJFDMabKLUji2ARf4vHHnruKXh8/xo0xpr9jRoiS0pCH3zEAtqtLF
	vn5Rcq6a87dr1IlrMc5QCkNNotaswcitPnBQ4=
X-Received: by 2002:a2e:e09:0:b0:2ee:88d8:e807 with SMTP id 38308e7fff4ca-2f3f88a6e99mr13197161fa.16.1724246012974;
        Wed, 21 Aug 2024 06:13:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbXz/zZNLpgYy914DPQE0G3jUIMMtBg2FW5l+r7EiJf3/VyOVgUXkDaaMO4gGanew6Bd0Rh41sjKlfIR/KxZc=
X-Received: by 2002:a2e:e09:0:b0:2ee:88d8:e807 with SMTP id
 38308e7fff4ca-2f3f88a6e99mr13196981fa.16.1724246012310; Wed, 21 Aug 2024
 06:13:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240819183742.2263895-1-aahringo@redhat.com> <20240819183742.2263895-12-aahringo@redhat.com>
 <20240819151227.4d7f9e99@kernel.org>
In-Reply-To: <20240819151227.4d7f9e99@kernel.org>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 21 Aug 2024 09:13:21 -0400
Message-ID: <CAK-6q+hx8MNeZCc0T-sTPdMgXH=ZcpLVqc2-5+psMCoQ_W0FxA@mail.gmail.com>
Subject: Re: [PATCH dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
To: Jakub Kicinski <kuba@kernel.org>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org, 
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	netdev@vger.kernel.org, vvidic@valentin-vidic.from.hr, heming.zhao@suse.com, 
	lucien.xin@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jakob,

On Mon, Aug 19, 2024 at 6:12=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 19 Aug 2024 14:37:41 -0400 Alexander Aring wrote:
> > Recent patches introduced support to separate DLM lockspaces on a per
> > net-namespace basis. Currently the file based configfs mechanism is use=
d
> > to configure parts of DLM. Due the lack of namespace awareness (and it'=
s
> > probably complicated to add support for this) in configfs we introduce =
a
> > socket based UAPI using "netlink". As the DLM subsystem offers now a
> > config layer it can simultaneously being used with configfs, just that
> > nldlm is net-namespace aware.
> >
> > Most of the current configfs functionality that is necessary to
> > configure DLM is being adapted for now. The nldlm netlink interface
> > offers also a multicast group for lockspace events NLDLM_MCGRP_EVENT.
> > This event group can be used as alternative to the already existing ude=
v
> > event behaviour just it only contains DLM related subsystem events.
> >
> > Attributes e.g. nodeid, port, IP addresses are expected from the user
> > space to fill those numbers as they appear on the wire. In case of DLM
> > fields it is using little endian byte order.
> >
> > The dumps are being designed to scale in future with high numbers of
> > members in a lockspace. E.g. dump members require an unique lockspace
> > identifier (currently only the name) and nldlm is using a netlink dump
> > behaviour to be prepared if all entries may not fit into one netlink
> > message.
>
> Did you consider using the YAML spec stuff to code gen the policies
> and make user space easier?
>

I will try to take a look into that and prepare a spec for PATCHv2. I
saw that there is a documentation about it at [0].

I did a kind of "prototype" libnldlm [1] to have easy access to the
netlink api but if there are more common ways to generate code to
easily access it, I am happy to give it a try.

Thanks.

- Alex

[0] https://docs.kernel.org/userspace-api/netlink/specs.html
[1] https://gitlab.com/netcoder/nldlm/


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589621A0BCE
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 20:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727773; cv=none; b=BpDEIF7s0pCz7zRy6uNSx+jBTjSZXYg4FVdj2+I0ulAW0OPtMdI9k0UVDCkBtJp5bRgm2nYUtkOgcewzkO4g/WEOHNASK+sJgThZjI3/Y/uSQ1IgOk10LU3AlXautTZfzZZ+SxuKF4KrvBrk18g/RmeECxHT+D5JU+S/17HkyFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727773; c=relaxed/simple;
	bh=kMZH+xLU9w/w+jErL7nAUzTIjTaixU+hbZdI5UMjEAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VLbQ2KTS9vWz1UtepDtQZrarB0VHCrzsSxaFfNE53o/vd+ty95zNSZHN9IADEwLo72i/gd7tPseN2m+8cPURtD4yiQOzb18b85N1Lu7rUpWcVpLZwXvpnuQ7EGMuc+8sk/AaOIZBF6BGMMioYyO/Rvb0AxzFVXwq6ZTGAKF+sEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MGpW3wqZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGpW3wqZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727727769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SVaqJm7tLoF1HWWT2ray8rPf/j7gC0aKBR8MDdz/TH4=;
	b=MGpW3wqZraBFuul1MtMDJThpJNLdF0TQbnX4rZPU5zmFMKKuhrXqXYz+mQ3atnFypJamnv
	GP5R2l/GIVnNto8MVZzDC7Pt8dq/a8ujYXe4dKD0r1SKQO8obHcfzX8oxm6DtE9CB7US9g
	mOxJWvhTcYwASEvsbtX8Yjg1atOUR14=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-SrYyYpHOOc66ruqz-8PyBg-1; Mon, 30 Sep 2024 16:22:48 -0400
X-MC-Unique: SrYyYpHOOc66ruqz-8PyBg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2fac931e7c6so12219781fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 30 Sep 2024 13:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727727767; x=1728332567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVaqJm7tLoF1HWWT2ray8rPf/j7gC0aKBR8MDdz/TH4=;
        b=fn68cIg/V5xbx3G2EsozDx0g4dCrUoeq5v4l263T0Gyjed2JZXFym9LOEc+0TsHlww
         iZgq1zwJJ+EgFDetbssfqqOf9i6mUF8W21PcMMOdsOCj3y02BubYQGAE9NwwsCsHGUP9
         TtY96lcj2pa1XGpCsJF8k99Uc4Yg41rmQV+tjqGxoRRF8VPdAorQVNLNpzRnk1xFBe5w
         uHAIOLtqJ/GwvZZgISw73h1T4G0KxPckuNsLioqNYp/DEnaayJ67i8JkdSxNOwesAcR6
         bMdvUjgL/TUUlACnIgGAYmSRRD5u8W3yuVa5UmN7Np7Kc6Puk5pNdzCcyfUV/zi6sTtm
         dbNw==
X-Forwarded-Encrypted: i=1; AJvYcCUkakLVy9AocI51mZihfNtd5vfZlBFBSSnr/LbWkAc8pLPndS7ZP+/Gs8f2Rqo2StYNaD2jZM4zRiHqpQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy7+MbEQu6u5vsAn7p03JumEMUxqfaC8rgi02FlQDzBdF0knXR
	fmZZpnigBUPnWOyQRdyta+flp/B4KNFW7XT+3b1wgymRQSvLGqZfRvzzqCQKS9wpCXjM7kOPAPP
	27VFBiZe1AZ8odjk3WjyhS6muN90WymbbtZEqO4LIlzHDvopyFnt+7ol2GzYD1hAvJmcxok6vEK
	OqqYR01VF/6zxJAXJ16zbTgYW1OXORfpDOL+M=
X-Received: by 2002:a2e:a58d:0:b0:2ef:2cdb:5055 with SMTP id 38308e7fff4ca-2f9d3e56140mr78848901fa.20.1727727766776;
        Mon, 30 Sep 2024 13:22:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOED+J7NIK671EAM5WNjgF/ITexh9huIebyGUKOqbFC6PtuFqTW3MFJhR+aLaTHS/W0tzN6SptNXddUS+y8JA=
X-Received: by 2002:a2e:a58d:0:b0:2ef:2cdb:5055 with SMTP id
 38308e7fff4ca-2f9d3e56140mr78848661fa.20.1727727766316; Mon, 30 Sep 2024
 13:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240930201358.2638665-1-aahringo@redhat.com> <20240930201358.2638665-12-aahringo@redhat.com>
In-Reply-To: <20240930201358.2638665-12-aahringo@redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Mon, 30 Sep 2024 16:22:34 -0400
Message-ID: <CAK-6q+h2-APvPUUDYgjGx2FzeJVkeAzH5Br+27A6bZyztfD5mA@mail.gmail.com>
Subject: Re: [PATCHv2 dlm/next 11/12] dlm: add nldlm net-namespace aware UAPI
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev, song@kernel.org, yukuai3@huawei.com, 
	agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	netdev@vger.kernel.org, vvidic@valentin-vidic.from.hr, heming.zhao@suse.com, 
	lucien.xin@gmail.com, donald.hunter@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 30, 2024 at 4:14=E2=80=AFPM Alexander Aring <aahringo@redhat.co=
m> wrote:
>
> Recent patches introduced support to separate DLM lockspaces on a per
> net-namespace basis. Currently the file based configfs mechanism is used
> to configure parts of DLM. Due the lack of namespace awareness (and it's
> probably complicated to add support for this) in configfs we introduce a
> socket based UAPI using "netlink". As the DLM subsystem offers now a
> config layer it can simultaneously being used with configfs, just that
> nldlm is net-namespace aware.
>
> Most of the current configfs functionality that is necessary to
> configure DLM is being adapted for now. The nldlm netlink interface
> offers also a multicast group for lockspace events NLDLM_MCGRP_EVENT.
> This event group can be used as alternative to the already existing udev
> event behaviour just it only contains DLM related subsystem events.
>
> Attributes e.g. nodeid, port, IP addresses are expected from the user
> space to fill those numbers as they appear on the wire. In case of DLM
> fields it is using little endian byte order.
>
> The dumps are being designed to scale in future with high numbers of
> members in a lockspace. E.g. dump members require an unique lockspace
> identifier (currently only the name) and nldlm is using a netlink dump
> behaviour to be prepared if all entries may not fit into one netlink
> message.
>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> ---
>  Documentation/netlink/specs/nldlm.yaml |  438 ++++++++
>  fs/dlm/Makefile                        |    2 +
>  fs/dlm/config.c                        |   20 +-
>  fs/dlm/dlm_internal.h                  |    4 +
>  fs/dlm/lockspace.c                     |   13 +-
>  fs/dlm/netlink2.c                      | 1330 ++++++++++++++++++++++++

and this file shouldn't be there anymore. Will be dropped in v3.

- Alex


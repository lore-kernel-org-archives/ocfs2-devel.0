Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3F97D406
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 Mar 2024 20:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710273819; cv=none; b=QwAzkQtT2W67jDeFS+1VChaO/no6LQMxS7vuZv5bJ+iATjBSO0pirNAam70NX1NV/ljV1HQQ+HfJI8sM4Mld+CRynoJjrr2u6JskzBD523P4ApMi1CEx4uqeN9amGev3x4771QIxooGszZK0RCHMQoyzqZKCacdqQCvk6l1juHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710273819; c=relaxed/simple;
	bh=Nn+6p/hmIw+razcPKWCs+SRAnYwR2JvVnyO+tYUgNrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iDZwLMmh28q6UgJhgmfL7Hs8GI5WfvqgsI/I8ONeOdwb7LWsD4k8hlRXJ0g0FIVdgPXt9TvDh0w1LA57WuWRcGkOtB9bjyMYw/KjeNTUGO6b+mO/BH5tZyKZGfRifFs+lYox+Y8JoCPNHKexAWgI0crY1q67OtUQCMkMWta7H0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QoHfs2JK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QoHfs2JK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710273816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nn+6p/hmIw+razcPKWCs+SRAnYwR2JvVnyO+tYUgNrQ=;
	b=QoHfs2JK1qAYuexiG4OFhBK3oSMwz6EO4ehVttsIa+Xqu6M9pfBIiFkTY4OTmZ5OjXwgHB
	89nBfUfxrmtXolfaBmFmqwRuLEDjvx2x+klx0yRdrzvAchCin3l9KWuLeyQEgJiogMSbw6
	WCqTJbw/VOPCY4r4bNS9rqpum/rwJIk=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-rfJTF8LAP0epQY6vv8TUGg-1; Tue, 12 Mar 2024 16:03:35 -0400
X-MC-Unique: rfJTF8LAP0epQY6vv8TUGg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d45f5bfdd6so7781671fa.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 12 Mar 2024 13:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710273813; x=1710878613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nn+6p/hmIw+razcPKWCs+SRAnYwR2JvVnyO+tYUgNrQ=;
        b=s/xGniezrMl9+nwQBlT68ziU+qsph85q+18uZCSDPqKgfA/idxszPW2zhjdJhLTItR
         3bA6akEfcotUiF5ytM69y1mqNCY/75it1pzPbvkxS9Ea8Zmqpdyt3WsryGCNR5lyRF7B
         fHlke0b7YUrKZaWZAnHqC5Z9wnLhlMoSkoywUWAOdtz2pEuzAIIuIIHnXenJfjj4LBCA
         NF36wv6T6I3r+5+uN28TdNjiQhwgtOCcWbs4aP/OKYqAg6Q5Ycy7CkjIU0oau8hE1E/8
         g3LXyxEmnZFJTXFN+P5jDzbi6RBQWjekB3+R5FIu4znzUYJNBGu4BmdTk/BcddrQmC9t
         i6Aw==
X-Forwarded-Encrypted: i=1; AJvYcCXPHk4Iade/K4i8+XErp+OFtZ7Cs3/hH+kdNiH0bxBxEch3NO/gYz09iTmAK+gNnhUeW7/RSI2SSpbXwEHoxpiQEH+BrNAe8FjFz3w=
X-Gm-Message-State: AOJu0Yw535i5GoZSS03Ok0OqHTvXbZ/glUGronYBgktOUd3n9JiwiGK7
	+KtFVOspe7QOLvmV+cxCMGJAk6KE0IZEt6INoysvoI2Hi7j5DDzUYsEb7QU/eXE2NMpDW0k0laz
	b5P3AJyPJzpU7BwApxk3Bm4CiTGkeqvjCa55U2RdNLBW5ATCaZdsaimWsbY2PRPEHKWQ5MncXC9
	1S2pw4ZqvG3sITvvJLjlEXCMYbvBJIEbDw+zI=
X-Received: by 2002:a05:651c:b0f:b0:2d3:1043:749a with SMTP id b15-20020a05651c0b0f00b002d31043749amr8461014ljr.21.1710273813736;
        Tue, 12 Mar 2024 13:03:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxmpPZsV05MBhF0gOUY8ImwCkxanwSe6nkpIgooua/tzfaK2qov+FBHBpWWx4FgFTfj5fxdGsoiC94TGXxl2U=
X-Received: by 2002:a05:651c:b0f:b0:2d3:1043:749a with SMTP id
 b15-20020a05651c0b0f00b002d31043749amr8461004ljr.21.1710273813450; Tue, 12
 Mar 2024 13:03:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Ze4qSvzGJDt5yxC3@valentin-vidic.from.hr> <49396145-712d-44eb-884e-58eb19b1f4f2@linux.alibaba.com>
 <Ze7IiZmlhRaOgdhm@valentin-vidic.from.hr> <CAK-6q+jFv8tK4rF-xY6okTwhK87zMtOKP6fthzCQ-H8-4q=wbQ@mail.gmail.com>
 <Ze9bIiT3rAWTtPJp@valentin-vidic.from.hr> <CAK-6q+j2UDh0mi0KUTdtsRE8pj4+tuw_SU+yjzjsR3GCLURz=w@mail.gmail.com>
 <ZfANyOkQh4SgXoty@valentin-vidic.from.hr> <CAK-6q+hBa08LoAEhsdiiG4DarCGF-CWy41zDjU3zB81P7hHx1A@mail.gmail.com>
 <ZfCg6o3Kmkq78SIG@valentin-vidic.from.hr> <CAK-6q+j8Ag5yj6pn0P4wC2kRSNMVaHGmVY+G6+H5aYD1-ygzSw@mail.gmail.com>
In-Reply-To: <CAK-6q+j8Ag5yj6pn0P4wC2kRSNMVaHGmVY+G6+H5aYD1-ygzSw@mail.gmail.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Tue, 12 Mar 2024 16:03:22 -0400
Message-ID: <CAK-6q+iWzE_QgH3sYK6v8JS+p9KxaEGihoe-6WD1-pfz964bCw@mail.gmail.com>
Subject: Re: ocfs2 mount error
To: =?UTF-8?Q?Valentin_Vidi=C4=87?= <vvidic@valentin-vidic.from.hr>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com, 
	David Teigland <teigland@redhat.com>, gfs2@lists.linux.dev, ocfs2-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 12, 2024 at 3:55=E2=80=AFPM Alexander Aring <aahringo@redhat.co=
m> wrote:
>
> Hi,
>
> On Tue, Mar 12, 2024 at 2:37=E2=80=AFPM Valentin Vidi=C4=87
> <vvidic@valentin-vidic.from.hr> wrote:
> >
> > On Tue, Mar 12, 2024 at 01:55:54PM -0400, Alexander Aring wrote:
> > > I was able to reproduce the issue and sent a fix out.
> >
> > Yay, thanks a lot for testing, I can confirm the patches fix the proble=
m
> > for me!
> >
>
> Then you can reply to the mail with:
>
> Tested-by: Valentin Vidi=C4=87 <vvidic@valentin-vidic.from.hr>
>
> that would help to bring the fix upstream.
>
> > > If you want to extend your debian testing using different approach
> > > (not libdlm) this can be done by:
> > >
> > > mount -t ocfs2_dlmfs none /dlm
> >
> > I tried that but fsck than fails to make a lock, so I think ocfs2_dlmfs
> > is only relevant when used with o2cb cluster type instead of corosync.
> >
>
> Yes, I think you are right. It is a replacement for
> corosync/dlm_controld handling. It seems I had both setup working at
> the same time, but it still uses kernel DLM locking.

It also requires a ocfs2-tools tool at a specific location:

/sbin/ocfs2_hb_ctl

maybe this is your issue why it wasn't working. My kernel was
complaining about it because it was missing in /sbin/

- Alex


Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964B83537D5
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 08:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808105; cv=pass; b=ZtHkjgXMjN9nfq8FhrKVEWJ/y1TGZVe2XCmhE1MIUMUsMdKqP1g6riJhWZYqdmylJQZ8cCnEt/t4tSF1sRITV5jDdCUdPZ8laDfWp2jRfc0MMGqJfjmvO9XEmJ1YNam2veGzymoO3DzYKjMkyvlI5syFHFk9HWYfF8h160K9hbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808105; c=relaxed/simple;
	bh=/Yc6vgah8TkpPGbCjR8i99D6TDxMyPvwt8bh/TWD1+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZEk8tnIm8bBfPLr6bGerO5M4pIHlM61KwBZdWgWqA82SrTGxLkFGGAoALvOhZ+pAGw4g1J0YPqFM3EAPKfYwhNgjHeaHSUqvIisLww89YVQacrLJ/pjAnVmAdvzud8QrKdB4iC195ceDZAyqlC8KNs0aLoF8d3nPdJODKpaAFdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1VxCGf+; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1VxCGf+"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8da8ae314deso23081685a.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 01:01:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775808103; cv=none;
        d=google.com; s=arc-20240605;
        b=H8cYXOQqMOZB1h1EnWXsMwdFjd8qjaJhs9NmBJNSQJ/3QMX5Ta9hbVwbc2AOpjWe+q
         X5ZlmeJospQacpS0NOivbWhVvEuXf93dR6m6ARg3nKvCXyXRzvrXk2wvjNvUeVdbPyhn
         D1auIP0agk6gyDf/v9qOxZpw80XFN6S2FLBPbX7CBPkBYE3jBem8iDNqCCAcB0Tm5FZn
         vCOOHMMsoqCj1Dw5Zeo/fot5abM+icatXEZoWb8tN1DZfr7VCfXHKDGlp9Q2b+HkG95N
         h7fGwv2JRWmmW1LlwbH9ib/yCZPuGKD0cu+r3u6uEDI1o8ZtsJdAbPzg9/AGp30eRSGC
         QpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XHwAwZJ34fHwTUT86MVvAndeny4bZKfD64hDKUnMj/g=;
        fh=8Z29Kn/Abxdg2txgAzWtbq5yRPorzLYHGlADsKc3G1g=;
        b=U5vNmcbgJ5zOEbyNUoXweu60Alerxpy8WUtZbxXy+pgD1J2oYJM2duZcag5n88E0mg
         xrtStEfb7aAQwPQLnuEqUHQwm6pc8TSa2LiVo1pZh1FEnxCVxps3YikccINPS7bhXEzz
         EcloP+etMr/AgKPcbGC+nfx5myGR3Ov8pXD8O+gDKrQjYPZ6q66+kLK44mRizRNUb8dP
         dOGxca/Jq/04dhnsLQkXVejGvf+Djd7z90QbajABCX5t8I8G/9iME8qsNEmcjEr7Trgh
         VWmZi0zC8TB7dlQbUb5XiJIv1VfhICiQunhd2vwZa6jooCPq4yM6MBZv61BuREUSEGle
         8ZfQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775808103; x=1776412903; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHwAwZJ34fHwTUT86MVvAndeny4bZKfD64hDKUnMj/g=;
        b=K1VxCGf+7LniMdoKt2kYIn29QjyPAGUy9ZxGiGXSU9SwWRss/D5cOZa6FAM5ULb+dq
         DMI+gncQrRch1Op47BZR1TO/PDdpVDMm4hE64CbW1H8BI/+vIB8Jg5TR96FxnqiLANXe
         gEhmVDbpdekN+toRPK5GxIHjiThGnw7jUjU769xIl8XqV740VLvmloRIJc4bB0HIYdGB
         DMI4gdjKPMZWNveuEoiJ7iUzw+x5dhUKaWIXfaGCqSAkdyb95qGILkgX8SvYM/ZEGppT
         kEG8fVMNcMUbXd4m56MmsvbKrbtYTsjbOPwY7E530xYB+oAdpE8upb+h1VpDbage0E/7
         gyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808103; x=1776412903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XHwAwZJ34fHwTUT86MVvAndeny4bZKfD64hDKUnMj/g=;
        b=qc2Jh4FqJj08DBEffjMmU4rzWXft1xEXx6cDetzVsvEoaX4VnE7O+az6Gs6R8wuX44
         BKtHFH/IGKwWK5hZRJrAh/vvhKOwap1+0Ge7RBe2E3pZ1GEAZc0ormOPhuNBr8QSzKDG
         0oFrD/68YDdYWENVIF8BOC9qK4mSV+/+ZxJUo6MBiSRSJUR+df7ZR4mNsiHP0Vp2UMGj
         l3aJ6xhUjyHx6RU0qzlWzxp2z1dlqt8iLanD6mDHowfaGtJB1cxDaxAUCs7gw/QHQaGU
         ItmUjLg5B1c5sr50uA4i0C29RpluYbYxHxmchwBqNah8j50tkRXduxobF81JlMLJjGxP
         9czg==
X-Forwarded-Encrypted: i=1; AJvYcCVqConrY6PoLKwOJbx28WzCtkMXPvD3//VjxqzfECOj2TXcvP2MPyfTxEflJGA3myFAGhyYaUx7YXxPjQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwCglNwX5WfTm9CvIW8rso+kYGa1MmuYzp1+mGr4kOxOqfzFQx4
	lfSNgMmrDru1iSTrf8d9GIBgSmpvTdw9JQcyEq0voLcPXpgUOQ26+zMIBBQTr3GOwK7QWNtlnsN
	bUeYBaIxZPezxSXAR9xxJB+nJK37vNZv1LyDEoWc=
X-Gm-Gg: AeBDieurK8/KM1Nw9S1M0Q0WC/QxO5tMx9B3HCCk5uPa/PV+9FHypiEcCS5ZNWY02dZ
	8TQJaIcSoPVOCLfRo7l085yXJytYHMYr8rQsNWEqznvmXEUA827+6n8j+rnXZ9MWbM9VdLACHUk
	jw4wHE6exeRAPkviU9gQ50hNrwtFfcg2l45q33JBtoepjOU97B64i+sT91+HcphOmlstHLw1RLA
	Oap1ZRUcJCqWGMQlx5uwEiAsbPkL24LRMrydPZ9t5x74i2EFu2XmRrjkKELlQoSweLvPbisBHlb
	v+BPF4ddeDD54TgNLvxbDWA=
X-Received: by 2002:a05:622a:351:b0:50b:5286:f757 with SMTP id
 d75a77b69052e-50dd5cf408emr21488891cf.4.1775808103504; Fri, 10 Apr 2026
 01:01:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260403035333.136824-1-tejas.bharambe@outlook.com>
 <20260403122947.2afc337b5333fb1990a78a65@linux-foundation.org>
 <JH0PR06MB66320ABCFAD8F239FE5112B2895CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <20260404175040.40a746040ddb0cb5ce347fe3@linux-foundation.org>
 <JH0PR06MB6632F1A4381AB798FED980CE895BA@JH0PR06MB6632.apcprd06.prod.outlook.com>
 <20260408131225.a37cd581ca47b3512a4219bc@linux-foundation.org>
In-Reply-To: <20260408131225.a37cd581ca47b3512a4219bc@linux-foundation.org>
From: Tejas Bharambe <thbharam@gmail.com>
Date: Fri, 10 Apr 2026 01:01:31 -0700
X-Gm-Features: AQROBzC1i7kYsHHSDBDyr4hc1Srf620y6vG7I3HHQgVD_622ygA-RxpXMNdTIVE
Message-ID: <CAJL2up6TkQq1JXUDvhwC0MnwGyXMzr8hU8iCQoYzz8HwjHdd-A@mail.gmail.com>
Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tejas bharambe <tejas.bharambe@outlook.com>, 
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>, "mark@fasheh.com" <mark@fasheh.com>, 
	"jlbec@evilplan.org" <jlbec@evilplan.org>, 
	"joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com" <syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I see the concern on using ihold/iput on performance. I find Jospeh's
suggestion valuable. Let me send in a new patch, I will just save
ip_blkno as a plain integer, that should be zero overhead


On Wed, Apr 8, 2026 at 1:12=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed, 8 Apr 2026 03:50:17 +0000 tejas bharambe <tejas.bharambe@outlook.=
com> wrote:
>
> > Hi Andrew,
> >
> > You're right, I missed that scenario.
> >
> > The inode can be freed if the file descriptor is closed after mmap() an=
d munmap() races with the fault handler.
> >
> > I can do one of the following:
> > 1. I can skip the trace firing when VM_FAULT_RETRY is set as I did in v=
1. It was changed to v4 after Joseph's suggestion to keep traces.
> > 2. If we want to keep traces, we can use ihold()/iput() as shown below:
> >
> > ihold(inode);   //pin inode
> > ret =3D filemap_fault(vmf);
> > trace_ocfs2_fault(OCFS2_I(inode)->ip_blkno, ...);  // safe, refcount he=
ld
> > iput(inode);  //release inode
> >
> >
> > Which approach do you prefer?
>
> Well, that's down to the ocfs2 maintiners.  Me, omitting traces doesn't
> sound good.
>
> But we should consider performance implications - this is a fairly hot
> path and iget/iput are a little costly.  Perhaps there's a way to avoid
> the iget/iput if tracing isn't enabled.  As long as we handle the case
> where tracing get enabled immediately after we've done the
>
>         if (tracing enabled)
>                 iget()
>
>
> > Thanks,
> > Tejas
> > ________________________________________
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Sent: Saturday, April 4, 2026 5:50 PM
> > To: tejas bharambe <tejas.bharambe@outlook.com>
> > Cc: Tejas Bharambe <thbharam@gmail.com>; ocfs2-devel@lists.linux.dev <o=
cfs2-devel@lists.linux.dev>; mark@fasheh.com <mark@fasheh.com>; jlbec@evilp=
lan.org <jlbec@evilplan.org>; joseph.qi@linux.alibaba.com <joseph.qi@linux.=
alibaba.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; =
syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com <syzbot+a49010a0e8fcd=
eea075f@syzkaller.appspotmail.com>; stable@vger.kernel.org <stable@vger.ker=
nel.org>
> > Subject: Re: [PATCH v4] ocfs2: fix use-after-free in ocfs2_fault() when=
 VM_FAULT_RETRY
> >
> > On Sun, 5 Apr 2026 00:30:14 +0000 tejas bharambe <tejas.bharambe@outloo=
k.com> wrote:
> >
> > > Following is my response for question posted on https://sashiko.dev/#=
/patchset/20260403035333.136824-1-tejas.bharambe%40outlook.com
> > >
> > >
> > > No. For ocfs2_fault() to be executing, the file must be open and
> > > the process holds an active file descriptor. The inode's lifetime
> > > is tied to the file's reference count, which remains held by the
> > > file descriptor for the duration of the fault handler. munmap()
> > > can free the VMA (decrementing vm_file's refcount) but cannot
> > > free the inode as long as the file descriptor is open. The faulting
> > > thread cannot call close() while it is inside the fault handler,
> > > so the inode is guaranteed to outlive the trace call.
> >
> > I don't think that's the scenario which Sashiko is suggesting.
> >
> > Suppose userspace does
> >
> >         fd =3D open(...);
> >         p =3D mmap(fd, ...);
> >         close(fd);
> >
> > Now, that mmap is the only ref against fd.
> >
> > Now, suppose that userspace does munmap() while another thread is in
> > the fault handler.

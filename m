Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D3E37B3F9
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 10:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775816608; cv=pass; b=ndptkGICfHfl6FS4b0P3H4UgSxlUUdYOfdzLNyQpmcRRU3nuCWJFjWffh69HYoFqq4mMNn369JlKMXrQNate0oeRl8q9yyK+qPeUKXWFOpPZvIvR21Hm4YdrqOVcOPlZFwSLhiGvXTz9vnckgh4OtFKwfgnAOe2mwaKm+5Pttc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775816608; c=relaxed/simple;
	bh=dKd8E2RW4dTFJYLfEwnAH7Aa0NwmdURo0S7LJBypZcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lt3HNXuzIKCQpbY3bFSdXVa3illZkMSDOuykG90Q5K87QsVun14EsALqH44njudTrnqbdKeqSvnrpawLjpFjBOicCIXRBSe+/H3nxPwfOnK59BnDvrr2npZluFItEQBLLEJuXzk1OWl/7iin/KFNVYxWtZ9IhdMg5b2z7TH78Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTGloo8y; arc=pass smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTGloo8y"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8d6654f06caso26324585a.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 03:23:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775816606; cv=none;
        d=google.com; s=arc-20240605;
        b=fgq3aCB/BwXsRsUKoAu8oPAhC7wePx8cBvsM1P4Pmz3PEvscoxjInapzBf5s84knXt
         NPqsr6mr9ljSCj/u9cQaXeVs9F2woZsderOpxl/cBiiUQfOVsPMEXf8GyE9qbDcPV1I8
         6hjdXXZI3EvrqYxi2aFbBOxA5sUhUJjfOHDewDN3p115gEe/lHdl13VWrNH7ybnivyYE
         1AtslEa1j9gRsFQP16sxKQ9v9NTr7d12+gi4EBcIgqL2b4mYotSFChEiLP4/03/I9Nm5
         Xfe11zJm3Q3iP/QuBEhb/Tfbosfpw3oc161TZHI1ckpZfDzjDLWW4sgN8Tz9/hfok39l
         tjuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lNYAisjpp27qjigxRpRaF9Cz5SeEGkqLoywjYJnMoY4=;
        fh=67b+z4RfWs8CY+t62f7hQyaf67yAIbmlOLeJu5naXbc=;
        b=OnAfzRk1xXXks9Btai5Ohoq4WyqnDTkl5Qey3beegbSjsRL4D9S6u8QE/qjOjmW2bM
         3780DTgMw+KwaX9hyvNchduLFWnn74clS6XNydjxl3fDYpMB5zkbrHVSJGuEYDcX0ofz
         SizST5qaKf17ilRfmMElM/MniJE172hcDXSYmgk8IJfiOow1PLPVWz0U4/T+aSzSWe+Q
         Wz2zzKHM0a7wjK9uBv8MyPI0+CiijyR6zHrt/FeIev2GxYJ/y8aJ1H/wD5uKk/2iJZ9a
         xR1mciVqPc74UoBz7MJwhvCm+p7f7I6JO3yslH3+ze2Aqte9fR8vJeuvqOzx9+F9SLOH
         pe2w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775816606; x=1776421406; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNYAisjpp27qjigxRpRaF9Cz5SeEGkqLoywjYJnMoY4=;
        b=gTGloo8yZK5bR0i8+zzEfEKb+1BOme1536UTwREtbKLUp9n6Rekl45qGOSFIUCxxnp
         xcSEXSKIXrEH/pSgQgtHWpFhg458xzsZ6cwtjefZTb5/z9Ttx43YMYSlW8/+mmYsZ/YH
         x5vaTWZQ+7diNP7RmHx0H5lZNszKE+W3KmBnlgM3JxOQ2L+2b2cu/Xj7A+KhuK29/JfM
         PT5OdxPuB9enOUCGKddhs9KIOYD6VRIxDQsuly173ZKHyl2VViAmWw1EpwKqPdq1e6rh
         wYEBta/Y43y9ZCwX9E3Nv/yb6YHcm3KYTUv5uRtjaSJzt7P3BAyHoznMxCZw+rtvsTVF
         tTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775816606; x=1776421406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lNYAisjpp27qjigxRpRaF9Cz5SeEGkqLoywjYJnMoY4=;
        b=LYx9pMvxNABraxnYd97F3mh3SXsLNsFIbqI7BqFZOiybVehyvQXCZXalp1qBks6uM9
         4nSvy3q8BaBPfqaSMRSp9WZOuw/WXCfdKQs74n/w4RIzWl58eRPM/UerAVD0KFADS5VL
         ECp8jLRtmAQCp8Hh9nKH9/kDQjQNKnA/oSnWdpr8ENjx7uEavggsAlnvD6QH6eTcjk3m
         XADa1Ft8SGEjfwRBcpEky5ZOgkZL2dpLDYYASBwDSCiQfkgm1sp2cQGRaaLGe0uNKN1G
         1j5TtPM9U2B82NhC77aiqiVXt51Wi2citiLRUCSgeO/K45iY0pvvHpdD6yX99b9Z3Xk+
         SosQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBqnTHxkiMrGeW1Vb9rC4740mFcPGnhPR2X6Qu4sT2xHAiaxfOqLZkaEtN8wiVMnJrwd9c7DafmYXmhg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHSZiXVXq1wOEVnsMhD8moBz5nt0Mr86krpjTmx+EwPtGJQojV
	uqSn+jRJjlyVBSD3DplI8aRy3W/gMmkEMb7K2QmynFSA2uKa5ljwFnRAw4SYN1WkVxAcditq22y
	++tYMB9bj4ZjaQ2weigvrwOvrIQqHJxY=
X-Gm-Gg: AeBDieuC6lcj9iIbWh/Na3oLqxytt9/lUi58zUidXpi8+p9IZBJUceYcRSCK+FyiiaV
	DeCWpI07AbRf2YelUFEdgeyerHGj0sWUzJmAwMQRoy6nAVbpvATvYwMkdwOS3NJ6V/HWEr1Cr6D
	xxJgsBZdmT9Rx7SXP0Qf55HidDdBuksoVv4qyM2lKtRYzxERkJV2AFAfCj1GWYdUOcCYU3bdGfx
	1cFZdIiKCeZcC/ppmGJYW6T1nScguPKvhfjm8Mr9Zx2V+bmC4WKxP4YLe7C4W6QBLa+qH8M0Ppo
	Ye9I6iGCMhJB9WXnisNxK9RA5p7IfpVuHg==
X-Received: by 2002:a05:622a:34f:b0:50d:aa1f:68be with SMTP id
 d75a77b69052e-50dd5bf0dabmr26733861cf.4.1775816606438; Fri, 10 Apr 2026
 03:23:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260410083816.34951-1-tejas.bharambe@outlook.com> <f6a98534-32d9-48fd-a2ff-da57b0e478a6@linux.alibaba.com>
In-Reply-To: <f6a98534-32d9-48fd-a2ff-da57b0e478a6@linux.alibaba.com>
From: Tejas Bharambe <thbharam@gmail.com>
Date: Fri, 10 Apr 2026 03:23:15 -0700
X-Gm-Features: AQROBzAyHEEypp9YEVdH4RZNxVHsTAleeZGeO6mRwKrZSmjKpATdpIOcwWsVUHM
Message-ID: <CAJL2up5yz6q1UAqPL3wmdrBxD4t2GZNMyTh46Gu=UZLFv=rS1w@mail.gmail.com>
Subject: Re: [PATCH v6] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: akpm <akpm@linux-foundation.org>, mark@fasheh.com, jlbec@evilplan.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com, 
	Tejas Bharambe <tejas.bharambe@outlook.com>, 
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you Joseph,

Andrew, does it look good?

On Fri, Apr 10, 2026 at 2:36=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 4/10/26 4:38 PM, Tejas Bharambe wrote:
> > From: Tejas Bharambe <tejas.bharambe@outlook.com>
> >
> > filemap_fault() may drop the mmap_lock before returning VM_FAULT_RETRY,
> > as documented in mm/filemap.c:
> >
> >   "If our return value has VM_FAULT_RETRY set, it's because the mmap_lo=
ck
> >   may be dropped before doing I/O or by lock_folio_maybe_drop_mmap()."
> >
> > When this happens, a concurrent munmap() can call remove_vma() and free
> > the vm_area_struct via RCU. The saved 'vma' pointer in ocfs2_fault() th=
en
> > becomes a dangling pointer, and the subsequent trace_ocfs2_fault() call
> > dereferences it -- a use-after-free.
> >
> > Fix this by saving ip_blkno as a plain integer before calling
> > filemap_fault(), and removing vma from the trace event. Since
> > ip_blkno is copied by value before the lock can be dropped, it
> > remains valid regardless of what happens to the vma or inode
> > afterward.
> >
> > Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f
> > Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
>
> Fixes: 614a9e849ca6 ("ocfs2: Remove FILE_IO from masklog.")
> Cc: stable@vger.kernel.org
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>
> > ---
> >  fs/ocfs2/mmap.c        |  7 +++----
> >  fs/ocfs2/ocfs2_trace.h | 10 ++++------
> >  2 files changed, 7 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> > index 50e2faf64c..6c570157ca 100644
> > --- a/fs/ocfs2/mmap.c
> > +++ b/fs/ocfs2/mmap.c
> > @@ -30,7 +30,8 @@
> >
> >  static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
> >  {
> > -     struct vm_area_struct *vma =3D vmf->vma;
> > +     unsigned long long ip_blkno =3D
> > +             OCFS2_I(file_inode(vmf->vma->vm_file))->ip_blkno;
> >       sigset_t oldset;
> >       vm_fault_t ret;
> >
> > @@ -38,11 +39,9 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
> >       ret =3D filemap_fault(vmf);
> >       ocfs2_unblock_signals(&oldset);
> >
> > -     trace_ocfs2_fault(OCFS2_I(vma->vm_file->f_mapping->host)->ip_blkn=
o,
> > -                       vma, vmf->page, vmf->pgoff);
> > +     trace_ocfs2_fault(ip_blkno, vmf->page, vmf->pgoff);
> >       return ret;
> >  }
> > -
> >  static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
> >                       struct buffer_head *di_bh, struct folio *folio)
> >  {
> > diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> > index 4b32fb5658..6c2c97a980 100644
> > --- a/fs/ocfs2/ocfs2_trace.h
> > +++ b/fs/ocfs2/ocfs2_trace.h
> > @@ -1246,22 +1246,20 @@ TRACE_EVENT(ocfs2_write_end_inline,
> >
> >  TRACE_EVENT(ocfs2_fault,
> >       TP_PROTO(unsigned long long ino,
> > -              void *area, void *page, unsigned long pgoff),
> > -     TP_ARGS(ino, area, page, pgoff),
> > +              void *page, unsigned long pgoff),
> > +     TP_ARGS(ino, page, pgoff),
> >       TP_STRUCT__entry(
> >               __field(unsigned long long, ino)
> > -             __field(void *, area)
> >               __field(void *, page)
> >               __field(unsigned long, pgoff)
> >       ),
> >       TP_fast_assign(
> >               __entry->ino =3D ino;
> > -             __entry->area =3D area;
> >               __entry->page =3D page;
> >               __entry->pgoff =3D pgoff;
> >       ),
> > -     TP_printk("%llu %p %p %lu",
> > -               __entry->ino, __entry->area, __entry->page, __entry->pg=
off)
> > +     TP_printk("%llu %p %lu",
> > +               __entry->ino, __entry->page, __entry->pgoff)
> >  );
> >
> >  /* End of trace events for fs/ocfs2/mmap.c. */
>

Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204553ACEFD
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 08:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775810298; cv=pass; b=M60rnHH636/lcZOZ+a0vudaYIpwCQE6Xap7dCVBHPSuPYCFPHUUDA5SJ6DLBOUEtRd2jR5hpNtoYUrL97+L53sODqO/3VrXN9LmJBIOj617w3gpHHnTgxfoPXfGqLuotIDek+xG4Xr99HAeK3V9vGO+BlRSphJPuDK4W0Jzi7VM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775810298; c=relaxed/simple;
	bh=Zts1F9Fz8vi0cMtrgVlEV9iCSgJut3cN1xlTncf6+zo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQOUpKrH7XrJOEDr9urD7VcB/d1f+Sc9+d80cVerWw0PQSmBcs4qOEpgqPNYbq3RpZYs0AKUUD3h5S8a36Z78XvZ2E5bVsATf4jVN84/2Il6tik6PW71075lpVuz/1Wuvx/H6Z4w79FGdYsYP78hMQOAqHVOLpgsBgPtBCVh0dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKcgszbL; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKcgszbL"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8d5e1ca50ddso20989085a.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 01:38:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775810295; cv=none;
        d=google.com; s=arc-20240605;
        b=iEKnjr3B1H8O73iz/QzaGg8HC/bbf7wNrdkbZQLKn1AeG20qhBEN28PgbWoS3W6B8c
         JsmRDDkRq1jinQPVk1D+92dMByS6dIc/a1+okswSKpbDch2ozs31B2Tm+zmsCDqNdwJH
         abcEMLUuG3BMLby+jpYy9uSwQJIHVXISTtcCGBAp7UQFUzhN+HILFV+G1flCDWn2lufn
         wuqqMnc3CMBHE0CKQ+gB+Z0Snn6Yyl3IEfAYIF65Cjo5bpXgNCqWwQQ55YZ94408rDjf
         PpN+y6i/D4NUE/L7r/iJI1AGEcRRmr+YYr2RmehWTHee7flDX776DpoBSZcP2U938+Zk
         4NOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sIZakez1OsopEjxLc5Tht62g/xQSMYT8hI7NHcXnFHw=;
        fh=Zt+3amzY94YlNGDKu+5n89l/EyJRiQ55hBV2Pimy6AE=;
        b=cUiXFqrKHDYhGdc69GVK6f5+taMTKqFDGtviMcayU7gzuYWuK6wMqQXUS/QDrpzhgi
         FrLWaeutlbD7aUSpb5jo9M6Vl1Vo74rfarOiQbR1FKeyrJmaI2Ot9/lWvrzEfjB8z0IU
         uzoVevQpX63MITPOXQW4D+Uxuzt5sv6gUUwAJ9JScp/PBllT7NxSKIcZCro5H6cHNhHE
         H5/juUqHtg7C0aW/xC/93Z6YETmkXVz2H25T+QC7dRFiEjkCABf6bgpCR1RkFTbjKwVV
         XbZjcVWat/IKC0zVeWozrOfsiA0Bi9WHRc0iK5wptis3/OrAZetLvbVVSV+xSy2RXkKK
         /WoA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775810295; x=1776415095; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIZakez1OsopEjxLc5Tht62g/xQSMYT8hI7NHcXnFHw=;
        b=AKcgszbLRY56gdg+FobOUT7Rfr/F27CS6wuzUcID79pGtJAfJbkCCXwOHWtPwYWdP6
         j3UcLSkUq98gj7gDxJ7ILvI6dTB4Lq3fQ94IUhMApDEtGfEzxXxhzbIInqto94K+iehT
         0/4TRA8kFZcUAq/ftFYm9PmrnUUorfPqyqkCz3YIqcYnF9Sjf4lZTSRLZ/d3mF0QXkwQ
         OliEPA3uaU+m6NkiKRfQIs7/bm8q4SOmZdMxYvDdbdWzHl+THRQtyYKjy+S+wKLMpUrK
         Qo7oDyPyP3KwAI17jCoQzwPQiIWlTzJA57gFHnHT4jWGvH3KdUAsMMODzCTtg9G2vpCY
         Evbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775810295; x=1776415095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sIZakez1OsopEjxLc5Tht62g/xQSMYT8hI7NHcXnFHw=;
        b=SYx6RPR/wf9a7Q4Yx/gEUusJCTcUJpE5vbMWdSoY+2uS7pzSwdZIyVrNKwX7tJuRZ8
         fnsHiMqMz7Lg2SeJdmpr5F+rxC3FZxXLUiUci1b+h+o8+OiOZ+U+zh62BtEsxIvXZxGc
         76Tws2RF+pWS4ZL4wbc4MTomWDlAfj46qb1tTu597Aqx23+Hy8Yzfpr0nc2PDed0umk+
         1HocVg+1ofvA3xWBUcyeSqch7AIfav/xJ/2QYIq62VKCGHybLJRxMVDSuTA59Io7yUtP
         e6d8N0l78imE3UeyYE3lB/nDqLyD7WcvNDDCP1KgQ/xxF7uxYFyGU+EXqZplYh2I2wtk
         qD6g==
X-Gm-Message-State: AOJu0Yyn35Bt39lQAy6GBWVa1IR3ih3CltoP0TNBFOn5PTrfdp/NVBuc
	OnnW2Xedh1RYjPxIJXoi7H0HFxGdrL3n6mGFVkzHfePJNdQUeYjGQ8RbS0kJBf11KX90bVV2YWn
	00EvRo564Yh32bDZb6nYrj+fAmA+iL5w=
X-Gm-Gg: AeBDievmUy5WHW6xzziHqjXgrvvZzmSawv8iFsn7lXUAtTEFOQoMNdndcDGu/hMHejP
	fxOBFN3E1Gh5AiwMkoPLqUeRdhPgkTLk+1VlXTAS6MwEpZNSpu5K4RfYTqB3glbw0tvKZ5sT3cc
	nhsSx0qSQEBqsSUMSsreKFJAtfC7w4dX9vKhlxWlBGmjBH7+sXs26Inen79eJkZwBwavcNFRUl+
	OYaPNPwvc88D4yV+ImkbtBTbGIwljRoA/B4R6ZtyRR+wPfM/7BRzei048G+Dhb30UzzDYdPetoN
	acuB/Tf+3g/NZ0JIATQ7sZ4=
X-Received: by 2002:a05:622a:1393:b0:509:2b5a:808 with SMTP id
 d75a77b69052e-50dd5a9128bmr25158941cf.2.1775810294904; Fri, 10 Apr 2026
 01:38:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260410080445.29422-1-tejas.bharambe@outlook.com> <98810912-b89a-4409-8602-7f7c4a2074ef@linux.alibaba.com>
In-Reply-To: <98810912-b89a-4409-8602-7f7c4a2074ef@linux.alibaba.com>
From: Tejas Bharambe <thbharam@gmail.com>
Date: Fri, 10 Apr 2026 01:38:04 -0700
X-Gm-Features: AQROBzDtY8yrstrhRJP82OL2jXuXJBVw24FRNzBHvCRC_ibc7w5HbYZzBY_JW1A
Message-ID: <CAJL2up5epdHZfH-UCTt+QyHR7LpDke1ddwurjepQU16gnYv-iA@mail.gmail.com>
Subject: Re: [PATCH v5] ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com, 
	akpm@linux-foundation.org, Tejas Bharambe <tejas.bharambe@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Noted sir. Sending in v6


On Fri, Apr 10, 2026 at 1:30=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 4/10/26 4:04 PM, Tejas Bharambe wrote:
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
> > Fix this by saving the inode reference before calling filemap_fault(),
> > and removing vma from the trace event. The inode remains valid across
> > the lock drop since the file is still open, so the trace can fire in
> > all cases without dereferencing the potentially freed vma.
> >
>
> The commit log should also be updated.
> Also do not send to stable@vger.kernel.org by default.
>
> Thanks,
> Joseph
>
> > Reported-by: syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Da49010a0e8fcdeea075f
> > Cc: stable@vger.kernel.org
> > Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>
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

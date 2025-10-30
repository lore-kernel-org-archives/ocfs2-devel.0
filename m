Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637F533557E
	for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 22:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761862093; cv=none; b=tv65EaSa4qXGSmTc8jWe5YDU6TGNToXoO0H8B+qsVpYXPiCx/vq399F5GkmwQWNzT58y4jjDJ9RDNQxJyGkgZibCeSs3iPPVFtSb/2qKu6y/hSL18hsZyshEfkkaSe8jdtH+bgj+lu2pSy8kzr9FInyDiRn9zPG74ehQ1sKgIBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761862093; c=relaxed/simple;
	bh=7ru5F1kwzreOleQxP1/PtdtLEReJTNcVqATHU/+UTRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O0TsrfRuWyNrhJYc+yDWh3gk6XGAEanlwN2alrneeNDDkKafBYxngBVVjQq3OfvbPdpWQcPX+ORZ739jn0tr8EDDXICqwxFuQ037BOLTVIqW3ymQU5rr/zD5HGqtY9EhoCZX8jHBOp+W5n7tPKPR4FuboLM1YcQI8fCoKsiDsI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=abUuptQH; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="abUuptQH"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63c0c9a408aso2412271a12.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 30 Oct 2025 15:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761862089; x=1762466889; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0LxObTOLLtZ8xxLgeHDO09rzfBk1nZUK8QTcdiGvecg=;
        b=abUuptQHzLV8jScOhPNokmxESfSRx4+DKsN5AsaNXhz/4GkWYAtx6D2CbUh3ERpxaH
         418MqHCcDWAIFVCr97p8jd2PydlQXw15xldjP+pnPW1vUmGkh1QLxcl5TLnPEk3bGNS+
         4GWhIGJ0XEi+7stMBFaw/23ab77dROh243Y5ij3EuhOO6SViVjEqejsChvIXarZYOj4C
         Nj0JOh0VVFeXhb8Vk3wmcn+qGw8pLYVUie/D5pM5VR6g/g4tdVwp91IpfAWxNn9+ezZ0
         OueZ3R8ad6csZ0IyLhhvVq5YXRJCc5ZuTbNNRVSgLQ/qQ2ELaP/E9jf4rGdYhUJ4YjXS
         e43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761862090; x=1762466890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0LxObTOLLtZ8xxLgeHDO09rzfBk1nZUK8QTcdiGvecg=;
        b=rJTk3SJZEcdoaWGej+FBo1Bus6qka/WkuWi8d2F7QL3vq42ehO5i4Xu/wrpov++xef
         b8ftrdTA5rwuMS3POnwNr7kYoPnjc6ckWD3mePbapZD5xXaM5wh2tICK5qmywnwz0o8k
         pq9MNEql+UZxv2UYrTsyhiKcsh/Cmy9RTBzzzAgLS8HPDItCP7TFtGofxrSmBjxxB7D4
         HJyPtZsxt8Ive8or7iPeRSE4pTc2e8g90SAmjWnWItnGDIyX86iZKKBAeIyeXR49/2Wq
         Ge3iowYwvkInYNaw/ufJx8kUstUZl0zvOiDklzTKSiEINBuRboEx5tvk5PWPyUU/nefv
         HqPg==
X-Forwarded-Encrypted: i=1; AJvYcCXPmZ6I1kCRYNpglaamD7RiOTot8gH1EWoNjPEFyghQfAcA3ynPCT3oN0FD81IJuoeXavMZP1DgzW73qg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzILglFiIF2SphUYp3YO/TZJhyaEX1Vyt/zqu2zjXJFE0omevw3
	vsLeNXt5Duv1Az6dPTRFwyxXxpDHOC7HJtW01qp89VgBHe6TKlXCRthrRAM/BcKcgyqgIYzGtCp
	rRZo1f5Sm7T2jn51bnbvBLkBLg8cgy5g=
X-Gm-Gg: ASbGncvysgbGFhfJ9V03ex8s9LK37cTOfgRlvQOYpe277VqrxVbxe47uXECBiu0fuEW
	lSm7DyNjYHUeKWOlv1eQzH42qtSnvuDBNXsb+88LFxeGwxhmR2mKBZUxZQNtDBqo1dnu3yWnlpA
	LeJj3Z1p+xhFcVT/cZV8pWM6KAMziH8Q14uK64NzhRi/C2L5tamRsk6mEf4BgaqamfywasI2+e9
	hW6TNDfanGFz8mg0CXyUzUNJoolLGHAGvLEYBsFZyXgyUyYtQbWG3YI5QCZds2w99ZReRaWQVqK
	q4laH6Sxctz7yGGdSiwLvip3zao=
X-Google-Smtp-Source: AGHT+IGR0wVutOFEKKEV5B5/riddaJS0BmFT14SEyFfKcUf47Pqu9r1kTsM350wF3kTvfvSWEdaPWWrc085FHNWrRC8=
X-Received: by 2002:a05:6402:3512:b0:63b:f05d:b985 with SMTP id
 4fb4d7f45d1cf-64077068b44mr856508a12.35.1761862089107; Thu, 30 Oct 2025
 15:08:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251029225748.11361-2-eraykrdg1@gmail.com> <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
In-Reply-To: <wzykonhpj76qowdn24inwtaji4zfclesmc3lqnnc7cn6jkyjl4@oauagnarupov>
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Date: Fri, 31 Oct 2025 01:07:56 +0300
X-Gm-Features: AWmQ_bl6GSQvlP8PEpYdfCdNwc9EbQga3YjgmFaSDoIhjzzpIF-Mu3RGnsKkrYM
Message-ID: <CAHxJ8O_7-PfJRyGp9-1KOkwmYJWQDzCvvo_P-jxzbzHoqXyH9Q@mail.gmail.com>
Subject: Re: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure
 during read
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	david.hunter.linux@gmail.com, skhan@linuxfoundation.org, 
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com, 
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Heming,

Thanks a lot for the review and comments.

Regarding the placement of make_bad_inode(), our patch places it in
ocfs2_read_inode_block_full() because
ocfs2_validate_inode_block() itself doesn't have access
to the inode object. I believe this (in the caller) is the
correct layer, as it seems to match other patterns in OCFS2
where the caller handles the make_bad_inode upon validation
failure.

I had one question about your proposal to combine this patch with
Albin's [1]. When you mentioned, "We should forbid any write
operations," were you referring to Albin's read-only check in
ocfs2_setattr as the mechanism to "forbid" the operation? Or
were you suggesting we should use the inode size sanity check
itself (e.g., by converting the BUG_ON to an -EIO return)
as that mechanism?

Thanks,
Eray

Heming Zhao <heming.zhao@suse.com>, 30 Eki 2025 Per, 10:59 tarihinde =C5=9F=
unu yazd=C4=B1:
>
> Hi,
>
> In my view, combining this patch and another patch [1] is a complete
> solution for this bug.
>
> According to the oops stack, the FS is already in read-only mode.
> We should forbid any write operations and then perform the inode
> sanity check.
>
> And I think ocfs2_validate_inode_block is a good place for make_bad_inode=
().
>
> [1]:
> https://syzkaller.appspot.com/text?tag=3DPatch&x=3D1287f614580000
> - by albinbabuvarghese20@gmail.com from:
>   https://syzkaller.appspot.com/bug?extid=3Db93b65ee321c97861072
>
> Thanks,
> Heming
>
> On Thu, Oct 30, 2025 at 01:57:49AM +0300, Ahmet Eray Karadag wrote:
> > Potentially triggered by sequences like buffered writes followed by
> > open(O_DIRECT), can result in an invalid on-disk inode block
> > (e.g., bad signature). OCFS2 detects this corruption when reading the
> > inode block via ocfs2_validate_inode_block(), logs "Invalid dinode",
> > and often switches the filesystem to read-only mode.
> >
> > Currently, the function reading the inode block (ocfs2_read_inode_block=
_full())
> > fails to call make_bad_inode() upon detecting the validation error.
> > Because the in-memory inode is not marked bad, subsequent operations
> > (like ftruncate) proceed erroneously. They eventually reach code
> > (e.g., ocfs2_truncate_file()) that compares the inconsistent
> > in-memory size (38639) against the invalid/stale on-disk size (0), lead=
ing
> > to kernel crashes via BUG_ON.
> >
> > Fix this by calling make_bad_inode(inode) within the error handling pat=
h of
> > ocfs2_read_inode_block_full() immediately after a block read or validat=
ion
> > error occurs. This ensures VFS is properly notified about the
> > corrupt inode at the point of detection. Marking the inode bad  allows =
VFS
> > to correctly fail subsequent operations targeting this inode early,
> > preventing kernel panics caused by operating on known inconsistent inod=
e states.
> >
> > [RFC]: While this patch prevents the kernel crash triggered by the repr=
oducer,
> > feedback is requested on whether ocfs2_read_inode_block_full() is the m=
ost
> > appropriate layer to call make_bad_inode(). Should this check perhaps r=
eside
> > within the caller or should the error propagation be handled differentl=
y?:
> > Input on the best practice for handling this specific VFS inconsistency
> > within OCFS2 would be appreciated.
> >
> > Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=3Db93b65ee321c97861072
> > Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
> > Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
> > ---
> >  fs/ocfs2/inode.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > index fcc89856ab95..415ad29ec758 100644
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -1690,6 +1690,8 @@ int ocfs2_read_inode_block_full(struct inode *ino=
de, struct buffer_head **bh,
> >       rc =3D ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_b=
lkno,
> >                              1, &tmp, flags, ocfs2_validate_inode_block=
);
> >
> > +     if (rc < 0)
> > +             make_bad_inode(inode);
> >       /* If ocfs2_read_blocks() got us a new bh, pass it up. */
> >       if (!rc && !*bh)
> >               *bh =3D tmp;
> > --
> > 2.43.0
> >
> >

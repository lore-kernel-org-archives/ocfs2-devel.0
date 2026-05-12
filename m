Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5FA383325
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 May 2026 02:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778552308; cv=pass; b=pEX9cyeynpwn4k2d/1RN/PPIjX5WU57f3q3dPnAHYFAjSm2C0tNxSZu01HT+DrHeUAgBtdjHP+PCOX55Z0KjcfwEwl4HpMKKrybNm8aic+aQeGVaBVpx90oFyUqaz6zrQA0EzU6qx9aBaYQfML17B3OU3CogA1EIF8+e8UR2D/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778552308; c=relaxed/simple;
	bh=bwVQ9XC5euoEO+khLcnbtIqaVFe1Sdqo/j+oXLA4i3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lnfLkhLMcTD9zfmh2ZWTXwOL81MoD5sgcFK2RvDq9KziYXDFDf6Yepw70gXweyy6ErxnRVRKtNY+sIzHDWmgRORS8+zdV8yxmIByGoOnq6rDGpG09LCY7zW+saGhRbZH4lwEV1Y5eL6qj5cqhgaDCCql6wP4nBR2Gf297UuE09w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NsVygS11; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NsVygS11"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6746d0b2b4aso7536298a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 19:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778552305; cv=none;
        d=google.com; s=arc-20240605;
        b=jqFpuyNllI2zwa+YK5t1rlEJ9P6XIHc843OHyk4VffVnr41q1Fc/WmaDwg7muuYjxM
         D+nPRxSMbCVXe7jQOFBx/x2fdiQ8UOTozPveIB9kyZM0DfptV6DSAaf+V9DBnr0HJhXR
         TzWTjdnBcwUJcOEJFf2vmwrN1Qa9pWpIdXmvmIqoayoYTT+vK4vizKOdbYr9ELLTSPNc
         fwZBnTas2mEXqYH9KDtj7qC3DmDutDRay5Fu4z0j+zEEAvIDzHgEYxdlqiGjlsr8f0bZ
         ueyllFn5e4WO/YnDB9k9OSodNNSYnN5Y0OcLoomixe+MKscnqN4CfzVvf5b3dnuIP109
         m74Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=spMHj3cC4fzc9jqRBylDsbrnaFTphxLOCiwZFXRJW20=;
        fh=FLRldhW73fzzUGsTXchr7wQPBS3DwSWYsZYi7QDX0Vc=;
        b=ZMOhFsilSu7xtQTj7TVsUwMk7jtrcwKi8H3pYrMKJzOBDdryN/2CujAkQvpYWkDmIk
         KjaSjLOJJLr3cb1V1YL9rD0ZO8zA65jef5bBp4sT63H/+Ju1npoBBmELn3u5QGj4lsXp
         DAUXzSuTdNV8RxGFeYXAw6chO+Vpr0TqfYQiDB2HeVnHNMaLXyuts6RNGdxlXwh5wUuL
         n5swC+XJA3saitEWQph6fPC9uTdl6a07kv0JykdlbPFD9gjV5y+w3jHIeMjR6DGTqTu1
         A6LCXlho+p2SnGRmKTYAnzJy4kv+Zu65p93ulwPT1ad3Zw8YbGg7KY5jZvCeQhjnC/D1
         ZYOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778552305; x=1779157105; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=spMHj3cC4fzc9jqRBylDsbrnaFTphxLOCiwZFXRJW20=;
        b=NsVygS11KHB1ZMko3nogqRVxpcn/t6Jbg12pg3UJrgii1+hJidBg8jgcshAZdoVjz8
         d7V2VeZxEYrJmlQLhTUpuI2CWtN7GCuIAAuESzrjqEzxt9FDNSzdWPnLB9xW2FZLrB++
         Snh2TBuZKVs/A+nnxOFlduMvZlMUauyJYxLQlvj3vxQq2mMnhFZ3+AeI/N6L7cfgUPlq
         9ngX245fdICQTWM2L2hDGrEypgWctJkTNv1pa7IF03kr0ZBoxsSyjOFfCfmj2Rl39l+l
         fGFipUysYNbLf3itcSLRN/KsPEZg+5vrFYxG4BeQDXNHdatrUfAj6l236iel8V+AeQ7R
         wLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778552305; x=1779157105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=spMHj3cC4fzc9jqRBylDsbrnaFTphxLOCiwZFXRJW20=;
        b=AemvfivfFCst4yRt90GkMrOVkvp7T6GTUUTkOfWDDZ2PmkXn3Gg14GRiv/HGaj7k0E
         nabU7eDwjnW5V8Q9vRgLswZc35E6L6bWcoMQln/V9uZsisztwS28pHGCFNCgpOrZZ/5b
         mmjx1yAP0EGRmQgmupflZ35vIfBFcdU4KQXZfxXmi7RtoT9FFeRqLRn8c0SmOg0RYR7v
         ZkVqLTFBRSqIjevlGykK8J91HXPZ3kSw/HU2bmkZigGqBagIUzdzRmz1GBkNAQ2IZqvT
         KGwTNwOdB9WSexDjkDQl5PGiozvw9MWpLQZCd7xiaxqXl8C690OXNV4Vi/XKl0VPumFQ
         J8tA==
X-Gm-Message-State: AOJu0YxaqkIbI0fgGAx17xBljFag30MRZDy55eI+fbEBWEtHd+k5sbwa
	VUC183+ap7ykj51z6pisCkoQbCa9jXJ5AT2KhAVRDWBU54TYtNsfIwnbA98Tv0NYI8FVvV5QUaS
	1h8pins+MlrErfPNCDjkUWk0eNC6+QLc=
X-Gm-Gg: Acq92OGLmjL2FHk78X4YVNGXrnXx+PIn/LzNXquRdKu/AJ2Cby/XgYPBSKmFzMjDj4t
	carNYKdVJGCcKoMz8LZE902RVjyjY/bdCSqvNySefL7SKwqK/HNc8DnV2+8MXyy5FV71X371CXA
	E5F/NTE21HFDPD8uRlrUpdOVXyBGlb5sYOOxtGh8k4MW+TqUj9nWA5sCCk8MpsUk6gooszdHf2c
	TWC1/HcBXTgjSYmmeRPgt5O7De+ftyucV7s2SD/pd9VVOt877z+2BTcHb/Ormv+ouwPgLapPECD
	suSWK9O93Q9onJEBz6fhz/L5GLN4e7p6aSLizAB21pAy+qxADGLX3gg=
X-Received: by 2002:a05:6402:913:b0:67c:e014:464c with SMTP id
 4fb4d7f45d1cf-67d638a7675mr13059573a12.5.1778552304822; Mon, 11 May 2026
 19:18:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260509091004.758218-1-gality369@gmail.com> <cd56254b-1ff0-4058-b67e-1a6cd4e10ead@linux.alibaba.com>
In-Reply-To: <cd56254b-1ff0-4058-b67e-1a6cd4e10ead@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 12 May 2026 10:17:58 +0800
X-Gm-Features: AVHnY4KxTk7hQ7CvLxfSJdgvIjuIpXi1M0zbDkn610Lg3_7ZA1n664fkEiQcgFU
Message-ID: <CAOmEq9W=gLFFkiMkc1+pEAiMkrOVkYEd3Hza8gzOJxH37AYSMg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: reject inconsistent inode size before truncate
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 10, 2026 at 11:54=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba=
.com> wrote:
>
>
>
> On 5/9/26 5:10 PM, ZhengYuan Huang wrote:
> > [BUG]
> > openat(..., O_WRONLY|O_CREAT|O_TRUNC) can hit:
> >
> > kernel BUG at fs/ocfs2/file.c:454!
> > Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> > RIP: 0010:ocfs2_truncate_file+0x1204/0x13c0 fs/ocfs2/file.c:454
> > Call Trace:
> >  ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
> >  notify_change+0x4b5/0x1030 fs/attr.c:546
> >  do_truncate+0x1d2/0x230 fs/open.c:68
> >  handle_truncate fs/namei.c:3596 [inline]
> >  do_open fs/namei.c:3979 [inline]
> >  path_openat+0x260f/0x2ce0 fs/namei.c:4134
> >  do_filp_open+0x1f6/0x430 fs/namei.c:4161
> >  do_sys_openat2+0x117/0x1c0 fs/open.c:1437
> >  do_sys_open fs/open.c:1452 [inline]
> >  __do_sys_openat fs/open.c:1468 [inline]
> >  __se_sys_openat fs/open.c:1463 [inline]
> >  __x64_sys_openat+0x15b/0x220 fs/open.c:1463
> >  ...
> >
> > [CAUSE]
> > ocfs2_truncate_file() treats di_bh->i_size matching inode->i_size as an
> > internal code invariant and BUGs if it is broken.
> >
> > That assumption is too strong for corrupted metadata. The dinode block =
can
> > still be structurally valid enough to pass ocfs2_read_inode_block() whi=
le
> > no longer matching an already-instantiated VFS inode. On local mounts,
> > ocfs2_inode_lock_update() skips refresh entirely, so truncate can
> > observe the mismatch directly and crash instead of rejecting the
> > corruption.
> >
> > [FIX]
> > Turn the BUG_ON into normal OCFS2 corruption handling. If truncate sees
> > di_bh->i_size disagree with inode->i_size, report it with ocfs2_error()=
 and
> > abort before touching truncate state.
> >
> > This keeps the fix at the first boundary that actually requires the
> > sizes to match and avoids widening checks into hotter generic
> > inode-lock paths.
> >
> > Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> > ---
> > diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -444,15 +444,17 @@ int ocfs2_truncate_file(struct inode *inode,
> >       int status =3D 0;
> >       struct ocfs2_dinode *fe =3D NULL;
> >       struct ocfs2_super *osb =3D OCFS2_SB(inode->i_sb);
> >
> > -     /* We trust di_bh because it comes from ocfs2_inode_lock(), which
> > -      * already validated it */
> > +     /*
> > +      * ocfs2_inode_lock() validated the dinode block, but truncation
> > +      * still needs to reject an inode state that no longer matches
> > +      * di_bh.
> > +      */
>
> In commit log, you mention the case is local mount.
> So here comments should refer it.
>
> Thanks,
> Joseph
>
> >       fe =3D (struct ocfs2_dinode *) di_bh->b_data;
> >
> >       trace_ocfs2_truncate_file((unsigned long long)OCFS2_I(inode)->ip_=
blkno,
> >                                 (unsigned long long)le64_to_cpu(fe->i_s=
ize),
> >                                 (unsigned long long)new_i_size);
> >
> > -     mlog_bug_on_msg(le64_to_cpu(fe->i_size) !=3D i_size_read(inode),
> > -                     "Inode %llu, inode i_size =3D %lld !=3D di "
> > -                     "i_size =3D %llu, i_flags =3D 0x%x\n",
> > -                     (unsigned long long)OCFS2_I(inode)->ip_blkno,
> > -                     i_size_read(inode),
> > -                     (unsigned long long)le64_to_cpu(fe->i_size),
> > -                     le32_to_cpu(fe->i_flags));
> > +     if (unlikely(le64_to_cpu(fe->i_size) !=3D i_size_read(inode))) {
> > +             status =3D ocfs2_error(inode->i_sb,
> > +                                  "Inode %llu has inconsistent i_size:=
 inode =3D %lld, dinode =3D %llu, i_flags =3D 0x%x\n",
> > +                                  (unsigned long long)OCFS2_I(inode)->=
ip_blkno,
> > +                                  i_size_read(inode),
> > +                                  (unsigned long long)le64_to_cpu(fe->=
i_size),
> > +                                  le32_to_cpu(fe->i_flags));
> > +             goto bail;
> > +     }
> >
> >       if (new_i_size > le64_to_cpu(fe->i_size)) {
> >               trace_ocfs2_truncate_file_error(
> >                       (unsigned long long)le64_to_cpu(fe->i_size),
>

Thanks for the review.

That makes sense. I have updated the comment to mention the local mount
case explicitly and sent a v2 patch.

Thanks,
ZhengYuan Huang

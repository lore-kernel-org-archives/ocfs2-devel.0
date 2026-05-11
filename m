Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C5622126D
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 02:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778468337; cv=pass; b=cGS6n9/HTMi1xd9x0/5b8MhMVgWSj0R11gXBweGFtr95T3bs5NyVzZE+WNCVb8NH/a5DkhTq1ad0SURnD2pwHn85xdD5Ii8Me25sMfvxxX+L1X2rPjWDmjm3eoPB+bGJ1kPEmR0+IAaSS9GKyC+RRFogTnQ4vj7OBDlgoLtKcPk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778468337; c=relaxed/simple;
	bh=MkFgioeUPRbMCBMVuRyiZHJtaUgtLemYwvP6+sgfAXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RjNIse+3YxIzPk5LPlHe6hI5ozJaxtaqs7rC47gihnHij2NrtEwtKAWXuy6WBQMac1M/pOGYiTEuT1Q2rmc74xf1SbTqtVtUciiSYgrZUy3xEXUjRCdJOX5hne/MVd7M0+FDuuvm8tDPAaWCCmPd4cSX61fLVV6vVroW+SIHbGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnHfDQXr; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnHfDQXr"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67bb5ad91bfso6934177a12.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 10 May 2026 19:58:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778468335; cv=none;
        d=google.com; s=arc-20240605;
        b=BhLRZahEZmJorYQ1wLcbO5PnlhqM7UwHqV3ZiZ8ZRJ8hPDGOMH4FS13Hww97jIkCK3
         iMNcSosC9rxQslVOhKu2fov1vl5XKhyVi4XUm/wgO/S3X0FZdEqzSnWJLObL/v0AusBw
         CLCFrEoaSMNfpQCYjBmT/RzZjOz+FUo3etA8CNEs/ouowvRoa2Sfbi2h1TN0D8sz0IRG
         4h0uC/VaTXMISFrUBRoJrbj123xBD5AJ+H1DmaRvyZLCGGD9LFfpZETdDNkm1/DzTztN
         3Ia+DrnoA+7dOv9DuqwgnXOsQQ1ck9erZoozI5AAESnYYI04Rqebqvv4OoOuPnPbkM5v
         37nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V7iLZq+tNA9/EluJlDLgmV0kX9fgVqqi4Ivkia7fqyE=;
        fh=FLRldhW73fzzUGsTXchr7wQPBS3DwSWYsZYi7QDX0Vc=;
        b=UyU/V3iQP2x86KuqP4RgDIPualWDx9lRATLqfi+U1Z2Sm9DXPfU8fQh3/NXfivfM4A
         b0wmOJuUMfjR1+atJ9sFKBz3gy3dfjCFsL6DrAddJ3/7kQHqUnk1DIanSoRTwo8O48Kf
         WeEWlwZCfAj86t0sZ+O4H8YHDV1U2VorgMoKLoUraXL9QHRX0KA6hqHyVCwlbcykCo6G
         Y4+OeHgLzW86oSyvVofOnLeNknJ+ga9OMQ4SsM9Ci404V6mT57qiFxfMGDLc85KI0gHL
         5xOqG2VatcJMbQUu+mxjOz2IZI09sSF1o/oHHcWpQoxwoUG5sezVQODBKwdiTD+8KPsm
         ltww==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778468335; x=1779073135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7iLZq+tNA9/EluJlDLgmV0kX9fgVqqi4Ivkia7fqyE=;
        b=cnHfDQXri+1bQ3hKvNmKJL5Qg6g1jMnHq2b0ymZtbTtRLfiy/SuHPAZc9Jn8Sfrb8j
         RsB8Xotj2Zo7tgmEo16SqYmkMw4G7L6hxFFJSJx6NCcpM2OErOgQ7ULEcEnPyFqA2PWY
         uhLyPq2iGnIpI0P00BO9wYvye0iuhcOg5s2nmmFLoy3UA0PjzJC7HDnwzVeQPWA5vkZW
         WdorxZg2k2ipYJuF75T44nzs6mASNZ/8g42rC7NlmTVWvz6IVGhn7moNELVrmZ+cCSzP
         FAwYQW5Y+MoFjRFXPaY95flPMN9Ph0xzgYaycO2JvT9XjC27WRsn4jd4BiSGzjC6A+ji
         2uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778468335; x=1779073135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V7iLZq+tNA9/EluJlDLgmV0kX9fgVqqi4Ivkia7fqyE=;
        b=VTB4fFEy7tBrmn3jDRzhEbkbgz14apeOd+j7mey5DonR2k7JDuLJdtBAcp9RyprVfd
         wD2sd7ZDKEAwbDYs1y8Tz8o8QNsUBNBc/Jwxx1rjzW6pFeTuLDsNdQa2fdqPA/rQVZ9r
         J2vcsvyjmRWwIDz4RpaOAIyDyAGDJgKlnj3dnfWkFlZrxnBe/jPHFuDN+DjYV71lBwf+
         0jbGbKUFU378+2zJ6U7MpwPP0yM+x+bqe9AEbqJqHX+nhJEjptRpJMcvG0/02/GjOrRM
         o9Ame+2sfVaGgTQbkpPj9iyGfeBTbTNpNdX+CzPXs5/wOTB5Z+oZcN2rq/YQNeWw5DM7
         UA7A==
X-Gm-Message-State: AOJu0YxtqSD5onfrYgPIDrVmeQ27ZpkqSBk6bvD7ETbHj9GYb3ZljEpr
	EXRoTzG74FAzHwyi9wzJ7VYX2ruZ6sFvUPw5fTIKDo+Z6pTCmFKAvZ9XpYcMiaEnUE2DOzgFmOs
	To1O3QPTCpmKQdqWC4nFTVfsjYnZoYRU=
X-Gm-Gg: Acq92OEA/krA0W+JfVC4EF4xC9Re6DArb9pL8C5XvSM/wBB4rAO+6k7hVHtpLH7Ol0Y
	1qpDdfHE8AAHxDhzMJefbXTvz34Quq2HYBOm9nWYVYs9z9Tt25DYNUqcSrL/TfjUIv5pU8gvLAp
	9IX+u4bGfqymkIeQV4ENeZL23OmkyCuOaLsAHtJEa4MZ/EIaDCBP5KpKf179/M81irh/q26nu7L
	RdIm+og37jKiuv2xKo97Da5APr2KcpDUkTxhaoBnGTA+UxM6rUl34OcoI5ZfSX3zjyEmasSIFhK
	1qJWQA4Qb0Fly3nq6Sj45sLvSeHxpGbrcDyqEvh1clWZ7A1Wa/jxKI4=
X-Received: by 2002:a17:907:9305:b0:ba7:7f6d:be4a with SMTP id
 a640c23a62f3a-bc56d132a0amr1261626066b.26.1778468334465; Sun, 10 May 2026
 19:58:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260509135213.925551-1-gality369@gmail.com> <e5806b59-7d5a-4f73-aa9a-24a0c4ec2655@linux.alibaba.com>
In-Reply-To: <e5806b59-7d5a-4f73-aa9a-24a0c4ec2655@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Mon, 11 May 2026 10:58:28 +0800
X-Gm-Features: AVHnY4JsFjHFN0E_ez-CPE8oFWXbFOjgQRQad9teIkOv9b-73Fa6g1NzTbHw0FI
Message-ID: <CAOmEq9Wv+v_rb+FRKYJxvr4V6e9nj49zN-4tM+82=_Ei82PN2w@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: revalidate the journal dinode before toggling dirty
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 10, 2026 at 12:02=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba=
.com> wrote:
>
>
>
> On 5/9/26 9:52 PM, ZhengYuan Huang wrote:
> > [BUG]
> > A fuzzed OCFS2 image can corrupt the current slot journal dinode while
> > mount is still in progress. The mount path first reports the invalid
> > journal block and then crashes in shutdown:
> >
> > kernel BUG at fs/ocfs2/journal.c:1034!
> > Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> > RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:103=
4
> > Call Trace:
> >  ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
> >  ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
> >  ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
> >  get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
> >  get_tree_bdev+0x24/0x40 fs/super.c:1721
> >  ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
> >  vfs_get_tree+0x9a/0x370 fs/super.c:1758
> >  fc_mount fs/namespace.c:1199 [inline]
> >  do_new_mount_fc fs/namespace.c:3642 [inline]
> >  do_new_mount fs/namespace.c:3718 [inline]
> >  path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
> >  do_mount fs/namespace.c:4041 [inline]
> >  __do_sys_mount fs/namespace.c:4229 [inline]
> >  __se_sys_mount fs/namespace.c:4206 [inline]
> >  __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
> >  ...
> >
> >
> > [CAUSE]
> > ocfs2_journal_toggle_dirty() assumes journal->j_bh still contains the
> > same validated dinode that ocfs2_journal_init() locked earlier, and it
> > uses BUG_ON() when the buffer no longer looks like a dinode. That
> > assumption is too strong. The mount path can force the same current-slo=
t
> > journal inode block back in from disk through
> > ocfs2_read_journal_inode(..., OCFS2_BH_IGNORE_CACHE) while
> > ocfs2_mark_dead_nodes() scans the journal slots. If that reread finds
> > corrupted metadata, mount unwinds through ocfs2_journal_shutdown(),
> > which reuses journal->j_bh and turns the metadata corruption into a
> > kernel BUG.
> >
>
> A bit confused.
> Since journal dinode is firstly validated, it means image is checked.
> Now mount is in progress, how to corrupt it during runtime?
>
> Thanks,
> Joseph

Thanks for taking a look.

Yes, the journal dinode is validated when it is first initialized. My
concern is that later in the mount path, the same journal inode block
may be read again from disk with OCFS2_BH_IGNORE_CACHE, so the buffer
used by ocfs2_journal_shutdown() may no longer be the same validated
contents.

This does not mean the filesystem itself corrupts the block during
mount. Rather, after the initial validation and before the later use,
the block contents may change due to unexpected disk corruption, I/O
problems, or a forced reread of corrupted on-disk metadata. In that
case, ocfs2_journal_toggle_dirty() should not rely only on the earlier
validation.

Since this is a cold mount/shutdown error path, adding this extra
validation should not have a meaningful performance impact. I see it
as a small robustness improvement to avoid turning bad metadata into a
kernel BUG.

Thanks,
ZhengYuan Huang

Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A1C1A23A4
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 May 2026 02:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778553944; cv=pass; b=sKNqVl5F7aFoTJ2BQlciWULXE10RZJLwBlgtJBBs83MhA13RXI8+btHMNjuqTUzMZxJa5I/g/MeFWr1OZcQvPn9MjKDgomGGREPb2VpyHlIb0i4Rbuo0SvZey8/tjh/awphwE2le/BUe93NEqFCk5xJ2TacPX6JMGwoRVYEj208=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778553944; c=relaxed/simple;
	bh=j1Vrg89prfHETOon1xBEBgnmN3SW81vg12pI/bhGciU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TyIcW64U9gomC6XoYIGbgqp/oVoOGsb2uGCjG2ynAFqqAiKYIP9y2T0UpcrvgLdkShjLn8szy/h38LU0qVJcFT5o5FAiXbAn6y+YSbA1Ea+u9N8seW4+ZR5K40lMfzSmlISytL/Cx5aVkqG+6uYS3cFGxrz+q8id4dAiYAYRIF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EJxT/i1L; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJxT/i1L"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-67c9616b4feso7384600a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 19:45:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778553942; cv=none;
        d=google.com; s=arc-20240605;
        b=lji3KaDJdsZLl8wfWY5nax3nAGtNAzye+cVlS093iWv2RgF/6l86N4Mkan94mNchMX
         bos6KqhdOcnLFousSCMk4Gt8kPZjLJ/NK0mOyINGWYhA5Vk9bJqHSbQ3GtC0RYGfEzd9
         viU9b72eY+tJW2g3b6ZsWg0LD9Xq+kcCEpuLH9z8km8qjHrMu1A46zAKrpcq1m7nDCrQ
         jtpRaiQyVQ01SIttrfyOtsZcIsLAp1cvYWm9LUB/SwvtG9W4SO0wyDh1ENm0gG/ChXSo
         +Uzs9vvRefmKD59Zi8YA3mWqLJ8+8uvo90gYxYsxLQ6cTJ2WEnvdB+ecGMfQW8TcvbIZ
         upLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pjYEJvIPevaBtcfqouseHWQhyQbx5SxQV+cmJ49jT1E=;
        fh=FLRldhW73fzzUGsTXchr7wQPBS3DwSWYsZYi7QDX0Vc=;
        b=Lyz/wOBaSFqlUB2kxOWnyoolN5q5iDnxGr984i0cQ/PSBcGEIK8wgTv6tFjDgyzQRi
         g7TRbovqTgdUodyY75F6gQAF5O5DUP89CANCh8H3jQJx/5eOWPonsuDW8jasfJQPMWgJ
         KM0j8ci1sM5wB0VYzVacQlwTtIUs3lK51bjaMV+tuXzNZ2ufonEITgTJQ4b9gpNEoq8j
         C0hcsJ5RSQcnNh9WeKy30vXI0FQmIN8+dkrOucrlsBMGvh5aebMV5fMVBUieONtn84Sz
         X52DFmR+9r/e1yWDg77CKlHu9nCivkKtV4iIvWbtp9B9R5PvaZfKxUdCoJOeLFWUP2U0
         PXJw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778553942; x=1779158742; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjYEJvIPevaBtcfqouseHWQhyQbx5SxQV+cmJ49jT1E=;
        b=EJxT/i1L3a5PZCpgh057p7i/IfaVU2j3WtzjZVSZn85sf0i0YijeJG5+cMiZHbfsJj
         0RoMyKUuQTOqlTcE90u4f+WaHh7Fmru0YG34Z1Vu69bb+Mi0FXLS7XZzQg788wNFFLsJ
         iY3OJXjNPD/76i0DvUBw3k229eXekxOyk6fw4Iml5BpKVri5wz0smxxfmmBeLQBOsKIC
         ZQQjK3EdgG3ffduZUnXDOGKsxorSFyZqOInhknvjxrWFyfr+UCynx9x0tWsDV4bJ1E66
         RyjAnnJ47ro9GuGuvciTRZC4aui1+urQ/qVlMk6eV1fOIZRq1MY5IwgFe0lT4RSwup8m
         bdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778553942; x=1779158742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pjYEJvIPevaBtcfqouseHWQhyQbx5SxQV+cmJ49jT1E=;
        b=T7oQGti6cUrLBO8nCnRKLwxcpQlg6td8e4P6Im1PRYxoGKxSLFZOPtlPQ9Yh4ne1AA
         FbkPMnr4ehn8hTAU68AZnifpNgqO8DVCQZZ7AYLLkYEN7YiscaoPETAnm6MTFWjADE1K
         7RAgMGKacJMizTUD4+0F+SehEWG8egHuSlZzPNnDEqWNPGYFctxJH26rtGCpehiQHws6
         zg3aNTdaRLZ0B+qNTdTIGM92EmlGytRcJUnqFZLMmMBNOGa8HV6xK47UTz3NaMdjgQ/R
         iGCW0UBWk6+77RuoUerDWBjO4/ZmjD/RiHs8tLdKXHWh4WYINxb4VvtKymCeTVSNMH/H
         cxrA==
X-Gm-Message-State: AOJu0YxlYWET3fA8oZWkiVv7oeJSdgPXI/y++iwix2eLEQEFNwkPJegd
	oMmQWoDpOqU49uSEERVIHqLhD4ikLNEOcDUsm64RGGIo0rGYHUKaTkvECeCea8362COGburNLkc
	X/7RZDLDbUwsBUWihED8WStez78ARPYH8KCEpGH9/TA==
X-Gm-Gg: Acq92OHdiTkMcvV4b3cUQ00mllaY61Vb6qyuxgjNfCavwtM0bjJLGRKiu3iuK6LwEtJ
	H1F90sKS0Dh5CeEdu650+QTNiMaTXYNxiMg0aLvjtoX+ADABE2QMOH+MEltyr3q6JP0deoWL72w
	9Qar6VpeaGWWB6ADd44fegGZn6S10p7gieO32eoL4M3el+dBwnMXRZrss80Ivdt+hWXuZ6zS+kb
	Q09nt4mRmWmdLSwPXGTXHLN4PMUovfl42siB7EH6/4AtD9+SNF95A3dB8dvs4EjUdVXERi991zy
	2Giarp2MAq9MyMx3dLkpPX2jj5Cb8e9fEL/Ys/dSd/Njq6jjVnJm2IA=
X-Received: by 2002:aa7:ccc9:0:b0:680:4be:2ecb with SMTP id
 4fb4d7f45d1cf-68004be3b6dmr2720056a12.11.1778553941396; Mon, 11 May 2026
 19:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260509135213.925551-1-gality369@gmail.com> <e5806b59-7d5a-4f73-aa9a-24a0c4ec2655@linux.alibaba.com>
 <CAOmEq9Wv+v_rb+FRKYJxvr4V6e9nj49zN-4tM+82=_Ei82PN2w@mail.gmail.com> <80f6acd3-f80a-4b7a-abdb-6723df92d867@linux.alibaba.com>
In-Reply-To: <80f6acd3-f80a-4b7a-abdb-6723df92d867@linux.alibaba.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 12 May 2026 10:45:14 +0800
X-Gm-Features: AVHnY4JbVDXRcL9ezeE-j1dZo-R24QG5xe1ERgwNn5dodbw2AC_BP0ipdoz7Abk
Message-ID: <CAOmEq9XzhSEG7SCYuSGZZQu3jV6me44DzHg1Fntb1x7_gteOrg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: revalidate the journal dinode before toggling dirty
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2026 at 2:15=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 5/11/26 10:58 AM, ZhengYuan Huang wrote:
> > On Sun, May 10, 2026 at 12:02=E2=80=AFPM Joseph Qi <joseph.qi@linux.ali=
baba.com> wrote:
> >>
> >>
> >>
> >> On 5/9/26 9:52 PM, ZhengYuan Huang wrote:
> >>> [BUG]
> >>> A fuzzed OCFS2 image can corrupt the current slot journal dinode whil=
e
> >>> mount is still in progress. The mount path first reports the invalid
> >>> journal block and then crashes in shutdown:
> >>>
> >>> kernel BUG at fs/ocfs2/journal.c:1034!
> >>> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> >>> RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:1=
034
> >>> Call Trace:
> >>>  ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
> >>>  ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
> >>>  ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
> >>>  get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
> >>>  get_tree_bdev+0x24/0x40 fs/super.c:1721
> >>>  ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
> >>>  vfs_get_tree+0x9a/0x370 fs/super.c:1758
> >>>  fc_mount fs/namespace.c:1199 [inline]
> >>>  do_new_mount_fc fs/namespace.c:3642 [inline]
> >>>  do_new_mount fs/namespace.c:3718 [inline]
> >>>  path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
> >>>  do_mount fs/namespace.c:4041 [inline]
> >>>  __do_sys_mount fs/namespace.c:4229 [inline]
> >>>  __se_sys_mount fs/namespace.c:4206 [inline]
> >>>  __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
> >>>  ...
> >>>
> >>>
> >>> [CAUSE]
> >>> ocfs2_journal_toggle_dirty() assumes journal->j_bh still contains the
> >>> same validated dinode that ocfs2_journal_init() locked earlier, and i=
t
> >>> uses BUG_ON() when the buffer no longer looks like a dinode. That
> >>> assumption is too strong. The mount path can force the same current-s=
lot
> >>> journal inode block back in from disk through
> >>> ocfs2_read_journal_inode(..., OCFS2_BH_IGNORE_CACHE) while
> >>> ocfs2_mark_dead_nodes() scans the journal slots. If that reread finds
> >>> corrupted metadata, mount unwinds through ocfs2_journal_shutdown(),
> >>> which reuses journal->j_bh and turns the metadata corruption into a
> >>> kernel BUG.
> >>>
> >>
> >> A bit confused.
> >> Since journal dinode is firstly validated, it means image is checked.
> >> Now mount is in progress, how to corrupt it during runtime?
> >>
> >> Thanks,
> >> Joseph
> >
> > Thanks for taking a look.
> >
> > Yes, the journal dinode is validated when it is first initialized. My
> > concern is that later in the mount path, the same journal inode block
> > may be read again from disk with OCFS2_BH_IGNORE_CACHE, so the buffer
> > used by ocfs2_journal_shutdown() may no longer be the same validated
> > contents.
> >
> After the validation in ocfs2_journal_init(), the in-memory copy won't
> spontaneously become invalid.
>
> And if it is broken by a re-write (e.g. recover), this a bug in the
> re-write flow and we have to fix the flow itself.
>
>
> > This does not mean the filesystem itself corrupts the block during
> > mount. Rather, after the initial validation and before the later use,
> > the block contents may change due to unexpected disk corruption, I/O
> > problems, or a forced reread of corrupted on-disk metadata. In that
> > case, ocfs2_journal_toggle_dirty() should not rely only on the earlier
> > validation.
> >
> ocfs2_validate_inode_block() is a bit heavy. So if we want to prevent a
> BUG_ON in case of unexpected disk corruption (still a bit strange, it is
> fine in init and then suddenly down...), a simpler alternative would be
> just replace BUG_ON with WARN_ON and return error.
>
> Thanks,
> Joseph
>
> > Since this is a cold mount/shutdown error path, adding this extra
> > validation should not have a meaningful performance impact. I see it
> > as a small robustness improvement to avoid turning bad metadata into a
> > kernel BUG.
> >

Thanks for the clarification. I have updated the patch according to
your suggestion and sent out v2.

Thanks,
ZhengYuan Huang

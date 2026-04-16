Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FCA3126A9
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 04:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776314119; cv=pass; b=BtXKf5zSzTzYrRYvEXrtXCnn+D6sayy1d7Pw1ZPiG7hGxO8cz6xulFbxV4F8C4zqni0Nfv2XLKhVEg4Ohn3qps9QsP3mMVNWo4NeiwY0zUguA5vLF5gFGeK+fwW1NwDWNY72Zhir2C1pqplkHUEN/8o1bFG/vGjEW6vSGRNA0mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776314119; c=relaxed/simple;
	bh=64G9l+U0R6IGVml3kCoXImIkc9etA5j7SZbOKzvyLxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gFfvGnNCeYUui6A3muiDUFdRZ9e+PgEr7dEaEQ83zPxKOTUkqcaAQ/G4c2epmlPDXGZmYzPdCiw+SHgr6FCvkEWpmpl+ifli/xtz0VYd8s/eOtFGivGdfsbYvmjAKzLpFURP/mBpBSVXbCeixDpsmyH7cgVTu9X+kesA7bkUPEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2HLWGoH; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2HLWGoH"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b93698bb57aso42793366b.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 15 Apr 2026 21:35:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776314117; cv=none;
        d=google.com; s=arc-20240605;
        b=IcKQVglLajd0JkoIHH2+WXdEHlQOjaZjSrcdGGh+wqqDE8ubMjxm1iXmhLO5a9ioNn
         9NN/IlxZJjoJ8FNFw1/Ps5CFg+ax+ns8ybG3G871o6c5DOz/ChgrsYZjexTHH3uTJnDx
         Co44C3h2uEKrO9EscuMMG2Xnq214oxCMrbndqzfS0GM/Us74sZwq+s8vj9ioncmNnEbE
         CLD7z/wd74WGY6td9P+98HzzNkt938kc9OdtEGo2jwC2cI/oJJvSxbfM1rxEhx1I4ggm
         6hGgDy/3ESZcYFCdyGqJzQ5Aikp6dsl3Due15dhsSYPhYEW7v1YhTxBOgYRDbhZozVhg
         4lQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QTxnHf/Qon1JDLNrFu2d5htE+P3hFvkr3lA/QesUOYk=;
        fh=TWnsSZZSGdEBS58sidpkWsDK+CRWLUukVAyN/X0uYHE=;
        b=FNHnr+B4yOT54i+34ecpyBrG2ONS/+1auCULp5m7iaxSf/SULaXySrde7ZqDg6z7t6
         84wEFqrbA79d0/A14+/uuJ52jqSdLNWOaovlJ4qCpAAfjkWS520TxO8fUM9Bza308Jh/
         ENh6pc7g2OFjFe5VXCWTYRKMxtBFbaccyMKRgUBDVPa0HJMR3z0uP4POm8KuJRaLk04M
         lTQ6w72MB/FcHkQLGDLG1gEw/5/tSIdJpeozuXaLqFlRX36EtB/H7GOTMgZ5L16ektHI
         7tfKy7T4zuTE8AjdcOdL8Rb6yRnjQmBIt6yUP5cshCcdshG4CRPAnzOpcxCt5NxI5L9x
         aaGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776314117; x=1776918917; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTxnHf/Qon1JDLNrFu2d5htE+P3hFvkr3lA/QesUOYk=;
        b=f2HLWGoHnUyHLdmHCFAdIUeYn5isxgo3z5pUBfKxLzrAZCe0dbfqeJmRJBgkDw6BdN
         wh2S+VSRfJ+KHngvMThIeWA/xlDqVm+svXhROEN8Jj1kiT+wFQUtlhSjGsIgEiWBOWbV
         hmQQ0hldMK3Zqn+bhRaszZ3ZkmN5QAiurKNG5g8NzxKMNgkJpxRaz0GblurH1cZsnYo1
         WfvIYzz7Z1nwItkb/9JFSvRVzSfk6WgIutXtmBRWY3mH03jaGyIl1ESSbm91m2oqntPm
         ruh9VkDDSc/WK/AH4awk7kytl0kPD0CTf0hmqc98vlTDxqzVfGis1JYFlkrTCQAUk+c0
         esQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776314117; x=1776918917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QTxnHf/Qon1JDLNrFu2d5htE+P3hFvkr3lA/QesUOYk=;
        b=H2C4B+4ktYRHBg4Coh06G4KDbbl6aikqS/3o7O89JmwHdkPnZgQRMtayF1H61EP1h3
         3juwrt2co7M+vRHT7gszdm9Jjo45TCL5AepEzoxL2l9opqjqnHg+edIIzca23ahtpM40
         1VViRYbb8mwOxMkCZAR/0/t4WP+Nz3qMXyd+ncTerNCHW5DCWp1B0eBEN9a8pl27mI0d
         GfRf/IpA/r0/AdX+7Y4WdNL/YGFxUOmQZsVQvws2lHxll7Z/SpwtnJM07tg8v/wJVhfM
         fBuwPwIlTAxMm8MCmNTlOD3IinaHZESD6DzzgU547YV2qT/wM9Kxn32aBQ7E4C7CNc1n
         gFnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+VK5zq0C1vcbLMkGuCHnsqdqUYqraal1q3vBxIF1DHDA1IqehwUNP9RnPKHtWYIEAtDluhVkglwE+dnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+vCoep+G/k2Wzz8DoaNug1gvC6l5uN7xGK3zY52lxr5FXXCTR
	/K4ZrPIsEB9WM5pofIq5VWRa0mXIlR52+EO8XtjgtTH6n96zZbKlcjsAsyezWbSEomk/ApGDiqB
	r1I6J79SHP3+8DKxvRZ2aJxCk6c0XdpY=
X-Gm-Gg: AeBDietpl4Ky2bHdkvL8ZiUyEKTwhMIXJfuaviMpgrJAQ3O2GxlAOdQwNb90ybHPqIb
	LnNt3eFQ5ayVDLEdNcNvEhllOEjXaC5/5On6Th2h4baUoxBpAWnUZ1s1Kzpk07AfB2KI7gTxmbi
	wRVadt+6eURDsYNVY1g3OUH9xm20bMRbwzOfQ7Lb4+tSsFqfljAGYbIcSH1iQscqLFhezSSIwsT
	78W+rRDFlbqiwppyLSehoBf21iYopiZRJPl30I5ymzdX4cE4tPajIYhXkCvAYBhNPQ0baaO+JkV
	fB6GCUqSkTP6ty8cGsy6kKLTsCrzJ9lxpXUrNOECprYvdU3yP+E=
X-Received: by 2002:a17:907:7b82:b0:b88:51cb:fd65 with SMTP id
 a640c23a62f3a-ba2671f405fmr108701966b.3.1776314116473; Wed, 15 Apr 2026
 21:35:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260410113229.4092277-1-gality369@gmail.com> <57ej3tjpgtx7myqagtuxj6js7nbnaa6wpdko26jo2wuw6ci5au@rpa7hwij2gri>
In-Reply-To: <57ej3tjpgtx7myqagtuxj6js7nbnaa6wpdko26jo2wuw6ci5au@rpa7hwij2gri>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Thu, 16 Apr 2026 12:34:50 +0800
X-Gm-Features: AQROBzClhB2vyuMU1bFq87K53UA26dbcFxvjGxtHlY1bUgrRDWNKcTwzAiNNmK8
Message-ID: <CAOmEq9VML66bTcwe6w7F03pGQva2Nqp=Yib8SOLsEBfAPwou-g@mail.gmail.com>
Subject: Re: [PATCH v2] ocfs2: validate inline dir size during inode reads
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 13, 2026 at 3:19=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> On Fri, Apr 10, 2026 at 07:32:29PM +0800, ZhengYuan Huang wrote:
> > [BUG]
> > A crafted inline-data directory can store i_size larger than id_count.
> > Once such a dinode is instantiated, readdir walks past data->id_data
> > and KASAN reports:
> >
> > BUG: KASAN: use-after-free in ocfs2_check_dir_entry.isra.0+0x31f/0x370 =
fs/ocfs2/dir.c:305
> > Read of size 2 at addr ffff8880088f0008 by task syz.0.1936/4656
> > Call Trace:
> >  ...
> >  ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
> >  ocfs2_dir_foreach_blk_id+0x203/0xa70 fs/ocfs2/dir.c:1805
> >  ocfs2_dir_foreach_blk fs/ocfs2/dir.c:1933 [inline]
> >  ocfs2_readdir+0x4ba/0x520 fs/ocfs2/dir.c:1977
> >  wrap_directory_iterator+0x9c/0xe0 fs/readdir.c:65
> >  shared_ocfs2_readdir+0x29/0x40 fs/ocfs2/file.c:2822
> >  iterate_dir+0x276/0x9e0 fs/readdir.c:108
> >  __do_sys_getdents64 fs/readdir.c:410 [inline]
> >  __se_sys_getdents64 fs/readdir.c:396 [inline]
> >  __x64_sys_getdents64+0x143/0x2a0 fs/readdir.c:396
> >  ...
> >
> > [CAUSE]
> > The inline-dir invariant i_size <=3D id_count is never validated when a
> > dinode is read. ocfs2_validate_inode_block() accepts the corrupted
> > metadata, then ocfs2_populate_inode() or ocfs2_refresh_inode() copies
> > that unchecked on-disk i_size into inode->i_size.
> >
> > JBD2-managed buffers can also bypass ocfs2_validate_inode_block(), so
> > the same unchecked size can still reach ocfs2_populate_inode() and
> > ocfs2_refresh_inode() through those read paths.
> >
> > [FIX]
> > Introduce a shared helper that validates inline directory i_size
> > against id_count. Call it from ocfs2_validate_inode_block() so corrupt
> > inline-dir dinodes are rejected in the cold metadata-read path, and add
> > matching guards in ocfs2_read_locked_inode() and ocfs2_inode_lock_updat=
e()
> > for the JBD2-managed buffer paths that skip the validator.
> >
> > This blocks the corrupted metadata before it reaches VFS inode state
> > and keeps the hot readdir path unchanged.
> >
> > Fixes: 23193e513d1c ("ocfs2: Read support for directories with inline d=
ata")
> > Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> > ---
> > v2:
> > - Move the validation from ocfs2_dir_foreach_blk_id() to inode read pat=
hs
> > - Add JBD2-managed buffer guards in ocfs2_read_locked_inode() and ocfs2=
_inode_lock_update()
> > - Reword the changelog to describe unchecked on-disk i_size rather than=
 corrupted in-memory state
>
> ocfs2_validate_inode_block() already has the logic to check inline-data s=
ize.
> You can find it by searching for:
> "if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {"
>
> - Heming

My mistake.

I reran my reproducer on the latest upstream kernel and could not
reproduce the issue there, so based on the current repro results, it
appears that the bug has already been fixed.

Although code inspection still suggests that JBD-managed buffers may
bypass that validation path, my current reproducer has not been able
to trigger the bug on the latest kernel. We will continue testing to
determine whether there is still a reachable path here or whether the
issue has in fact already been fixed by another change.

Thanks,
ZhengYuan Huang

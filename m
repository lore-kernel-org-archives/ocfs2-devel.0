Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DAF800
	for <ocfs2-devel@lists.linux.dev>; Sun, 29 Dec 2024 02:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735437936; cv=none; b=nwxUWrkWOE8z8WBwRhuUpdZPW6Y/szafypyUGrT8XyNVaJn5u5S4lLu7wRhmNdcp8JfSttlpSgalCYEo8kvq6djYINiYSum7HXJLRxNrZe9Ln+oG57qhyTYVGCRvTsrNjyWXQKEnpZGWG8Z8Yj1YHYiSVdAGNleTcs6GV4hlrDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735437936; c=relaxed/simple;
	bh=phsBM079JfVBohmMdhAU1CvqevW8LvaVsOgJoTzaMDA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=R0hryoan7Osi6M0bGM9AtbF4v3yL57SHwdUsAntudli59NHoxKGTmlqj+6FYG3D42fqRP5gQ81Nb7IkQVfL0K10iY3BEjHzCjsRjjKj9wanqDGyRSNSeeNkJudOMdzFvHR8lKEJ34mYwRVWoWefjMZKbpJG/aN3Hfwby8yod7dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Smc1nKki; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Smc1nKki"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3f57582a2so16521652a12.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 28 Dec 2024 18:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1735437932; x=1736042732; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWfXGmiQQlP1QfqGYg0o5BH0waXKk8EfCgONalxWrRA=;
        b=Smc1nKkiTzPHaPkCRsXmeVE1sHFynKYnzBFLsO54hfJNgnJwUBm/lyvQ9hYJRe4uaz
         Z+N3bdwXE6j2d3TyNKNg+fym5TtCfgq99y1cy0mlzjaSyOWWtqlm1rN2vVdutRKisd3V
         XKzhVws3GND49eNzPgbFuQnzFZwmlpuKftkFDJuGq2QQ3KD3P1mAd95OM6sJAdoA5p+L
         6pv0XPV+Ouje0LAoDU6SqJNZW0nPBcFm10ibax2knJd4PpDmRaI/VWkdLv7/ilVZYENX
         VDhypHXEypzy/puDyMgyQALE4zJeGfJlCKrg2nsc6sjg0dwfrGkKsMivXCM82SraecPc
         pRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735437932; x=1736042732;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GWfXGmiQQlP1QfqGYg0o5BH0waXKk8EfCgONalxWrRA=;
        b=Mw/9a3OQB+OMjxaf3Z9jI65XlYetzSWSVYLeh6I75y6u6u5++I4oJHK6AYlCWaMN0p
         pET5B7M+/daLs34py90HStsgkQAZVT0Z0i/YSNgm8pYa8ObcokCIlETe6LbzykTjy44t
         tYstbEsgSiGQDTXl7QbWd6cNtZ1CWucX+LX2rOAAt8OhKoifKfQPu8ZlW4eFns18RBvs
         dQosAFs7xWlYKYU2Zny/SIizaTYHnEOG0ya9I9Nc4cohDJfYaueJhUt/LoAz/A4123sc
         696SfIpto2Csa9QYnPxy2hJI7X9agtq49r4djC9urvNJ/6zK1nxGxsTFgRaxj2m6KWwx
         b0sw==
X-Forwarded-Encrypted: i=1; AJvYcCX3fs2mFnu0LQxQYn+AkGiCH1tkBSoOdMDy7gZ+PJ17fW5JHJSfpfEinnkITD+Cpa1YQfUDr0Q3kE8x3A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwPk6tBvJcmUoSNKwc2I8C23a3c6p0mQ0TmuuMzrzTG53mFx8LZ
	BMRzw7r6mswoFa425anvL5K1Vi2B7ZQhavNRV512TlkEv2IK7p9HxSsRiytaNjE=
X-Gm-Gg: ASbGnct+vrGQdf9eJH5jb13qmXCamX4gmcsgO7c5awPXFeYjILLJYkMGS459kSoDYGV
	MIvkuPwS3IzUufOlggBBXE4sLUYyrMkXulDmLHF0+G8HsupPrgMZc/Kgw9DRHuyQnwH/ndyAUoe
	T4A1TujCfSi7a9Uh5eES8hdA6YkJsCTszgnxmis5zIo5UW2kx4HIs8gHNdKsVk1PPOz9SRQypdX
	UJ5mwMsH62UrW8siQGfj7wNVh8O0tUvmk33N7l+awxbu8XfKu4EVJ4kvzMg
X-Google-Smtp-Source: AGHT+IHxyryRtbX4gx+UYfFhIYaTOPL1y5Jh1p5BHeCs1XG6Z0LHkezJ7VW6bS3rIFd0+odXsd1GBg==
X-Received: by 2002:a17:906:415a:b0:aaf:c0:be7e with SMTP id a640c23a62f3a-aaf00c0c9d4mr1051765366b.29.1735437931947;
        Sat, 28 Dec 2024 18:05:31 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72afb89fedesm7420015b3a.84.2024.12.28.18.05.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Dec 2024 18:05:31 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] ocfs2: add extent record check in ocfs2_commit_truncate()
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20241217104345.358461-1-dmantipov@yandex.ru>
Date: Sun, 29 Dec 2024 10:05:17 +0800
Cc: Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCB4B87E-9C81-4212-8C05-CE160130A399@suse.com>
References: <20241217104345.358461-1-dmantipov@yandex.ru>
To: Dmitry Antipov <dmantipov@yandex.ru>
X-Mailer: Apple Mail (2.3826.200.121)



> On Dec 17, 2024, at 18:43, Dmitry Antipov <dmantipov@yandex.ru> wrote:
>=20
> Syzbot has reported the following BUG():
>=20
> Kernel BUG at fs/ocfs2/alloc.c:686!
> ...
> RIP: 0010:ocfs2_new_path fs/ocfs2/alloc.c:686 [inline]
> RIP: 0010:ocfs2_commit_truncate+0x2547/0x2550 fs/ocfs2/alloc.c:7234
> Call Trace:
> <TASK>
> ocfs2_truncate_for_delete fs/ocfs2/inode.c:623 [inline]
> ocfs2_wipe_inode fs/ocfs2/inode.c:790 [inline]
> ocfs2_delete_inode fs/ocfs2/inode.c:1079 [inline]
> ocfs2_evict_inode+0x1c46/0x4630 fs/ocfs2/inode.c:1216
> evict+0x4e8/0x9a0 fs/inode.c:796
> d_delete_notify include/linux/fsnotify.h:332 [inline]
> vfs_rmdir+0x3d7/0x510 fs/namei.c:4407
> do_rmdir+0x3b5/0x580 fs/namei.c:4453
> __do_sys_rmdir fs/namei.c:4472 [inline]
> __se_sys_rmdir fs/namei.c:4470 [inline]
> __x64_sys_rmdir+0x47/0x50 fs/namei.c:4470
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ...
> </TASK>
>=20
> In 'ocfs2_commit_truncate()', add an extra extent tree depth check
> to refuse further operations on (presumably) corrupted on-disk inode.

The BUG_ON is in ocfs2_new_path(). The grace way to avoid further
similar fuzz reports is that change the BUG_ON() to check and return
ERR_PTR(-EIO) but it needs change of all call sites. For now, I think
 the fix is fine.

> Reported-by: syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc16daba279a1161acfb0
> Fixes: 78f94673d7fa ("Ocfs2: Optimize ocfs2 truncate to use =
ocfs2_remove_btree_range() instead.")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
> fs/ocfs2/alloc.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 395e23920632..040aa2694f53 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -7219,12 +7219,20 @@ int ocfs2_commit_truncate(struct ocfs2_super =
*osb,
> struct ocfs2_extent_rec *rec;
> struct ocfs2_path *path =3D NULL;
> struct ocfs2_dinode *di =3D (struct ocfs2_dinode *)di_bh->b_data;
> + u16 tree_depth =3D le16_to_cpu(di->id2.i_list.l_tree_depth);

No need of tree_depth. Just call
If (unlikely(le16_to_cpu(di->id2.i_list.l_tree_depth) >=3D =
OCFS2_MAX_PATH_DEPTH))  {
...
> struct ocfs2_extent_list *root_el =3D &(di->id2.i_list);
> u64 refcount_loc =3D le64_to_cpu(di->i_refcount_loc);
> struct ocfs2_extent_tree et;
> struct ocfs2_cached_dealloc_ctxt dealloc;
> struct ocfs2_refcount_tree *ref_tree =3D NULL;
>=20
> + if (unlikely(tree_depth >=3D OCFS2_MAX_PATH_DEPTH)) {
> + ocfs2_error(inode->i_sb,
> +    "dinode %llu has invalid extent record depth %u\n",
> +    (u64)di_bh->b_blocknr, tree_depth);
> + return -EINVAL;

-EIO is better.

=E2=80=94=20
Su
> + }
> +
> ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
> ocfs2_init_dealloc_ctxt(&dealloc);
>=20
> --=20
> 2.47.1
>=20
>=20


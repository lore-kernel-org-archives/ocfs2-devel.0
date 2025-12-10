Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDCA2FC879
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 11:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765366103; cv=none; b=c+7XXk1rVz3ia3CJtPPJAk0xaBR/CYbICeOoYIWv+e+7UGurII/eBanVFjprnT0qOQcWnLjwalBIO1LU0xsxNSWx1qTHYoLsmdXvpKUW5tukuL+510Yfs8dE6XV84fVoK2AjJ0TtFb4J4/hffXbn3GpZx0EXHhWbMDtaZB8uf50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765366103; c=relaxed/simple;
	bh=XAXYptBcDX2fvYO//82dlDUOddwhzfae/Zs/jle65rc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fXraOvrkU+Mf54UpnQt1wip8dVUTS1UGGz7GMx8fErEQBO3HtIS9Fm2v7vo6YOgMpSg1f6whLYBC5NpfIYq5TbJUhS8mM+q6AbF+XKMjNAbV7FwlR1wsjUtzTWYm9hjL9y5e9QQ1mBdM0bVdcxo5f10hruvPBJ3yNgYUICmEIcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMNd/DD5; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMNd/DD5"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640b0639dabso10899264a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 03:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765366100; x=1765970900; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/OlIs4fA7vyKE19uOvZgraqstFeGDQidWxB59d9RmY=;
        b=aMNd/DD5Wcgz5adOWCF6eVKIRaKW72kfIGEQLPekwYwu0zjzh1IjP+ZgWIThGXTpap
         kHEB2MBMVw8qyN9sbgvK5DWZfIQbLKCwk4XgcBuuqPvRmxCLh32dR6FcbzS8xBwp/dNL
         FvnU8D8j7ScCqzStRfTuTBpqZx2k/66vz9jP6tKudt2cCqKRQ2d6oa8WkR5UfJrRruUz
         OhBh+V7ZADG6CQorn6dOqYjI6KmOkxJAIRuCKqTdnYJjmgV7vbU7gaC9qeqNotYCboGr
         k8u271KEF/s9VdJy2QjhfVKfgYoQcOnuTGaFjIKLze/daOVkEoncdtTMkMWS/LGxwP3J
         QyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765366100; x=1765970900;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3/OlIs4fA7vyKE19uOvZgraqstFeGDQidWxB59d9RmY=;
        b=uCkYYPbJXXaCO4iLwO1g8ECcnmeOddX1gxvhB0PzCr7nzoZNw9YGhDegH6gCZHIn6C
         0NfucP2N3LBsyYOGFpnhzxjhXphQgB4qnAHsqcM+bdJ8gYbI1N1oT24i+vh1XgA/GC+h
         77MkdtzDpYHegAngvKP8Z5Gzm6v1piEafLV9A95KqU/ktKGrE9OY6Eml31YMGwd7s44N
         9sAXP39kUwXb/pFLA54Sy7VjfPKAfn6L6zMrg3YYXEAMZfA5Fx7DAxr4cWYwJv9afiyz
         RGH0hoYdIlBxWA4ECAA8RsBKFEvLEMKaCaTuzRM8MB9LZFgFcK5BLDemUzaWSXMe+XL1
         aTAA==
X-Forwarded-Encrypted: i=1; AJvYcCVNI0/7A5lODMHc+H1S089m5X3rGzJj7w/lFjx/4mVxfod0BQuhpacjWajE2fkA6dT/gKLc9E+UpOSMRw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxcVrgFW0qE6c+ioMkykf4pWZ3IUN0kN7rb13ARjQofZaRRRd1h
	i1+rlwtlHG/gGUwAC5c64H2v5rzr+GajYRDOnApSnGVFhz5NoXAZWOpdXTjwT97ze/0V78oZirG
	Fyz87ufFpE5dQS1UtSKdzzbbmBgqJaBE=
X-Gm-Gg: AY/fxX72SJYLI08tUwr+1/E47WfcW9fApW4AY2//T+PSTQncHNssMAzUFyTOGEjFmfm
	gPnMIjC18mLQihXTLKL5mxWK1LEGgz6fgLaduWPgUJ03UNuXsttMtWFrUX+xS2VgOo2lMur7t7s
	IFDHDS4zBva44w3vcuxlSCv0JLwgfs1Ns8erboR7b+6MCbaHsn32zDox82OLvVvnnQ1Rou7I1N4
	0HwdEW7YtHqMaGOmyxqYo9pc3EyOS8Qbs5V1CtzLISB4YNMcsWGmmbm4VfSSmT0z7u6wneVEoJ0
	ySH+BN9mxYMc2sd7oap8+Qk0vZI=
X-Google-Smtp-Source: AGHT+IGI9z2LZl2WibgGATCYde2aL+JH7VhrQQY/TMvTfGol8TxjwJQZ+8ocqbRLU4TLms/TZMLHiCAIyDj9wQZG4H8=
X-Received: by 2002:a05:6402:27cc:b0:640:c640:98c5 with SMTP id
 4fb4d7f45d1cf-6496d5e5fc8mr1967549a12.34.1765366100233; Wed, 10 Dec 2025
 03:28:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f2ui7rofuos4vcuj7t7pa5tcyq5m3agm44ouk7hcdl7opiwmwd@dyctf7rrsuqw> <69395726.a70a0220.33cd7b.0006.GAE@google.com>
In-Reply-To: <69395726.a70a0220.33cd7b.0006.GAE@google.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 10 Dec 2025 12:28:07 +0100
X-Gm-Features: AQt7F2oNOko-4QXcehKn_iA5o50dm0UpHnz99JthCcbiFS8x7mF9mDdJg9Jb8S8
Message-ID: <CAGudoHH5KvF4aJiLSiEqu_UkHrqoCKt2XXRozDDh-Bub_usuSg@mail.gmail.com>
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 12:25=E2=80=AFPM syzbot
<syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot has tested the proposed patch but the reproducer is still triggeri=
ng an issue:
> kernel BUG in ocfs2_journal_toggle_dirty
>
> (syz.0.554,7359,0):ocfs2_assign_bh:2417 ERROR: status =3D -30
> (syz.0.554,7359,0):ocfs2_inode_lock_full_nested:2512 ERROR: status =3D -3=
0
> (syz.0.554,7359,0):ocfs2_shutdown_local_alloc:412 ERROR: status =3D -30
> ------------[ cut here ]------------
> kernel BUG at fs/ocfs2/journal.c:1027!
>  <TASK>
>  ocfs2_journal_shutdown+0x524/0xab0 fs/ocfs2/journal.c:1109
>  ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
>  ocfs2_fill_super+0x5574/0x63a0 fs/ocfs2/super.c:1083
>  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1751
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3636 [inline]
>  do_new_mount+0x302/0xa10 fs/namespace.c:3712
>  do_mount fs/namespace.c:4035 [inline]
>  __do_sys_mount fs/namespace.c:4224 [inline]
>  __se_sys_mount+0x313/0x410 fs/namespace.c:4201
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

That's a different bug.

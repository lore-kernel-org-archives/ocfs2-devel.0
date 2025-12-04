Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B230AACD
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Dec 2025 07:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764834324; cv=none; b=kwoozL0XJ72zWSo0wT8e7XkUeB4wKF4m5R1KZUT/Rqc+bRyeKVNtJPVpKewkkVNyI/m2ffdocF4Bjr32nEl/YxIVBjNZnCv+jem4LwuDvpGkyub8GlnyxsLDb0oMgid6JCtK/oeGT45tIC2q6tzeMf7Nlk3RFIfBYz9jTffjNbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764834324; c=relaxed/simple;
	bh=RrTlWpIqtgGY1sds/HoUlGvSPEX0LM6BkRc0xxMvr88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gMONYy0zWoMHddftfkdUSG+L4jw2+GiwSwz7gHQXEHXgR/ys3uhBR/iSN+YYTJNf2gGaizOwSP0yj4/pXCzqshlkqKFa+h6zvqCstoXmOLZIsgYm0Bd6YRP9Ip6JOetRKRI6O8y81q9+JH6s8X+KJ062xchOth09yCxp/+VjE+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0nlC9mS; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0nlC9mS"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so741875a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 03 Dec 2025 23:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764834320; x=1765439120; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GCW6tJSUzkuUwWazSC7GMvke61dgEKEVAI0iICTO6Nw=;
        b=B0nlC9mS2+p7cdzWTz+2Mw7BS23bBcz31gzs9Is556KBbeQr8M/2UO+lETzV4vODuL
         573Qz0R45RRj6V0AXBfRxpULNxUckq+REsoWLJ/dI4qWevWNkOCeJvzVEZE0TkTPc8/a
         LBZWA5v03gGBgmfmQhKFvQG1cPB4fkgDZD808pfvNf1Rv1OroWDGxYAFbdoCkHtsjvOb
         gubcD9EbZfPWAlRZMzsD8uTPjJdsdxZjE69/jB/k50kyoMAR9rjsCF8K9ub/fsvQgLSp
         jjtSZg2NM+g9gNXtS1y607RcKtD2Q57L4ydtG6vaU+9m3YLpHagS4O1Kg+wlZUPxkydR
         ZGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764834320; x=1765439120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GCW6tJSUzkuUwWazSC7GMvke61dgEKEVAI0iICTO6Nw=;
        b=kmieNlVnMeD4aBptbaQ+VSPn5Vz3Oz7vZtjxcLktB/ZvHR/WIyNJFGZmD7bOcB7yx8
         R8cL+LFL4WRRgFirtQR/IYK7/7wxfACQNi48QsoOXrDZzU37TARp8r23IcWK8vK07aBp
         7JiVjH03qLilsSpUWPRsA4pNxSFtxREJwEZ0cG51KVjeGl5Oawr5TiIM3jgdXjfE4V+A
         KaPF1iyuIlJq4jktGPdgNWXwSBqnVsWomAKNbkiuaRip9vUzBRTjx2PrLG8tF4hWsOOh
         De1MICpNNQFpTG/49Pl4drPxKNR3t+iqWH+DAfbmafSRqeuI3P22ZDmBLA1YWWCSPROK
         djtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhNx9/JY9HHV8gtkF4hLIDNq3xehl3lvVM61qx53smNRIWckmh1jtWMN6iwwsfhJoRnyRD5L3Eqoe+ng==@lists.linux.dev
X-Gm-Message-State: AOJu0YzkuPhIPPmMXD/awls9VEgVcsw8k1gI7XQxpDL6+ft/IpS3OZt2
	ho9yvBPS9Jyxs443BLYjOJiskft16tVcYrIJY5w2k6RyU478diVxVZkiL+j1Tda8SQ3Mvz+TAh5
	/JNHLyeTpNxLandFFrh+tQACyWGG2IWs=
X-Gm-Gg: ASbGnctMtTAOntMWO60iRqD81l+4uHNNgkFwcVZrbniE0IFvUj/QqN9e3xSFcqbHOzz
	cpvw74q8xrtlQC0m3IgCS5roXQyjOeVp4hEr57dAIX6/ES+8R2Y2CwNy5C2f1uQeRpJMtlo6N27
	1Yd1kcYIYP6Mcjtqx0lzbthZ3S1HgQ3YyhShLOkxjBKA3Ed4mpUsBxe9m4FrjZj9WT31ogGuk+H
	bhksafwfPdtqWI+dM/C2dWD8nIf0mUcuewQuxAw7IQ59fBmnFwAvZyLG6lZFgIlZp5OuyhEAAhm
	wT0IRc4ti+bjn0gTmTijyIWTNw==
X-Google-Smtp-Source: AGHT+IEW6nEgFDYPURnv+v93qP+JYZcAoOPn8xbtbhXkHYzDtOGkOndqro2kdjzMhRd2AONz1sK3oRC5iGP7CNBjs+I=
X-Received: by 2002:a05:6402:2696:b0:645:d34b:8166 with SMTP id
 4fb4d7f45d1cf-6479c529581mr4778744a12.26.1764834319966; Wed, 03 Dec 2025
 23:45:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6w4u7ysv6yxdqu3c5ug7pjbbwxlmczwgewukqyrap3ltpazp4s@ozir7zbfyvfj> <6930e200.a70a0220.d98e3.01bd.GAE@google.com>
In-Reply-To: <6930e200.a70a0220.d98e3.01bd.GAE@google.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 4 Dec 2025 08:45:08 +0100
X-Gm-Features: AWmQ_bnrH8oTpt6w8DaWw6tzlnw_HCO8tIUlHCSXHC5ARXQYE1OLwZmDfA5680k
Message-ID: <CAGudoHE0Q-Loi_rsbk5rnzgtGfbvY+Fpo9g=NPJHqLP5G_AaUg@mail.gmail.com>
Subject: Re: [syzbot] [exfat?] [ocfs2?] kernel BUG in link_path_walk
To: syzbot <syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linkinjeon@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 2:21=E2=80=AFAM syzbot
<syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot has tested the proposed patch but the reproducer is still triggeri=
ng an issue:
> kernel BUG in link_path_walk
>
> (syz.0.73,6964,1):ocfs2_find_entry_id:420 ERROR: status =3D -30
> ------------[ cut here ]------------
> kernel BUG at fs/namei.c:2532!

On the commit syzbot is testing on (b2c27842) and with the patch, the
triggered assert is the second one on S_ISDIR:
       VFS_BUG_ON(!d_can_lookup(nd->path.dentry));
       VFS_BUG_ON(!S_ISDIR(nd->path.dentry->d_inode->i_mode));

d_can_lookup is  __d_entry_type(dentry) =3D=3D DCACHE_DIRECTORY_TYPE;

Or to put it differently, lookup got entered with a bogus state of a
dentry claiming it is a directory, with an inode which is not. Per the
i_mode reported in the opening mail it is a regular file instead.

While I don't see how this can happen, I don't think it is *my* bug
either -- merely nothing else asserted on the 2 things being in
tandem.

syzbot likes to operate on corrupted filesystems, so I'm going to
assume things are going haywire in ocfs2 until proven otherwise.

> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 6964 Comm: syz.0.73 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/25/2025
> RIP: 0010:link_path_walk+0x1a57/0x1a90 fs/namei.c:2532
> Code: 89 e9 80 e1 07 fe c1 38 c1 0f 8c be fd ff ff 4c 89 ef e8 2c e5 e9 f=
f e9 b1 fd ff ff e8 62 90 83 ff 90 0f 0b e8 5a 90 83 ff 90 <0f> 0b e8 52 90=
 83 ff 90 0f 0b e8 4a 90 83 ff 4c 89 ff 48 c7 c6 40
> RSP: 0018:ffffc9000491f8a0 EFLAGS: 00010293
> RAX: ffffffff823e22d6 RBX: dffffc0000000000 RCX: ffff8880250f3d00
> RDX: 0000000000000000 RSI: 0000000000008000 RDI: 0000000000004000
> RBP: ffff888079181120 R08: ffff8880299ef520 R09: ffff88807acd2000
> R10: ffff8880299ef520 R11: ffff88807acd2000 R12: ffffc9000491fc58
> R13: ffffc9000491fc28 R14: 0000000000008000 R15: 0000000000100000
> FS:  00007ff92e2e36c0(0000) GS:ffff888125f49000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555575344808 CR3: 0000000025c92000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  path_openat+0x2b3/0x3dd0 fs/namei.c:4787
>  do_filp_open+0x1fa/0x410 fs/namei.c:4818
>  do_sys_openat2+0x121/0x200 fs/open.c:1430
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_open fs/open.c:1444 [inline]
>  __se_sys_open fs/open.c:1440 [inline]
>  __x64_sys_open+0x11e/0x150 fs/open.c:1440
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff92d38f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff92e2e3038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 00007ff92d5e5fa0 RCX: 00007ff92d38f749
> RDX: 0000000000000000 RSI: 0000000000145142 RDI: 0000200000000240
> RBP: 00007ff92d413f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff92d5e6038 R14: 00007ff92d5e5fa0 R15: 00007ffda4bd0278
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:link_path_walk+0x1a57/0x1a90 fs/namei.c:2532
> Code: 89 e9 80 e1 07 fe c1 38 c1 0f 8c be fd ff ff 4c 89 ef e8 2c e5 e9 f=
f e9 b1 fd ff ff e8 62 90 83 ff 90 0f 0b e8 5a 90 83 ff 90 <0f> 0b e8 52 90=
 83 ff 90 0f 0b e8 4a 90 83 ff 4c 89 ff 48 c7 c6 40
> RSP: 0018:ffffc9000491f8a0 EFLAGS: 00010293
> RAX: ffffffff823e22d6 RBX: dffffc0000000000 RCX: ffff8880250f3d00
> RDX: 0000000000000000 RSI: 0000000000008000 RDI: 0000000000004000
> RBP: ffff888079181120 R08: ffff8880299ef520 R09: ffff88807acd2000
> R10: ffff8880299ef520 R11: ffff88807acd2000 R12: ffffc9000491fc58
> R13: ffffc9000491fc28 R14: 0000000000008000 R15: 0000000000100000
> FS:  00007ff92e2e36c0(0000) GS:ffff888125e49000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1310116e9c CR3: 0000000025c92000 CR4: 00000000003526f0
>
>
> Tested on:
>
> commit:         b2c27842 Add linux-next specific files for 20251203
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D15d7801a58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dcaadf525b0ab8=
d17
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd222f4b7129379c=
3d5bc
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D1281d4c258=
0000
>

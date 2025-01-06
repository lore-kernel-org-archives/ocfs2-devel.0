Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92DB14D456
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 06:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736143875; cv=none; b=U86k2jZ6pexQoeC/5FZQ9WlZrIN6TsTomgRWA/izyk9eW4eP5JhqQuk6gwyec40KBPsIfxzWDOZN0QisMWE8QafXR9LGG+4FvJKi7bvYSEn5ZA2nZnDT4hUEgUBggI/d1cmAM+m26PlGn/8m7X49nqUf2FZBYqCE5MmfL3ii2FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736143875; c=relaxed/simple;
	bh=lQDYdv36K6LdGToaWwS8AQX3hI0/VlP97w2L2coP34o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rsCm19DEqruax71rtJTSeG3Nq65PgH2FSp++I81rtNMqdjBEwNQz61DR8/ywHntuHckUfc+vlHlXIE/rVir4xUjYSsp7nFfql5l4UGsx7SKF5kwWXkNtHaIwfHGbanqrzCyeSLY7i3Xw2w9YkSoOpKT2N0Szuv6023CSak9ck+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L6BwIp5j; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L6BwIp5j"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-436326dcb1cso92712995e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Jan 2025 22:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736143870; x=1736748670; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNemmaR2nwawnzux8rQV9TWcIHO/G+8KVolM+J/yFdc=;
        b=L6BwIp5jjwKCbXCQJy4u9rKmQJFzSr0/px3kvIeRw6BXzmAIM7UP9280W+3Dy6gOXJ
         FwjZuGDWYuXgsgkfC+jPUH/ve8CJ37afl+ntd4TAGpEzX6k/Xx2wA8inQBW5QOXMg9//
         JsM+ExHT6GT5A9H65nMfokKG2Z1Ear5yCXJ29YDXABQebj2s51ciYaPu6s+axgdESkuC
         Sq4LcyfmxXAkJqSHl6RFJlnaWTgpjFAMxaRygUwR/cQBT4hluXVTddfAR5y4+fUEqbbW
         8MyFDrZbyJUrZxy2YAbaey5KSTjrQY9rgUH8ru07lMqS99ZIZBBn/ZUCTg8V06CZSVfq
         K4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736143870; x=1736748670;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yNemmaR2nwawnzux8rQV9TWcIHO/G+8KVolM+J/yFdc=;
        b=Di5sNg1JL/W8PYPLH8d/nnJrVSe6q2QOKOhN+A+sZl4knPYSlq3g32NXvxQoxDUByJ
         0ov/ndpzGJtAOuxmTZRMwJtY7nLoqr1JisCJCNpg+zo2Duyi2ekWqiDbrPDWIDq+nnso
         B54xFL2/LkbbjnqQRtT7GxxACz3CKStaNGWPgtucZ6pQ1k7n3yX9d5+67yNUu9hFchEN
         qZk353rwYgpcK1s2P3oj/CWZ8pIYrQhiMQ14LgM+NJU9RmMTgla/cX+LYW9ySjusCOSC
         E7pqmiO2VU/yf9UGbtd1UMZq6+gSHv9W4q2iQoQmONnRCwMpKO/iG/a3FGaUVDVhXSLC
         pm4w==
X-Forwarded-Encrypted: i=1; AJvYcCVt2vu6lfTrbuLGoQnTS4Vw2tUKW69eoD+mrY24ZSTOQay+ohnP3ZKtLYqtKhYfn9GpypFaDmgTIP5AlQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywdy7KoLoM7E+jW3EuR2iN614aGVqFbHX7KnM84r6PzT+rx5R2c
	OD7Hp6MgQ4S9NyO6mCUEU9UkqsyV2sdEwdWA1v8ps7qkVqUUK64hEWTdpowz1O4=
X-Gm-Gg: ASbGncsoeMVQLSUQH00FlPsH2/5ur+KLpzQK4N+F8P+9YeyQ2JsHNPZRUuUfbVcWu1F
	4YFzRT10l1CG52OVk2LUb9DGhY81umNLkNSHBOBd7fq5VHgJwtegfX4uGniH4pURPFHdM05w4wR
	c6JVZVsPoOzSdOljwGcYPwkPxOtrHZCFIFjbRG6ZtjDs5MR2X97rHOHgpiEtPC5yC0MzhHEOkuu
	jdUbuiTHjsIQXcW80Lbsa2iPuWe02YbYOEBbhMjoHbWaRuoLAnoMeEluOE=
X-Google-Smtp-Source: AGHT+IGqJtC2/xGwOmcdB3UbUCw1CwaggPsIZf/sY4CwKla3MepH6vKa5RI0ddt+tlhJpKydphtBWQ==
X-Received: by 2002:a5d:59ac:0:b0:385:db11:badf with SMTP id ffacd0b85a97d-38a221fb47amr46550843f8f.22.1736143869908;
        Sun, 05 Jan 2025 22:11:09 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46a95338dccsm114859841cf.56.2025.01.05.22.11.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Jan 2025 22:11:08 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_append
From: Glass Su <glass.su@suse.com>
In-Reply-To: <67720802.050a0220.2f3838.04b5.GAE@google.com>
Date: Mon, 6 Jan 2025 14:10:52 +0800
Cc: jlbec@evilplan.org,
 Joseph Qi <joseph.qi@linux.alibaba.com>,
 linux-kernel@vger.kernel.org,
 mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A32B849-6C84-44AD-8747-CF3983926C29@suse.com>
References: <67720802.050a0220.2f3838.04b5.GAE@google.com>
To: syzbot <syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On Dec 30, 2024, at 10:40, syzbot =
<syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot has tested the proposed patch but the reproducer is still =
triggering an issue:
> kernel BUG in ocfs2_truncate_log_append
>=20
> (syz.0.15,5809,0):ocfs2_truncate_log_append:5874 ERROR: bug =
expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) || =
tl_count =3D=3D 0
> (syz.0.15,5809,0):ocfs2_truncate_log_append:5874 ERROR: Truncate =
record count on #77 invalid wanted 39, actual 2087
> ------------[ cut here ]------------
> kernel BUG at fs/ocfs2/alloc.c:5874!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5809 Comm: syz.0.15 Not tainted =
6.13.0-rc5-syzkaller-gfc033cf25e61-dirty #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
> Code: bc 24 a0 00 00 00 48 c7 c6 dd 83 0d 8e ba f2 16 00 00 48 c7 c1 =
40 4a 47 8c 4d 89 f0 41 89 d9 50 e8 6d 7d 20 00 48 83 c4 08 90 <0f> 0b =
e8 11 bf 21 fe 90 0f 0b e8 09 bf 21 fe 90 0f 0b e8 c1 24 40
> RSP: 0018:ffffc900027def60 EFLAGS: 00010296
> RAX: d6f52f3429698400 RBX: 0000000000000027 RCX: d6f52f3429698400
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc900027df090 R08: ffffffff817f0a3c R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff11009d5dd58
> R13: ffffff3800000000 R14: 000000000000004d R15: ffff88801227c008
> FS:  00007f02de6956c0(0000) GS:ffff88801fc00000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000f000 CR3: 00000000444da000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
> ocfs2_remove_inode_range+0xff3/0x29c0 fs/ocfs2/file.c:1907
> ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
> ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
> ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2740
> vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1584
> __do_sys_copy_file_range fs/read_write.c:1670 [inline]
> __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f02dd97e719
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f02de695038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
> RAX: ffffffffffffffda RBX: 00007f02ddb35f80 RCX: 00007f02dd97e719
> RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f02dd9f132e R08: 000000000000d8c2 R09: 0000000000000000
> R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007f02ddb35f80 R15: 00007ffc7cf04758
> </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
> Code: bc 24 a0 00 00 00 48 c7 c6 dd 83 0d 8e ba f2 16 00 00 48 c7 c1 =
40 4a 47 8c 4d 89 f0 41 89 d9 50 e8 6d 7d 20 00 48 83 c4 08 90 <0f> 0b =
e8 11 bf 21 fe 90 0f 0b e8 09 bf 21 fe 90 0f 0b e8 c1 24 40
> RSP: 0018:ffffc900027def60 EFLAGS: 00010296
> RAX: d6f52f3429698400 RBX: 0000000000000027 RCX: d6f52f3429698400
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc900027df090 R08: ffffffff817f0a3c R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff11009d5dd58
> R13: ffffff3800000000 R14: 000000000000004d R15: ffff88801227c008
> FS:  00007f02de6956c0(0000) GS:ffff88801fc00000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000f000 CR3: 00000000444da000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>=20
>=20
> Tested on:
>=20
> commit:         fc033cf2 Linux 6.13-rc5
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D1136aaf8580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Df52ce141d88125fd
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Da66542ca5ebb4233b563
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> patch:          =
https://syzkaller.appspot.com/x/patch.diff?x=3D10ffa818580000
>=20

I don=E2=80=99t get why the patch:          =
https://syzkaller.appspot.com/x/patch.diff?x=3D10ffa818580000 is wrong.

#syz test: https://github.com/Damenly/linux ocfs2-syz=

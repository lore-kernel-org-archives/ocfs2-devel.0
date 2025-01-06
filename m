Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3FF15666A
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 06:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736144705; cv=none; b=Pb4FYXLNpvAW65zBQCIVn4MDsqijxdAatCN3RuM7VDDyBu0Hqa7ueWfpM4/AOcWQ2+GIP9bDCcIXHnzHi5s/XyYIXrblesQS2kppp5PFJ1+Ig96wolnNKaJPj7/pcU6PbUmq3ZWdFqSTswBb4hmhWKUdl5//0dmjkI6uS2Pix6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736144705; c=relaxed/simple;
	bh=LYuQC+yw4GGguc2gm5QWSojWTg5aVxRHtjTyq/xkTpQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iIYW3z/+fJ+qgbOZ9ppWY6Q8OJrMlD3q3UqhhtWk5Rr/y9lTXMbwonxQdU+oHM4YETKxpfQyWSrrjkIwHrqOFjZ4GqdEEb0N8WtVsg/zA4ynkRsycnAN4OkLuGbhk7V9gXSXRioR8blEtu/pMyMcaaczEMKmW+RIgSs1zVn7xxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a9d4ea9e0cso138122185ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Jan 2025 22:25:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736144703; x=1736749503;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q84u+dsdlcLRH1SUCFrF/rzaG/ts/JoKR2QXMS2SLq4=;
        b=a17p8jO2QM/6kSFhZCZaPDFwlgJWAV5avt3cAhxhKeOKq+E6Q2gxchYSgzDRiOW8r1
         Pt+VaoiiOSM+c2yGhOua1uPapiohHSdy2YhlV9yNVXnzU9EP+8svIERCtp7QxEP0APqp
         P2HVw1ywda6PxiyJ66Wujx6AfkkCpq2lFDX588vMVAFI+geDiwFzC378cSPG9+r5SOGo
         f2qktqicbrsdC6pEuq0zuxU//0ATweZkXNKmbKat6gzAhBk4HAHA+86fvsauc11Ls3Pr
         r3l4OH3W7FZV2w0CeabKLevnCOiFs+/nHVRuHrqzNFYrgjOGg2py3VwBxxo8173rGmVc
         eHNw==
X-Forwarded-Encrypted: i=1; AJvYcCUSKs/L7St17XsTMyH8d3eCB3VfOnOiSi3zhCxoz29BoQeK+c4XDnGvHKRhlFCr/pQE7TNSNzffiJquRQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwXV1lQLF9pf2egCScQt68EpHUoKi75ySaHqD7qPFV/XF7Rtw4H
	XsvewdP1uqyzIsHJV9MwvzpBMQdPAcUfTUG5WVznLqzNo1Olx8tPgOvqMeA01vtmyPzVr9QftaX
	eku1wZcR/qpp7BzZUmb9BsA0a7N5vic7SmUwijTefzKN6kNeqIB5ITf0=
X-Google-Smtp-Source: AGHT+IErjpdwNvqHpltG1/nefJ+KLa/AhO4SoNvgWleB7/okkcfYFeJUpdD60P272eORFEiCfrlrObgKHbdP0ib2Xkl+FWa3Fec9
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cb:b0:3a7:d792:d6ad with SMTP id
 e9e14a558f8ab-3c2d5918ac8mr352461045ab.22.1736144703291; Sun, 05 Jan 2025
 22:25:03 -0800 (PST)
Date: Sun, 05 Jan 2025 22:25:03 -0800
In-Reply-To: <1A32B849-6C84-44AD-8747-CF3983926C29@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677b773f.050a0220.3b3668.0004.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_append
From: syzbot <syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com>
To: glass.su@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in ocfs2_truncate_log_append

(syz.0.15,5818,0):ocfs2_truncate_log_append:5874 ERROR: bug expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) || tl_count == 0
(syz.0.15,5818,0):ocfs2_truncate_log_append:5874 ERROR: Truncate record count on #77 invalid wanted 39, actual 2087
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5874!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5818 Comm: syz.0.15 Not tainted 6.13.0-rc4-syzkaller-g7dace56f464b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
Code: bc 24 a0 00 00 00 48 c7 c6 0f 85 0d 8e ba f2 16 00 00 48 c7 c1 00 4b 47 8c 4d 89 f0 41 89 d9 50 e8 ed 7d 20 00 48 83 c4 08 90 <0f> 0b e8 91 bd 21 fe 90 0f 0b e8 89 bd 21 fe 90 0f 0b e8 e1 22 40
RSP: 0018:ffffc90002a7ef60 EFLAGS: 00010296
RAX: 3de6beb9eda26200 RBX: 0000000000000027 RCX: 3de6beb9eda26200
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90002a7f090 R08: ffffffff817f0a8c R09: 1ffff9200054fd5c
R10: dffffc0000000000 R11: fffff5200054fd5d R12: 1ffff11007e58958
R13: ffffff3800000000 R14: 000000000000004d R15: ffff88804f32c008
FS:  00007f7dae2556c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 0000000056b52000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
 ocfs2_remove_inode_range+0xff3/0x29c0 fs/ocfs2/file.c:1907
 ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
 ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
 ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2740
 vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1584
 __do_sys_copy_file_range fs/read_write.c:1670 [inline]
 __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7dad37e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7dae255038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f7dad535f80 RCX: 00007f7dad37e719
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f7dad3f132e R08: 000000000000d8c2 R09: 0000000000000000
R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f7dad535f80 R15: 00007ffffb564de8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
Code: bc 24 a0 00 00 00 48 c7 c6 0f 85 0d 8e ba f2 16 00 00 48 c7 c1 00 4b 47 8c 4d 89 f0 41 89 d9 50 e8 ed 7d 20 00 48 83 c4 08 90 <0f> 0b e8 91 bd 21 fe 90 0f 0b e8 89 bd 21 fe 90 0f 0b e8 e1 22 40
RSP: 0018:ffffc90002a7ef60 EFLAGS: 00010296
RAX: 3de6beb9eda26200 RBX: 0000000000000027 RCX: 3de6beb9eda26200
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90002a7f090 R08: ffffffff817f0a8c R09: 1ffff9200054fd5c
R10: dffffc0000000000 R11: fffff5200054fd5d R12: 1ffff11007e58958
R13: ffffff3800000000 R14: 000000000000004d R15: ffff88804f32c008
FS:  00007f7dae2556c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 0000000056b52000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         7dace56f ocfs2: check dir i_size in ocfs2_find_entry
git tree:       https://github.com/Damenly/linux ocfs2-syz
console output: https://syzkaller.appspot.com/x/log.txt?x=12b4b9c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5ad6ebf66b1e197
dashboard link: https://syzkaller.appspot.com/bug?extid=a66542ca5ebb4233b563
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.

Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6565B21A
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 12:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764590707; cv=none; b=gqT5x5bVUG2SpPS21FkDa3bdoRU4CqSLqUzs1JkFr2w7v5htx7Li9GcuZ0AahIX+UGvk2MFeSJjsfiGEVZLOhZFwGlvFUZni8ejTyVT+1NaEgofMjehui9VAalKrMp1ZyLc6zaXxtv6ehuBxuVDwfp/HEbm1nw4g0IPa5+MfQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764590707; c=relaxed/simple;
	bh=BB1U+eW50bjUYdPuu7FJk40T+cdc/59COdoTbefiU90=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=PsIpCEK1BaiyAwb82PvOv6SPhpdHC/vea6dA83/8Ud/l4+9kLX4B15r6KkPaxsFwO9mpi//r7pUdbo04OmPGViHBOagsNTx/PILUY3Mioq/+HJ2LYfTCTczKODFzDjNu7lTLo6QMwBapQzNBcKD8IfGzwVYfB5V81ADhCCurpnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9490672b7aeso239131239f.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 04:05:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764590704; x=1765195504;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFfjeJddVOrxIpgWyp38ZxIEXlCAgSoMDRaHy3gYyRQ=;
        b=Piy/vBx5wlZjd19NsUKRXwsyaSIFdPQwpAIlU/Si6o9forqbXlh+h0DpR/BZBUQ3+c
         gry4EMrgjd43uL4LMtWJQ9O1lKcMAIXqTzfqAEKVJsFa/r7DIj9GbwlLAOPozqxpnshD
         M3gOa82tiCJT4rLHzW8uLcOoYyZlDJwYEZu0xxMPeXzj6M/MZjOKdM4EomwUMZMuH+VJ
         2FX2Bzs7uHgMBt24fcgHppMk8qX+H5YJ9UxqM1lFr2xnlWhiLGIqGGlVzdZklOyOEmfv
         6HCOJdK0Bkng+3OZDrnqQ2gcJ4E4k5cn3PEZkAy6imiZzojQyizhGJunudt2hm2cY+yJ
         3IHQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4N53aVr6TvTbuvxcY1xS8KP1y+Yehp6ePlfeSA5sY1hrglh4jCJR5qk8NeUqmWdxFb8C5XzFWfkBp9g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwcUw23G5QhTDIldDEKlG0TJVq/8Nub2PYWWALuCwSWFSd/gNLX
	5LoKs95gsJsYf7kgAt7NCszX1AQWgZeTGbZQ80AnRN8XujzdTB/hdAhpKhbDJb8uupcjag26m0S
	mYTJ1w/vzxV+eGsI8oOkd/KPQ0w/5n9ubrpLhZmcfABHbSHFeiU10BlNM8Go=
X-Google-Smtp-Source: AGHT+IFmjKehZ3eRdzi2JpC+C3wz1dKaQ/yiS9pjM6QtmkPRj/qZx6zKua5SiCMnliz+ETnTwoyzcWj+MHvo7KmwHiTcLD2Wg3rp
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:120b:b0:576:54b5:34ee with SMTP id
 8926c6da1cb9f-5b967a20479mr21926432173.9.1764590703950; Mon, 01 Dec 2025
 04:05:03 -0800 (PST)
Date: Mon, 01 Dec 2025 04:05:03 -0800
In-Reply-To: <20251201114321.121153-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692d846f.a70a0220.d98e3.0187.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_claim_suballoc_bits
From: syzbot <syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in ocfs2_claim_suballoc_bits

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
OCFS2: ERROR (device loop0): int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *, handle_t *, u32, u32, struct ocfs2_suballoc_result *): Chain allocator dinode 71 has invalid next free chain record 0, but only 0 total
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:1443!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6562 Comm: syz.0.16 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:ocfs2_find_victim_chain fs/ocfs2/suballoc.c:1443 [inline]
RIP: 0010:ocfs2_claim_suballoc_bits+0x25b9/0x25d0 fs/ocfs2/suballoc.c:2005
Code: 5f fb ff ff e8 08 41 1c fe 90 0f 0b e8 00 41 1c fe 90 0f 0b e8 f8 40 1c fe 90 0f 0b e8 f0 40 1c fe 90 0f 0b e8 e8 40 1c fe 90 <0f> 0b e8 e0 40 1c fe 90 0f 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00
RSP: 0018:ffffc90003496e80 EFLAGS: 00010293
RAX: ffffffff83a40da8 RBX: 0000000000000000 RCX: ffff888025d78000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003497110 R08: ffff888072d4c103 R09: 1ffff1100e5a9820
R10: dffffc0000000000 R11: ffffed100e5a9821 R12: ffff88806f212ec4
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888072a78000
FS:  00007f6946c846c0(0000) GS:ffff888125c86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2dd5ffff CR3: 0000000027c28000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __ocfs2_claim_clusters+0x303/0x8f0 fs/ocfs2/suballoc.c:2430
 ocfs2_local_alloc_new_window fs/ocfs2/localalloc.c:1166 [inline]
 ocfs2_local_alloc_slide_window fs/ocfs2/localalloc.c:1295 [inline]
 ocfs2_reserve_local_alloc_bits+0x12be/0x24e0 fs/ocfs2/localalloc.c:669
 ocfs2_reserve_clusters_with_limit+0x1be/0xba0 fs/ocfs2/suballoc.c:1168
 ocfs2_mknod+0xe32/0x2050 fs/ocfs2/namei.c:354
 ocfs2_mkdir+0x191/0x440 fs/ocfs2/namei.c:656
 vfs_mkdir+0x303/0x510 fs/namei.c:4366
 do_mkdirat+0x247/0x590 fs/namei.c:4399
 __do_sys_mkdirat fs/namei.c:4416 [inline]
 __se_sys_mkdirat fs/namei.c:4414 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4414
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6945d8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6946c84038 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f6945fb5fa0 RCX: 00007f6945d8e929
RDX: 0000000000000081 RSI: 0000200000000000 RDI: ffffffffffffff9c
RBP: 00007f6945e10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f6945fb5fa0 R15: 00007ffc37f061f8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_find_victim_chain fs/ocfs2/suballoc.c:1443 [inline]
RIP: 0010:ocfs2_claim_suballoc_bits+0x25b9/0x25d0 fs/ocfs2/suballoc.c:2005
Code: 5f fb ff ff e8 08 41 1c fe 90 0f 0b e8 00 41 1c fe 90 0f 0b e8 f8 40 1c fe 90 0f 0b e8 f0 40 1c fe 90 0f 0b e8 e8 40 1c fe 90 <0f> 0b e8 e0 40 1c fe 90 0f 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00
RSP: 0018:ffffc90003496e80 EFLAGS: 00010293
RAX: ffffffff83a40da8 RBX: 0000000000000000 RCX: ffff888025d78000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003497110 R08: ffff888072d4c103 R09: 1ffff1100e5a9820
R10: dffffc0000000000 R11: ffffed100e5a9821 R12: ffff88806f212ec4
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888072a78000
FS:  00007f6946c846c0(0000) GS:ffff888125d86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e32d8b1950 CR3: 0000000027c28000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         939f15e6 Merge tag 'turbostat-2025.06.08' of git://git..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=12f502b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc9fa9d12bdc372
dashboard link: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12d958c2580000


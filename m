Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4526C2AF04
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Dec 2024 02:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735526404; cv=none; b=uFozsW7gHbYKSobC7FIXr8diVMXVz3eNoP3M0G7oJlT32oZc4dP3gVNvTIl7uIbOuCw7Tb9T+ysIC7x/zPGf3rIfIYIxazhERllzV6hEdNiaP3jWNZn7qAnJgVT4Wh0OcLMfFY35JacXa6CHJ86xh/xjbplYAl9JbnuXFi4ANrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735526404; c=relaxed/simple;
	bh=cuTdM4lkm7bAMUDs1nbbXscuD967/zqwxBBf46TTMmg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=LflNAOcGOxfXpOUdcSis7fLzlr/YhPW6MtWHAnoFRjOakPu4RtkVuvfTEYsmd6ZWy8Y2Y6SiV5AV0/o8e6yJo0VCCXVu0HhKWnKrhNa/WbwldqncwObGPHmWR700fz4BnHH58iRo20NKR8YwVGebxMPQLg02SD7wldvgVpbItn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a7e4bfae54so86142435ab.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Dec 2024 18:40:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735526402; x=1736131202;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rFd4czk0PYPGWITZiB8Qo4AwdOPEM2gAzHOjO41rScc=;
        b=oEuBr8/xy8p+rjgAu1WdWxp+0BMbevY06vQ/sC30P+/wDHfjIwDt5vAVgc/Xp9t3QD
         Rwy+khgU0NdZtVwo+d0bVIz8eyHgjSxaddaBxtsxuBFb+/AiChwjI0Br/i6hIxFg4530
         i37fpfFi4rjkhhNpva+3fTdlFryQ5mFLpOChHAsODS2aF7pAVsn8OvJudRKVF5vYL124
         POEyNi2aJ+sdkp6pQbgZoRAObdi0OUNMzlzKNRdZa3kH6CYUPVgS2PKfNi2cjmhL/yiy
         l6Q7uv6vN/3boyRXmkORtW3n12SMgJt+4hd3TiZ2byMt30oSuCZ4wW4+MQrKunAlxH3/
         vyEg==
X-Forwarded-Encrypted: i=1; AJvYcCXrVZpMGi5h2GQOuK5+BLz73quEaTsiQ7XhyBQB8mjJyj13mWYyQb1XpR8MYFW/yK3xkLopkYGaJmpXuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxwQHJqRs66rrD0MA5X8mejq1AFfZNMKTfkeV1wmk3gyh+Yk4Or
	eRJYevmKnWGMJLmX24DKRqwZuz/yX8wyafawj0/zkTSG2fHaC1N4qLzKMWjnDs52E6T2JUOtWLs
	ebyzxLCsdKzcYaFYu6Enu03C/o6RrCH14Oet1CyNYLqBmwpTU2BfFAAE=
X-Google-Smtp-Source: AGHT+IGAC8RqxZ/H0AgXvennnS804l5xUcfjOZr6APiHBToH4CIgDmirjEsTKVN5otmXk38jZm7cKXFqAPXJbofz53Qe8nQlK4O6
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b29:b0:3a7:9736:501e with SMTP id
 e9e14a558f8ab-3c2d2881756mr253730595ab.14.1735526402464; Sun, 29 Dec 2024
 18:40:02 -0800 (PST)
Date: Sun, 29 Dec 2024 18:40:02 -0800
In-Reply-To: <F98EECF0-AC75-4617-9D1B-5D095D3B7DFA@suse.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67720802.050a0220.2f3838.04b5.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_append
From: syzbot <syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com>
To: glass.su@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in ocfs2_truncate_log_append

(syz.0.15,5809,0):ocfs2_truncate_log_append:5874 ERROR: bug expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) || tl_count == 0
(syz.0.15,5809,0):ocfs2_truncate_log_append:5874 ERROR: Truncate record count on #77 invalid wanted 39, actual 2087
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5874!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5809 Comm: syz.0.15 Not tainted 6.13.0-rc5-syzkaller-gfc033cf25e61-dirty #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
Code: bc 24 a0 00 00 00 48 c7 c6 dd 83 0d 8e ba f2 16 00 00 48 c7 c1 40 4a 47 8c 4d 89 f0 41 89 d9 50 e8 6d 7d 20 00 48 83 c4 08 90 <0f> 0b e8 11 bf 21 fe 90 0f 0b e8 09 bf 21 fe 90 0f 0b e8 c1 24 40
RSP: 0018:ffffc900027def60 EFLAGS: 00010296
RAX: d6f52f3429698400 RBX: 0000000000000027 RCX: d6f52f3429698400
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc900027df090 R08: ffffffff817f0a3c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff11009d5dd58
R13: ffffff3800000000 R14: 000000000000004d R15: ffff88801227c008
FS:  00007f02de6956c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 00000000444da000 CR4: 0000000000352ef0
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
RIP: 0033:0x7f02dd97e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f02de695038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f02ddb35f80 RCX: 00007f02dd97e719
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f02dd9f132e R08: 000000000000d8c2 R09: 0000000000000000
R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f02ddb35f80 R15: 00007ffc7cf04758
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
Code: bc 24 a0 00 00 00 48 c7 c6 dd 83 0d 8e ba f2 16 00 00 48 c7 c1 40 4a 47 8c 4d 89 f0 41 89 d9 50 e8 6d 7d 20 00 48 83 c4 08 90 <0f> 0b e8 11 bf 21 fe 90 0f 0b e8 09 bf 21 fe 90 0f 0b e8 c1 24 40
RSP: 0018:ffffc900027def60 EFLAGS: 00010296
RAX: d6f52f3429698400 RBX: 0000000000000027 RCX: d6f52f3429698400
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc900027df090 R08: ffffffff817f0a3c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff11009d5dd58
R13: ffffff3800000000 R14: 000000000000004d R15: ffff88801227c008
FS:  00007f02de6956c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 00000000444da000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


Tested on:

commit:         fc033cf2 Linux 6.13-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1136aaf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f52ce141d88125fd
dashboard link: https://syzkaller.appspot.com/bug?extid=a66542ca5ebb4233b563
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10ffa818580000


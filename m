Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793431DF256
	for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 21:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761429273; cv=none; b=h9gM/rZw3IExH4EUQ+4QcKt+uuC4apUPDm/807mQhhQRVJCcBNLOWs1g3qV4SGzAlnoMBerhOMSLQZa2XpnsiWxboySQSloM00sMVoUygcBd8ySh+EhClx0I8Adc+onaXbBPWapxEn11sk0r0/bEmLuFJWRl33UpwrkmHcSiTvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761429273; c=relaxed/simple;
	bh=JUFCk2b3q4NWznqEsdIiWE2fWpm6sZb1vcEUhwwy7Rs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WWx+kd5+2IuQ6R1dOzxxHDKm4naLKjo2vXCqSwd5cfbm9F5w0GOiU6BgIiGM2IoTtVBS2FfLE9uR7DG3azN25gE2gickAp376YZJkRe0NBarT1Dls6oPW1r/lFZFUeavnJw+w1gz1MqjrOcG0o2ylCW18nO+3ggEFv8iG6QBTVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-431f20be851so17015215ab.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 14:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761429270; x=1762034070;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ClV3ZeL1Y+tIFEcvdME/1DYGFdqnexVcINdMwTUQ/4A=;
        b=OrdHOJbkh+vvqknsR3/VTtlYxXr7BpKIvv8qk6d1VV5ceFclKSlrGnXYc5WZiZsexm
         /Q5fdBcFZu29JUN2CyqyIQdMQCHzrXZh4KcFN0uB6+WfmiNW2Hhar8UKKNnIuQCWpD0G
         am3C0vOzOw3CwOHr4q9Zxak+FhXbQf6nILLu7/F3D82lf65ox7kf4P5Otk75+1K/CKa6
         aXIUDkeNPyu1Tl3OFgOgyUcic+czIyOtWc5Hd1gDrUIHDP4GwOWjj0Toj97hghF9z1xE
         XxQ5hJpwAycV4l5KcL90gzFsevuhnBJ6Ed5xubTdXCPSti2I+FFGZ6QL4H539o4i1lIV
         /bog==
X-Forwarded-Encrypted: i=1; AJvYcCXGtgTnD4GimTpPZAey+2XPYP80y0CcE524BKNEunSM7JkJ0qISGoYlKR6m1L6ZQUbjLiHcei8XtLKJuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyyrSVuNljliUa/sHSSivSa4zxTcDGqBg8GgpZU1keLzNAa9Y4t
	DplofewuH0WagPbetlho4KqfVeOTtaJv5vrCKg9A1R0LuKv1OICsbmjQegTdUZHIYF3/e/m2fHh
	ka3IBdx9dvGw560Hey57Pyjd4bvHs9mTLBTvdwcwG4It0NjCguYB2FeouGHA=
X-Google-Smtp-Source: AGHT+IGYASKP8hU31QI0trilywDw31OIxZOXXBUT5ZKD8CVkHRLF0C+8oJSCZ8wIM1De8sDbw67hl19Hri2UeJckvuAe6Kdc9wql
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0c:b0:430:c38f:fb82 with SMTP id
 e9e14a558f8ab-430c5223b84mr401619015ab.8.1761429270642; Sat, 25 Oct 2025
 14:54:30 -0700 (PDT)
Date: Sat, 25 Oct 2025 14:54:30 -0700
In-Reply-To: <68f4abbe.050a0220.1186a4.052a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fd4716.050a0220.346f24.039a.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] divide error in ocfs2_block_group_fill (3)
From: syzbot <syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    566771afc7a8 Merge tag 'v6.18-rc2-smb-server-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112ec7e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=25811b07889c90db
dashboard link: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141ca614580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=156b4be2580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-566771af.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d8d15ef51fac/vmlinux-566771af.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7f77bbb0b916/bzImage-566771af.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/34711c27aae5/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1061bb04580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com

         option from the mount to silence this warning.
=======================================================
ocfs2: Mounting device (7,0) on (node local, slot 0) with writeback data mode.
Oops: divide error: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5467 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
Code: 34 1a 49 81 c6 50 01 00 00 45 0f b7 3f 49 83 c5 02 4c 89 e8 48 c1 e8 03 42 0f b6 04 20 84 c0 0f 85 eb 03 00 00 44 89 f8 31 d2 <66> 41 f7 75 00 0f b7 d8 4c 89 f0 48 c1 e8 03 42 0f b6 04 20 84 c0
RSP: 0018:ffffc90002b2f080 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888000dba480
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002b2f188 R08: 00313050554f5247 R09: 00313050554f5247
R10: dffffc0000000000 R11: ffffed1009f9b801 R12: dffffc0000000000
R13: ffff88804fcc24c2 R14: ffff88804fcdc150 R15: 0000000000000000
FS:  000055558f3fe500(0000) GS:ffff88808d733000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fd63fff CR3: 00000000431d7000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_block_group_alloc_discontig fs/ocfs2/suballoc.c:634 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:703 [inline]
 ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
 ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
 ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306
 ocfs2_mkdir+0x191/0x440 fs/ocfs2/namei.c:659
 vfs_mkdir+0x306/0x510 fs/namei.c:4453
 do_mkdirat+0x247/0x590 fs/namei.c:4486
 __do_sys_mkdirat fs/namei.c:4503 [inline]
 __se_sys_mkdirat fs/namei.c:4501 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4501
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3f05d8efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdff269308 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f3f05fe5fa0 RCX: 00007f3f05d8efc9
RDX: 0000000000000000 RSI: 00002000000000c0 RDI: ffffffffffffff9c
RBP: 00007f3f05e11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3f05fe5fa0 R14: 00007f3f05fe5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
Code: 34 1a 49 81 c6 50 01 00 00 45 0f b7 3f 49 83 c5 02 4c 89 e8 48 c1 e8 03 42 0f b6 04 20 84 c0 0f 85 eb 03 00 00 44 89 f8 31 d2 <66> 41 f7 75 00 0f b7 d8 4c 89 f0 48 c1 e8 03 42 0f b6 04 20 84 c0
RSP: 0018:ffffc90002b2f080 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888000dba480
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002b2f188 R08: 00313050554f5247 R09: 00313050554f5247
R10: dffffc0000000000 R11: ffffed1009f9b801 R12: dffffc0000000000
R13: ffff88804fcc24c2 R14: ffff88804fcdc150 R15: 0000000000000000
FS:  000055558f3fe500(0000) GS:ffff88808d733000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fd63fff CR3: 00000000431d7000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	34 1a                	xor    $0x1a,%al
   2:	49 81 c6 50 01 00 00 	add    $0x150,%r14
   9:	45 0f b7 3f          	movzwl (%r15),%r15d
   d:	49 83 c5 02          	add    $0x2,%r13
  11:	4c 89 e8             	mov    %r13,%rax
  14:	48 c1 e8 03          	shr    $0x3,%rax
  18:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
  1d:	84 c0                	test   %al,%al
  1f:	0f 85 eb 03 00 00    	jne    0x410
  25:	44 89 f8             	mov    %r15d,%eax
  28:	31 d2                	xor    %edx,%edx
* 2a:	66 41 f7 75 00       	divw   0x0(%r13) <-- trapping instruction
  2f:	0f b7 d8             	movzwl %ax,%ebx
  32:	4c 89 f0             	mov    %r14,%rax
  35:	48 c1 e8 03          	shr    $0x3,%rax
  39:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax
  3e:	84 c0                	test   %al,%al


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

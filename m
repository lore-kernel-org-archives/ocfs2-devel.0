Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410C914A0B7
	for <ocfs2-devel@lists.linux.dev>; Sun, 22 Jun 2025 10:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750587572; cv=none; b=KlySYKvHCWjHC1BbkizwXCrg7IPo4P1LpbKm/7koFAuvmwD0fBAVmptpu+peTHzPgOHXshMYVu7MWaQM/3qfmXdm0dRm0AN/WQUdObs+6OkUDs0mDKUUljs1bQgTvRjG8883tvYnEMZu2JlZO3uJ9iWkQh9xL6ve0AvywsM8jc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750587572; c=relaxed/simple;
	bh=iqPKefTuFjKDge/YXPIckSmSkIQtoIGuRGhtMtYtAwY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iBnjy72NhOsx9rvRZoKj9SynwfsUJJ59IMMQ/u75zzcqQAlqUiYEVQuCsfe3YkHqWiH2OGgy+7rOvsDT6hubtegLtxqGi8yb7ivFh5A7onSgS58DaChWv51gnQ7TahacoO9ydyD+xpHsmb4uJU7U/bTEvGAaDrX+G4bC6TXWIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ddc6d66787so47729425ab.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Jun 2025 03:19:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750587569; x=1751192369;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gz1t6l57m4XyNrxwFehdjgRcECOluCdmMWxcbHppU0o=;
        b=e+yAbLP7a4Zxw4REQnU7gkQgymCtGeF6fStpVsybtk0MYxa06tzht1IX5/fSmocQxF
         Xa5WRzvjEBUiqYlbyAa3LrRouvV1A250dUAdHrk7P2oBy6qNVufz8ABnSkcht+y8BzBB
         KxzXcv4kXdqoMB81FGmKgxRTt/PhlSV9JUdwctxJrhsgsdWSj/5Zg1vDVHB27VJZnzVe
         did6/u9qkJb8q/eOL1CrxmfbDEQGEsuVmqipG7h/7vslX5ukirhudv3YSDeIR9ZUPv/q
         WkpD9r0SSZHLBnXvicmImtfahPL/lVFlbWUMoyLypr4toGsBU54M2kZBBY5nPIPORxP2
         bhOg==
X-Forwarded-Encrypted: i=1; AJvYcCUixFzm1TM3pcgz1q+o7fsIohiyprE4iq0ZQFa5b7sHAphh/CJL/SM8uuxAIV+nBAUSIpAfa/QQTsQlAg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxnx9J97IaMm69y6a5umLyXMo6fU9B4QwuNQMt3X7yN0QGL+F3W
	VWkivZNj99sssGhH61IyESGNAxX0Zak1sopXUnIAhNZP7Gnt4hqHZP2yboidtkfAuxApFzwGh9A
	o+PpgUv2y+uG6GWuJY3H4i1PpKcW98jyGuH8+CnTU7vW/JfhK7XkqPMVLus4=
X-Google-Smtp-Source: AGHT+IFPbWQmiWbMtpaUWpZVr0JUs1313ze2kXd+kyIVSBsvWLe7pL2dyEPM9dTMIp/EJA2radWY5N64c/11m5cMAskQk1ghlTr8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2b:b0:3dd:c1ed:d901 with SMTP id
 e9e14a558f8ab-3de38cd92b9mr106879205ab.21.1750587569452; Sun, 22 Jun 2025
 03:19:29 -0700 (PDT)
Date: Sun, 22 Jun 2025 03:19:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6857d8b1.a70a0220.62859.0005.GAE@google.com>
Subject: [syzbot] [ocfs2?] divide error in ocfs2_block_group_fill (2)
From: syzbot <syzbot+ec365bd7d5b823192c1b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4663747812d1 Merge tag 'platform-drivers-x86-v6.16-2' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165fde82580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d11f52d3049c3790
dashboard link: https://syzkaller.appspot.com/bug?extid=ec365bd7d5b823192c1b
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-46637478.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bde908b9f3d9/vmlinux-46637478.xz
kernel image: https://storage.googleapis.com/syzbot-assets/87a1193c8552/bzImage-46637478.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ec365bd7d5b823192c1b@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
Oops: divide error: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5329 Comm: syz.0.0 Not tainted 6.16.0-rc2-syzkaller-00045-g4663747812d1 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
Code: 34 1a 49 81 c6 50 01 00 00 45 0f b7 3f 49 83 c5 02 4c 89 e8 48 c1 e8 03 42 0f b6 04 20 84 c0 0f 85 eb 03 00 00 44 89 f8 31 d2 <66> 41 f7 75 00 0f b7 d8 4c 89 f0 48 c1 e8 03 42 0f b6 04 20 84 c0
RSP: 0018:ffffc9000d296940 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000100000
RDX: 0000000000000000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000d296a48 R08: 00313050554f5247 R09: 00313050554f5247
R10: dffffc0000000000 R11: ffffed100a989801 R12: dffffc0000000000
R13: ffff8880427fd2c2 R14: ffff888054c4c150 R15: 0000000000000000
FS:  00007f3342a506c0(0000) GS:ffff88808d251000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000033c000 CR3: 000000004262c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_block_group_alloc_discontig fs/ocfs2/suballoc.c:634 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:703 [inline]
 ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
 ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:984
 ocfs2_reserve_new_metadata fs/ocfs2/suballoc.c:1027 [inline]
 ocfs2_lock_allocators+0x29e/0x5c0 fs/ocfs2/suballoc.c:2761
 ocfs2_write_begin_nolock+0x2279/0x4340 fs/ocfs2/aops.c:1718
 ocfs2_write_begin+0x1bb/0x310 fs/ocfs2/aops.c:1882
 generic_perform_write+0x2c4/0x910 mm/filemap.c:4112
 ocfs2_file_write_iter+0x157a/0x1d10 fs/ocfs2/file.c:2469
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x548/0xa90 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3341b8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3342a50038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f3341db5fa0 RCX: 00007f3341b8e929
RDX: 000000000208e24b RSI: 0000200000000000 RDI: 0000000000000005
RBP: 00007f3341c10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3341db5fa0 R15: 00007ffd49600af8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
Code: 34 1a 49 81 c6 50 01 00 00 45 0f b7 3f 49 83 c5 02 4c 89 e8 48 c1 e8 03 42 0f b6 04 20 84 c0 0f 85 eb 03 00 00 44 89 f8 31 d2 <66> 41 f7 75 00 0f b7 d8 4c 89 f0 48 c1 e8 03 42 0f b6 04 20 84 c0
RSP: 0018:ffffc9000d296940 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000100000
RDX: 0000000000000000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000d296a48 R08: 00313050554f5247 R09: 00313050554f5247
R10: dffffc0000000000 R11: ffffed100a989801 R12: dffffc0000000000
R13: ffff8880427fd2c2 R14: ffff888054c4c150 R15: 0000000000000000
FS:  00007f3342a506c0(0000) GS:ffff88808d251000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000033c000 CR3: 000000004262c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

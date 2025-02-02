Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23291EEE9
	for <ocfs2-devel@lists.linux.dev>; Sun,  2 Feb 2025 05:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738472908; cv=none; b=uVAOUp1i8NO8QrwY2/zlPaJl11TcoNJByeRl8OIJ5WU8vsCM/7jDPAqDZRKDZybZDfRBB9yic8cThsli7abF87O/+MRe/dcgBt5S3IoKC4fcnTLC5NOrPCnooGnVBPv/kra+cN+Fv4feHmOyVUS7S4w79y3DIzDMciitAoV9/ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738472908; c=relaxed/simple;
	bh=10+q2USENm0O2mnYgP2SdcSi2OiECTJOXx5J1Of340k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ned8hA7XjqXfRolmuSfDXkT9SqtLDHXfTK19ts7S4fLtXj3bnfM+yVLsNBDY98IuPc6l1JUSVEcR1khylTOxFskqlreijSMclyr/3p+WrKRjFL9tYl0cX+SHHNaSXlY79jtWBfjjA+cbdHSSDObbSXOK51Cm0NwUf5h+rrQPGAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a814bfb77bso28962485ab.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Feb 2025 21:08:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738472906; x=1739077706;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+TH0j3bkIsLW/Wptm4tihJHXBlgsdnRdS0VgXtEGtuo=;
        b=JHdId2HgzbsRhPeZRfHQK07psa/CcUGDkYuPYohjriYfMEmAv8ojjFY3/niQjV3OiG
         P9Icd4leh0FEZ3KhdXp1HQLpaiM7x6kA2VcgHkp0XJ49YvQg2RBgvKSqhx3lZmC8fwBo
         /vu3ISb3vEEX4yS7wtkl4Wi+mlSph2eEnG/6KM4Ucixv0NpQu/8UppVo+gzhQhYduZfj
         zrqFj70koTZ0KjOGe+TBzDA5dbxhs9sffZFdHSsjc6ALG8BWPkTDwgrCA6EJhMN501DU
         PFW7cSHInJLbK7DLsn6PoodtaLDvajcaXUKpYE5gDU0NDg0daw2/fpNA2/8pOenZmSmC
         izYA==
X-Forwarded-Encrypted: i=1; AJvYcCV7x62DoUNXBmw/Gd89gwhBUSu21fctIWHPlStTdy+ZqMbRE6+eeCGGlpVG3e5uB4p843oQhbRLcCtTuQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+YxIrnXqRf4/zfKUmGK1XdbROPtDrNYH4Ahi56paUS1wB5DCJ
	q7lofSLtRFO4xKWqT1MvTQlQMPBwvUcduUmfs5VNyYg4mI14K0SgKRnXXtFKyGidC4PJe7d40Q2
	f1Qu56h/9yTB2/XEO7B1s+dkKgqckCmAdwKuGr7sIt24Ozl3Ylvu3eyk=
X-Google-Smtp-Source: AGHT+IEMYBz6TSyoOWTIwaSW7uaHekBklp08pW3Q/DLxKLw8eGY7j+kBFZVE03whp/yUI+O0vPDIfbBUNBTA1stXdLno3Wftey6Q
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1688:b0:3a9:cde3:2ecc with SMTP id
 e9e14a558f8ab-3d012ab22a3mr90353865ab.6.1738472905964; Sat, 01 Feb 2025
 21:08:25 -0800 (PST)
Date: Sat, 01 Feb 2025 21:08:25 -0800
In-Reply-To: <679d38b6.050a0220.d7c5a.0053.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679efdc9.050a0220.163cdc.002a.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] BUG: unable to handle kernel paging request in folio_unlock
From: syzbot <syzbot+2d57a8e099fe62bd60f0@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    69e858e0b8b2 Merge tag 'uml-for-linus-6.14-rc1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137be724580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
dashboard link: https://syzkaller.appspot.com/bug?extid=2d57a8e099fe62bd60f0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b1d5f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17c72d18580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-69e858e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a53b888c1f3f/vmlinux-69e858e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6b5e17edafc0/bzImage-69e858e0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4e6ad1d359e4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2d57a8e099fe62bd60f0@syzkaller.appspotmail.com

R13: 00007fff1f775058 R14: 431bde82d7b634db R15: 00007fe1ac9c701d
 </TASK>
(syz-executor147,5303,0):ocfs2_grab_folios_for_write:1080 ERROR: status = -12
(syz-executor147,5303,0):ocfs2_write_begin_nolock:1798 ERROR: status = -12
BUG: unable to handle page fault for address: fffffffffffffffc
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD e73c067 P4D e73c067 PUD e73e067 PMD 0 
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5303 Comm: syz-executor147 Not tainted 6.13.0-syzkaller-09760-g69e858e0b8b2 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:const_folio_flags include/linux/page-flags.h:310 [inline]
RIP: 0010:folio_test_locked include/linux/page-flags.h:510 [inline]
RIP: 0010:folio_unlock+0x3b/0x170 mm/filemap.c:1499
Code: 49 bf 00 00 00 00 00 fc ff df e8 b0 56 c7 ff 4d 8d 66 08 4d 89 e5 49 c1 ed 03 43 80 7c 3d 00 00 74 08 4c 89 e7 e8 95 eb 2d 00 <49> 8b 1c 24 48 89 de 48 83 e6 01 31 ff e8 63 5b c7 ff 48 83 e3 01
RSP: 0018:ffffc9000d327128 EFLAGS: 00010246
RAX: ffffffff81f81610 RBX: 1ffff1100232e806 RCX: ffff88801ce4a440
RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffffffffffffff4
RBP: ffff888011974030 R08: ffffffff83ad8572 R09: 1ffffffff203680e
R10: dffffc0000000000 R11: fffffbfff203680f R12: fffffffffffffffc
R13: 1fffffffffffffff R14: fffffffffffffff4 R15: dffffc0000000000
FS:  00005555865c0380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 0000000041da6000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_unlock_and_free_folios+0x71/0x1a0 fs/ocfs2/aops.c:772
 ocfs2_free_write_ctxt fs/ocfs2/aops.c:820 [inline]
 ocfs2_write_begin_nolock+0x3908/0x4e40 fs/ocfs2/aops.c:1837
 ocfs2_write_begin+0x205/0x3a0 fs/ocfs2/aops.c:1889
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 ocfs2_file_write_iter+0x19af/0x2180 fs/ocfs2/file.c:2469
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xacf/0xd10 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe1ac985889
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 1a 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1f774df8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fff1f774e10 RCX: 00007fe1ac985889
RDX: 00000000ffffff6a RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000001 R08: 00007fff1f774b97 R09: 00005555865c1378
R10: 0000000000000001 R11: 0000000000000246 R12: 00007fff1f774e30
R13: 00007fff1f775058 R14: 431bde82d7b634db R15: 00007fe1ac9c701d
 </TASK>
Modules linked in:
CR2: fffffffffffffffc
---[ end trace 0000000000000000 ]---
RIP: 0010:const_folio_flags include/linux/page-flags.h:310 [inline]
RIP: 0010:folio_test_locked include/linux/page-flags.h:510 [inline]
RIP: 0010:folio_unlock+0x3b/0x170 mm/filemap.c:1499
Code: 49 bf 00 00 00 00 00 fc ff df e8 b0 56 c7 ff 4d 8d 66 08 4d 89 e5 49 c1 ed 03 43 80 7c 3d 00 00 74 08 4c 89 e7 e8 95 eb 2d 00 <49> 8b 1c 24 48 89 de 48 83 e6 01 31 ff e8 63 5b c7 ff 48 83 e3 01
RSP: 0018:ffffc9000d327128 EFLAGS: 00010246
RAX: ffffffff81f81610 RBX: 1ffff1100232e806 RCX: ffff88801ce4a440
RDX: 0000000000000000 RSI: 0000000000000001 RDI: fffffffffffffff4
RBP: ffff888011974030 R08: ffffffff83ad8572 R09: 1ffffffff203680e
R10: dffffc0000000000 R11: fffffbfff203680f R12: fffffffffffffffc
R13: 1fffffffffffffff R14: fffffffffffffff4 R15: dffffc0000000000
FS:  00005555865c0380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffffffffffffc CR3: 0000000041da6000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
   7:	fc ff df
   a:	e8 b0 56 c7 ff       	call   0xffc756bf
   f:	4d 8d 66 08          	lea    0x8(%r14),%r12
  13:	4d 89 e5             	mov    %r12,%r13
  16:	49 c1 ed 03          	shr    $0x3,%r13
  1a:	43 80 7c 3d 00 00    	cmpb   $0x0,0x0(%r13,%r15,1)
  20:	74 08                	je     0x2a
  22:	4c 89 e7             	mov    %r12,%rdi
  25:	e8 95 eb 2d 00       	call   0x2debbf
* 2a:	49 8b 1c 24          	mov    (%r12),%rbx <-- trapping instruction
  2e:	48 89 de             	mov    %rbx,%rsi
  31:	48 83 e6 01          	and    $0x1,%rsi
  35:	31 ff                	xor    %edi,%edi
  37:	e8 63 5b c7 ff       	call   0xffc75b9f
  3c:	48 83 e3 01          	and    $0x1,%rbx


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

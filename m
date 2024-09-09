Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFD817AE19
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Sep 2024 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725906146; cv=none; b=KSOda+e6RXTfQf1q/LJ8+/tys6P5FJfQ+u3JIB2/Ra/a3nh2+/aqYujikzFF1dUZL6i8sMK+RYKuQ0w11O9jTHbuQl2DiH1ZoHeyeKp5R6+jjHsdrVOBpehdR1AKuFUrIWfzqiWjuShn4vEVUeQ9kvLEJran0mAVd92/DDjhLSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725906146; c=relaxed/simple;
	bh=NtyjkX+1bGqCpmVxNMOyCCyksiDENu8acybT/GPJfdk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=rHDUGUo6nFliaUT/jsNyg0WIm8a2upcQCcbDEmzSp/Csh6ceGEcx6JW0YvLW2W8Pq2ICK1bSZ7S9lcWVc/4PLrppiolXuoBsOqSlcjkweeUhfsTmluElGxjJJei1dEGhNX3fgr2Lzxvtbbo8LBEV4EQZCIkZU1M1eEafsTf/p10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a047cb2e7dso78220335ab.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 09 Sep 2024 11:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725906143; x=1726510943;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZZI31CASFNs3jooZUjFUTIRWTitRbHWZlYPwCSUElk=;
        b=gQwuoy82muhXWlOEnVNcy75vC/Vjb+HUm84fsOut2TaXQbJfYLAbRjNATTpiVbvE8w
         W7WWMc7ESGmaaPFctEwZmBVUDE0FPzd2pek5L1+10d+5r7KAp59djBy//hdRDUfCGPNk
         2OAUizdj4YiA5awdN/l4MW2IKOpyqHXikoSx2di7lrCBaaQbT4X6DXNt3slXDImHutnF
         4NzksM8bw3zW01qFhbGk2lUbgEbW/3Pq6R7x6BskAePZXXOrjZb1w0tTvwj26vbqeEXV
         jclGW1yPSzfxL1DCNV8eDRkZvM88Bb2GWhHGYZfKnu+jyhTTFWcNqlLkpthyuWj1r3Rh
         4GWA==
X-Forwarded-Encrypted: i=1; AJvYcCXp7fjsqa7ez7EEG0+xcwkX+146xSP+OeIhPOCRoDo3r7PJmQqP/wm2a4xY0/XbJQeJjdElfH2lsBF8Vg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKu/fGpe+9JU+Liy1BBa80tF3+KL72GioVB2qSUL5aO7enutip
	p6lSdyw/DUNvuYKJSVDrrOZnPjdO71S6a0GsAdruAlG9juI8qZBUogs7EqV1MhErAfsGKiKX8kT
	7fNA/O6QHxV781xIejf3Ui2scl04ukZ18U5wMgB/BIN4kDZLjrTTbN+I=
X-Google-Smtp-Source: AGHT+IECUPxL2xHm/Lehf8VLrKkLtam0Xi+mvX/Zj84PtwKBSCL30FES7DfLB/6LEw5AG0tJcDBRMoq4BZNZb6zkJKqIou+El3eb
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a69:b0:398:4bda:cf66 with SMTP id
 e9e14a558f8ab-3a04f0e23f2mr146523905ab.18.1725906143570; Mon, 09 Sep 2024
 11:22:23 -0700 (PDT)
Date: Mon, 09 Sep 2024 11:22:23 -0700
In-Reply-To: <000000000000b10c48062134870d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a7f1f0621b3d649@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in _ocfs2_free_suballoc_bits
From: syzbot <syzbot+2d6d9df993967dde8297@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    da3ea35007d0 Linux 6.11-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=139d743b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=2d6d9df993967dde8297
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a32200580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-da3ea350.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1ab780d224f6/vmlinux-da3ea350.xz
kernel image: https://storage.googleapis.com/syzbot-assets/834dde85c1c2/bzImage-da3ea350.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/fac451c0badd/mount_2.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/81fbd0552bdc/mount_23.gz
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/03da9db81461/mount_24.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2d6d9df993967dde8297@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/suballoc.c:2542!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5596 Comm: syz.0.31 Not tainted 6.11.0-rc7-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:_ocfs2_free_suballoc_bits+0x11a2/0x14a0 fs/ocfs2/suballoc.c:2542
Code: 18 e9 8f fb ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 92 fb ff ff 4c 89 e7 e8 c9 a0 6a fe e9 85 fb ff ff e8 4f 58 03 fe 90 <0f> 0b e8 47 58 03 fe 90 0f 0b f3 0f 1e fa 65 8b 1d 95 a2 73 7c bf
RSP: 0018:ffffc90003147840 EFLAGS: 00010293
RAX: ffffffff83903461 RBX: 00000000ffffffff RCX: ffff888034b74880
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc900031479e8 R08: ffffffff839023bc R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff2030ee6 R12: ffff88803fa77bc8
R13: dffffc0000000000 R14: ffff88804c17ae00 R15: dffffc0000000000
FS:  00007fedd93ef6c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1fc838b897 CR3: 0000000056c10000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 _ocfs2_free_clusters+0x5ff/0xad0 fs/ocfs2/suballoc.c:2646
 ocfs2_replay_truncate_records fs/ocfs2/alloc.c:5971 [inline]
 __ocfs2_flush_truncate_log+0x760/0x1250 fs/ocfs2/alloc.c:6054
 ocfs2_flush_truncate_log+0x4f/0x70 fs/ocfs2/alloc.c:6076
 ocfs2_sync_fs+0x125/0x390 fs/ocfs2/super.c:402
 iterate_supers+0xc6/0x190 fs/super.c:934
 ksys_sync+0xdb/0x1c0 fs/sync.c:104
 __do_sys_sync+0xe/0x20 fs/sync.c:113
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fedd857cef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fedd93ef038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a2
RAX: ffffffffffffffda RBX: 00007fedd8736058 RCX: 00007fedd857cef9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007fedd85ef046 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007fedd8736058 R15: 00007ffde5c8eca8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:_ocfs2_free_suballoc_bits+0x11a2/0x14a0 fs/ocfs2/suballoc.c:2542
Code: 18 e9 8f fb ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 92 fb ff ff 4c 89 e7 e8 c9 a0 6a fe e9 85 fb ff ff e8 4f 58 03 fe 90 <0f> 0b e8 47 58 03 fe 90 0f 0b f3 0f 1e fa 65 8b 1d 95 a2 73 7c bf
RSP: 0018:ffffc90003147840 EFLAGS: 00010293
RAX: ffffffff83903461 RBX: 00000000ffffffff RCX: ffff888034b74880
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc900031479e8 R08: ffffffff839023bc R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff2030ee6 R12: ffff88803fa77bc8
R13: dffffc0000000000 R14: ffff88804c17ae00 R15: dffffc0000000000
FS:  00007fedd93ef6c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f04fbd58000 CR3: 0000000056c10000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

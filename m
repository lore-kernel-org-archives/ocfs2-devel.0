Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50EFC2F2
	for <ocfs2-devel@lists.linux.dev>; Mon, 10 Feb 2025 01:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739150195; cv=none; b=omrztimGAauvs6jUCI3UjSIRsYcALaZrnc2kMSAywudcm3zMRr7x9t1gfsAxm92NnOYrCpJIKP0gSfx3DymhNIkM3/5TNCVu9P6S1vODvXuJ5je9A7Fn8uDxR2R07GWBNHCZambF3roPAaqvlutUmYN4BgW7wZaYydXULkBnFzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739150195; c=relaxed/simple;
	bh=DuZeMhp5oN+Ad1f/OM6YurV+/AuxnboY41McH/sNFxQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NTO7rE7hiOfhG22fa1zTOS2ARFbbTLhlavn3UxrDf3/EQdNMFS7xwwHO14pmgGfDqAjs9c2zbuOb0U0gTKKyRPKc78JyPNdyrveJutCxyFmk5buN5lSjEPXQeLnxC2Mjpb+ahFIy46Fg1zfINjUZYPCuAoR34CI4I7B3m1rxnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ce81a40f5cso79213815ab.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 09 Feb 2025 17:16:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739150193; x=1739754993;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4JQRilZSEsRfSdZVX7rLS980iHRw58YbaBBmRysg5RU=;
        b=PDoL4NT4NkI/pQQ8KATvPHUptv6mfGhd7sU2eUcYMlJduTpkxTdIUtBrSzEpUyhcav
         VbHKQzGkxuHpH1/0k+2vako+XQMXHycaiNuMEny/JqUhN4rrDk5im2ZQ8SCvxApnkaFU
         nrenmvxuV5AG3RQbLr5yWjOe4BWpAvGOfFXwdE6psyUE9UE1jUSr2626wU5ki4UU1aY4
         SbojRANOW0vtC7a01GuG3wjOMcgYAoPt9WUbs1MoMhgakX8jqrXiqU8uRhyk/RJ7ZnHY
         KiR1LklNP29gcduVQ575OMeb+44T97jExyQrY+9MFop7C0/iwGGRhr3UntvtIRgEH8zF
         1nDw==
X-Forwarded-Encrypted: i=1; AJvYcCVcUXpWLmMn3VpMtiwVRBLkcn/LQVZPi/WjrXWzMywWrKeASp4BJ21A/H3tqGZ/qyXFkVRum3+xrGowWQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YycN6U13MciVLGLHp9eVvmVuKBfRAwNaOFUf76U1UNIGaDshFUk
	c7uOBYcvBOrx+g8S8ooBNmnzV2J3q0N++HCxMtH9WtGreVvjNzQU9casod/vc7TR0jgW3/4oxbY
	sXcjg5ZB+gg/ynImNCev81OwQkUNm0VugJFJaj7ytsxE511e21mmgC44=
X-Google-Smtp-Source: AGHT+IHrk+lqCr+stsnTqDdO03qvfqYcXjhVDikHEeNHFyTDnJGFth3jufml1vwpOq0ECBSg246dxhputw7CKSOVjNq77hE2titY
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c263:0:b0:3cf:c803:1295 with SMTP id
 e9e14a558f8ab-3d13dcfcdeamr109250035ab.3.1739150192680; Sun, 09 Feb 2025
 17:16:32 -0800 (PST)
Date: Sun, 09 Feb 2025 17:16:32 -0800
In-Reply-To: <671ff85a.050a0220.11b624.04b3.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a95370.050a0220.3d72c.0046.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_journal_toggle_dirty
From: syzbot <syzbot+ea8d1726e1e3367085ce@syzkaller.appspotmail.com>
To: axboe@kernel.dk, djwong@kernel.org, hch@lst.de, jack@suse.cz, 
	jlbec@evilplan.org, joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	mark@fasheh.com, ocfs2-devel@lists.linux.dev, ocfs2-devel@oss.oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    69b54314c975 Merge tag 'kbuild-fixes-v6.14' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=178742a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=ea8d1726e1e3367085ce
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107a3b18580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d86bdf980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-69b54314.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e32e396b49c9/vmlinux-69b54314.xz
kernel image: https://storage.googleapis.com/syzbot-assets/30d7fe7e4148/bzImage-69b54314.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/16cf04118a70/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=13586bdf980000)

The issue was bisected to:

commit 98ded54a33839e7b8f8bed772e01a544f48e33a7
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Mar 30 05:29:10 2022 +0000

    loop: remove the racy bd_inode->i_mapping->nrpages asserts

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=144cf0b0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=164cf0b0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=124cf0b0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea8d1726e1e3367085ce@syzkaller.appspotmail.com
Fixes: 98ded54a3383 ("loop: remove the racy bd_inode->i_mapping->nrpages asserts")

(syz-executor198,5726,0):ocfs2_inode_lock_full_nested:2512 ERROR: status = -30
(syz-executor198,5726,0):ocfs2_shutdown_local_alloc:412 ERROR: status = -30
------------[ cut here ]------------
kernel BUG at fs/ocfs2/journal.c:1012!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5726 Comm: syz-executor198 Not tainted 6.14.0-rc1-syzkaller-00276-g69b54314c975 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_journal_toggle_dirty+0x397/0x3a0 fs/ocfs2/journal.c:1012
Code: 6f fe e9 f7 fd ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 2a fe ff ff 48 89 df e8 d4 68 6f fe e9 1d fe ff ff e8 da cf 08 fe 90 <0f> 0b e8 92 58 3f 08 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffc9000e2fefe0 EFLAGS: 00010293
RAX: ffffffff83b67fc6 RBX: 00000000ffffffff RCX: ffff88801f368000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc9000e2ff0b0 R08: ffffffff83b67d30 R09: 1ffffffff285f32a
R10: dffffc0000000000 R11: fffffbfff285f32b R12: dffffc0000000000
R13: ffff88804121a740 R14: ffff8880449e9600 R15: 1ffff92001c5fe04
FS:  00007f04682156c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f046066b000 CR3: 000000005005a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_journal_shutdown+0x479/0xc10 fs/ocfs2/journal.c:1094
 ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
 ocfs2_fill_super+0x668e/0x7200 fs/ocfs2/super.c:1083
 get_tree_bdev_flags+0x48c/0x5c0 fs/super.c:1636
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0468a70faa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0468214f88 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000400000004440 RCX: 00007f0468a70faa
RDX: 0000400000004440 RSI: 0000400000000040 RDI: 00007f0468214fe0
RBP: 00007f0468214fe0 R08: 00007f0468215020 R09: 000000000000441b
R10: 00000000000008c0 R11: 0000000000000282 R12: 0000400000000040
R13: 00007f0468215020 R14: 0000000000004421 R15: 0000400000000080
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_journal_toggle_dirty+0x397/0x3a0 fs/ocfs2/journal.c:1012
Code: 6f fe e9 f7 fd ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 2a fe ff ff 48 89 df e8 d4 68 6f fe e9 1d fe ff ff e8 da cf 08 fe 90 <0f> 0b e8 92 58 3f 08 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0000:ffffc9000e2fefe0 EFLAGS: 00010293
RAX: ffffffff83b67fc6 RBX: 00000000ffffffff RCX: ffff88801f368000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc9000e2ff0b0 R08: ffffffff83b67d30 R09: 1ffffffff285f32a
R10: dffffc0000000000 R11: fffffbfff285f32b R12: dffffc0000000000
R13: ffff88804121a740 R14: ffff8880449e9600 R15: 1ffff92001c5fe04
FS:  00007f04682156c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0460bff000 CR3: 000000005005a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

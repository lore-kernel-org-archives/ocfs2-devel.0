Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21033CF6A
	for <ocfs2-devel@lists.linux.dev>; Sun, 29 Sep 2024 07:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727596346; cv=none; b=kRICxaDdhg6DPQ2yxLjMgqbR1Rkx9bsh5jL/u0n/ydL47LIkyUZZqar8vHf6/tDbimq5W/Ihllsu6IAbXgxT4evk6imNRLrhzvgTZ1JE1E8nl7XvQwbVEtpj7/Udl+frpGGvobpVy17stfbUVkOvHfdP3k1IcSKPguZWjF6UEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727596346; c=relaxed/simple;
	bh=ITB0+OlYDpzDQWhHgd3zkX7HrwRqwXvZYX47JHU3PGg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Dv2cnkSLIxmlIBwag1JGTN6YLEV9UzpUgqKJXs7s3MbglEqxfwFl2hvDGbq7Ocw2qduTPxhGM5iRu8bkhhL5mMhPTnTmqqWSfhT4KFvADR00yr6LpqdNSzdDaiSA4mApKIus0Vw/Tb4oS8IEEAZxqMx8QGvKqbgE/pFu8CO2EaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0ce8cf657so47609795ab.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Sep 2024 00:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727596344; x=1728201144;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIHcvdtG0iDERh6UQqeY66Cz1jCEOiuE8AtiS4TPaXU=;
        b=h+nq11Xg5XJCYCuW3o/txOxd1tibD/bjWeCCGjUXO8gxHuqzAS2oBiN9H+dCdZvGsj
         P7LV0m7uoXTogX1CoqfYL78aUAfF1yhp1Y1c2+awrmOa2pxX7MnygYT+b4Ikk8dH31x/
         9e0TVvAP9s4AKD70/FjkkqSY0qHvrIIsI23uB+pQsoB9xVfT/P6CzV2rB4HeQCNsUlqe
         HslkNL6m+XAkw8nxgzKr+1ywTbAnkEOS37+VGzS1RTRWNByxBccTUvPNtll/blvr/MFT
         +qE5k0BKoZsrJ9D2KrBdTQZ7WJaqz4XXEiEcjj/2tFjiv5i1y4t42pCfzyRfzpwsaVLI
         PT1w==
X-Forwarded-Encrypted: i=1; AJvYcCWXEbTu7ngeT4rScakDNEVcQ7rJtDOVUberjpp/vGJ+NX795uakDTGBZWgRYmQy+rGLhWGLc3B/odV/VA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyDHYYBIMeI+cOa6SXXoIfPYbcenVATrMzl0kFoSX7/zjfza8av
	wMAFX7EQUyqu7csL1FN6kdULmEn/6sSjlbBGo+Ieot9r0aiyFiw+Ebol6xLZ/hBIoofHblbCu4L
	F3XH+3WChX1ohrqGo02erTRMPKAgvxDg0+4yi8SNM+qQeCHIKKL8TEmI=
X-Google-Smtp-Source: AGHT+IEdyLF+esx+qQfp73Jksq1msrFcWY1rLgc5085xEd3TjP5ILUWBqDUtreZ/1sU3rxe3gOAl/EL86GDOzIphtzr+5kHs5wet
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d07:b0:3a0:9238:d38 with SMTP id
 e9e14a558f8ab-3a34517e824mr71928335ab.10.1727596343977; Sun, 29 Sep 2024
 00:52:23 -0700 (PDT)
Date: Sun, 29 Sep 2024 00:52:23 -0700
In-Reply-To: <000000000000cb688206213d1bda@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f90737.050a0220.4a974.001b.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] possible deadlock in ocfs2_fiemap
From: syzbot <syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    3efc57369a0c Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11480127980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4fcb065287cdb84
dashboard link: https://syzkaller.appspot.com/bug?extid=ca440b457d21568f8021
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109ccd9f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1476de80580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-3efc5736.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d0988c372a39/vmlinux-3efc5736.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8547f30d7e9d/bzImage-3efc5736.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/ac59be7d6f54/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca440b457d21568f8021@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
======================================================
WARNING: possible circular locking dependency detected
6.11.0-syzkaller-11993-g3efc57369a0c #0 Not tainted
------------------------------------------------------
syz-executor356/5112 is trying to acquire lock:
ffff8880119d4418 (&mm->mmap_lock){++++}-{3:3}, at: __might_fault+0xaa/0x120 mm/memory.c:6700

but task is already holding lock:
ffff888041bdbf60 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_fiemap+0x377/0xf80 fs/ocfs2/extent_map.c:755

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&oi->ip_alloc_sem){++++}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
       down_write+0x99/0x220 kernel/locking/rwsem.c:1579
       ocfs2_page_mkwrite+0x346/0xed0 fs/ocfs2/mmap.c:142
       do_page_mkwrite+0x198/0x480 mm/memory.c:3162
       do_shared_fault mm/memory.c:5358 [inline]
       do_fault mm/memory.c:5420 [inline]
       do_pte_missing mm/memory.c:3965 [inline]
       handle_pte_fault+0x11fa/0x6800 mm/memory.c:5751
       __handle_mm_fault mm/memory.c:5894 [inline]
       handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6062
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #1 (sb_pagefaults){.+.+}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_pagefault include/linux/fs.h:1881 [inline]
       ocfs2_page_mkwrite+0x222/0xed0 fs/ocfs2/mmap.c:122
       do_page_mkwrite+0x198/0x480 mm/memory.c:3162
       do_shared_fault mm/memory.c:5358 [inline]
       do_fault mm/memory.c:5420 [inline]
       do_pte_missing mm/memory.c:3965 [inline]
       handle_pte_fault+0x11fa/0x6800 mm/memory.c:5751
       __handle_mm_fault mm/memory.c:5894 [inline]
       handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6062
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8c0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

-> #0 (&mm->mmap_lock){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3158 [inline]
       check_prevs_add kernel/locking/lockdep.c:3277 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3901
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5199
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
       __might_fault+0xc6/0x120 mm/memory.c:6700
       _inline_copy_to_user include/linux/uaccess.h:183 [inline]
       _copy_to_user+0x2a/0xb0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:216 [inline]
       fiemap_fill_next_extent+0x235/0x410 fs/ioctl.c:145
       ocfs2_fiemap+0x9f1/0xf80 fs/ocfs2/extent_map.c:796
       ioctl_fiemap fs/ioctl.c:220 [inline]
       do_vfs_ioctl+0x1bf8/0x2e40 fs/ioctl.c:841
       __do_sys_ioctl fs/ioctl.c:905 [inline]
       __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &mm->mmap_lock --> sb_pagefaults --> &oi->ip_alloc_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&oi->ip_alloc_sem);
                               lock(sb_pagefaults);
                               lock(&oi->ip_alloc_sem);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

1 lock held by syz-executor356/5112:
 #0: ffff888041bdbf60 (&oi->ip_alloc_sem){++++}-{3:3}, at: ocfs2_fiemap+0x377/0xf80 fs/ocfs2/extent_map.c:755

stack backtrace:
CPU: 0 UID: 0 PID: 5112 Comm: syz-executor356 Not tainted 6.11.0-syzkaller-11993-g3efc57369a0c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2203
 check_prev_add kernel/locking/lockdep.c:3158 [inline]
 check_prevs_add kernel/locking/lockdep.c:3277 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3901
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5199
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
 __might_fault+0xc6/0x120 mm/memory.c:6700
 _inline_copy_to_user include/linux/uaccess.h:183 [inline]
 _copy_to_user+0x2a/0xb0 lib/usercopy.c:26
 copy_to_user include/linux/uaccess.h:216 [inline]
 fiemap_fill_next_extent+0x235/0x410 fs/ioctl.c:145
 ocfs2_fiemap+0x9f1/0xf80 fs/ocfs2/extent_map.c:796
 ioctl_fiemap fs/ioctl.c:220 [inline]
 do_vfs_ioctl+0x1bf8/0x2e40 fs/ioctl.c:841
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c21255d99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc7eb343e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0c21255d99
RDX: 00000000200001c0 RSI: 00000000c020660b RDI: 0000000000000005
RBP: 00007f0c212ce5f0 R08: 0000000000000000 R09: 00005555783d34c0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c212ce5f0 R14: 431bde82d7b634db R15: 00007f0c2129f03b
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

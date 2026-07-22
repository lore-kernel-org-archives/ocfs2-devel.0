Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791CF470E9F
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 19:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747436; cv=none; b=a0DC+TIx0XF2mrUwdUtnHSdkfRDuS/LgO6sHczW8vMbUxDdn8pECYuh6TpmRJr6Be/25LAjsH+7OW1/TjGOLPDNxODsk6Zu11uklXhj0TqZ06Fmr5vyNXz+usJ1O/kSwEMqhArkJnA4ma+ZNaCDuYGQ47/0cc5AhZy3yBZOnazY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747436; c=relaxed/simple;
	bh=QSk+8TZzsfVPCAl2XC59e/1BraosVxjnVBJB9OLsjUU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iTKCRcrUE7oOsm22kVQ7I9RiY9QHpwUSAFDvHXB9Z3973Ad4D1A32sG/EOiL5xD3+CRYjAEL4C8BJQtRdBQFGmC7oemVFKzrU5eXLm2nmDOn6OfFY3Ogp59RRZxQxK4taxWx8zejV7ADACeKeUHxGX/7fpRaAJ6daCXzZLXKHOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7ead32f5c6aso8073377a34.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 12:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784747433; x=1785352233;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0dkNhFe/uBczo1c6y8CnnOJ4gnHcZ/PUKa4sHOAmbVI=;
        b=QhDF2IGePy16FMmxQQG9p5V+KX81oi56fCXuIplB6is5kM8aRDFHL10ajul87qJDG2
         itA91F8OCi+1cdFf00acL1IFhY7Lk3TEwlPInW9eRyCOJ7sToGqVsm4YBkAHmdkWy8rc
         4+cjES3Nt9tjddvpKHSojXWgYDg9blyFDxiircZv+pbUN+IUY8l1XLImILKLXV7MfHzj
         sdli4ZPXKcud0bPIWGcd7y/mJVQaGvBEMFcF5nr2IJBh9AygQnmajOofAQEgnUpktOUf
         xbp3MDvfFf1Rr9z08EeZC/fM7C58aUhEi4UbcqkHELH98l7q/+Zmo3GZlV41sGoL7Y58
         kz6w==
X-Forwarded-Encrypted: i=1; AHgh+Ro6ae+4p1SiqgHk22nSxTGQ8ADIpYGqPQ99Yv2rwJS1q+x8dsjkPby8IYwEHXr0HpqY20ZPUfqAjk5spQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzlgTtiHnTSUnT3juedKVSf/fsk8aG2JmIR7kBZnWn2vQZ4ubTL
	QqaCYK5FhiGXjG/XKj2CtuZPf1Tmo0g9zI+dAllK2jC+MmkusRwoULWOPt8ZLdW6OE5i5z6CpPC
	nZya5w1NbIG6GylX2McgG3/dYPyJZXKmDZOlZPzSPcErxfUxFngtq1K4DkIc=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1689:b0:69e:39c9:c6ec with SMTP id
 006d021491bc7-6a5366ad66bmr11004261eaf.13.1784747433309; Wed, 22 Jul 2026
 12:10:33 -0700 (PDT)
Date: Wed, 22 Jul 2026 12:10:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6115a9.036d4df3.243f95.0004.GAE@google.com>
Subject: [syzbot] [ocfs2?] INFO: trying to register non-static key in
 ocfs2_trim_fs (2)
From: syzbot <syzbot+0a1363933fe7d9e120ee@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    248951ddc14d Merge tag 'hwmon-for-v7.2-rc5' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171772b9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=98da55a882774dfe
dashboard link: https://syzkaller.appspot.com/bug?extid=0a1363933fe7d9e120ee
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2c64b346eb71/disk-248951dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c1a6ad8dc1de/vmlinux-248951dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c34e79a35bcd/bzImage-248951dd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0a1363933fe7d9e120ee@syzkaller.appspotmail.com

ocfs2: Readonly device (7,7) detected. Cluster services will not be used for this mount. Recovery will be skipped.
ocfs2: Mounting device (7,7) on (node local, slot 65535) with ordered data mode.
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 8273 Comm: syz.7.455 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xab/0x2ce0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
 mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
 ocfs2_trim_fs_lock_res_init+0x25/0xa0 fs/ocfs2/dlmglue.c:703
 ocfs2_trim_fs+0x13c/0x24d0 fs/ocfs2/alloc.c:7692
 ocfs2_ioctl+0x6c2/0x7e0 fs/ocfs2/ioctl.c:948
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xff/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f23c8d2de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f23c6f86028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f23c8fb5fa0 RCX: 00007f23c8d2de99
RDX: 0000200000000080 RSI: 00000000c0185879 RDI: 0000000000000004
RBP: 00007f23c8dc3eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f23c8fb6038 R14: 00007f23c8fb5fa0 R15: 00007ffc521a25a8
 </TASK>
(syz.7.455,8273,0):ocfs2_trim_fs:7699 ERROR: status = -30


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

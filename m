Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6DF3148C4
	for <ocfs2-devel@lists.linux.dev>; Mon, 10 Nov 2025 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798172; cv=none; b=LTxRgafyOpazUp9XydqcT22ynMKdLFFzxNz3+iW9BOsNp8qC1MRHy2Zk0pNCOXmMxcEjG69ROHjBHWv+ze/SrzYboHjvK04XozpqzNxm0ywblzzvCzNYDjaceP97idGwasj7UHCEvgVjwXa/JaBZD7+oQZwtwHDBbl1n5Zlcns0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798172; c=relaxed/simple;
	bh=sOpKSZ9DVN62lSeikkgNUpf5JPmJS2ddxRw25mRn25Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RZbSmXF9wVf2JNGI0yCsYNQTMzizljazQkUHckj1SYgYVNzELhDZEbm72T9TWALKdY67gCcjAKyAgHOV6S8GvC1BeNeTevjgce6P9q2D3sJpJ5sUV93Y4dM/1OLUE8INada6KSy0+mOo3WPgWFv3hM/gAjlF9966gb78LOpnSuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-4330bc0373bso27742745ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 10 Nov 2025 10:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798170; x=1763402970;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e9VGTpiy/zHOj27Kr6JudPe5X1s+x1x54FmX6tzV7CI=;
        b=NMvXoCjqvLoIBAlcbrHSHWcEyCFYhSwrwJv3Zqw4CxI1QHIazu5SbOslbt1g6NGsrF
         /UCtE3eDDIAadXbsdVy7DEtq1dDSvdxTgH6VkTZjCEJ522qgJDkYnk6R/1yCETZHIIfY
         Xg6ZUBqD+BJBTNmDDpGidCpg8aNFd8E3zhPhraqPWsIo+nITwEAG+7HnyYtDTiUlF2Sz
         3qf9PuIbDvcdL8OAcw7/H9xq8zs1nl5abkzQWUrSepSM4IJzuQotZ37pf3Kau7ZrktIj
         OMHXhK8ZwxNc84WEbVKyfLerOSFnbc9B/hzG6kbDAG0bWNDmSRxRRz2i4r0pPYhQwf7Z
         hePQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDP4SYGrJTVkInfe9l/soJ+vIIu6MSoR4JYuYMi8zOsHUGz0zMe1UZyg+WEAU/VwSSlJaRPgMfJ35hGw==@lists.linux.dev
X-Gm-Message-State: AOJu0YykjLrwDCNlLjUJCKl2wZBm5DP4/Nrcbdin46Q38eTWifBhB2lK
	m5HJSv/sxaQr+pF2PR+xVUkyUOnhmBNOTpSzTC7geCJ6X64oFfccs1dLDJzqSCh749GYo2FI6zT
	pUBeQQPQ7BDgywgqVX5Gv8Pqct+xrlCSa6vC+e72M1sISiwLqvHN35znobNw=
X-Google-Smtp-Source: AGHT+IHOHzLhT9i3VHRpSVgXLLTJI5CkBlv/YZ10nGLOQpWrHIVu59y8ci/be4hJ9nb32J4J8yTuXWN9cMi3oZqqiIlGen1uzEFO
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:741:b0:433:2341:bc13 with SMTP id
 e9e14a558f8ab-43367dde525mr146736075ab.11.1762798169711; Mon, 10 Nov 2025
 10:09:29 -0800 (PST)
Date: Mon, 10 Nov 2025 10:09:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69122a59.a70a0220.22f260.00fc.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_listxattr
From: syzbot <syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e424ed997df8 Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1739c412580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8b659f0cab27b22
dashboard link: https://syzkaller.appspot.com/bug?extid=ab0ad25088673470d2d9
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1531aa92580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1361d084580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ada05b916921/disk-e424ed99.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/674414e6bfd1/vmlinux-e424ed99.xz
kernel image: https://storage.googleapis.com/syzbot-assets/67ca98bd56a6/Image-e424ed99.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5d507ac2b3e1/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=11310412580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com

On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: File system is now read-only.
==================================================================
BUG: KASAN: use-after-free in ocfs2_xattr_get_type fs/ocfs2/ocfs2_fs.h:1114 [inline]
BUG: KASAN: use-after-free in ocfs2_xattr_list_entries fs/ocfs2/xattr.c:934 [inline]
BUG: KASAN: use-after-free in ocfs2_xattr_ibody_list fs/ocfs2/xattr.c:982 [inline]
BUG: KASAN: use-after-free in ocfs2_listxattr+0x408/0xa74 fs/ocfs2/xattr.c:1044
Read of size 1 at addr ffff0000eba98007 by task syz.0.17/6724

CPU: 1 UID: 0 PID: 6724 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xa8/0x238 mm/kasan/report.c:378
 print_report+0x68/0x84 mm/kasan/report.c:482
 kasan_report+0xb0/0x110 mm/kasan/report.c:595
 __asan_report_load1_noabort+0x20/0x2c mm/kasan/report_generic.c:378
 ocfs2_xattr_get_type fs/ocfs2/ocfs2_fs.h:1114 [inline]
 ocfs2_xattr_list_entries fs/ocfs2/xattr.c:934 [inline]
 ocfs2_xattr_ibody_list fs/ocfs2/xattr.c:982 [inline]
 ocfs2_listxattr+0x408/0xa74 fs/ocfs2/xattr.c:1044
 vfs_listxattr+0xc0/0x128 fs/xattr.c:493
 ovl_listxattr+0xd8/0x49c fs/overlayfs/xattrs.c:123
 vfs_listxattr fs/xattr.c:493 [inline]
 listxattr+0x10c/0x380 fs/xattr.c:924
 filename_listxattr fs/xattr.c:958 [inline]
 path_listxattrat+0x15c/0x33c fs/xattr.c:988
 __do_sys_listxattr fs/xattr.c:1001 [inline]
 __se_sys_listxattr fs/xattr.c:998 [inline]
 __arm64_sys_listxattr+0x84/0x98 fs/xattr.c:998
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:746
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:765
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffffb730e pfn:0x12ba98
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 05ffc00000000000 fffffdffc3aeb708 fffffdffc3aeb888 0000000000000000
raw: 0000000ffffb730e 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000eba97f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff0000eba97f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff0000eba98000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff0000eba98080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff0000eba98100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

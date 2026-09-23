Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FBC530E06
	for <ocfs2-devel@lists.linux.dev>; Wed, 23 Sep 2026 18:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188417; cv=none; b=EDlvVuj/G6D9JfxsSm8sb7n5GTwkeBaWSD5D+aeziBxnbQISISgUJNhD7WO6zSpvVhmSsioXGUXjzq/WKXYD3rbGRzD1XyaWziRt1PiuMbjbjw+AkNQ320dGd+xBys2K69GNXoDDqFpNiJo0Y17DAaX16MkQjTvI53QiiMV0WlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188417; c=relaxed/simple;
	bh=FK3MqZuR+VAo+Zg02gc46BX0ZpW/+rFTrzF4iXr1qF4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QmGnqxmz2tFrmlHhe9hv/+18hHpOItzs+WDQJYuHF9/ln/2aWxXv3gZaMm+AtmYkMKU/yRc6rsvgBhLQrClqYBEuf+5iO+FZdj+ekFaxb04gErK+Jh0kgiaH/uRZX2m5rHBZxhz3+cpB0OdH9qyNDdn5if2aWIy47RWUD6v1XlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f6.google.com with SMTP id 006d021491bc7-6aafac56856so525021eaf.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 23 Sep 2026 11:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790188413; x=1790793213;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nIQIjfmnTCGxAmmHaCJpZ50YUZ8tHFhIK4QdBhPLVMw=;
        b=tgOYDpBIWulXKbqyH15A0XHD2pjoJ+BbDmlyTO4TyAxmCJweQ5L3wvWssTxr3z17CG
         kUGsBsXSkAueRN5YxAJKsvysP1Y2DE7qSHOABuIMmubILQCwhDUIjOs7nl0oWD99f4T7
         hS1KssG7hPRAkuH1G1RFrdGvrXNah5fqx0JvN0YVbjBGdmeZH2kucoFgbLoGhraEwb5u
         N50kz/axCrgoWMcyEgqIP7RYwkoG7Qs4fjOnUT/eRUnJ85vVxKc5nAA46vIAcyLdyc/e
         2xVOnoQZMU+ZH/7n0v/1jD99wwdXvB5FEg5AkjZwPbzbgJE1UcUYwYWuVXe8aPNb69/e
         D6xw==
X-Forwarded-Encrypted: i=1; AKwUvBxb/p6k2XAOyHYE9cPj8vHtmzmuuumWk6GEAYSItiTqXx1dJx/qFgwTBCJquEiX9m35kKOIGeFgWbi3zw==@lists.linux.dev
X-Gm-Message-State: AFuF++mBzkZO9OhTZ8pgJUdaCkPR8pwpao4Am9hmlgNySAb26GuszIeh
	5EmygjgR82TuhDYXqRsCEnzg2ZnSyZAX0Va7Y2mqhyFZVbCKpmdrBDg1kpDlvrQ9EtMP5/0SOlo
	dTIFIYWNd4Ojb5V2nhtOsZHEuWti2xvuoKwVoWtOz7LJjKKp9V12jB/qRi74=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2916:b0:6c9:80d8:a1e8 with SMTP id
 006d021491bc7-6d43fd7bf45mr111141eaf.37.1790188413606; Wed, 23 Sep 2026
 11:33:33 -0700 (PDT)
Date: Wed, 23 Sep 2026 11:33:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab41b7d.e548f532.1ca396.0020.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in vfs_rename (3)
From: syzbot <syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    40288c9206c1 Merge tag 'drm-fixes-2026-09-19' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120d6ff9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5a2529faa72a9438
dashboard link: https://syzkaller.appspot.com/bug?extid=c73ff6790f3d6c635abc
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9ec4bf87ffd8/disk-40288c92.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/30e34b18bd6f/vmlinux-40288c92.xz
kernel image: https://storage.googleapis.com/syzbot-assets/122f601f5b36/bzImage-40288c92.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c73ff6790f3d6c635abc@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.1.4093/19971 is trying to acquire lock:
ffff888077a8eba0 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: inode_lock include/linux/fs.h:1024 [inline]
ffff888077a8eba0 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: vfs_rename+0x566/0x2000 fs/namei.c:6162

but task is already holding lock:
ffff888077a8cfa0 (&sb->s_type->i_mutex_key#25/2){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
ffff888077a8cfa0 (&sb->s_type->i_mutex_key#25/2){+.+.}-{4:4}, at: vfs_rename+0x542/0x2000 fs/namei.c:6160

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&sb->s_type->i_mutex_key#25/2){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_write_nested+0x94/0x200 kernel/locking/rwsem.c:1757
       inode_lock_nested include/linux/fs.h:1069 [inline]
       __ocfs2_reflink.isra.0+0x328/0x1c50 fs/ocfs2/refcounttree.c:4198
       ocfs2_reflink+0x5cf/0xbb0 fs/ocfs2/refcounttree.c:4297
       ocfs2_vfs_reflink fs/ocfs2/refcounttree.c:4423 [inline]
       ocfs2_reflink_ioctl+0x7cd/0xa60 fs/ocfs2/refcounttree.c:4463
       ocfs2_ioctl+0x5e8/0x6e0 fs/ocfs2/ioctl.c:920
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&ocfs2_quota_ip_alloc_sem_key){++++}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1631
       ocfs2_reflink+0x596/0xbb0 fs/ocfs2/refcounttree.c:4296
       ocfs2_vfs_reflink fs/ocfs2/refcounttree.c:4423 [inline]
       ocfs2_reflink_ioctl+0x7cd/0xa60 fs/ocfs2/refcounttree.c:4463
       ocfs2_ioctl+0x5e8/0x6e0 fs/ocfs2/ioctl.c:920
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl fs/ioctl.c:583 [inline]
       __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&oi->ip_xattr_sem){++++}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       ocfs2_xattr_get+0x10f/0x270 fs/ocfs2/xattr.c:1578
       __vfs_getxattr+0x13d/0x1a0 fs/xattr.c:446
       cap_inode_need_killpriv+0x40/0x60 security/commoncap.c:331
       security_inode_need_killpriv+0x87/0x1e0 security/security.c:2186
       notify_change+0x779/0x1330 fs/attr.c:481
       chown_common+0x51e/0x6e0 fs/open.c:825
       do_fchownat+0x18e/0x1f0 fs/open.c:853
       __do_sys_chown fs/open.c:873 [inline]
       __se_sys_chown fs/open.c:871 [inline]
       __x64_sys_chown+0x7b/0xc0 fs/open.c:871
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&sb->s_type->i_mutex_key#25){++++}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1631
       inode_lock include/linux/fs.h:1024 [inline]
       vfs_rename+0x566/0x2000 fs/namei.c:6162
       filename_renameat2+0x754/0xa60 fs/namei.c:6326
       __do_sys_rename fs/namei.c:6370 [inline]
       __se_sys_rename fs/namei.c:6366 [inline]
       __x64_sys_rename+0x81/0xb0 fs/namei.c:6366
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &sb->s_type->i_mutex_key#25 --> &ocfs2_quota_ip_alloc_sem_key --> &sb->s_type->i_mutex_key#25/2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sb->s_type->i_mutex_key#25/2);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&sb->s_type->i_mutex_key#25/2);
  lock(&sb->s_type->i_mutex_key#25);

 *** DEADLOCK ***

locks held by syz.1.4093/19971: 5, last CPU#1:
 #0: ffff88802476a460 (sb_writers#14){.+.+}-{0:0}, at: filename_renameat2+0x3af/0xa60 fs/namei.c:6290
 #1: ffff88802476a768 (&type->s_vfs_rename_key#5){+.+.}-{4:4}, at: lock_rename fs/namei.c:3789 [inline]
 #1: ffff88802476a768 (&type->s_vfs_rename_key#5){+.+.}-{4:4}, at: __start_renaming+0x111/0x520 fs/namei.c:3878
 #2: ffff88804fd1c1a0 (&type->i_mutex_dir_key#10/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #2: ffff88804fd1c1a0 (&type->i_mutex_dir_key#10/1){+.+.}-{4:4}, at: lock_two_directories+0x162/0x2d0 fs/namei.c:3765
 #3: ffff888077a8f9a0 (&sb->s_type->i_mutex_key#25/5){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #3: ffff888077a8f9a0 (&sb->s_type->i_mutex_key#25/5){+.+.}-{4:4}, at: lock_two_directories+0x199/0x2d0 fs/namei.c:3766
 #4: ffff888077a8cfa0 (&sb->s_type->i_mutex_key#25/2){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:1069 [inline]
 #4: ffff888077a8cfa0 (&sb->s_type->i_mutex_key#25/2){+.+.}-{4:4}, at: vfs_rename+0x542/0x2000 fs/namei.c:6160

stack backtrace:
CPU: 1 UID: 0 PID: 19971 Comm: syz.1.4093 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1be kernel/locking/lockdep.c:2087
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2219
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
 lock_acquire kernel/locking/lockdep.c:5942 [inline]
 lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
 down_write+0x8b/0x1f0 kernel/locking/rwsem.c:1631
 inode_lock include/linux/fs.h:1024 [inline]
 vfs_rename+0x566/0x2000 fs/namei.c:6162
 filename_renameat2+0x754/0xa60 fs/namei.c:6326
 __do_sys_rename fs/namei.c:6370 [inline]
 __se_sys_rename fs/namei.c:6366 [inline]
 __x64_sys_rename+0x81/0xb0 fs/namei.c:6366
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3e8219e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3e82fa2028 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00007f3e82425fa0 RCX: 00007f3e8219e159
RDX: 0000000000000000 RSI: 0000200000002440 RDI: 0000200000002340
RBP: 00007f3e8223506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3e82426038 R14: 00007f3e82425fa0 R15: 00007fffbb292648
 </TASK>
(syz.1.4093,19971,1):ocfs2_double_lock:1202 ERROR: status = -2
(syz.1.4093,19971,1):ocfs2_rename:1311 ERROR: status = -2
(syz.1.4093,19971,1):ocfs2_rename:1711 ERROR: status = -2


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

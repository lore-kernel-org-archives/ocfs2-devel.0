Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFCC12FB34
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724000788; cv=none; b=rAgVm5tFa3LNK6f6kxgpAS2FV2q+5WReCWdXiLpN1mn7n7p1fnVd3H0FuySPhWvmQDdv1WR1o5yij5lWhG6RrL2rFRk4DOc1IhrLaC6DpqoQmgiarvfkeujbjDfcrHrblkVkOk6gR8HnE9jqk8IJhvAdI1piByls8xyUnrrfAFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724000788; c=relaxed/simple;
	bh=7uihQaIe1v3SpARYJseHEKh6z9iSbqvBveQqHa7kFYk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oUt20OBlK9osgkpXcI6/yAuHgL9fTto2wN3+W3jA8PjUTvWSxi4G+9Wlmzn8cOqWJ52JQ1spXKcC37yy9SJ50yYRS8c1Zi+Yn1NfXAbuQ3S8SU15GpUccPRxV7VLTIW2rhN4sXGkrvPKAimObqolqmLOqHvEUFuXrMOix/hTvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f8c780fe7so353874439f.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Aug 2024 10:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724000786; x=1724605586;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lVs+Y106R9IQp9A6uG6TsFq3/HHb4uB6f0rcaCLdZuI=;
        b=GKvoYMfPfoVS9p+ROa2exQGFpQGBrNp/hOG0HrLZ6GbXUORuX+8Ryrv5Ewf6kw9Eyh
         4NjxL9FBm4B4bslemwLLrMlte7FycCdHIpKbb4PsjECbZ2T+2HI6DwuAlMQtVWghVHW6
         FQ6S8wGkMva/2rXdhV470jJE6nwWLJ0rIGpE32S6A0avs8bh6dElsmhts0KyiK/MtDM4
         m738yQ5PglC3FV+zaDAeWG19L4K/hOGWjYyLzhhgtQx1PHyGJu7lAxFjvuVI3WC67ckj
         dwVYa5K40vXMRujE8Pivhu8dFUDKEc0I9qn/+wnFg3Y8nSoggozZj7LzeFq7LLLaoa4v
         80uA==
X-Forwarded-Encrypted: i=1; AJvYcCWFLoDNHMxwbaA5naWmo13gQ3AIlzc45sLxIE97e6hAh6yE+jvsjVpGCZaDXjWNC/tIbECY+yssulTzdXPRZnwaUkFpWBEWNGBrSTc=
X-Gm-Message-State: AOJu0Yz9v7FEBxaFlklf1qpcg+T0m2OWO8RIRArK6pchJ5KcuGjsQyJM
	sULkGrVpvRCEDGKhP0TrgjmfcrS7Lq1S8+040Hp1p1lILyvebHOPXnv0sEObNbTUkYD53NXR4W6
	zoxueOvjleb5eEQLd/XtZJ0eXrBaKBiZLwUB+iYiD2vRAQPS2FUInvtE=
X-Google-Smtp-Source: AGHT+IGFxLUqEwkzkWLa6Apb7vm5HQFV8SnbEj8QmO9Oli1y7ktbggvOoAEAKr2TOeW5+aLPTlVzsFVGhdHF+fqO9tA0X81SLjLC
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6c03:b0:81f:8d10:6f00 with SMTP id
 ca18e2360f4ac-824f269c430mr33999439f.2.1724000786264; Sun, 18 Aug 2024
 10:06:26 -0700 (PDT)
Date: Sun, 18 Aug 2024 10:06:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007541d9061ff83615@google.com>
Subject: [syzbot] [ocfs2?] WARNING: bad unlock balance in ocfs2_read_blocks
From: syzbot <syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c3f2d783a459 Merge tag 'mm-hotfixes-stable-2024-08-17-19-3..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102f82dd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a0ec05980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ac3093980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-c3f2d783.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d927f7c3cfd/vmlinux-c3f2d783.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea54bdfad24b/bzImage-c3f2d783.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/f0e7bccc5087/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/5861bd127de9/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 9061
(syz-executor268,5095,0):ocfs2_read_blocks:240 ERROR: status = -12
=====================================
WARNING: bad unlock balance detected!
6.11.0-rc3-syzkaller-00338-gc3f2d783a459 #0 Not tainted
-------------------------------------
syz-executor268/5095 is trying to release lock (&oi->ip_io_mutex) at:
[<ffffffff837f37f6>] ocfs2_read_blocks+0x11c6/0x1620 fs/ocfs2/buffer_head_io.c:394
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz-executor268/5095:
 #0: ffff8880207680e0 (&type->s_umount_key#43/1){+.+.}-{3:3}, at: alloc_super+0x221/0x9d0 fs/super.c:344

stack backtrace:
CPU: 0 UID: 0 PID: 5095 Comm: syz-executor268 Not tainted 6.11.0-rc3-syzkaller-00338-gc3f2d783a459 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 print_unlock_imbalance_bug+0x256/0x2c0 kernel/locking/lockdep.c:5199
 __lock_release kernel/locking/lockdep.c:5436 [inline]
 lock_release+0x5cb/0xa30 kernel/locking/lockdep.c:5780
 __mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912
 ocfs2_read_blocks+0x11c6/0x1620 fs/ocfs2/buffer_head_io.c:394
 ocfs2_map_slot_buffers fs/ocfs2/slot_map.c:385 [inline]
 ocfs2_init_slot_info+0xb35/0x13d0 fs/ocfs2/slot_map.c:424
 ocfs2_initialize_super fs/ocfs2/super.c:2274 [inline]
 ocfs2_fill_super+0x31b7/0x5880 fs/ocfs2/super.c:994
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0669b38cea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0669aed048 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000020000100 RCX: 00007f0669b38cea
RDX: 0000000020000100 RSI: 00000000200044c0 RDI: 00007f0669aed0a0
RBP: 00000000200044c0 R08: 00007f0669aed0e0 R09: 00000000ffffffe8
R10: 0000000000000000 R11: 0000000000000282 R12: 00007f0669aed0e0
R13: 000000000000447d R14: 0000000000000000 R15: 0000000020002340
 </TASK>
(syz-executor268,5095,0):ocfs2_map_slot_buffers:388 ERROR: status = -12
(syz-executor268,5095,0):ocfs2_init_slot_info:426 ERROR: status = -12
(syz-executor268,5095,0):ocfs2_initialize_super:2276 ERROR: status = -12
(syz-executor268,5095,0):ocfs2_fill_super:1178 ERROR: status = -12


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

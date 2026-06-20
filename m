Received: from mail-ot1-f78.google.com (mail-ot1-f78.google.com [209.85.210.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FE5231C91
	for <ocfs2-devel@lists.linux.dev>; Sat, 20 Jun 2026 03:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781927966; cv=none; b=XgJOoXQpizFPfnvzrvBMUq1PD4d+aU8Aagn/fcjnPhKFoFwKvExMyUk1IEOUrbs5I2RDpBeyf0nMpAqzCh998Q68dcnEc7zr7xPTXgJJkobzI6lCKcwkruZBZXgjEgpXXvAIaxDN4vdaiZ+vpDzJfvqk2XNcvazmfCTZgFQ/aDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781927966; c=relaxed/simple;
	bh=sfm/jKA9PdU8NL1m9lwViChZ7NgjPrCvDr088M9JyKs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kyWkhNaWCdF0K159c8+AGngS2+qnU/Nx3NjfqEyoSDC1tfoSdB7HlwxDVi8mORNV8F+k+8hKM6GO62NWrX+uXZVANGnGnckOkLlp4g5DbIYZgf4M70zB+Ljhj5H01cRvxg8VFGECKTMIrMN2FAxejuac8qagUy6m5DCIGLTnEnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f78.google.com with SMTP id 46e09a7af769-7e92ff90c55so1716512a34.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 19 Jun 2026 20:59:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781927963; x=1782532763;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fp7zNQ+9tUYXcvCHIK53UIefdtLteCIywp9TpaM1LLE=;
        b=A71bC0tJw7g7dXwW5bcbJYtQ8RJyssUKg7TDSGfVchJUS7vklnWk1Xn+UKm3hag++i
         YuI2orbr/hKKR1yhH8yhg/jtCs/7x7PvItZBvDfwWwT7LMQXV0109XuaA3AczN1nrOCv
         +Gf3ivCWAIK9h6qBnRWcoSOt/qDkD7V/Kp6Q5xDFQp8J/vEdaJjhQDJHAsU1+q5N1AFc
         6eo6IsfTJSR7XBo3qGQhb5IIy8Y2gQRQTealxss7/NV76S6stCb6HFi4LqeG4LJD/pNL
         b4ZdWNvevakWDhg2Uhdka2ji99RSH+zAi9Sx56ydCoUAQcsSoqzWjVL3dnqQF9isBfMQ
         GhQQ==
X-Forwarded-Encrypted: i=1; AFNElJ93QR01mWF/QhIZ8KjIkQ9r3fhwWEic3pWNTOe0p7JJybmoiRqJCQOAeEU2vWQL4U8+qNVMx4k12rfIqw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxmyqcWIb6ChoUmUSp+vEeH5CmWheW4wPFz+VfH/hQMPbGYXVBm
	0khP02zfPXFNsjjq4XX8o/SiBb6tJ/6FlHbFoNu/WtB2sVogA7HLoPFh5kW4BYJ6iEf2t6eFaog
	3DcE+HSi08layKvZqEMmm88OqjtlqBvQn0BaXYmy+XWjDf/SxUAicWH+FzHI=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5296:b0:489:5c86:ba9a with SMTP id
 5614622812f47-4896aa7420bmr5603863b6e.19.1781927963509; Fri, 19 Jun 2026
 20:59:23 -0700 (PDT)
Date: Fri, 19 Jun 2026 20:59:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a36101b.be22b350.2a3e9.0002.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING in __rt_mutex_slowlock_locked (3)
From: syzbot <syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b1cbabe84ca1 Merge tag 'for-7.2/dm-changes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b26986580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=effd10de8797244
dashboard link: https://syzkaller.appspot.com/bug?extid=ce129763ce7d7e914739
compiler:       Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a7e4ae580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100063b6580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/965fde89d8ba/disk-b1cbabe8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6e68a7e15b8d/vmlinux-b1cbabe8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6ffa4967bc81/bzImage-b1cbabe8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d0c566fd1884/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1344c4ae580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com

------------[ cut here ]------------
rtmutex deadlock detected
WARNING: kernel/locking/rtmutex.c:1698 at rt_mutex_handle_deadlock kernel/locking/rtmutex.c:1698 [inline], CPU#1: syz.2.19/6001
WARNING: kernel/locking/rtmutex.c:1698 at __rt_mutex_slowlock kernel/locking/rtmutex.c:1760 [inline], CPU#1: syz.2.19/6001
WARNING: kernel/locking/rtmutex.c:1698 at __rt_mutex_slowlock_locked+0xeeb/0x25b0 kernel/locking/rtmutex.c:1787, CPU#1: syz.2.19/6001
Modules linked in:
CPU: 1 UID: 0 PID: 6001 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
RIP: 0010:rt_mutex_handle_deadlock kernel/locking/rtmutex.c:1698 [inline]
RIP: 0010:__rt_mutex_slowlock kernel/locking/rtmutex.c:1760 [inline]
RIP: 0010:__rt_mutex_slowlock_locked+0xeeb/0x25b0 kernel/locking/rtmutex.c:1787
Code: 0d 48 8b bc 24 88 00 00 00 e8 51 1a 7c 09 83 7c 24 40 dd 0f 85 3a 0b 00 00 48 8b 7c 24 18 e8 2c 1b 7c 09 48 8d 3d 45 3a cc 0d <67> 48 0f b9 3a 48 8b 9c 24 80 00 00 00 4c 8b b4 24 90 00 00 00 43
RSP: 0018:ffffc900040f6ae0 EFLAGS: 00010286
RAX: 0000000080000000 RBX: ffff888045214e28 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8b87bf80 RDI: ffffffff8f6c4fb0
RBP: ffffc900040f6cb0 R08: ffffffff8f692af7 R09: 1ffffffff1ed255e
R10: dffffc0000000000 R11: fffffbfff1ed255f R12: ffff88803bd7f550
R13: ffff88803bd7dd18 R14: ffff888045213d68 R15: dffffc0000000000
FS:  00007f5edd08e6c0(0000) GS:ffff88812647d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000293cc000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rt_mutex_slowlock+0xbd/0x170 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 rwbase_write_lock+0x14c/0x720 kernel/locking/rwbase_rt.c:251
 inode_lock include/linux/fs.h:1029 [inline]
 ocfs2_del_inode_from_orphan+0x12e/0x7b0 fs/ocfs2/namei.c:2728
 ocfs2_dio_end_io_write fs/ocfs2/aops.c:2379 [inline]
 ocfs2_dio_end_io+0xfe3/0x13b0 fs/ocfs2/aops.c:2418
 dio_complete+0x254/0x760 fs/direct-io.c:281
 __blockdev_direct_IO+0x2d43/0x33d0 fs/direct-io.c:1296
 ocfs2_direct_IO+0x24b/0x2c0 fs/ocfs2/aops.c:2455
 generic_file_direct_write+0x1d1/0x3f0 mm/filemap.c:4270
 __generic_file_write_iter+0x120/0x240 mm/filemap.c:4439
 ocfs2_file_write_iter+0x1709/0x1f20 fs/ocfs2/file.c:2476
 do_iter_readv_writev+0x624/0x8d0 fs/read_write.c:-1
 vfs_writev+0x34c/0x990 fs/read_write.c:1058
 do_pwritev fs/read_write.c:1154 [inline]
 __do_sys_pwritev2 fs/read_write.c:1212 [inline]
 __se_sys_pwritev2+0x17a/0x2a0 fs/read_write.c:1203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5edda2ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5edd08e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f5eddca5fa0 RCX: 00007f5edda2ce59
RDX: 0000000000000001 RSI: 0000200000000240 RDI: 0000000000000004
RBP: 00007f5eddac2d6f R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000005a00 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5eddca6038 R14: 00007f5eddca5fa0 R15: 00007ffef8036c98
 </TASK>
----------------
Code disassembly (best guess):
   0:	0d 48 8b bc 24       	or     $0x24bc8b48,%eax
   5:	88 00                	mov    %al,(%rax)
   7:	00 00                	add    %al,(%rax)
   9:	e8 51 1a 7c 09       	call   0x97c1a5f
   e:	83 7c 24 40 dd       	cmpl   $0xffffffdd,0x40(%rsp)
  13:	0f 85 3a 0b 00 00    	jne    0xb53
  19:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  1e:	e8 2c 1b 7c 09       	call   0x97c1b4f
  23:	48 8d 3d 45 3a cc 0d 	lea    0xdcc3a45(%rip),%rdi        # 0xdcc3a6f
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	48 8b 9c 24 80 00 00 	mov    0x80(%rsp),%rbx
  36:	00
  37:	4c 8b b4 24 90 00 00 	mov    0x90(%rsp),%r14
  3e:	00
  3f:	43                   	rex.XB


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

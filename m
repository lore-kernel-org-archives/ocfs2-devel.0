Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794644790;
	b=w0Jw9J9AgaDbYqIisRmB8+PVcDhu3qvRgzeI4JcZ+MsHVAu1hb/SOkhEA/mHXPW1VKAx
	 BQeNi/KGxo9dVe4GLWKtuFsugjf2qmOL8hIgyIdMVfJCRKbEP540ut8x6acC9yjMooONo
	 j3hdopu7I0axNxR6I3oEmdV1Ti0rc6nn1ea+5euI92huejSkut/sNNPLKBT3IXlgwv7ea
	 nQPw3NI6KljiT1FjzR9MF/u81A54ldS0K8r7qCw0bpCIZ1zE/l1pX179aFuI5r7YRVk2E
	 KQrOgaDh9FBC6/ZsSnsiNB+MR2ShlVcpEz1RfgdT3J+JHn84VUQHRuuaWb5YhvaXdBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794644790;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=LxT87EFsNzRJRHFsuOKWqqk4s6jW+mIcA4huHSOsASI=;
	b=i4X5PQIJXrcN8eACUKmWJ9OZFLhtz4azB+XRHtIppwyiqjO1SCyXOvCBp4FqJMBocuW4
	 7fWpw7CTAFWNW8gJHx3cXr5/S6MaroxqchliGvNGjhnIr6XQsaY1tcq/et9c7/0H8wWDG
	 ZkQC+iFk8HieAWnH4bktujtllJt3mzOm3tem41tY/HIJ9lc+bHNA6YzdO5+MCRgVFlql0
	 C7lNP69RFySUtf162jlLcWPgPbrNotzeXbQgmrWXsBH1AlM/rK1O7MSd8WarIH9yUPh6g
	 tYdomrjbOQ4JzZ0iHpGrvbdVhXKu9HkEhRno0/cEGhpeiqmdUVGe0DMk8NGdaP06drg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D4E606A32D
	for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 08:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30D4E606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-862ad1e3959so32063a34.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 14 Nov 2026 00:26:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794644789; x=1795249589;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LxT87EFsNzRJRHFsuOKWqqk4s6jW+mIcA4huHSOsASI=;
        b=YnuWBab1jxYW325JjVhQiSCysS0geEfXncx4NH0+/nqvc10QsUzqN/gbrmLUljgMMZ
         5UznUCYDsQma+Q/ASnhWSmst8ESIbLnGixo2SvNGzXBA/1k50QA4/JFFrXuBWIVFPEt1
         sFBQlJ4kCb6l7LCc/2r1CSYTeQNk95miD2AdrRJvBLPS28moucDFa2xgtQ0BVscb5QKo
         v/ifJyQSBti+Jbgj/ZbnflwmXuT8iP9evQjga5tlzejQQlmlbL1YOuQhJs0bvJvs96ow
         NVVfK93zrFoWQ+jrnDueQBFiQCSg+ahlMY8yWH4SqmWM3D3mPG1mWx0YrEbnb9rJ8Bb2
         9Sbw==
X-Forwarded-Encrypted: i=1; AL+hErFYHNcrplmALnZYMQ5JXVzh383OUJouOa/wqXqrgfmFRIL2yhevgn67YGuFFLWrRpgbaBEsC0fV7iH6tg==@lists.linux.dev
X-Gm-Message-State: APuU4Z91Ev98yjtG8LV3GF4svMqJiH5Tr8jcW1kY3U76TVnS/IkNmdty
	tVybNVpyfR3pXxM/74949E34xYdSRG/PqvuIFFgYu20bqdx9DMVmvcO5eHrd+U+GaerraLEb0Ak
	YrKLp7iT1ApPJc9f+w/VAN8GJswFxWrm2mxlDurGGNGaitS1Pf1d3+f2baVg=
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c177:b0:4c3:7073:8c4d with SMTP id
 5614622812f47-56e642d319emr4344318b6e.20.1794644789171; Sat, 14 Nov 2026
 00:26:29 -0800 (PST)
Date: Sat, 14 Nov 2026 00:26:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af81b35.097d52ff.3d440.0001.GAE@google.com>
Subject: [syzbot] [ocfs2?] possible deadlock in ocfs2_duplicate_inline_data
From: syzbot <syzbot+3f66416993279938e957@syzkaller.appspotmail.com>
To: heming.zhao@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    97d73c825122 Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16c6353d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d16c0eae9c338e3c
dashboard link: https://syzkaller.appspot.com/bug?extid=3f66416993279938e957
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c6353d580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13609bed580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3968468419c5/disk-97d73c82.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1066269755a7/vmlinux-97d73c82.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec6230abb854/bzImage-97d73c82.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/28571daccc92/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=136fc9ad580000)

AI-generated root cause summary:
In fs/ocfs2/xattr.c, OCFS2_IP_ALLOC_SEM_UNPUBLISHED was defined as 1 to allow
down_write_nested(&OCFS2_I(inode)->ip_alloc_sem, ...) within an active
transaction during inode creation without tripping lockdep against the standard
ip_alloc_sem -> transaction lock order. However, subclass 1
(SINGLE_DEPTH_NESTING) was already in use by ocfs2_remap_file_range() in
fs/ocfs2/file.c when locking the destination inode's ip_alloc_sem. When
ocfs2_remap_file_range() locks the destination inode under subclass 1 and
invokes ocfs2_reflink_remap_blocks() -> ocfs2_duplicate_inline_data(),
ocfs2_start_trans() is called, acquiring sb_internal and j_trans_barrier;
lockdep sees both transaction -> ip_alloc_sem/1 and ip_alloc_sem/1 ->
transaction, reporting a circular locking dependency false positive due to the
subclass collision.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=3f66416993279938e957

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3f66416993279938e957@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz-executor238/5619 is trying to acquire lock:
ffff88803fb38818 (sb_internal#2){.+.+}-{0:0}, at: ocfs2_duplicate_inline_data+0x16a/0x570 fs/ocfs2/refcounttree.c:3991

but task is already holding lock:
ffff88803559db90 (&oi->ip_alloc_sem/1){+.+.}-{4:4}, at: ocfs2_remap_file_range+0x342/0x700 fs/ocfs2/file.c:2780

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&oi->ip_alloc_sem/1){+.+.}-{4:4}:
       down_write_nested+0x39/0x50 kernel/locking/rwsem.c:1757
       ocfs2_xattr_set_handle+0x3fc/0x820 fs/ocfs2/xattr.c:3941
       ocfs2_init_security_set+0x151/0x210 fs/ocfs2/xattr.c:7996
       ocfs2_mknod+0x13dd/0x2190 fs/ocfs2/namei.c:422
       ocfs2_create+0x195/0x460 fs/ocfs2/namei.c:677
       lookup_open+0x103d/0x1b00 fs/namei.c:4575
       open_last_lookups fs/namei.c:4774 [inline]
       path_openat+0x711/0x2100 fs/namei.c:5013
       do_file_open+0x23e/0x4a0 fs/namei.c:5045
       do_sys_openat2+0x115/0x200 fs/open.c:1443
       do_sys_open fs/open.c:1449 [inline]
       __do_sys_creat fs/open.c:1527 [inline]
       __se_sys_creat fs/open.c:1521 [inline]
       __x64_sys_creat+0x8f/0xc0 fs/open.c:1521
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&journal->j_trans_barrier){.+.+}-{4:4}:
       down_read+0x92/0x200 kernel/locking/rwsem.c:1574
       ocfs2_start_trans+0x3aa/0x700 fs/ocfs2/journal.c:379
       ocfs2_block_group_alloc fs/ocfs2/suballoc.c:801 [inline]
       ocfs2_reserve_suballoc_bits+0x7b7/0x4850 fs/ocfs2/suballoc.c:950
       ocfs2_reserve_new_metadata_blocks+0x415/0x9a0 fs/ocfs2/suballoc.c:1100
       ocfs2_mknod+0xe79/0x2190 fs/ocfs2/namei.c:350
       ocfs2_create+0x195/0x460 fs/ocfs2/namei.c:677
       lookup_open+0x103d/0x1b00 fs/namei.c:4575
       open_last_lookups fs/namei.c:4774 [inline]
       path_openat+0x711/0x2100 fs/namei.c:5013
       do_file_open+0x23e/0x4a0 fs/namei.c:5045
       do_sys_openat2+0x115/0x200 fs/open.c:1443
       do_sys_open fs/open.c:1449 [inline]
       __do_sys_creat fs/open.c:1527 [inline]
       __se_sys_creat fs/open.c:1521 [inline]
       __x64_sys_creat+0x8f/0xc0 fs/open.c:1521
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_internal#2){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_intwrite include/linux/fs/super.h:177 [inline]
       ocfs2_start_trans+0x2a7/0x700 fs/ocfs2/journal.c:377
       ocfs2_duplicate_inline_data+0x16a/0x570 fs/ocfs2/refcounttree.c:3991
       ocfs2_reflink_remap_blocks+0x4aa/0x1ab0 fs/ocfs2/refcounttree.c:4684
       ocfs2_remap_file_range+0x457/0x700 fs/ocfs2/file.c:2788
       vfs_copy_file_range+0xe39/0x1430 fs/read_write.c:1581
       __do_sys_copy_file_range fs/read_write.c:1664 [inline]
       __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1631
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  sb_internal#2 --> &journal->j_trans_barrier --> &oi->ip_alloc_sem/1

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&oi->ip_alloc_sem/1);
                               lock(&journal->j_trans_barrier);
                               lock(&oi->ip_alloc_sem/1);
  rlock(sb_internal#2);

 *** DEADLOCK ***

locks held by syz-executor238/5619: 5, on CPU#0:
 #0: ffff88803fb38528 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2765 [inline]
 #0: ffff88803fb38528 (sb_writers#8){.+.+}-{0:0}, at: vfs_copy_file_range+0xa29/0x1430 fs/read_write.c:1569
 #1: ffff88803559ce80 (&sb->s_type->i_mutex_key#17){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #1: ffff88803559ce80 (&sb->s_type->i_mutex_key#17){+.+.}-{4:4}, at: lock_two_nondirectories+0xe7/0x180 fs/inode.c:1275
 #2: ffff88803559df40 (&sb->s_type->i_mutex_key#17/4){+.+.}-{4:4}, at: ocfs2_reflink_inodes_lock+0x11a/0xc20 fs/ocfs2/refcounttree.c:4772
 #3: ffff88803559cad0 (&oi->ip_alloc_sem#2){++++}-{4:4}, at: ocfs2_remap_file_range+0x31e/0x700 fs/ocfs2/file.c:2778
 #4: ffff88803559db90 (&oi->ip_alloc_sem/1){+.+.}-{4:4}, at: ocfs2_remap_file_range+0x342/0x700 fs/ocfs2/file.c:2780

stack backtrace:
CPU: 0 UID: 0 PID: 5619 Comm: syz-executor238 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/06/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_intwrite include/linux/fs/super.h:177 [inline]
 ocfs2_start_trans+0x2a7/0x700 fs/ocfs2/journal.c:377
 ocfs2_duplicate_inline_data+0x16a/0x570 fs/ocfs2/refcounttree.c:3991
 ocfs2_reflink_remap_blocks+0x4aa/0x1ab0 fs/ocfs2/refcounttree.c:4684
 ocfs2_remap_file_range+0x457/0x700 fs/ocfs2/file.c:2788
 vfs_copy_file_range+0xe39/0x1430 fs/read_write.c:1581
 __do_sys_copy_file_range fs/read_write.c:1664 [inline]
 __se_sys_copy_file_range+0x2fb/0x480 fs/read_write.c:1631
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fee8fd74a09
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffecd787a88 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fee8fd74a09
RDX: 0000000000000004 RSI: 0000200000004d40 RDI: 0000000000000005
RBP: 0000000000000001 R08: fffffffffffffff8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffecd787ac0
R13: 0000000000000002 R14: 431bde82d7b634db R15: 00007fee8fdd404b
 </TASK>


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

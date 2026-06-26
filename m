Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6CD3ABD95
	for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 08:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782461374; cv=pass; b=rHroL4EwyBWKSCCeH3tnEnuu53wRm6ESf0zyqGcbkG2EznpeO7y3AmKsSGT82aPbsPWqBqELfay4BdhEHbcxrTazl1lz4rPFbpNGfwu4auHVccYU2fe2Z86I5lR5s53uBSRcU3ot1crzPR0oipH7Y0wsZmNcRGOB9GRAXL4QCd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782461374; c=relaxed/simple;
	bh=LxlDGYnkSefoy4VKzXGwGWY5H1v4SXOnw9lhn/fH1+s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Xq79EPL2Px202byQraPdwlHoA8vqRTUc8Bb6ml6m4pajOAFM9NaB/AyOIBFYRBYt/chP6GklVV9q7gclmP56Yg4H/v6NyhhRR28TWfARjgzjTr80ZSGa63Xw0vAhr2uOiGWZvGie5l7Ps5E5esR980PinQG0gldg57s8nma/7Sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ApilITah; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ApilITah"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c0efc7ef797so102985866b.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 26 Jun 2026 01:09:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782461371; cv=none;
        d=google.com; s=arc-20260327;
        b=Y4xLWGUQ/0OvHPh4VCeRNx4ZJf+M/Os5LljXlyp8JnU5TW8/d2diAax8D34TftR1lm
         KMFf719XtB3cNeXnHl8072qvpUWrKYJ5Z/sV9CYdmiUkbWcKa3GiJPehr+5HM8+wruvU
         zSSbQ4juvSDAsrfXUMPVBn8TW0PBV6pFNMVVXFMTfopB8pRWLui/Qz34vB0XK2nHyPvF
         7YSNPDCQfTUcEto3pFORlF8TyoCwATBWtP/vXoAGHMbKp+B6gab97rsF/rgs98faSF1y
         1NJLZaWqYYBuPjDQTD17pY67iTRTg4R5+KF+Mrif/0YCJPRK1OiPQa+wnWjtfGn8bXWt
         ZZ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=wQNSX6NvAYIpblirHIgZbTnCb2GrZCJFLC4P67HCpjI=;
        fh=sGN/KLXiOPbMBQCjlFe5MlhcM6mxnsINz9fydxW4rIk=;
        b=Omph0FvezQ6cLOzJM5MZLZerTlCEi58uD4mif8hQuIcXKmdzERGyP3oPutG7pCGFWJ
         HXHf2rx+vdX3938Ulva5ErExZ132bnBaXUy3fU3Nyd1UsTsoKcNyJuosDdvnIHDNJhLK
         kZ28vQBRXNQ7ExbpoRMmZOzL1OBvFWEhYcKl0JoMmXvuqfoG8XXvS6PpYd8U+UkqzbI7
         TNu6FBvqwGO2k9mGOqN+jfJvDggQWdQWRtz2RRQuGVo0mEPnQY+6K0JgJLViJ32HCMcj
         vceVk1pMxtPBzn5A/plI3jIWSU4VKeLnVCc23BgXPLP9KAzYFs9H08leyKX8Gtm4+LK2
         g6XQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782461371; x=1783066171; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wQNSX6NvAYIpblirHIgZbTnCb2GrZCJFLC4P67HCpjI=;
        b=ApilITah/7MSMifgEJ9fAZd6T7pT7IlQVsschwmisgoCEC6SYySMcoUgjw7LJzAKAt
         dfIGF8pAWxzXvOz7iYcW8K5sQBVWPFM8fNaAFrVlFZzOfzAvUz8XOXSEt1/itM6IeeDH
         uCRmZxrl/kFQyINGjc+MMuf1YQwBvqkTwkPx09EaYxl+HifWWV0NpyHUHwpAMnFcf6KM
         Ykv4M7GbG1BjgRHFMebV5C/dhqkemd4L1R5QPTqIE/0z554jl3jNbf9lQH0Z5r8VPX44
         KGPIIvGb5EaRjPko9rOYhPjkCpL8EDY5FG3Mw0MH4q8ruXDL/Fq6x36htmMJH3skOZJl
         yn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782461371; x=1783066171;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wQNSX6NvAYIpblirHIgZbTnCb2GrZCJFLC4P67HCpjI=;
        b=DZHo4xn+r6ZGux/PdVAK4e5UhbhMybpvSNtTVDs/ldDPfrwvzMgmVEoYb0Ilqyn30P
         3G6DiwuXzFutv1U0MdidMPYsdNx1pzD6jK0tWgP6BZyFJQBIr61eGgJzWLSmJk5BNkEf
         ie4pe7NbScqnfwZMCn28dgVMpqU1Wn/zB+cGzDNUdjgQW1OBK71n1Wwt8bOzH4anRj1r
         EQ/r7/NxRu5KL53BwepBylpyX1Kxe0P70XnpmBmWb4KgUzGgU/2zXeHRh2qkI12xeqIg
         TOqbhpI6ASTASg8tDGZNfQi2OtkNbG8scNvC6njuBQRDhg+SDoNR475IxD/GUktbGU2r
         bpmw==
X-Forwarded-Encrypted: i=1; AHgh+RpPCZnSJHmC9+ckwJHGcTSplXM+TuxIOw/VhxWLvfRqfOaw2+PJRoyVz5IvPBXT6ixYVJW9xafjEXJeag==@lists.linux.dev
X-Gm-Message-State: AOJu0YyzXEZmX1J9ialEcBL/JdpAh2gXAEYrEPo9hj9N5iucq1TKYU1d
	Pl9MnLluxVPnsYJM6UlKoGz6ZQ3x+WHRqwHplphnS947xlIOgQHys07A+bCROR/7/6ExhTUj4ke
	OtZAu6hAFyx9yIdNTa37lxmh/G653s4gJ/yecMoc0cg==
X-Gm-Gg: AfdE7cnDfAqTML2FmSUQM0WhA/iOI01L20Oc7LwF/Va5rFT/W6L42XeQJGYSb8qsXRC
	BD/oiRQ9ENhEX8y82gT2lhjrYtryXuMiwMvg8Y7KmLkSvKcgZVs7o8QjhfOMrnbWs9J5qzCzoP1
	mDShnX7aIiWuiAgWOs7AUIBgT8UV++rRf8JuHMl/WFSjAJSEH6BUJz6aHcHACNC8ehpcnHpPEq8
	sKkvPToCIpMARPmSIl+7tLmLC1KegAWcavcT0niVUpq6Eq7gd7FNu2PpdkrDufWFDMTmEeYvQ==
X-Received: by 2002:a17:906:e108:10b0:c12:29a3:e348 with SMTP id
 a640c23a62f3a-c1229a3eca4mr53341166b.27.1782461370422; Fri, 26 Jun 2026
 01:09:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jiaming Zhang <r772577952@gmail.com>
Date: Fri, 26 Jun 2026 16:08:44 +0800
X-Gm-Features: AVVi8CfiNSgl7KGjGVpdnHq58qXFQLQdFFN6nvSp2247ivj7B8uJtgCsSaQrww4
Message-ID: <CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com>
Subject: [Linux Kernel Bug] INFO: task hung in ocfs2_recovery_disable
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We are writing to report a task hung issue discovered in the OCFS2
subsystem. The issue is reproducible on the latest version of linux
(v7.1, commit 8cd9520d35a6c38db6567e97dd93b1f11f185dc6). Below is the
report formatted by syz-symbolize:

---
INFO: task syz-executor839:9410 blocked for more than 143 seconds.
      Not tainted 7.1.0 #20
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor839 state:D
 stack:24440 pid:9410  tgid:9410  ppid:9409   task_flags:0x400100
flags:0x00080800
Call Trace:
 <TASK>
 __schedule+0x177c/0x5610 kernel/sched/core.c:7236
 __schedule_loop kernel/sched/core.c:7307 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7322
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common kernel/sched/completion.c:121 [inline]
 wait_for_common kernel/sched/completion.c:132 [inline]
 wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
 __flush_workqueue+0x6f5/0x14b0 kernel/workqueue.c:4130
 ocfs2_recovery_disable+0x2bf/0x370 fs/ocfs2/journal.c:222
 ocfs2_dismount_volume+0x19a/0x8c0 fs/ocfs2/super.c:1815
 generic_shutdown_super+0x13d/0x2d0 fs/super.c:647
 kill_block_super+0x44/0x90 fs/super.c:1665
 deactivate_locked_super+0xbc/0x130 fs/super.c:477
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1317
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 futex_within_robust_unlock include/linux/futex.h:118 [inline]
 futex_fixup_robust_unlock include/linux/futex.h:137 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:65 [inline]
 exit_to_user_mode_loop+0xf5/0x560 kernel/entry/common.c:101
 syscall_exit_to_user_mode_work include/linux/entry-common.h:267 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:316 [inline]
 do_syscall_64+0x33a/0x5a0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5a083ba58b
RSP: 002b:00007ffcaa64f718 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f5a083ba58b
RDX: 00007f5a0839cfcc RSI: 0000000000000009 RDI: 00007ffcaa64f7e0
RBP: 00007ffcaa64f7e0 R08: 0000000000000073 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcaa650870
R13: 0000555592aef6e0 R14: 0000000000000001 R15: 431bde82d7b634db
 </TASK>

Showing all locks held in the system:
5 locks held by kworker/u8:0/12:
1 lock held by khungtaskd/32:
 #0: ffffffff8e1455a0 (rcu_read_lock){....}-{1:3}, at:
rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e1455a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock
include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8e1455a0 (rcu_read_lock){....}-{1:3}, at:
debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
1 lock held by journal-offline/89791:
 #0: ffff8880201b6c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at:
percpu_down_read include/linux/percpu-rwsem.h:77 [inline]
 #0: ffff8880201b6c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at:
ext4_writepages_down_read fs/ext4/ext4.h:1876 [inline]
 #0: ffff8880201b6c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at:
ext4_writepages+0x1ca/0x350 fs/ext4/inode.c:3042
1 lock held by syz-executor839/9410:
 #0: ffff88804437e0d8 (&type->s_umount_key#54){+.+.}-{4:4}, at:
__super_lock fs/super.c:58 [inline]
 #0: ffff88804437e0d8 (&type->s_umount_key#54){+.+.}-{4:4}, at:
__super_lock_excl fs/super.c:73 [inline]
 #0: ffff88804437e0d8 (&type->s_umount_key#54){+.+.}-{4:4}, at:
deactivate_super+0xa9/0xe0 fs/super.c:509

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 32 Comm: khungtaskd Not tainted 7.1.0 #20 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x10e/0x190 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:122
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:65
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 watchdog+0x182e/0x1890 kernel/watchdog.c:246
 kthread+0x38a/0x480 kernel/kthread.c:438
 ret_from_fork+0x509/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted 7.1.0 #20 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: ocfs2_wq ocfs2_complete_recovery
RIP: 0010:tick_program_event+0x0/0x120 kernel/time/tick-oneshot.c:28
Code: 99 0e 00 48 c7 c7 60 d1 b2 99 e8 eb 03 fc ff 31 c0 c3 cc cc cc
cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <0f> 1f
40 d6 55 41 57 41 56 41 55 41 54 53 89 f5 48 89 fb 49 bd 00
RSP: 0018:ffffc900001dec10 EFLAGS: 00000093
RAX: ffffffff81a6f534 RBX: ffff88802b828280 RCX: ffff88801c2e0000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00000042a62b9381
RBP: dffffc0000000000 R08: ffffffff8fa314f7 R09: 1ffffffff1f4629e
R10: dffffc0000000000 R11: fffffbfff1f4629f R12: ffff88802b8282e0
R13: 0000000000000000 R14: ffff88802b8282cf R15: 00000042a62b9381
FS:  0000000000000000(0000) GS:ffff888098ded000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd2bbe450d0 CR3: 000000004bc84000 CR4: 0000000000752ef0
PKRU: 55555554
Call Trace:
 <TASK>
 hrtimer_rearm kernel/time/hrtimer.c:2133 [inline]
 __hrtimer_rearm_deferred+0x270/0x450 kernel/time/hrtimer.c:2161
 rseq_update_user_cs include/linux/rseq_entry.h:398 [inline]
 rseq_update_usr include/linux/rseq_entry.h:553 [inline]
 rseq_exit_user_update include/linux/rseq_entry.h:645 [inline]
 __rseq_exit_to_user_mode_restart include/linux/rseq_entry.h:674 [inline]
 rseq_exit_to_user_mode_restart include/linux/rseq_entry.h:703 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:103 [inline]
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 irqentry_exit_to_user_mode_prepare
include/linux/irq-entry-common.h:244 [inline]
 irqentry_exit_to_user_mode include/linux/irq-entry-common.h:315 [inline]
 irqentry_exit+0x757/0x7e0 kernel/entry/common.c:165
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2039 [inline]
RIP: 0010:vprintk_emit+0x453/0x550 kernel/printk/printk.c:2478
Code: 0f 84 44 ff ff ff e8 8c 1c 20 00 fb eb 44 e8 84 1c 20 00 e8 0f
d8 c2 09 4d 85 f6 74 94 e8 75 1c 20 00 fb 48 c7 c7 c0 0d 02 8e <31> f6
ba 01 00 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 95 f6
RSP: 0018:ffffc900001ded60 EFLAGS: 00000293
RAX: ffffffff81990f1b RBX: ffffffff81990d95 RCX: ffff88801c2e0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e020dc0
RBP: ffffc900001dee10 R08: ffffffff8fa314f7 R09: 1ffffffff1f4629e
R10: dffffc0000000000 R11: fffffbfff1f4629f R12: 000000000000003e
R13: 0000000000000000 R14: 0000000000000200 R15: 0000000000000000
 _printk+0xcf/0x120 kernel/printk/printk.c:2504
 __mlog_printk+0x25e/0x290 fs/ocfs2/cluster/masklog.c:77
 ocfs2_get_clusters+0x4d0/0xa80 fs/ocfs2/extent_map.c:-1
 ocfs2_extent_map_get_blocks+0x202/0x6a0 fs/ocfs2/extent_map.c:678
 ocfs2_read_virt_blocks+0x288/0x960 fs/ocfs2/extent_map.c:1001
 ocfs2_read_dir_block+0xd8/0x4f0 fs/ocfs2/dir.c:521
 ocfs2_dir_foreach_blk_el fs/ocfs2/dir.c:1876 [inline]
 ocfs2_dir_foreach_blk+0x29a/0x1510 fs/ocfs2/dir.c:1962
 ocfs2_dir_foreach+0x42/0x70 fs/ocfs2/dir.c:1972
 ocfs2_queue_orphans fs/ocfs2/journal.c:2218 [inline]
 ocfs2_recover_orphans fs/ocfs2/journal.c:2302 [inline]
 ocfs2_complete_recovery+0xc38/0x2170 fs/ocfs2/journal.c:1369
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xb4b/0x1840 kernel/workqueue.c:3405
 manage_workers kernel/workqueue.c:3201 [inline]
 worker_thread+0x8a3/0xda0 kernel/workqueue.c:3461
 kthread+0x38a/0x480 kernel/kthread.c:438
 ret_from_fork+0x509/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
---

Here is our root cause analysis. Note that the analysis was performed
with assistance from an LLM and may not be accurate.

Given a crafted OCFS2 image with corrupt orphan-directory extent
metadata, unmount triggers orphan recovery and then waits in
ocfs2_recovery_disable() for ocfs2_complete_recovery to finish. The
recovery worker scans the orphan directory through
ocfs2_queue_orphans() -> ocfs2_dir_foreach(), but when
ocfs2_read_dir_block() fails on the corrupt directory block, the
extent-list directory walker handles the error by skipping forward
instead of aborting the internal full-directory scan; meanwhile,
ocfs2_dir_foreach() discards the walker return value. As a result,
orphan recovery may spend a very long time walking the damaged
directory instead of returning an error, so unmount can hang while
flushing osb->ocfs2_wq.

The potential fix is to make internal full-directory scans fail fast
on directory block read errors:

```
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8e6b03238327..549d9f40346c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1866,6 +1866,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
  struct super_block * sb = inode->i_sb;
  unsigned int ra_sectors = 16;
  int stored = 0;
+ int ret = 0;

  bh = NULL;

@@ -1873,9 +1874,13 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,

  while (ctx->pos < i_size_read(inode)) {
    blk = ctx->pos >> sb->s_blocksize_bits;
-   if (ocfs2_read_dir_block(inode, blk, &bh, 0)) {
+   ret = ocfs2_read_dir_block(inode, blk, &bh, 0);
+   if (ret) {
+     if (persist)
+       return ret;
      /* Skip the corrupt dirblock and keep trying */
      ctx->pos += sb->s_blocksize - offset;
+     offset = 0;
      continue;
    }

@@ -1950,7 +1955,7 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
    if (!persist && stored)
      break;
  }
- return 0;
+ return ret;
 }

 static int ocfs2_dir_foreach_blk(struct inode *inode, u64 *f_version,
@@ -1969,8 +1974,8 @@ static int ocfs2_dir_foreach_blk(struct inode
*inode, u64 *f_version,
 int ocfs2_dir_foreach(struct inode *inode, struct dir_context *ctx)
 {
  u64 version = inode_query_iversion(inode);
- ocfs2_dir_foreach_blk(inode, &version, ctx, true);
- return 0;
+
+ return ocfs2_dir_foreach_blk(inode, &version, ctx, true);
 }

 /*
@@ -2189,8 +2194,10 @@ int ocfs2_empty_dir(struct inode *inode)
  }

  ret = ocfs2_dir_foreach(inode, &priv.ctx);
- if (ret)
+ if (ret) {
    mlog_errno(ret);
+   return 0;
+ }

  if (!priv.seen_dot || !priv.seen_dot_dot) {
    mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",
```

With the above patch, I reran the C reproducer and did not trigger the
issue again.

If this solution is acceptable, we are happy to submit a formal patch.

The kernel console output, kernel config, syzkaller reproducer, and C
reproducer are also available on Google Drive:
https://drive.google.com/drive/folders/1TNujt7AI1zWIo54H6IXERahGVH1Vw3gJ?usp=sharing

Please let me know if any further information is required.

Best Regards,
Jiaming Zhang

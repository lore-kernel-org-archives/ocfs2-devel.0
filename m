Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEB313CFAD
	for <ocfs2-devel@lists.linux.dev>; Wed,  6 Nov 2024 08:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730880450; cv=none; b=FS4LdwtEGIy07dUCptu/qpe5rLdSwz5dCxjNx4LsZnO1wthqDKux34eszfk9ATpk0uCKovKItyjuDG3F9rqmmuG305vwnpyENKLSvJOtpB8IbmO9Q0kvZeqTbTxq86udUQRnG7Dy06mTMnVwx4CQEQTHx2e50y+x1dVxuJx3WvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730880450; c=relaxed/simple;
	bh=wZuRRNuxDidz574zavocng2QVbBI6mpaJ/vfuUVYeuU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QCQJI9fSOZrnRXkpBYVA8FM75LJmuROkmXQZS7SORa50E/tGGV8eYzqcyBO303b6zI1Yz8R/pvcIcGwyBVk2d1s6KmEtInQzD+X5TbZ7QPKASNAWuqlNWoAcEKyuv0StBkibEqO+/Q/OdMuGjJs8D2UazQqO23YW8G5UJYZKj+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83aae46538bso671005339f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 06 Nov 2024 00:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730880445; x=1731485245;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PfIImr7QeZx6eB64QAk6EhoI/9c7u+cLneLPWLTBsos=;
        b=lIHtoZJj82EzBPnsHbXBKTh+0SECcRLnhUcFWAAiq7Smsn3tlzLqy0jH+GYmE9HwEd
         WLQzvz/8xkRU2RZizZQ0hnDUlEsYBEcYQSumNTln3oqLPRHa24RKkqxc50XsbAVl2zjg
         cXUruQavyFaxdVnbALGFELPVhxlzN1RVHChzspRvv3HtPddFo8rLYiuN94GEVuHKj6A9
         zt1x6Jw1s4sVklGQryX+yhrNwv2T9CpYyslksz//PnNgxdVs2QSRqvIBLJrsh/uHeOK/
         hLXl3q7MSC2JYptXRqdkxUsITWPtn2bVhc4MT4agW0b14pC4kQroKzNpMYfG/PbO/RBE
         +Akg==
X-Forwarded-Encrypted: i=1; AJvYcCUgRvsejVUpBSKOJw8JUQLuOGyU3WgDbRyFzlLpovFuMnU/7w6pXgGbB30x+Zmpewlfal5B0QWOdEkjtg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwjqddbSTXSY90BLYlS5wVmTitjmZO/MoXK6NHBZ6x+5TnLLFLC
	2LsPdFzwzZIvyRc/ifMWDCGI62A+659M6gtfSefQUPHXnRXmmNcuLloU3uQY+2ftS9AP7RyxA99
	A1mvTfBXnfL1rm5AefHaDY/Wpnm37IaGjZt0gdINZQcw9Fr5oHR1babI=
X-Google-Smtp-Source: AGHT+IFxSqm4sTsHDYqXWiLtHaAKVn2uKzFi/vW0TMUkL0r0ORBdfK5FkiigENkHH4yhRNaZ3KflozltQQCOweMZiE64s6xz24af
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cc:b0:3a6:c000:4443 with SMTP id
 e9e14a558f8ab-3a6c000470amr117379275ab.20.1730880445368; Wed, 06 Nov 2024
 00:07:25 -0800 (PST)
Date: Wed, 06 Nov 2024 00:07:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672b23bd.050a0220.2a847.1ba3.GAE@google.com>
Subject: [syzbot] [ocfs2?] INFO: task hung in flush_delayed_work
From: syzbot <syzbot+ab509d831d9b0222f5fd@syzkaller.appspotmail.com>
To: jack@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2e1b3cc9d7f7 Merge tag 'arm-fixes-6.12-2' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16b25d5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11254d3590b16717
dashboard link: https://syzkaller.appspot.com/bug?extid=ab509d831d9b0222f5fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=142f4e30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c00d87980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6a49054c25b2/disk-2e1b3cc9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0d6873a86739/vmlinux-2e1b3cc9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/630443e7db25/bzImage-2e1b3cc9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bad1c1b4973a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab509d831d9b0222f5fd@syzkaller.appspotmail.com

INFO: task syz-executor186:5865 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor186 state:D
 stack:24080 pid:5865  tgid:5865  ppid:5860   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 __flush_work+0xa37/0xc50 kernel/workqueue.c:4217
 flush_work kernel/workqueue.c:4238 [inline]
 flush_delayed_work+0x169/0x1c0 kernel/workqueue.c:4260
 invalidate_dquots fs/quota/dquot.c:577 [inline]
 dquot_disable+0x7a7/0x1cd0 fs/quota/dquot.c:2295
 ocfs2_disable_quotas+0xf3/0x210 fs/ocfs2/super.c:963
 ocfs2_dismount_volume+0x1ad/0x8f0 fs/ocfs2/super.c:1870
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7b944e939
RSP: 002b:00007ffd2b477288 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe7b944e939
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fe7b94cf390 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007fe7b94cf390
R13: 0000000000000000 R14: 00007fe7b94d0100 R15: 00007fe7b941c830
 </TASK>
INFO: task syz-executor186:5866 blocked for more than 144 seconds.
      Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor186 state:D stack:23872 pid:5866  tgid:5866  ppid:5859   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 __flush_work+0xa37/0xc50 kernel/workqueue.c:4217
 flush_work kernel/workqueue.c:4238 [inline]
 flush_delayed_work+0x169/0x1c0 kernel/workqueue.c:4260
 invalidate_dquots fs/quota/dquot.c:577 [inline]
 dquot_disable+0x7a7/0x1cd0 fs/quota/dquot.c:2295
 ocfs2_disable_quotas+0xf3/0x210 fs/ocfs2/super.c:963
 ocfs2_dismount_volume+0x1ad/0x8f0 fs/ocfs2/super.c:1870
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7b944e939
RSP: 002b:00007ffd2b477288 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe7b944e939
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fe7b94cf390 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007fe7b94cf390
R13: 0000000000000000 R14: 00007fe7b94d0100 R15: 00007fe7b941c830
 </TASK>
INFO: task syz-executor186:5867 blocked for more than 145 seconds.
      Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor186 state:D
 stack:24432 pid:5867  tgid:5867  ppid:5862   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 __flush_work+0xa37/0xc50 kernel/workqueue.c:4217
 flush_work kernel/workqueue.c:4238 [inline]
 flush_delayed_work+0x169/0x1c0 kernel/workqueue.c:4260
 invalidate_dquots fs/quota/dquot.c:577 [inline]
 dquot_disable+0x7a7/0x1cd0 fs/quota/dquot.c:2295
 ocfs2_disable_quotas+0xf3/0x210 fs/ocfs2/super.c:963
 ocfs2_dismount_volume+0x1ad/0x8f0 fs/ocfs2/super.c:1870
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7b944e939
RSP: 002b:00007ffd2b477288 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe7b944e939
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fe7b94cf390 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007fe7b94cf390
R13: 0000000000000000 R14: 00007fe7b94d0100 R15: 00007fe7b941c830
 </TASK>
INFO: task syz-executor186:5868 blocked for more than 146 seconds.
      Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor186 state:D stack:23584 pid:5868  tgid:5868  ppid:5861   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 __flush_work+0xa37/0xc50 kernel/workqueue.c:4217
 flush_work kernel/workqueue.c:4238 [inline]
 flush_delayed_work+0x169/0x1c0 kernel/workqueue.c:4260
 invalidate_dquots fs/quota/dquot.c:577 [inline]
 dquot_disable+0x7a7/0x1cd0 fs/quota/dquot.c:2295
 ocfs2_disable_quotas+0xf3/0x210 fs/ocfs2/super.c:963
 ocfs2_dismount_volume+0x1ad/0x8f0 fs/ocfs2/super.c:1870
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7b944e939
RSP: 002b:00007ffd2b477288 EFLAGS: 00000246
 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe7b944e939
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fe7b94cf390 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007fe7b94cf390
R13: 0000000000000000 R14: 00007fe7b94d0100 R15: 00007fe7b941c830
 </TASK>
INFO: task syz-executor186:5869 blocked for more than 147 seconds.
      Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor186 state:D
 stack:23584 pid:5869  tgid:5869  ppid:5863   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 __flush_work+0xa37/0xc50 kernel/workqueue.c:4217
 flush_work kernel/workqueue.c:4238 [inline]
 flush_delayed_work+0x169/0x1c0 kernel/workqueue.c:4260
 invalidate_dquots fs/quota/dquot.c:577 [inline]
 dquot_disable+0x7a7/0x1cd0 fs/quota/dquot.c:2295
 ocfs2_disable_quotas+0xf3/0x210 fs/ocfs2/super.c:963
 ocfs2_dismount_volume+0x1ad/0x8f0 fs/ocfs2/super.c:1870
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7b944e939
RSP: 002b:00007ffd2b477288 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe7b944e939
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fe7b94cf390 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007fe7b94cf390
R13: 0000000000000000 R14: 00007fe7b94d0100 R15: 00007fe7b941c830
 </TASK>
INFO: task syz-executor186:5870 blocked for more than 149 seconds.
      Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor186 state:D stack:23192 pid:5870  tgid:5870  ppid:5864   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 __flush_work+0xa37/0xc50 kernel/workqueue.c:4217
 flush_work kernel/workqueue.c:4238 [inline]
 flush_delayed_work+0x169/0x1c0 kernel/workqueue.c:4260
 invalidate_dquots fs/quota/dquot.c:577 [inline]
 dquot_disable+0x7a7/0x1cd0 fs/quota/dquot.c:2295
 ocfs2_disable_quotas+0x1bc/0x210 fs/ocfs2/super.c:963
 ocfs2_dismount_volume+0x1ad/0x8f0 fs/ocfs2/super.c:1870
 generic_shutdown_super+0x13b/0x2d0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1710
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 __do_sys_exit_group kernel/exit.c:1099 [inline]
 __se_sys_exit_group kernel/exit.c:1097 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1097
 x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7b944e939
RSP: 002b:00007ffd2b477288 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe7b944e939
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fe7b94cf390 R08: ffffffffffffffb8 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007fe7b94cf390
R13: 0000000000000000 R14: 00007fe7b94d0100 R15: 00007fe7b941c830
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: 
ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6720
5 locks held by kworker/u8:2/33:
 #0: ffff8880b863ea98 (&rq->__lock){-.-.}-{2:2}
, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
 #1: 
ffff8880b8628948
 (&per_cpu_ptr(group->pcpu, cpu)->seq
){-.-.}-{0:0}
, at: psi_task_switch+0x41d/0x7a0 kernel/sched/psi.c:987
 #2: ffff8880b862a718
 (&base->lock
){-.-.}-{2:2}
, at: lock_timer_base+0x112/0x240 kernel/time/timer.c:1051
 #3: ffffffff8e9eda48 (jump_label_mutex){+.+.}-{3:3}
, at: jump_label_lock kernel/jump_label.c:27 [inline]
, at: static_key_enable_cpuslocked+0xd7/0x260 kernel/jump_label.c:207
 #4: 
ffffffff8e7e6f48
 (
text_mutex
){+.+.}-{3:3}
, at: arch_jump_label_transform_apply+0x17/0x30 arch/x86/kernel/jump_label.c:145
10 locks held by kworker/u8:7/1125:
2 locks held by getty/5598:
 #0: 
ffff8880351d20a0
 (
&tty->ldisc_sem
){++++}-{0:0}
, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: 
ffffc90002f062f0
 (
&ldata->atomic_read_lock
){+.+.}-{3:3}
, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
1 lock held by syz-executor186/5865:
 #0: ffff888033d4c0e0 (&type->s_umount_key
#47){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
#47){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
#47){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
1 lock held by syz-executor186/5866:
 #0: 
ffff88807d8ca0e0
 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 (&type->s_umount_key#47){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
1 lock held by syz-executor186/5867:
 #0: 
ffff8880781be0e0
 (&type->s_umount_key#47){+.+.}-{3:3}
, at: __super_lock fs/super.c:56 [inline]
, at: __super_lock_excl fs/super.c:71 [inline]
, at: deactivate_super+0xb5/0xf0 fs/super.c:505
1 lock held by syz-executor186/5868:
 #0: ffff88807df000e0
 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 (&type->s_umount_key#47){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
1 lock held by syz-executor186/5869:
 #0: ffff8880775e20e0 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff8880775e20e0 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff8880775e20e0 (&type->s_umount_key#47){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
1 lock held by syz-executor186/5870:
 #0: ffff888031f9a0e0 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff888031f9a0e0 (&type->s_umount_key#47){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff888031f9a0e0 (&type->s_umount_key#47){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 1125 Comm: kworker/u8:7 Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: events_unbound quota_release_workfn
RIP: 0010:trace_hardirqs_on+0x0/0x40 kernel/trace/trace_preemptirq.c:54
Code: ff ff 90 0f 0b 90 e9 77 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <f3> 0f 1e fa 65 8b 05 6d b8 66 7e 85 c0 74 14 48 8b 3c 24 e8 b8 fe
RSP: 0018:ffffc90000a18ca8 EFLAGS: 00000086
RAX: 0000000000000001 RBX: ffff8880b872a700 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8880b872a700
RBP: ffffc90000a18e10 R08: ffff8880b872a703 R09: 1ffff110170e54e0
R10: dffffc0000000000 R11: ffffed10170e54e1 R12: ffff8880b872a748
R13: ffffc90000a18d60 R14: dffffc0000000000 R15: 00000000fffffd10
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d3cad44600 CR3: 0000000034136000 CR4: 0000000000350ef0
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
 _raw_spin_unlock_irq+0x23/0x50 kernel/locking/spinlock.c:202
 __run_timer_base+0x1c0/0x8e0 kernel/time/timer.c:2431
 run_timer_base kernel/time/timer.c:2439 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2449
 handle_softirqs+0x2c7/0x980 kernel/softirq.c:554
 __do_softirq kernel/softirq.c:588 [inline]
 invoke_softirq kernel/softirq.c:428 [inline]
 __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:649
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2042 [inline]
RIP: 0010:vprintk_emit+0x700/0xa10 kernel/printk/printk.c:2406
Code: 00 e8 f4 c2 20 00 4c 8d bc 24 a0 00 00 00 4d 85 e4 75 07 e8 e2 c2 20 00 eb 06 e8 db c2 20 00 fb 49 bc 00 00 00 00 00 fc ff df <48> c7 c7 80 33 81 8e 31 f6 ba 01 00 00 00 31 c9 41 b8 01 00 00 00
RSP: 0018:ffffc90004897600 EFLAGS: 00000293
RAX: ffffffff81741785 RBX: 0000000000000000 RCX: ffff8880275c5a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90004897710 R08: ffffffff8174175e R09: 1ffffffff2859b1a
R10: dffffc0000000000 R11: fffffbfff2859b1b R12: dffffc0000000000
R13: 1ffff92000912ec4 R14: ffffffff817415c0 R15: ffffc900048976a0
 _printk+0xd5/0x120 kernel/printk/printk.c:2432
 __mlog_printk+0x281/0x2b0 fs/ocfs2/cluster/masklog.c:77
 ocfs2_release_dquot+0x8a2/0xc40 fs/ocfs2/quota_global.c:765
 quota_release_workfn+0x3a1/0x650 fs/quota/dquot.c:839
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 3.031 msecs


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

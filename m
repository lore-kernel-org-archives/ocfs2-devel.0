Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8B332E134
	for <ocfs2-devel@lists.linux.dev>; Sat,  9 May 2026 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778316382; cv=none; b=ttDn2mpdW7B3pUtJ7DcNTUqR3AtUk8oalym2p9UPQLDsDg6tYwlTE69a5m3cKWD7BCi25lIONBt9JRSb0CvCsmp5RNXD8PtECmiBuVSzLWH5Ao8K+sVXScjH7XiUK0ARmJ5W0qLD4NbkyJvdsaG1EAkObDeGugjbeShgXawNKFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778316382; c=relaxed/simple;
	bh=iueFzQ0Jy/wR1BNKHe5OXlG3FBdLFlkx5c2xnQcYCNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RVDZhVaI3w36oMVRxCgkQHMD8WrmHScGhxlpJFqXkqprUGm+xh7VKPMboxbFgpGKJfubjWkYX8KXRg8vHH2krr7+ZzrpWrViN9pqy8sKtWmQFRRbdYEcq78kFlRaL5w/XgV6DS+jNiR1jwu/UuF936kjvW/F13AdV6VsvuESOPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass smtp.mailfrom=mails.ucas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.ucas.ac.cn
Received: from fric.. (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowACnUW1L9P5pzhSxDw--.13714S2;
	Sat, 09 May 2026 16:46:03 +0800 (CST)
From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
To: joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	jlbec@evilplan.org,
	kurt.hackel@oracle.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	xujiakai24@mails.ucas.ac.cn
Subject: Re: [PATCH] ocfs2: fix use-after-free in ocfs2_inode_lock_full_nested during unmount
Date: Sat,  9 May 2026 08:46:03 +0000
Message-Id: <20260509084603.3255620-1-xujiakai24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <af0ae50e-1bcf-40cb-820f-aff07af156a5@linux.alibaba.com>
References: <af0ae50e-1bcf-40cb-820f-aff07af156a5@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACnUW1L9P5pzhSxDw--.13714S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKr45uF17GFW7tr17tw1fJFb_yoW7ZrWkpr
	yjgrsrGF48WF18AryUAry5Ar47Jr4UC3WUJrWxGrn5AFyYk3WDXr1ktrWxtr1Dtrs0v347
	trnxXws7KrnrAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
	YxC7MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjpBT5UUUUU==
X-CM-SenderInfo: 50xmxthndljko6pdxz3voxutnvoduhdfq/

> What is the operation?
> We expect all operations cannot access filesystem during filesystem shutdown.

Here is the full crash report produced by the fuzzer:

BUG: unable to handle page fault for address: ffffffff1315afd0
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 6e6a067 P4D 6e6b067 PUD 0 
Oops: Oops: 0002 [#1] SMP NOPTI
CPU: 0 UID: 0 PID: 12119 Comm: syz.2.132 Not tainted 6.18.5 #1 PREEMPT(full) 
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:__pv_queued_spin_lock_slowpath+0x109/0x430 home/zzzrrll/tmp/linux/kernel/locking/qspinlock.c:288
Code: 9a 00 00 00 0f b7 c8 81 e1 fc ff 00 00 83 e0 03 48 c1 e0 05 4c 8d a8 00 c4 6b 89 48 c7 c2 f8 ff ff ff 48 8b ac 4a 90 0d ab 86 <48> 89 9c 05 00 c4 6b 89 b8 00 80 00 00 45 31 f6 eb 23 41 80 7c 2d
RSP: 0018:ffa000000da9bcc0 EFLAGS: 00010216
RAX: 0000000000000060 RBX: ff1100007da2c400 RCX: 0000000000008584
RDX: fffffffffffffff8 RSI: 0000000085873528 RDI: 0000000000040000
RBP: ffffffff89a9eb70 R08: ff1100007da2c414 R09: 0000000000000000
R10: 0000000000000002 R11: ffffffff823c6ad0 R12: 0000000000000000
R13: ffffffff896bc460 R14: ff110000f4370000 R15: ff1100007ba096c8
FS:  00007fb3ffc0a640(0000) GS:ff110000f4370000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff1315afd0 CR3: 000000003f598000 CR4: 0000000000751ef0
PKRU: 80000000
Call Trace:
 <TASK>
 pv_queued_spin_lock_slowpath home/zzzrrll/tmp/linux/include/asm-generic/qspinlock.h:111 [inline]
 queued_spin_lock_slowpath home/zzzrrll/tmp/linux/arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock home/zzzrrll/tmp/linux/include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock home/zzzrrll/tmp/linux/include/linux/spinlock.h:187 [inline]
 __raw_spin_lock home/zzzrrll/tmp/linux/include/linux/spinlock_api_smp.h:134 [inline]
 _raw_spin_lock+0x31/0x40 home/zzzrrll/tmp/linux/kernel/locking/spinlock.c:154
 spin_lock home/zzzrrll/tmp/linux/include/linux/spinlock.h:351 [inline]
 ocfs2_is_hard_readonly home/zzzrrll/tmp/linux/fs/ocfs2/ocfs2.h:665 [inline]
 ocfs2_inode_lock_full_nested+0x5c/0xca0 home/zzzrrll/tmp/linux/fs/ocfs2/dlmglue.c:2446
 ocfs2_inode_lock_tracker+0xd8/0x400 home/zzzrrll/tmp/linux/fs/ocfs2/dlmglue.c:2691
 ocfs2_permission+0x75/0x130 home/zzzrrll/tmp/linux/fs/ocfs2/file.c:1349
 do_inode_permission home/zzzrrll/tmp/linux/fs/namei.c:526 [inline]
 inode_permission+0x1b4/0x2d0 home/zzzrrll/tmp/linux/fs/namei.c:593
 path_permission home/zzzrrll/tmp/linux/include/linux/fs.h:3086 [inline]
 inotify_find_inode home/zzzrrll/tmp/linux/fs/notify/inotify/inotify_user.c:381 [inline]
 __do_sys_inotify_add_watch home/zzzrrll/tmp/linux/fs/notify/inotify/inotify_user.c:771 [inline]
 __se_sys_inotify_add_watch+0x146/0x650 home/zzzrrll/tmp/linux/fs/notify/inotify/inotify_user.c:729
 do_syscall_x64 home/zzzrrll/tmp/linux/arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc6/0xfa0 home/zzzrrll/tmp/linux/arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb3fedae16d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb3ffc09f98 EFLAGS: 00000246 ORIG_RAX: 00000000000000fe
RAX: ffffffffffffffda RBX: 00007fb3feff5fa0 RCX: 00007fb3fedae16d
RDX: 0000000004000000 RSI: 0000200000000080 RDI: 0000000000000004
RBP: 00007fb3fee480f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb3feff6038 R14: 00007fb3feff5fa0 R15: 00007fb3ffbea000
 </TASK>
Modules linked in:
CR2: ffffffff1315afd0
---[ end trace 0000000000000000 ]---
RIP: 0010:__pv_queued_spin_lock_slowpath+0x109/0x430 home/zzzrrll/tmp/linux/kernel/locking/qspinlock.c:288
Code: 9a 00 00 00 0f b7 c8 81 e1 fc ff 00 00 83 e0 03 48 c1 e0 05 4c 8d a8 00 c4 6b 89 48 c7 c2 f8 ff ff ff 48 8b ac 4a 90 0d ab 86 <48> 89 9c 05 00 c4 6b 89 b8 00 80 00 00 45 31 f6 eb 23 41 80 7c 2d
RSP: 0018:ffa000000da9bcc0 EFLAGS: 00010216
RAX: 0000000000000060 RBX: ff1100007da2c400 RCX: 0000000000008584
RDX: fffffffffffffff8 RSI: 0000000085873528 RDI: 0000000000040000
RBP: ffffffff89a9eb70 R08: ff1100007da2c414 R09: 0000000000000000
R10: 0000000000000002 R11: ffffffff823c6ad0 R12: 0000000000000000
R13: ffffffff896bc460 R14: ff110000f4370000 R15: ff1100007ba096c8
FS:  00007fb3ffc0a640(0000) GS:ff110000f4370000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff1315afd0 CR3: 000000003f598000 CR4: 0000000000751ef0
PKRU: 80000000
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	00 0f                	add    %cl,(%rdi)
   4:	b7 c8                	mov    $0xc8,%bh
   6:	81 e1 fc ff 00 00    	and    $0xfffc,%ecx
   c:	83 e0 03             	and    $0x3,%eax
   f:	48 c1 e0 05          	shl    $0x5,%rax
  13:	4c 8d a8 00 c4 6b 89 	lea    -0x76943c00(%rax),%r13
  1a:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
  21:	48 8b ac 4a 90 0d ab 	mov    -0x7954f270(%rdx,%rcx,2),%rbp
  28:	86
* 29:	48 89 9c 05 00 c4 6b 	mov    %rbx,-0x76943c00(%rbp,%rax,1) <-- trapping instruction
  30:	89
  31:	b8 00 80 00 00       	mov    $0x8000,%eax
  36:	45 31 f6             	xor    %r14d,%r14d
  39:	eb 23                	jmp    0x5e
  3b:	41                   	rex.B
  3c:	80                   	.byte 0x80
  3d:	7c 2d                	jl     0x6c

Jiakai


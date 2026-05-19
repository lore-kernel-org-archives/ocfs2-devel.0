Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261EF2E2DDD
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 01:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779154746; cv=none; b=Z6nC2zuHKL9k1uMHeRPU1ovW0cgJNBerNzaCoaxsWYR2xW9iwMfKs5gkElZkgA2waSMN8l5ztdq8v2BxUGq+oJ8P1BeGIRK6uX0gjjyI4tqm0P16t+1v9snN67Kc7W9pdZyFmOneVhd6RnT+C7H0S4HC4DAvWcct7E/azOXMxS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779154746; c=relaxed/simple;
	bh=6jnondp19TSNklX5II9XmZPLOFFHyr1T17f8WqKrDNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gyt+zJi80RNPAsazYlxx360SjN0EHtGSjq2QSdWuRYhKRy0jcKpUzlFHU8bCOIYYrQ5trsryRD1ngDqAiK80mtnjEFkWsX6p5+EeDj8HK5tt5gfHfiqj0O58HdeNuAIZWw9KPFsJbjxRRe88FhnMuTXM1Ge9u/rq/IPhJvvApbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass smtp.mailfrom=mails.ucas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.ucas.ac.cn
Received: from fric.. (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABXPOMzvwtqyjV5EQ--.10885S2;
	Tue, 19 May 2026 09:38:59 +0800 (CST)
From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
To: xujiakai24@mails.ucas.ac.cn
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH] ocfs2: fix NULL deref in ocfs2_wait_for_recovery after recovery_exit
Date: Tue, 19 May 2026 01:38:59 +0000
Message-Id: <20260519013859.1111967-1-xujiakai24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260519013629.1105967-1-xujiakai24@mails.ucas.ac.cn>
References: <20260519013629.1105967-1-xujiakai24@mails.ucas.ac.cn>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABXPOMzvwtqyjV5EQ--.10885S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr13GF17tryDAF1rKr18AFb_yoW7Jr4Upr
	yjgr4DCF48XF18AF1UAry5Jr48uF47A3WUJwsrAr1rAF1jk3WDJr1DtrW8tFn8Jr15Zry7
	twnxJws5tw1DAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr
	0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUhNVkUUUUU=
X-CM-SenderInfo: 50xmxthndljko6pdxz3voxutnvoduhdfq/

This was found by fuzzing. Here is the report:

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 28fdd067 P4D 51bb2067 PUD 0 
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 0 UID: 0 PID: 216737 Comm: syz.2.26512 Not tainted 6.18.5 #1 PREEMPT(full) 
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:ocfs2_recovery_completed home/zzzrrll/tmp/linux/fs/ocfs2/journal.c:1234 [inline]
RIP: 0010:ocfs2_wait_for_recovery+0x45/0x180 home/zzzrrll/tmp/linux/fs/ocfs2/journal.c:1242
Code: 07 65 49 8b 07 48 89 44 24 28 e8 96 23 28 ff 2e 2e 2e 31 c0 49 8b ae 38 01 00 00 49 8d 9e c8 00 00 00 48 89 df e8 cb 45 41 03 <8b> 6d 00 31 ff 89 ee e8 af 27 28 ff 48 89 df e8 37 47 41 03 85 ed
RSP: 0018:ffa000000e1bbb58 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ff1100002ac9a4c8 RCX: 0000000000000001
RDX: ffa000001873b000 RSI: 0000000000000000 RDI: ff1100002ac9a4c8
RBP: 0000000000000000 R08: ffffffff823b5a33 R09: ffa000000e1bbd70
R10: 0000000000000002 R11: ffffffff823c6940 R12: 0000000000000000
R13: ff1100002ac9a400 R14: ff1100002ac9a400 R15: ffffffff896a4020
FS:  00007f74f0df8640(0000) GS:ff110000f4370000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005177e000 CR4: 0000000000751ef0
PKRU: 80000000
Call Trace:
 <TASK>
 ocfs2_inode_lock_full_nested+0xec/0xca0 home/zzzrrll/tmp/linux/fs/ocfs2/dlmglue.c:2457
 ocfs2_inode_revalidate+0x90/0x300 home/zzzrrll/tmp/linux/fs/ocfs2/inode.c:1352
 ocfs2_getattr+0x49/0x180 home/zzzrrll/tmp/linux/fs/ocfs2/file.c:1316
 vfs_getattr_nosec+0x120/0x1b0 home/zzzrrll/tmp/linux/fs/stat.c:213
 vfs_getattr home/zzzrrll/tmp/linux/fs/stat.c:262 [inline]
 vfs_statx_path home/zzzrrll/tmp/linux/fs/stat.c:299 [inline]
 vfs_statx+0x116/0x240 home/zzzrrll/tmp/linux/fs/stat.c:356
 vfs_fstatat home/zzzrrll/tmp/linux/fs/stat.c:375 [inline]
 vfs_stat home/zzzrrll/tmp/linux/include/linux/fs.h:3593 [inline]
 __do_sys_newstat home/zzzrrll/tmp/linux/fs/stat.c:515 [inline]
 __se_sys_newstat+0x6a/0x240 home/zzzrrll/tmp/linux/fs/stat.c:509
 do_syscall_x64 home/zzzrrll/tmp/linux/arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xc6/0xfa0 home/zzzrrll/tmp/linux/arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f74effae16d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f74f0df7f98 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 00007f74f01f5fa0 RCX: 00007f74effae16d
RDX: 0000000000000000 RSI: 0000200000002200 RDI: 00002000000021c0
RBP: 00007f74f00480f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f74f01f6038 R14: 00007f74f01f5fa0 R15: 00007f74f0dd8000
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_recovery_completed home/zzzrrll/tmp/linux/fs/ocfs2/journal.c:1234 [inline]
RIP: 0010:ocfs2_wait_for_recovery+0x45/0x180 home/zzzrrll/tmp/linux/fs/ocfs2/journal.c:1242
Code: 07 65 49 8b 07 48 89 44 24 28 e8 96 23 28 ff 2e 2e 2e 31 c0 49 8b ae 38 01 00 00 49 8d 9e c8 00 00 00 48 89 df e8 cb 45 41 03 <8b> 6d 00 31 ff 89 ee e8 af 27 28 ff 48 89 df e8 37 47 41 03 85 ed
RSP: 0018:ffa000000e1bbb58 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ff1100002ac9a4c8 RCX: 0000000000000001
RDX: ffa000001873b000 RSI: 0000000000000000 RDI: ff1100002ac9a4c8
RBP: 0000000000000000 R08: ffffffff823b5a33 R09: ffa000000e1bbd70
R10: 0000000000000002 R11: ffffffff823c6940 R12: 0000000000000000
R13: ff1100002ac9a400 R14: ff1100002ac9a400 R15: ffffffff896a4020
FS:  00007f74f0df8640(0000) GS:ff110000f4370000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005177e000 CR4: 0000000000751ef0
PKRU: 80000000
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	65 49 8b 07          	mov    %gs:(%r15),%rax
   4:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
   9:	e8 96 23 28 ff       	call   0xff2823a4
   e:	2e 2e 2e 31 c0       	cs cs cs xor %eax,%eax
  13:	49 8b ae 38 01 00 00 	mov    0x138(%r14),%rbp
  1a:	49 8d 9e c8 00 00 00 	lea    0xc8(%r14),%rbx
  21:	48 89 df             	mov    %rbx,%rdi
  24:	e8 cb 45 41 03       	call   0x34145f4
* 29:	8b 6d 00             	mov    0x0(%rbp),%ebp <-- trapping instruction
  2c:	31 ff                	xor    %edi,%edi
  2e:	89 ee                	mov    %ebp,%esi
  30:	e8 af 27 28 ff       	call   0xff2827e4
  35:	48 89 df             	mov    %rbx,%rdi
  38:	e8 37 47 41 03       	call   0x3414774
  3d:	85 ed                	test   %ebp,%ebp


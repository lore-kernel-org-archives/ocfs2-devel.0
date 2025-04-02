Received: from ksmg02.maxima.ru (ksmg02.maxima.ru [81.200.124.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BEE232386
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Apr 2025 06:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743577036; cv=none; b=aAQq4r1pLE7zSIf0AOpTDPKf0kuI4OYeTU1r94cn8n/Kj04ls1IPvB2j+FQtRya4L6KizVj13Q1Fx5JksxrrMdd7ZdnIGOzq3IeMsCmIQKv6btOOeJ+IZlbAvTQttdOZks86FaZ84lEKnHJSRSPloO9nGNvQSDMJQWMcf6vITv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743577036; c=relaxed/simple;
	bh=Nlx7yleWhdsq0o5oxSbApN2URkCpdx6fdnWZkqCTaA4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wn2qKA03ACsMzVp/DWo//jJhF1sG956ZX3bQZOzNvbihCAtVoWErwoVYetdqM/gdRY6vT05VPUpaXZsTFG7u29YwBU7DBuFEP+q4gN00RMaifDXUVMQB61TGAMueU/z46b6aEiAQeqUTOgji/rANPT0X1HUfPVDMNenTEbDwgAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=mfrzpAud; arc=none smtp.client-ip=81.200.124.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="mfrzpAud"
Received: from ksmg02.maxima.ru (localhost [127.0.0.1])
	by ksmg02.maxima.ru (Postfix) with ESMTP id 362F41E0009;
	Wed,  2 Apr 2025 09:57:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg02.maxima.ru 362F41E0009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1743577032; bh=GZplQYKq4Ek0jQUSSrhTx9i5W5X6I3hWOHDLuXtV9GQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=mfrzpAudbq3p7Tw3JgTQ37nh6adsStCzO3e+f/1OX79eUW5uSdm5Fb1kr3RAd+tuY
	 NWfqbMaOfBTo7Mi1PG8xTtp6rdC/ZBkdOlMeNO9JaRWgdJwmxjAknZHX1qQ8Cwz4dC
	 H6f0wHxKUNg4iGBSD8uE8aHqUT/U4+4F+pEJFRN9ys1zPs6IsJVwWR41tM+kpTYg+U
	 Xk6/Q8NWP+qYz6hPQFv9RHJKl7mhAGqjeuFvpntDZ5KSwU0VlIo/xVPPDbI44S3IrO
	 SQiVJlJzwJkRUqA7en+adDmYf8kpHAdRIcGtkGR8F5JVYmKzu2rZcvugC77QFQMCXK
	 n4q/yDuOu+gkQ==
Received: from ksmg02.maxima.ru (autodiscover.maxima.ru [81.200.124.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (verified OK))
	by ksmg02.maxima.ru (Postfix) with ESMTPS;
	Wed,  2 Apr 2025 09:57:12 +0300 (MSK)
Received: from deb16-01-masimov-t-build.mti-lab.com (172.25.20.25) by
 mmail-p-exch02.mt.ru (81.200.124.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 2 Apr 2025 09:57:10 +0300
From: Murad Masimov <m.masimov@mt-integration.ru>
To: Mark Fasheh <mark@fasheh.com>
CC: Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>, <ocfs2-devel@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>, Murad Masimov
	<m.masimov@mt-integration.ru>,
	<syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com>
Subject: [PATCH 2/2] ocfs2: Fix deadlock in ocfs2_finish_quota_recovery
Date: Wed, 2 Apr 2025 09:56:28 +0300
Message-ID: <20250402065628.706359-3-m.masimov@mt-integration.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250402065628.706359-1-m.masimov@mt-integration.ru>
References: <20250402065628.706359-1-m.masimov@mt-integration.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mmail-p-exch01.mt.ru (81.200.124.61) To
 mmail-p-exch02.mt.ru (81.200.124.62)
X-KSMG-AntiPhishing: NotDetected, bases: 2025/04/02 05:33:00
X-KSMG-AntiSpam-Auth: dmarc=none header.from=mt-integration.ru;spf=none smtp.mailfrom=mt-integration.ru;dkim=none
X-KSMG-AntiSpam-Envelope-From: m.masimov@mt-integration.ru
X-KSMG-AntiSpam-Info: LuaCore: 53 0.3.53 da91f386ac5d59a1df8d7a7d55ad5b472b5df140, {rep_avail}, {Tracking_phishing_log_reg_50_60}, {Tracking_one_url}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, mt-integration.ru:7.1.1;81.200.124.62:7.1.2;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;ksmg02.maxima.ru:7.1.1;syzkaller.appspot.com:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 81.200.124.62
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 192297 [Apr 02 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/04/02 03:33:00 #27848807
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2025/04/02 05:33:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

When filesystem is unmounted all pending recovery work is processed. This
may lead to a deadlock in ocfs2_finish_quota_recovery() as it locks the
s_umount semaphore while it is already exclusively locked in
deactivate_super().

Use down_read_trylock() instead and return if it fails, since that possibly
means that unmount may be in progress so it is not possible to finish quota
recovery. According to the description of ocfs2_complete_recovery(), which
is the caller of ocfs2_finish_quota_recovery(), by the point this job is
started the node can already be considered recovered. There is also no
error handling in ocfs2_complete_recovery() which indicates that fail is
not critical in this context.

The following warning has been reported by Syzkaller:

================================================================
WARNING: possible circular locking dependency detected
6.14.0-rc6-syzkaller-00022-gb7f94fcf5546 #0 Not tainted
------------------------------------------------------
kworker/u4:10/1087 is trying to acquire lock:
ffff88803c49e0e0 (&type->s_umount_key#42){++++}-{4:4}, at: ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603

but task is already holding lock:
ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       process_one_work kernel/workqueue.c:3214 [inline]
       process_scheduled_works+0x9e4/0x18e0 kernel/workqueue.c:3319
       worker_thread+0x870/0xd30 kernel/workqueue.c:3400
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #1 ((wq_completion)ocfs2_wq){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       touch_wq_lockdep_map+0xc7/0x170 kernel/workqueue.c:3907
       __flush_workqueue+0x14a/0x1280 kernel/workqueue.c:3949
       ocfs2_shutdown_local_alloc+0x109/0xa90 fs/ocfs2/localalloc.c:380
       ocfs2_dismount_volume+0x202/0x910 fs/ocfs2/super.c:1822
       generic_shutdown_super+0x139/0x2d0 fs/super.c:642
       kill_block_super+0x44/0x90 fs/super.c:1710
       deactivate_locked_super+0xc4/0x130 fs/super.c:473
       cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
       task_work_run+0x24f/0x310 kernel/task_work.c:227
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
       do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&type->s_umount_key#42){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
       ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
       process_one_work kernel/workqueue.c:3238 [inline]
       process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
       worker_thread+0x870/0xd30 kernel/workqueue.c:3400
       kthread+0x7a9/0x920 kernel/kthread.c:464
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  &type->s_umount_key#42 --> (wq_completion)ocfs2_wq --> (work_completion)(&journal->j_recovery_work)

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&journal->j_recovery_work));
                               lock((wq_completion)ocfs2_wq);
                               lock((work_completion)(&journal->j_recovery_work));
  rlock(&type->s_umount_key#42);

 *** DEADLOCK ***

2 locks held by kworker/u4:10/1087:
 #0: ffff8880403eb148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
 #0: ffff8880403eb148 ((wq_completion)ocfs2_wq){+.+.}-{0:0}, at: process_scheduled_works+0x98b/0x18e0 kernel/workqueue.c:3319
 #1: ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #1: ffffc900026ffc60 ((work_completion)(&journal->j_recovery_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319

stack backtrace:
CPU: 0 UID: 0 PID: 1087 Comm: kworker/u4:10 Not tainted 6.14.0-rc6-syzkaller-00022-gb7f94fcf5546 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: ocfs2_wq ocfs2_complete_recovery
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2076
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3906
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
 ocfs2_finish_quota_recovery+0x15c/0x22a0 fs/ocfs2/quota_local.c:603
 ocfs2_complete_recovery+0x17c1/0x25c0 fs/ocfs2/journal.c:1357
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd30 kernel/workqueue.c:3400
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
================================================================

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
Reported-by: syzbot+f59a1ae7b7227c859b8f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f59a1ae7b7227c859b8f
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
---
 fs/ocfs2/quota_local.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index e60383d6ecc1..d3304bb03163 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -600,7 +600,16 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
 	       "slot %u\n", osb->dev_str, slot_num);

-	down_read(&sb->s_umount);
+	/*
+	 * We have to be careful here not to deadlock on s_umount as umount
+	 * disabling quotas may be in progress and it waits for this work to
+	 * complete. If trylock fails, we have to skip this step.
+	 */
+	if (!down_read_trylock(&sb->s_umount)) {
+		status = -ENOENT;
+		goto out;
+	}
+
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
@@ -608,7 +617,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 		lqinode = ocfs2_get_system_file_inode(osb, ino[type], slot_num);
 		if (!lqinode) {
 			status = -ENOENT;
-			goto out;
+			goto out_up;
 		}
 		status = ocfs2_inode_lock_full(lqinode, NULL, 1,
 						       OCFS2_META_LOCK_NOQUEUE);
@@ -676,8 +685,9 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
 		if (status < 0)
 			break;
 	}
-out:
+out_up:
 	up_read(&sb->s_umount);
+out:
 	ocfs2_free_quota_recovery(rec);
 	return status;
 }
--
2.39.2


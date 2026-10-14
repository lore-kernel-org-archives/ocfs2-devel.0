Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE72040B364
	for <ocfs2-devel@lists.linux.dev>; Wed, 14 Oct 2026 03:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949597; cv=none; b=deZshGPMfkuGp0yX4dTTbMv8IpGVh72ttamrgvBMJT0kKB7+fK5Q6lnGDinJTTlMaCvjGDflQeOjV+ShQnkppxzZihifgj4yvlWmQKJkGZhQfxadq0tnQ2II9z6lxMx9JlE2X/TJyvNZ7QFCJuPwYlITs/PNpKKQ5bS6hd3U7yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949597; c=relaxed/simple;
	bh=2nQGm0SV0Z6NzDcRAYWzHyPW7ZSNwX8KBK/mssNbLlw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DY0PWdpB9sIIRJtJfrrOr3oNjhiOG6IVrl/C3df3gNjakj3nKdS6CZjBXhRZ9oW6rjvj2cNIORo6rBraNwiit4GEDc7ls1ln5QNxAetP/JTd4DSJpfBysYne2NIdIdwUCrWDLZ9WGdqAb+V77zYT/c6HNvo9NHAWz+8h1jHwD8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZscJedG8; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZscJedG8"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ab4178ee33so1975305a91.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791949595; x=1792554395; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OMsUnlH498VEzFDwKMOMwmbF5NXX7koG+hTNIxSkTzI=;
        b=ZscJedG8P+SM/7W8my2qzelARQTQqVbTmOnIxBqQv6iRyJzHCa72l8TCsQeWMKTgal
         EzGyUu9m0k7Qb+ZRQNdWqe35IwWWU9/XHFU7kOcy+XLc8oEjGgegcN1KdhTbAy0WyW41
         nXxQBD5NmLdRPSoaRAF7YQa3TR0u7raZC1p6M3EgIUS8b+6JJBs4XkiJFgEkbHX+mksm
         I3Bh4sCG+DECYxDBSx5XccgD2e1JEschtd+GUmTd9a/NTKXi4F0OGnAyqKgFUIF2rRqI
         5+jRUPSh5C0Xstu9teMrKW3ZQgUlVmPqy2malrCRh97A2cyIHi0B+wRcZXtxMaLazFAa
         eA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791949595; x=1792554395;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OMsUnlH498VEzFDwKMOMwmbF5NXX7koG+hTNIxSkTzI=;
        b=MVj5JOPSQscJULGNV4erP6X+xV+yn1bW7/mdRM9+L+R6ZN8zOB4zkh73MjL3amlkGG
         04fsVxVbZcj3vZqeVftiCWbq/+4pSL5IMMRUjMzBNeUhw99htyK3TBbJMQZyXRG5yBsC
         KF+erv/clr775Qyys8dm1R4fZv3kk3PcmmQb+Tf2P2OC6NLGOnnQDExb1YEOULQZV4nL
         4jQ7Rw+0l2bkZzW2KeVnd9EnHfVkQblJRfnB0qzkN43bfZOxizROjOehXKdVDYHJ/ogS
         YTpmOGygg2aC6neCTVkQqNOXvUbZEwf75ZFJKBTCffqyXkt8CPhkpbq9pe2Uwtj2AmXv
         qIdA==
X-Gm-Message-State: AFq9FYLU5VlCs+oJiLdQFs8bdIgrTCvG7wUrF8tiqsgBn/fk/nacFhb9
	UmUnnn2BQBkJ8KPT2erlogJMNDo3JHVaEjMybquqqdznyMMnt3fRfNuO
X-Gm-Gg: AYBFou3VGu6Fu/pf0/EbD1IWESA/AHfwDxPvavfjPo2oMh3Xq7IOqwOji7nRkRCxg6z
	18r5OymH+zHNWgPCH88QW1IGrcr/BIy+PSfZIgk1DLKEoSG/pXa+feje96q8i8fNuEdob2JoDQd
	nePNK5Cl/c7o/Ts5Ay4UrgG9AXI0an+Wtt8bDUAQu6cs6hqSp+TSwHx55b74G9D7UfMmCwVd3lp
	jMclwYkBtHVGka1rh4aLAw/Mo65aRAGrn6FMXR2tTLFrIstMVMVlKtSGVVfwmM2UInhsUCEsE+6
	4vv98jIpKqBgCyM3NIlh6wY+x7lKL8HpMS5vH4jFVuHnHpF4+RoPKTUd24YSbIEvyXtq2NNNl/a
	0u7f+2xFTkJ+026IuxSM53D0+/oXko7NBb9oV7GQNFgFQT01SR4ky89vpcdPwe/Vd1gd9aHy45j
	idEZqi7GaZSm0K9/HXpFlAn9sNfKYnL8os7Yg4spwMSswYf5j++Z5/P5mi/jXBnNx88g==
X-Received: by 2002:a17:90b:1a82:b0:39d:f08e:e6e7 with SMTP id 98e67ed59e1d1-3ab3a35a068mr12230516a91.9.1791949594986;
        Tue, 13 Oct 2026 20:46:34 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f05083fsm2532188a91.1.2026.10.13.20.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 20:46:34 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2: dlmfs: Hold l_lock through the unlock wakeup
Date: Wed, 14 Oct 2026 11:46:27 +0800
Message-Id: <pm-ocfs2-objects-candidate-0055-v4-c1574edc9949e3a22edf@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The user_lock_res embedded in a DLMFS inode must remain alive until the
final unlock AST finishes accessing it. user_unlock_ast() clears
USER_LOCK_BUSY under l_lock, but releases that lock before calling
wake_up() on the embedded l_event. user_dlm_destroy_lock() waits only
for BUSY to clear, so it can return before the callback's last access.

With the native userspace stack, fs/dlm dispatches the unlock AST
asynchronously. Unlinking an attached lock with no remaining local
holders can therefore reach the following order while the parent domain
stays mounted:

  Unlink and inode release          Native unlock AST
  ------------------------          -----------------
  submit final unlock
                                    clear BUSY under l_lock
                                    release l_lock
                                    delay before wake_up()
  observe BUSY clear under l_lock
  return from the destroy wait
  unlink and evict the child
  RCU callback frees the inode
                                    wake_up(&lockres->l_event)

The initial condition check in wait_event() can succeed without joining
the waitqueue. The callback holds no inode reference, and keeping the
parent domain alive avoids disconnect draining the callback workqueue.
The delayed wakeup then accesses freed inode storage, causing a
use-after-free in waitqueue locking.

Keep l_lock held through wake_up(), as ocfs2_unlock_ast() already does.
user_check_wait_flag() takes the same lock, so teardown cannot observe
the cleared BUSY flag until the wakeup has finished. The callback and
its wrappers do not access the lock resource after this final unlock.
The waitqueue lock is released before wait_event() tests BUSY, so
extending the critical section does not invert their lock order.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x3d/0x60
    Read of size 1 at addr ffff888117dc93c0 by task kworker/u17:0/871

    CPU: 2 UID: 0 PID: 871 Comm: kworker/u17:0 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: dlm_callback dlm_callback_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? _raw_spin_lock_irqsave+0x3d/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? _raw_spin_lock_irqsave+0x3d/0x60
     kasan_report+0xe0/0x110
     ? _raw_spin_lock_irqsave+0x3d/0x60
     ? _raw_spin_lock_irqsave+0x3d/0x60
     __kasan_check_byte+0x36/0x50
     lock_acquire+0x113/0x300
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ? pmbd_probe_hit_cookie+0xee/0x1c0
     _raw_spin_lock_irqsave+0x3d/0x60
     ? __wake_up_common_lock+0x27/0xb0
     __wake_up_common_lock+0x27/0xb0
     user_unlock_ast+0x21a/0x490
     ? __pfx_user_unlock_ast+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? process_one_work+0x7c8/0x1b40
     fsdlm_lock_ast_wrapper+0xf2/0x130
     dlm_do_callback+0x2e9/0x6c0
     ? __pfx_fsdlm_lock_ast_wrapper+0x10/0x10
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>

    Allocated by task 492:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_slab_alloc+0x89/0x90
     kmem_cache_alloc_lru_noprof+0x205/0x5c0
     dlmfs_alloc_inode+0x2a/0x50
     alloc_inode+0x69/0x230
     new_inode+0x23/0x1a0
     dlmfs_get_inode+0x47/0x2d0
     dlmfs_create+0x18f/0x2f0
     lookup_open+0x88f/0x13e0
     path_openat+0x95e/0x2020
     do_file_open+0x21e/0x470
     do_sys_openat2+0xf4/0x1b0
     __x64_sys_openat+0x136/0x1e0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    Freed by task 0:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kmem_cache_free+0x242/0x580
     dlmfs_free_inode+0x25/0x60
     i_callback+0x4b/0x80
     rcu_core+0x6be/0x1ed0
     handle_softirqs+0x1fa/0x8d0
     __irq_exit_rcu+0x113/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20

    Last potentially related work creation:
     kasan_save_stack+0x33/0x60
     kasan_record_aux_stack+0xa7/0xc0
     __call_rcu_common.constprop.0+0x80/0x280
     destroy_inode+0x131/0x1b0
     evict+0x543/0x9f0
     iput+0x680/0xb80
     filename_unlinkat+0x36d/0x660
     __x64_sys_unlinkat+0xb0/0x110
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f

    The buggy address belongs to the object at ffff888117dc92c0
     which belongs to the cache dlmfs_inode_cache of size 1464
    The buggy address is located 256 bytes inside of
     freed 1464-byte region [ffff888117dc92c0, ffff888117dc9878)

[Physical-page and shadow-memory dumps omitted.]

Fixes: cbe0e331fdbd ("ocfs2_dlmfs: Enable the use of user cluster stacks.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
diff --git a/fs/ocfs2/dlmfs/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
index 617c92e7b925..60653db7b411 100644
--- a/fs/ocfs2/dlmfs/userdlm.c
+++ b/fs/ocfs2/dlmfs/userdlm.c
@@ -253,9 +253,9 @@ static void user_unlock_ast(struct ocfs2_dlm_lksb *lksb, int status)
 
 	lockres->l_flags &= ~USER_LOCK_BUSY;
 out_noclear:
-	spin_unlock(&lockres->l_lock);
-
+	/* Complete the wakeup before a BUSY waiter can free lockres. */
 	wake_up(&lockres->l_event);
+	spin_unlock(&lockres->l_lock);
 }
 
 /*

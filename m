Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E333E49D7
	for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791905980; cv=none; b=gN/1dCinXrFIwqdntffU7ALyZvg7y6V8aOiw2Z8lLo7+S86vcI87oyihb4L3h2B4C2g7zf/wQGmi8gCA4sbhoQKAwsDHalUraRX8cSbOirJnKUluRXfWbnzqV0uWzkiV+sQ1eS9XIsTT7ZNGSXp0sWK+adS6EfTK4+luQ7qw/mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791905980; c=relaxed/simple;
	bh=EaZC5TOSHAB4O6JP3uYGaf3GKhirtAQdi/vn/xzeiU8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=X8OBEqyhqKrRkoq1jUrUwb7wNcOhhGFXpqERgMmnG/EZGsH3p09VsiQ6Slwg7DPeSr7hy0uKh3dfVwqOdwTId+7w79DmGf811xEnIdTAN0M8eB0F3ia62F2QEDH5R2IYmn6JBEO+JZbOZ4WUuEIUqsW1zyq7RQAfAzB0V4XbkkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRsX+eeM; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRsX+eeM"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e60f9af6e6so211295ad.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 08:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791905979; x=1792510779; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=giD26UiN46ti0dfu+fg4QCzd3bGZ2b4o+lL+TX1mGJg=;
        b=WRsX+eeM2q5wk4v4p6OtSzYJq5lAAWa+tFBbnrjyNm7Rv87qOjyJfqyj3LMhAOP/eP
         rSOf2FWFLt5cnV1KhR/KJAx2eo1PV6UkEGghfG8/ABBJI1IBAGddze6G+lSKw4tFZTQb
         lxBm7c7FUozDF8N2vftudWyBOspVtsEq+6Q1cgeP+jM/cJy867zMn9ft5fh+T2n5Tlcj
         Q2hb9F379ds/+tdjxHqajsI50iw17uJkXiN94QG4fxH3xIy3NNMuachn8AcTQglsgano
         CaTe+Ggr7m4Prd9EkZ6NO9cQoa33s85JavWlEhVK2NYOnzIQrNHa84SihzR6i1StAOsA
         rpGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791905979; x=1792510779;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=giD26UiN46ti0dfu+fg4QCzd3bGZ2b4o+lL+TX1mGJg=;
        b=BOm+ruOpMp8wldehtmws0rgEEbJ0S2jw0wPSnZvMULLOupAYyDOioqEigLcEhsJhRs
         WySwuKoYC4P8cjZw5LvhdgmFt/1QmtsGU/jQ8bq3jq1jKCfsLqZbI0QKfc6hbff5JIuu
         Be6KYOSrBPcVpAtGXiOS3v5mQ12Rh/X0pV5GemdXaG/uBo3hQGrBwUPG8DQncrwy075U
         pqXvGEBqw5nTjIlkJogCxOhdHBN+2ONM71Db/g2CqVdynMkrOuTrEu3UilSx1iO/z9UY
         GZepaMe6BPkowZnxd1C+PQIT0BJr74ZYfoEDXCbTSJiWena5RaZrFF3DxyzFIZRLbyiX
         Zemg==
X-Gm-Message-State: AFq9FYKk0sJWjt2NTp4fLMyU0b7Kmodqix86/QMaQd8hzOV4B0PvxSO+
	Muq1c0gdrcQ6LjkxmDoNd7OW7jxc7eb1dYMjj3nAEHfPA5ftNxhxfouB
X-Gm-Gg: AYBFou2ETxvRegRWRJ7UmuZyAj5oiWfvtWhwvMkSaKZxotkR8vGv/0E3JJUUiZum8JT
	hbaW6K/7gaGDK5vqQL7dVbWB97f5zDPxAx9C36zaO7e1Mpz1OE4+hgwf/JmN9zMy+qv/rN+Zzqs
	92GQmIcfdenpxvijrAWyDAnyQfIE0+W8DP18xtROd1OMQuPJqXN86Hkzh9mdtBuynYz1bA6g/lr
	Z8lBtDH9kf2Wn0+GvPnfdYTlWE0ReXPDO3672lf7mt6apuAf95+z25VBpTfjwiIol+DKJ1xcCaz
	/i2wU6MpgBbkCvUT9qsQf80YndHQNQI2DV8+GDIFyRrf0Y6z1TpLESawEaem0mInvHiJJWMduDD
	OvKt7mJkB/IoUCNpsWkZ7hDPOxhNeS0FMo2Ygg2Tpsf0jHt1hKSxcQatL/mLrck9aYJ5zyGanqx
	fWamfohpUyWVSEqZGRrXXk5GYQLct3RJ0xAUaLKoXEp0RbcZgkJGaakwso5PjIogtyMg==
X-Received: by 2002:a17:902:d4c9:b0:2e8:18ca:5f30 with SMTP id d9443c01a7336-2e842f30fbdmr103619045ad.48.1791905978642;
        Tue, 13 Oct 2026 08:39:38 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e2511sm57923175ad.76.2026.10.13.08.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 08:39:38 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	kees@kernel.org,
	sunil.mushran@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v2] ocfs2/dlm: hold a lock reference across grant AST enqueue
Date: Tue, 13 Oct 2026 23:39:29 +0800
Message-Id: <pm-ocfs2-objects-candidate-0043-v5-1ad07df761ff49638789@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A newly granted remote lock must remain alive until its grant AST is
queued. dlmlock_master() publishes the lock on res->granted with its
base and queue references, then drops res->spinlock before calling
dlm_queue_ast(). The resource's reserved AST count does not retain the
lock itself.

This can fail when a peer dies with an immediately grantable CREATE
buffered on its socket. O2NET's node-down callback flushes receive work
before DLM cleanup, but the flush only waits for work queued on entry.
A data-ready callback that already selected the socket container can
queue new receive work after the flush advances its work color. Socket
shutdown does not discard bytes already queued for TCP receive.

The late receive work and DLM node-down cleanup can interleave as
follows (the lock reference operations shown are before this fix):

  Socket data-ready        Node-down thread         Receive worker
  -----------------        ----------------         --------------
  o2net_data_ready()
    select sc under
    callback read lock
                           o2net_disconnect_node()
                             queue shutdown
                             begin flush; new color
    queue sc_rx_work
    in the new color
    release callback lock
                             shutdown socket
                             flush returns
                                                    read buffered CREATE
                                                    dlmlock_master()
                                                      lock res->spinlock
                                                      add lock to granted
                                                      unlock res->spinlock
                           DLM node-down cleanup
                             lock res->spinlock
                             dlm_free_dead_locks()
                               unlink lock
                               put queue/base refs
                               free lock
                             unlock res->spinlock
                                                    dlm_queue_ast()
                                                      __dlm_queue_ast()
                                                      read lock->lockres
                                                      (use-after-free)

DLM cleanup holds res->spinlock while dlm_free_dead_locks() drops the
queue and base references. The CREATE handler no longer holds that
spinlock when __dlm_queue_ast() reads the lock, before taking its AST
list reference.

Take a temporary lock reference under res->spinlock when a grant AST
will be queued, and drop it after dlm_queue_ast(). This keeps the lock
alive across cleanup until the AST path has taken its own reference,
without reversing the existing AST/resource lock order.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in __dlm_queue_ast+0x8a4/0xc00
    Read of size 8 at addr ffff88810ead5940 by task kworker/u16:3/52

    CPU: 3 UID: 0 PID: 52 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: o2net o2net_rx_until_empty
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? __dlm_queue_ast+0x8a4/0xc00
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? __dlm_queue_ast+0x8a4/0xc00
     kasan_report+0xe0/0x110
     ? __dlm_queue_ast+0x8a4/0xc00
     __dlm_queue_ast+0x8a4/0xc00
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_raw_spin_lock+0x130/0x270
     ? __pfx___dlm_queue_ast+0x10/0x10
     ? __pfx_do_raw_spin_lock+0x10/0x10
     ? _raw_spin_unlock_irqrestore+0x45/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lockdep_hardirqs_on_prepare+0xeb/0x1a0
     dlm_queue_ast+0x46/0x70
     dlmlock_master+0x51f/0xf50
     ? __pfx_dlmlock_master+0x10/0x10
     ? dlm_create_lock_handler+0x2b2/0x870
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     dlm_create_lock_handler+0x35b/0x870
     ? __pfx_dlm_create_lock_handler+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kvm_clock_get_cycles+0x31/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_dlm_create_lock_handler+0x10/0x10
     o2net_rx_until_empty+0x1dae/0x32c0
     ? reacquire_held_locks+0xdd/0x200
     ? __pfx_o2net_rx_until_empty+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
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

    Allocated by task 52:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_slab_alloc+0x89/0x90
     kmem_cache_alloc_noprof+0x20b/0x5c0
     dlm_new_lock+0x39/0x5f0
     dlm_create_lock_handler+0x16e/0x870
     o2net_rx_until_empty+0x1dae/0x32c0
     process_one_work+0x9a8/0x1b40
     worker_thread+0x65c/0xe40
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 603:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kmem_cache_free+0x242/0x580
     dlm_lock_release+0x1df/0x2f0
     dlm_lock_put+0x51/0x80
     __dlm_hb_node_down+0x15be/0x2710
     dlm_hb_node_down_cb+0x6c/0xa0
     o2hb_run_event_list+0x34a/0x500
     o2hb_do_disk_heartbeat+0x1a07/0x2950
     o2hb_thread+0x1ed/0xdc0
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810ead5900
     which belongs to the cache o2dlm_lock of size 184
    The buggy address is located 64 bytes inside of
     freed 184-byte region [ffff88810ead5900, ffff88810ead59b8)

    [Page and shadow memory dumps omitted.]

Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
Changes in v2:
- Illustrate the node-down and grant-AST race with a sequence diagram.
- Use the ocfs2/dlm subsystem prefix in the patch title.
- Add Cc: stable@vger.kernel.org.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0043-v4-24e62761a79be6b84b55@gmail.com

diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 46120eb75d90..660237c0d7cd 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -138,6 +138,8 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
 					  res->lockname.len)) {
 			kick_thread = 1;
 			call_ast = 1;
+			/* Keep the lock alive through AST enqueue. */
+			dlm_lock_get(lock);
 		} else {
 			mlog(0, "%s: returning DLM_NORMAL to "
 			     "node %u for reco lock\n", dlm->name,
@@ -166,10 +168,12 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
 	wake_up(&res->wq);
 
 	/* either queue the ast or release it */
-	if (call_ast)
+	if (call_ast) {
 		dlm_queue_ast(dlm, lock);
-	else
+		dlm_lock_put(lock);
+	} else {
 		dlm_lockres_release_ast(dlm, res);
+	}
 
 	dlm_lockres_calc_usage(dlm, res);
 	if (kick_thread)

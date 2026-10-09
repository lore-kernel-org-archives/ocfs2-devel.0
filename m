Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F15E379C3C
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 08:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791533499; cv=none; b=AuOJKBxCXQgMafC5ml7W2FTxP9fIIfBaTE7qOITv7M4T3j1FsxzEJQbzC+ZobEoxy3zNEZIPTHGnySAfcyZnUl3viJ9pm+FBoVdBnr3ed+qXWRV8r0b17PQf40o2Ab6PLyHwlGzqpWtwuzOxRR6E4TFRLTfprMwxPAxhI+nhuFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791533499; c=relaxed/simple;
	bh=HeDRxBrOSXPmm7ASKJRIpyryU/fNruS/AGxremEwaOY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=fcIvjsqw+VeYJFxBmA7cDh8va82zmVf6aUnnTb9BYciKeGZA4w/9rc5pIknEBRvBLjTBNNiW1bYV1wawG73UQVYu8ejNcsPbsk+Re2CoNPKZlg2B0hLup9ra5kXBprUZ9x9po0eiqHsxFY1865aWfRf2CRjVxEEBOuNsoDzWxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ioEclNmc; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ioEclNmc"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8520161fdb9so3987493b3a.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Oct 2026 01:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791533490; x=1792138290; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jorHnXCyWEhW+lCsEocQ36hL6FicutQ3r2BseWpNOZY=;
        b=ioEclNmc9yr/nzPH7y1yIiWZfHx5h/m52donfkzGgvyXi2vtIaERiYegCdmsp2Xrhz
         7v+CIzaJmGz6WS4n+49DpMgpqgVjRn47M5BfJBoUNOD3e45QwJViPvTmeo8AAms0jIru
         oxXwKaALQHLS82fj6d5v/Zcg90mCul3FZhcInhvhbnR2Q0nztcYJVjsUK5mmfdBvUJlV
         p5Pmt6Jb3g/PAb4gGihbljNzam594ZqeV65QMlIBsr0E3uOsXOMU8hvPC0d6fOFbLkqM
         dfZ344T1tA0nVJubcoNGTm7re7Zbu4BdHTT2GodtFWZv4BuBfrQtfOaAkLkoUNcfzBNa
         QQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791533490; x=1792138290;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jorHnXCyWEhW+lCsEocQ36hL6FicutQ3r2BseWpNOZY=;
        b=rVUoI4cAKBkf++wwf57aKnbgeX6f+vJGBDfHWfjSX4X9VY2Lo8/HOXbCRZATnNYxcY
         /TFI5kzbcQYRL62C1lvI0qY0JLql9LTW8bNBGi4cysXdsYip/1Mjfbc2SuDWlN3ACzp6
         pF/Oe8xd2F3ti9IZMumifv54BcCLN6A7rPYXGYXnveJMAQAihct8W5Efx0veFziATawv
         ZP5GuNya2QJnnMJ4rtVo9rP34VvRQ1T09uvZO0PHubTM28crLHWtTxCpuM/Ca1U3deLO
         SawuXpMr6CJ/Q5XEl+Iu0O34avRMwHjRusybGFks1ChZal4zyq4TYnLJPjJXFgyi25w3
         fzGQ==
X-Gm-Message-State: AFuF++l5OdFC+V4EB08vf1Da8rSOCRLQvaTsQPvedW2peLEzJoPa2I5k
	NBMgsexHT8NTaggrGHtnklixGaXrnwqTS0mxd2evF2CKcgAfKpKbSIbX
X-Gm-Gg: AYBFou1pFG0esHEg7J4imgEm2QSVMldS2UpsKwvy9bk0aK0k9Et2jSb8OErl5x7ryv0
	11JRzqfEkWUQYuRMECxFLpwuP5VC68HsHZNOSUgvNlKT3RAOhpjT6oFu5X7jujJzsb+kW5hEb+r
	1hi0V7DrAfTDDwPqsZNtgWvzr3iIez058LZHrYZQ25Abi41EpszsS/Y98GLuhvc0RAC6k7E/mK2
	1TObDgRGyquXzYwMcfIlcanCj+XLIAtLeUN0/qqk/FjkyyhpRelkgcybs9rJMaNSNSqCVbV5wVu
	IIpGsLI5JdfuClghJ5Fg61pA0qYF9CZTFm/pjHLbI4xO5l+2rFA08gYCXoWMAyJmzbTy1RpHcou
	RxAb1PPjyPKOvig/721q+3swhAcsPMGMr01ii90HpJBBUFHy/Q1fU7y1hyiP/KXdBMz1N0y8FDg
	kbHln1unkfHdjgQGwua56ADG144o96EjzDZL7XbJMaySiZ1LZd+HNLH9A764hw8oDJDw==
X-Received: by 2002:a05:6a21:600f:b0:3dd:85aa:4533 with SMTP id adf61e73a8af0-3e16be72365mr883547637.37.1791533490194;
        Fri, 09 Oct 2026 01:11:30 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e53f8bsm552895a12.24.2026.10.09.01.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:11:29 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	moonafterrain@outlook.com,
	brauner@kernel.org,
	rppt@kernel.org,
	kees@kernel.org,
	julia.lawall@inria.fr,
	kurt.hackel@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2: drain domain handlers before destroying the DLM worker
Date: Fri,  9 Oct 2026 16:11:23 +0800
Message-Id: <pm-ocfs2-objects-candidate-0056-v2-57239c657ac017b50fa1@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The domain workqueue must remain usable until every network handler that
can submit work has finished. dlm_unregister_domain_handlers() removes
handlers from the o2net lookup tree, but an already referenced handler can
still run. Its dlm_grab() reference pins the context, not dlm_worker.

On the final local domain disconnect, a migration receive callback can
have passed dlm_joined() before shutdown changes the domain state, yet
still be preparing its work item when teardown destroys the queue:

  o2net receive worker             Final domain teardown
  --------------------             ---------------------
  Get the handler reference
  dlm_grab(); pass dlm_joined()
                                   Unregister domain handlers
                                   Stop the DLM threads
                                   destroy_workqueue(dlm_worker)
                                   dlm_worker = NULL
  Publish the migration work item
  queue_work(dlm_worker, ...)

The handler lookup reference lets the callback continue after unregister.
The work-list lock does not protect the queue lifetime, and destroying the
queue drains submitted work without waiting for this producer. The late
queue_work() therefore passes NULL to __queue_work() and crashes.

Use o2net_unregister_and_flush_handler_list() at the existing domain
handler unregister point. Removing the handlers prevents new lookups,
and flushing o2net receive work waits for already referenced callbacks
and their post handlers. They can finish submitting while dlm_worker is
still live; the subsequent destroy_workqueue() drains those submissions.
The same unregister helper covers failed registration and join cleanup,
without changing the DLM thread or workqueue teardown order.

KASAN report as below:

    Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
    CPU: 0 UID: 0 PID: 14 Comm: kworker/u8:1 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy)

[Hardware details omitted.]

    Workqueue: o2net o2net_rx_until_empty
    RIP: 0010:__queue_work+0x9b/0x1600

[Instruction and register dump omitted.]

    Call Trace:
     <TASK>
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx___queue_work+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? clear_pending_if_disabled+0x83/0x1c0
     ? __pfx_clear_pending_if_disabled+0x10/0x10
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ? dlm_mig_lockres_handler+0x984/0x1500
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     queue_work_on+0xda/0xf0
     dlm_mig_lockres_handler+0x9d5/0x1500
     ? percpu_rwsem_wake_function+0x10/0x480
     ? __pfx_dlm_mig_lockres_handler+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on+0x18/0x160
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kvm_clock_get_cycles+0x31/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     o2net_rx_until_empty+0x1a55/0x32f0
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

[Empty module list omitted.]

    ---[ end trace 0000000000000000 ]---

Fixes: 3156d2670166 ("ocfs2: move dlm work to a private work queue")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 97bb9400e24bbf6badea1339dd8de1623fe5bac5..b69baf99a4a6e4d5a5c51664625bafa905dc3bf5 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -1708,7 +1708,7 @@ static void dlm_unregister_domain_handlers(struct dlm_ctxt *dlm)
 {
 	o2hb_unregister_callback(dlm->name, &dlm->dlm_hb_up);
 	o2hb_unregister_callback(dlm->name, &dlm->dlm_hb_down);
-	o2net_unregister_handler_list(&dlm->dlm_domain_handlers);
+	o2net_unregister_and_flush_handler_list(&dlm->dlm_domain_handlers);
 }
 
 static int dlm_register_domain_handlers(struct dlm_ctxt *dlm)

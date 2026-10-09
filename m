Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446103C0607
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 10:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540094; cv=none; b=ghxKs2Iizx6Z+RYHON++Ud80xDNEZ45r79xVQUy5QKKA+5W5SliE8VoE+hG4xAJeLhNQVcez18gXp5q/20Wa9MW0laci14pWARCuNQuISW1F7M6AXmysiUi/JYo5/fTrY+DimM4fb9Uy0b2BM9rc8TN+Fcmr7ZjGQPSM5RAz7x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540094; c=relaxed/simple;
	bh=fsQsZ+2NTBEQHO1bSyIeaS0icE1pgKIaijb3ej7DD3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=EbOG+dYt1vVr/5GPxi6ESAtRupuGKqCV2ULZElEgM7b6zbLMh2wZL9okOrxBTN4FsjPPL6RjDj1Rb6oZoX7h6XrWRmDKcOB4W69n7ZzLjZkhtp/EiyEOSIgvfojiuqaMSe6IKJmC5Uzdy+z9SXke2EYUlMJQml5uJbdM2PQyp7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRCCReWv; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRCCReWv"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8899a204034so2302513b3a.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Oct 2026 03:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791540091; x=1792144891; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J2r2j+124EZwxoHjlkMce/YRKhVj0c9JCcBiSTT0WCc=;
        b=BRCCReWvXJa+d08NwrKWFR9FlvHt46ACemY5ctGmM78PyF3ouG1bxprmnkZlcI7xk3
         NBfxZ7FX3+5IkN9jbemPyi2HN9ujcJiUEIXklTYvBAhYZL4fx1E32pHFjbQWRtk+rPh7
         zqBaFnf1YHbps/g05kSbgBpsTdUi9V/wqS0KLr3olFGP3u+B5Mm+sjUZsQya+FUdvxxE
         C31gmLr0lsrsTuHTzSOCjvCuz1fGUF8ye9LYua4lsJHIx8ABU4R+ybnrBoGS5GV/MyiR
         HqFNHgT59m7M9Er5jjDbpkXcxfqYXzGkaZlfu4R1JIRYU7mBjqmdm/Ma8Hgvl+IgMxAt
         XDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791540091; x=1792144891;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J2r2j+124EZwxoHjlkMce/YRKhVj0c9JCcBiSTT0WCc=;
        b=Z4WvBm3fF2kT1/BeUirXvY/HKod1P08yL3BlhVKYTEpZGugdAx1gtAH37G2eMnVOFw
         05IwaJc/UmjJzEzgPhd14Ljm1zwoc60joEpdBPn2FhoapikPP7M/i4RW/RK9/s6wUoo2
         P1wPOBtAmqrHC4td2KZEdvDDUyfUF2pdRxCxV1qYvt2Spi1nxOTy4AL6pTT5555D9CGX
         1fzEH3h+AuzxVnlnE0+cKlhGKyystM4S+/LK20Ucxe+n5bJmRBBK9hE0usbNmTKyxnBK
         +jno3WhRO5KiY+M6cf6S0SWoWTsp1q1Z/Rcv6GxOuErgwkl0UFLO/46KijNxEyoF5/Ki
         zCmg==
X-Gm-Message-State: AFq9FYIhgBG6MPg/2Wr7m8vVfIEB1vabDqtz1PS1/qWLgCFuQ6K04Eqf
	lab0QgZiWSjALyBpr81oy75cMaaupBwjKoBy/COMOGvYhdiSdEqq26dp
X-Gm-Gg: AYBFou0KUM3Mxe42/uxIxsB0zCAzq5BEQfT2zmTjv6xi/REIjvP5MBAl19+5X3aHjcW
	H2MbgF7PgfaSoOeyzL2MQrFXotqzrDIuzF8N40P7QjI878bkska4SQer1mumoHR1yGKEakqeDj4
	OGnt4MwHjvB5Nok9JuRpe8LVR3vGk3LXFhIT7wMIvP/NlaiGu0zXAK5cIClY2UnrSOf5oLlx9Wm
	EQpe8/XlC8Rzjx8uPfauKlsv4yC4/BihJdv9ukpllaBpyI4LEiZClzHjEiOTCPHbrOTFyL0/8bP
	ZhJh9BDLxil4IsIBIOxavg6MmbfgxmwXDhy07+yZ5rdDxIJbR4D7aldOD/r6+j4Fj+x98YBHAzo
	WHhCc4uump91NFpt9oMc3flSDepsk9Lo/+4PrsFzvEGN8RNogsd7It9aedqiwhi4MAjKMr+Qhve
	oRk000eVB3KbZbfadVR9jHvj0EQGipZhNdfpXqpb2ZDLnKogSM0GPK6G3+oVWR6PV8B21A/uEL8
	A2k
X-Received: by 2002:a05:6a00:4195:b0:874:705d:f643 with SMTP id d2e1a72fcca58-897c77da504mr1014452b3a.37.1791540091477;
        Fri, 09 Oct 2026 03:01:31 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c3107373sm657534b3a.9.2026.10.09.03.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 03:01:31 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	kees@kernel.org,
	jack@suse.cz,
	rppt@kernel.org,
	hexlabsecurity@proton.me,
	sunil.mushran@oracle.com,
	akpm@linux-foundation.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2/dlm: Serialize recovery list teardown with debug reads
Date: Fri,  9 Oct 2026 18:01:24 +0800
Message-Id: <pm-ocfs2-objects-candidate-0049-v2-a5d5091b8900dc3f9849@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Recovery participant records must remain alive while debug_state_print()
walks reco.node_data and formats their fields. The formatter holds
dlm->spinlock, but dlm_destroy_recovery_area() detaches the list under
dlm_reco_state_lock and frees the records without taking dlm->spinlock.

When a recovery master finishes recovering a dead node, a concurrent
open of the domain's dlm_state file can reach the participant list after
the master's last dlm->spinlock section. The following ordering is
possible:

    Debugfs open                      Recovery thread
    debug_state_print()
      lock dlm->spinlock
      select participant
                                      dlm_destroy_recovery_area()
                                        lock dlm_reco_state_lock
                                        detach participant list
                                        unlock dlm_reco_state_lock
                                        kfree(participant)
      read node->state/node_num
      unlock dlm->spinlock

The field read or the next list iteration then accesses freed memory.
Debugfs removal protects the domain lifetime, but session completion
leaves the file installed, so it does not drain this open callback.

Take dlm->spinlock around the existing locked list detachment. A debug
reader must now finish before detachment, and later readers see an empty
list. Keep the frees outside both locks. This also covers cleanup after
partial allocation failure in dlm_init_recovery_area().

KASAN report as below:

    BUG: KASAN: slab-use-after-free in debug_state_open+0x1169/0x12d0
    Read of size 4 at addr ffff88810662ef80 by task dlm-state-stres/896

    CPU: 1 UID: 0 PID: 896 Comm: dlm-state-stres Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? debug_state_open+0x1169/0x12d0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? debug_state_open+0x1169/0x12d0
     kasan_report+0xe0/0x110
     ? debug_state_open+0x1169/0x12d0
     debug_state_open+0x1169/0x12d0
     ? __pfx_debug_state_open+0x10/0x10
     full_proxy_open_regular+0x193/0x310
     do_dentry_open+0x595/0x12d0
     ? __pfx_full_proxy_open_regular+0x10/0x10
     vfs_open_consume+0xd1/0x400
     ? srso_alias_return_thunk+0x5/0xfbef5
     path_openat+0x18d0/0x2020
     ? __pfx_path_openat+0x10/0x10
     do_file_open+0x21e/0x470
     ? __pfx_do_file_open+0x10/0x10
     ? _raw_spin_unlock+0x23/0x40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? alloc_fd+0x3a6/0x6b0
     do_sys_openat2+0xf4/0x1b0
     ? __pfx_do_sys_openat2+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __fput+0x5b5/0xa60
     __x64_sys_openat+0x136/0x1e0
     ? __pfx___x64_sys_openat+0x10/0x10
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    [Register dump omitted.]
     </TASK>

    Allocated by task 880:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     dlm_remaster_locks+0x147/0x1d90
     dlm_do_recovery+0xde1/0x1580
     dlm_recovery_thread+0x109/0x300
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 880:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     dlm_destroy_recovery_area+0x285/0x460
     dlm_remaster_locks+0x17c4/0x1d90
     dlm_do_recovery+0xde1/0x1580
     dlm_recovery_thread+0x109/0x300
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff88810662ef80
     which belongs to the cache kmalloc-32 of size 32
    The buggy address is located 0 bytes inside of
     freed 32-byte region [ffff88810662ef80, ffff88810662efa0)

    [Page and memory-state dumps omitted.]

Fixes: 007dce53a29c ("ocfs2/dlm: Dump the dlm state in a debugfs file")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 9d4a2695b9594d1ad8bd60de9cec8ee701355f09..5719c2b88e4292cff38e26b10b29c8a4a0deccda 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -764,9 +764,12 @@ static void dlm_destroy_recovery_area(struct dlm_ctxt *dlm)
 	struct dlm_reco_node_data *ndata, *next;
 	LIST_HEAD(tmplist);
 
+	/* Serialize list detachment with debug_state_print(). */
+	spin_lock(&dlm->spinlock);
 	spin_lock(&dlm_reco_state_lock);
 	list_splice_init(&dlm->reco.node_data, &tmplist);
 	spin_unlock(&dlm_reco_state_lock);
+	spin_unlock(&dlm->spinlock);
 
 	list_for_each_entry_safe(ndata, next, &tmplist, list) {
 		list_del_init(&ndata->list);

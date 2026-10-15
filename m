Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231913B5314
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792080231; cv=none; b=HkcT0niAojx3m91HRtqqn39QNT/9zDMHj7aa/i9o4f8k/+v42j8IUY6BP5v923j/4cIW3Qf9o3ipcT7GBVpPQRU89An1GyUuoSFleyKOF+w4pZeCA61iCy9CQw+oqeN1HO5ltiXkaykw4tMAiLCPH2NFBdL1ZiYnr8WWgd/QrEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792080231; c=relaxed/simple;
	bh=go7u6IBJLBRk40wJNkJnyMxkUOKsGfKDNJNyCKClnZU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=aZWT1zv4N6jVpZIzGrakMZzLyxi4ArPnZ3hHFyL9TU/y917DScu3BN/dGb3qVB9FF4vmyFdIEWWU0w4ue8n2NFCjUflEb6mvp3a6C/lMRQPQ4F8BjGf9F/jvjY3e5R5tKroaD7fpOT3K7RRgN/vltFiu+hZG4EOJ/4p42G+SmdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GU7733mK; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GU7733mK"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e87c66e556so1088285ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 09:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792080210; x=1792685010; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PsDHGrwyCQ98HtyGLf4J6qUbdlCfaJF9N0Ol2bbzSUY=;
        b=GU7733mKk/zIcRvoKtB4DkEixDMV2GpEX9YtjnNZmH/Q95CI7HjCRU9n9MiqkEJkWB
         J1ysDqm//hkNrJ/ztl30hW58htePjJOOEz3SJGum/bfLY1DH3DFjaef6+axlphw7MdHW
         B44ROtEPPCwVfeoZam8x6S45AZAyt2YXXxoSsEdUKTGQEJLk8dwMgknJMSBtI8o+rQeY
         6ndIqZvcYUR/aeqLM1UaohIu1wwNBJvbZJldVgL5sWIxht4euDryslz1O98gUIzVqXBJ
         Q9GmKlD9KjSK1sXXIbWQxyg/pRXaQyEKpgtqYm/KxLw5f9m0lldH1tbxf6Ah+c/4SGFq
         lClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792080210; x=1792685010;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PsDHGrwyCQ98HtyGLf4J6qUbdlCfaJF9N0Ol2bbzSUY=;
        b=jYFjVvgIxShmEYJecIJMdPAYw7t4eEQtSlM3sM+wedvk92LhlirB1yLmO/Slts7cbv
         ufJTSsBS42953asqK+xU77TYJhxc2ZWL+LRF+ylNLEmHwvXy6bikqKrLDC2QFJjBa2el
         eml9OT8/i388Dln96L5JKuZ77H8bojwiAaQFgxgkIS69GYlHCY3MCEpdf3vQKkTG0k5h
         axLiP+RLdNCxF750eioAsJO7kfGGjO58lbV1DxFG9FI8V5I5BCqQOhnZDja3gAN9Aoqa
         i4+hwlhi6HCoTcxoewk7c7ySr4DqPSGTpcq8maB9gg/4+Sqs4M7gCl8ztiAPTFZMgnGe
         LMmA==
X-Gm-Message-State: AFq9FYKmJ1w70U9Y5idxaEgXvtB6hgTMJcF5SS3HqST41dp0MXj2qZH9
	YhJvxBRNi8hI2gIKaWyvWpDNSUxDIYUTdvXz8zRR6hyOtA9d9M0Eq1dC
X-Gm-Gg: AYBFou1LNbWQgc7ypx/Hl+Fsw14OqdcZLeH9RNXMOVo9Vh6qgsxhBtCjtxl2n1W9Q3v
	GC3Wh0OvyIPNo754I7rMbsvlD0HZAhfFMcPE0Nr90ux64mWsmUME1eJkp89Cj79G86My3Apsip9
	ary4G7OS4wM4qWJAjSppJe9rWWQqMkAhFYJxRK43dw0ir4Z/gXyy7ANyPSqcpJpLtG+CImh+vE0
	HOxSfPSd3dto0BYeikIuCIMjnNes192J9ytojov7q7rnk47kRInJpnMGvN9Gd/5Iqed5TbwLEXE
	V14Gd/6mlXPPMbwoCX9FEhThbjQJ2EAI02Tvj/YbFit5ynUv5I4nQL2QDC1nhFDxJ3+Fu1zbnQ/
	P5t1TNB/NoTLtfS5bZ1HM6PGnOvqXPFmAqRst45xxE7l81+Su4XfdF/IOdZJcOFNIAtjjdK6dzf
	bWrSx+XxzoOQON60tAZehtwzBxOUuCy7JXGTEG7OH8AAEnF0U1EE9/KkWK/aWqJgWPZQ==
X-Received: by 2002:a17:903:234e:b0:2e9:4ecb:24a5 with SMTP id d9443c01a7336-2e977140ea9mr3372775ad.2.1792080210118;
        Thu, 15 Oct 2026 09:03:30 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8419fe0a2sm83631725ad.6.2026.10.15.09.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 09:03:27 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	jack@suse.cz,
	akpm@linux-foundation.org,
	srinivas.eeda@oracle.com,
	rgoldwyn@suse.de
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2: Keep the dentry lock inode alive until callbacks drain
Date: Fri, 16 Oct 2026 00:03:20 +0800
Message-Id: <pm-ocfs2-objects-candidate-0012-v5-a0413a339b72c02fc885@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The inode reference held by a DENTRY lock must outlive callbacks on
that lock. ocfs2_drop_dentry_lock() drops dl_inode before marking the
lock freeing and waiting for DLM unlock completion, although the BAST
path still reads dl_inode->i_sb in ocfs2_get_dentry_osb().

An EX request, such as a remote unlink or rename, can make the
downconvert worker delete all matching aliases. If no other inode
reference remains, its post_unlock callback performs the final iput().
The O2CB DLM can deliver another BAST while the request is still
blocked, for example when another holder releases the same resource:

  Downconvert worker                 DLM callback
  ------------------                 ------------
  Remove dentry aliases
  Clear QUEUED; post_unlock()
  ocfs2_drop_dentry_lock()
    iput(dl->dl_inode)
    [inode reclaimed after RCU]
                                     Duplicate BAST
                                     ocfs2_blocking_ast()
                                       ocfs2_get_dentry_osb()
                                         Read freed dl_inode->i_sb
  ocfs2_simple_drop_lockres()

Call ocfs2_simple_drop_lockres() before iput() so the existing inode
reference remains held while queued work and DLM callbacks are drained.
The inode can only be evicted after the DENTRY lock has been unlocked.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in ocfs2_get_dentry_osb+0x155/0x170
    Read of size 8 at addr ffff8881100ff888 by task dlm-5B530197BEF/575

    CPU: 0 UID: 0 PID: 575 Comm: dlm-5B530197BEF Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? ocfs2_get_dentry_osb+0x155/0x170
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? ocfs2_get_dentry_osb+0x155/0x170
     kasan_report+0xe0/0x110
     ? ocfs2_get_dentry_osb+0x155/0x170
     ? __pfx_ocfs2_get_dentry_osb+0x10/0x10
     ? __pfx_o2dlm_blocking_ast_wrapper+0x10/0x10
     ocfs2_get_dentry_osb+0x155/0x170
     ocfs2_blocking_ast+0xd3/0x6d0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __lock_acquire+0x5a3/0x2140
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __mlog_printk+0x212/0x2a0
     ? __pfx_ocfs2_blocking_ast+0x10/0x10
     ? __pfx_o2dlm_blocking_ast_wrapper+0x10/0x10
     dlm_do_local_bast+0x20c/0x300
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_dlm_do_local_bast+0x10/0x10
     ? dlm_thread+0x2e36/0x4480
     dlm_thread+0x32b8/0x4480
     ? __pfx_dlm_thread+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0xc1/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? __pfx_autoremove_wake_function+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? __pfx_dlm_thread+0x10/0x10
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

    Allocated by task 584:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_slab_alloc+0x89/0x90
     kmem_cache_alloc_lru_noprof+0x205/0x5c0
     ocfs2_alloc_inode+0x2b/0x100
     alloc_inode+0x69/0x230
     new_inode+0x23/0x1a0
     ocfs2_get_init_inode+0x84/0x190
     ocfs2_mknod+0x8a3/0x2150
     ocfs2_create+0x14f/0x3c0
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
     ocfs2_dentry_lock_put+0xca/0x230
     ocfs2_process_blocked_lock+0x1fb/0x420
     ocfs2_downconvert_thread+0x327/0x730
     kthread+0x351/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff8881100ff000
     which belongs to the cache ocfs2_inode_cache of size 3400
    The buggy address is located 2184 bytes inside of
     freed 3400-byte region [ffff8881100ff000, ffff8881100ffd48)

    [page and shadow-memory details omitted]

Fixes: 8ed6b23709b3 ("ocfs2: revert iput deferring code in ocfs2_drop_dentry_lock")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e06774fd89d8..e2b560797f17 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -354,8 +354,9 @@ out_attach:
 static void ocfs2_drop_dentry_lock(struct ocfs2_super *osb,
 				   struct ocfs2_dentry_lock *dl)
 {
-	iput(dl->dl_inode);
+	/* Keep the inode alive until DENTRY callbacks have completed. */
 	ocfs2_simple_drop_lockres(osb, &dl->dl_lockres);
+	iput(dl->dl_inode);
 	ocfs2_lock_res_free(&dl->dl_lockres);
 	kfree(dl);
 }

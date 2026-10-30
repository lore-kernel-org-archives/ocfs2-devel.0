Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793337908;
	b=BCXKjx77wS1045shbejCCBE5DncJKxY3vgygIrk/mG/Vtx61odwxFSGc4ck8abFQ2k0F
	 m6qIs2k8LG2s//aWNZ8nCnZFVNUL/njD9mF4ldTnNCWg1C9aOemjBiD9F23ej2Xog74eG
	 qycjtEuocqXJ0Cenqhiu32/h9FGOVoqJ4A2n+RfI6rElMom0uHwqVW4gFAIibQRywtjJ5
	 JlsNwBY8IPmQEvTrwpvrDLG295ZvpxxKyLpLMnGDs0byordjEQ5kPtxCrgCeVHqRE8BZF
	 MpXYBmDHFIEKJ4wLQCyI3E9YSIohFyM14Vl4CvY+scYqIPMrpX7Sk0m1+8dLrBAII0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793337908;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Mck7iiQBTW9TKhdP7RVb/9jfgo9mu8qffyanjI2fNnM=;
	b=CCOQjgJl9jmo2UB+CW68uuYaAtdq4NHW61efQsnV3sjRd4o16y4YoVnVkTbq/iyAN/LH
	 J1FvUY5WxsAK7UoscoaG/V1kzy/Zp6pKOZB/4BYP9/IgOEi+mluiekRj4PdyaqwZJbXF/
	 t7zRIYkSzXz0DXb0I828cIhrh+6wTSeEgMdEsayVEirVdplBzQhE7och/JmuAxFvPDLMU
	 0zI5XpB/kZy3XtbDLwbFfn1H6e+MaVk4PN64VNrFOoeXLPGjDCKy0lmmx29PrjstqXWAx
	 BCQYNLXl3HewJ7R+ysTkjuXYEabGCSKzwYw/R/GalTDXAMMaygEhd2BDdH7R1tjm7pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lEEbF8TA;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44086606A323
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Oct 2026 05:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44086606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lEEbF8TA
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e985106c0cso3272035ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 22:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793337907; x=1793942707; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mck7iiQBTW9TKhdP7RVb/9jfgo9mu8qffyanjI2fNnM=;
        b=lEEbF8TAq39SRmnnqVuSxSC4+rcVukXL4tiZNtpbBfxzvg0MJIicH08tXIYuqH3l6v
         9w5DyghX6f55LaExTfo9nLsFnzTDi26MmvQQ+tAB+JfS4sV8mBHdwsshFjjhumJGhJtK
         D4jRhPr1iOvxAJphQcyAcg3N3WeYmeoSsg1FDb4PAKzr68SmUysD1odIedrfAHYEu0rq
         GsABoDuRZHStzQObdt+55DJ6bQnazlSPLMDmBkyod1vU+P8XOGU3vvtPbazfCM/0EUhC
         nudFqriRf2uGzUrXQxXG8gktZpJrUdaAigr8mZhtzw0jMZl8p47TruiQIY3ZDAw/e49U
         oEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793337907; x=1793942707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mck7iiQBTW9TKhdP7RVb/9jfgo9mu8qffyanjI2fNnM=;
        b=AFjUUAXP8wHa8hhnv0AB5uSSnshpKfACyC53w+HuafEEnaaomlv3h6DjHvoF0JhMfZ
         OSZTQZpaadEdeVpSxyXl4pAg9jSNPyCW4bUV8NHrzUM6GcWaA6pFbjXDzU+MdQVDv2Xk
         52ePesRcDA4CKDcKfwiJO3CYTTHNEOl+HLU+Hs2xImttHmDHODki9KywApWSAcma4Z8v
         GRreKzQW0xUhMilhp6Kievif+IN+hI43y1CCvbblb7g2kktGa+Va5bW2Yxpf5mZmqtk7
         nUFe728SZMGkFlnLYMGomOVg97sVEQQMap/X8YoL59QxBMJzxtEkjVZThKkEAbsbJCO3
         ssuQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhBaMk1exlJVGv/iKFSkp8BKeIVzCadVp05HvMkl2ePSCrDMBkEeeGNSO91ABjziUr73iRF6dU+mmDjA==@lists.linux.dev
X-Gm-Message-State: AFq9FYLGsuCEL3C02A5tXEiNtFJy8oEFNkQC11xxyAUNXgDtgpNu1Pzp
	uRbzR/6c4iZGHar3XIAHsoLTEbK4LZpj4JP8drwl7Rukn7xG1CrbZPOo
X-Gm-Gg: AYBFou1+1UQlPZzZ6K7Gy7JcAJxGWsJ6aO75DcxhgWHCILbSI9o8MygK4WhnC7sJ8Pt
	79+asNvj4nL4BtPIWrWaYu4Dj+xjPAgDNDbZQlc5+Y1k7a18aDP3xEA9NFre4/SVfYPCyvv8PrM
	pzg/E+7CsGx3AhoCXpbeU7/sWG3JAiIG6orSSvmuG3hLWPNDYgDo8TI5NEHk9lMDBWj9VX40wiy
	psSnXXqnAdEqR1PA5zCwte/2rsQucTxhfv53eY5HShgtAz8zVUyvxwryRBPO/avGkJ5pX23a29o
	c4kydKY/JBq/56T8yL8vVNNxFF7VfeADJKFyJmkdH9n7v7BCl8oPsNeZP8YgtpeQ8wsjbBJNAY+
	j4NpfajGTS5GtsNvkhmDV/P9MJBqEdXdEJyAJ05Vr7eBh23Jbms3rUFgXaN9XDT4WmkI8EvAcgn
	8XP56ofj7DJumR3LakgcUu9kCNTWpyziT5a9Ajr0JaI9A0e3uIItLbXUivSc3y+l9TOaSGqmujZ
	LRSSUIQOYNmNhiBzuvF9AVI9VOXKzWj02nDqkot71YpxAYvbW75vijERIse+L0hMwKcSjZpP7V7
	+pmKUEwnzLrhrFf7uJT83jXE
X-Received: by 2002:a17:903:18b:b0:2ea:825a:7f6d with SMTP id d9443c01a7336-2eb3649be2dmr14547155ad.13.1793337907342;
        Thu, 29 Oct 2026 22:25:07 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3929087csm2458675ad.57.2026.10.29.22.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 22:25:06 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2: drain fs_state readers before journal teardown
Date: Fri, 30 Oct 2026 13:25:01 +0800
Message-Id: <pm-ocfs2-objects-candidate-0003-v6-2f69dbb7417fcd537be6@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The per-mount fs_state open callback formats journal fields through
osb->journal. Its debugfs active-user guard protects the open callback,
but does not keep the journal allocated after journal shutdown.

Both unmount and the mount-error path in ocfs2_mount_volume() can free
and clear the journal before the debugfs subtree is removed:

  fs_state reader                       Mount cleanup
  ---------------                       -------------
  enter ocfs2_osb_debug_open()
    ocfs2_osb_dump()
      load osb->journal
                                        ocfs2_journal_shutdown()
                                          free journal; clear pointer
      read journal fields
  leave the open callback
                                        remove the debugfs subtree

Remove fs_state before cleanup releases its backing state in both
callers of ocfs2_journal_shutdown(). Debugfs removal prevents new opens
and waits for admitted open callbacks to finish. Later reads and release
use only the per-open snapshot buffer, so they do not need the journal.

Keep removal in the caller paths while the per-mount debugfs parent is
still present. The remaining debug files retain their teardown order.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in ocfs2_osb_debug_open+0x967/0x15e0
    Read of size 4 at addr ffff888116a56028 by task cat/502
    
    CPU: 3 UID: 0 PID: 502 Comm: cat Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy) 
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? ocfs2_osb_debug_open+0x967/0x15e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? ocfs2_osb_debug_open+0x967/0x15e0
     kasan_report+0xe0/0x110
     ? ocfs2_osb_debug_open+0x967/0x15e0
     kasan_check_range+0x105/0x1b0
     ocfs2_osb_debug_open+0x967/0x15e0
     ? __pfx_ocfs2_osb_debug_open+0x10/0x10
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
     ? __pfx___do_sys_newfstat+0x10/0x10
     __x64_sys_openat+0x136/0x1e0
     ? __pfx___x64_sys_openat+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     ? srso_alias_return_thunk+0x5/0xfbef5
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    RIP: 0033:0x7f7d444d6687
    Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
    RSP: 002b:00007fff1e988040 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
    RAX: ffffffffffffffda RBX: 00007f7d44444780 RCX: 00007f7d444d6687
    RDX: 0000000000000000 RSI: 00007fff1e988df7 RDI: ffffffffffffff9c
    RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000202 R12: 0000560ae86f2a00
    R13: 00007fff1e988380 R14: 0000000000000000 R15: 0000000000040000
     </TASK>
    
    Allocated by task 495:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     ocfs2_journal_alloc+0x91/0x450
     ocfs2_initialize_super.isra.0+0x11b8/0x3070
     ocfs2_fill_super+0x801/0x38f0
     get_tree_bdev_flags+0x35d/0x5f0
     vfs_get_tree+0x93/0x320
     fc_mount+0x1d/0x200
     path_mount+0x592/0x1e00
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    Freed by task 504:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     ocfs2_journal_shutdown+0x10a/0xc20
     ocfs2_dismount_volume+0x315/0x940
     generic_shutdown_super+0x15f/0x490
     kill_block_super+0x40/0xa0
     deactivate_locked_super+0xae/0x120
     deactivate_super+0xa2/0xc0
     cleanup_mnt+0x217/0x450
     task_work_run+0x144/0x230
     exit_to_user_mode_loop+0x17d/0x570
     do_syscall_64+0x4d1/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    Last potentially related work creation:
     kasan_save_stack+0x33/0x60
     kasan_record_aux_stack+0xa7/0xc0
     insert_work+0x37/0x210
     __queue_work+0xb57/0x1600
     queue_work_on+0xda/0xf0
     ocfs2_queue_recovery_completion+0x301/0x480
     ocfs2_complete_mount_recovery+0x10c/0x290
     ocfs2_fill_super+0x2083/0x38f0
     get_tree_bdev_flags+0x35d/0x5f0
     vfs_get_tree+0x93/0x320
     fc_mount+0x1d/0x200
     path_mount+0x592/0x1e00
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    The buggy address belongs to the object at ffff888116a56000
     which belongs to the cache kmalloc-512 of size 512
    The buggy address is located 40 bytes inside of
     freed 512-byte region [ffff888116a56000, ffff888116a56200)
    
    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x116a54
    head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
    flags: 0x200000000000040(head|node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000040 ffff888100042c80 dead000000000100 dead000000000122
    raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
    head: 0200000000000040 ffff888100042c80 dead000000000100 dead000000000122
    head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
    head: 0200000000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
    head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
    page dumped because: kasan: bad access detected
    
    Memory state around the buggy address:
     ffff888116a55f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
     ffff888116a55f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
    >ffff888116a56000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                      ^
     ffff888116a56080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff888116a56100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ==================================================================

Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0af2245ae303..9f93ae9433c2 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1783,6 +1783,9 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	return 0;
 
 out_system_inodes:
+	/* Drain fs_state readers before releasing their backing state. */
+	debugfs_lookup_and_remove("fs_state", osb->osb_debug_root);
+
 	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
 		ocfs2_shutdown_local_alloc(osb);
 	/* Drain pending suballoc reclaim work before the journal goes away */
@@ -1810,6 +1813,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 
 	BUG_ON(!sb);
 	osb = OCFS2_SB(sb);
+
+	/* Drain fs_state readers before releasing their backing state. */
+	debugfs_lookup_and_remove("fs_state", osb->osb_debug_root);
 	BUG_ON(!osb);
 
 	/* Remove file check sysfs related directories/files,

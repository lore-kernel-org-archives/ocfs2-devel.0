Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257064;
	b=o8S/nCuhnw7Txvl8RAIXwkoY4iu0KmloLB/SMghUGNFei6KMIzqb869jARFE+1nvuLv7
	 V5drAzjsgefwRY4dpKvYtANs2s1lEOe0+rEkOJ4WOF3Dm1StdMRngHNavsDsrn3ciMX9X
	 XISuvI6FlShjk+f6hyonf1mKdNEPwat4LUvK5OQ9e1nvtiMAn+WVHcvMID5kyNmWSkBYH
	 +YAQf4PK6zbBcGDPxjy3ZpJMC3/0PW0Gk+lGHRFTZh1e/XXoJGQtvhnYQ66Q7NZICBFd3
	 BbKWb3NDLaCfLXwunD6sA1mZN8ERduMZi7vEuqhkxFU58q/Jo/r3Ie+Y3oTGLjjLVWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9IaSUVC3Bhn3N2zjTnRy6nvIgW0G052wvFunojoXXog=;
	b=4xrSaGRQ7sE93Mh51BeO94bo/tNejnBp41rwB3jzkeLGjISLl/Aa9juxowaOeVgI5vqu
	 jriFo4UhMbrbtOhTbWyM31+skAv6ZfTUXAdJ6oWYn9mHg9CvUel08n9szrk5F1peNM4NL
	 RS8M8o/1Dw98mvo3u+V/saPvgPrbuNfhupP3RS0tLz2KmFd1X+iLUIjNn77KUxZXQ0743
	 TqOjfDmF8uRlL0W3k4Nlr2quGcztcNL4OcNuikqtrukzleY3GydYGwj0hb/iGt708+Vam
	 WwIXXRZJRbn3g7KmR+X6CeuMemJhLq7tqFvdafbk/M0VR+JBTCIVOn5p5jBW1Zx4mVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="HbvN/yqG";
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBCB606A31C
	for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 06:57:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DBCB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HbvN/yqG
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso850145a12.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 28 Oct 2026 23:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793257063; x=1793861863; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9IaSUVC3Bhn3N2zjTnRy6nvIgW0G052wvFunojoXXog=;
        b=HbvN/yqGGJL3FTYmDNYFWn5u28qu7xXQMSRZFcQEkweGXefFdMEiVqtbQzHYRP/Qz0
         MoBmrcxgu9A+UZlXXdlnLOnP9k+eZ+sbthcMhNsAqJFBAzCMAq/Wk/TS7BvRmQaJ3yD1
         frasDN3iupHEYMWcCIREprpYaiaW66RZYLmfknANB2oWaA5L3fmic3V2Wv5ZTwTquM9v
         H8aFfN9DzN6HY4g14nWDyFngJghekCnV2LjdGL500apvc+eMT9j+E1d0znCGtGifXygv
         q3hmLRF/FbH7PwxjpIdKsi6dFUeZ4Rz26rxplyMOcezV2AtkPG9Bceo2p7TgTwu2YQKq
         PTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257063; x=1793861863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9IaSUVC3Bhn3N2zjTnRy6nvIgW0G052wvFunojoXXog=;
        b=EdrjhJp4EgJwVQb74/2kp1l6/RRfB84nRE0TNnhNIKn5hBWwmmqCrmNKCI9H6UcB2S
         feFPv2GxcBD0rWXdDzZwGAggOfYJxB0KwJoDFmr7V3L99hsZbLz+e3Ar4EHhQ7ZBumBV
         MQ+GcW7/G5+3fLy5v3Ytqgv5pvtK6EA7v2+SkrhwlOsdsSBYO6Dv7fAnXzZbDct+55Pv
         vPmr5vLS7jdRvgNEXAJj9EChb04RMK6/glyhzOoaPTUvBDO/Nv2msv4lQEbmQRTlLcaa
         meBH22X4hBeaIkl6q+WZDXCVlie8lbOb+wiozmVzu/XYWcwphBjuSf0vnupS/T8ReZkN
         7DeQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTKav3/xW8vj77c3yzA4zPvswoDyoVST9yAji5ry4a2u02C395vejZYCjW8mvzdBGVS74winzDVXPbsA==@lists.linux.dev
X-Gm-Message-State: AFq9FYK2d9Xyy+STzGu9P0FPkzvpWrrG8TsbJ+60wo83mB/jDogx0p9z
	idGEh4LkYf6RArj7CMsfJqrJBiiAvAF0FsSqwQt31fLRRZTqFsy73ouV
X-Gm-Gg: AYBFou3yfHBCwM3D+eRgC0e0UpYY7vbSz8GKxbeLikH8KjWgh2xbYiMTpBznBSKny1k
	wZQWqnJoQvvJ4CQXDn7W+zNu55x04CvpJWrtuKOoBn8hJfy8ayfm8Jo0GFJ3LfXKNEP0Exs5pnZ
	V04iFjHkeUYle8/rjsm00n74u3gxy81uHrr3x8zdhEl+YhuVciQmcd51NVTUmgk8W3mUERpXHIt
	WBteGBgRT0W06d4R6dyq71ut1ry3OoEJp/ri3X1J5FwM6Bc4URs1MCC1Mq9kGZbW5Vnggh0qYFi
	Y/fszfCOA738CrFgScOooQ5i5IH9l9DZC3dtJz2MQjHFsP7x5HKxIZF3iKjzCKTqpujly+CfHpr
	n2/ZrAzrQYkDrIL0JmlFLqruyrqSpd+PuUsEi/ASfowVw35JJRURS9xR/mPEuH70Ob6H9qOZyFt
	wcAqC/UVSrymHdAd0SnhiW7yPOdx4GtopJab5tc/EhvGpi506CzUIfKU6CEz9uYYyL1XvPInlvY
	8gVFxIxjRGKOj4Yt/bkilLKJCiOCGJq4UMDyLW/Ph64WDphEl+2ucpQCvoH0TAYwoqvmfjsXH7G
	BQ/bL9Uaupa6/WvuPUwmFyi9mmET/HEUXZAMZwZoqSopOA==
X-Received: by 2002:a17:90b:1dd0:b0:3ab:33b6:2c27 with SMTP id 98e67ed59e1d1-3ae57f9c1eamr3604405a91.23.1793257062419;
        Wed, 28 Oct 2026 23:57:42 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae579db47fsm3020022a91.3.2026.10.28.23.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:57:41 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: stop recovery before shutting down local allocators
Date: Thu, 29 Oct 2026 14:57:35 +0800
Message-Id: <pm-ocfs2-objects-candidate-0019-v8-574dd69fd3f47f56348b@gmail.com>
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

Recovery completion needs the local allocators until it has finished
reclaiming a failed node's allocation window and truncate log. During
unmount, quota recovery is stopped first, but that leaves recovery_state
at OCFS2_REC_QUOTA_DISABLED. New non-quota recovery can still start.

ocfs2_truncate_log_shutdown() drains existing completion work and releases
osb_tl_bh before ocfs2_recovery_exit() closes that publication path:

  Unmount                             Recovery
  -------                             --------
  stop quota recovery; disable quotas
  truncate_log_shutdown()
    flush existing completion work
                                      recover another failed node
                                        queue completion
    flush local log; release buffer
                                      complete_truncate_log_recovery()
                                        use released osb_tl_bh
  recovery_exit(): disable and drain

An extra buffer reference alone would still let completion append new
records after the final truncate-log flush.

Split stopping and draining recovery from freeing its state. Stop all
recovery producers and drain completion work before shutting down either
local allocator. Keep recovery-state release at its existing later point,
so its lifetime relative to other teardown users stays unchanged. The
second stop at recovery_exit() is harmless once recovery is disabled.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in ocfs2_truncate_log_needs_flush+0x23d/0x360
    Read of size 8 at addr ffff8881093711e8 by task kworker/u16:3/53
    
    CPU: 0 UID: 0 PID: 53 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy) 
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: ocfs2_wq ocfs2_complete_recovery
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? ocfs2_truncate_log_needs_flush+0x23d/0x360
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? ocfs2_truncate_log_needs_flush+0x23d/0x360
     kasan_report+0xe0/0x110
     ? ocfs2_truncate_log_needs_flush+0x23d/0x360
     ocfs2_truncate_log_needs_flush+0x23d/0x360
     ? __pfx_ocfs2_truncate_log_needs_flush+0x10/0x10
     ? __pfx_down_write+0x10/0x10
     ocfs2_complete_truncate_log_recovery+0x315/0x780
     ? trace_hardirqs_on+0x18/0x160
     ? __pfx_ocfs2_complete_truncate_log_recovery+0x10/0x10
     ? ocfs2_complete_recovery+0x666/0x11b0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kfree+0x308/0x580
     ocfs2_complete_recovery+0x676/0x11b0
     ? __pfx_ocfs2_complete_recovery+0x10/0x10
     ? reacquire_held_locks+0xdd/0x200
     ? process_one_work+0x7c8/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_acquire+0x190/0x300
     ? __pfx_autoremove_wake_function+0x10/0x10
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
    
    Allocated by task 538:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_slab_alloc+0x89/0x90
     kmem_cache_alloc_noprof+0x20b/0x5c0
     alloc_buffer_head+0x26/0x120
     folio_alloc_buffers+0x122/0x1d0
     bdev_getblk+0x299/0x4f0
     ocfs2_read_blocks_sync+0x513/0xbc0
     ocfs2_iget+0x9cd/0x1a00
     ocfs2_get_system_file_inode+0x25e/0x7a0
     ocfs2_fill_super+0x1b05/0x3930
     get_tree_bdev_flags+0x35d/0x5f0
     vfs_get_tree+0x93/0x320
     fc_mount+0x1d/0x200
     path_mount+0x592/0x1e00
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    Freed by task 553:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kmem_cache_free+0x242/0x580
     free_buffer_head+0x4b/0xc0
     try_to_free_buffers+0x1dc/0x330
     ocfs2_truncate_log_shutdown+0x789/0x1290
     ocfs2_dismount_volume+0x1da/0x940
     generic_shutdown_super+0x15f/0x490
     kill_block_super+0x40/0xa0
     deactivate_locked_super+0xae/0x120
     deactivate_super+0xa2/0xc0
     cleanup_mnt+0x217/0x450
     task_work_run+0x144/0x230
     exit_to_user_mode_loop+0x17d/0x570
     do_syscall_64+0x4d1/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    The buggy address belongs to the object at ffff8881093711c0
     which belongs to the cache buffer_head of size 160
    The buggy address is located 40 bytes inside of
     freed 160-byte region [ffff8881093711c0, ffff888109371260)
    
    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109371
    flags: 0x200000000000000(node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000000 ffff8881008883c0 dead000000000100 dead000000000122
    raw: 0000000000000000 0000000000120012 00000000f5000000 0000000000000000
    page dumped because: kasan: bad access detected
    
    Memory state around the buggy address:
     ffff888109371080: 00 00 00 00 fc fc fc fc fc fc fc fc 00 00 00 00
     ffff888109371100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    >ffff888109371180: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                              ^
     ffff888109371200: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
     ffff888109371280: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
    ==================================================================

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

---
Changes in v2:
- Keep the vol_state ordering comment, naming VOLUME_DISMOUNTED and the
  recovery-completion mount wait.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0019-v6-7241e0b915991218f315@gmail.com

 fs/ocfs2/journal.c | 15 ++++++++++++---
 fs/ocfs2/journal.h |  1 +
 fs/ocfs2/super.c   |  3 +++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index a3938a03e93b..674e70dfbb5c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -227,13 +227,22 @@ void ocfs2_recovery_disable_quota(struct ocfs2_super *osb)
 	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
 }
 
+/* Stop producers and drain completion work without freeing recovery state. */
+void ocfs2_recovery_stop(struct ocfs2_super *osb)
+{
+	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
+}
+
 void ocfs2_recovery_exit(struct ocfs2_super *osb)
 {
 	struct ocfs2_recovery_map *rm;
 
-	/* disable any new recovery threads and wait for any currently
-	 * running ones to exit. Do this before setting the vol_state. */
-	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
+	/*
+	 * Disable producers and drain work before freeing recovery state.
+	 * Do this before setting vol_state to VOLUME_DISMOUNTED: completion
+	 * work may still be waiting in __ocfs2_wait_on_mount().
+	 */
+	ocfs2_recovery_stop(osb);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 19fc920d26b1..4b52bf7b0938 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -147,6 +147,7 @@ void ocfs2_complete_recovery(struct work_struct *work);
 void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
 
 int ocfs2_recovery_init(struct ocfs2_super *osb);
+void ocfs2_recovery_stop(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
 void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0af2245ae303..3072b0386db8 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1831,6 +1831,9 @@ static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err)
 	/* Wait for worker to be done with the work structure in osb */
 	cancel_work_sync(&osb->dquot_drop_work);
 
+	/* Stop recovery producers before releasing their local allocators. */
+	ocfs2_recovery_stop(osb);
+
 	ocfs2_shutdown_local_alloc(osb);
 
 	ocfs2_truncate_log_shutdown(osb);
-- 
2.43.0


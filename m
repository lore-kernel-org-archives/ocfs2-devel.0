Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257017;
	b=3+SxXebr1ivXIYyTdvqIpyFyP9WveVIo/MU5DexekPKNOrHjkN0Xj5fxJ19ElkVHUuLG
	 i8ooxKUycax818lCXwiLuKMYnbQGlbcTyYSIg2cAgdQ/emP2YBhZVIOrlWJlBJmd1e34d
	 Sjs+aK4lhtBAnA7fGX663Pbutmv5DZtc4BCM8kh+cjqOOG9BD/zaZ78/SLqs0cIAUcKj/
	 m5dZrBcmFtxmjCxwC4+2f100UfvarTM0aCaqjITMwEVcacOXRVOHvvjvL9xJFT5xb8Ue6
	 mQ45FcRaUa94f+HnHFd5J4sFv6yDn9LaPe4Kn6R054npgiL1vBK/FAd9D3I8mnsN99w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257017;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hR7bpGoqOkAzxkh6GFImhYK3YN9EXwKZesSLQ0u1G5Q=;
	b=TmcuB7dJQHEBl0dy6v0029j22AIArLlWAOjZVu3uC18R4Wo50GZN8OerRmKlGRgmHlVH
	 IzXhZPN5iINj+aoWXPpNI9s/vrtelAEBrSkrPH2U7eQeWn+UHEDNhxyrKETSwrL5+T09D
	 GLcwe5vS2S9dCXYIO0MhAPb7eMHsr5HxRxb/zJUzyVTQG/Rm/tKbBzWhqAc/ZowL5w8gC
	 F7EWKwY8qhRtITW/cGRchgnPUR+HHQlE3ufufDtL6hYcpBrtRVbT6WXCi6RD4ThkhSGgC
	 EplML98+nzUhJ4QxklQw3wi2a+6RORlbxqJG1P+niSgUO7i2oSHiv8QiALXk1+s2YqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l8BTARqI;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85090606A31C
	for <ocfs2-devel@lists.linux.dev>; Thu, 29 Oct 2026 06:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85090606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l8BTARqI
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso869945a91.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 28 Oct 2026 23:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793257016; x=1793861816; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hR7bpGoqOkAzxkh6GFImhYK3YN9EXwKZesSLQ0u1G5Q=;
        b=l8BTARqIWDBTNFMa5T9EDs7mVgkGHy2I0xaDk4v/Dfsu0rCZdDOwuT81bFLfLRLuTy
         iOxaNzMFBnCQ3hcmcdQL94tEJsHeOk1T+9q/XPEYP3KjIATICkSdqY91+hePcOht8Dwa
         i5Km9vmlludWix3tn4rqdV5R2GELiSmYmBVsHUf0v2kNf60Wiyg/2gCA6qA/kSP2wes9
         MRzAaiOtiHxdksTTPL9jiMxQ/40VzTbXvbT3eiHZljeGkgLLYYKILx5/gZSV+k3IgM77
         ffN5EK0T/p+tbT7qzq1arIBzVhg0oCF7CtepRH8awFSOLGCNqvkDz0j9advGTnRk1TU/
         xlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257016; x=1793861816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hR7bpGoqOkAzxkh6GFImhYK3YN9EXwKZesSLQ0u1G5Q=;
        b=0AZWIw36KhlZOb8flV+ckdy8yeKUTV2YSVBAHw+1G6ZJbt2/fUl6Hu6nUXaG0lldFU
         APDp1YSmwbFR6NJeUswSuEdHdpcH8shiNgOZhlKZmjyDXWEZUB7xmFshAMQiTomLT2va
         SmuY4yGshFVQyV3x5ETUCsd31ffMXYsVik2oWwiZtDJYs56EJS5vsR4moHEBv0Oy26VD
         ATQdqH9k2fL1znkgFahC5SLM9c199XcSdikPTFsaa6Yyb0FwM79VQ49m5wOFPjhwZQwG
         Y65fUqyKSlZahnOEHZNiUNHTU/kNsKb1PNfgZgU0V4Z3qBlSqPw6BlyZbqOuZRwsdart
         Iw/g==
X-Forwarded-Encrypted: i=1; AKwUvBy+e0gJk62WbQK5FtVxyJbg93A3QMFAJlj+CdO9aBvZRBShiSDsWcjFmhvDVMAyZ1kaxsC9HVfmvOLbuQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYLOU3x3UjyhCjMRgmeQSKQSX3Zzy5KKbxfdnWuJdZmqxXguSDRi
	3iKX88iQ4PL4F5C9Nz6Hhnl5AP50kZiCSSgTBRFqrxoNCjgS32/Vlano
X-Gm-Gg: AYBFou1Qh98VXbDk3oaZqsy6REQ6iOZIY71At/cJ2AElPOKM2wbcmTM50NVjTqzfGZZ
	v+E3D2lVSkQPKKMxJ9zRZfiTYXKK5CDcT1UTLRXNq1C1OnIr8wJhe7nQUEAyT/wNm9+7uB8g7CF
	l+ZhXGoTAW8bvLvDxrW74pYm6u4AVcFZthD3LSD3jKxBQiZQ3Bh0695jLSBPu2NXWZXjHaYPana
	XffwxeZk8LWJiu3yKyR1V5+cc4NC9uM+HoF3TKw8nVgSYT9PWmIi53luvA4nTFXYofXvhwNtyw/
	SCZNIeREPZYXZIoijeNYqoU7mllsILB57R3RCjgb467Bri9BYe69v5XXWBZPJjBskTL8nfMHKzx
	TBeGTNt7NNorbDNKbgnICrUeCi0c+kb8P+IpQG+7KyJENYxfTKnlttx1pLrVZkRgutAq4SgQ57U
	UGAku8EWGR+twAtKFY03idysbYwFHpWKsbF3YCzhuN9Id0kGyMYLcaTVNsH4RXuNV7GKYIE0Tcr
	KmmXo8w9pMVTKRUB0L09jGftfmlaNcqrQPDiVdNQh66yUbA2EJgxGRFmUJt9NqUewRuz/FN/TDP
	KBgx90V78P1VbVY/DbqX7N/k
X-Received: by 2002:a17:90b:4b89:b0:3ac:17c:6e85 with SMTP id 98e67ed59e1d1-3ae581e1959mr3583427a91.47.1793257015651;
        Wed, 28 Oct 2026 23:56:55 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e83a4f1sm2954509a91.12.2026.10.28.23.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:56:55 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: advance locking_state through the live cursor
Date: Thu, 29 Oct 2026 14:56:48 +0800
Message-Id: <pm-ocfs2-objects-candidate-0053-v7-ec41d4bbd38bb4d795a8@gmail.com>
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

locking_state copies each lock resource under ocfs2_dlm_tracking_lock
so its containing inode or quota object can be freed during the dump.
The copied l_debug_list pointers do not have that lifetime protection.
Yet ocfs2_dlm_seq_next() follows them to find the next record.

Remounting read-only can free a quota-info object while a debugfs read
is between the snapshot and the next iterator callback:

  locking_state reader                Quota suspension
  --------------------                ----------------
  snapshot current lock resource
    copy l_debug_list.next
                                      remove next resource from live list
                                      free quota-info object
  seq_next(): follow copied link
    read freed lock resource

Advance through the live dummy cursor instead. List removal updates its
links under the tracking lock. Position it after the resource being
copied before releasing the lock, and never walk the snapshot's links.
Reuse the per-open snapshot for a nonzero seq_start() position, including
read continuation and buffer retries. Rewind the live cursor only when
seq_file starts at index zero; seq_lseek() traverses from there through
seq_next(). Clear the snapshot's l_ops marker at end of list so later
reads remain at EOF. This avoids replaying the list prefix under the
tracking lock on each read, without adding a new cursor or position field.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
    Read of size 8 at addr ffff888117ea9838 by task python3/489
    
    CPU: 3 UID: 0 PID: 489 Comm: python3 Not tainted 7.3.0-rc4-next-20260921-pmb-bt-functional-v1+ #1 PREEMPT(lazy) 
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
     kasan_report+0xe0/0x110
     ? ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
     ocfs2_dlm_next_res.isra.0+0x1b1/0x1d0
     ? __pfx_ocfs2_dlm_next_res.isra.0+0x10/0x10
     ? __pfx_do_raw_spin_lock+0x10/0x10
     ocfs2_dlm_seq_next+0xb8/0x4c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     seq_read_iter+0x92f/0x1110
     ? srso_alias_return_thunk+0x5/0xfbef5
     seq_read+0x362/0x5a0
     ? __pfx_seq_read+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? selinux_file_permission+0x11d/0x540
     full_proxy_read+0x11f/0x180
     ? __pfx_full_proxy_read+0x10/0x10
     vfs_read+0x1a0/0xc20
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? kmem_cache_free+0x242/0x580
     ? __pfx_vfs_read+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? putname+0x93/0xe0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_sys_openat2+0x12a/0x1b0
     ? __pfx_do_sys_openat2+0x10/0x10
     ksys_read+0x111/0x200
     ? __pfx_ksys_read+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    RIP: 0033:0x7f0266dbb687
    Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
    RSP: 002b:00007ffccf76fc40 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
    RAX: ffffffffffffffda RBX: 00007f0266d27780 RCX: 00007f0266dbb687
    RDX: 0000000000000001 RSI: 00007f0266a53200 RDI: 0000000000000004
    RBP: 00007f0266d27700 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000001
    R13: 00007f0266a53200 R14: 0000000000000004 R15: 00007f0266b651e0
     </TASK>
    
    Allocated by task 547:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x28d/0x610
     ocfs2_local_read_info+0x181/0x1580
     dquot_load_quota_sb+0x68b/0x1000
     dquot_load_quota_inode+0x227/0x3e0
     ocfs2_enable_quotas+0x27c/0x520
     ocfs2_fill_super+0x21f9/0x38f0
     get_tree_bdev_flags+0x35d/0x5f0
     vfs_get_tree+0x93/0x320
     fc_mount+0x1d/0x200
     path_mount+0x592/0x1e00
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    Freed by task 577:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x308/0x580
     ocfs2_local_free_info+0x47b/0x800
     dquot_disable+0x5d9/0x17a0
     ocfs2_susp_quotas.isra.0+0x22c/0x2b0
     ocfs2_reconfigure+0x284/0xd00
     reconfigure_super+0x3ca/0xa70
     path_mount+0x16ae/0x1e00
     __x64_sys_mount+0x24b/0x2d0
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    
    The buggy address belongs to the object at ffff888117ea9800
     which belongs to the cache kmalloc-1k of size 1024
    The buggy address is located 56 bytes inside of
     freed 1024-byte region [ffff888117ea9800, ffff888117ea9c00)
    
    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x117ea8
    head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
    flags: 0x200000000000040(head|node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000040 ffff888100042dc0 dead000000000100 dead000000000122
    raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
    head: 0200000000000040 ffff888100042dc0 dead000000000100 dead000000000122
    head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
    head: 0200000000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
    head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
    page dumped because: kasan: bad access detected
    
    Memory state around the buggy address:
     ffff888117ea9700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
     ffff888117ea9780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
    >ffff888117ea9800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                            ^
     ffff888117ea9880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
     ffff888117ea9900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ==================================================================

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

---
Changes in v2:
- Resume nonzero read positions from the existing snapshot instead of
  rescanning the list prefix under the tracking lock.
- Rewind only at index zero and let seq_lseek() traverse through next();
  clear the cached record at EOF.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0053-v5-76075d5da2df8108f813@gmail.com

 fs/ocfs2/dlmglue.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 88d946466083..99885d21e06b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3102,9 +3102,17 @@ static void *ocfs2_dlm_seq_start(struct seq_file *m, loff_t *pos)
 {
 	struct ocfs2_dlm_seq_priv *priv = m->private;
 	struct ocfs2_lock_res *iter;
+	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
+
+	/* Continue or retry the snapshot left by ->next(). */
+	if (*pos)
+		return priv->p_tmp_res.l_ops ? &priv->p_tmp_res : NULL;
 
+	/* Reads from zero and seek traversal start at the list head. */
 	spin_lock(&ocfs2_dlm_tracking_lock);
-	iter = ocfs2_dlm_next_res(&priv->p_iter_res, priv);
+	list_move(&dummy->l_debug_list,
+		  &priv->p_dlm_debug->d_lockres_tracking);
+	iter = ocfs2_dlm_next_res(dummy, priv);
 	if (iter) {
 		/* Since lockres' have the lifetime of their container
 		 * (which can be inodes, ocfs2_supers, etc) we want to
@@ -3113,8 +3121,11 @@ static void *ocfs2_dlm_seq_start(struct seq_file *m, loff_t *pos)
 		 * trust any pointers on the copy returned, but that's
 		 * ok as the information we want isn't typically held
 		 * in them. */
+		list_move(&dummy->l_debug_list, &iter->l_debug_list);
 		priv->p_tmp_res = *iter;
 		iter = &priv->p_tmp_res;
+	} else {
+		priv->p_tmp_res.l_ops = NULL;
 	}
 	spin_unlock(&ocfs2_dlm_tracking_lock);
 
@@ -3128,17 +3139,19 @@ static void ocfs2_dlm_seq_stop(struct seq_file *m, void *v)
 static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ocfs2_dlm_seq_priv *priv = m->private;
-	struct ocfs2_lock_res *iter = v;
+	struct ocfs2_lock_res *iter;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
 	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
-	iter = ocfs2_dlm_next_res(iter, priv);
+	iter = ocfs2_dlm_next_res(dummy, priv);
 	list_del_init(&dummy->l_debug_list);
 	if (iter) {
 		list_add(&dummy->l_debug_list, &iter->l_debug_list);
 		priv->p_tmp_res = *iter;
 		iter = &priv->p_tmp_res;
+	} else {
+		priv->p_tmp_res.l_ops = NULL;
 	}
 	spin_unlock(&ocfs2_dlm_tracking_lock);
 
-- 
2.43.0


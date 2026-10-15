Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3865650F5
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085794; cv=none; b=HQ1s957MMPhNoRBEVPWwzKAQgEcxoy/uNlh/QGYmW2E6X7S1wpXdKLEBShN02h/NZ44VQmzwn2xPr20Y8kNadUXrmXhByjq0mH4+s3mJy7zUKMC/XieFWKum9idjPycnP4/HGUAAPWGe5v1Z+BQdckclPX5VXt9Hj+l6jvs6StI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085794; c=relaxed/simple;
	bh=XMZWNSALGx66DAXTjiCW6D0VHKFTsEvlhMkKHIV7N3U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HxNAbTIdkqz/aK+dpYUTEoZf5oH2wjAnw7xMozWuWC3sLxr9//+P8W1scitJC1ue3L4GmH+AebcL3yW3BmlSd7aqgc5cRftK4Uzii00Mctsh9Aw2a35tvxlcnnGX8tMKa7e6QBuPKOewxL4sUAoV8n6zyXFZxZqyrV0IRlzYqZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pFr2xhL6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pFr2xhL6"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-88b5f43cb8aso715244b3a.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 10:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792085783; x=1792690583; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d2fubKBoLgQUTAWsAbRE7jSlw3VB6SYRsTIq0RJ/P+s=;
        b=pFr2xhL6OIsqOHXpQLoPngF7AaW2U02IcdJfulP6tmcKod9Q4oz7vcJxE73nbRewQN
         iDvsI2iTQlkibZGHCPtgtBdbzp8NGQ6R1thY7V1qxY+vzYb7dioU5H5MCkLp4t5/ifK0
         69yYwUo/559FO19sQhzc1Udb83IPdgIoLOZw9gzjGc/P6kCOrUdQoqGopma842LPYjlA
         orhjXVXl5cm0iCvAOUUIw/rBXUSqoOcagC/so40VL6UgFh60ai5eFczD7Gnso4trMinj
         S3d1SdQsMBCgOmcrTr21NEPhVtzyTs8jEbUWT/vuud0bKVqHNn5OnMnd94l26pYrU3D9
         SiEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792085783; x=1792690583;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d2fubKBoLgQUTAWsAbRE7jSlw3VB6SYRsTIq0RJ/P+s=;
        b=v5mOBZZqd8SRlAGdY4+v03YCTNpdmD+SGqRDQletqF6efqUyRVtcJvVjx1+sZmz/dm
         q0IJL9Ms0Tdmox6fGezypOPLEvKOcRKGxIcI1ORAFRhXVlN0oOWY5zqtfHq+9XPUIPK2
         aTtRmjGGEHFVgdZ0rcDy+8C2thX8KgCiSzJNyYAJoNyyVuUGAwOqpUIQvIm7C98y0nfz
         DAERTDXk7BYo9Tq2WbHAhYkzxi+pStaWnCm70GQa2mKgifPQPU4ITOSmS/12LD5+/PuU
         OZkb3OdRrXS3s3R9UI0LvxitQF9DLxtySpvaFYimq1KJ9htYzznnhECYe8rJWNu0PbRr
         0Tew==
X-Gm-Message-State: AFq9FYLEcmUJSTfywTVaV+nlduYV7ujNM44iycgd6BDpRLAfHVsJtVa1
	6o8lHwTNoOReIuQ744qoSDXnIDbI0I0uuk//q3waQXEcAihyEh/JnRgm
X-Gm-Gg: AYBFou3Mb1wXohIYBSTI2gw6kKEzBf5ZNfzPvM3l1fW7QxgDRlBWo17ujXl7qVn06CO
	OjPRCrUUX8KyFsPKltHrtoI6oCpKXqLYXI3iEwrIlmK3z9yzw0t8WNEH59GtIEgtUqCFZ5wMD9W
	YgHOlswcRYksI2Imq0WKzLlXV90PdqOL6PTvjrwdOpOHybCEbkf4Vx81i2qzhdv2+BlAwmpmL7Q
	ms0h17dHs6W2Ot8oNkCcOsliXC8qWBuuchj6Ik/wWd5bwwCK/+5656blca/NkeSI7qTbW0LAvwH
	U8nxCE9CHGatbNk8FP81NFWAH/A0sv7Wosck0JDQS/dgHZ+rWEJDYE3M4YNzv+oICGg2cXxZA9M
	td9l/JqIaeiSbak0zWDm4V8jiKIWO7yFmYwP6/iEJzryLdmSz7DyFvFp2004lYJBJkh1fbfoVVK
	osFT86wPXIlp9dfcDH5S3E40mh3IoUhkqwv2pcsE8M1u366z6xrSZAvPcZb5YL9AiRBw==
X-Received: by 2002:a05:6a00:4fca:b0:87d:430:1437 with SMTP id d2e1a72fcca58-897c7ec3069mr17209710b3a.38.1792085782783;
        Thu, 15 Oct 2026 10:36:22 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f5820b344sm1422b3a.53.2026.10.15.10.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:36:22 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	boyu.mt@taobao.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v2] ocfs2: stabilize the dentry name while tracing reads
Date: Fri, 16 Oct 2026 01:36:16 +0800
Message-Id: <pm-ocfs2-objects-candidate-0088-v4-a9a0df898afb4fc65fa0@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

An open file pins its dentry, but not the external allocation backing
an individual dentry name. ocfs2_file_read_iter() passes d_name.name to
its trace event without holding d_lock or a name snapshot. The event's
__string field needs those bytes for both strlen() sizing and the
subsequent copy.

With the read event enabled, a read of an open long-named file can be
preempted after evaluating the trace argument. A successful concurrent
long-to-short rename of the same dentry can then reclaim that name,
provided no other name snapshot retains it:

  Reader                              Renamer
  ocfs2_file_read_iter()
    load old d_name.name
    <preempted>
                                      vfs_rename()
                                        take_dentry_name_snapshot()
                                        ocfs2_rename()
                                          ocfs2_dentry_move()
                                            d_move()/copy_name()
                                        release_dentry_name_snapshot()
                                      kfree_rcu() reclamation completes
    trace callback calls strlen()
      through the old name pointer

The pointer load precedes the rename, and sizing follows reclamation,
so strlen() reads freed name storage. The tracepoint's SRCU section
protects its probes, and the event callback disables preemption only
after the caller has loaded the name pointer.

Take a dentry name snapshot before tracing and release it after the
trace call. The snapshot copies inline names and pins external name
storage, keeping both the string and its length stable while the event
sizes and copies the name. This avoids holding d_lock across trace
callbacks. Check whether the event is enabled before taking a snapshot
to avoid adding snapshot work to reads when tracing is disabled.

KASAN report as below:

    BUG: KASAN: slab-use-after-free in strlen+0x85/0xa0
    Read of size 1 at addr ffff88810a5b2b18 by task python3/496

    [CPU and host details omitted.]
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? strlen+0x85/0xa0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20e/0x420
     ? strlen+0x85/0xa0
     kasan_report+0xe0/0x110
     ? strlen+0x85/0xa0
     strlen+0x85/0xa0
     trace_event_raw_event_ocfs2__file_ops+0xf0/0x480
     ? __pfx_trace_event_raw_event_ocfs2__file_ops+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xe7/0x1c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ocfs2_file_read_iter+0x6cd/0xb30
     ? __pfx_ocfs2_file_read_iter+0x10/0x10
     ? selinux_file_permission+0x11d/0x540
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? security_file_permission+0x26/0x80
     vfs_read+0x7d2/0xc20
     ? __pfx_vfs_read+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_do_sys_openat2+0x10/0x10
     ksys_read+0x111/0x200
     ? __pfx_ksys_read+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? trace_hardirqs_on_prepare+0x11d/0x150
     ? srso_alias_return_thunk+0x5/0xfbef5
     do_syscall_64+0x114/0x620
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    [User register dump omitted.]
     </TASK>

    Allocated by task 489:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_noprof+0x2de/0x780
     __d_alloc+0x5fc/0x8c0
     d_alloc_parallel+0x106/0x11d0
     lookup_open+0x3ff/0x13e0
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
     __rcu_free_sheaf_prepare+0x65/0x2a0
     rcu_free_sheaf_nobarn+0x1d/0x50
     rcu_core+0x6be/0x1ed0
     handle_softirqs+0x1fa/0x8d0
     __irq_exit_rcu+0x113/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20

    The buggy address belongs to the object at ffff88810a5b2b00
     which belongs to the cache kmalloc-rcl-192 of size 192
    The buggy address is located 24 bytes inside of
     freed 192-byte region [ffff88810a5b2b00, ffff88810a5b2bc0)

    [Page and shadow-memory dumps omitted.]

Fixes: 468eedde23d6 ("ocfs2: Remove mlog(0) from fs/ocfs2/file.c")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
Changes in v2:
- Replace d_lock around the tracepoint with a dentry name snapshot so trace
  callbacks run without the caller holding the dentry lock.
- Pass both the name and its length from the snapshot; keep the event
  enabled check and release the snapshot after the trace call.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0088-v3-d628f98bfcb6784a0bfb@gmail.com

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..fc357c227ad8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2542,11 +2542,17 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			filp->f_path.dentry->d_name.len,
-			filp->f_path.dentry->d_name.name,
-			to->nr_segs);	/* GRRRRR */
+	if (trace_ocfs2_file_read_iter_enabled()) {
+		struct dentry *dentry = filp->f_path.dentry;
+		struct name_snapshot name;
+
+		take_dentry_name_snapshot(&name, dentry);
+		trace_ocfs2_file_read_iter(inode, filp, dentry,
+					   OCFS2_I(inode)->ip_blkno,
+					   name.name.len, name.name.name,
+					   to->nr_segs); /* GRRRRR */
+		release_dentry_name_snapshot(&name);
+	}
 
 
 	if (!inode) {

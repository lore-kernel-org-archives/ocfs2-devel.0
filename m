Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89C431F9BD
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510069; cv=none; b=Nhomr8qJGUDWGLwBzAU/6vqIFnmY5OUJKLZjd7Z0dWKPsHxO6A3/UV/FViLX/SqzHnkz0cCD/XdKZ0sxAsM47rk4/IM3s7sCj7axbTc7ljx5u3VWDF27ETLnJha5ZUaUsztvHpZk/kdHBFJB2SH22OPZCsl2LLUwKfbgCFg+wyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510069; c=relaxed/simple;
	bh=5Jv8j7APlwwaU6ZUf8y9K5scT0ha0/L1LucPaGnbmfY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hhtk5GhttWUt4vR1VSKGhtdrPZODAuQYPS2V1cCVdidUsoNnNwMupsC380MCQ3FIlC1vQtANZeAnZH6R3MJhjpaxFsQV6TnpsHyGGKnGA+DWZ89hyL1oLGDTJhJG+bpglundG8BCyzy+Kp9JVDgLu94+R/gOh3a9osZiI3kLdyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oJBO1kzq; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oJBO1kzq"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-88bf90b7f07so1230926b3a.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Oct 2026 18:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791510066; x=1792114866; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oc3v/RNKFMSSXOD1ONlfWh+mZ5uFjK1VgKM2BwVJqMA=;
        b=oJBO1kzq6G/ZCUb15u7t/v1YWoBAUTBcNPU1s3dZMKEXyh92WxFdluvQdXgM2vLqCR
         Y6+W3Rh9BATELSed9ANq5ciXASYOQVWV+v4ylayzpfNZbYkITVRyOgotNyrZkAS3Ng96
         IG3gRqljKlcX7qTGXsf57/SA9n7o9zID6kJ8HAC+B2HlXIMLnZ3ZLqlx7+FauqxeQTg7
         GsRdAocNdXIVCSJWTeGwgk9wm5mSGk31Xma5WE6oKNisZ2ZKoz4OBxJ72+AdYhwCKbsV
         7GlSfEhozhZa109O99oeXidR0JLfuh/WvwE2tsAOhW66Jqfkge6PS7tQtzTCY+qulRd3
         187A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510066; x=1792114866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oc3v/RNKFMSSXOD1ONlfWh+mZ5uFjK1VgKM2BwVJqMA=;
        b=l5IR8lqOEMPFPaH0maaDmADXTH7tDDZYXAa6jTAXRzt+fpLaOaF/C/DlertXGw+E7e
         x9j0nTdAkGQy0euaQ+Q4bfsgKj2QD1080j4kah9Nm4Dsl2GWW/e9aClb0Xrtv4GMACTL
         n0VJAwcS8am8/b1qrTV+6BhByxWSD0087Rvyw8+QTJex7zn+hXZ9t3P98j46R7OLdgCD
         S6Oj91zQaPpmsDaWvZab597n3p2HNJIGOpgUXL3Ww5OrmAAuS/YSI0VRjK/T15v95DCU
         4OzyFM63/qxiCc8LO8J3Ei1oIdYLsWuvyttihmMVNsJxXmMfWBZTNNCb4QSVDykw38bD
         M7Zw==
X-Gm-Message-State: AFuF++ngmEtfObAOTNzMt+mLAn5M7b/3J0cE+nn1DZ/kOQaLTSthsjTP
	LmQeITCjmWbEuY/o4Z8/KMNosTO9Guo2AC8q9uPlPT9hLdrJULgrlrRij0updQ==
X-Gm-Gg: AYBFou37NzIlL1FQmJqHaTLVeBT4yUFtyVNEBlsYp0/vkX2zWXn84Z2F9Wkv93lqIWW
	trhupnzPXgPreUrUxl246aS9Ilglxs6pVlCYfBI7irUQd72nDH83Ghv7A3BuYXdDYmYEtEg5mrB
	+3vDPwRAcTCNeFdy+di27QncM28TFlQEuWVF6yIc6duN/bGe5lSS9Ld+DKA4I3iC/xXZBMe4Rgn
	7jhZwbhDfo8VHW7ikxBoXnqJnjAnfElBoybyh6LeIjsYqA12Zs4+Gb7BYpbHW7m00CZGziPQCE1
	W2+0TWuzRF9h6OsPBkDEQYeHR1rA5XnHIyG7VgQNRRY2gJ/BYywUBsCDUUMKg1PDLIIlIRjsJdy
	rwrm9U8TAC7cysNA4AcI8l7RKI6zllcZ+QeCRGs74B/wOPRSMaXfEUG4UgnWZPJAzIZ7lm5CwV6
	rXUI1VeeTytHSvv99KbLXIOsgv0T8cltXvngTzYMV/bM+DYwMyENq0bCvaNu0vP2I9aw==
X-Received: by 2002:a05:6a00:4f92:b0:881:6fb7:bf14 with SMTP id d2e1a72fcca58-897c75e7fe1mr295921b3a.38.1791510066165;
        Thu, 08 Oct 2026 18:41:06 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c43aab7csm256100b3a.46.2026.10.08.18.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 18:41:05 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	zzzccc427@gmail.com,
	ericterminal@gmail.com,
	kees@kernel.org,
	kurt.hackel@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH] ocfs2/heartbeat: Unlink live slots when their node is missing
Date: Fri,  9 Oct 2026 09:40:59 +0800
Message-Id: <pm-ocfs2-objects-candidate-0058-v1-177573785904d0ea43c7@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

o2hb_shutdown_slot() returns immediately when its node is no longer
in the configfs registry. A slot can still be linked in o2hb_live_slots
when that lookup fails. Region teardown or startup-error cleanup then
frees the slot array without removing its embedded list member.

With the same peer live in another region, the next list update can
follow a predecessor into the freed array. Reusing the node number can
also make a later insertion encounter that stale member.

Always remove the slot under o2hb_live_lock, even when node lookup
fails. Preserve aggregate membership accounting and the last-region
DOWN callback: the existing callback interface explicitly permits a
NULL node for DOWN events. Only drop the node reference when lookup
returned one. This closes both normal release and startup-abort paths
without changing the publication or callback locking protocol.

A controlled probe-instrumented test reproduced this while stopping
one of two regions after removing the peer from configfs. Its KASAN
report includes:

  BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0x1e0/0x210
  Read of size 8 at addr ffff888106a4ac60 by task o2hb-pmbd0058_b/497
  Call Trace:
   <TASK>
   dump_stack_lvl+0x93/0xd0
   print_report+0xce/0x630
   kasan_report+0xe0/0x110
   __list_del_entry_valid_or_report+0x1e0/0x210
   o2hb_do_disk_heartbeat+0x1591/0x2c50
   o2hb_thread+0x1ed/0xe70
   kthread+0x351/0x460
   ret_from_fork+0x659/0x940
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Allocated by task 491:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0xaa/0xb0
   __kmalloc_noprof+0x2de/0x780
   o2hb_region_dev_store+0x7c2/0x1b60
   configfs_write_iter+0x2f9/0x4f0
   vfs_write+0x639/0x1010
   ksys_write+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  Freed by task 491:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x5f/0x80
   kfree+0x308/0x580
   o2hb_unmap_slot_data+0x1db/0x330
   o2hb_region_release+0x14b/0x4f0
   config_item_cleanup+0x14b/0x230
   config_item_put+0x79/0x90
   configfs_rmdir+0x58a/0x910
   vfs_rmdir+0x2e8/0x820
   filename_rmdir+0x3b1/0x520
   __x64_sys_rmdir+0x4b/0x70
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1c3def99bb0765deb828ad6415fde31ed9316002..95b9061fce854ac8f32acf3c29f71336fb37a372 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -880,8 +880,11 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
 	int queued = 0;
 
 	node = o2nm_get_node_by_num(slot->ds_node_num);
-	if (!node)
-		return;
+	/*
+	 * The node may have been removed from the node table while this
+	 * region's slot is still linked.  The list member must still be
+	 * removed before the region releases its slot array.
+	 */
 
 	spin_lock(&o2hb_live_lock);
 	if (!list_empty(&slot->ds_live_item)) {
@@ -903,7 +906,8 @@ static void o2hb_shutdown_slot(struct o2hb_disk_slot *slot)
 	if (queued)
 		o2hb_run_event_list(&event);
 
-	o2nm_node_put(node);
+	if (node)
+		o2nm_node_put(node);
 }
 
 static void o2hb_set_quorum_device(struct o2hb_region *reg)

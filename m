Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0BE3D9DC3
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 05:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791523310; cv=none; b=pK9LzCrK9tOhsT1LcVvJ8Pz1kTnK6vuGH6Mvc5u424Sl4nH/nZss7Y0MH6tBByFWelYfmoyDY9dYk25NwYGKoeI82E0X8w6H15+mMplZ2ZfZDVxF2zQWrfk+gI1461Gp8p87VlcT2jPFCKui78YYNNtTYrcuSzSQg36tiE9z/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791523310; c=relaxed/simple;
	bh=GRj9pTV00s1yPxP53I4E1kwwwxMrjXiHC9bHI2p2RvM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iUw89OzIIWhN0BUJEi/cWXsIi8P2yjOv1XVfw++ULqT1QbKU6nU7SDcmvmtIZ/sZhgVprXBtf0u9HnlT96GLe2vT7o0myqzXgVcslutr3xKDHzdNRQQmrv03367MUDTUdQRSiq15UO3RyLl1L1fDbf6csq3o23VPxU1ykmRnARE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqw6cdjD; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqw6cdjD"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc7cc8aafe6so1852744a12.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 08 Oct 2026 22:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791523308; x=1792128108; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KoRrsoveKcsTS8cAXDbOoURKgA5JJLzDOytuW3dWWAc=;
        b=dqw6cdjDTjDAM2m5l2eB1Py/U8PNIohPHyzFoCKesVxaP3w9Xv6Knbm2eowhESusxR
         dJ3RXm1bk9OeEL9E+bCw/DDTvKKfbaM9OcQK9VoxdtFAeUo0tKMkN1WPSoGyoyyg03At
         UrgRI8t4i1L4QvcsR6wgwMSOlDsJcLQkqo2gnMZP1NfbC957NeBw8dg9g6UBpp/a5wMF
         vEMzXHK/WAmlOQo96W5KuDTe3WReuSBdEN4znAtCNmyXBVUpI1EYq77QfSu4ojUfs2Nc
         w0ZqRnVTMpAdlcFIwiU5BXEd8LlOo/Yr6yLjWjSlltbzHPwYBc42ElQGnBrEd4zeDaaj
         4BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791523308; x=1792128108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KoRrsoveKcsTS8cAXDbOoURKgA5JJLzDOytuW3dWWAc=;
        b=KnkYCRsC8sNgbXfsguMrNW6BLgG9TjV3LWZsxeeKLXcfyWwOty6qgg/GzRK9tffR8I
         +gP/LJLoqzNKoEqOT4DtdfAeclq8NRLwSKMznQAsLYP5YfKVDHX6V0fMeHRLpZkv5Fer
         RHT2bJYSO71UxZWq8vuEYA7HE59L//XosKcGIUkRxukW1GDsQMiFN3PfZ+NAgWQRblA+
         lkicOEeNRwPQDuQW2jkylPeez8tnqVatJSyiTGa21thP2PaaK5ct1H8jaoIHb+TT59c4
         1dplYmhB0X8cN3HXpo45QsWlH/QLNey6UwMkjs/35YeEG7pR2uH+AMPsfjYZqswg4kjz
         2eRw==
X-Gm-Message-State: AFuF++ndykZvBJcNxm8nw0on/ucrzc3/6XFJ7WW7eKVR5OTqSR1HurCq
	DJeCywv1jxXc3q+eYRyzfgGclKcxV3znorVB+EV8uSPSlrBHEWouDfdi
X-Gm-Gg: AYBFou0dkVu54eXzYoiXMf4aT1x/e9dpt2IT6fElaQlLz7Pmc3bOyCoHJNgJLUULsxK
	1oMUOBKAwc7HVJxln9oMV+Fov1uieCIT+egG/yMNvXJDoI0IkKodR/F997Cr0W/xI71JnyVP5if
	yrH4eEEwL1NFtmyne+6rUn95zF97Qp5yMPm2JDeRUAYe0p/iWHzBpL46f79TCAZHosdxLOaQ/Js
	qWg6lkS3lH7/czAiH/0t4IQhLcLjVtWLu0sDMeOdwA3VaLHwB7dlelsQB+akHAidoT94PGPGCPG
	76VJKSWw0sfeDGp6nJat+OGUZb0Evhu2pHRvSM1FaavUDVatvO1ypgiAkiz751YGzsD95sAhTb0
	WUsK4bRktzkBjpAirF6s7xnmzKdHPQJLMOj6+pCYcaw0XJOPmKHF/ROX/WGoMZHhLk2KLGi7b0p
	v316fLxq+E3sQ3LMAjpeIadQTgp4WlCeN6duyF4esMSIE18vMFAqtIWjb67ge2SiZyOmQ=
X-Received: by 2002:a05:6a20:2d14:b0:3de:3f4d:f2dc with SMTP id adf61e73a8af0-3e16be89960mr590768637.17.1791523308169;
        Thu, 08 Oct 2026 22:21:48 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e41126sm392095a12.23.2026.10.08.22.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 22:21:47 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	zzzccc427@gmail.com,
	ericterminal@gmail.com,
	kees@kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH v2] ocfs2/heartbeat: Unlink live slots when their node is missing
Date: Fri,  9 Oct 2026 13:21:42 +0800
Message-Id: <pm-ocfs2-objects-candidate-0058-v2-9446113c2b16c817c538@gmail.com>
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

Also require a configured node before admitting a new live slot in
o2hb_check_slot(). The early live-bitmap check is not held through
admission: the last live slot in another region can be removed in
between. Without a node, admission can then queue an UP event with
a NULL argument and hit the event helper's BUG_ON. Existing live
slots can still leave and generate NULL-node DOWN events.

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
Changes in v2:
- Require a configured node before admitting a live slot in
  o2hb_check_slot().

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0058-v1-177573785904d0ea43c7@gmail.com

 fs/ocfs2/cluster/heartbeat.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1c3def99bb0765deb828ad6415fde31ed9316002..3f3f6fc6b1316e7c996681fc50fde84d183d117d 100644
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
@@ -1038,7 +1042,7 @@ static int o2hb_check_slot(struct o2hb_region *reg,
 fire_callbacks:
 	/* dead nodes only come to life after some number of
 	 * changes at any time during their dead time */
-	if (list_empty(&slot->ds_live_item) &&
+	if (node && list_empty(&slot->ds_live_item) &&
 	    slot->ds_changed_samples >= O2HB_LIVE_THRESHOLD) {
 		mlog(ML_HEARTBEAT, "Node %d (id 0x%llx) joined my region\n",
 		     slot->ds_node_num, (long long)slot->ds_last_generation);

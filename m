Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B1C531AE4
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 16:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792083479; cv=none; b=lgPp8FSaPxZjXeM6TgPcEQqLGigU2zZ0ru90eF9VDcjtBgvs6SB2tdH/IvsHqM90rVh6fkWwlmK/vKIOboueDUb2Yg3jpXrPH51OFDdJTX6WXXKYzd/hxezpI58E0/4GVI5yEvjGmBFitwxKTNB/LS37Wutol00Yn23Vhfiz2qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792083479; c=relaxed/simple;
	bh=gBYGD3tKItIGu9oXJXjWgIyeMXUwedDlFFMV8rc1jdA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=nfDmzwZgYeAbH0BZGurjHW0OtP4aFGnd5GuqFZc5cuLA63WPRkHkGbd1KXcMMD7DIQ8NSc/yIySERXx8S/a/7lVOB55nM4UcjOFcW60y1nGh20RDriJ/favQU61/dhbTkUIr1I3xxeU/Rlxq7Cajz6FeqDGrPb+XjfenaOy77q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cR/vGW86; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cR/vGW86"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-85377c8bc96so2570277b3a.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 09:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792083467; x=1792688267; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iPaWbI2r8AXvwprE8o0BKzZtz+m3PX1iYF2IvumBD60=;
        b=cR/vGW86zAckPkf7pg4hU0s2bVegGt3e1WG5iBLYdePVLGV5bjx5BctMd71h0WlhTJ
         pYiy0oepVwKg7uG660DrnhZ9mVQyVxtee5Z5u36/9uzigcetoT42lILqThmgT9nYe4OM
         0H5/qDSANoZHwJxefTRPEoXz1BnzBQVlIjDZnXYhSudswVUeMMQVLRohRocrgM5UdYyC
         iTaEDtr+b2YPlVEuJcTmd79wwZFg8lPxjUuzQdeP4hl2ybj3w6G9eoWWpDm4DXsiJ54I
         FokR0THnPeQhC3XidYp+8lTyaJg8AgSv+cs5YlYpGZ94y6CEcmz2aNbTGmCH0TDjIQHd
         6p6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792083467; x=1792688267;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iPaWbI2r8AXvwprE8o0BKzZtz+m3PX1iYF2IvumBD60=;
        b=sfEkeGA2uwzktwBvZDZMJMXCfvgsptvj/KhLq9r66umAE5xzEaJZ0iDrAsDY/hAoqc
         xubIgIY4GzSqHvlWPP8iWlRd+Dt8GBLORZjDq1AyqBo1KyH8Ss8GbmZQTY+FpZrI1s4y
         JjjRLu+ClQzDCMoq45Zbu2C5lWMBwO3uZaPmdS0bNR4XHJmd3iJ+Er4GdBOOqM7vxIao
         GBbewOK8mgUqTbrRaMIWGOE3CPv1wW1p+bCZIpI1iVgCXZDoorUjHytMDvJqNDh2e1pe
         Bf7tojYU5GiB/7zSvW0liRu2OAY28MjQNTwy4FmHIfU7jBrIcexm7M+TH6+WZl8cVp4B
         HcPA==
X-Gm-Message-State: AFq9FYJ1bwFOC+92CTOh4z/9VIuy92uugdlN1npQi7rFAYNYxZRoHgPe
	3G26K9929qrSxXxNaawTDTNjYwW0ntpeH0qKdoC+SKAM1vh2TOC2ZNFq
X-Gm-Gg: AYBFou2WyBEIQFCsIFjBVyRysjSyCqc/XWm44nsp7ESOKDrerQ6eVbi8gUJvzexfaRu
	/4ohkauFj1E6kHWkh3cQ+YE2aXglEnbwGDsavOPhZYWL0I7hgu5ZJDCuaOlP31Z0pEVCepM7fMY
	SUs3tO5OqNhs0FC2IwM/zkwaNANm4c0crQj7Z650dWO/97ti9cDvO1t2cWFhRqfcStvaL0BM4yy
	9AZo/CwvJGcBiuRHwwKDiYjfMvEer8GpxSkNFUpzfkaF6royt+/fSBU87WSAsdBJHyB0Y7fuDL3
	7hPPVNm0rzEWD47autlR85F/NCWg0oNMv+jdY/bX1M7sM/ICEUM+rQkZ3ZleB+g1MHKAehNPWZ3
	UbtgYJen1ZY+aW8u4vpIedh3hPd/74orKhCYcBxjOdnooSwdTst3AA1aDDlTUt9aWK9tHPm7lwy
	1ceDORAntIIIInZb5TrIigcEUJaMLD4338fW0l+91NmETcHZN8mqhyAatnO0a7dnCESw==
X-Received: by 2002:a05:6a20:6a0e:b0:3e0:c2fd:511b with SMTP id adf61e73a8af0-3e16be0d320mr16966384637.32.1792083467156;
        Thu, 15 Oct 2026 09:57:47 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd635cbaca7sm1556170a12.25.2026.10.15.09.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 09:57:46 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	akpm@linux-foundation.org,
	zzzccc427@gmail.com,
	christophe.jaillet@wanadoo.fr,
	blum@kernel.org,
	kees@kernel.org,
	sunil.mushran@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH] ocfs2: drain quorum work before removing the cluster
Date: Fri, 16 Oct 2026 00:57:38 +0800
Message-Id: <pm-ocfs2-objects-candidate-0064-v4-51daf51db746eedf7533@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The configured cluster must remain available until an in-flight quorum
decision has finished using its fencing method. o2quo_make_decision()
drops qs_lock before calling o2quo_fence_self(), which marks heartbeat
regions for unclean stop and then reads
o2nm_single_cluster->cl_fence_method. Cluster removal clears the
singleton without waiting for this independent system-workqueue item.

When a failed-quorum decision overlaps removal of the heartbeat regions,
nodes and cluster through configfs, the worker can be preempted after
marking the regions and resume after the singleton has been cleared:

  Quorum worker                     Configfs removal
  select fence; drop qs_lock
  o2hb_stop_all_regions()
                                    remove regions; join heartbeat threads
                                    remove nodes; stop o2net
                                    clear singleton; release cluster
  read cl_fence_method

The resumed read dereferences NULL instead of applying the configured
fencing method. The heartbeat thread's dependency protects the local
node only until the thread exits, and draining o2net does not wait for
qs_work.

Call the existing o2quo_exit() flush before clearing the singleton in
o2nm_cluster_group_drop_item(). By this point the heartbeat regions and
nodes have been removed, so their work publishers are stopped. The
flush lets any pending or running decision finish while the cluster is
still available. It introduces no new state or locking; the worker does
not acquire the configfs mutex held by the removal path.

KASAN report as below:

    Oops: general protection fault, probably for non-canonical address 0xdffffc000000011b: 0000 [#1] SMP KASAN NOPTI
    KASAN: null-ptr-deref in range [0x00000000000008d8-0x00000000000008df]
    CPU: 0 UID: 0 PID: 72 Comm: kworker/0:2 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: events o2quo_make_decision
    RIP: 0010:o2quo_fence_self+0x65/0x200

Register dump omitted.

    Call Trace:
     <TASK>
     o2quo_make_decision+0x345/0x3a0
     ? __pfx_o2quo_make_decision+0x10/0x10
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
    Modules linked in:
    ---[ end trace 0000000000000000 ]---

Fixes: f6656d26d17b ("ocfs2/cluster: Make fence method configurable - v2")
Cc: <stable@vger.kernel.org>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM

---
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index e08850a5d736..13d7f579047f 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -12,6 +12,7 @@
 #include "tcp.h"
 #include "nodemanager.h"
 #include "heartbeat.h"
+#include "quorum.h"
 #include "masklog.h"
 #include "sys.h"
 
@@ -740,6 +741,8 @@ static void o2nm_cluster_group_drop_item(struct config_group *group, struct conf
 	struct o2nm_cluster *cluster = to_o2nm_cluster(item);
 
 	BUG_ON(o2nm_single_cluster != cluster);
+	/* Drain quorum work before it loses access to the cluster. */
+	o2quo_exit();
 	o2nm_single_cluster = NULL;
 
 	configfs_remove_default_groups(&cluster->cl_group);

Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E460B33F594
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Oct 2026 01:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792113451; cv=none; b=k0ZrInsuXemahpsJsdB/BPmRa7AL1j+6VizBIW9Mwm3lA7rlajjFnA1GpMULxH1lPcRyDWpwtaOFkGTXdD+R+XM1ZmHNFkkAoEODTLu+RGli3FNeJPKoMd+bMg5kYOqDldizSvjmE2/Qaqsq7tg/AsFwkc/2pPIQ0frSmOlol4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792113451; c=relaxed/simple;
	bh=SJ/jG8MLQshaLuhuluYLLcj2s2DRB1st0MberlN5Xn8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FOXNhwsV2MvtYZFq1UVz7XxGiLUKU6CrK+I9pb7oIKFjyTZ8Nhe2XnzaboFrGilxNnVz8J8X+rN4foGiXVrJKXoWe45TkBOTHJU6gacLg96DRDiNkecMZLrCGUqHY4YHdoHc6rHBfOAwA2d8g7F4L3qMgmeqGF7D5v70dd285zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LPoM/D2D; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPoM/D2D"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-88bd2b44f3aso2975577b3a.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 18:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792113441; x=1792718241; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kt9FQDsR1MLn/kxVOoumsCY08npA6k90Pz+IFSTIf/4=;
        b=LPoM/D2DjJwYGMMfhfS7DKfYAXtM1kPUcdwDZLPvFueLP4/jjQiOFw+Zso60DcrU9i
         4t4ep/LabovG/hm/KBf4Z2gsGzkCx3WooG0xFjtHkMXmcDnE5LOoNAm7XPUAuCVs3vIC
         WyRUIqqw+xpAbjuLEkgqgrTmij5teQLuBJ6JhRtJm2b/3YYA6iWt2X6Qy7SzPWHvQPEk
         LoMUn63AwHVrdZm0WsdO5AzSzOYHkqnZnCWDI9ZK9dEh+Taj+EZqWnwhJRg4Oz+doJxG
         UHU6xZPK97zIoR5KtaqHRcaXWyRMkpoXEXeFvmt7MTnC0SF/bXijSpBTNzqphuozOpxD
         2wLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792113441; x=1792718241;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kt9FQDsR1MLn/kxVOoumsCY08npA6k90Pz+IFSTIf/4=;
        b=iuZyzTJ+w9ayRyn/eMWcusyv5wzK7+8dq0srX97CEuzuENptlyzMlf2pAqgwWhOHBI
         Nt1s9Ae3MD5xDLDDqH9iWrWsjvw1Zuz5j2I7LtQLXOahgEfSoVN6stewe3MRBRkl/vZz
         dJM7K3B0nnaMeGWxbVO1ttKhjJ+xYTB5trIkjQXffLWAJetskCblF1bMdU3geySdiFFc
         xL913syHwrDz92RxEVATYrY1vKfezy5IGP2qP98r09pz8WBjAIroZ/YVW7Obbc1kM3X3
         yAaqGOUFtw0EaPd3NzCvBLnE0fn2gCiU3BPRmtkFxmrxq/CnKWRopF1gUMnTo1TUOF9m
         cLiQ==
X-Gm-Message-State: AFq9FYKshVAs0uqd2W6QXF9agcu+WrkbSVsPkPhnPgz9sMPgo70NJ1sd
	mXIk4WhMYbwsN0EBSpUqDViCfXOUSCqUpZ0G0ax5MG0UOUFv76/EAXx1
X-Gm-Gg: AYBFou2IE9aEde9nqRky2/hQGCBZhznDbP/7SnaabpFk5yo8I7VEH6/PW9y8Oiu9vF7
	pnpskd86w2DsNyKXXIhuWp9HJHpuaQv1ynclRYg7Wu77w1duN4XP6jKqWIA67VfcNkmfrwUjJoN
	7qU9McPSsu0gYPi5rU/qdHafChFXp5UY5TNpCfEmjcOGnBQhRSz6sM70I1aNYEfug15qAA5tutW
	QLMIAlGxNVT36qOLOEvRL8cnbKNxHJoFBgpoqHV+aq8lj/y39gJyMw3P506H787ULzVLjuk0mN1
	12NYPTM0CV9czhGaA82xlipcZQD7GsKjCg3I6NS2YW04VCc4wxARVXM5YvqfY5UzYm/k4G09Yhf
	YWL6LXo97+SDPVRb1fa0+RXbvGiFECA/QY/7MVo0fRBDfQX+BzvmsMA8xZP1VIiqFQmagm2hojM
	gmN+uz+ovU0UhBqRbFF8LURZM4xHWzJtUFP6LKFEnVGYRu0gG1xLSncq/KoXrixJzkwfk=
X-Received: by 2002:a05:6a00:9504:b0:878:6ee:671c with SMTP id d2e1a72fcca58-897c700e769mr18527238b3a.30.1792113441269;
        Thu, 15 Oct 2026 18:17:21 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f6ab19e93sm247444b3a.49.2026.10.15.18.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 18:17:20 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	akpm@linux-foundation.org,
	zzzccc427@gmail.com,
	kees@kernel.org,
	kmehltretter@gmail.com,
	christophe.jaillet@wanadoo.fr,
	ericterminal@gmail.com,
	rppt@kernel.org,
	rollkingzzc@gmail.com,
	brauner@kernel.org,
	sunil.mushran@oracle.com,
	kurt.hackel@oracle.com,
	jack@suse.cz
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH v3] ocfs2: Pin owning modules for open debugfs files
Date: Fri, 16 Oct 2026 09:17:13 +0800
Message-Id: <pm-ocfs2-objects-candidate-0089-v6-f7fda843f80887488145@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The OCFS2 debugfs file operation tables do not set owner. The
full debugfs proxy obtains real_fops with fops_get() at open and
keeps it until final release. Without an owner, this does not acquire
a reference to the module containing the table and its callbacks.
Removing the debugfs entries does not drain retained open files.

An open connected_nodes file can therefore outlive ocfs2_nodemanager
and make full_proxy_release() read real_fops->release from freed
module memory. Heming also reproduced the issue with fs_state and
asked for the other OCFS2 debugfs operation tables to be checked.

Set owner to THIS_MODULE in all eleven explicit debugfs operation
tables: five in ocfs2_nodemanager, four in ocfs2_dlm, and two in
ocfs2. The existing debugfs get/put pair then holds the appropriate
module until final release. Leave the open, read and release callbacks
unchanged. The blockcheck table already sets owner through
DEFINE_DEBUGFS_ATTRIBUTE(), so it needs no change.

The original controlled test used an unloadable OCFS2 module and
case-local probe filters without changing the candidate open, unload
or release logic. Closing a retained connected_nodes file after
normal unload produced:

  BUG: unable to handle page fault for address: fffffbfff804cfef
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:full_proxy_release+0xbf/0x190
  Call Trace:
   <TASK>
   __fput+0x39a/0xa60
   fput_close_sync+0xff/0x200
   __x64_sys_close+0x8c/0xf0
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in: [last unloaded: ocfs2_nodemanager]

Fixes: 2309e9e040fe ("ocfs2/net: Add debug interface to o2net")
Fixes: 87d3d3f3931f ("ocfs2/hb: Expose the list of heartbeating nodes via debugfs")
Fixes: 3ba169ccec1c ("ocfs2/cluster: Add new function o2net_fill_node_map()")
Fixes: 50397507e856 ("ocfs2: Expose the file system state via debugfs")
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Fixes: 7209300a9b98 ("ocfs2/dlm: Dumps the purgelist into a debugfs file")
Fixes: d0129aceaecc ("ocfs2/dlm: Dumps the mles into a debugfs file")
Fixes: 4e3d24ed1a12 ("ocfs2/dlm: Dumps the lockres' into a debugfs file")
Fixes: 007dce53a29c ("ocfs2/dlm: Dump the dlm state in a debugfs file")
Assisted-by: LLM
Cc: <stable@vger.kernel.org>
Suggested-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

---
Changes in v3:
- Match each .owner assignment to the indentation of neighboring members
  throughout, as requested by Kees Cook.

Changes in v2:
- Cover fs_state and locking_state in the OCFS2 filesystem module.
- Cover all four OCFS2 DLM debugfs operation tables.
- Keep the five node manager fixes and the original diagnostic.
- Add explicit module headers and Fixes tags for the added tables.
- Add Cc: stable@vger.kernel.org.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0089-v2-4c67f48d4e2d0fc85990@gmail.com
Link to v2: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0089-v5-076c780eeaf45afb2a53@gmail.com

 fs/ocfs2/cluster/heartbeat.c | 1 +
 fs/ocfs2/cluster/netdebug.c  | 4 ++++
 fs/ocfs2/dlm/dlmdebug.c      | 5 +++++
 fs/ocfs2/dlmglue.c           | 2 ++
 fs/ocfs2/super.c             | 1 +
 5 files changed, 13 insertions(+)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8e6ead433228e7419bfbbe5c7cdde65c654a24f4..1cb516df53f4e1b3b2a292eb2550faa3d16e3fa2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1447,6 +1447,7 @@ static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
 #endif  /* CONFIG_DEBUG_FS */
 
 static const struct file_operations o2hb_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		o2hb_debug_open,
 	.release =	o2hb_debug_release,
 	.read =		o2hb_debug_read,
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index f7ab66e70799302f3ed4e70ab6a8fb057dd0bfa9..5d373002297de1fdd9a05e270f7942d8c1ce2dac 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -183,6 +183,7 @@ static int nst_fop_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations nst_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = nst_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -415,6 +416,7 @@ static int stats_fop_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations stats_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = stats_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -427,6 +429,7 @@ static int sc_fop_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations sc_seq_fops = {
+	.owner = THIS_MODULE,
 	.open = sc_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -476,6 +479,7 @@ static ssize_t o2net_debug_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations nodes_fops = {
+	.owner		= THIS_MODULE,
 	.open		= nodes_fop_open,
 	.release	= o2net_debug_release,
 	.read		= o2net_debug_read,
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index ce6d301cb9420385211d20d59637069154a89993..8919eb14df22700b36b1edf985bca15b8f185fd6 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2004, 2008 Oracle.  All rights reserved.
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -339,6 +340,7 @@ static int debug_purgelist_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations debug_purgelist_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_purgelist_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -394,6 +396,7 @@ static int debug_mle_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations debug_mle_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_mle_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -601,6 +604,7 @@ static int debug_lockres_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations debug_lockres_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_lockres_open,
 	.release =	debug_lockres_release,
 	.read =		seq_read,
@@ -791,6 +795,7 @@ static int debug_state_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations debug_state_fops = {
+	.owner =	THIS_MODULE,
 	.open =		debug_state_open,
 	.release =	debug_release,
 	.read =		debug_read,
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6bc4a21cf5f02f04a6b54100925084aed239ae62..88d9464660833006b7bac25e2c2641dd77874438 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2003, 2004 Oracle.  All rights reserved.
  */
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -3332,6 +3333,7 @@ static int ocfs2_dlm_debug_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations ocfs2_dlm_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		ocfs2_dlm_debug_open,
 	.release =	ocfs2_dlm_debug_release,
 	.read =		seq_read,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 1e76b1d9fe0af4b3cf503e91e1dd077762fef88a..0af2245ae30369421e78ecd781b986c481d10f5b 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -387,6 +387,7 @@ static ssize_t ocfs2_debug_read(struct file *file, char __user *buf,
 #endif	/* CONFIG_DEBUG_FS */
 
 static const struct file_operations ocfs2_osb_debug_fops = {
+	.owner =	THIS_MODULE,
 	.open =		ocfs2_osb_debug_open,
 	.release =	ocfs2_debug_release,
 	.read =		ocfs2_debug_read,

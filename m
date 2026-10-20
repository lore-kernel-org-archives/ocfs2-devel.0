Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792468669;
	b=i/p07sK5TujLv16VIr6rQNXmsrU8Jpp4bCsbSOTHlOvx9VpN17+s1JkFaYWikNPAZnvc
	 fLB4mhNliQUsxmclmKdeMbNHyKHdlp6+t42aWKlwoyfX5YSA28XD0MiguEqys8nmg0746
	 NybmLCLGmAJCtKrrfexU8fCM2EoBfR/puN+D/Q+9iHTv0/7BceLp7Y03HW9bXYerYetFp
	 RzYEHjm5ll7qkCK1V8ba/GIpYGRa2ACJ9FjMK628vyeO0Rscemo/Gjumuq1QeiVWrU0Y0
	 M170bsSkZqmg14PhDOsXz6oDkU49KaUJf0kqnwc5Dh0ELMkF9nxHKSspoq+HZNhUvLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792468669;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GjbNloEv1OIvWNQBjBw6yfhNVrFCgRGa2Awkmrsd1dM=;
	b=sx6HQY2+dUbFSS2UI4pkR063SQRQHBn1fXeCUKSWsqjNtQwjrBOiG6eGgK1YKcn4U6u0
	 AfgznMQcvcZfhpzz8tK+3ov4Gm/fJuWqebsyTY+RaDW57o8nt/zM9F1C54E1hqX4Fa3/0
	 mhA3PO6L1S6KJ21zqfIleaEkgKPpSG19MYzL3Y6LROAJJhlCiDBNLnmBZeqYXP10IDLK7
	 iFiBbDvnVH6JQADNlflFwXpaT7sZVFWJaRzC02sKJ+OsUczFKV2bgacNDG2xrJT3npYAd
	 MyGm1bJE1sbdi9HN7M6sy4bkfko/DmLqlVeU1iqRoGslSJjmNQ8jwCwSL384TcjdLlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T4yQ+RYk;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F92D606A31B
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Oct 2026 03:57:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F92D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T4yQ+RYk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e9d1114320so14640175ad.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Oct 2026 20:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792468668; x=1793073468; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GjbNloEv1OIvWNQBjBw6yfhNVrFCgRGa2Awkmrsd1dM=;
        b=T4yQ+RYkRdMdfCq8Nc0Z9JEcuEN5zxu0JKrx2o7IwF0jdIYYRm7bVFTh3uxIB1m/wW
         M5nYZnGkkSqeO2catarMnFvh6pVMIxgcAy8Y7WVIxZo/dvZ4fOedazqyvLQ3TEubGXvw
         NYSe/VkXDSVSMDS5RtSEvfrxjWOEv4jJ++BrkyUUjnhGA+BWuIqAALBsIiu7x9QTRcml
         UFaMR9RQw/Wz7E74QbMKzXKyZiMfGCvZhF7uSaxwlxLs+zhxlcZWZ4g39d4jAlD4Tl29
         o71IQha9cDT3i4b+YWOD9ipLaIHxYt4gH/XEvGGuIs50XWT0X7XIFXfEcu6DOYltuzdI
         CKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792468668; x=1793073468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GjbNloEv1OIvWNQBjBw6yfhNVrFCgRGa2Awkmrsd1dM=;
        b=PqiBoeZnHXZi35m67f0Oz4yBH1lkThRQ+c7z2+vRX0y0vGdh1OHI2ugJgk+RmrFLE3
         m2LzbBLYEPtdz4l7xbmHUL54xe0iYmnjt2gCSCJtvPXSDlY6pe3KL/IvWogekCaArSYV
         kntu9m9zZOnOhfOW9gZ3cf7O7xRL5WYazdy523UZBy2+VmYCqMgyJxZ6InLhRbtnW7qh
         A+uGdsh/vtA93loV8dmgEpawAVmoBphJ+aGBhoyZbuGKM+j4FXHwtAxuupyEs34uMnyy
         BN9zShwAeQPrinjqi5HN/v3Wv3FyufHUlBKeHZxUvQxGFweWvs0P4n/ayjUm4VMPCdev
         6zzQ==
X-Forwarded-Encrypted: i=1; AKwUvBz3W7Nt1Cli74qelKvMtPXtYdGK74ylyCt+lnYOTDPIy0hJdMdjFOdZ9oUCC0oMwShdSKWm4o/66lv4HQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYL0DZj1EIlHYi2ZDFkyQlZLTsl53p0fHzMQjVq/GG80fgSvLK61
	QnEM1T8CNqP90AiymlaMMdGdAzaHKn07j8buMIJqdwiBiDHxWAJokarE
X-Gm-Gg: AYBFou08ujAhxlJV9AFSoClW4swd2D8PuHCO+0C6+aWcee0MFV8vSAvB33/MuE9k0mN
	HFzzypxpQ6elMWY3yb5od14RSm2CR6xvG2g2+usbMJCU6qIg9JzzQoVvbqxFBXtxTTG2BjAITjt
	ftgi5uXed54ObLa9a3dcOvWVk/M0/wrNyOx06vhY1qTRGI2Y7wKWNR1aPFBkV9b2l4C2WEFaoxC
	J1UQjTKHC7LEtO2EehoVCkhLgjesKjxkDN0dXMCAyN+hSl4wIDLodlB2nCZyPJcfLyTyaeCHGDW
	60BCB5qDLPE9QXhp7YirV9xKBS6aHywK+N76hsATbIdl34hvPqs5EaLXvboo2FX61vUW8X+Ggrg
	9/5RFdDBOIHNMfERG9LRHmWnGwRyX3GYOE8BmjpETYqd86IAVfnN0ciISxNdnooNWETAfMwt15w
	aDWDb8YNIUsaVtekerecDRsja9MLx/nykPa2u+Ep8gy/u3nc8IKSE3rHw52bP2JLKw1Q==
X-Received: by 2002:a17:902:e806:b0:2e9:568f:75bc with SMTP id d9443c01a7336-2e9a6c04230mr87982285ad.39.1792468668282;
        Mon, 19 Oct 2026 20:57:48 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea15180273sm7857015ad.60.2026.10.19.20.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:57:47 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kees@kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v4] ocfs2: Pin owning modules for open debugfs files
Date: Tue, 20 Oct 2026 11:57:42 +0800
Message-Id: <pm-ocfs2-objects-candidate-0089-v7-33777b9118b01969d965@gmail.com>
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
Fixes: db02754c8a12 ("ocfs2/cluster: Show o2net timing statistics")
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
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

---
Changes in v4:
- Add the missing Fixes tag for stats_seq_fops: db02754c8a12
  ("ocfs2/cluster: Show o2net timing statistics").
- Add Joseph Qi's Reviewed-by; keep the code unchanged.

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
Link to v3: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0089-v6-f7fda843f80887488145@gmail.com

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

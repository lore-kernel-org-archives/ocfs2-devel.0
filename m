Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AAB6FC5
	for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 01:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791768707; cv=none; b=jnxTj2D6j0iN77jA5Z5NhI2fNZsPB1elRwY39CioECC+GQcSD7FHeot9XIOrZcAiBVqDjE4h6jueDOcPn5Vl+Hd2Xc0D6YvVIGQzKRfxenriGacs+Qsi5rL3zCST15nmTA63qPZyVNcsuXsMykUHCH6x17aH4sHST0nmMfI6XXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791768707; c=relaxed/simple;
	bh=pqCW64MWKKqJ+b5EZyD/nzo8SaOHA3QqAsTpgswNy84=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dmAV2aiAuKQWZleiSEpaJZxu1/12+hKLZXBuQ+fcwi3Zlksl1xRXvFBB8hKkgbQUGsedSk7YVj5/VudV8u/FZXzX21EOHAf6qp/AJZb6wzzm50sa2Yck7niALK/M9vWxP7LanImdAJp+7Dr3X+VF4i4kypYdFr/utcY5FIKlUN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g+GaXSMc; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+GaXSMc"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so1162562a91.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 11 Oct 2026 18:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791768706; x=1792373506; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s9fm9fZTpu/z3C1fJkYEh93qh6MI7pDV/XkQ0dbiT30=;
        b=g+GaXSMcMmkAsV+CjyAmX+tbCiguQU38jy9ebQnojiHqn/k5+11WqQirp2SVUl0GSI
         iAl0Nba2oICUig2kwR5cLLYx2HiMeJBmOHbgCvzEcQTom4mWwDW7NQj2D8bzjPfwQEa/
         d2xYMHIvfU+WiLs7NdXija3nQzusxQmN7KOhPz7Id6FKV3dvFDLdbd8GlkTRxottyDPi
         9W7yLwYF3NX7W/8wT1qvximwONsIksowxRCl6VIFmrEeezegbDGvXj23T7XImtBseady
         FLg2TBt6B7NBNAm0zI9kaXphZhUt5LiAH+fZjoPpEHIALvFPGfZ+FnItk0DXvI32W3xa
         cqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791768706; x=1792373506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s9fm9fZTpu/z3C1fJkYEh93qh6MI7pDV/XkQ0dbiT30=;
        b=2V0vAAAIw5pFVHre3Ed90brKNWb7Oi7Cgc8ZpiNJWQ+ivm4R/UsxqhD+rKmz+ufWoR
         YzfjxlBHn9aETNBICU5Bf1jjeFC6Y20bgx+hAvGTs6DBvaSx1aidN1i6OJVEjtF1MJR7
         4y9EilKkSqGordUqBcUP5yZX0eYCjTzn9rDTWhBqz8FcS3nM1IhFt0RlEg1WXu4Grepq
         YPG7eOoMTTFomCZs7fOD95F0kJlVFrQ3WsV12u50r1/UBDhRkFn8Qj9uY50uS0p1nwCs
         n3f10fpPMP8FjI+boyyH0/mmuNIEa6PjW71yvTaVe8kmElDtPdZ2qNtRjj2iRXRM2AwA
         d6gg==
X-Gm-Message-State: AFq9FYKzoJHTtpx8/WtkpuhRh4ShLyODJR2B/piSPD4MF2TdpCBJ90qm
	JnHhR/bHgrAlmSl3DCc4WAS05UJzMFvHOk1+5oViuLQoISPPl4703BOX
X-Gm-Gg: AYBFou0h4R8BNy2LRBB4GMAfVYllOA+ZFvMPaIATTHH8IflWJBByBzWMudtFNLze0dO
	4pIoLm9/sQeBzhyDyuuASZfrySYPKK1BkjmhXbrvY88NF/Mp3tIRpuvCxIRK9OLUsTA++NVRn8/
	mPZ/rBi7KDBdyzy4RVQdKqtZ+6DcJGembj98TAeFDiU6FEVI1hH+s+kzAmrthLpDq9CbQLcjpzF
	4E5dAUjkvOcoUSbcr58gcRSLUIp/cdpu6z7jpa599cEV6xfXSv8aUhZm3O8kJIeV0R36i1BJhQ5
	5MeAbZ+obbqZGY5dY5W5aTMRPNIl9pp1taKBp1KRKOOMYo9NeQwN5wa+zBHd3G8sZkUXbote9LL
	mfwGuxU/7IUfQWSFNQ0IeRaidk+f3zsk9V3U6+bBOHX0hWlNiyadQT3Fpx8a960OVoh+uMV+MXf
	4R/acVrpg8s7r4eP7wypmXvpSipexNTSsYCIxRS0kfYO5UjN8v6U3vsSAvOCQmT6hI7EtIBJNJf
	tem
X-Received: by 2002:a17:90b:3d92:b0:3ab:36c4:b50d with SMTP id 98e67ed59e1d1-3ab3a3a0bc0mr7646379a91.9.1791768705777;
        Sun, 11 Oct 2026 18:31:45 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab39238608sm14651247a91.17.2026.10.11.18.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 18:31:44 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	akpm@linux-foundation.org,
	zzzccc427@gmail.com,
	kmehltretter@gmail.com,
	ericterminal@gmail.com,
	kees@kernel.org,
	sunil.mushran@oracle.com,
	christophe.jaillet@wanadoo.fr
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com
Subject: [PATCH] ocfs2: Pin the node manager module for open debugfs files
Date: Mon, 12 Oct 2026 09:31:38 +0800
Message-Id: <pm-ocfs2-objects-candidate-0089-v2-4c67f48d4e2d0fc85990@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The node manager debugfs file operation tables do not set owner.
The debugfs full proxy obtains real_fops with fops_get() at open and
keeps it until final release. Without an owner, this does not acquire
a module reference. Normal unload can free the ocfs2_nodemanager
module image while an open file still holds its operation table.

Closing connected_nodes then makes full_proxy_release() read
real_fops->release from freed module memory. Removing the debugfs
entries during module exit does not drain retained open files.

Set owner to THIS_MODULE in the o2net and heartbeat debugfs operation
tables. The existing debugfs get/put pair then keeps the module and
its callbacks alive until the last open file is released.

A controlled test used an unloadable OCFS2 module and case-local probe
filters without changing the candidate open, unload or release logic.
Closing a retained connected_nodes file after normal unload produced:

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
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8e6ead433228..1d4f71190d27 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1447,6 +1447,7 @@ static ssize_t o2hb_debug_read(struct file *file, char __user *buf,
 #endif  /* CONFIG_DEBUG_FS */
 
 static const struct file_operations o2hb_debug_fops = {
+	.owner = THIS_MODULE,
 	.open =		o2hb_debug_open,
 	.release =	o2hb_debug_release,
 	.read =		o2hb_debug_read,
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index f7ab66e70799..5d373002297d 100644
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

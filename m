Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4512A3F4DF3
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792082573; cv=none; b=MPBU3Sv2jZpqMbvFlpDFcDAzpYMc50gv74bDaUpfrowiC8seOFBgafNvmQsTb//i9S7toI+BKkCTmiiU2aO8ZQHRuQwxnkmPMwrOpJ/fCjkokuCZyOayDzqkgh5a60l54Qh7/US2y+TiCa+B4JEQy445o3DziDjKsZZK319z3OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792082573; c=relaxed/simple;
	bh=OTU5FPXRS7SrHUOlR2OvN6NsypIYjQfFMY0pipFB/Qg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=msDuicqiLWbKHWz2Wji0kjulNuOqSPYMZHQZudPmBV+QQwulNaAPb8LIMZU6kPa+AvRt82QDx1t74poPmNs0grvmksK0ij8dGXQirGkXzhscmu1rBG87c+4b50cnl41w/fpgoRVdmleFF86v16XpE6zatIamMua1PR0OVFpOArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dd5vJvJd; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dd5vJvJd"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e5fb79ce82so31808145ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Oct 2026 09:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792082560; x=1792687360; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rhNH0BW2XAjBueCKdT6wW0Wg3sEZITNbVSl2Bvf6yOk=;
        b=Dd5vJvJdcFMrYV1BjSOScbhQWbbWWU3HYEjHb7B/avGSk3/jSqOjMTACxsLjh9m7LM
         yoPS1XIVY7AyRVVGMcvuh/rxYuDvQhKgvTOuDFESTkYgUE1JnObFyqFNS4Rhyr/AVXw2
         1nSayxIE9bIRoGGx75mstUlTxfAHOrL+Uyzz9EVQcx3Aca/2eXOIflPF0XdGMRlshU3L
         +CoCzSWeU1NRprqIkmwcOgUn0jaI80XHcgaQT7cMQnJh7C9WQNbguII+zp7GqGBgIdEC
         9So+IcN2j0O06nlnw7TRFs9rrWdEbAADfuM8a6zDUBASUkZK9539qLf+hAoM15iUwcCU
         pEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792082560; x=1792687360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rhNH0BW2XAjBueCKdT6wW0Wg3sEZITNbVSl2Bvf6yOk=;
        b=BW+FvvajAkND7JUClM4lwY8QurAKVAZgblXtgSvVUXvCKibwVFbjCGWCLVRJP8sBBa
         XGP1f4Y0fHMDg9lc41f0cqBvQPNQE2PdOzBy3WGiHQ2WhwU+ggGcuslQwEQZEwLwLhmw
         bvj0UpeDGqfqf+Xx3qZ5RfHKfauoTcUdMpOVotYw11p9wDb1b1uRrRXpgHjtUJwZhFo9
         ssZPcbMksnFgR4OHbCsp8xjNhcNOtFlv/PkwbdAo76UhK0mhkcSC47odI1LvzSXgoYNv
         L3xFY0z6HtRe4aNPMBwFe2aIWnhnHS4ooVbpQ/xj2wubP8hIMZYeLTUo4cB0O91HyLE5
         fL8A==
X-Gm-Message-State: AFq9FYJ66/3nsEHx45BWMzINN9pmnqx9UqoAFW2dbxhOyQgvOBa/172G
	hDpYqIXBh+WvXVKugnQgXHV8JesITAPLk+tt3Y1U4tyKEIV93quGfVGH
X-Gm-Gg: AYBFou1ejQgmv6Tb3VbouArj9HyysklCE/nfgnR411b1WTfn+1yugjPoGEretfDm8cU
	XWhS5K02IBitjuuk00Zz6M+X1pAxyH6r7nENysUlMxUGbmidwqeprJ0iomWX5qsbvzRx0GwMs9c
	j+DkUL661l6VYhR3Z8usvhp2vAimqXA4h84np82oDXUhaJlqFgZidKc3XZCIGLgwCso/lVDwn6j
	zEitPXRaqiKb6oieARcMoOA51TDHiDQ4F8i0rB8u/4WjQxGUr3ikGxfa4uictQa2DRUzK75eHx7
	sp2dBrZOokuJbloJtFt3TIp0MWokTgZ8J4cxRNZWGHoLN6VbQvucoJqPVamcoUZuvu5SY9pFQwX
	a1d4BCXOGchavl7OtcvhXxYIn1L94e/+0gVjvfF966COzwcKIy16otvW0PAbGl7AATym7kzLWiw
	l9ck8KLKwUHPxoWTDiyC/VQs9lGE2ZDHFI0dlt0/ukV2JJTpnobTz8spblz/+UpItX4A==
X-Received: by 2002:a17:903:32cd:b0:2e2:d7d6:6563 with SMTP id d9443c01a7336-2e842ce162fmr161624375ad.43.1792082560456;
        Thu, 15 Oct 2026 09:42:40 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e4eb2sm85667535ad.74.2026.10.15.09.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 09:42:40 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: Pin owning modules for open debugfs files
Date: Fri, 16 Oct 2026 00:42:32 +0800
Message-Id: <pm-ocfs2-objects-candidate-0089-v5-076c780eeaf45afb2a53@gmail.com>
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
Changes in v2:
- Cover fs_state and locking_state in the OCFS2 filesystem module.
- Cover all four OCFS2 DLM debugfs operation tables.
- Keep the five node manager fixes and the original diagnostic.
- Add explicit module headers and Fixes tags for the added tables.
- Add Cc: stable@vger.kernel.org.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0089-v2-4c67f48d4e2d0fc85990@gmail.com

 fs/ocfs2/cluster/heartbeat.c | 1 +
 fs/ocfs2/cluster/netdebug.c  | 4 ++++
 fs/ocfs2/dlm/dlmdebug.c      | 5 +++++
 fs/ocfs2/dlmglue.c           | 2 ++
 fs/ocfs2/super.c             | 1 +
 5 files changed, 13 insertions(+)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8e6ead433228e7419bfbbe5c7cdde65c654a24f4..1d4f71190d27b2b7fcf7db7b39fefcad5cc669cc 100644
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
index f7ab66e70799302f3ed4e70ab6a8fb057dd0bfa9..9b8e2cdd05ed452f98f95d45bfb7f5865db434f7 100644
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
+	.owner = THIS_MODULE,
 	.open		= nodes_fop_open,
 	.release	= o2net_debug_release,
 	.read		= o2net_debug_read,
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index ce6d301cb9420385211d20d59637069154a89993..4face0bea236748b679571e6ade068658d33bd12 100644
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
+	.owner = THIS_MODULE,
 	.open =		debug_purgelist_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -394,6 +396,7 @@ static int debug_mle_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations debug_mle_fops = {
+	.owner = THIS_MODULE,
 	.open =		debug_mle_open,
 	.release =	debug_release,
 	.read =		debug_read,
@@ -601,6 +604,7 @@ static int debug_lockres_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations debug_lockres_fops = {
+	.owner = THIS_MODULE,
 	.open =		debug_lockres_open,
 	.release =	debug_lockres_release,
 	.read =		seq_read,
@@ -791,6 +795,7 @@ static int debug_state_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations debug_state_fops = {
+	.owner = THIS_MODULE,
 	.open =		debug_state_open,
 	.release =	debug_release,
 	.read =		debug_read,
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6bc4a21cf5f02f04a6b54100925084aed239ae62..b332938fe57f87c3d9a81e3800eed1a25e49de1b 100644
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
+	.owner = THIS_MODULE,
 	.open =		ocfs2_dlm_debug_open,
 	.release =	ocfs2_dlm_debug_release,
 	.read =		seq_read,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 1e76b1d9fe0af4b3cf503e91e1dd077762fef88a..1f6d828a470fb28ccde2e6ed9a82a4ed7c294201 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -387,6 +387,7 @@ static ssize_t ocfs2_debug_read(struct file *file, char __user *buf,
 #endif	/* CONFIG_DEBUG_FS */
 
 static const struct file_operations ocfs2_osb_debug_fops = {
+	.owner = THIS_MODULE,
 	.open =		ocfs2_osb_debug_open,
 	.release =	ocfs2_debug_release,
 	.read =		ocfs2_debug_read,

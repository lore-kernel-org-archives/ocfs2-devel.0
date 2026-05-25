Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596F2772D
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 04:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779682654; cv=none; b=RIt3zzczTxSHh9PTI7em4m/3PGLLrNxO1bQyuA1L3G8RoG5W2e9DdXZTJghRg+cnCqSQ36j0VyrpDNNbjPwOXb5LJt4PnINmoTsSu6yV+s86aYLQK4vXRPU8NhA9e0LpBat71hc3g73pOBmkTIFElZ4seOKPqODVDgHPpAn34pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779682654; c=relaxed/simple;
	bh=nvzaVdb4G58gGd2ReG80hncVf/NPtOa5U1QQGdy8OCM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Fdi1lcO1TtxJK3BoqJhrYWBwQ1pfUlbAdzGwWq5tpIOc06l30nCXMldd9IVvub/AeR8DhxMuJFoLg0LtM/VcSCRzNgmFK7YP6Q/EfPejKoDJMDXIFyFk2qAcLHYOait8LC0+OcQkbId3JV2/MrKbWY9GTGih9aR4cbsxr2U3z8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZIrJoA+; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZIrJoA+"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-36abfe17c11so962515a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 21:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779682653; x=1780287453; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QEPlnSbwf27lwJaVxkFuVjukJW0WKTw/weMKGB11AFQ=;
        b=FZIrJoA+sBqySRRUfvQU1lRgSpdChjCKv4dnV6fHcMmSm1Pw3hjowu2uyw89Q+fwLy
         b3BQidAm0pprKO2SE4P6Vz3Fz5BMjEtIcVVrdm4dMb244QYZ0pZ/KNEkbFWDAmWVmSxZ
         v8Xem6TgwJU6vM1hsdNz4zjPOQP+lT2UWUipK/gTo9maFEphBidyxC/G4abnQdT0fqCf
         FO0tFU6zbwvBohtwDxEKuqjhqKim3AYOyWpcJX7+CrpXzmGTurZp9nW9dCQRcB9pW5WC
         O1k1OYLd1qMFKBKf2ZVx0HAERkLfTN8gEzcW2V6Bv7oYYlb004imjSA1zDuNdhkQsGAM
         6vuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779682653; x=1780287453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEPlnSbwf27lwJaVxkFuVjukJW0WKTw/weMKGB11AFQ=;
        b=PAYtNxDOISUHP0AQxOtFXcLJfGnk5JJqyv3Fd3HK00q4u3i/UChuShL13Pr/niOUws
         E4MK9Km4cGTg1lgqwbJEUAQ+MXEpHNrNN2zfv+bf9iBb/q+ZRXIXxBm41Nir4BDYfzL8
         IB1ZzmdCd3TfcqZWCHJ8F3okeyrehtvnUQEVC484zTkC9SOM96FFmS3JAlMPnKtLQxh4
         QDWJAK/9GgHEA44nKtXYBJk68m6w1I5/vYt4q+TwLGgEfMpYYAmMAdHgBmSjxRl/KctU
         TCwEiaJzHnNmomD6nBw+Ip0mMeuLVRLHa5v51aYsJHfqEunhubxVcjKOWj7wePsnqXJF
         jejA==
X-Gm-Message-State: AOJu0YzcVUHNNQJbterkBECBl4NJk12ulSUkMqrJK+CybS+/1nRAaTxf
	hFahsfBi+srM4nQ8WiajfI1WKDo0XtxPuZSjfh/nNjSBlG5AlvRoDrxj
X-Gm-Gg: Acq92OHp5hay9bv6PPdChxt5VHm4QgW3bKI5NLb5IvlJBGyi6fQgJiabsKP6abtwmDf
	7WQhyKW9xNXBa7EimWq0hQnc8twpGyUpazoVJ04VBlczF21T3XGMYole93ZUl2G1Yk3xara0e5d
	C4WeQve+A0h+dugNccZ+JdPyj5MNx6ECG3SMgas0vMvgDyImyhHuH0c31drJQFP/rKx9jx0q/2n
	iGjRi2C3MzIQE4Lig/7tXEKZ1JebfHGfdC14tu4ZtyL1eZVFRghNbWr4VcAuYudwBpfRtAa3kqt
	BdByhXnzlOV0ZkQTgTc4bNdEdVEqj3dbADvgQ5JfD1bCqRWpDcLn7xiFGtW8EwU+DFktZD9rtn4
	DDSTNFAKj1eV9Dt1lGMDQtGdjn5h7FxVlI3pxmCQZQQRUE4eCpkU3FwghWcFTxK2rTWii4TrCOu
	OpR5I0RFoH8G5SxF9vcAOo/FtnJHueFVTX5SSXTFdePg==
X-Received: by 2002:a17:90b:3c92:b0:35f:b6a1:8d27 with SMTP id 98e67ed59e1d1-36a67626883mr12137058a91.18.1779682652573;
        Sun, 24 May 2026 21:17:32 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a7263179bsm7936415a91.1.2026.05.24.21.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 21:17:32 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v3] ocfs2: rebase copied fsdlm LVB pointers in locking_state
Date: Mon, 25 May 2026 12:17:26 +0800
Message-Id: <20260525041726.4112882-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The locking_state debugfs iterator snapshots struct ocfs2_lock_res by
value under ocfs2_dlm_tracking_lock and later formats that copy in
ocfs2_dlm_seq_show(). That is fine for the inline fields, but the
userspace fsdlm stack stores the LVB through lksb_fsdlm.sb_lvbptr. Once
the iterator drops the tracking lock, a copied non-NULL sb_lvbptr still
points into the original lockres owner, so teardown can free that
container before the debugfs dump walks the raw LVB bytes.

Rebase the copied sb_lvbptr to the copied l_lksb before dumping the raw
LVB. The seq snapshot already carries the inline LVB storage reserved in
struct ocfs2_dlm_lksb, so the debugfs reader can dump the copied bytes
without borrowing the original lockres lifetime.

The buggy scenario involves two paths, with each column showing the order
within that path:

locking_state reader:                  lockres teardown:
1. ocfs2_dlm_seq_start()/next()        1. file release or another owner
   copies struct ocfs2_lock_res           teardown reaches
2. ocfs2_dlm_seq_show() formats           ocfs2_lock_res_free()
   the copied row                      2. the lockres is removed from the
3. ocfs2_dlm_lvb() follows the            tracking list
   copied sb_lvbptr                   3. the owner frees the original
                                          lockres container

Validation reproduced this kernel report:
KASAN slab-use-after-free in ocfs2_dlm_seq_show+0x1bd/0x430
RIP: 0033:0x7f8ec4b1e29d
The buggy address belongs to the object at ffff88810a1e0800 which belongs
to the cache kmalloc-1k of size 1024
The buggy address is located 368 bytes inside of freed 1024-byte region
[ffff88810a1e0800, ffff88810a1e0c00)
Read of size 1
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  ocfs2_dlm_seq_show+0x1bd/0x430 (fs/ocfs2/dlmglue.c:3137)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x19f/0x330
  kasan_report+0xe0/0x110
  seq_read_iter+0x29d/0x790
  seq_read+0x20a/0x280
  find_held_lock+0x2b/0x80
  rcu_read_unlock+0x18/0x70
  full_proxy_read+0x9e/0xd0
  vfs_read+0x12c/0x590
  ksys_read+0xd2/0x170
  do_user_addr_fault+0x65a/0x890
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  __kasan_kmalloc+0xaa/0xb0
  ocfs2_file_open+0x13e/0x300
  do_dentry_open+0x233/0x7f0
  vfs_open+0x5a/0x1b0
  path_openat+0x66d/0x1540
  do_file_open+0x186/0x2b0
  do_sys_openat2+0xce/0x150
  __x64_sys_openat+0xd0/0x140
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Freed by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x5f/0x80
  kfree+0x313/0x590
  ocfs2_file_release+0x138/0x260
  __fput+0x1df/0x4b0
  fput_close_sync+0xd2/0x170
  __x64_sys_close+0x55/0x90
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: cf4d8d75d8ab ("ocfs2: add fsdlm to stackglue")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
v3:
Fix the truncated commit log in v2.
Include the complete KASAN use, allocation, and free stacks from validation.
No code changes.

v2:
Document the introducing fsdlm stackglue commit.

 fs/ocfs2/dlmglue.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7283bb2c5a31..a23dd8f86c89 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3134,6 +3134,22 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
  *	- Add last pr/ex unlock times and first lock wait time in usecs
  */
 #define OCFS2_DLM_DEBUG_STR_VERSION 4
+
+/*
+ * The debug iterator snapshots lockres by value, so a userspace-stack LVB
+ * pointer copied from the original lockres must be rebased to the copied
+ * lksb before the dump walks the raw bytes.
+ */
+static void ocfs2_dlm_seq_rebase_lvb(struct ocfs2_lock_res *lockres)
+{
+	if (!ocfs2_stack_supports_plocks())
+		return;
+
+	if (lockres->l_lksb.lksb_fsdlm.sb_lvbptr)
+		lockres->l_lksb.lksb_fsdlm.sb_lvbptr =
+			(char *)&lockres->l_lksb + sizeof(struct dlm_lksb);
+}
+
 static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 {
 	int i;
@@ -3191,6 +3207,7 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 		   lockres->l_blocking);
 
 	/* Dump the raw LVB */
+	ocfs2_dlm_seq_rebase_lvb(lockres);
 	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
 	for(i = 0; i < DLM_LVB_LEN; i++)
 		seq_printf(m, "0x%x\t", lvb[i]);
-- 
2.43.0


Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF931F0E34
	for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779619666; cv=none; b=Ti/asdRJziccZrUalUX2lCkuvCf3nkzjjCvlP8iDJUxkQiz8xlYdK89T7Gx5xAWN9o9Bj94N3HK31kNTcFmB8QhMtcVYwmZvSSne7mL+kTbUVcxO3z38SzS7h+ss/0ORqoG13tgtfmv41rbgnweTRjWC84zoRm9bQZwVzjzB4aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779619666; c=relaxed/simple;
	bh=7kufMGHzg+Ivvc7YQW474zZbrY+DhwFXmQr4DNqm0K4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=msvX+MsfkRJcH2I/xWUAo7Sq6RpG2n34C3jCJ48GHR/IhKzci5YW0QPH49il2gCtc5S1jDF2ImeDjULkvk0bvs0rVO0pptHWipJusXaTALzE2Sgd5LhuImuqTOnq1cmJMHqGdH+COPFg40I9xezp9oMcRtxE68GiivthfwZzRK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z+UnTjc1; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+UnTjc1"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2bea7176c72so25523345ad.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 03:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779619664; x=1780224464; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gSTBs+CvpCoHZ9vOvjAYBeSJNzUYCx+7KaD800fiCWM=;
        b=Z+UnTjc1BiCb0Ebnb3l+8kDuP10hc+ck7zxuhie9jOhJYbTpZZuJt5CkB1qPcI8SQp
         BtoB6+OiDAKu2Qh3YNiXU00riWbOd/K/oBFT75PQS9c1+QeeI5Rlx4jwIFioZFUMpQUP
         8ZiGOs2jRw9lgyow0GO68vtSa2GbBXalnEY6xVoi52AgfDqKR8hG+S9CJ4NFqnd3Nqv2
         umQr59QbTJoYsuhGieiTfLn3xdRNEqOGZXRcY1BqVnJb9w0gpcqAh/GXljBVmMZW+8pD
         bBHD9ufo+fBYqfUXYTxI+e7CQQPPjfqwoT5Qmfh0OdlCNZYb8HcPQGDplaRj8ApUe4+n
         h2yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779619664; x=1780224464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSTBs+CvpCoHZ9vOvjAYBeSJNzUYCx+7KaD800fiCWM=;
        b=LnDf2/MODZY4P6pgGa2KEHfOmCqYwpw6HhrBtw19fERFNcyp/40oio3Qhm24rvROxd
         3hCNbW9120hg8sUMU99JqXcpn2OIU29QEQY7hGnSUpCaWZb2j6IZX5xP5GdVuAUWuOG0
         9ItvJ+KNdVnSpyJs9uPoU2pEtX9UXxOz+zB2jLHWfQQCU4InCLni2JQmcw5QgnorxPWr
         Iq+WzjUGE6OsypsE1hBuQiScXs18dJpOvIEf3tHcCNiU3emht8NX4xAr2Wz07llyhY7l
         PuqaeSwXIWEUHPF08/1aEy1w6h9i8rss1IvLRuh1wO2nUohbBStrlflAQ6V/OP03dz0J
         cj/g==
X-Gm-Message-State: AOJu0YyfIg4nDNbizj9Pa2k2MXQ1uzlA+7S7kN2W8k8kA/+VCk7koHTp
	dKkI+n/+6SQBu+Ib/YMZl5IAnr4roeMP8SgPZDoPn1AIIr7acGF9u8Ly
X-Gm-Gg: Acq92OHklZUZaMbKy6aFiQtAUrTd1HFZLNidtcIiYPy4X/PIflxIZz5heXl98NKCTu1
	oVN/sbDz+7+eBLp4ZPDGCgC9tsMi2i74hrNvcORYOkt9Zmfo6EI0AWvx0it73jUFyhlegh1dZ85
	1beCbaAvP/I4OO7P87aAZXrrTKcmV9FQzjjXA1pVL4GM2+sHLApR3BU+1NM9JriMDElKU/oI+h+
	lXYAGptn13D5fxLaigmoGO1pDZ1W5rClXln8FAzRn4KgdpFeJ1xCc4xbiXVszSVMLY1uZ4H4HQg
	iUsr8O3VflTCX7DHgcBDKDz5S8EJFY4EGS6V64QrC8wNBxOPsr6aLLIa7n0BI8G7iFkTBOeMdKA
	6q0rlWQTzZ72Liwvk2T9wIYiRtAF7VLNRvCNsweHaPlZ1Cl7WB3Dvm0qmgSdsn76lNwVAXp+khA
	SAeRar4x0eNYuCwk2asKuz3AIVeQrCIPs=
X-Received: by 2002:a17:903:1a0d:b0:2b0:6e60:9582 with SMTP id d9443c01a7336-2beb06354bcmr116069275ad.18.1779619664357;
        Sun, 24 May 2026 03:47:44 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58fd888sm66439715ad.73.2026.05.24.03.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 03:47:43 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] ocfs2: rebase copied fsdlm LVB pointers in locking_state
Date: Sun, 24 May 2026 18:47:38 +0800
Message-Id: <20260524104738.1363926-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

value under ocfs2_dlm_tracking_lock and later formats that copy in
ocfs2_dlm_seq_show(). That is fine for the inline fields, but the
userspace fsdlm stack stores the LVB through lksb_fsdlm.sb_lvbptr. Once
the iterator drops the tracking lock, a copied non-NULL sb_lvbptr still
points into the original lockres owner, so teardown can free that

Rebase the copied sb_lvbptr to the copied l_lksb before dumping the raw
LVB. The seq snapshot already carries the inline LVB storage reserved in
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
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xce/0x630 (?:?)
  ocfs2_dlm_seq_show+0x1bd/0x430 (fs/ocfs2/dlmglue.c:2168)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x19f/0x330 (?:?)
  kasan_report+0xe0/0x110 (?:?)
  seq_read_iter+0x29d/0x790 (?:?)
  seq_read+0x20a/0x280 (?:?)
  find_held_lock+0x2b/0x80 (?:?)
  rcu_read_unlock+0x18/0x70 (?:?)
  full_proxy_read+0x9e/0xd0 (?:?)
  vfs_read+0x12c/0x590 (?:?)
  ksys_read+0xd2/0x170 (?:?)
  do_user_addr_fault+0x65a/0x890 (?:?)
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
Freed by task stack:
  kasan_save_stack+0x33/0x60 (?:?)
  kasan_save_track+0x14/0x30 (?:?)
  kasan_save_free_info+0x3b/0x60 (?:?)
  __kasan_slab_free+0x5f/0x80 (?:?)
  kfree+0x313/0x590 (?:?)
  ocfs2_file_release+0x138/0x260 (fs/ocfs2/dlmglue.c:?)
  __fput+0x1df/0x4b0 (?:?)
  fput_close_sync+0xd2/0x170 (?:?)
  __x64_sys_close+0x55/0x90 (?:?)
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
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


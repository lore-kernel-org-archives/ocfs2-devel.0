Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBB32DF142
	for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 11:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779620877; cv=none; b=bxifLLwik95U+nXXOZD/VtJ7v3oquGtBN9uzeVVX7rJgpHtrQ9zh/My98jyuATv8amBjh5DC1wT6E8sajLXnBSRH32XGHk/gy7HjCs3khgQuxSJclBuv1NK1ksn82DsbaK7y2M2PjDekeXnFT89TTCPT2ZWr6QSsnH+IDRfnTls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779620877; c=relaxed/simple;
	bh=k2gMGD7pi/5B2rr4nutalEDpM7lkesvUPR00Gb+nx5o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FpS2mqDdfM07HduBP0xy6YMsJKG2SGGcerLbNd+B8EcGJBXCTeIpuoRSOwlwN5Byl0QlGEsKC38jUxgbUSY7rO0HMIOK6WbYYLGww4bF1crOZ4Hr+5Xx6L6SlpjnVWi2XoINuaj06aHGzS0TLXkbTwwAYu98X2mn/Id4tZZPUPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bhQDI4M+; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bhQDI4M+"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-3660ab73adbso6206296a91.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 04:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779620875; x=1780225675; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TLZZ7iYZ+Pe7GSh59d0Mo5Ot4bh6bJXCTFg96+FHGFY=;
        b=bhQDI4M+ipbgcDcwQ7PqPVdzRgkyiVTzbc1SW8hECJ7nmwnFCOf5Il29oizlaTtIJu
         J5vo4rk5fghbO8WvMciNWyN5acz122Mh9y+EEMPiUpvkD9f5NbMMf+UJ2T3Z9nbj3Q/1
         nf1vd56D0abYg/viJFNY2dDwiLoq96nUft0bt+6iUknLifl3R0hyz2fdXaX5SRqruIg1
         XtUWorXp8DycdjZhGxt9qyy+36rtxwqQ28f6RhIZ7WXx5fs15rg8wGs1n3vl0HnXTHSb
         li5eNS8pHTIWLH6OCZTl1l8oSyRWoZymg4MTWuzx5J0ZS7RNJHHdF42SLI82w7C7+se/
         sMSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779620875; x=1780225675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLZZ7iYZ+Pe7GSh59d0Mo5Ot4bh6bJXCTFg96+FHGFY=;
        b=hEzKuWHaI09isfm2k9nRchB5MX6NXmIz9ygBJebmAC3n0HmxIRDvQ19Lcjs1TE/8hZ
         oiDmBeocmPe7aj72omxZGkCgjS295ylu/LotnZacSOvkeXNIIsJDGVF/y2TVo1UUfp9M
         Y4kQCJxxKBA8cmkXoJpWJ5+6DalLZfNtridaUwc1ip8vt9WCf8ygXSZmAbUGkoeCJbXV
         FkV8q7M9cKrbZVCoo71pwT8k9H1XbhzQnIEsZVxdcISq1rYanGB4eepcooki3uCX6j7Y
         YuDHmr0s93638zVBSYKPreuH9yA5+UP4NZ7iYe5kHB8UG6LtXw1oakcMWlivocCSWSpl
         6w8g==
X-Gm-Message-State: AOJu0YyMvNMzelDTt+xjoOHaB57WsjnCbsvm3qPq1MET5ataLr0gwMur
	ZFDXq0xu4Uoi4xyrkpUsNi1Nryba0J1W0NfBLABFmaUGz3jJkSBM2afG
X-Gm-Gg: Acq92OG1kOBJlpL/1ffti7qIuzCYszEU4IpGmB7H0QYyodPY9zGRKL+E5dt/Y9dLask
	lsti76RGlxhuwcjspa0QI/JJbP8onWGcgae20k4ofVSDuMfQhK6kH89IaAmt9E3nzrkytx45j/3
	6Ug/E+y6SyIvRYpbTeNfIBWqKFb7iAZvvBWe3KUz2yUPKONnBDoYZrPavNQwgPsQFJevzP6vuyN
	YdXsMmbw2SkvnOTlvE++t/ZT946sspdl+7D9Vjr+rRoJe/S4SnyS0O3k0hv2NsG7cjB3hUAKA0k
	C4mvwsLtVmcGIKysCi8EhKfpokJdQjVmbURLkgX/qaqhqGCog6mXkBPFops0b0HrNHVA2d0/Zc6
	eH21+axOCndbwA37Z2VRdlQh1t73GyCD8LW6F3yd6L/HkZJYPv644mOfY6w+pPMTzo+z0O7BE0U
	SK2NTtoiIJAe6kXwx3dsVazMJTruonhgI=
X-Received: by 2002:a17:90b:560b:b0:35b:d795:cf5d with SMTP id 98e67ed59e1d1-36a6bb5b91dmr7671078a91.5.1779620875442;
        Sun, 24 May 2026 04:07:55 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a7265a400sm6576226a91.5.2026.05.24.04.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 04:07:55 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2] ocfs2: rebase copied fsdlm LVB pointers in locking_state
Date: Sun, 24 May 2026 19:07:49 +0800
Message-Id: <20260524110749.1416771-1-rollkingzzc@gmail.com>
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

Fixes: cf4d8d75d8ab ("ocfs2: add fsdlm to stackglue")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
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


Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B69420468
	for <ocfs2-devel@lists.linux.dev>; Tue, 13 Oct 2026 01:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791856748; cv=none; b=NXRD0hfSRzM+GapH0VhRTmQuhwbCiQ0uxHqHGLI4k/9Cyc+jsqtiQoRkNR3GQ32khXv/Jjh5HfeO/xighpCwd6c/4QzakJTaAFOlhd8vHzrPdfaI8eXE4Vo5zvceHj6kSaEI0n/qt4Ib3RgjozMUpuEZz049vs3zSbB8R+hk+qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791856748; c=relaxed/simple;
	bh=gdrhrrhojiYmNOqh2JvMQwXyKcDnKZ5DGo+JK3pZzbk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G6xgQL5Epn93MHbqPsjPuf2kNabrE0g16qnFabNYoEiNVGv/0AiLkX//baxBs2T6ZzrPzcbrhFNlBncJJuD5frfy6s/kpJz4oKKOpXb+2qjpqvH81mcV6KLoRFwE1ckEel2Yq8oLPttRqmgcRSMLb9igsE/P444mWk1TO7E0ziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kDWg8HvJ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kDWg8HvJ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e87c66e556so9959725ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 12 Oct 2026 18:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791856745; x=1792461545; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VulKwxghGCCa25Yap2OP81AUAKiRy4s4zXpBxbouW5A=;
        b=kDWg8HvJaI8Bn+zrmnWUKBAniT3x3jdFUJabq5fZ7JWYTJcNV9bmogI+1q6DHH2m9x
         qVqEIOkKCoXHH78+h193RLPRxMXpn9MI6A4tv3c6m9zOuRcZxHbkspJyADx6CtrTfYzM
         3Oh+ktWaO79NtXQtLXmgZow4aibyrpsQfaz3GPeXpuMwdkNAKWvIgVtksfmZq+/KmS5H
         f15NrpkgkA24smc8wYVc7YcP8XkTfgX5gQgKVVZz7vcZdB/5zqQgYlwa6m6MbFPbb8kc
         X2tTJwki3j95qSnsTi7Z9SgZ7Wqc3eUPrx3P2tQZI8KDHlkGJR7ZV/xgA3w0VYMGGjCm
         9y9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791856745; x=1792461545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VulKwxghGCCa25Yap2OP81AUAKiRy4s4zXpBxbouW5A=;
        b=uIM9Mvu9pHLitjBGt9Fe4dYuzyfUZPzHj8iUufXNq7wPa7gd8t1/tkfKGAo/85LUlb
         T2pj32ddxk1zqdUbT9ylkrheOrU7rg3ePGacyj/Bu60EcxMBIIdGsRJyEMykepo58xTD
         gwMjcKuZflMGSmpw5yO0xYAafpVjpScTqn/f5hnAS4RGwoFRMQ3+RXeDwm3mgkKn7/iw
         ancCwR7lKMqiM2vEnuRj21F55Wc4V+VMeerQpWucJHtdmCyVrPgMiKzDAIqS+QdoJrcL
         SgRSaAsY2vGyJwHZR/yKdmO8iesSTG+5GIA4nKEOeRFIRc7ixf2x4KtOVIlXpYMXFuuy
         jo4g==
X-Gm-Message-State: AFq9FYLhLC3VxJmX5JUIrpgoFJUk8C3PaLxHE05A89NQZ12g/p8w8EWD
	kGm2f1O3arq5GNFIe0fQVI6GiAMrFCnl7Lvs6id735uErhzl6c7N46ap
X-Gm-Gg: AYBFou2NB1of9MLWnOVw/UTCLnzRB3naCAIcaItTFqQMxYgiSC8F8huv5U4EUiDHynk
	30eiobgcZop/BBTNF97DfolpkMtqmZ+Ilim3o3PNjYnhvLRc5ddKakS8C4sawutGcmjoEEMoZHZ
	wWviG5fRqllQ+/0irbD0yb3KeRVUpy7XHf+AZ/UV8x4t1Iiyv55wh9D9FenEulJTMr2sJP90s4x
	IzDxbRUpaoX8i+zLw1K5shT4Ocjcd3zdWFQ5fs5oidm7MmtkanRU31W3ZDs8SqErOSrRot+SpvQ
	+xFeX7PoaqgmySrd31xwPzDL+O/SuKrRUO9Jlpy5ygea+/Tyjcb/rNSGxFn1xLJjJtFH5C/sqNK
	e7ByxI9G6diPFf3VYX38vh3yv1ArYJM6fvyrCuC54tlh4GmidqXycqCKHURVyi1OSZPHcmmD+aY
	cNKSH7sfTDzuK9xpTah3YstRrx+CJV5OXxLbe3rt+uQ35MJl8UWEi3ZKcLeJVeX1UUXQ==
X-Received: by 2002:a17:90a:5185:b0:3a0:bf71:eccf with SMTP id 98e67ed59e1d1-3ab3a9533ecmr4229118a91.14.1791856744976;
        Mon, 12 Oct 2026 18:59:04 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ff0ce7sm19784735a91.15.2026.10.12.18.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 18:59:04 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com,
	ghe@suse.com,
	akpm@linux-foundation.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v2] ocfs2: Publish the filecheck owner before adding sysfs attributes
Date: Tue, 13 Oct 2026 09:58:58 +0800
Message-Id: <pm-ocfs2-objects-candidate-0086-v4-1b3a3c5fd05c1fb41df9@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_filecheck_create_sysfs() initializes the filecheck allocation
before calling kobject_init_and_add(), but assigns entry->fs_fcheck
only after that call returns. The default attribute group can already
be visible while registration is in progress. A concurrent read can
therefore enter ocfs2_filecheck_attr_show() with a NULL fs_fcheck and
try to lock its fc_lock.

Assign the initialized owner before adding the kobject, so every
activated attribute has valid state. Clear the pointer when addition
fails, preserving the existing teardown guard and error cleanup.

A controlled probe-instrumented test kernel with the original OCFS2
registration ordering produced this Oops during a concurrent sysfs read:

  KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
  RIP: 0010:kasan_byte_accessible+0x15/0x30
  Call Trace:
   <TASK>
   __kasan_check_byte+0x13/0x50
   lock_acquire+0x113/0x300
   _raw_spin_lock+0x31/0x40
   ocfs2_filecheck_attr_show+0x138/0x5f0
   ocfs2_filecheck_show+0x5d/0x90
   sysfs_kf_seq_show+0x1d3/0x360
   seq_read_iter+0x480/0x1110
   kernfs_fop_read_iter+0x419/0x5a0
   vfs_read+0x7d2/0xc20
   ksys_read+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  Modules linked in:

Fixes: 5f483c4abb50 ("ocfs2: add kobject for online file check")
Assisted-by: LLM
Cc: <stable@vger.kernel.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>

---
Changes in v2:
- Explain why fs_fcheck must be cleared on registration failure.
- Retain that cleanup guard and add an inline error-unwind comment.
- Rebase on 35eb6a2f; keep the original diagnostic unchanged.

Link to v1: https://lore.kernel.org/r/pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com

 fs/ocfs2/filecheck.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index be713d7d24a76b9aa8fcded3d83b3d91d124eb6e..75334e4bd0823fd8154717290bfe57d2e5198176 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -179,17 +179,20 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
 	fcheck->fc_size = 0;
 	fcheck->fc_done = 0;
 
+	/* Publish the initialized owner before activating its sysfs callbacks. */
+	entry->fs_fcheck = fcheck;
 	entry->fs_kobj.kset = osb->osb_dev_kset;
 	init_completion(&entry->fs_kobj_unregister);
 	ret = kobject_init_and_add(&entry->fs_kobj, &ocfs2_ktype_filecheck,
 					NULL, "filecheck");
 	if (ret) {
+		/* Mount failure still calls ocfs2_filecheck_remove_sysfs(). */
+		entry->fs_fcheck = NULL;
 		kobject_put(&entry->fs_kobj);
 		kfree(fcheck);
 		return ret;
 	}
 
-	entry->fs_fcheck = fcheck;
 	return 0;
 }

Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
 

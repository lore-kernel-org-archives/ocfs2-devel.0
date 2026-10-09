Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258674A8406
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 10:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540305; cv=none; b=Rs2lA7HALRAoyhddbrFRhhR+c8Pm99q/B7ub8rVYyg+zZsDYAJWora2HAMw+0O/Q1TDiDdC+IgprNxiZ+6rox5zR0AY6j2n6KPXPfXaOfEF19eJHwQ2mtVG4oGfCDasbArnk6LnjJE/1hGJZcYGdZajOLTxGy+WeEEkf8Y66ulU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540305; c=relaxed/simple;
	bh=zeWR0WfokKp9ZtwxmTpL1MQF6hizvBIjf5JyD3r1Rd8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s0l8wWFQkJp7z73wQU/lrofuF4f7yRDkH19Un8gZH+Ed9FmFfEPZbggKLcQrhzFinoNUnbajolCz1faXfUZbqq8AuTNgPFBNbdMFie4ObGIJ3d7lKX8EkzGUPnsCUYb7agcEmR4ix+1x+TJ0nFl5KQU5L7RO4IsNI0/yTwTbKCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sh8DzW1u; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sh8DzW1u"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e81738d24eso12202965ad.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Oct 2026 03:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791540296; x=1792145096; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ogu/BtajEQWyJ3zFLux+gZr1Wq4ynKnt7QP0d0lnwTs=;
        b=Sh8DzW1u72/lcsiNayb/dd5sIaR1ws4N2Ce0wkM81WZZxzbfL0TVEQSmElTYyBpddm
         Of6YpjfAr2rr7OJElhd82g/JjnxwLfUtI0nRct0Xz1hqYqgy7S8bSWr2v+llhRpBAGWe
         FB743wC2mpwnAFmqF47hkiYjaWorHGTSrgcU1GWNx8F91BsSaR95a2JysYmjAnPEFuoE
         cUU278gbY/5v5KCL1mRnSIQDChegzF3w1Im5SBKnW1Vpl8S9V+MGEURyULuBYT++qdxP
         23cGz7GZeiK+8CRjluQJ9O9/hSasrauxHDg26cjhGrnjlaycNdgsC03ucvbrzjVJBYwg
         2DrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791540296; x=1792145096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ogu/BtajEQWyJ3zFLux+gZr1Wq4ynKnt7QP0d0lnwTs=;
        b=Urd6X/mFNU7O559hsbzmPR8orlxAK5m0ZZaIEq3UtnPWF++ZWUZ3uwFqojTb1inL4t
         r76o/0b+hmKi0SD4nd88/YIQTT8FLmako9nMaTKC7cHk3JHDDuhyUK65OZF0kbdT9Mc0
         48/a01fwHtXBON9Yvdac9nLkt/eqhbLOid0IKKclqOJ1Cr8G9jcSNj4wVK6ThMxSG4nq
         tnzF6srqf6SnMkN8+bFhkFoiZq0xSnt3cUjFoNb7u8Eq7ntbWUF66IAuZQAggpnyJXaJ
         3DV+37Q/p/aM0UbD1+fbQJiGb0XddKd0YBUIp+fyCl1RQYQhNTOpufIgBRWuJ6DPIXQU
         t8EA==
X-Gm-Message-State: AFq9FYIVG8xLkxsQSeOTVnzfb1lllM8341j8LLQTeB6KOSrx1PTcGWig
	v5jAKq+OEn5U5kxCYDty9gIrPgIZaCSKyvkUPfTm9xyiqYVWp4XPVcEG
X-Gm-Gg: AYBFou1QRSYgzVFVeYZ6GDM0lh5AXdncVZQ/euGhv6/LaWNzapOf9svzoTyI6Dp35zv
	vxxtfulaHK568xaqHmrc9NqNy6ZHDUTsMMZdLQPvqdfFmer+3thr1FHKEyno0m6McxPEsE8LsqN
	g2877a4ZBPoGg5ZxrjhB35yEZ7XeZKrxAbNaDtdHzbgO46dsqbGD5as22qOiQqttmhOjM9zcAvQ
	gAB2JxEXz1QklUXLjsH258ElPpbKPrKUWp41ELCdO8Nj5ezXbWIhr5EE5c1kA7y4/s2HfOwjGyT
	HYPYqaa2CgFvEpLPtg7H5BZHi6QY2x9sWOBLXzxygkSImFKoo6IRuBeo2zLJjYcuCiFmbNiGHvL
	dpx/TE/lhbsIDiObI0pbOHvypd/h6wt4CR3s0mZhh1wdPMeIMwmtB4fkrME1cD4SzpulJCnvMF8
	Ci3HAsAC4YwESqMGJOik+RKQrr/SeBzngUVYo/bOHqJOim3wfyu0aU8BdKjfj4BHHfHg==
X-Received: by 2002:a17:903:17cc:b0:2df:a972:e48c with SMTP id d9443c01a7336-2e842f37fe2mr11158855ad.55.1791540296059;
        Fri, 09 Oct 2026 03:04:56 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e1643sm6131975ad.70.2026.10.09.03.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 03:04:55 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	ghe@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	jjzuming@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] ocfs2: Publish the filecheck owner before adding sysfs attributes
Date: Fri,  9 Oct 2026 18:04:49 +0800
Message-Id: <pm-ocfs2-objects-candidate-0086-v2-646731c4254a02823b4d@gmail.com>
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

Fixes: a860f6eb4c6a ("ocfs2: sysfile interfaces for online file check")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/filecheck.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index be713d7d24a76b9aa8fcded3d83b3d91d124eb6e..862c1ee7099c943b2e3e57e31f887380c6dc8a88 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -181,2 +181,4 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
 
+	/* Publish the initialized owner before activating its sysfs callbacks. */
+	entry->fs_fcheck = fcheck;
 	entry->fs_kobj.kset = osb->osb_dev_kset;
@@ -186,2 +188,3 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
 	if (ret) {
+		entry->fs_fcheck = NULL;
 		kobject_put(&entry->fs_kobj);
@@ -191,3 +194,2 @@ int ocfs2_filecheck_create_sysfs(struct ocfs2_super *osb)
 
-	entry->fs_fcheck = fcheck;
 	return 0;

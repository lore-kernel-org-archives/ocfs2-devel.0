Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E514C3BE65E
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775732340; cv=none; b=Y0ae+fKdClYNTiBv2CoB6J43in23xPfRfYAohO5HjJxZKuZ6Yn9WDpyDcPG74zNYXt8he5yCwBzlwkXAbJh1YxD8+jwGXSSKw8hvSOUlAZ9d9k6R5I0OQ+x3EonxBppW1+GqoXKAK5AC7THjDroM14+UX2Tsf3WUqJn4j60Xe/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775732340; c=relaxed/simple;
	bh=QiCJhquUE3eKgN9dpSpylxp1kIMi6GJEaaVHVMTr3VY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NspJHtUmdWWaW1wb4NR8O2WW9RfwjcUg5ZQiKa68YEUz5hiXuh2XMXgu7UFnOgcQ203dFwJAZtPU9A6X4HNE9OoL5xJ7VUbEMlbrbI3kbfI81C7wphDcWDWNpBT6AKTIZVysA3KH8JKcZOCfU0TuEs6iUjgJa+ZfbrB/ouU4QgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JXJ3RUVo; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXJ3RUVo"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82d03827316so346754b3a.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 03:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775732338; x=1776337138; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c5CvpgPvJ3ra5jpJbzJWtxkirX7PYlZGGCkjAtCKYS0=;
        b=JXJ3RUVoIN1h7dnVl6Ksrt6LQ/LbGIJKDmzuvOlCFhCLTcO9dumifE58oP10Z9y205
         R4iePE1sxjbCipj3EPW69+OJ2q+/KCgFOsRRm3Tv2gTb1aoStjJ+k4uWxosvLkvZ0BC0
         F/V+IFzNeYhjM0t3e11OdL3ukD8jKVlu6V+lORcgft4kkNEOi9d/oszKb839l4Tn+VVM
         0ebTfl95r+vhPrqkxRq69axmgzlKHRPrgi0zO2MKTtYTNzeuqA3ReMkJg/7Iq/3q9f7M
         8Bue0DNVJ4fNaEhtmPce2X0wzPa0o9e08bVO7n3JEIoZCVpquvXEMqTyEECybDD9gsz3
         k3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775732338; x=1776337138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5CvpgPvJ3ra5jpJbzJWtxkirX7PYlZGGCkjAtCKYS0=;
        b=SqwW/GrdJYXHT/0M2ySiskkhkTRnJkDr7svjs7zcu0JrAbXvHya2i69IpKVf/Od41v
         iGAXL8xrmpAn1oEfiaQ/CS4vWbE7i+wJmoRydna9eNJKbE6cAYZKiAQydp1QxqgFUMnm
         th6zDv6Cv/AQTSSdvd3v0HYfkxBCPZbs++jnrkDFZS4EDMgvDtIiAsct0yMAeLBUU20+
         wiObZAgegKiZ8LX4D1aAvFj6c7+6Njp36LAfp3UrpkuKeRMlVgnxrg31pwjheC+SPpM8
         icaIfWYi16tQCCYBaYLAZPcUAnxY4/D1orZGK+9BDDves7bGLFo222Yhjr/UGJmLKcJ7
         LE6A==
X-Gm-Message-State: AOJu0Yyq1JewMmNFrOnevcUeh5/tmkMKVs8gYrQ6xNDcNUWh8RXShHoz
	eBKv9ShVpqtYcQR5Cye2Cr0AtPCDe9pKhkMSwqEQObHQxj4XuuRtpHXN
X-Gm-Gg: AeBDieuFKBCQHtSbaOMMGuBFvq/B8Bur/sTXODqK60MKGElgumCA4er/1bJkVXSJB2Q
	xXRdiIPqEfMuY/ksYclqI5BU7PGMsbqm4nhTuhwJAlNAYfRN5sQunGJM9215hpiiR/EIe6NOjIE
	l4qGoWE9isKXcFqrgi7ghbvjY2jr9nt1EE3ofXfGQjF1PzH2ON3TsNV7SkZSqz1u58WsBTb+/Vn
	bW8fWLyAUHJQgWi8o3iWVpPLVsCQ+C40rYy+0QD2zO6SwCtcuh+5mosiRgVOtpb9d+zebRUNpQ3
	fFCewNPMZIMtrnNngvEj54Tyyvc9sg4QmFqM/R2ixMFXRewyq0x4tZcLmZAQzls4trUwIkbz5lE
	wvVNcIuSgk5pPPW+doIcp4L/5AxgrV4mZ0Vrtaf8Ty2offfPg1wa8H7yb+mT7syX7vJU0a4le1B
	HjfCwTWsAZbAXpa/v51HNt5z9iYVaY/pN2EbcYYfSQfa+DxvRmgDgpWroH8tZDPH2uQaFc9Q==
X-Received: by 2002:a05:6a00:2e08:b0:82c:c390:ad77 with SMTP id d2e1a72fcca58-82dd8a1dbb5mr2728823b3a.7.1775732338058;
        Thu, 09 Apr 2026 03:58:58 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6fdd7sm23943961b3a.48.2026.04.09.03.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:58:57 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: handle system file flag mismatches gracefully
Date: Thu,  9 Apr 2026 18:58:35 +0800
Message-ID: <20260409105835.3474103-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
Mounting a crafted OCFS2 image can trip:

kernel BUG at fs/ocfs2/inode.c:609!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_read_locked_inode+0x1038/0x10c0 fs/ocfs2/inode.c:609
Call Trace:
 <TASK>
 ocfs2_iget+0x7fa/0x9b0 fs/ocfs2/inode.c:157
 _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:142 [inline]
 ocfs2_get_system_file_inode+0x389/0x820 fs/ocfs2/sysfile.c:112
 ocfs2_init_local_system_inodes fs/ocfs2/super.c:491 [inline]
 ocfs2_mount_volume fs/ocfs2/super.c:1756 [inline]
 ocfs2_fill_super+0x1330/0x3cd0 fs/ocfs2/super.c:1083
 get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
 get_tree_bdev+0x24/0x40 fs/super.c:1721
 ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 ...

[CAUSE]
ocfs2_read_locked_inode() assumes any mismatch between
OCFS2_FI_FLAG_SYSFILE and the dinode's OCFS2_SYSTEM_FL bit is a pure
caller bug, so it routes the condition through mlog_bug_on_msg(). A
crafted filesystem can violate that assumption by making a system
directory entry point at a non-system inode that still passes generic
dinode validation.

[FIX]
Keep the mismatch check in ocfs2_read_locked_inode(), where the caller
context is available, but replace the BUG assertion with an error log
and the existing bail path. That turns crafted on-disk input into a
failed inode read and mount failure instead of a kernel crash.

Fixes: 24c19ef40474 ("ocfs2: Remove i_generation from inode lock names")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/inode.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..0a60de5d46fe 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -602,14 +602,17 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	fe = (struct ocfs2_dinode *) bh->b_data;
 
 	/*
-	 * This is a code bug. Right now the caller needs to
-	 * understand whether it is asking for a system file inode or
-	 * not so the proper lock names can be built.
+	 * The caller has to tell us whether it expects a system file inode
+	 * so the lock names can be built correctly. A corrupted system
+	 * directory can violate that expectation, so fail the read instead
+	 * of crashing.
 	 */
-	mlog_bug_on_msg(!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
-			!!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE),
-			"Inode %llu: system file state is ambiguous\n",
-			(unsigned long long)args->fi_blkno);
+	if (!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
+	    !!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE)) {
+		mlog(ML_ERROR, "Inode %llu: system file state is ambiguous\n",
+		     (unsigned long long)args->fi_blkno);
+		goto bail;
+	}
 
 	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
-- 
2.43.0

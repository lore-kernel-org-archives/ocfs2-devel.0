Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C56B36E477
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 May 2026 02:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778553711; cv=none; b=QJBuIAgGkkDEHM2qKKxm6dBhYW6xxEQxPQT/EscDeLUE8EKMudueBanzlTp8tBVAmANSTKgC5sgoegyKFFrsQAYSwsK8rYdWupoWiKO9jROQJQxzNBOJESEP+wklhi/gFOqUl9gcSNxQHYAtsPPyHbKnKs99dG9aGI6TSKEssE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778553711; c=relaxed/simple;
	bh=5c989E85hEFk7TdblX10kDlQYvbompQir8PjfNzJeIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iVB5J0+IjEsWFQ5u3712WPnC2dmbzdOiFrSvv1jPLSSOLKmZmRyzJB9LzpIKHKuK0h8EO/quKyzEczkt5gfjhKjyyLSV0SISHMWFCsuaqqPyuRqgUOnLHiDTRvD+09IAFkIqNc1TJ5n96QiOJSj5fm8++3XwzeTHdgfqXyWVnfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3EHzUop; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3EHzUop"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-362e50b4641so2983005a91.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 19:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778553710; x=1779158510; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8eUzOs74h+dHsN8FmzNvVjuwaojaqocv//w7199OsQU=;
        b=T3EHzUop1xS+fCNm1/zh417GBnNepoEzF2hfRneH5E38JCteLLoj0nf8ZTRr5O4Dyi
         4pebF9b4jg8TTCoFrXsRtuUthjVYaRIwWbEE72DJnZ0MPm66VtdqtXSm8zyPUvjXpTB6
         SBIQaABtN3gpVAHBkDSOCMPh8Cs+v1IzpxZ0rnDmWYJpC6QCVAIAdpC+wddNsF9oYQQu
         PzPbNVAkp5Y8J5qeqkfdy5CkmleKvRFe22g8cen3I4a3/Hh7ZVq8owK8JM0B2VxNE1Kj
         poROSmJM44R1+ETMANoqmhcDQYfDiEF8vuNYPniTh2JKps9GQSr+q4tx3/lgcXoUQ7c2
         CpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778553710; x=1779158510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8eUzOs74h+dHsN8FmzNvVjuwaojaqocv//w7199OsQU=;
        b=Q6wGa1zv2ld5bmBYaMbW99+DIFGnHR9axXOCXZ39IfBcL+LfeFP39KIO1JQaqaj6p1
         QTgaWs8x+5Ov91Qk+NSjjkJDmbFFqDUplT5sUOCw54Sdxs109di07BICIOABLKdKbzbH
         WJF8xFzv9OGf0ZMIj/ED9eQO4/BiEYUp5hRLrKrrWN36rAJSj731oAFLPoh54hS06U27
         LIlq0wIvXs6ROoD+20QKgBX+Ne7rdW+w5ljDdk016CHBdcuQSWnvZbqZlzsqNQQgzF2L
         wPQ2lc79Sc0TZGAWUJrVdSw+zBcVVQvHCLcvZrZ8QbcC5sOnWYI38+hrTepluO8fw22d
         TVNQ==
X-Gm-Message-State: AOJu0YxJY18YWcPb1fQBa5c1QBwx2yq64iTx/epekZepvbwX+4nvf1Dk
	stT6Lx9fg+JtOrXjWFybXLc/KsdgttJe1YUPBihSrhzsat7ajwO4ut5f
X-Gm-Gg: Acq92OFXTneI09u4EFCpcDhXZGU2lNQZ4jn/XJeNpYGkGBwvrkIhTjp5s8nr9fLPEYA
	VbRdQcwKzJDvV+9wnEJYAJDhTq41WtOqVZlkaUsc4npfAmnWhzg5V8p8bfdq179VhQJUwEUr6IS
	fWoLiS22sAAjSgO1L2WDoPd969Tqf1aDIkObTvh9MXPpqzwRX22jP3ErqE97PAMei7db58R4a/k
	BweUyosi/tpfLTAvvY75nceDn/2GSZUyfII+8hYxOUoo0KH9AjbmA8Rly9WuWiw+XesNIG81VJc
	u4oOYhBwYyUUVsZNVg/DSRrmfalJai/3dqwZf7dS1gALmjBs3QQ31spjvpOZyDxYwlkTOVTmkYs
	AhQuETiMEc3u6kSmp/gOvAVeBDtIUJ8LYRjn6+bEGUUajRy5T7ai2XUNh/D21OgfOrQcW3Djs78
	HW+NoJ+29Y+1EcP4wE3g1LNyl0UoT6+IW4QQQyfWBAUbx1mfOF07MyjFeuIz8CSZ0X7w==
X-Received: by 2002:a17:90a:1001:b0:368:78da:803 with SMTP id 98e67ed59e1d1-36878da159fmr3382805a91.12.1778553709617;
        Mon, 11 May 2026 19:41:49 -0700 (PDT)
Received: from gmail.com ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d628474dsm9284539a91.8.2026.05.11.19.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 19:41:49 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: don't BUG_ON an invalid journal dinode
Date: Tue, 12 May 2026 10:41:15 +0800
Message-ID: <20260512024115.4036371-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A fuzzed OCFS2 image can corrupt the current slot journal dinode while
mount is still in progress. The mount path first reports the invalid
journal block and then crashes in shutdown:

kernel BUG at fs/ocfs2/journal.c:1034!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:1034
Call Trace:
 ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
 ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
 ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
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
ocfs2_journal_toggle_dirty() used to return -EIO when journal->j_bh no
longer contained a valid dinode, because the startup and shutdown paths
already handled that failure. Commit 10995aa2451a
("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.") changed
the check to a BUG_ON() under the assumption that the journal dinode had
already been validated. That turns an unexpected invalid journal dinode
during mount teardown into a kernel crash instead of a normal mount
failure.

[FIX]
Replace the BUG_ON() with WARN_ON() and return -EIO. This keeps the
invariant warning for debugging, but restores the original behavior of
failing startup or shutdown cleanly instead of panicking the kernel.

Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Drop the full dinode revalidation and use WARN_ON plus -EIO instead
- Rework the rationale around the historical BUG_ON conversion
- Add a Fixes tag for the commit that replaced the old error return
---
 fs/ocfs2/journal.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f9bf3bac085d..fc54cc798ce3 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1022,11 +1022,8 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	struct ocfs2_dinode *fe;
 
 	fe = (struct ocfs2_dinode *)bh->b_data;
-
-	/* The journal bh on the osb always comes from ocfs2_journal_init()
-	 * and was validated there inside ocfs2_inode_lock_full().  It's a
-	 * code bug if we mess it up. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	if (WARN_ON(!OCFS2_IS_VALID_DINODE(fe)))
+		return -EIO;
 
 	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
 	if (dirty)
-- 
2.49.0

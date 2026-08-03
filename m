Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222D1DDC33
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Aug 2026 03:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785726049; cv=none; b=Jlu2z8YkVm5IrR1OWbG/xCbY3OaUK4rIevQpLKDjJROsDdDAskiGaPwT6IUJLUnMeZJzH75lsmcvulK2ZkNPSqXKYrtDWO4sFQJXM05wrkdOq821Sp9jA1M/zVYlVIV9gb6xMOuj+9NDVEZD3xNqGCowhZHyscW+FN1m+ATm7Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785726049; c=relaxed/simple;
	bh=IL4PPdL89KrYlb+3vsLpx0jYYpLzXSAWBppKnDP13KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hw8rMNPrA9xUDqExslzmcFh/RetR8pKMHs57E+wZAysqx8SFPDuZVfnz1M9yPKGfQ1lHjs8Ekg7l5M1WHcinQyt9LcAvtFYj8TRHiGQlb8l6fT1Wy+6HpyxH6sD8OqSsO+/emWzZjUNuSDEt7696O0/bg2Nu5qiPZ2hdZqZKtdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oipfUuvs; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oipfUuvs"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso2408942b3a.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 20:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785726048; x=1786330848; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X9ddKkl1cDb08a4csiFm959vb9khfkPCLClK+RZwmRE=;
        b=oipfUuvsV5m9LXJxxzbDg/IycWQtbqu8X3yCfwe4YQAaUQip8JrJJzZJ4lAXM/JgH9
         ttbm5GdVoBxkelaRKHB0ILvTE5xWumDm2om79ymCV5zH3WOG6/HVVT3XpSPAbwSPnI1Y
         qP4FDvw29Ajpt/SXRMFOFtJBJn7Hq2Gc6JMIMxiSoMfm/PcCW6YOIY4Hh7XXJQxX8YHC
         buBOLjujDntIqKLHzZBF6UImlu2yqxOaXQrlzVa2pfvD1GJMcTUwTcgJIfdoxX8Hdtey
         dxtDLd458Ytw5iD8wnlSuRdikKSgH0ah8uQmyDv13jd1wD1Sl/93jrJgUSw3LIkJRd4q
         J0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785726048; x=1786330848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X9ddKkl1cDb08a4csiFm959vb9khfkPCLClK+RZwmRE=;
        b=N1peQlOsLAAaFm0eWvbshVHwl5je7UWsLSLVEtMePfz4BBEwPdNPSWMujqsS2RSRRi
         6TLK47Xkk9Q/Yd5ZcFYqTxNxL2LCWA0Aj3hv1i+WqP+eQN77HxhZPVvJss2342MLv9p+
         RwPOHbmHQ3wt2KXhfb/SN+u9/j2FnX7QYFS+h7tLFAb5TV+O/CwT10BX58mCRmWd0hfN
         kK/wSO6YQaS/eyW1jZi3m1WmyZb6Pe81/BTKUTV1H0jypz2mIGVB6hL+05jrhdEkcR2I
         auqmAyBVxScOjjE2lkIz+Dqo8I5FluV24ApTMDJyfuHJ4/RF2NoyH6E/h0D/7QO1ZmWk
         Zz/g==
X-Gm-Message-State: AOJu0Yy30VakewFgVFvJSf6gHmGyxb6GsJyznUiOCLil0I7qgZsTpEGn
	4FfbMY1JxzQxbRtwJ04CGvX+gfJ1uNh8a7L70PuijXjJAdDPqkQ+N3+E
X-Gm-Gg: AR+sD127+oY8Qy/z1L5zcSTXiilqV2vpfzb9Qt0arMOvL7b8oHHcqZer8Y1IqZvkb4n
	Y+D86eEcWlb2J0soPDMDGfQ9AZImYkXIWwFCWOm5sc4mzianbZ2Gea4A0nuH/BVNS1iQODhwXZ+
	bAz1PHPVwgB4OThauU1t69Wv/DT4xaUa0WbUPoN0m4lAxWyqKxneafx+qV3jSiTvcekmO7UTX4Z
	7DH/hOUGLRY22QPZmVplwpz/aagwnlgDXEkb+IiRvxvTZMA9kGbABYimnaM8JNYiKQhzOW8Zs63
	A6qoS3/35ZH+LixIYlTz1LNXIAv1xf0TKPapDnx+icPUYneW3+dMh3MOWZkkyVRLXbGEXop/t0B
	SQ3P4TSXgFSkxf4rX+fAFaFNzFCUwDS3QTQ1MCLFvXiPb9RhBTHyQR9PbiUxL7q5sJtlZ/M/JRw
	b8EHhdnxl4ETLRaj9hmTITMPk+nx6viYj5PKu/F8C0H+5xgL8Zqi3TEo7HreMrI4xm828t4m2SV
	G7K8D87VXqmx5fXnph8pGfPfn+jeA==
X-Received: by 2002:a05:6a00:22d1:b0:848:7bbd:2851 with SMTP id d2e1a72fcca58-84ed74bdcf0mr8930419b3a.29.1785726047593;
        Sun, 02 Aug 2026 20:00:47 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc29f2b9sm2962878b3a.35.2026.08.02.20.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:00:47 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	tom442288@tuta.io,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH 1/2] ocfs2: validate orphan slot during inode read
Date: Mon,  3 Aug 2026 11:00:06 +0800
Message-ID: <20260803030007.3993199-2-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803030007.3993199-1-gality369@gmail.com>
References: <20260803030007.3993199-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted dinode with OCFS2_ORPHANED_FL can carry an
i_orphaned_slot outside the mounted filesystem slot range.
ocfs2_wipe_inode() uses it to index osb_orphan_wipes before looking
up the orphan directory, causing an out-of-bounds memory access.

BUG: KASAN: slab-use-after-free in ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
Read of size 8 at addr ffff88800b767c00 by task kworker/u8:3/85
Call Trace:
 ...
 ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
 ocfs2_wipe_inode+0x292/0xf70 fs/ocfs2/inode.c:840
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x6c9/0x1170 fs/ocfs2/inode.c:1295
 evict+0x38e/0x8f0 fs/inode.c:810
 iput_final fs/inode.c:1914 [inline]
 iput fs/inode.c:1966 [inline]
 iput+0x55b/0x8b0 fs/inode.c:1926
 ocfs2_recover_orphans+0x610/0xe40 fs/ocfs2/journal.c:2374
 ocfs2_complete_recovery+0x5af/0xd00 fs/ocfs2/journal.c:1373
 ...

[CAUSE]
ocfs2_validate_inode_block() validates i_suballoc_slot but leaves
the active ordinary orphan slot unchecked. Downstream consumers
assume that the value is smaller than osb->max_slots.

[FIX]
Reject an active i_orphaned_slot outside the slot range during
dinode validation, before the inode reaches orphan wipe processing.

Fixes: b4df6ed8db0c ("[PATCH] ocfs2: fix orphan recovery deadlock")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 41db7dd39ed9..358ab3535366 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1528,6 +1528,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
-- 
2.43.0


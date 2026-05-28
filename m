Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117EB3FF1A9
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 May 2026 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779981178; cv=none; b=ED8dtaB8dONuggokhWQ94EVnK5+sap2BwWrCu2BVQbviJZ/XJ2pxCTgmNkcYs9oNaUv5b+0x5xy1scAwAY8cNDjJccI1w1aJ02raD2Vexwr8peCZI4WACcfAREc4oDhDoGvcZExFDmJLJ/qBfrLBGzEWHYJVaaSo3Y/CPstCiRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779981178; c=relaxed/simple;
	bh=HDBiHdYCyIKy+OuWxPaBBwUmPAehH3pi/cLEU4sqbYM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r/c7VRHQbvE1qgfmZ5uW/GOIgvJaU0jcyZO/BippDzi8bZ8Ze5IYaV8D0rUP42WpUiEiVsHaAw4Wv0E3nCtZfQ3oBWiEzM3iec6EudBku+Z3/+06B6/Cc3hdN8hOOc2yjLobPDppTlrH9/b7sfdpt7WoTw58p0l4Ix1BbiRz0Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mxHoiWjW; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mxHoiWjW"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso144606375ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 May 2026 08:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779981175; x=1780585975; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FY1oEZUaPSeQRzlw+wuEBoMpewNNBX067H9SykvETM8=;
        b=mxHoiWjWRjGDyGkfujjgZmmzTIIpsJmFktul7IfqwwLrg7FfQqrp2KiRFteVpS+01P
         79Z23kuUSYHxrExn+qDFqmQpHCRCCL+318T6mZzSLSaoW1n+VBzTLGfjOIDwbRxaHdGM
         Hgd0Kz7yy1b9z83GtOqFz1JbfFHiizFoNzzpoPsaFuPhVOY4irQQ9liwRj0CIyoZXE80
         rsUNxaJNIIOqpgo4oEZwmYhl/oXaDrbNjDHhGBffoAKm9qIMSe4MrqxDHEbkO354ygMR
         7TWM+O5tmQUi2+glero1ZvCf70kvvLjOHQN5nyon2wd2MeSxQl/UH8lW/E3bTu3MdYFe
         mNkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779981175; x=1780585975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FY1oEZUaPSeQRzlw+wuEBoMpewNNBX067H9SykvETM8=;
        b=XYkt46bdkmdloYqTEp741MVHZP3yn3TVSGRslRr6T3SBg2oLpqwxqgkZyxStJO/jsN
         aSxUlPyCE+ZM7A8koPMTeY/rbuZbXSFN9k0bpSxMk4Q0GzCOP/P9MMP78AsnR9XWS3b/
         6PMhiYSYlq2O8Guh3y6/PchspndxOiZgjEtaC1enADv+IUu1ZMgsFsV9zRlZcOVezNhZ
         p7tLvjqXKt5AcoBnqC19XyjCfQEKHshBtl1oQHnUdn3PXrNKMo5PzCIU8t05l91rsbUT
         NwRrNhrlsw4GfErXh4KeVUnD61Ozfu6w0qBJ86ZNh1SjxTR7F5kzNxScaA3/Z8t4D7g/
         Trfg==
X-Gm-Message-State: AOJu0Yy2Itiy4MiJ2bp1JTLDsMZBflNCFuIoQiQByPtCVeX3bVdsNoll
	q5kwPui40Wd77tc3Klhdkji5qvl5jCw1dMEQpUaH/XNtrOWbieCw5oyP
X-Gm-Gg: Acq92OH167IzZ/Uk0O0qWEhF8cVty6cBLyK7RlRw9PLemKuYycPiif+wldd94jVXfHB
	eDKr6FK1NNxh1NnO8VAS5Sjgq5If7JAZkcNYwc3ar7ljmqXF17obBNNFflDQKnmXGfTKy5rKTUD
	aHo8mJ91wq60OEbyHLjaQp0uSZDEMy0wDA/pptXlzaP1VvwTaY1VRd06XEThOuQ2EkMMbY+RVa8
	aOLRnDO5i4DfnriyZJKXpvVO7R5/uJ2cywDjroCMmR9Qz8gyZtYa0Nl4iX7opzHddhgsPDFS1N7
	CcGWWtV8zO+KhI7sOEy2uPsbYEOLrIt8c9/oHBbcV0LS1caJacwVqLvWIawawLxt7lkuhy+SJnx
	OXY3zXUXqs1IwNqaMjOI0Y6L6sK9spaTSE8dx0qIiz2jnvGkABcYzOGZYnyjwZfTcUzoFWY3l3i
	pAwZGuSpSSica9ZjHbHHFssB3gjwQpBCj2hD4Z3v+gLg==
X-Received: by 2002:a17:903:2c04:b0:2b2:549f:7d2b with SMTP id d9443c01a7336-2beb0596f55mr311852275ad.11.1779981174894;
        Thu, 28 May 2026 08:12:54 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b2ea3sm187675705ad.43.2026.05.28.08.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 08:12:54 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] ocfs2: reject FITRIM ranges shorter than a cluster
Date: Thu, 28 May 2026 23:12:47 +0800
Message-Id: <20260528151247.361854-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_trim_mainbm() trims the global bitmap in cluster units, but its
too-short range validation only checks sb->s_blocksize.

On filesystems with a cluster size larger than the block size, a FITRIM
range that is at least one block but shorter than one cluster is
accepted and shifted down to len == 0. The later start + len - 1 and
len -= ... arithmetic then underflows and can drive trimming past the
requested range.

Reject ranges shorter than s_clustersize instead. That preserves the
existing -EINVAL behavior for requests that cannot discard even one
allocation unit and keeps zero-cluster trims out of the group walk.

Fixes: aa89762c5480 ("ocfs2: return EINVAL if the given range to discard is less than block size")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 6e5fd3f12a84..be09e766ac1f 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -7576,7 +7576,7 @@ int ocfs2_trim_mainbm(struct super_block *sb, struct fstrim_range *range)
 	len = range->len >> osb->s_clustersize_bits;
 	minlen = range->minlen >> osb->s_clustersize_bits;
 
-	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
+	if (minlen >= osb->bitmap_cpg || range->len < osb->s_clustersize)
 		return -EINVAL;
 
 	trace_ocfs2_trim_mainbm(start, len, minlen);
-- 
2.43.0


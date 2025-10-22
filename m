Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD08015D1
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Oct 2025 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761172100; cv=none; b=U2y8CqJPvs8puHAqIJaZ0tJslFK9JRXtSVMiMAX0+KSyIsv323/Ta/e7GnunFLHbSXcR9bM+UaaqwygrocKJeFh6cVWRI2OEkZrz/6ucB9U8P2+cqNxgxwmwhLtQ1BlLlZX8BJs7eh5RrVuYeQ6leGCWXVQGekrk7Oa+ZKCpOWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761172100; c=relaxed/simple;
	bh=isfyGf+q4j0GyX+Zx0JQ48+InVacVB/eM3aODMGSFN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SpylKkfVEE9XpZRDLrRuaRmkuS/1fZSxY6eEy49OvzwOKk13JovZRkbMfAKC9cukuAshM8jV4+H1yxlFwPyrUkwXiCdZQtmz9dKcJamiTwASMPNeomBq05GA3rrVlQ39Yx9ciU5UlQR5AVQOOEo6xOZwCnaUu8gH8bWxQL1/dWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h/U2AaqD; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/U2AaqD"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b4aed12cea3so31111466b.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Oct 2025 15:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761172097; x=1761776897; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2VBBjigv3CT5N8O/I+Hvzhx/gBfj5BueEjexvjIc/bI=;
        b=h/U2AaqD3F6SCl+YeUD3k47AAGWmuwOFlJ/6fUbOX1BxjDq7NLrSXd431NvAR8pbuf
         A/FTdIU6Rg0O71iXZHsN9Gf0HmMHURXQFqMtlb56eVjn7v7hRnFy3Guk9ztOoxqwgPwt
         9vKKOU62uA/nboXAlqWv9/LlfeYW3fgr1UQo3WfxM1v/xR0AGeUWti83h0fTdFRZGije
         e2iYBDl49mnYG3cppj012TbIr41y5Sx3BpzhQ9BLj0Yb8JU8D2yZ2tDf+ATDyvcb8rJ8
         pmPwYfO3GsiPNPhqIbGydktbR4Vn2FIAX+znre2kmgsWuJwLB44G5xI2dbVk9qMJSVK1
         QXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761172097; x=1761776897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2VBBjigv3CT5N8O/I+Hvzhx/gBfj5BueEjexvjIc/bI=;
        b=S4f4nb89+xO+AF2zq+yT+zJ5sim9LUahjIvYyHL2dTiOq5di8bKnjzfYyAzK/hTsOZ
         s7KG0V4uYOdyM1ryx+aDSmXJQXOvPQGDhTe+SNgiZeJAKPjLBB6McEYW06vqVyTH2wYE
         x9dJc3nHXTLvV+twFtG+kyU1UOsLlDvg7hvc5fkbHjD38/Z78HT+NfhRgfNc7FkeSq9f
         PagZiyxsoQvwQFL+jpINSxuOrbAZs40cs89w75Ey7a8WIeZeGZJaB9yxHoDDcU4rfTQA
         yfB/UJ8PHYkYGZ4YEutmB4+8PZk6BVfBmNPgnTjUxotdo8eldAOHmIn9thVZkgBV+wrW
         8ZyA==
X-Gm-Message-State: AOJu0Yx6248veuUkBwSkXFsrPiqAIv0SVN2tUQ4bSSjAyaz0vGgv+aR8
	xSsLz8N1ItyOsf2dVa/tPdQxoqDxKDGt8jNTZ1PkAmkJYdfKarUiBQugeKXWwPd1coE=
X-Gm-Gg: ASbGncvhLbM/Vmu1epK0cdGza0fkV0Y9k6wKhKeHH/ZaFc7mSsvK6YlRCHbwsDJTV5z
	JHquLhdKv9A/OgVjhhFuun1B9TnP4nqAgGGTtxIEWE1aBXdlnnFWzY/De4SngjUH9tElPtNcxcG
	wICwvIRMthUx7X2oUE/6JSC2i2NPWL7ZhOrLJfdumt2/qfau2LLIRQQ9uCpWfrk7doG820jduDc
	99sweSNUjU0PzEvQKE05rfxh80jMNA038Wh2dEX7/SxMc/Hjck5lPzWrOMPDymVfnxT2XFUxUKS
	TDgXCRxU7OcuyxmjCyKKyrj5S+3VEz8fCXqBRvYn2UjUoLPtlUPR0dsjDnGV/enROaOH/CsnXBc
	GaSJTEYqC/3iA0E5bImPquAaS6MM4M+ulgr7cLlxqjlXzZixcSEAZoPWvh5Cgix79qoFCy7rOsb
	21uQ==
X-Google-Smtp-Source: AGHT+IFKy4BxL63HMi3F50TzZgIj7aS//0dgKOpQCa8zsKJgTdxjsokDGki3wOZJJ9x2140UA9Oyog==
X-Received: by 2002:a17:906:ee8c:b0:b3f:1028:a86a with SMTP id a640c23a62f3a-b6472d5bbb7mr2707762666b.3.1761172096233;
        Wed, 22 Oct 2025 15:28:16 -0700 (PDT)
Received: from eray-kasa.. ([2a02:4e0:2d06:1636:dfb5:40c5:809c:aa06])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d51417523sm28512966b.50.2025.10.22.15.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 15:28:15 -0700 (PDT)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [RFC RFT PATCH] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Thu, 23 Oct 2025 01:27:53 +0300
Message-ID: <20251022222752.46758-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.

This "zombie" inode is created because ocfs2_read_locked_inode proceeds
even after ocfs2_validate_inode_block successfully validates a block
that structurally looks okay (passes checksum, signature etc.) but
contains semantically invalid data (specifically i_mode=0). The current
validation function doesn't check for i_mode being zero.

This results in an in-memory inode with i_mode=0 being added to the VFS
cache, which later triggers the panic during unlink.

Prevent this by adding an explicit check for i_mode == 0 within
ocfs2_validate_inode_block. If i_mode is zero, return -EFSCORRUPTED to signal
corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
make_bad_inode(), correctly preventing the zombie inode from entering
the cache.

---
[RFC]:
The current fix handles i_mode=0 corruption detected during inode read
by returning -EFSCORRUPTED from ocfs2_validate_inode_block, which leads to
make_bad_inode() being called, preventing the corrupted inode from
entering the cache. This approach avoids immediately forcing the entire
filesystem read-only, assuming the corruption might be localized to
this inode.

Is this less aggressive error handling strategy appropriate for i_mode=0
corruption? Or is this condition considered severe enough that we *should*
explicitly call ocfs2_error() within the validation function to guarantee
the filesystem is marked read-only immediately upon detection?
Feedback and testing on the correct severity assessment and error
handling for this type of corruption would be appreciated.
---

Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
---
 fs/ocfs2/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..d4142ff9ce65 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1456,6 +1456,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (unlikely(le16_to_cpu(di->i_mode) == 0)) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: i_mode is zero!\n",
+                           (unsigned long long)bh->b_blocknr);
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0


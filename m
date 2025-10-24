Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37B614B06C
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Oct 2025 02:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761273113; cv=none; b=moC5c8ZedVRKZYJAH5QUQXG4UHqXPeEMsDnce0mRsqKYjaoaz3TzMsjbXoaMFLdKluNVTw5ENuNGv3hdsOyRDjFtf8P3lcPFM2JeL6bApAspjUnWubfi3ZUf5sUZpfjef9FoTJrRlZYm+YwAN1mpDfJrhLHeRdgDkK2ELARQxzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761273113; c=relaxed/simple;
	bh=mB+Sz698UKnQG2Of9PMiBc4sskjxEz1TZXLMejF+Bgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf6mJDT7XhzSmDQb/5P98koJi2tzTi23ASa5Bi+2omMbAaAN4ebuTFsvrsLQdAyYTsjD/FvXTqWdNnZliFyNXHJTvnKcWI0m0lgwkjN53L9TxdL9EPYuA+M5Y6rx9a8SnyBUGdUsYFjM9zMH+0rQA8THb6K5cZ2NQjcv4yR+6HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=juA9HWKw; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juA9HWKw"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b6d5b756284so250707566b.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Oct 2025 19:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761273110; x=1761877910; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vucv2+AArBiVxHEjmAULkpSApHonysQt9coOVU0c3uU=;
        b=juA9HWKwoN6Tazw4sogzdbptAtnJwtpUDVeDedNGJb/7D50z4nta3gNAv+Gpt9fcrO
         JgWGLYOoOHuLUFpJvqbLQ/hFfPAeIwjivSRAxK4yuoYya0YJfqZv9h7lC0KRJNchMG+k
         RhMnCd0X/W6jIZTkBk9rO9WKbCDEML0d7Oq9Zy9F8yIu5NWdNml7wiPZxgBvsBMfR8Gr
         Sh06WoMj5oEr2PviCzcXsXkUxXQYwEFawp7prYEIMkTXJ6XuamuLsehSsOEBKGlZA3XA
         d4OJ7y5ZE7U6TrHtacM78dxZwNP1zjnDJaFH3p6ZSFZsrQ/K/6r4fhDNFNc89cpZPEZ0
         X/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761273110; x=1761877910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vucv2+AArBiVxHEjmAULkpSApHonysQt9coOVU0c3uU=;
        b=iiW0vK6pnXqd2pGHhaVnfP/+yo6ZcPlx2ZH4q+LxReRgxZ/cKOmIEFG+quxfp2WcdX
         7ZmE0yzMTggtoEtW1qVCciQJwt1JEVWqCWO5htR0EwihhD+2N0nu03qnR5DZUbBqkYGm
         eWkKlN9lYjZ/I20mBiccjmfQVf1x5SPiNXCOjM8fbGC0ciQmGr44ZSPFsdLIB4/BKGEl
         f/pL2h+N4uoFezPEgxuFYrDsqMjnaNw77igX9Y7tUeuy11balTEeNj2kXIQdhlh2ocpv
         9pVsN56tvAufyrR9hJu3h9bvykCHknFxXjIJsyP7+z0XonbewN6ZXIheEsP8WaZqaTNl
         EAzQ==
X-Gm-Message-State: AOJu0Ywgneqjxb/KVxQuZ1oTufxCSuv4y6QO3wp5LIMRKZwt6kRpbSBg
	qMQsXZOqXcN6gXwuuP3tTTi97l1lVztANiUaFnIVT0DMhsSNhmuvMd0o
X-Gm-Gg: ASbGncuA00mSls7yMVKsUW/JFsbNUVW4KPAljvrFiUBOMnGs5PJYSTUHN///ilwK8WN
	uBWm0JnFfPUhJuDEN/JQhlEwOfBI5EuvMvNSGYm38Jt5dgvjS8+1BG7k9tBayjXspj9cWbI68Ds
	ypgxKOPgEpLT/2VMZnClfWg8GYW5vvEd2tFVhKybt72AEoIDq+EQ0zR77QVbCHMIYlKYXk+P90K
	odmNLATdZQzqjG+Tgwur7H65GLESJg8I7jin/NN7+BkPLskHJ5HIxHo4Zk1HnYBkY5N4D2TINsv
	S7SO0cb0XrrKUhkK+kCCV/sti94ce0d2Xtnyfo4SbyUMrqLugBJZak1zTDKrjn9mz0dL35nB9r8
	oL1w2HA5CJsmiKB8jDnOa9I9DIJJ46pbD+pfYeTkW36U1MeEnpcNsYkKI6LB1OsCgh/Jm2tBN0B
	xfeUoTzB5FmNhv
X-Google-Smtp-Source: AGHT+IFqr0OGMyRPm4LvrFPZEOmm/DXOx7zylQHcHqhS9CvytEP058sbN2a+w/3eikBWJAEa++c9yQ==
X-Received: by 2002:a17:907:3f1f:b0:b6d:5003:8746 with SMTP id a640c23a62f3a-b6d50038937mr592991666b.21.1761273109902;
        Thu, 23 Oct 2025 19:31:49 -0700 (PDT)
Received: from eray-kasa.. ([2a02:4e0:2daa:1585:2b9a:69d4:d466:5f63])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511f8634sm385725066b.29.2025.10.23.19.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 19:31:49 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Fri, 24 Oct 2025 05:30:57 +0300
Message-ID: <20251024023056.29275-2-eraykrdg1@gmail.com>
In-Reply-To: <20251022222752.46758-2-eraykrdg1@gmail.com>
References: <20251022222752.46758-2-eraykrdg1@gmail.com>
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
v2:
 - Reviewed how ext4 handling same situation and we come up with this
   solution
---
Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
---
 fs/ocfs2/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..6c936f62b169 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1455,7 +1455,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr);
 		goto bail;
 	}
-
+	if (di->i_links_count == 0) {
+		if (le16_to_cpu(di->i_mode) == 0 ||
+			!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL)) {
+			mlog(ML_ERROR, "Invalid dinode #%llu: i_mode is zero!\n",
+			           (unsigned long long)bh->b_blocknr);
+			rc = -EFSCORRUPTED;
+			goto bail;
+		}
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0


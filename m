Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFB52E5B0D
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 22:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761778689; cv=none; b=Xo2iuN89zU9xwYq+8jaJJfukrMh4/RcMTnz0fgK4lnPZS9xWyt4x2QqHmqo6oEre9UYStqJRURmB4jooEvdx9b6jWiEaYEhBBfobX4TwYbZ8W0uyQ6VRopBc1kuE59G3DBZeqDxwsuK37up9XcF8j+gHXI7FCAe1SSjUCVlmB4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761778689; c=relaxed/simple;
	bh=R35boBO97p0Y3sowS7PP3Y56OecWAH0OL9cqtC4OFZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V3Y6XQ/MEmwxHJH9+tvyNVr6b23Z2BuM+HsWWVFQlMD5513iAVFjoWb5YFHJZahLMufljluYZY4CfQlYkV3q8bVtf1jj0iKZqe54lXIjtkk7XPpOhcweiev2MPBczHSP0Aj6lET7HBKhZCrJJB+9n0AOIvP7cmnXt2lqA9p6ytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B1vVfedT; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B1vVfedT"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so56152966b.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 15:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761778686; x=1762383486; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYrvBEQFYhC2vv51UNS1Ho/nte1oyOBTb9uNU2WpKKM=;
        b=B1vVfedTbv5PU8+nwehNzS79RErrBJHmutqZXrr5pB8CrRqolmlYUEgUbb0fsFtigz
         gZge9l7Lp4uf0xkqy/vW3WAylNW9uu85GiUr0Mp+ejtIX3ggTURFcqdWB0/zBYOy3oN7
         EEZvrSnfOTGAJfZ6uLjbkqjzFI5FE9dijgPRvOBP+u7b12lHP16/NzluZa6o7Xoqw0cs
         vV2RunDBr2T8iv0ZTuYHoD8zakwD0JNf4tAHO7Thp25oRNtWjXog7R02C6dIFasaAu+6
         biEq8NhZOJnoNHmYE5gCf/Yijd/Rt8qo3WoHJRBxIeNJUeMmRPJkrgrudODtVgX1ihNW
         7JhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761778686; x=1762383486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYrvBEQFYhC2vv51UNS1Ho/nte1oyOBTb9uNU2WpKKM=;
        b=EkkRIX1QK4A+FOdK1xrw+2dUW+Of6TED1IeqWub4/w8svG8NXNFZd7z/dw/DyecrKm
         CZdIketaVhSyUHF6fsihx1oNGftmN521CsRvdDemOzsnnmFEQaLa1YdODvRQeTstJmxU
         LIB45Lkwz9jKAbCAAnrU1bgVeMUDQT0IprLSb7i4EhvNgAej4si23+fTJORT7BgM4B0w
         +vKgTg/Adm7tjo6TC8P9WTwLyKXrvVSn82wxEv1jfG3AJLbwrBRZVUGxuISKbA2rm0aH
         rNjs+Y1gqJg/03/5uWVVXKNfDllqAp9mTq21VwvxSJfrd9ISMaFWrN9HdS9DXrOkx5iA
         2axw==
X-Gm-Message-State: AOJu0YwmdIGCjuakGTXjf6hTmqkoeJh3mySfPxmGs7JuhRwsKV4eTR5a
	88bS0qMIBWKduYyZ8W65SrtOgJ8g21FHzlTcWZ6Epkjy6zhIKzVuO7dl
X-Gm-Gg: ASbGnctMLrXgP+Y9Qp+HxAIW/nOb8ev9M09fx+RV3Y3xSnsSUJojdEOcoj/ZXkhOWkN
	sO2/MZv5P0hXnq30ActElYJmH44wLiEXz0buumubHJcxeWzEFhrzWatBGguXqdvo3vv0NPdBaHN
	abUxCNITydxxyfXIvOYwac7k55ceBaLNI+6f4WALCO1ocb3vxdZDXe9V1/q6qdsfATkC5mdbcPS
	Dv5b38F2qmZy9nI0afbekcO0v9f7m0GTcccDYmkOgwIi089CngxrdORgzsgYiNQTqlGa7FZj464
	X4mRyJmW0Z618mgMQqcwPKs2+i1Lx2ok1nKk25Ls9OfJJHaGU5mbwBXXuzNmtRUXM3OTSkdi0Q0
	JdeNRybBZw1VEarem5dA3ksmdAW3SA0UrmWpKX+ERk6scqTZ6vvZpmjoul+bwrhlqkgJK6hcFda
	JB
X-Google-Smtp-Source: AGHT+IG4M+TrFZ+WvBWMivsgusTfxTkskwi+ZZSO0k5cw5412piiRHZ3q1efPw/ibuWapgCjmuNcfg==
X-Received: by 2002:a17:907:7211:b0:b40:6e13:1a7f with SMTP id a640c23a62f3a-b703d38ca50mr510498066b.27.1761778685725;
        Wed, 29 Oct 2025 15:58:05 -0700 (PDT)
Received: from eray-kasa.. ([2a02:4e0:2d02:232:b56b:334e:6279:ccaa])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d85309074sm1559094666b.2.2025.10.29.15.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 15:58:05 -0700 (PDT)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [RFC RFT PATCH] ocfs2: Mark inode bad upon validation failure during read
Date: Thu, 30 Oct 2025 01:57:49 +0300
Message-ID: <20251029225748.11361-2-eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Potentially triggered by sequences like buffered writes followed by
open(O_DIRECT), can result in an invalid on-disk inode block 
(e.g., bad signature). OCFS2 detects this corruption when reading the
inode block via ocfs2_validate_inode_block(), logs "Invalid dinode",
and often switches the filesystem to read-only mode.

Currently, the function reading the inode block (ocfs2_read_inode_block_full())
fails to call make_bad_inode() upon detecting the validation error.
Because the in-memory inode is not marked bad, subsequent operations
(like ftruncate) proceed erroneously. They eventually reach code
(e.g., ocfs2_truncate_file()) that compares the inconsistent
in-memory size (38639) against the invalid/stale on-disk size (0), leading
to kernel crashes via BUG_ON.

Fix this by calling make_bad_inode(inode) within the error handling path of
ocfs2_read_inode_block_full() immediately after a block read or validation
error occurs. This ensures VFS is properly notified about the
corrupt inode at the point of detection. Marking the inode bad  allows VFS
to correctly fail subsequent operations targeting this inode early,
preventing kernel panics caused by operating on known inconsistent inode states.

[RFC]: While this patch prevents the kernel crash triggered by the reproducer,
feedback is requested on whether ocfs2_read_inode_block_full() is the most
appropriate layer to call make_bad_inode(). Should this check perhaps reside
within the caller or should the error propagation be handled differently?:
Input on the best practice for handling this specific VFS inconsistency
within OCFS2 would be appreciated.

Reported-by: syzbot+b93b65ee321c97861072@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b93b65ee321c97861072
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
---
 fs/ocfs2/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..415ad29ec758 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1690,6 +1690,8 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
 			       1, &tmp, flags, ocfs2_validate_inode_block);
 
+	if (rc < 0)
+		make_bad_inode(inode);
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
 		*bh = tmp;
-- 
2.43.0


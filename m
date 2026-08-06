Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A338E8BE
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 02:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785982863; cv=none; b=SyapaI/UolBeE1t9R2l6tq67iyy5y4x35ygsjA6qNnqcaecRfW6KACJBcBltRFQPCTRq6cpdyZLi+3LxJpR7+W1UeWFOYhW60ut8qheSeO8gaKL0ED0IwE740pdziINppFXzqgnLQX+fogskiHu5Zu7ZyoUiDzBQewoH/jgIFEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785982863; c=relaxed/simple;
	bh=cWjV8h1cQrtdcyPgxMG0qe7pvsvyiL4napaYUUAF7JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGO+fZhvLJ1HEe+Au7h+H7djM12EDb1fD8NSd9LENmXBAtMdyC6FjPW+VmPhHtzcerT11wl/tzRLeYPF+B3u6WG2YGgSr1twCjSdzFMho1Nh0y3B4BZMQgL1nPQqErmOEsukRUDjiJNJ7YzlsJntxZhMM0KDS7rnZwHSCy3Sgnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/Y8MXkj; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/Y8MXkj"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso2030809b3a.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 19:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785982861; x=1786587661; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8rrR7xn4oTTUbhGxl5QbDi5ytS4GenrW393UJoeG+oc=;
        b=j/Y8MXkjVL+dVnidZmYrFgejCadkG8yosvXyI7tRb+X3JJ8s2Y+o6r9pnnvjh/CHKy
         /NX6ARHCYWlfBOfSOm85aOkkRYYzM0AkWsJL8rE5b3QDvgBbJeFLMl9LSRLnMXT3Xyro
         KM1mNxzJcjtYyZkO/u1BjOnTM0Hlunrq4BFRAx3vLj3n7eo11UcyonCT3Em9KkfmvAWn
         DyU1/gpxSkHGVu+L+wfVgkNcTCG3f1o5LBGgQREfbF5QwLNAavmSKmUqJt8EzG+3IxOu
         wi1SBLZ8J8Dg/wH3hgq8T+bdWBbkICvSNzVp9zP9dceJLgl0uT0FuptMGOSv1SjcrRIP
         ezkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785982861; x=1786587661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8rrR7xn4oTTUbhGxl5QbDi5ytS4GenrW393UJoeG+oc=;
        b=pyWYGXOxRAgQbk6aNl7lSlMa1kd9nCifCo2O6cY60qzF7D0F4zUN1qcArEahZOkDv6
         QzQW+dK8PzOx1OZc/Amyl3zkccA+w8iCGiZ9tKkSdICPu6aGhdU/qinqwfFbAeLNDeka
         sQEVOWuBSRi0mMnc91XJC2ICBZK7DfmMrna9+w3PtDGKrOoKrxaQb8VJ2hiQlbBj0l8c
         cH6nuH9ltUKXdcx4n/0kipCnYdl7QrZeDdkN2u/49UbR8RR+mmG0xhruyNDtE9qxCIsU
         EpaF7/baVmlzLr3OcXzXhOKZNxk5R2Vi5K4CWQmLOd3yssKdyqHx6jWpeZOIVlJTZAiw
         ej+w==
X-Forwarded-Encrypted: i=1; AHgh+RpVTugjOdNyh75sWkcLY/i7Hgm9TWzDf6ghzu+T/BVI2wrRBqcWy32CyQHvlBGhiGjM5GxnBsBWGxZhjg==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywmv8my7WUEBlASx/W/Aw/v+A1aMZL0l9pyYCvpa9O7liFxPSzQ
	V5MfkFjm6PV+I+m7Po7aZkpBhMKAhKyQxr1cjd3Aq7MElCK5zlxw9L+8
X-Gm-Gg: AR+sD11gOMRVncFsoF9RxkcqS6ag/zcAHsc05p/ycjwS6+25R/YNfZsmxcWa1twtR1D
	En56lIM9d+D/oNMpX83so07lekkvJzyt2Sf9Tvc4UzJOSghYaUus8NRf0nFaDTYKs6/HxXlMJPg
	ucOH4sjPdb0WbV88BqSmsy67mwQN3KJdwlUYLKOEMSPEAxDszV9E3QDYS99vzWBC1JVehwTxs12
	JNJTWSGVmzcSg8fJHp4RSUoMtOEp4Z75u3EDDC+96AsZ4zSmk5jiedFqfzaFozDYM8wW4I3HgCW
	rlE9L+zoqgYxZly8AAWVQQ2UMM8Gh4FPZ0hw+5ELPqk/qGmJpQPowWVLEszDKNTbA1bIGDqSqWJ
	kBDcF+VTCpg7Q+CdJ/jbUXXZX0dWcS1Mc91VIvKwKFbEzTOy1IINld2Wsoc2QP/7ZnReoN8jeks
	JYsXw4opAL45xkJdwKgs/Ba8dFrWGIlTowlK52D5YeHMFoma7TeLXkoJ076+cGm/Bm1C5uCJceJ
	HTv8t9T/1E=
X-Received: by 2002:a05:6a00:240a:b0:84e:538:476e with SMTP id d2e1a72fcca58-84f2e0ed7fdmr11031006b3a.32.1785982860876;
        Wed, 05 Aug 2026 19:21:00 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f4538ba99sm323012b3a.9.2026.08.05.19.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 19:21:00 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ext4: fix readdir position truncation on 32-bit kernels
Date: Thu,  6 Aug 2026 10:20:43 +0800
Message-ID: <20260806022044.167962-2-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ext4_readdir(), the directory cookie position is rebuilt with

	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;

`ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask

	~(sb->s_blocksize - 1)

is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
block size).  In the AND expression with the 64-bit `ctx->pos`, that
unsigned operand is zero-extended to 64 bits per the usual arithmetic
conversions, yielding 0x00000000fffff000.  The high 32 bits of
`ctx->pos` are silently cleared, even though directory size is
allowed to exceed 4 GiB on 32-bit (s_maxbytes for ext4 is many TiB).

When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
position is reset back into the first 4 GiB block, making the
re-validation path re-enumerate already-returned dirents indefinitely.

ext4_readdir() reaches this linear path for non-indexed directories, and
as the fallback after ext4_dx_readdir() returns ERR_BAD_DX_DIR, so a
directory large enough to cross 4 GiB can hit it.

This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
bitwise operation having different size") fixed in exfat.  Cast the
operand to loff_t so the mask is 64-bit before the AND:

	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;

64-bit kernels are unaffected (unsigned long is 64-bit there, no
truncation occurs).

The truncation was confirmed with a freestanding 32-bit test program
mirroring the kernel expression: input ctx->pos = 0x100000100 produces
output 0x100 with the unfixed expression and 0x100000100 with the
cast.

Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 fs/ext4/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 17edd678fa87..8113f43d4989 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -252,7 +252,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 							    sb->s_blocksize);
 			}
 			offset = i;
-			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
+			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
 				| offset;
 			info->cookie = inode_query_iversion(inode);
 		}
-- 
2.43.0


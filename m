Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0F733F5B3
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Aug 2026 02:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785982856; cv=none; b=HZpX36dggpN9Z5VDFumGbHFxLn+tTIFjP4N69wQm9p+5IvIr4ll0TGMoKk21CsUTst1V5srijXAz3kJUQX/KBBs/WnAQLqfp2goH/zMxrWUpNYOfUwpoCbZQxpHJkKZm8rTjYgmyHXUKknoTax+GbBTuWACZuU7DupX6CZ65m1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785982856; c=relaxed/simple;
	bh=w19NtSrhDkavmkUlqXA4R+/hToYaKJSwinog3Ti6Hjo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CDlDHTQ32RJhOCKc4IPF93wIJn80WjXMvnqRnC1GzoyU07Z7v/WQA8flElr5oJZisiD9rjVFp5avZjql7g3xrxA1nPs1yPley+mNqLLF6lNFONmcVuIMugqxVR3+V3Jk/54YEkvUms3hVeDImw7LF4armmIe3cUdd+sBZ+4OSZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lXcB+rPl; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXcB+rPl"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84eb992a881so1557244b3a.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Aug 2026 19:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785982854; x=1786587654; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rDAOxwq3ttzmOFNmqT41qJrWI/l0YQGgUcGKO+iJ9p8=;
        b=lXcB+rPlyAfq1pxS48lLF5OZjWBnXhnqrNh8IJ/jOHBdkLFzPCsQ5Y5P9XJtyodFI7
         EkJwuYBhjtnM0mW2aSMCsWgBLCBSIEafD3Bsv7McCsIk6kkIqwK3V6SIHaVLjGmStYSz
         iL7hr56H9r/GjLymf4IsSlvkYVXJ4VjPMfpa+QoMfgW7qJGaEvtkmQ6BLHeqoXEObGfL
         KhivO6OvrxVGl6LPSzqIeOezKVnouWNQBk8sMTkP0YhPctvsFMcIRFBysOWstoaL+aHb
         0IddzsSRF/4a1VR6fqkppm8aimH6bsmAHt5g5w9VGwvpnBLyD+Un+uX52Q5a/LRO7sVT
         X3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785982854; x=1786587654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rDAOxwq3ttzmOFNmqT41qJrWI/l0YQGgUcGKO+iJ9p8=;
        b=ohiCHZ2nmfFWmlMQ8Z6sSbiFrE1sERpHlGjpxSifYx4A9++7xRuqHc2wTUj8xwRwhb
         Yy8kR0tQ1EWuTespcMyOkdP3k1qQYuIj1tGZjDc04RdtyMgkIRiWv+NFnn0jPkQKqmTH
         lG4tWyhjNf77jUqIWyepG/nlBIEbbBj8zhbuEhgbAYqI6wZZsEC++PH4UGlz1TaVrhk8
         W10DN17bpFm1W+krTPjUaizALzACox620aOS0LuswPFQ/hH/mm3ewAEHS7jekoTTSdNe
         QlESmr7I5+zMUk1o99DXrEF53Gw0zUCE/sN0IIu2td40WV91uE8q9y+3bQ4fFpJte5eZ
         F15Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro6iNPxYhcX5lYBO95xid3HPAOIflF+vMHOfJTgOimoadT8i0kGNBx2GZfKGovXZjcRDF9e5zx5ujVCBA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxBQOvA3DGaBjv0y302sxvjxcc+HcfoyeBTJFaAQnfYESM011wL
	2Y3Y8M4rsJhq0eADTdBxFwjVL9BYYms47FSJRc5DQZwPuNk2QbYMAlm2
X-Gm-Gg: AR+sD12KJs5bdykXPJXVSZZCpUDrmn97DmXoL8p4F1gBRSvvxZnXVUrVSxw1ghw0f2/
	XvmGWGFXg+dsX3XWjCQF15XIRDYCVD03C09A5f+6ksofHbRtwa0JisSbBZ5b2uQionDT/mLC6n+
	nSHr976tdBnfWpzsAWCjJDgjIkyZNjgjf4tIdEBQ7BP3NvMEJKbHxgaUJcOR3dHkKN7uA9AnX6e
	DnezTzGhHwNABWFniFtCtKig5xiAqi4TwJQAHGEhXZLBIKhcPUjib1svTj8UyRy+hMhSVMpaB0T
	dgfq3nSdN5bMqX7GNGHbvwoMZFGqVwCwTPG38ezbzbwMWdagmZk5OkaBc2U3g9Qor31zuhf8l7d
	/seUoZnRq27qhqIrinil7ZmAjG6Tx24KTV0/3RQtM3ruvOjaWGqk6VuFPi+s6cUUuqM8zZINMP+
	RJLoFZg9TFflergnTOJsGoypYr4vFMA33YCbcSqpPBQ/E2o8klSR/3iiBvzq9GCOQrHm+Z40pq
X-Received: by 2002:a05:6a00:4489:b0:84e:24df:3873 with SMTP id d2e1a72fcca58-84f2e0c9cbdmr12720996b3a.32.1785982854383;
        Wed, 05 Aug 2026 19:20:54 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f4538ba99sm323012b3a.9.2026.08.05.19.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 19:20:53 -0700 (PDT)
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
	zhanxusheng@xiaomi.com
Subject: [PATCH 0/2] fs: fix readdir position truncation on 32-bit kernels
Date: Thu,  6 Aug 2026 10:20:42 +0800
Message-ID: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both ext4 and ocfs2 rebuild the directory cookie in ->iterate with

	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;

ctx->pos is loff_t (64-bit) but sb->s_blocksize is unsigned long. On
32-bit kernels unsigned long is 32-bit, so ~(sb->s_blocksize - 1) is a
32-bit value (e.g. 0xfffff000 for 4 KiB) and, under the usual arithmetic
conversions, is zero-extended to 0x00000000fffff000 in the AND with the
64-bit ctx->pos. The high 32 bits of ctx->pos are silently cleared even
though a directory may exceed 4 GiB.

When readdir() crosses the 4 GiB boundary on a 32-bit kernel the position
is reset back into the first 4 GiB, and the re-validation path then
re-enumerates already-returned dirents indefinitely.

These are the block-offset (non-hashed) readdir paths: ocfs2's
extent-list path (ocfs2_dir_foreach_blk_el(), used for all non-inline
directories) and ext4's linear path (non-indexed directories, or the
ext4_dx_readdir() ERR_BAD_DX_DIR fallback).

This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
bitwise operation having different size") fixed in exfat. Cast the mask
operand to loff_t so the AND is performed in 64-bit. 64-bit kernels are
unaffected.

The two filesystems are independent; they are sent together only because
the bug and the fix are identical, so each maintainer can pick the
relevant patch. The truncation was verified with a freestanding 32-bit
test mirroring the expression; not reproduced on a live 32-bit >4 GiB
directory.

Zhan Xusheng (2):
  ext4: fix readdir position truncation on 32-bit kernels
  ocfs2: fix readdir position truncation on 32-bit kernels

 fs/ext4/dir.c  | 2 +-
 fs/ocfs2/dir.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.43.0


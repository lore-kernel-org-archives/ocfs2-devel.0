Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8158F1D5165
	for <ocfs2-devel@lists.linux.dev>; Sat,  5 Jul 2025 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751738007; cv=none; b=MPM3x00LgMjsvrlloN2ypAdHrS7NkVsPWxiRvjOIc8fFygT7ayoHlRUI6rSTEFleNxmdbfEioT2ddJ5G7MUUSBNZmkU1qIut5ur7sZfAkeMZTd+jIeqmVfPliWjQuQJag9z/CDt6cxMPrsipS0RfCz3880C4edtrtwVpkEcBzvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751738007; c=relaxed/simple;
	bh=TEejV14HsRC5fLEWgeIeilpSyWrV9Qx84J/4EhI6W64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DJ+LQlHpFwuaKA8xVJdrk5COz9Db6J4+Hc3RTy8A/GNH+ThX5ZxrHRhg4MOm9YG4994fzXcmIaqrGXj0sLkR6V9Sw/tg3ZALyBXOSoPV/qWY/iJfGuLpcgCCBFIpkYuaALGzfWtlmZn0BfZjuq8TCqXDZ4nJr9M7doAT4Ro8kXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfTlt1FT; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfTlt1FT"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-747c2cc3419so1484662b3a.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 05 Jul 2025 10:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751738006; x=1752342806; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NRnHRIkvKPiGwHQ/DdC9lszMjv0qPduuNx1iD3B8GN0=;
        b=LfTlt1FTrUskhbddKIJOoVixVOsrG337clhAKoea0YrXVrq755hQQQThwUIYqEayfY
         ZMXVZR+jDA8bffYLSTK9DN70PmuoV/9giPJAcuCXabFejUgOKHCuNjColrGMqxD/Zsl3
         QDS+GniPIsIWJuHJmdZMDTcbm9dy1VcpclNBa3Ktz4CZPeUY07BVngA9zMzovaxGXEBJ
         Ly1jysdHQbNzjm75Xfjzth8Kn2C+wf6MshLrlxVUgG8OG1mWxayFydRzKejrQU2lsZP5
         s/aKY9TDXTuSgdspSc5D0U23E/bsKaSZBkAJoiu15KD7f0Kmwo2vrynSMy/9GJkgJ4nX
         BKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751738006; x=1752342806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NRnHRIkvKPiGwHQ/DdC9lszMjv0qPduuNx1iD3B8GN0=;
        b=F2fkGUPcAECO5Ar7VOO98/IU5JoZ+Ey164mbyCou6lpuT/fxCXGeGL/zUNLJtkHAri
         6+Lu+bol0iiALrHQJagAMGJsBBi5VDFmzf1EZB8Eehpo6iiCPpygL3ZHF2FWHJ6aEwKR
         C7JDrULdpFEXQyWczYktABDcHlBNzVHn7dgXHoLQZHsQupSzZ21JruyS5/UtH1y1vFDC
         5REVLfHgQw9VnskjAgtAMrHvYTghRa6BdlvNBwiRZziDE+RMVDOQCNAjQS/D/KCtbSKA
         wMn+SU3N8MBjhJPY9Z53bQB/cTVtz/XgVaFsJCp7yVUFmqhaAx/+9mDTKjV754vrQ1yW
         8jKA==
X-Forwarded-Encrypted: i=1; AJvYcCWMJ3GzNHxnZ5Xh3kfhSnPwmwVvWLvZNoM4DUBXVa/uNgh+7gWHb4L15ZWIUZuCo5SbqSVPERa9zv5kFg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyYb7NlKJXJ5aTN5GW+jj3ZFFIayb8fEf8RrcKi+eigXIxq6Es1
	/ULmNrEQn6lg/03Yvi71BSSZcZgsD5YaXm4Bni413x7s/JYUs+GCu7i9xbEs8gVa+Rk=
X-Gm-Gg: ASbGncu1frimriVPJ4hVOpgE7S83x/QqoeKePjEnT2oVCUf96xtSb0ocs3NFZjk1Tc7
	f2OVCOqZRnTDqhbionrogqEAlL50ufb0bR5QKzey5pHOp3SVgyM303bKfb5smrp8h0lOK8eO4vd
	xENddfdbBh7F9/iA6l85RJVC5K2FdsofIo48I9OPHnQ0MGLFdclugL5UJBk8gtomcxTdML5sBqW
	y4cTdymwRGH9U1qf3gq2Jk+1BNLIL4isdIb30SgUNKKS3txaI146jHfFiBdNz+h1G959DwS/BFB
	1PSfLQq+UEUdSo+1WlCu8vvikICX2DgWH7gNJmi1+JY+2lQhZ+ebma75iJOgjip/4T/ALarqx6i
	kMHm7aXfxFKM/vWJ9vfuRMo69Dp1AfEPZ8Pb01H8=
X-Google-Smtp-Source: AGHT+IHznKRnwTVFc0Lh48sxul6MzHr+FNSwk4CN2E/eToBZhWqZxMcHqv67W99+dssKncSnR7ihSA==
X-Received: by 2002:a05:6a21:2d8c:b0:225:ed50:2278 with SMTP id adf61e73a8af0-22721e6fe99mr5061569637.32.1751738005718;
        Sat, 05 Jul 2025 10:53:25 -0700 (PDT)
Received: from ipravd-Nitro-AN515-55.hsd1.ca.comcast.net ([2601:646:a000:5fc0:224a:13ba:b5c6:4ebf])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce359e90asm4596710b3a.6.2025.07.05.10.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 10:53:25 -0700 (PDT)
From: Ivan Pravdin <ipravdin.official@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ivan Pravdin <ipravdin.official@gmail.com>,
	syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: avoid potential ABBA deadlock by reordering tl_inode lock
Date: Sat,  5 Jul 2025 13:53:15 -0400
Message-ID: <20250705175315.225246-1-ipravdin.official@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_move_extent(), tl_inode is currently locked after the global
bitmap inode. However, in ocfs2_flush_truncate_log(), the lock order
is reversed: tl_inode is locked first, followed by the global bitmap
inode.

This creates a classic ABBA deadlock scenario if two threads attempt
these operations concurrently and acquire the locks in different orders.

To prevent this, move the tl_inode locking earlier in
ocfs2_move_extent(), so that it always precedes the global bitmap
inode lock.

No functional changes beyond lock ordering.

Reported-by: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67d5645c.050a0220.1dc86f.0004.GAE@google.com/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
---
 fs/ocfs2/move_extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 369c7d27befd..ab460cb2c9c8 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -617,6 +617,8 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	 */
 	credits += OCFS2_INODE_UPDATE_CREDITS + 1;
 
+	inode_lock(tl_inode);
+
 	/*
 	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
 	 * logic, while we still need to lock the global_bitmap.
@@ -637,8 +639,6 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 		goto out_unlock_gb_mutex;
 	}
 
-	inode_lock(tl_inode);
-
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-- 
2.45.2


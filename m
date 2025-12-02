Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE8F22097
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 00:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764635599; cv=none; b=AbeEjROG2EYaustb8mzBdcIPRBXw1pgxMs1zRpE6i00qS81VcFwd+tq2EzofEF3fhJarnDwfTVBeONxl6t72uUw0sDHOy6i6mTM1+GeN8PDMAZu1crBT3aGEhTttY6SvOFWHcs6FZyyFLABWsUyr4Si6N02VRFJ8yGuQAjkuTtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764635599; c=relaxed/simple;
	bh=uW16PtSZ3FL7ROpLg1EtQFyrFJTu4Si5GpuvxdnYu94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGSLYWUreCsmdia6Ed0NzqhG9OT/2XHY3PpmixJpv39w0UwG7RyRneITHiZMeMtr6vsTox8IXQ018XreKjL3KHvt11mVCTzcHQsTEborUH4jcl5HsGEkooH5M4ggK3t4Yr2hOGh77+bVkRXyEKkckZo4gtL9FMs2996NR3QyjQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTCZLhGd; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTCZLhGd"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b73161849e1so1211893166b.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 16:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764635596; x=1765240396; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2TrsoSJtXBFVY7DoavTJ0Q4eFLJZnGfCQLuv/hSYlYA=;
        b=XTCZLhGdvwM97QJMs1xpviwFtVQnxPolbYZj3fCMKldKPHmZAg5cSM/z8dPjp4smUi
         Bcnpq05ptiA1k1HHFs0I40UEIJ2DuaGYyrUhHMh2iKwJkSX1yC4AYbpk2sEHN+Yx89C9
         X6o/MgMnaccGgWR5jHS/I0bxCHrXWbZhHVGIABv8xZHPySh1s/dU1S0RVYTUHaxUX+jE
         HJ1M2jds8BfaNU3XOVVrJvSlh9sV4jC5mBcls57PBH0klylGlkHBYw7dTm2l53NPJcl9
         /1jobDxDYB9gGcaUYZRtrcyppVxpJnlGHOo23Lcp6LsAvd1ej0llLR6XnEbr90dJi/bM
         ggMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764635596; x=1765240396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2TrsoSJtXBFVY7DoavTJ0Q4eFLJZnGfCQLuv/hSYlYA=;
        b=NxrWHJ+ef9azSqkXgK0sP7z4srqvgK/fw+w5+A/yrdYyWfusE5UgONN8GJeGsb7uJ+
         /0ENYvChz7h9g2o/C1JOs/KhyM9OnMdqC3dQFzuZV1ohnWNTPBrKQdsgz/kN+JLOPz28
         U9xMh4OCNoyJtWb5traobfsXtGtMtCHsKZr+6wdmL+41YXW+4xKKvUmV/+T/NIhFYDMn
         yVMBP8RHDBLYGxqpR8hkpHp3J6h+ZnC+3wgx6QKKugCiWF0sx151UsLXqY1hYTxuh01+
         jRTSiap5eTB38/5xb1YDaDObGGhMEtixqIFz1AEEHgfACg7tZFs+O+1he7kVMWsxsFJJ
         gkBQ==
X-Gm-Message-State: AOJu0YybQikcNP439rlswiAUwbwQYY7YzNBAvMGdqMqlS12Iw7qxLMl8
	4AiKuT/fJJcaG/KL/iROmNpepciO/x5YybpT8kZlBHZmaHhTFtSrK4kq
X-Gm-Gg: ASbGncug3UyTQHLZFR9GZcAep1VbXPqs7ztUrkzMbzOPMLIEoymTuQJdEDh26/C3Njl
	Yn+/k8ggPGtcbn89nrk3CmsZ46934CEJry/8YSh6XWWO9A+r8RQWtuntlbixCepuHM13sikFJZp
	YfvfyBZlBE/O9+PJUg5d1gjnFxdamybXsMCja4q2Mu9Qm5WB4TyPTlhcp7z6jY7C5aijaYz3xBD
	kuv+S53lckC5vF3ZaaIhiunaIIGLRf7xIiGrpd+d36rau6ED0onINmzx8Dc+5phyBhF0bZr+Mfe
	iuIAvXHMxPBAri6qNbIf2px/RC7nZX7kv+Jev3zr2rExky8PoA5brsnR8liPihETZaU3yLdZODd
	6tU26jWuEB9RvGv/qFRs+Xf0UoBOE+aCfMYZt112dF3lAV/sDjk8SP/PDPj+QWC0KLHTFcn3WNP
	xmU4b05aCzLhc=
X-Google-Smtp-Source: AGHT+IGbxAdcsjiIWpDaKFXL1RodvXCDyjtpDDIbBfRabhhY7XPB2fC2OpKBlsnFAi4TDKiQYvEyKA==
X-Received: by 2002:a17:907:7245:b0:b76:339d:63ed with SMTP id a640c23a62f3a-b767183c00emr4028307866b.52.1764635595749;
        Mon, 01 Dec 2025 16:33:15 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d02:fb4:3deb:c78e:540e:164e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5a2176csm1342823866b.57.2025.12.01.16.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 16:33:15 -0800 (PST)
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
Subject: [PATCH v4] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Tue,  2 Dec 2025 03:32:10 +0300
Message-ID: <20251202003209.188987-2-eraykrdg1@gmail.com>
In-Reply-To: <20251108120133.37443-3-eraykrdg1@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
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

Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
make_bad_inode(), correctly preventing the zombie inode from entering
the cache.

Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
---
v2:
 - Only checking either i_links_count == 0 or i_mode == 0
 - Not performing le16_to_cpu() anymore
 - Tested with ocfs2-test
---
v3:
 - Add checking both high and low bits of i_links_count
---
v4:
 - Reading i_links_count hi and low bits without helper function
  to save few cpu cycles
---
 fs/ocfs2/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..34c2882273ae 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1455,7 +1455,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr);
 		goto bail;
 	}
-
+	if (!(di->i_links_count | di->i_links_count_hi) || !di->i_mode) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink=0 or mode=0,) detected!\n",
+		        (unsigned long long)bh->b_blocknr);
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0


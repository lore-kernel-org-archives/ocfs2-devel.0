Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6C211CBA
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Aug 2026 03:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785726054; cv=none; b=QLvt6CIbbPzR1QThdanP5pSk3nk/ws5ELg7xjMSbGqdG3OlSqLSyESdHCRobRsi/VrFD48tN6Kvrff1rINKxax2LSYuIV9vRiJrt/2ANswT6oErHYNQBKEvTLlx3nGfdyGn3WRz7e+xZutzuvnrQkloBBsJcSAnqUNSMmUtRjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785726054; c=relaxed/simple;
	bh=xCj9Wo0LyTH8jhmyJf20NsQdndMxCAqsBnt9oKDNl5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJ85tTemTRjKBDx7QYyOTazUlLnnWswvi4WgVTWauGeprmQAROFaS5Y5Zb4E7kkKLLih0FwoU3Gx4XqdpkEb7Ll7PDqWGinIIVHpm46OllQ5+ED9sE2+4sbST1DO3Jn9ZZf8qtsdqHAkcOEzb2lJv9f2GIkW3RekGv2+KUdaazU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qFywJ4O/; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qFywJ4O/"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84867f07d63so3389166b3a.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 20:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785726052; x=1786330852; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VWJ8xLFcXVUc0SNvEud0LPLdtHNvViXl8nMczowYX88=;
        b=qFywJ4O/5eOOyB8YoJMxpA+V2JwqG+Ye6NSnxLUKVrwIU9dfsqI4QZ1H8LvhgvPdiw
         SQc5tUCJUF0Lz57y5Qu0NJsRSy54lx2e5zqIzhkxLFmx0fpr+W0dnMBpnRSy60NoXlub
         v4CSkiL4vF8gdz/LvEHTFvtrRBBny9xVb9oc+igCIAtiTM+2rXPnFaq6XrJloEAcD3J4
         fZMDy7ofNFUDm0+KL5It23seZBPICOMNoHeHbql8TLbALvT72HicEFbHvdRnceu6LfMi
         hzZWgDLPJqOtqMA8hPvwF85N0VBt90XGfG07w89NSvSkKxhjLiy6lGAtHRkkQF83qmWd
         K2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785726052; x=1786330852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VWJ8xLFcXVUc0SNvEud0LPLdtHNvViXl8nMczowYX88=;
        b=bzyr1m1Ugz2dzQpcga2rHjzhdOnrTTwk1bd7WKQ3oLMhz7mbrqOc1S0QtBYJwZxBf8
         dylZIH9ZTvXeMk006IpQI8tfjvaJUH1AMIWESNhZX5EWD2qkl4LZ5EvWqZl3k4UiAWIJ
         EPJdTmYwYWItVYoVPkZP5VWTnL8VfjD71jezsHTz38tE3yDdpu9SZ/mrHegz1PiLWly7
         oGuR3++5juLMU+mD18DvrJX2JuhD5uADoomMyFYd4dlUKEG/JJEqTKgzWVAHTWVHUwJX
         0f35RiI/eii4qCQ/h8rd954U9s4gXFCRSeMS1FLH+NSFfMAP1VjkRroEqhVVLVNXHrqD
         INFA==
X-Gm-Message-State: AOJu0YyXDSfpH7hdCciDqiQSPLcgdYInKFC1jwKNM1Zx5htsBCXtOVk1
	MwH3njS7e7SPfOXUGFlpUsJD17oT0kYM0gWZ5XA9/vgI60OO9a5yZA17
X-Gm-Gg: AR+sD11kn1XkadsXY9b1kTMLf+AcirM29+/LvixTgkHITnnrGUrT19mYh6UJi0pusbm
	Lxbnji5CFX2yod8a4yHa9pqAmjg62z/SblD7GGqUIDvMooNXw3ofNOhIdz1jzdcduNdjKxG+ySA
	KS9N5O/kFWhtJtsPvdDXLJHRAXLjVvyZAXU1kT900Oz3bsUmJZ8bewBt7US+XjBxq2ayvPtTqCF
	/zSmtz8B+oY92TS5dLAtYvSAHGuvykSaKaZJ4xmFTXtDwRp4pKkGi9FKPCbm5QY9wkej8skzVwR
	9ZVAz3WFH0neysaruOQ+W2N12Cv4XZhx253YC9bLsYkt3zuVSWE6QlxSBiaYINIUJ8hwM7eAfC9
	hz8l8Rc9n+qu3Xjs7etYfLV+CT2KDLKGAiQbCJiCXJUUlD8ph6zHKshws3ll3Therr+Ip4aMz/l
	nvU7EBWa/lKjlSoZfdVV3pn2toqrXxXXMcDyZVlvd2JJ8O68O6hx2Ka9PkevHSA8rsHR4Oao3ue
	33SHawQ64RikV8tdtxcbmcEWKEwDKvwSz4agbkE
X-Received: by 2002:a05:6a00:2788:b0:847:b16b:46d9 with SMTP id d2e1a72fcca58-84ee4851d1fmr7449689b3a.34.1785726052315;
        Sun, 02 Aug 2026 20:00:52 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc29f2b9sm2962878b3a.35.2026.08.02.20.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:00:51 -0700 (PDT)
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
Subject: [PATCH 2/2] ocfs2: validate DIO orphan slot during inode read
Date: Mon,  3 Aug 2026 11:00:07 +0800
Message-ID: <20260803030007.3993199-3-gality369@gmail.com>
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
A corrupted append-DIO dinode (high byte at offset 0xa1 
corrupted from 0 to 1) can carry an i_dio_orphaned_slot
outside the mounted filesystem slot range and trigger a 
use-after-free error:

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
ocfs2_del_inode_from_orphan() uses i_dio_orphaned_slot to index the
slot-local system inode cache. The dinode validator does not check
this active slot, so an out-of-range value produces an invalid cache
entry pointer that is dereferenced as an inode pointer.

[FIX]
Reject an active i_dio_orphaned_slot outside the slot range during
dinode validation, before DIO orphan recovery can consume it.

Fixes: 06ee5c75b575 ("ocfs2: add functions to add and remove inode in orphan dir")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 358ab3535366..180107a11046 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1536,6 +1536,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_dio_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
-- 
2.43.0


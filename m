Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9FE1E8320
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765392032; cv=none; b=oEF15KrQdHJF0RFnoFFNvr77TGtNZcBpt/SH+8dcB4Ez6AJplUZAqzAdcTADbyYNt09wVcQFJjSmggeNHwYi+tRvZ3JAS7xgG52aJkwoQQiWTV+SzK5v69JEDcObLuA6k43ltwPtRhPI+fCii9C46/l2TL3pfKthO8VqACpRk9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765392032; c=relaxed/simple;
	bh=J87FXvc0Ebdki5nlyjcqAi4bbCPFZwvZNK/lFr60TrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmiJZyK8ITt0QeMu5p7maSuTgBplM5JDKkGJW7pzetBnfqCR7YzhE8kjCND4IA9T7Vwm+l4jc75fidU/aBCxOtG0joeH6nEFqsNiFoAwoY+uAI01MoEmz3ojb3kbzqoxHDC1rP4AmgQBGgwLFhygJx+Gu/gqdV/oobZ3Iuo3MRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cfot4s1j; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cfot4s1j"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29ba9249e9dso2578015ad.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 10:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765392031; x=1765996831; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9AUgIpP8Oo8wx9K3vD172gZ9DXcnSJ5r4V1t+NtBMbw=;
        b=Cfot4s1j/+UB7eXMAwOOl+d9tBGa6ThXzgvG2Lvjo3tdxT32uap46xEk02j3zeQztr
         ECinDiO+8go1pUS1JVQ9YZIJPN0Tmf8dV9C3MPJLgCaCbuOQe968v/b+1AgiyKDgPuF6
         JXBN4Jqxcqpljn4dPkioHc6PhlCPUqurWa0i0TDJG5l8RSsXK12gz4x8WnebZ9k7oOPD
         StLlt6oQQNC8Lebzmd5KsJOCLFxyLSrhDHQ44cPl4Oqkv+IdEPvGaW9BE3+NACxVkqnz
         46H+jOyOfZojgWkcwRK3e6SWARsKLYoIeTU38yyYuZv4By8eBU75ty/VrojeMIgyPHVv
         UM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765392031; x=1765996831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9AUgIpP8Oo8wx9K3vD172gZ9DXcnSJ5r4V1t+NtBMbw=;
        b=qU+tF2CrvWib13bzFgafmLGbN5HSTea5CP28DmgZZqXnxTTa+x0U6GwR1SjYnfsOcH
         0gBvl59n4bc8QZWub1mZT7C28TCIwLd8daJswH5WBsgfSbuzSGx02EJ7CjtvMqLNVOIT
         jSgh3O2xkoaB3S6uBD+npgW5DhuZ97jmtz1sej7+f12Syhn+cbuCCbqqSg0j2Unek1JH
         tLz72kLL7FwX6wOav0BtsrK3Kib6AVv6u4nLx60MRdTHxgSNWNmi02LbssxoHvOM8O0I
         rPhsgRxIEt0sL+AeEhhxHt3GFdPFz8pHfDLjLiBFcz07zkmKJA34eYstEakIBuicb9Il
         0wvA==
X-Forwarded-Encrypted: i=1; AJvYcCU40b7GDcsIsCz4d7sZ4Um8ZDkNl1mSFFc6SvejJeZa6vZ0tWRf3g4oSCY1D7hvbAXlHr3hNrhkS9YVQw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxFUZDQOGii32fZV787nabhNYiGw53qya18Fczq2hRoSROJTJzn
	n0mNZ5vMUC48vdruPMk9pYW4LnTo8IVD+/hHjiepfxOsQxRH8nNA7DW6
X-Gm-Gg: AY/fxX7e5ZU35xc9iQI+hBLfPqCBmnvSWN+r1UNwj9mtgLKMIDL7j5g6EY6dQrOPUoN
	vEEfusVJhL+IRTT06FWxToHU+SGQHFUV98lAtKIuqAvhVK+mztgbYO1gY47fo0wZX488sP8rxzP
	usBVOkKF57fm3EBhcNzS8gLrb6EvkJ8J8RjFTx8T44m8hFVrotsFT0KVVyh//Q8Ylqgqbc03YZg
	VVVmSvuq8XYlKskIQYbGW/F4S8TOuLCcycT5BAOE5QzwIV17ZbGCZ+TKjzOOWt4wm40qIvQI8cZ
	2TxFExa1qhhCM1TlLHH4uvF35AnEjOrtr6qHP/BXW7h0fwxUHosG+z4WY+AJRDjElC8zQh0mtCK
	4mz/iLjEndtMEPkd3DvVK89rzKzNm/vnK6ttNvrxPJRFXMJvOWvKEwKaYIBqevfWQliL2MPQPiT
	u8SSfPSZD+IfyUyDcYolNw64508pY=
X-Google-Smtp-Source: AGHT+IH7q9flqkfKABX+Ntf1VTKRWHSnR60YNh1DWdPARW2mjPWEOPD/rMTfpkg8L6yiSfVnq7pu9g==
X-Received: by 2002:a17:902:cecc:b0:295:9a46:a1d0 with SMTP id d9443c01a7336-29ec27bb1e5mr29916365ad.45.1765392030490;
        Wed, 10 Dec 2025 10:40:30 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea06b49csm588205ad.95.2025.12.10.10.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 10:40:30 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for ocfs2: fix kernel BUG in ocfs2_write_block
Date: Thu, 11 Dec 2025 00:10:07 +0530
Message-ID: <20251210184014.22798-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
References: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 24172e0d79900908cf5ebf366600616d29c9b417

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/slot_map.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..e916a2e8f92d 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -193,6 +193,16 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
 	else
 		ocfs2_update_disk_slot_old(si, slot_num, &bh);
 	spin_unlock(&osb->osb_lock);
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		status = ocfs2_error(osb->sb,
+				     "Invalid Slot Map Buffer Head "
+				     "Block Number : %llu, Should be >= %d",
+				     (unsigned long long)bh->b_blocknr,
+				     OCFS2_SUPER_BLOCK_BLKNO);
+		if (!status)
+			return -EIO;
+		return status;
+	}
 
 	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
 	if (status < 0)

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
-- 
2.43.0


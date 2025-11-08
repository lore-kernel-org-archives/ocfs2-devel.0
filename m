Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC084222560
	for <ocfs2-devel@lists.linux.dev>; Sat,  8 Nov 2025 12:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762603355; cv=none; b=kEFoUMuD1hgTfQlYdR2SJJmt5VSmXLol4v0C4R8DPkMV42tfnKr4Ck/eGLtJAq4KzUxt1io87HkImgGWRk13oX6KYGNWFJ33Ss9wxGpgSTQqxiOPq3Nm5BN4ZhTKlOPNnDgJ73H1Kq5k63vVHB686NEbaUN9F8h5hwLPN0JGDf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762603355; c=relaxed/simple;
	bh=h0efBWAdcFLUiA+GAVsRMGr16AcStdyj1wmiqunxhM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vFR9o+cU6RZJJrqwSQS5eWuUgbFJp7AxkkZpCM4s3lLozwtbpHVz8W/4y/9gDxtNWYNZQG8kJHi2FklpSWi935w4PfZ2qMnRabNqOsZZhjvQAeScRy9lag/QI+Az+yovJufVfAgfSr28nL0vCanM8b/74CuNWHypAmI1Y3WJbmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g2zfacAr; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g2zfacAr"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so3000897a12.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 08 Nov 2025 04:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762603352; x=1763208152; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MolBFQJK8LdoF2uvTwy8N0sP5mBs/YPd2CVkntKqOPs=;
        b=g2zfacArm4X4cDC9tVyxjUGsu9s8PhG2Pw1c7Dlji/B8v893ztEQbCmuGZIzYdiVJW
         fbPhMdvirfCyY/qlgt3uuVIBFXsaClNWL/dpO7ZazJ53myljpduFejWPX2mHmaZcJyjl
         053nWGDrgkSknlTlMETBiHSWfVxlyg1Zix2WB7Byq7APnJo/bT1YPrls4HgWaHiEaTfM
         JsnFll5PQP/E2jUzN3pBPVZh6gNCZ7lDcKViefZN77YiWxHFGebWxgwhouNIUAV/9kVP
         hku1u6YQX9UbjdD76jSMO/8Me0qNKT9jaHTVvQkBQD3q6gSwt99yRnlSj1BlfvJYvg9F
         /6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762603352; x=1763208152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MolBFQJK8LdoF2uvTwy8N0sP5mBs/YPd2CVkntKqOPs=;
        b=hN3Q3P+uvI+ucjbMfNqzvi1WAeci5R0NePtgHsCARPdDOK3FN3TjyPmRDdivEKOEna
         WSJpflViAnT1VfHwqC8m99Q9N9bA3aumieaRGSYtQ7fm3W/dGlqa8kkUEAtATw9V3bq5
         VrDFlC8gdpF7VcztUdpYgd/ybmpUBOhYb+rNmjnpPaCSW7u2Nvl55o0vnAMXAlHtquZx
         apEzIwncpvZGw5F8cKWf27RP664w/TIEh3cR5UfDjxpX7OARcpA5dMEV1iYk23OPx4tB
         JpKhurWo2X9j/Ytl21vlQ0cDoNESJK352Hf8J07Eo+QHxRMii2kiXVL2qQygwYM7iEiL
         QvBw==
X-Gm-Message-State: AOJu0YxLHO91vYkEv+ZtpIZMFS3azufunbFt1SjyYopk6BunwEJL/Ibl
	jSnk1MmuTQa3Mo8kLfhEj6FwebA1raGvmHZ1G+80gEfASd0kHVRw10Mq
X-Gm-Gg: ASbGncsW9zuF/qNI3SAeUIR4XNci0t7PA3JMOWuVLSa9usrFeSLZJYr/hnB8oE03c+8
	2YDx8YBowSIwLS5+gaunLxbM0hME3zoXySa3qyT3THKPjGbbiZ72tI+K/fRJMMAWjy2Dt6DnusB
	of3RUmvYyyKTRp7vVPcP5HLS3qAz5id4BYAovKUJuCUXheUA6u8IrWBC5OAlcKKSHvb1mFfFye2
	VvKE82GpYadT7s9X2EgZgccBFqD/nkYQTAB60/igjGwvPwGxwoxtSps3C0oXay3VJVi47a82aeP
	NaZWyUsQRPfLvG7F8CtgCPxM68A18QAuyjKGRcsXDF8KmNHAkPOTuFYOfNGsysNBzwdS4oxtF96
	6GWi6Lziwz2B3Q7Z+NVRVRP0BaCYY0usroWRarAzTuqHYO6NXhiaiWjejdBsLPDYPAKYq4BT2T4
	ycpmjZ2BubGw==
X-Google-Smtp-Source: AGHT+IFkaflDTO/AMyaKzX31TFdl/h9dbC4ZFglrOZEwm9xh+j+bASEBScZd2OFMTAZpV1p/LcKF+w==
X-Received: by 2002:a05:6402:354b:b0:640:fb13:6b8 with SMTP id 4fb4d7f45d1cf-6415e817106mr1607860a12.22.1762603351778;
        Sat, 08 Nov 2025 04:02:31 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d18:62f:6d96:aed2:215:b816])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f86e12fsm6459166a12.34.2025.11.08.04.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 04:02:31 -0800 (PST)
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
Subject: [RFT PATCH] ocfs2: Invalidate inode if i_mode is zero after block read
Date: Sat,  8 Nov 2025 15:01:35 +0300
Message-ID: <20251108120133.37443-3-eraykrdg1@gmail.com>
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
 fs/ocfs2/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..d966df3aa605 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1455,7 +1455,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr);
 		goto bail;
 	}
-
+	if (!le16_to_cpu(di->i_links_count) && !le16_to_cpu(di->i_mode) &&
+		!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL)) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink=0, mode=0, !orphan) detected!\n",
+		        (unsigned long long)bh->b_blocknr);
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
-- 
2.43.0


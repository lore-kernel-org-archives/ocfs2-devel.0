Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BC523B61E
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775197835; cv=none; b=r9tubZ3n0bW3WSsQfXfdL1gCkccej/y/MbKx4eQb5St/NUpa22A+3JX9qVqe+Uhytn/OBFGReyi+ZuY/S9nQnBovhrJphAUGtuV3AunksFZjXx+vpAVLLAKYA1TAIAztq6rGiUdRD++f5dMyHEUv2fsl/8+C8ebmOd0fTBNnFRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775197835; c=relaxed/simple;
	bh=xzl8Tl+oT/5JDgckUA3p7FC1yPtGRVwkqYuL1scmJsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H0YvwYxkrerJ2lZ1tsmYewg/1pdAJsUF5vQ3aPZSmBi8Vt0qV45CGgJ0bau+7K/3VhRDnis1S0zVxl94qzLbhXSFJxCdH2q0AuoPEpSXnQ/CTPnUAHB/tOvmayaDiBO8thR1xe184Bitj7udZUvTEBtNM7T81GzUMDRgwgjFNFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A82tUCea; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A82tUCea"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c757a9251faso497107a12.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 23:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775197832; x=1775802632; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GqRq4TvoUCbYo8jO8ig93cBQJkCaPpPSvejubE0Dwzw=;
        b=A82tUCeav+eDr41P6vKiZHzP5tXRT75NeTLx21SeH8DOep7HzoKIOE/K2gclvDdf4B
         oh8K1fmZ90g2GOJ3AeNWg352ZnEAaDfhpAVVaf/WSqU0AoPfsTXxEmkABxKuCuFFiqvN
         XIxfyhUBS1J+RbENaDu1AyC9BJIo6uNFWyZNaKcyRQz6sclF+O6g1Fw3ecxTcTn8VcdP
         CqjEduYq5dNEBlYDdRkxWpfwETlst2RJ2n522ghOa1G/T+p+2B77Jhe2ZlcWqUWn6LLb
         iaouxh9vFM+NyOIxhc7tziLamlfc9Ykbvw+3HkCiqW7nZdSsvRQZkJvbK94yhqZYYEpu
         cTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775197832; x=1775802632;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GqRq4TvoUCbYo8jO8ig93cBQJkCaPpPSvejubE0Dwzw=;
        b=BQRdwKvvlOCTRdwrNj41HC4pvSP1iqsnrz5O4rCK0AhQyOidfbQAhzaml+635qTobX
         snly3LFTmeYp2WrunMqGFe4CcH54fN3q8PsaOO4+005gPVUihddgoYCu++JIZ24kX/Yt
         70u8lJ2PEISVlYUqX4P/dPmEii0zDkRCd5BnVNOc4fRXZU3mn8EbqP3d5+qZ61sWS5qJ
         eKsk+IlMPlBEUnlJpm6dKwMnexQFdkNzlfswDECOXZ0cTL/yU2YCpm/1RNteK9gKSipL
         ONzRXq7FJHHvfrmVjgYPDrWylCZO2cwmzYuiwqyH8x2lGa/D0Z0hBKnWg/UpHv45WgTv
         bBaA==
X-Gm-Message-State: AOJu0YympW6QW2GQcEeDCeYToLX76u9G0U8XFI5keLUNka515+sF6gDd
	wxF4fkagvSuVye5RdsyVOUWftMWZhlfD7UTWx4cvuOQsGyHSCod0pP+R
X-Gm-Gg: ATEYQzwkLs1VCmqJa+LhafEW/KHJyQxWajLN9lcpTJ1QVscz50cTQHQy6t2boLFNrCZ
	qWZ0j0aJvMg+33oqYPtmaiKggZzn9aiPH7GRa3UzyrlN34vtwneGeO4wz6Q3sjn5tczqHaJcx0Z
	ZYuu8WRsp20OkbFpGKaDcByAr/wokV7nvwHiyDWFltW9eMdYvR1s6eMTIRhEkGAwRsK48ahwitW
	QSriaBtbiSsQJNLPkM4YYDy0s6RhZ0+PHZYtFItpmuoNTBBMf+Z5uawnWBG+vubAc6y6KhLXUsg
	X6KzFKwxB4BZNq+ntZh5cq0fvyICl/sdfPANQpw6RCwvxt6Zyb1SpLJoUyDD3TqBjjsFtUck+55
	k3jdS14IKnAcgd/20CZxh/Bv7dbfylOmwmDcx7b47cgg2Xh2uQ1odV7X5paNaQoXBwmnfqfjZOa
	hz8t8Eauzq+xmvGyPtCuR3EAw0lSmIALRXL3jy3IFh7zjbGj35iTihyTxtt33R6NVOu5oHGws=
X-Received: by 2002:a05:6a20:5493:b0:398:981e:2e13 with SMTP id adf61e73a8af0-39f2f3aec2amr1890255637.62.1775197827036;
        Thu, 02 Apr 2026 23:30:27 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c41b8dsm4572258b3a.34.2026.04.02.23.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 23:30:26 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH 0/3] ocfs2: stop BUG_ON crashes in suballoc invalid-dinode paths
Date: Fri,  3 Apr 2026 14:30:13 +0800
Message-ID: <20260403063016.438287-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 10995aa2451a ("ocfs2: Morph the haphazard
OCFS2_IS_VALID_DINODE() checks.") converted several OCFS2 dinode
corruption checks from graceful error handling to BUG_ON() under the
assumption that every caller only sees validated inode buffers.

That assumption does not always hold for JBD-managed buffers. The common
inode read path can still hand suballoc code an invalid dinode, which turns
crafted filesystem corruption into a kernel panic instead of a normal OCFS2
filesystem error.

This series restores graceful corruption handling at the three
independently reachable BUG_ON() sites in fs/ocfs2/suballoc.c:

1. reserve_suballoc_bits()
2. claim_suballoc_bits()
3. _ocfs2_free_suballoc_bits()

The series is split per crash site so each patch fixes one bug. A broader
follow-up could harden structural validation for JBD-managed inode reads,
but that change touches a much wider read-side contract and is kept out of
scope here.

ZhengYuan Huang (3):
  ocfs2: handle invalid dinode in reserve_suballoc_bits
  ocfs2: handle invalid dinode in claim_suballoc_bits
  ocfs2: handle invalid dinode in _ocfs2_free_suballoc_bits

 fs/ocfs2/suballoc.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

-- 
2.43.0


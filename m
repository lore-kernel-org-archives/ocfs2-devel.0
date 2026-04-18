Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB62F355F22
	for <ocfs2-devel@lists.linux.dev>; Sat, 18 Apr 2026 13:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776517853; cv=none; b=FsLz8/ct0c56lnA3aXME3XjlWRvyr/2yQfLoZipcHWa8hp2ZPfyuXeLlS737JBPUqTYQTF+e9fbJODBcX1zcjP/+m3T/Voy0UGt6ueAoBf1Y/hyg9McZ+pLsFNxMcmGHrM0xqb2c+/ORNWIxDoZO8sJMCXB5CMgyGZIUKmF3W5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776517853; c=relaxed/simple;
	bh=aPbZ5ymb3d5dKk9NYSabaQZ61XClFCKtNen++M+fRsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eCeUZSoFTzIAsmLnjmiDUWs/nC8o7Sd/qCIcLOLdZ75MvfwetfiIP6xIUvuO9z1jdPsFFZ0tXdV4596ajO8XnajNls4f28aCI/BZ+t3UgzS+k1bzEnavC2GbKl+7MM3VtYMVzaAI8vGwXIspeBxLUQmfgBZn5K64tdVbnN0wLnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HxsXp62e; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HxsXp62e"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48897fd88ebso16280195e9.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 18 Apr 2026 06:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776517850; x=1777122650; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=700dgybNF4lsIbcRAdfipQ719p0FNtgEBpwSz84w2qI=;
        b=HxsXp62eZrlOQdfgKmUMhKm55g+fGbQeG3FfuMaRbgkmaTwiv2gYSu+TEWZwQJfJFd
         mnqiUiqGkwHwnUsG2R7rUiYmsiyd5Cuun6R245FGHu6DqpudUfPvakc55kaY/ETbH4Gq
         nh7OtkT1vip5fochd+vAfrh8zdPOp+hYn+CUFo6vtDoB4KXRrtwwLFuki9A/FUpqoxfp
         640KcKq5U6EUbamsxHixdLX0EoVKOmSNaORpIeOi8kqTvvHMOYvzyAd7JvLecw7/X9b8
         whOuNCcKBfcF9Cdqh713lOGuUUc3+aQVk+3nBfu7mAIgry8W1UOrYqFIEfSVSM0s1O/K
         cVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776517850; x=1777122650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=700dgybNF4lsIbcRAdfipQ719p0FNtgEBpwSz84w2qI=;
        b=K5wVdDDZNVlAPHkZ2tjmBm3ADn4kotFH0wt+6mW/8+dtVC2YeGdk0Z71DOTNoVdNfO
         QDtrYn5p6QsFRESSSUbUy/Bx6Vj51IY0Jp3OhI5gwrqurqoiC5iiZEstHvPt1nVRmkah
         /v+fNwZ1bl12cyw+8EmJthj5vSAaOYKIN0Pqt//cm0NH6Uy35r+le6FNuso1MluwcoYw
         GZpcbTPE2rN44Y3ALVUKwdkvYoR3vPXmQE5VgYEuAQT8x2+oMb3JzQr0WqXKzQgr9gTF
         O/qjaUtR4/pPuruLHMbytGfWYbzPs/VpYGbbaPmfVgHzkLqBztcRxncpl2m8yB8S5LOe
         47Tg==
X-Gm-Message-State: AOJu0Yw2eqwLzk+8Ko1yRuZeEgLWIBPEDCJ8UNimQuRc8Rz2WZlRtmm6
	9IVbe3sSsNCJlZQY9p4ohZr/AOkpmFevgjS9ofpjyYR1pwbNy2mEMgw=
X-Gm-Gg: AeBDievZvE1c9WYMc4tozmRMw5FsHjEgX9OfjzO1cGN1MxRAPq74ECO5A+9KnwbtALe
	NgGubT+guYhfDV++zESx67YNdLrR6C0wAn+p6Q00mXAK/SJMnzWkxJM9JazOpfR0PddktJLa8RH
	cpy+tSGYgtPzU+ouq8orIowUwHn3ClQFw+HREA2HBpzUaWLz2b0S9Q4eDUxyrkZrt+pFNdaBErN
	1RHr6H0fzfqjQ48VOol0mTjiKEiZmD0VP1atl7shs47OCvDoK25CVJJIq6tWzcYqWXtu/fnnbf/
	gXbyRdkvWIzE7eceTmBUuwsWMcmb+Hd/ZDIx29QrOu52F6MLM6Llh+2z8kZkWbF1J1mFq43Qf73
	8nQDU3VqrUQyDUPqLWECaM0x068gBkqCeS3CtkJLj05LPn0FAjU1rPwQ3ivGNvTvCtJLHgzNCh1
	fgI0M=
X-Received: by 2002:a05:600c:3e05:b0:486:ffa3:594 with SMTP id 5b1f17b1804b1-488fb78049amr98923805e9.23.1776517849810;
        Sat, 18 Apr 2026 06:10:49 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1393d3sm190186135e9.11.2026.04.18.06.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 06:10:49 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Sat, 18 Apr 2026 13:10:48 +0000
Message-ID: <20260418131048.1052507-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does
not fully initialize it. This can lead to use of uninitialized bits
during quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 12cbb4fccda0d..f55810c59b1b1 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(struct super_block *sb,
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;
-- 
2.47.3


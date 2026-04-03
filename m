Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED3D3644C4
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 06:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775197838; cv=none; b=hNS8J9Vx3y15I4PEOChvk0bcBm8L1KvKyQg+n2Nd5NkTPf2Drx1bEXEhSSD1nxpmZrnfvjFJpq7RNKVPjd8pNj1Mjwox7nzZ47KMX1nLDzd4peKMWFfar1TTQA3fYtxTmwBJF6t7YKyAr/unYuAAvlpylBEKUKSLuNQx0XjO8kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775197838; c=relaxed/simple;
	bh=AyTQF/cGPP0NGCOED8q8zmLVfRLlR83ojMuRP0TmCeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRZK4Dvf2N6U2vKjZ43vSVUAI6YcYzlOkzPtJQusgvS7/pNHUlshQTw4VxLoFXE7H7bEKfknbXJ82s4FLrC0SvJpJ+VTaoqXIgXI4fnagBw4SoE8zhfplxE9GRxNK0gTZ/x+KYSRNViGimlg6cq3M5m17rU7PhMS2dtAKGJWTlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rrgst5bL; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rrgst5bL"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82a67ce6969so1202610b3a.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 23:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775197835; x=1775802635; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+f0oKHtSJA7PrZhO35i+p8/nUL8EucM4r8b8pY9Pn8=;
        b=Rrgst5bLIKGgSkzq5ocxfmADAw+9swcuUlWhyTdRy4uCzzCFpS2wl/87U8Q8D7hMUU
         +Z3zS1KnyOdcAKtS0zeCh2+X12CAydstyntS+vWxVSSHEDp5t/yc5/GDD9adePtr3Eqr
         xNV8XXq37I5lBuMl/L5mB5w6niaW2ONFP+tNXE4Vi2V/Hc3CBpJ2olaLXxgXJsNvmGUd
         P7+nR5J4ynOnf7/a9SZuBUPex9KS+db47Uzf99R4GepDDRG4E+QEb+K7682MiSUZ9iv4
         4ldyJawX7fJji2kRtrRNYpS4aAWnL4knBZOEsG3uhACYQ6gYbwPPDpPF7/tdNfb8cyDA
         Iqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775197835; x=1775802635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J+f0oKHtSJA7PrZhO35i+p8/nUL8EucM4r8b8pY9Pn8=;
        b=DPcQUFmwikiA/NNYcsHQwwN0ptaKoWjdOLHkCz99taKHHqYNXM+/b4DhxYl3tUFALB
         KtD3oSrtOHWAgCF1xOcpPB/uHxENFZGKQmX9KBof5AHSWr9/sNaPFs5dKUHjFNtknVXq
         tkYZeYRLPmTYUdF76WTv9fmV4U0Qk2J2HzExy3c/dzVdSJSpPzxf+3f/0M2zDmkBaUXF
         Y5d6XA55itmciIRRBrdWFJtwOLQJt6IAmplXw6/CYGSkEputCdO0ZMqIeqJMo08NqNOo
         uXvPPGuLMyOzztD0eBb9W6TxSKw4GWiLeKhxV6wnISDy+NUaM1/CcAz3566TkOgs2Ozh
         Kf9A==
X-Gm-Message-State: AOJu0YzFIyEV8D4orKdgzE2pcmZAk+E2ZGafwvO3fQoby5LsFqM2Bk85
	Tsg2X1tPGg9N3jC2g7vb/gx2xTSGy3WOpwKUHrwWGdtf2w5L/4/bp+gdiPr6UElL
X-Gm-Gg: AeBDiesVYktfSif5QPy04yi/iwxaZu+QJtT0ABmv6YnsQhCAiBh6I3whm7i2rk4UP+q
	CaJjhwPPqETeqQnuiliHBB8LN0IfU/SVjaswtwNmj0mf9oN+zCxidL1VtoJO8w+8kjT8S+2ZAYe
	kMbQQtruXfnWqVKOmlYcuNlYd5fjUo4/28yK52pJ1ZJJRSua0yRLKQYfId/3QDGFqj9Ew6AgObL
	MeenXoAzL09E50mb2BB+CZr4E2LgS2J5BPqs6J8iXCp5gSfwufxmDy4Jh3B4/x0HJ/PGBeBazqS
	h+jtqH8vbN7s3J/gm0JICr8KORXiJcU0E2TvJIxPsjw3Inm7VOiSUB5YjbRNvjDgyyGaRuy5ohS
	FfV9NKYK1WzUbC1tB70HnMIWAMmEsQALyUfFG2loNOHOpthaLMYVezufe5xO08v48dyU8o64CoK
	QFTNS/hvxmyZ6sn+sWaDaX8Vk61I922v2s0BwjG8SXw/7On26bp/+EFZdwlIkZWZc/o6lRFmA=
X-Received: by 2002:a05:6a00:4b53:b0:827:3222:c4c with SMTP id d2e1a72fcca58-82d0dba3201mr1827582b3a.39.1775197835318;
        Thu, 02 Apr 2026 23:30:35 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c41b8dsm4572258b3a.34.2026.04.02.23.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 23:30:34 -0700 (PDT)
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
Subject: [PATCH 2/3] ocfs2: handle invalid dinode in claim_suballoc_bits
Date: Fri,  3 Apr 2026 14:30:15 +0800
Message-ID: <20260403063016.438287-3-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260403063016.438287-1-gality369@gmail.com>
References: <20260403063016.438287-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A crafted filesystem can feed an invalid dinode into
ocfs2_claim_suballoc_bits() and trip:

  kernel BUG at fs/ocfs2/suballoc.c:1966

[CAUSE]
ocfs2_claim_suballoc_bits() trusts ac->ac_bh, but that buffer is not
limited to the reserve_suballoc_bits() path: local allocation can also
hand in osb->local_alloc_bh directly. JBD-managed buffers can bypass
inode validation, so invalid dinode data can still reach this function.

[FIX]
Report an invalid dinode as filesystem corruption and unwind through the
existing bail path instead of BUG()ing. This keeps the allocation logic
unchanged while removing the fatal failure mode.

Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/suballoc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 12ac2bb3f10b..b99870aeaf88 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1965,9 +1965,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 
 	fe = (struct ocfs2_dinode *) ac->ac_bh->b_data;
 
-	/* The bh was validated by the inode read during
-	 * ocfs2_reserve_suballoc_bits().  Any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	/* JBD-managed buffers can bypass inode validation. */
+	if (!OCFS2_IS_VALID_DINODE(fe)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Invalid dinode #%llu\n",
+				     (unsigned long long)OCFS2_I(ac->ac_inode)->ip_blkno);
+		goto bail;
+	}
 
 	if (le32_to_cpu(fe->id1.bitmap1.i_used) >=
 	    le32_to_cpu(fe->id1.bitmap1.i_total)) {
-- 
2.43.0


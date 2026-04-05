Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBDA30C635
	for <ocfs2-devel@lists.linux.dev>; Sun,  5 Apr 2026 15:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775404047; cv=none; b=g3BXRDHWVI/5PL01Oaa0lL2ijv0QFnbJKP2RLFn3JXBHBkrAM3FkDHyxMuHEDQQCOPxfh2sTfYetlm/XPZ8phpn685KxfSebgDN1yklAWlXIdFu4UsXmMMaatEAKn95KBBIcpLrMikgSG+SHz1sHWe2BF068Q0cov99Y92S51iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775404047; c=relaxed/simple;
	bh=EPE9N89KV663jvYuDoxO0xN5AKqWQTFRqxYvpbBg0eo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cw3KhL7+U5EvhW18knytxmAuA4L1Fu/jL6rl1PaIqjyoZKmThe/RFRihl5vkJJ23GpZodL7cufLcc/SxzMMTS7rMBmZW9OYsg5CTSEDoNFIaOkBMCUOlk2AbGF/corg/BA7hgh7kGhaTp/AFR3AEpgPdZNCf7jv5rcJMEXxCz3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GKjG+JJ8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GKjG+JJ8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso28968825e9.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Apr 2026 08:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775404042; x=1776008842; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rgPaYX1vw7zD8x9Hq2ONqUeVNJTtmY6U9Z87WRHw184=;
        b=GKjG+JJ8yBw8TYSb6u/GQhgyLx8adWNBFHf+VW+xOtgioco2+2s6cFPjNMzEy3cn5X
         KQ15srsFMbjY1zMvk7q1jhpELU+r5fekTgMneL9VdA0KcGDDwKDD0bt1XFzypTAMiqEA
         ENvvza8ZSvJuRiyOwIhO9nf7mirhaGb2d4qDaCO2/onSt5a3FlyQV5DVkNxnF3IW7uZO
         LmvbQGOA6jW/eqfjVsdL8ac0Hk5H5Ygy+E1y0pIUsSWP31+hTHhnFBCjfGy+gGjZ9VwB
         ieUDgHX3lL/KvuKtuEK+iKMj7H9ZjF00ElbgjUxaT4sibP9Zg6VoOiGci5oMb5VOPAow
         LAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775404042; x=1776008842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgPaYX1vw7zD8x9Hq2ONqUeVNJTtmY6U9Z87WRHw184=;
        b=f6SlxqNPCxMlrb0MJp18pPNFGPEdaWWYH34AsPCc9jkE2bhUT4eIP5b1WCvSsYEjBW
         onIHb2BwcTf7Z1kRd5FRovaVd6K2BqS/hy3eDuKxzPGBfhWSLVmcUwU7BjarGcvYYs2N
         71x/3Mv9LfeG9ctmyRbgPoqwMsgUGV4silT/yptTsIAMEB0LBae2qXkr7M40ekb+/tqW
         eYREyf0X4HUSlJQ65IWezwMOQOAV1ta1HSOvnHjZbD+GLHjXR+p3YE7usccouMvOf4hh
         7fZcmCNbnLyz6p9NhVHeHFRFPzevWojsLD9QJztNamFoz6dYHdzi7HkRRMPDLNGbELsp
         UV8g==
X-Forwarded-Encrypted: i=1; AJvYcCXRWXKhWsOJEk9tRSfz+3u8SIl3PBkjVOYLkUvsJO+MnvFe72LC3TwNWgCESRPuCx+145Pp2SLx6cdGtg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwEGtmyHGqi6EM+E9fVLk3KDu66OOBm7MAKKv/0XY+ixTykrNDH
	vgAhU1x7LZ7N6XzsUmJydVLMtfg7ZSUrdq3AQdaUrAdrZU+8rUlUekeU
X-Gm-Gg: AeBDiesZ3JYrT/k5EM7i1KCFC8JL5yA/gFVOIsU4PrRYJxFS4ppAwEReTNCeaHE318d
	ZFCN6MPXICVcXXVN1jiZRuaQlSwr6WC3fWGe3h9PzXhBbj1bjok3S7W9UKDok+JJSg2xotqe/P4
	FQ60k6r2NpCBczALnEaiJRUjoCYM/iD4Lu0MTvrjlJ9IJfxOAygHK3JsUByHqWpC49qFPc4YiNw
	GjoEjcNoavhCKOVtT2ZZJyVoF3YNKnkmOoHn64Zvz7KclT0uXTdi2LcgTobwrXWlVUJZCltd5q1
	dQzY5/dcnBCJetvd+mCP9/vL6a+NdtD13FEIhqPzUnOgFdP5zJBMaAJs07JiI1m/v4hPbfPIGdb
	5ALXtvdkSUO6528Uj0HkTJyeYiG5iFn9XaFBPwrAyeJvVUYxCcfgXzf72mFmj8MStVY4cWF03C6
	C6JXCcW+O+MmeH6ExFKOa05hBAXzstq2MHafo7vdco6VoEGSaLZI+RjoTHuP+xRjjSW2LdC6hbS
	mJwaJnWLgSD
X-Received: by 2002:a05:600c:154b:b0:488:af14:f1da with SMTP id 5b1f17b1804b1-488af14f30amr25977845e9.7.1775404042142;
        Sun, 05 Apr 2026 08:47:22 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48895e19c10sm216312345e9.8.2026.04.05.08.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 08:47:21 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] ocfs2: use get_random_u32() where appropriate
Date: Sun,  5 Apr 2026 16:47:20 +0100
Message-ID: <20260405154720.4732-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the typed random integer helpers instead of
get_random_bytes() when filling a single integer variable.
The helpers return the value directly, require no pointer
or size argument, and better express intent.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 fs/ocfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index d7c58fd7d438..b875f01c9756 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2124,7 +2124,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		osb->osb_cluster_stack[0] = '\0';
 	}
 
-	get_random_bytes(&osb->s_next_generation, sizeof(u32));
+	osb->s_next_generation = get_random_u32();
 
 	/*
 	 * FIXME
-- 
2.53.0


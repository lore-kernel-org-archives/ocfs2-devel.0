Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C86C161311
	for <ocfs2-devel@lists.linux.dev>; Thu, 19 Dec 2024 02:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575717; cv=none; b=ggPttJgUmPICaiRiCCKjPD603Nj9Hl8Upn+3mebQkjQyRS7wl0y3mIE5bwACICKS5TZb5aXXPqLyUucSC7NFw5SiDtu7S1zttlgMU2pBJ0N3Ml1HTMphnjzActOmOY9crc1Hl07z2LBUfYKYEQAbUoK/mVa+OkwzqAcbaJ64OlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575717; c=relaxed/simple;
	bh=hl37Iql5X8gsZ29nKhRpHi4iYM29ft8c5jBgwm122Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D+9Ko0isDKD17Da562U/G6LP1GAY6eZLJ0SdoWdPPe6b1J+FdF70jhHopTXNwUvLrTZaVEYu/IQLzR4NsC1ePGCkqgbHJS3TBNy7tVZV1ESc9CLpJy3xO1V+nXhegXlmYORy7lIlF0iMnLBGd6UY2orDmLU2O+jmQmzBoIZtlWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kf68mBOa; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kf68mBOa"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-725ef0397aeso257521b3a.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 18 Dec 2024 18:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734575715; x=1735180515; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz5f2fkK5TyUEN5/ypHLYKDvnfLQ33CHwDb71kc+wK0=;
        b=kf68mBOaCVHyMFbtyqjGZMJ8J5XN1Q4puohkS+31qJXeuXUMM7wBHCREO4kCL/2IVT
         G5wyzAVHnURDbuPEwq0j/ihrGYAUweO9hTwup3Qobw8xwf0Fu7Xo6OXViSQEs/zQOQyD
         WHzbwg8SmS3jkgcnmI+/RzbdpJ5XwB0m04ES2mQ0JccFnNTDh7Y69zsZozOexyeuY5k5
         9K+Ij/flpehn3yIxAD+Yr2YEnJn9KKWPA5Gp/LEDVfLdcJx6s9D/vy6wV+Iej++EJ2FO
         1la3GDvgwWmsIYaWJA8SoChGED0kAspbRkWnjsSCsWKsIDCzNdlzF+X+6QX8XEyeFz7R
         oe6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734575715; x=1735180515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zz5f2fkK5TyUEN5/ypHLYKDvnfLQ33CHwDb71kc+wK0=;
        b=GTNXKNDScclNNHVCxYL/LTrxw5cFqqd2qO2TFrtvz+nVF03BZP5cU7ukmJo5Vy20Yt
         FHg/VvdFRj2OUkA6kq7OAWgB5SpQEGUmja/xJy7ZQbjhGbFLqyNEkSllTcG/N8AtcTx0
         ha2fXHZbF5pSP3q19IirXGI/aA7xonyqVoikhMLCatJZpj3siqbojhJbNetTKhSkizIf
         9V7DRJ0GIFUburbSBtL5CgggYkolc5nrTxBdwNCWNOd6n/751PpqS6wCiQTsHK3Mc38U
         J4/nvrhWi7KjOJ0m9NkA6RrvObZn3/dlvJveY+gxVlD+0N103TuV+IYHcltqoW+5NKlO
         +9iA==
X-Forwarded-Encrypted: i=1; AJvYcCWdz2PslTUe6rxdDhjmmpAK4szIlRsfTobo66KoTr1qXnxIROXymMSXnu/bjAJJmG/b9bR0ItHMsZx0NQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxpUDMB4m5VXyPxPRsWistMJnyuGV9gXgZX0BDdXiIVdV35F5iQ
	o3ZuwaEV4V3lwqgKYglTzIRTl72J6xoF7yR/KaYLfWxIZF7DYE/l
X-Gm-Gg: ASbGnctZO1M+LDTHNy+X/O9Lbe80MkqGyPRiX8EjB6unH9M5LEVcqGEDFLLHAKtcxwv
	hJepV3AB0R9HV5YoOEcOtxUN7CGRBdNmXZH6Mdwr97ZB/LsT52S07qAEnVfTyjEIK+hAHm8jEoa
	xvRN8L+vL6HHF50ut7oRugNyjr4UsD6gCuP28BbaTVYhZmyiplcYNQeGHZu9fHr9WVphk2EGoOs
	dZH485sWEGIh+/iGLPYc2m3BKFd2o0VZZqfDK9BWgixJROaNy2CGeWBv2xsovEUqN8td9BUmToG
	UggdSd4=
X-Google-Smtp-Source: AGHT+IE+5BVERtvEj0uFGUNd3NBBPkGat0lwCNqupmyw0FAX2xvKE0cJmTowKcGod/Hmj9SrgliLyA==
X-Received: by 2002:a05:6a20:a11f:b0:1e0:c0fa:e088 with SMTP id adf61e73a8af0-1e5b4810ff0mr7532504637.18.1734575715510;
        Wed, 18 Dec 2024 18:35:15 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-842b821da83sm142163a12.40.2024.12.18.18.35.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Dec 2024 18:35:15 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org,
	pmladek@suse.com,
	kvalo@kernel.org,
	bp@alien8.de,
	andriy.shevchenko@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	x86@kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	ocfs2-devel@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 3/5] net: Remove get_task_comm() and print task comm directly
Date: Thu, 19 Dec 2024 10:34:50 +0800
Message-Id: <20241219023452.69907-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241219023452.69907-1-laoar.shao@gmail.com>
References: <20241219023452.69907-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer. This
simplifies the code and avoids unnecessary operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 3bb04b05c5ce..bea70eb6f034 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -640,10 +640,8 @@ EXPORT_SYMBOL(wireless_send_event);
 #ifdef CONFIG_CFG80211_WEXT
 static void wireless_warn_cfg80211_wext(void)
 {
-	char name[sizeof(current->comm)];
-
 	pr_warn_once("warning: `%s' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211\n",
-		     get_task_comm(name, current));
+		     current->comm);
 }
 #endif
 
-- 
2.43.5


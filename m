Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F9718C91F
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068835; cv=none; b=BUBXrxSBBO54G3L5rrObGivQA1Ndxo8z2AjYpa+IlurTCl0atlPuhC09XXhUb4sliRAZjS0Lej4Je+X9k8ZxThXnqXjpa6wLoLWfJjZIsPZrnglWzzv4h55JcsCTyYUjMaG10mJU2FC681sai4KfaEFX4TDipQ41igFA1clQp8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068835; c=relaxed/simple;
	bh=QTcEM0pa4oOmr4wRV1zBU96zbdoeKwVEN5PXZd67iuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oywq5fL20caYnc0I2SLfLJEaihjrvyhxXyFBMPO37S9RDKCnbwu6L+rkrIAKUQdlbzOWl//bnnCHlZ30UHNWod9UpsNtgUGqPSipXKoIhUKepOrlqvTmurMcL3yJX6AiCmcUjv7eZ5IRpa6RKYs1LR4CykSZvEIFcjy7Z/7xc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=axiXwipQ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="axiXwipQ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216728b1836so12307375ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068833; x=1734673633; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gS7oaK0RsPIguog+zKCBYVnzq+DdL6weynD0punt/E0=;
        b=axiXwipQCrz/eKiACdDJzBgDNi/6spK0tJ5f4jaEgrlXwb/8n2cjM+Cxj0H8nXeFuG
         jKopf+RtrEfh/yMzfaQ9NJvZTonQvFBcS74bwzbxuU4qb7SmnWRkuAtpuFGYj/+B3sbQ
         F9VS69fJowp2vDul3lUkGVicOMXpHR2xuIWVp1/P/ZcElzRCvHrrTEkhdpYGRY1VAK9z
         mUBQo8k6Egy4HttB+i/+4NVrPb3hJpZf06s/Jc9NHrzhJx0DnPimMJvcfEiuf/nbHacZ
         rMPVGU0u9Of2sFJrFdpVn91BYayPdCgUQlBDXgCcU0wk1vQ+O5PrrKVCx0BniIyRiaqH
         kTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068833; x=1734673633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gS7oaK0RsPIguog+zKCBYVnzq+DdL6weynD0punt/E0=;
        b=kFtR0ZRus1AByVU3kBWp/+BLHv3dEtWvPzaW7bxSM0ApIgdEg2UDD6rIR3YAWrpLmN
         ILC/45yKiT47P3zV4CZ2umf2lun0+ppZhstworCu70PR6ZtKH1I/gz8F1RGJD4+7Cu4M
         8qPlg4ciyOufI4tuHBjWIyPFJX/7xeG6Ye0ka+DU8mnL6r3garaBZEBiZ3bEB8N2mpIy
         31VfnfcohiFkvuz3j1N8YZx4j8mQQd+ok6VuWXrYVpHgGNbWMNhxWeBnB+ks5rtmjzDC
         eoKnwbB6paL08llGDbs5nSRCEF4ai8puTAFFf6iJZycjiAm/rvBEhcm17t+H3FA1jm5r
         dvtA==
X-Forwarded-Encrypted: i=1; AJvYcCWpSsL2FmaoHwjtGoiHSkx7HRME0h/CzqkXnf7arrS9O7avQ+3BAAiuQbaayICsWNEMLx9SZaMRFTjsvQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzts53EhB1spgEFUB7tRKpTbe3TDXx02YNeJndXg35yMEqARCRH
	kn0SQu+AqNRBUQErr1/wOJONRYcTjUdv+TAQIe2AJ48z4Vwihc6m
X-Gm-Gg: ASbGncuViN+yItYvg6Aevm/Lw4TeFRuk8yRNBotfvZ9iJol83Pw9V3ydRsHB2Vl67ou
	mJn4d0A8LU5UOAMga0I3cvipA93TccT7g48DxgW4ZFcTHa7L9kTe0CFDwpl0TFSo/N2M9x4I/tE
	jqaddDxem76KjyU0ol8xCRgKznDS5Wa2u7kuqf0E6eUQ2g5koETGISsmyIYPvwSX3OSrztb+MNa
	rCxAsV3MsGqnD7qZlS4lsoXxxBp+5CCGPdfi7dleZ76YK3qM4thK92iTZfN6fDjJ/CRjTcbIQxd
	Wk5ho/4=
X-Google-Smtp-Source: AGHT+IG/u9vPHYJsr72JqaDrYLM72r0Mv+gF1sZwvgldiU0c1giVELNbwcEluD8XRP6pboK2QDHicw==
X-Received: by 2002:a17:902:f60c:b0:216:7c33:8994 with SMTP id d9443c01a7336-21892a7a811mr23989435ad.53.1734068833602;
        Thu, 12 Dec 2024 21:47:13 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-216483dd292sm82564985ad.226.2024.12.12.21.47.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:47:13 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: torvalds@linux-foundation.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
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
Subject: [PATCH 4/7] net: Replace get_task_comm() with %pTN
Date: Fri, 13 Dec 2024 13:46:07 +0800
Message-Id: <20241213054610.55843-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20241213054610.55843-1-laoar.shao@gmail.com>
References: <20241213054610.55843-1-laoar.shao@gmail.com>
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
 net/wireless/wext-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 3bb04b05c5ce..1f2a7ab546ba 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -640,10 +640,8 @@ EXPORT_SYMBOL(wireless_send_event);
 #ifdef CONFIG_CFG80211_WEXT
 static void wireless_warn_cfg80211_wext(void)
 {
-	char name[sizeof(current->comm)];
-
-	pr_warn_once("warning: `%s' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211\n",
-		     get_task_comm(name, current));
+	pr_warn_once("warning: `%pTN' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211\n",
+		     current);
 }
 #endif
 
-- 
2.43.5


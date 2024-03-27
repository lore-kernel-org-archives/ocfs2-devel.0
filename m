Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF96134C6
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711519768; cv=none; b=Xu4oCToRRrFFMb5hyHo4wMcVGaoWoih9FqZYkyQcPLW/c7ipQLK5eLg8Y9pJ13I8WHoOQJZkTgTf+s0HFBHr1Ujq35Lnq8PKVhKtN8VoFFV9XACnZMQMEiEkAis1QsoNDwKeUlneoDiiEhBR4btlIXlz6JmOH3BN3DhphZ7+nN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711519768; c=relaxed/simple;
	bh=HR/Fn+pJDtCMBi9fd9cSg3uFhSjvM3m4xFqr239VbE0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=To/WDbi51dh7l9bBjFFdpEke1IVASR7hDsmEDhbOHYhMtHdsnt97ckHc5y4asy3rG6P83mW0ozihyvkhx4SRX0UGuQp1Ga6VqMO9ZfErE6Glfk5ns1e3PpQ3X6ksmODD8yirzokhlEL+naRpYpDFVztkhjRdkakGp117DJyAhXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XcEM6xxI; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XcEM6xxI"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d24a727f78so70649041fa.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 Mar 2024 23:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711519763; x=1712124563; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fzvGQo3Pwe/zQYDmqlh9eVSU89lreMa78gFUm2mdovo=;
        b=XcEM6xxIpn6mzaZNPaPMg+OXyk1kD2OTCy2pOhW2xnjcw2k69B8uUeLNgKe1i7h7Yb
         UhZvglbNcOKa3rTicqKAAnhBTcLVsOykwaGrWHNFK5zeBwTgFuUTsg79hMUTEiGqfxuw
         /tPySGq/UBYZKCzuM8Uh/+YFIe1tGl/Zvs1f0Bq4w8irwFJutGstGOmoP9OB7FKwjVLb
         hPfGvo3RwmohY2sf+InnRb3IC9pv5d3t/8F62hf/BvmXCmHWCde/gs5+/l11nV7R4UdQ
         WKF9ymrJ6LOglywOO8nVs3FXj+OC9LVbZ40H3w/YGTd97WGo3/JrrgvJha/sW81oScsz
         nVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711519763; x=1712124563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fzvGQo3Pwe/zQYDmqlh9eVSU89lreMa78gFUm2mdovo=;
        b=M8ayW1GgScAT1nqci5iCpBMQsAh+PtQgm8A+JGqpHzvR7O4+BXbGEDnBrXLoskA1zU
         KudnsFA86Asy8KzK2dP4VMl73f2H6DTRbsFB1IHtgus4C3TIfRs7pRGDjsF/sD5Lv/9s
         ldFSmkG5AhdIFAXjw9cViSHwGNy6fSUsovuwr7UuhAso+iW8zUB/2jNIRixJigqo3n4w
         bi/YRBEXFWRYCAA1XSUGssJ7EC1EGTKAsR0H3ncCUHxw0UHyaZSSLXjKd9Uw6dujbst4
         pV1bpA45ZYskmDe0f5QpJ9WmpkMBOb3WTjvEOBhOKcIr0K43/5gDSKDj3KA2/v611sKg
         uhMw==
X-Forwarded-Encrypted: i=1; AJvYcCW+YBnGeanX9cifkCHFth2SM8ke4zuxpER+0ucsyqNoXY2IyBCiE59HeOG0stkI9GuSmwLLIP43Wy4Zpz9ZtetaE/KUvfcSc+O+Dy8=
X-Gm-Message-State: AOJu0Yw7Mktecd1a7its83mGaxmT9qIChMTz0aeyTQIINqnSusLj/um2
	q0ULdDzzbxsr3a/jhS8+GMfqrThVY1OxdHwmd5bO/Rbdlnz13RpoGUkfF6wc4Yw=
X-Google-Smtp-Source: AGHT+IH7hCLnYCG0fJiIIlr36TbNeiOjJQdusKTEmrTqrI+kpaD/ft/8WeW+5cSzrfjbr4t7ax+5uw==
X-Received: by 2002:a2e:6a09:0:b0:2d4:3dbc:16ec with SMTP id f9-20020a2e6a09000000b002d43dbc16ecmr3414851ljc.20.1711519763573;
        Tue, 26 Mar 2024 23:09:23 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id s1-20020aa78281000000b006eacefd8fabsm93445pfm.64.2024.03.26.23.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 23:09:22 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH 0/3] improve write IO performance when fragmentation is high
Date: Wed, 27 Mar 2024 14:09:11 +0800
Message-Id: <20240327060914.2583-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In v4 coding, I found new issues and split 3 patch files for easy reviewing:
- (1/3, existing) improve write IO performance when fragmentation is high
- (2/3, new) adjust enabling place for la-window
- (3/3, new) speed up chain-list searching

Heming Zhao (3):
  ocfs2: improve write IO performance when fragmentation is high
  ocfs2: adjust enabling place for la window
  ocfs2: speed up chain-list searching

 fs/ocfs2/localalloc.c   |  17 ++++---
 fs/ocfs2/move_extents.c |   2 +-
 fs/ocfs2/ocfs2_fs.h     |   3 +-
 fs/ocfs2/resize.c       |   8 +++
 fs/ocfs2/suballoc.c     | 110 ++++++++++++++++++++++++++++++++++------
 fs/ocfs2/suballoc.h     |   6 ++-
 6 files changed, 119 insertions(+), 27 deletions(-)

-- 
2.35.3


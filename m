Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6470515A8
	for <ocfs2-devel@lists.linux.dev>; Tue, 29 Jul 2025 11:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753789329; cv=none; b=UUNWC3Etn59h+Huf1w9DCaNUc28r27Qmch5VrOvNecwM5OOZeQi81Lz8JOawAT5TtMPvFFNmnNNrqRvq6+m0iw0ELrchOSXhSll821XLGTTyBr7GcNDxv4qJcs1PNjgqk6YiHe/KJoI/RPJ96CYqGwdnGF0VyMQXEkER1NVunrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753789329; c=relaxed/simple;
	bh=o8XI6Qww8Kx2zax/zwUEYzHQzQWFjOFhte4WwN8IaU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y8Atcc7vYC8vom48Sq9Yfi6gOA10whl3qbd3xhmZsjrxlFhrHekcLS7rdaiRjrUT5hzVknrA45vGLEFo5VDDGV+V6n1NVRQ95CneqOzakeDFUj00fbeaH1R7frqT/rCqpxb0bymtdOvjMcMFmz5DK07Sz3SwlJqG1CVycJt0dYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mAXoiPYD; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAXoiPYD"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-455b002833bso20888205e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 29 Jul 2025 04:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753789326; x=1754394126; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aL4YbNzCG29DBkIuw7Hb1YlrFbRw4MJIPtbPF3ye9w0=;
        b=mAXoiPYDi24esqQ7e7cAoM4fu+g6/02eZGS2Dp2EXVDI8OgCK0+DpGw7oP083ulNZs
         dt4labLg7cXCH48gQm4GWNulxQUveXOIWuWz4dq1FczPaWsL9cF7uaFlkdx69/m00ZNi
         Ws+bl+ggLQcAS3e8cLPgLbk0f1FUAC5rncxvn1Wyg7PquCxnHQHRqkPJE569934utWFr
         e81lSW7dPbuTjg83HVy3oH3gpp7G1J2JyVLh64SNvA5qB8nHIysS5VtuG/E6Ttd1aDx/
         6cLbJtZGTaBmyFQwqoCTFJc0iJB/h9mM3W6IAvfdVfA0UCJtJMp+RU8xV3mJcw1tbwR/
         hgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753789326; x=1754394126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aL4YbNzCG29DBkIuw7Hb1YlrFbRw4MJIPtbPF3ye9w0=;
        b=YoDGzk6zgZgywLHSPuQvf6Uo4Cns+/ygeV2BhS1vXlF7XMMfGnT8qT05iguqAKdEED
         wsGm28m8qdbWS8vCAvvT63L9f1CCNXYWPw3TJd+I171eHIWZRpFKQt90jKq/Gg8Pfm7j
         b6C38hFTuHmuR3K+FrnFvw4p1mdBlyxkqFpgu4eDWGNlY3yO3rSIXelYRiVkidI4TwCf
         q0TChlaG5wlGy8W1KZwdfH6C84XlrqUEbxVFwzmgVXCPYwtoeSodt4PLusO6rXU9VEDA
         M7biVfQ1GEMAvHaLW6NiLNcY366eFVuPNgbCYh3GCX4ohjcMbQoQiPwPImUwKy+H18iA
         laOg==
X-Forwarded-Encrypted: i=1; AJvYcCXMGUOqyTNm6BU1BaYLAA5KysYSmCkCRYdj8cWbaXudVKnz8I3kAhOBJEIuuM1t8gz6glDB7U/fX114Jg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzTKHCyErb97FaKBfbVb3IlltbATi/VCKoozOA0R6CLm7uKnEN
	rP8rwfwY40AC5UxpWtYKLI3ExP5UrRc/tWIWP8wZFf6iL1bV/7lGt0J1
X-Gm-Gg: ASbGnctQW+7ajPBiGDmSV2GVlmCX8SV0UCdo8CNpJ7oYFSIOM62/dBeS5owOTf1CbuZ
	xZw4XcD5WX8edl5S5gMObCQ23gJ5WJ6TZpf3Ft9p5c7TpaAJTYHr79sL/pjVTUa4e7yRmBZfb5J
	4HLKll017HyXAn9MVU+OsObvpcFhtnvkQkHE8DI3DRs46wA9CePZvN7IXKBy85SabfjqdlKTDTM
	5hyYV75zeeFjil9iNrz2JJljk/t++flDv8X44W4Mjq/q3faGw6d19Dg9MaLGH5I5xOBjYDxsQp0
	ZuCarU3gFyNikb8IrKPWn8tY0G5P2KEqXVsqHLYlD9AP1NSQvYysx4YIgyLT/dTcBPlEvW0JPr9
	/P/vRb0HxS+31naKA25QY
X-Google-Smtp-Source: AGHT+IGyRgnokjH/fRnTW0dxtgVYaUoiWxnU49me+vMz+eafgwnRz6toTk9ITVF7/sWl1VO7Y+XW9A==
X-Received: by 2002:a05:600c:810c:b0:442:f97f:8174 with SMTP id 5b1f17b1804b1-458765475bcmr135316915e9.18.1753789325702;
        Tue, 29 Jul 2025 04:42:05 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4588dda22afsm15545125e9.2.2025.07.29.04.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:42:05 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] ocfs2: Remove space before newline
Date: Tue, 29 Jul 2025 12:41:31 +0100
Message-ID: <20250729114131.1925586-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is an extraneous space before a newline in a mlog error message.
Remove it

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/ocfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a4f5a868bec1..4b3ea721395c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2108,7 +2108,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		if (strlen(osb->osb_cluster_stack) != OCFS2_STACK_LABEL_LEN) {
 			mlog(ML_ERROR,
 			     "couldn't mount because of an invalid "
-			     "cluster stack label (%s) \n",
+			     "cluster stack label (%s)\n",
 			     osb->osb_cluster_stack);
 			status = -EINVAL;
 			goto out_orphan_wipes;
-- 
2.50.0


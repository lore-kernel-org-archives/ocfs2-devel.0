Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322B017C22E
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 Nov 2024 08:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731485370; cv=none; b=owo/0Q8ZdlMm31M9/9U59KHdOac+UkT2vEArgGm6/9AsW8WLYv0fsZNnS3qH8zmDY2t0h3yGmU8VsvSnDZ1XwDe761Ioahf+J/EXjq32WRTRxubng/JsGsxfWmAmNee88wXDJaI+FKE94r7wr11ACzW68q438gwR8nx7whRkOsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731485370; c=relaxed/simple;
	bh=7WpWtv2jS3x3gXkO8R5xyAkvr3fN5myR6YUfGDPxZWg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=rTYJGw0E4mdYoIXcZEUo3QtDoH8aYB65ioNx6aF9scs8n1WQWCX0y0dxdf/ZSZJogAk26G1CjdpgwRwU2Sqoz+FmWJhw5VyrAVi5azxDCi8EnKR/EHJCsdYIKCmnJrWcUwa3P3C8UM/979EjsPhLedh1lFHaMsvvjgt2ig/emcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F9lxCJ4/; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F9lxCJ4/"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20cb7139d9dso62511305ad.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 13 Nov 2024 00:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731485367; x=1732090167; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xIsnWe13ChOHunrq+aFxgomX4EggmYavswon98hsNh0=;
        b=F9lxCJ4//v+3xRGKdeCEExP0yxFVrkdXDcbjrDkIrfPgG8MVc8q9Tpwp0rFaN2aBiV
         aNPlH3BIsHrPiSkO8kuM5zwYlCceyyeSBvYK5wJV2M1JNXVEQYj5NoJiu6jSCXQh0KGO
         KygPEXNbLmWXX/MCILXLSShImjRH57DkxQNi4WFJxaBCN3Se29nE8ZeFT9O0RD1jrOl8
         z1xEWyZrB5YjF97A6dYFrXyzRC3uGeuAsZPnaFeMIlp8sx+TUftDS4bouyaj9rXs0XSf
         uPL146RzuzcTzY4hkuSR4XNoghz9EX7ykJd0G4QptC4VLRVqwgax66f8zWYLSMlapVOa
         dyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731485367; x=1732090167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIsnWe13ChOHunrq+aFxgomX4EggmYavswon98hsNh0=;
        b=E9RUTBfzx0Cbx/SdMgdF2r/R9PZJP/g85M0qjHSwE5/5FWlcSYGv5WXWLlMDabI1cZ
         RKNM8DBirFtlwpi1khTs8coZ4sD+5JaHrBPeUMHyd6DtPMI1bCIgQNtJ2C4DL/7murgs
         y+q091YA7A1x9U68wilMogxjMdhfQQ0gvAODCFEOXf+Vqp5FuBUIQQCQt758hD+gtyUX
         OjC4VNN9ojV/QY1BzXrb1lgUZAeKb3kMxGNRVlG62w9M7+ISGnLhhXW36eRwrNwgpowr
         vd5viLusCeia2JKSfvmaKu4W9QNke1HK4eSqHEtoWn0DMbFeNnO3IyqWVdDq0ktuxijm
         7tLg==
X-Forwarded-Encrypted: i=1; AJvYcCVC9E8QZNWPvolhGtwROsq1M0+mPrVF1IZjTZKEEw1grrviUo2mX2JjoGU73n4lIu5jfF+Z5BkDVDOXkQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YytD0+sqDhGtmirfW1I4u8L5HBHMTUeyOrAh46+lg/iB6YpMM1S
	tEmgUYZxCXzFXQkpO1oJiZFRTji8RCgwNHvPgwvknXvENjLuAVfq
X-Google-Smtp-Source: AGHT+IH/hCD8QpNb1D96+qOwTRIPNXkvBqvqnmyXSFc7Q3LYNiYEnQsdpsPS6vUxcfQzJgpRf7YMHQ==
X-Received: by 2002:a17:902:d4d1:b0:20c:6bff:fcc2 with SMTP id d9443c01a7336-21183e6e414mr232444315ad.56.1731485367391;
        Wed, 13 Nov 2024 00:09:27 -0800 (PST)
Received: from debian.resnet.ucla.edu (s-169-232-97-87.resnet.ucla.edu. [169.232.97.87])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-21177e58e4fsm103225255ad.203.2024.11.13.00.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 00:09:26 -0800 (PST)
From: Daniel Yang <danielyangkang@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"GitAuthor: Daniel Yang" <danielyangkang@gmail.com>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ocfs2: replace deprecated simple_strtol with kstrtol
Date: Wed, 13 Nov 2024 00:09:12 -0800
Message-Id: <20241113080913.182499-1-danielyangkang@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function simple_strtol ignores overflows and has an awkward
interface for error checking. Replace with the recommended kstrtol
function leads to clearer error checking and safer conversions.

Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 4b9f45d70..dff18efbc 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
  */
 
+#include "linux/kstrtox.h"
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/jiffies.h>
@@ -1777,8 +1778,9 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	if (o2nm_this_node() == O2NM_MAX_NODES)
 		goto out;
 
-	fd = simple_strtol(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	int p_to_long_ret = kstrtol(p, 0, &fd);
+
+	if (p_to_long_ret < 0)
 		goto out;
 
 	if (fd < 0 || fd >= INT_MAX)
-- 
2.39.5


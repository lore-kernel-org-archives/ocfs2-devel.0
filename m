Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435DC17BED0
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 08:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731657623; cv=none; b=UZVSI7nVXS2zRHhM+D4HErnHMccTJPG4Ohla0vKHTAWQ7CQvRiPTa+oKx9LES/PGgVLBvQBH9fCFxoPkAwDVnC57su/O80km91x9TONLS0qJ/bgswSErWJk/Ds6fVW30QERVJO9M6c3w8qmE+vt8KdoQLIyFJQeR3A7LOBDbJF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731657623; c=relaxed/simple;
	bh=7I9Dpf4vIeqGxg2ANx/uqzFrzV4Jcou62ECo2RBhnow=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=LG+M8a/CHjgYABFcY2cwt3Mi4ypTuD4K/5FGoWIsSJJIfHFNi8mNZ7YbC7WUDsmEllgNrvJz7U0Nj/yso8eTdHMeOliqYlnLXROZf9yOy2g7Zs0F/wcjS6bbiADVgNNhyBKuwQwG2Zg7MIC85+eZQtVnI9ZEpj9DdH7IqHCx63k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qn/xWW/9; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qn/xWW/9"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2118dfe6042so12464035ad.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 00:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731657621; x=1732262421; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nfsfy9LrscUrRpjVUBT/GZ583qVwlWlgmPooq0UheVA=;
        b=Qn/xWW/9v1V0BYVArx7odNIDuXDGVcQSXI3MR9zyqfTpxwbUflKCev8UkI5ccOr1Dm
         aq54bxY137Su/tfTwtp43/qcyo7FAfzw7kaVAelUbECGEFJEI6PVX8Wfs1ET0lkctTeB
         47mtNhA+Q+BIckjHEM3o+fTbEV5tsBobl9WhFNJzE2YZZnyaf4dMyYSfShS/SBBDPyJz
         FFt5R6I+trWzzuX193ngNKMFJ2wPug2yDob2prA3iX1Lxe/eQeXGdF3TV5WuBJGZmhTj
         VN9xmMCPU2Y2a+HF3eCyV1oT+aDHzK1UJUMp9bQovILw/jDtryh6ywDoe2NbbpN5SX14
         T4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731657621; x=1732262421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nfsfy9LrscUrRpjVUBT/GZ583qVwlWlgmPooq0UheVA=;
        b=AcaqOXfrtyIhsH7RZ1YKPYXrE5SeYl6N42oW/PIongQCUuD+6BPhhQmA9zdd0ZG8vB
         dFiIg2zAGHfzUv5aKTr41RlrydvyBtNmU2hdStphJLZC47jphqPVj6lluqGnsQNCD/gM
         MSSTr99ByH8DiPZjb5j+v23WFyrhhFuoMNLqU6St3F7ICxnVizf+2X+fyqZtM++NjXV8
         +ibzU6fM3I1SGvO5ieNSHvfzYXYPOMSQCEIMr/UwUpzeTABo8QA3MtViFSr24LyPn2fM
         08DGnW40jSMB8ZcC/qgyeSmRkuJMFQJ5RbYcKPcAA6221xCVkjkxTNnhZyy/W79ZCxy4
         ajGA==
X-Forwarded-Encrypted: i=1; AJvYcCUbDXGTKojS+Y+wVcyY8haT6WoBzYnyXnhPNwYE+CoXfXxGfxZvdOg6xwiZB4SPnSDrg0CIOkO0Z5KJfA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzpkUXCbAc8fPBiN4viewF5pySSHhAj22rjxrwWdpFD/Y2M532v
	QSjSxuT9XP+UBWUBbWkK3kHgYb7t5ko9UB1TSuXTm/m9tEPATSAI
X-Google-Smtp-Source: AGHT+IEvpCwPomO/0Q9FmOExYgVoGHcjaghFKE5dSi5ttGKcHh35wNzWC1V55UMaCqwf+9Lf3jpMQQ==
X-Received: by 2002:a17:902:ecc5:b0:20c:d5d9:95dc with SMTP id d9443c01a7336-211d0ebed9amr27847205ad.40.1731657621373;
        Fri, 15 Nov 2024 00:00:21 -0800 (PST)
Received: from debian.resnet.ucla.edu (s-169-232-97-87.resnet.ucla.edu. [169.232.97.87])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-211d0f53ac3sm7161585ad.240.2024.11.15.00.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 00:00:21 -0800 (PST)
From: Daniel Yang <danielyangkang@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"GitAuthor: Daniel Yang" <danielyangkang@gmail.com>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] ocfs2: replace deprecated simple_strtol with kstrtol
Date: Fri, 15 Nov 2024 00:00:17 -0800
Message-Id: <20241115080018.5372-1-danielyangkang@gmail.com>
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
v1->v2: reuse ret and remove blank line

 fs/ocfs2/cluster/heartbeat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 4b9f45d70..18333aa19 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2004, 2005 Oracle.  All rights reserved.
  */
 
+#include "linux/kstrtox.h"
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/jiffies.h>
@@ -1777,8 +1778,8 @@ static ssize_t o2hb_region_dev_store(struct config_item *item,
 	if (o2nm_this_node() == O2NM_MAX_NODES)
 		goto out;
 
-	fd = simple_strtol(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	ret = kstrtol(p, 0, &fd);
+	if (ret < 0)
 		goto out;
 
 	if (fd < 0 || fd >= INT_MAX)
-- 
2.39.5


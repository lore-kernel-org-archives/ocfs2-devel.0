Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55A42877CD
	for <ocfs2-devel@lists.linux.dev>; Fri, 12 Dec 2025 05:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765519118; cv=none; b=bjjIb0J6C4SPtn6RO2iTzbOxCXZqo/FcZlPHFRPKGxI8huABdeHEURe+5LBbmizUDL5t5zvKigbfhRrVKkAn3kft75JfBsd5GrsVPuAqz2/daIUi1DcJVAwhQLjomD3Qqmf+KS+XlW4XRer04IpxxLu7KR/JLcBX8De8iQ4o/ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765519118; c=relaxed/simple;
	bh=QDQh1hFjJw4Rwp21p2CYU5tmiVME/0qXLmcAtZx6An0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DIUXXellw4OU5w7JYJ+Ov6YOjh1BQqmH1ZO48BLRyNnQNwqnegxaNJ/YZ7JsIaqZ91wVHaZxssaG/n3nXhULMvJ/0I8wDqaWVLBWV+OjegsRsUbGP13ZidS6HHvWx+y5Fvj8Tox0bAMqTBFBrWx3xsKwmhYEp+ThuEW9882KFhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTSEOK4Z; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTSEOK4Z"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-297e264528aso9359955ad.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 21:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765519116; x=1766123916; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f5tFOINPA5hU9NBLjqWlAIwU53x93j72lMljtonQguM=;
        b=CTSEOK4Zey5SGQdIjIaZO+E96SouEDZOy90bGOsEvg0H5l6MymdbaKG8v6Lj4T4e1f
         fiXZviOR9gBGpL4qAuiXcxJl7GUx+AZ0ghPTbqzHuzvHvDi78GdrJeyf9FqCjH6/DBQE
         vgqlSIqCL8lYkPIjTbQOsJ8Slx7URiDr0jTBRK3ADwxCaqfNEsHTEeam/21nO3r5pGt4
         20XBa9rPJkt5C33peoM+ZtoRsJ8NKMM9TLakY0HN/dOYtbB1lzotbNmVZh0eiAi035sc
         sdMe7J5XpA/z/gWuIRj6KZpeo3N+uCA42yAjgAvmuF1fu0PkVdN76KKiAYSShRQEbERy
         BbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765519116; x=1766123916;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5tFOINPA5hU9NBLjqWlAIwU53x93j72lMljtonQguM=;
        b=kWGKFXJFWlIRlfenXlxTDmmjdihtaDjfi9an4wD1zoTsg4W0Dq7bf/0miDqUGomuAh
         4hKkGtbVe376vm1uN40p5H9T8En84MmIooBYq6dLSgY4l1R23CVzKQvKAUXdpie67TbJ
         5Yi4XwI8TE+CMIslasGNS6iIYe45gTtfIGqwcr11bh6Y6UmDMoXE1/bJJNONpg3N6V4s
         nXs+w3Qd0ZoSuBSwAbrspbKCP8qeqIhyMQIg51EI2FgK6WMnYkdnYxB2aURrA05eQIBi
         l/haujRkesgmz3VY/z18qoczsK+Ccq+5UWxezAoZgWp0Dke4QdcXXZZ5OZnU4zv0MIX0
         WgdA==
X-Gm-Message-State: AOJu0Yx1Bhku07IUuKedMArlmeSDz9x/rnLIgWynqMhUFn0atFQgAZ9/
	8Ll2CGLBhGjgsdKPI4MUA1TQNqY29pwRlYNne8D9NTIAOjE8o89mtVoG
X-Gm-Gg: AY/fxX5TxJ+z6BkNjmztoxIdiTq7NqyEXNHE/xXdw+483DF9PeZEfDeQo+g/IETD4yu
	yoNrnCgll+HRFKANCosIjCrDbt9aJqjbvbmtRTz1LgMeN6iK2cAluXZ0qZz6tTJI/y1NUHqNcA3
	NJ7QZaqM/LF2ayXM5dXPxnArrlHf9V8pD8KWHkG/UeGshs8Fp+ZQ/UYHD7U8vvr1pz0fE8HJ77X
	vOpuEuulxpnf8rudSHp66qgGiprtFlsn/3dbHGYqGYkOePGM56RW8tKd0B3BhO8iv/6j4CpAibt
	Sme7j0lvVfml22+jIsgD/bQTacFzx6OhoATuJ7JVLJqYz95K+PPQTZSv7nlrIRMOVtV1m0jxUeh
	BlxK+N5AMitmK1VNx15vzTfT8+6fdeLBcHipkAh0FcGq0cB5SPbFNEp92UCMlAy7h+L2Jx/Iix4
	VvcESWVZT2oAEtxyykpTK5NOMMBfLq59lb6nkz7CNujxVt3uzxrIDvjRe9TRB8DPg1HLkpSTjLH
	rww8g==
X-Google-Smtp-Source: AGHT+IGNup7YmTDugDMC+CiM3JJ8sIDmyXTKagZK2geQUoICzXXLoyCBmxi7MUva3cKPoITMIh0bmA==
X-Received: by 2002:a17:902:c403:b0:29e:38de:6140 with SMTP id d9443c01a7336-29f23e1d4d0mr10560205ad.13.1765519116173;
        Thu, 11 Dec 2025 21:58:36 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:569d:4eca:4ab8:f2d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea04038dsm41782445ad.76.2025.12.11.21.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 21:58:34 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: validate i_refcount_loc when refcount flag is set
Date: Fri, 12 Dec 2025 11:28:26 +0530
Message-ID: <20251212055826.20929-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add validation in ocfs2_validate_inode_block() to check that if an
inode has OCFS2_HAS_REFCOUNT_FL set, it must also have a valid
i_refcount_loc. A corrupted filesystem image can have this inconsistent
state, which later triggers a BUG_ON in ocfs2_remove_refcount_tree()
when the inode is being wiped during unlink.

Catch this corruption early during inode validation to fail gracefully
instead of crashing the kernel.

Reported-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6d832e79d3efe1c46743
Tested-by: syzbot+6d832e79d3efe1c46743@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251208084407.3021466-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20251212045646.9988-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v3: Use le16_to_cpu() for consistency with other checks (Joseph Qi)
v2: Shortened error message to fix line length (Heming Zhao)
---
 fs/ocfs2/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 78f81950c9ee..1019ca80760c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1484,6 +1484,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
+	    !di->i_refcount_loc) {
+		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
+				(unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.43.0


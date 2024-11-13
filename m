Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4296189F52
	for <ocfs2-devel@lists.linux.dev>; Wed, 13 Nov 2024 08:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731487275; cv=none; b=HErQ5KXMHpuehg4sgH1jzH4qxssIuYmhvivgIRk8ctvrercXoso9TBIdrAOa1EmopPGWc+eBKDucpWUHnYOo7zHeRi2EqVV+TVASufhLANWiZWYUVDPu2s2+bHo2uMZeoCgbdjoX1W99CuNkwddVPpZkubRUX0qIgdkOe5j2q4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731487275; c=relaxed/simple;
	bh=9ac3S7GwjMYsuWPSg9A6e77/XxzmBRaa86u9PtncFZM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=nktE4Os/3qCkCQjODZXWUATKWSOFym3B3ovYxHthQjsrRkEAOR61NjD0K7bgEV/sb6+K7CZKK6QMnXcqYLQn58t6PpD3HaiX/Pq6jLUMIn+Zeyn9Wu1lh0dyS+gZrXri6iP61VptKImw2vfgLYQITupFnqiNyRF4o4TKo9Jmv7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jNALe/jZ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNALe/jZ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20c9978a221so74343585ad.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 13 Nov 2024 00:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731487273; x=1732092073; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hARpX5ZPx74ElNUTsqJ78OBOuYxJi1lpnBAIag7Jp+g=;
        b=jNALe/jZIhnlBufnqQDXZybnptbcSihUPZe7S7aZbtR12M7KuluuVl7/aijT0/TXOC
         tfT+FdlmsZVeqCA3cSZK49oan+bYZouDK+FenhzG+L6H5rIRQ/hRJADBOaSExN17Dshh
         DuWRHV2zidtCN8dXM7SrjasaybY/BHDEW55wkAS4FMfA0cp5HpfAKHUWFUQOld2rGIrb
         wmbhvc7tbEaf1jdKMFZf9HC2fkV1/EyD1tRId7vG2Z4oI+uLAZOevVShiXDjJF7aJAKt
         y8lPdSoF2MgBrPqUAlMaN3R7/QP2hULZgmZ+6voh/7M8hi8e/dGWiAQ0dH9J7Hjmct33
         K7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731487273; x=1732092073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hARpX5ZPx74ElNUTsqJ78OBOuYxJi1lpnBAIag7Jp+g=;
        b=q8hDhNmTLzcaKuqOd4OqoGrK24dmZoNUF5IabkZhx895kWgEg0qZrlsiKYkg5myY1C
         to5SJ1E+qKcl5SKIRaJatAfvp+dYvuiNErRJbJuIuG26L7IURyGX4OjmMblzMl4ivRXn
         JgJbDrlUQ6oNvJlSXf0E0vknrT5P1CkVcY/1nNOkxmxdEhwgRaH3NHkVwQIi9OoUHds+
         W3f4+q1CipeLscOCm8Rwn46OB0TxdmIbJCX7nrwIDv75t4HvCpkfm5w/ZXFggGIjC86d
         OaTmP2ZwNMijGS1R7uMlV++cm141qvMLoMXIRG4nBtRrgxllM+Cx1qhw0O7LGvdzvGrh
         P2qw==
X-Forwarded-Encrypted: i=1; AJvYcCWHdoFceEzBoMG9WQQPbV+V5lm6WzK0WU/wrlvl2THvxwU3XhfOI0NYOhktBN2SN8sNilLLD9JoCyR1lQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxFZPxu3eM5nvvwbtUke92qGcBkgDnZLDfwibms749S3dlh45pe
	M4nuySyL0f//WX9jS+8SznfJa5eW+gl9ujPp1JD6X2TbpI3xYeYG
X-Google-Smtp-Source: AGHT+IGIEuI1rvXnQCvJTS4p7g2yPIXhYnzr0HRFq8xLhfWXpkWFmXjk7RUi+cYqXEN3kz7hHMHcYw==
X-Received: by 2002:a17:902:f54d:b0:20c:ecc9:c50b with SMTP id d9443c01a7336-21183d67ce4mr251260245ad.42.1731487272793;
        Wed, 13 Nov 2024 00:41:12 -0800 (PST)
Received: from debian.resnet.ucla.edu (s-169-232-97-87.resnet.ucla.edu. [169.232.97.87])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-21177ddd616sm105613825ad.63.2024.11.13.00.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 00:41:12 -0800 (PST)
From: Daniel Yang <danielyangkang@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"GitAuthor: Daniel Yang" <danielyangkang@gmail.com>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ocfs2: heartbeat: replace simple_strtoul with kstrtoul
Date: Wed, 13 Nov 2024 00:41:07 -0800
Message-Id: <20241113084108.186506-1-danielyangkang@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function simple_strtoul is deprecated due to ignoring overflows and
also requires clunkier error checking. Replacing with kstrtoul() leads
to safer code and cleaner error checking.

Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index dff18efbc..4fc1b23f1 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1537,8 +1537,9 @@ static int o2hb_read_block_input(struct o2hb_region *reg,
 	unsigned long bytes;
 	char *p = (char *)page;
 
-	bytes = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	int ret = kstrtoul(p, 0, &bytes);
+
+	if (ret)
 		return -EINVAL;
 
 	/* Heartbeat and fs min / max block sizes are the same. */
@@ -1627,8 +1628,9 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	int ret = kstrtoul(p, 0, &tmp);
+
+	if (ret)
 		return -EINVAL;
 
 	if (tmp > O2NM_MAX_NODES || tmp == 0)
@@ -2142,8 +2144,9 @@ static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *ite
 	unsigned long tmp;
 	char *p = (char *)page;
 
-	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
+	int ret = kstrtoul(p, 10, &tmp);
+
+	if (ret)
                 return -EINVAL;
 
 	/* this will validate ranges for us. */
-- 
2.39.5


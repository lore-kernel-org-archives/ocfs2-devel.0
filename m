Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A655818872A
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 Nov 2024 07:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731657112; cv=none; b=N/DNghDLcdMeY4+KBMvgAG+KFBMgyPQtGHhiaH5vFXkkqn9HTEsQIEpQxFXIgKJnm+me6NbQmGFozffl8yrwO4ptslvQtZ3cCObtd+xBklsXXrt3VKNNvjRDsUTuZJnhmHw9qcCB6yKRydCEybc/aWr2y/8neFU3HI7dJ5Juark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731657112; c=relaxed/simple;
	bh=qqENQbAaKXZZva5Avw5Y8LEF9gtDGy8zzcMAUd41gSk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=KZhotz3laik7athzZ0SZoOgTZ7dXAZQ4f001pVMqvPyWcIrdUL0CzugYeSMpzRi+RefrJh+CTHEIpBMPmOk02VP5/G2hc+H1lgP0i4vtrJQtnVGVuHbEtv5JiGlBHAeUsOgL6QqLuOn8aItZQSi6fCggVe/2XHc5YEEsM5Ff3Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hz7SBhAy; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hz7SBhAy"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2110a622d76so13422045ad.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 14 Nov 2024 23:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731657110; x=1732261910; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KsAouvdVMNUqn4IU4fD/T6fDVN+WMWnKWEIbCDTa3i0=;
        b=Hz7SBhAy6iSmjCKpQHydrNJHjJ4fT6qjkPREh2cCKcn0B8OcykZ2ruy138EAM9UtU4
         1dVkOViGq6P+dkl/ED/z4cjIhoBTO9gbXZHA5LZmfV76Mf7VTKRmM6SqioXVS7rPZR8+
         hsasMBVloNEjpI8H3cLuwbf9Iz+/MJ5nYMojFiqVnz2F4+gAtjAYFHVcmeEg7UHsSeZZ
         +sQNrnlXfgFUDn2ZBkj4Dw98gp8KhUwvg+Rndsi5oTtAx2VSBiAU4X8TYta7Rz0nZFai
         +UpI9FxXkQCSrzzFCpMBuzM9ocxuqpTK64c9VxPePpvTFBsZRGFlMELEgMgo6iOM00hs
         x51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731657110; x=1732261910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KsAouvdVMNUqn4IU4fD/T6fDVN+WMWnKWEIbCDTa3i0=;
        b=B9TGlJMvktbe9569vyDg5Xa6sasLTVCjaH5b2PbT3ScEqSyWey0ARL3OgvuQws2RBu
         GAlnur75u+wEXz4/jEN0QjkmQlb6W5XeUcKl0jC0w+64Jr36jPt3MWvacgYA01FtKjCA
         vPsQ03gyRgs3al8KZ93gn6je69EH9p2Nf2eX9PhQKpGtFTGhb4Jdhpmd0hPQwXYDPrW4
         uwKx+KdSerKtWax9TiJAbec9t7upGfE6uzD2vU6hzJcda4QQF/oHIpL7yzoe7CuVotUs
         B3EqWPOzUCYlffGEQOCgJxDXL/ZC3XcNgiQXNEFLywFL2yHrgqs/IOlsGTreN8BEw405
         FH3g==
X-Forwarded-Encrypted: i=1; AJvYcCUlIuG0xu9+9ZuG1cL1U+APMjY1a1/aTAKenxMzhNnbSDFwmH1QAcvL+L62NWBCuzOH5NMxEDCS7X3i8A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxbjaFrZAtYjyVtbBjV8siy9GUkxOOUwhQApyyWiEyAtkjTVrOq
	Cni9PTslBXhJFCPUReikaYHv7zOxbKLnqtF45qHQjQ9+DGqwPcCS
X-Google-Smtp-Source: AGHT+IFzkzeyJcCFRb5Z3zNnEDk6v8V4BkBj6xtGAUVR35xl08Ysxdp+lgXyAzGw0rXAZUxj1QsD3Q==
X-Received: by 2002:a17:903:1d0:b0:20e:5792:32ed with SMTP id d9443c01a7336-211d0ebc0c5mr21895735ad.41.1731657109792;
        Thu, 14 Nov 2024 23:51:49 -0800 (PST)
Received: from debian.resnet.ucla.edu (s-169-232-97-87.resnet.ucla.edu. [169.232.97.87])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-211d0dc3114sm7191875ad.15.2024.11.14.23.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 23:51:49 -0800 (PST)
From: Daniel Yang <danielyangkang@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"GitAuthor: Daniel Yang" <danielyangkang@gmail.com>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] ocfs2: heartbeat: replace simple_strtoul with kstrtoul
Date: Thu, 14 Nov 2024 23:51:30 -0800
Message-Id: <20241115075131.4457-1-danielyangkang@gmail.com>
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
v1->v2: moved ret definition and removed blank lines

 fs/ocfs2/cluster/heartbeat.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index dff18efbc..84ee5e340 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1536,9 +1536,8 @@ static int o2hb_read_block_input(struct o2hb_region *reg,
 {
 	unsigned long bytes;
 	char *p = (char *)page;
-
-	bytes = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	int ret = kstrtoul(p, 0, &bytes);
+	if (ret)
 		return -EINVAL;
 
 	/* Heartbeat and fs min / max block sizes are the same. */
@@ -1623,12 +1622,13 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned long tmp;
 	char *p = (char *)page;
+	int ret;
 
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
+	ret = kstrtoul(p, 0, &tmp);
+	if (ret)
 		return -EINVAL;
 
 	if (tmp > O2NM_MAX_NODES || tmp == 0)
@@ -2141,9 +2141,8 @@ static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *ite
 {
 	unsigned long tmp;
 	char *p = (char *)page;
-
-	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
+	int ret = kstrtoul(p, 10, &tmp);
+	if (ret)
                 return -EINVAL;
 
 	/* this will validate ranges for us. */
-- 
2.39.5


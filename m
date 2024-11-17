Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78621D9A78
	for <ocfs2-devel@lists.linux.dev>; Sun, 17 Nov 2024 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731880345; cv=none; b=JmQmeQgEuE9Sh1QambXaIwTGNlDhAnNimKoWPl3e6EI28x0uJJA6IG5qrwFUVvUf3+dPpDUJT8hZxcmFq2FNE8LABcUd3fCJ5fW7ILXHS6Bx6pyfYjULRhc+gsjG3qOlv27xua7VDTzcbd5b9FDRxBU3dBuePmnmpGHdh/kmUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731880345; c=relaxed/simple;
	bh=NU7crY72ANGOmaw+FykFygE/dkkujprQhyOPT2KbGvQ=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=V8WQueqcPAmbg46e6X6SHqISapSsUXB7R9RSk1Yh1HMnHqaT3H1f7hcNzjLfJTlJbm6OZJ/H4d6+Yz4JVNjQ1tB4UIqJDYPSGSnWbbZ8+MwF1qhpwMq6zuBjgW4OIT0s/fUh2fhROPLf645rPM23A8h0LcVS3rCtwDYDDYim1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lBfhO110; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBfhO110"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7f8095a200eso2453030a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 17 Nov 2024 13:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731880343; x=1732485143; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TZFa1I2jutht+G4LRPkakmXfxYKKGJlHT58aBpyCo3A=;
        b=lBfhO110wjuf7w9dwRxnrxZPGGMDyNln7pG929XkDRk8d2SEvO2Qiny6ueXIiBsu4j
         8akHoTezi43sqXk9KhzQKpJ8Z6LADHD6W5AdIK+d3OkF6vdl+KftUwBuRo62aOvMg4iz
         GKpJkb0EK478lHo5sZye/rb4FjSDR8/0XnRPUwZbjQhuxUNvz2Gt+ywD+36XpsbCIHD3
         EQ/al81zthd+j1DAlpXJez2SdQZVx+ZL8dFClYaQsrdQF2gkQRVU1L2YXWhr/mTLJw/N
         DIM23ycaNG2Jt4fiQgHJC5y9ZOrlhg1QeS0jlCbYCvCur1RBEd91n1VoF6NQxmKOygpL
         X2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731880343; x=1732485143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZFa1I2jutht+G4LRPkakmXfxYKKGJlHT58aBpyCo3A=;
        b=mu605c/8UgCHHJtO9r07Mffx+3XsFnGv6kUfmQ4ZprFFKLYUSn6u9v5ZXVm0fW4CzR
         kIOekVApj2fR4HpNkm+42V6YCP75OWeAfG44c5yT7BJyTN7wFQD7BRaNbB+99D+t9Lp1
         nndqAsIZSrnosIzn5tRareIktelnF38OERNKqCUVVcQtBu9fi/CcY17Lp/ECRjfl1EcC
         iv5xyhfuwRKIUzbzotlKYw6X2AjTi8De0oGXz6pjM2ykm7ngZJ/clRrld0cQ9F44jJ46
         W8OsnNuBIS/RrrgvfwwSi8IEj7RW24bAzSUavjW72FZwr1IITEzUv7IcemyFzyfLatwx
         MdiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwUk5PE3WjlABFYQn/x6db+OvxuvPBmMDvE/6nexg8qy04nr/wXdf7tjGJDpLQwbUBE4RsustdFZFSpw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwEkOJrmFZhop1Ffhm4q+NtJNE9c1I0msCDglpuvrET7UR13rPR
	zHMA2TC9UAIPiTcijNbCbCVle+rJ62uSJ1IWYVSieDhc6sxu1Zsm4Nb6o1+C
X-Google-Smtp-Source: AGHT+IGH3sWRJ7aCqF1wjKKWMkrxL2s288oAl945dj2z0e7cyzKT3LxbZQOtJvHKEce+XipNgoXQCw==
X-Received: by 2002:a17:902:d509:b0:212:4b3:1080 with SMTP id d9443c01a7336-21204b3158bmr55172805ad.13.1731880343068;
        Sun, 17 Nov 2024 13:52:23 -0800 (PST)
Received: from debian.host.ucla.edu (wifi-natpool-131-179-61-163.host.ucla.edu. [131.179.61.163])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-211d0f56f02sm44450015ad.272.2024.11.17.13.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2024 13:52:22 -0800 (PST)
From: Daniel Yang <danielyangkang@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	"GitAuthor: Daniel Yang" <danielyangkang@gmail.com>,
	ocfs2-devel@lists.linux.dev (open list:ORACLE CLUSTER FILESYSTEM 2 (OCFS2)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] ocfs2: heartbeat: replace simple_strtoul with kstrtoul
Date: Sun, 17 Nov 2024 13:52:18 -0800
Message-Id: <20241117215219.4012-1-danielyangkang@gmail.com>
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
v2->v3: code style change and return ret
v1->v2: moved ret definition and removed blank lines

 fs/ocfs2/cluster/heartbeat.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index dff18efbc..76f1e7bfd 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1536,10 +1536,11 @@ static int o2hb_read_block_input(struct o2hb_region *reg,
 {
 	unsigned long bytes;
 	char *p = (char *)page;
+	int ret;
 
-	bytes = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	ret = kstrtoul(p, 0, &bytes);
+	if (ret)
+		return ret;
 
 	/* Heartbeat and fs min / max block sizes are the same. */
 	if (bytes > 4096 || bytes < 512)
@@ -1623,13 +1624,14 @@ static ssize_t o2hb_region_blocks_store(struct config_item *item,
 	struct o2hb_region *reg = to_o2hb_region(item);
 	unsigned long tmp;
 	char *p = (char *)page;
+	int ret;
 
 	if (reg->hr_bdev_file)
 		return -EINVAL;
 
-	tmp = simple_strtoul(p, &p, 0);
-	if (!p || (*p && (*p != '\n')))
-		return -EINVAL;
+	ret = kstrtoul(p, 0, &tmp);
+	if (ret)
+		return ret;
 
 	if (tmp > O2NM_MAX_NODES || tmp == 0)
 		return -ERANGE;
@@ -2141,10 +2143,11 @@ static ssize_t o2hb_heartbeat_group_dead_threshold_store(struct config_item *ite
 {
 	unsigned long tmp;
 	char *p = (char *)page;
+	int ret;
 
-	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
-                return -EINVAL;
+	ret = kstrtoul(p, 10, &tmp);
+	if (ret)
+		return ret;
 
 	/* this will validate ranges for us. */
 	o2hb_dead_threshold_set((unsigned int) tmp);
-- 
2.39.5


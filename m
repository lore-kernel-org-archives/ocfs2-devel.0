Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD3674068
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Sep 2024 18:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726599140; cv=none; b=nPrY8pBl6921vg/zNNFFT79Gc+YUHiyEw8Yw08h3JJjkQlAKPBOy9JMdxUmtVsQ8NuKexbMw2FwgpJD0cNTWyZ0pS4U+5/Z57LkkUA6yuxIAI2bTGQVtGF+gyZEHm+y8+J2sfjVaYTTyb7xU5p4bjgyhxbJoiR3Vinj+btYo8m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726599140; c=relaxed/simple;
	bh=9rZ0NAjyMN/Cy6XIxzVeo9DgCI/Rlqh8OOlBqAhJOdY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R9n4XOqPnMLVzNmyF18yX16IBjG9YSkFodbXlWUtmmeQ7wfcSZR/29ez7gcGiQq1jaMBB2AfxDGMmPA1qi+rluTjmasKVSwM8AAK10PEDjt5cruDRdeEuKDddex7k0BDzA7Mc9BNPMCJ6iaQ3BIdWgJf+T+zuIBFdrqwDyHEiK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N5Gi7058; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N5Gi7058"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71979bf5e7aso603529b3a.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Sep 2024 11:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726599137; x=1727203937; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+vyLopvVFarVc7b6zqFWSVn6Mj7mgp46/75nlYETkLY=;
        b=N5Gi7058Za0amiNA949y+NRHR5SflhFA6Z3CiB3D9U0ldVQ1ELpMsG0U8m9oniiDjG
         jq3H59MboJQuJbGnZ6tNVKacI74s9D0hPMTasBWW/aDYy67s4QsjBqABCkBhuyQBpIvY
         fKmh4Tj45GVrijMTAZuV6li0WcxesAStVPktCt06BxTkCjhANARZUwwaiqn+Jk85MwFs
         y8WWmz9AnV890kGBqfF9ODIGUfK6WhoIN5yZXYIZDApHf9aommv4HcAnOxBboLnhohaH
         LN19B06FSQt/acy3EGmqCwes5ByjxZMsLYjwigDk9dPgddNo0ArVYxjRU8yiJejGkiwO
         vyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726599137; x=1727203937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+vyLopvVFarVc7b6zqFWSVn6Mj7mgp46/75nlYETkLY=;
        b=YwA1u38EXUyGhDBZngLrugkVYtR0PYxILqSImhObhINQfCjxoReWMY0kB+PDRkxZPm
         Dk7rlf8lHOD8pzfNWHAK7KjtkaZAFAnGg5BVRopHa9Z1LEnGyaDs7UDkDdESlYR5c96T
         ZqDvpTab8jTIAqdT8GRZBQOSEZOjX2IExSmjirRoV2sgYAi46JAdojvwfEfExToan/Ro
         jjpGq3YJhIx9tKj8g2tOdUV4SDVxviv55JHPNwytkm+mofEbEx2e7JAT+zqZMKjndPQK
         EuAa+AGqEfUsE8qqoNkAihhMN6D2f7xjiZHu38/1BdZeFCFLVPIqcI+/MunMlYdzZx0B
         vuFA==
X-Gm-Message-State: AOJu0YxRYNDFNNmqqm+nGM2xa5nsgbePOBmVNAkDYZps8cUDY1oW1QrQ
	T1C4ePX9+qS2FfCtsKvIIO8ZIlYASGwL5lGUqpC48b8Ia+SPM0RqSyq3nSDk
X-Google-Smtp-Source: AGHT+IFmCN82+5xtavbARoR+V+tU/i2kaMpPTlaO2CRQHv+8DXSG6y6urfrYImfGrdKu9Rjz81UpEA==
X-Received: by 2002:a05:6a00:23d5:b0:719:1f54:73a5 with SMTP id d2e1a72fcca58-71926056052mr28503306b3a.2.1726599137339;
        Tue, 17 Sep 2024 11:52:17 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-71944adf70fsm5468108b3a.89.2024.09.17.11.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2024 11:52:16 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>
Subject: [PATCH] ocfs2: Fix typo in comment
Date: Tue, 17 Sep 2024 18:51:56 +0000
Message-ID: <20240917185156.10580-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix "Allcate" -> "Allocate"

Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ea9127ba3..395e23920 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4767,7 +4767,7 @@ int ocfs2_insert_extent(handle_t *handle,
 }
 
 /*
- * Allcate and add clusters into the extent b-tree.
+ * Allocate and add clusters into the extent b-tree.
  * The new clusters(clusters_to_add) will be inserted at logical_offset.
  * The extent b-tree's root is specified by et, and
  * it is not limited to the file storage. Any extent tree can use this
-- 
2.46.0


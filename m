Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899F819005F
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724154948; cv=none; b=EKZwJn9f6T96Un/MRag4mGIsBtDh4aX4yTjrmaIpSSSOKSGSB3EQnN5udqrnMwSNJeT5357PVhjrZVdoiUKwTKT3v+6iOO6gEYGjAZYp6bPKMZhmmohAFzwS8NbuZvdR/qirdpiP8JLB7zKyL3t39mXCj8EwK3BX/er2i2yBkMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724154948; c=relaxed/simple;
	bh=hkfItsWa9NSLlabsXabPkApTXzik3ePg1jC981q8YyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bcfh3VAf4YxI2b+CUzj1BoIHAAQYHoqCbo4ZF5Xk55QybUTPElLQDzE0FHvh+h21z39uB2RpsUc4khl/NCGPXQquUTZ6ZyL2ZpawWlHi6C3NddZtoSJRu86fFaMPApsFMBJZtcNWmTMmkLFz1jbeZwlddxsc4LqMA6FZd5ApUpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=XYJhZWTz; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="XYJhZWTz"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7d89bb07e7so567408066b.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 04:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724154945; x=1724759745; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gvs8qgusy6T7TLswBVrW7X396oYI0zVMv2rCG84jfiA=;
        b=XYJhZWTzbCsFAFdGPT/feFNakQ2GZ9OP+cW41vGJK4ehRXhWfLM4rXcgz2B2NJ3Iz5
         RHWq5fUn25cxXGwxSSgy5khOWZW8TetzCR4mkxiSCfFJGG0wk7dCdhWjLFM2XMJK+jux
         JUSoyry+CaiPX6aJMPsPVK0/4sis/4tl4azZtenbSjtX0PyqYBwLxT+Y16vqHutL/fNG
         GepcrL6hC6/sH/wIJh6oMsJTC6ur6U9QQifgoIcRbq4S/dTvbqdHG9h0tI0jAcDJ1ZY1
         uAIaL8B3th0BWhlII3NoGvMdIhypid6L5NGT1RG3UIrxvf3R1mkdWe6KdwxWuKSYVyXX
         lIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724154945; x=1724759745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gvs8qgusy6T7TLswBVrW7X396oYI0zVMv2rCG84jfiA=;
        b=McwR6dnjXAU5tK9UcwM9WYiBUFwMx5jgWHXDS6cKWOHyxdr95YYoHNqfpnkjQqXtjG
         6vy98l8ktb9eNjOMrJ0mRcWe34eIYx1bKyBa05Cl6k2qSansenRPQvMe17xwNz21bPHi
         MZNQNe/QJVbF019GWwskULZWct1mD6322rZs0NrXZB3uZjAmghbBvs2SpQ6vuo1agdcM
         2rJ1rPIH9ovpHTJhYauAQu9yZWwDuj8iNb5Xqbyv09w+p5mzAvrHNbgznVM7DU6N+t+u
         FYkjXEFzwJ/tXUd1wI9ZiohbqzlGX20XE9aGdhwFfmh9pOILfHpLSCYS67Gmv+VRuf8o
         8QJw==
X-Gm-Message-State: AOJu0YyS+dy37TR4mV/YJVRgl5rjPhcwORStfpcDZ5+mon92g1/hn3JJ
	pzD0+U7TijYjTsjcGJhFN7vh7t6o0di1+Xf+vp3Khb6KBmJwjKbrjptknHclMGk=
X-Google-Smtp-Source: AGHT+IFmfX3oCmgw3h0mXt1dqnyVJueOjZQjBdYc7SIl1OC+ATI8A8SOR6/3y5K4612gXvBTvVyuNw==
X-Received: by 2002:a17:906:d553:b0:a7a:a5ed:43d0 with SMTP id a640c23a62f3a-a8392a15b56mr932799666b.47.1724154944359;
        Tue, 20 Aug 2024 04:55:44 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838c6c1dsm751413766b.5.2024.08.20.04.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 04:55:44 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] ocfs2: Use max() to improve ocfs2_dlm_seq_show()
Date: Tue, 20 Aug 2024 04:16:07 +0200
Message-ID: <20240820021605.97887-3-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the max() macro to simplify the ocfs2_dlm_seq_show() function and
improve its readability.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/ocfs2/dlmglue.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index da78a04d6f0b..60df52e4c1f8 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3151,11 +3151,8 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
 #ifdef CONFIG_OCFS2_FS_STATS
 	if (!lockres->l_lock_wait && dlm_debug->d_filter_secs) {
 		now = ktime_to_us(ktime_get_real());
-		if (lockres->l_lock_prmode.ls_last >
-		    lockres->l_lock_exmode.ls_last)
-			last = lockres->l_lock_prmode.ls_last;
-		else
-			last = lockres->l_lock_exmode.ls_last;
+		last = max(lockres->l_lock_prmode.ls_last,
+			   lockres->l_lock_exmode.ls_last);
 		/*
 		 * Use d_filter_secs field to filter lock resources dump,
 		 * the default d_filter_secs(0) value filters nothing,
-- 
2.46.0


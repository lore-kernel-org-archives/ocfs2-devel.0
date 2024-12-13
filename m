Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C2D1862B8
	for <ocfs2-devel@lists.linux.dev>; Fri, 13 Dec 2024 05:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734068970; cv=none; b=ldS1bmPkskuZfWYO6tpB5blVq6SE1OPgaRWQWwe8fskP/dC7sucf2dPf8AHHnw0DEvqaGJEGeyL3OiFxsX1US4qFLEcD0hu9YNDNJzS7F8nKUQHbIe6YgPeZjxeu5jon8oVI/FH4ScMT3LSd4DjroKjXxRg0UTQrjBm1DSmM7W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734068970; c=relaxed/simple;
	bh=v+pMu9kg4VrTuiGatKb8KwXRW5PcoI6cotIuO17+lWI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jPxpaKWuYAbP+SGnwRcJNaUeFBzXjnJ7cKXh01h2tumJu+Ht3PiVaBRUtjd+/pFbTmULyQ7GWte9OFy8YZNbljc3gcQA72ge+WOzssoY94da7r4JmitktEpoBYH/VOGY9EzrXjALuRFxrvkmTYWeLqyuA65llzggR2GGIfz9K64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JjTHUQ9e; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JjTHUQ9e"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-728ea1e0bdbso1127646b3a.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 21:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734068967; x=1734673767; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m2jUPvsdlfQUhZsdbtI4Ke1sLD5+tvHbQzW9Gl1gyas=;
        b=JjTHUQ9e1JfhYYLa417xuwDB3s6aYsgrit2IJyyhFv8k/6SyiX1pPlFqLixeZy0CcP
         aip/JfJyZDx/1RKYUvmyLcg2/7P5B1GoTbPZOXSB65gZAdSSeHn9SbuwvGX9n0kJTjIw
         vmN5a4fL5sNWdZIhe7tyQa4wGcnmHWiQVvb7mR8lbyiPzJvQyAi91QImDm8Yzuk7rbVe
         RryeBMKNvHJxnzBO6VEKgrkUzcy76b5+Jo9KIlWUmwzJpHSdD5EYLMaC+eGBTHHF3bae
         GS+HaBnEUovOBqM5j63tFLdBjcn25nrGp2JoCfz/RaMJOsGT55NEg/ks5Ez4f9P2hTPd
         IMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734068967; x=1734673767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2jUPvsdlfQUhZsdbtI4Ke1sLD5+tvHbQzW9Gl1gyas=;
        b=SMZM+ECyOKRFsYyxSwexXZg0AdBr7IiQePGVwaOxCC/OWfTX2nVS2VcJMERjl7sCb2
         JNmv5KDOMrEMxMBO1toB/5HwrESC+BX/2DedppBpRyQVXkIjTt/zFEykjos2v/WBQuZh
         LBER39qeIb61OARhywfz1PYY2WitZEJjD41PmeuJ5+tm0AW/KQfyTk83MIhqg9lJpWZ6
         3MOcWdXrbgvkjDtom0TIrtEGM3xrGOdfjvPamv0zx46jaTQsHPhgRlZJVFy1LA8jBJmE
         jQtbCh5SXEu1oOlrRxt5tAsorhYJ4pGBK+US23w8WzKJKrztykuLH0IiqYB/5icR18d6
         KVtw==
X-Forwarded-Encrypted: i=1; AJvYcCWiwqSuvR/lhUhMa6zBo7tqAOfmhywhwS6omSWaelutQ0FwJSFxC6S0zguqwOaDv/l3O5abw9IdzTnhOg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxW08zXorot6OuVZnS4s/FE29aH+xSeeDUPn1EP5a6kTjGYMzut
	YbdeOFgppbyCMOotsm4YOKU3JS/Rjk2CIT6pc8sEzp5VlrNA66Ya
X-Gm-Gg: ASbGncuDKCT5wOxZh5V0NJb8rNgwwfgP9RM/hrJvgzX5rQUMAlw9BV6oQ8NPvIz/AFX
	sHkr5dIEm2aE3WgCQiJ95iYIovHGBiiIC0J/YfRnzA/x7Uc9vsidYTzwiI+VOM6jkSvJvBXoZFh
	iEZmPNWuXlht3ao3BJ6iDf2BwPeuC7TPg7Or4deXGu5t2QmeiQgWzzMazbkwsMSWO1X2ei+79Qh
	6+SMuy9omkR3k17/rcROTATPBk0lRqOWR7/esedQvIcvugI+02O+zLA+T3iNfUHKpk3IG4pVYJC
	OQ9FsK0=
X-Google-Smtp-Source: AGHT+IGsjn2HsD9B470GSaZ7/WuS4a1ciiqbzWwWUR77XR0Zla03DKiQ+x82aV6yWtJ1LuxULtoYsw==
X-Received: by 2002:a05:6a00:b46:b0:71e:4786:98ee with SMTP id d2e1a72fcca58-7290c2702e3mr2257553b3a.21.1734068967116;
        Thu, 12 Dec 2024 21:49:27 -0800 (PST)
Received: from localhost.localdomain ([180.159.118.224])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725ee10f928sm8166032b3a.32.2024.12.12.21.49.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Dec 2024 21:49:26 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: torvalds@linux-foundation.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	x86@kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	ocfs2-devel@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 7/7] fs: Use %pTN to print task name
Date: Fri, 13 Dec 2024 13:49:18 +0800
Message-Id: <20241213054918.56441-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since task->comm is guaranteed to be NUL-terminated, we can print it
directly without the need to copy it into a separate buffer. This
simplifies the code and avoids unnecessary operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/netdebug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index bc27301eab6d..039d99f951ea 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -122,11 +122,10 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 	send = ktime_to_us(ktime_sub(now, nst->st_send_time));
 	status = ktime_to_us(ktime_sub(now, nst->st_status_time));
 
-	/* get_task_comm isn't exported.  oh well. */
 	seq_printf(seq, "%p:\n"
 		   "  pid:          %lu\n"
 		   "  tgid:         %lu\n"
-		   "  process name: %s\n"
+		   "  process name: %pTN\n"
 		   "  node:         %u\n"
 		   "  sc:           %p\n"
 		   "  message id:   %d\n"
@@ -137,7 +136,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 		   "  wait start:   %lld usecs ago\n",
 		   nst, (unsigned long)task_pid_nr(nst->st_task),
 		   (unsigned long)nst->st_task->tgid,
-		   nst->st_task->comm, nst->st_node,
+		   nst->st_task, nst->st_node,
 		   nst->st_sc, nst->st_id, nst->st_msg_type,
 		   nst->st_msg_key,
 		   (long long)sock,
-- 
2.43.5


Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60163F881A
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Mar 2026 16:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332862; cv=none; b=QEYzV0Jvl+TPO1pJfA/OHKPoJv/ZzadmIGykMhhl3CwRPzvVp4CIuYb7oyEJww7AuPqwRjzzhS0gqSfQotS7RV/uEy8fcDALe7gCEDIAAjCE+G8xgSiSUFYMRrFI45Bc/BzGGiNeIrrrcsT3Uhr8DyZJKe+zcbi62vdK8jdsB3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332862; c=relaxed/simple;
	bh=02rGhxuWGlNpPSap/aHd6O9jLUtVoVM+DZHyaxhsHGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mLokbqMaq8dTHar3zpKe38co8opPhABGIS+BiTlMWOAZvPMe5LHz3lluG3Ta6PP3Rq34rLtTPTF5JdaurRYIYTqjnvt4Sb4ZEBjE1D4k2y2gDKPGo4cVezvoFB5IGJBEjZS5qyPGLns1DFsij2mtyvCY8bP+7YF0Rk1rDRnk/Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fryyVHAc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fryyVHAc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48371104ffdso990605e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Mar 2026 09:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773332854; x=1773937654; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KH/3FZRu4kb9QNYNYXEBrHZ4pupTdvN6/yYWaDZmIaM=;
        b=fryyVHAcZDz2vwItcmZsTwXlBvHB5GZrdMNfftBc0WBjslQvP0kaCZ5XidKTGAOA+p
         bCMFqNVUEYi53FaRn8t9DiQnQ0FTVWFde1ZcEfwjxkXwjggBI25LVBsndyIRPaToO8B4
         m1qJkM4ArZIJv87FkXkAQfNSnhpqruC+gZkzzkHK4RRZUUvnPbQbKNESHY+ZeIC7lidF
         R+Qpz2HB/vz60Or4FRnqBTZtrEAJFiQ1XXX5zgF7HBRwhxjHUchOnwIyplZR0Tumd0C2
         gX2j1nMYhYPbaGD/D05vsT55QX2F97TSddWjIyATk1OBAK0H7YTBw28peAF0fxQeS2Y1
         IE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773332854; x=1773937654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KH/3FZRu4kb9QNYNYXEBrHZ4pupTdvN6/yYWaDZmIaM=;
        b=FOa6UKLAyBCcEwGHxg4vh+FRAK8vvYOf8ttNQTa9XtzGjbb1ve3XQ8QKpeMLH8vnNA
         DJGm/RUCCrylJ4ooWlImu1hJzhOQ0g1/q7nsx+jHll3tkJpSCKW28FlDC2hLGtX3phkk
         WVLx3zP+ZlyJK1XBw8nHbFxYi7BojIhX0QxdAwnKvQg7KJOg9limOAiPvzLELRtcYr5G
         LSzrjtYQV/z4rt+R3p04OnZUo5b8phHYCOejqSwn9GECafwAzik43pkw8rVqZZl7KOrR
         u7ysTKB/ZbK8+musOKcRB3rijpi4yRBYeyBWc3+UlJOyXaq/i/HtptLIQtJtrBlSrEER
         rRvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfUpYQdavLRq30jSAJi4xc2+3JN8vBaBaqNMakqklZuJKckkGrK6eGZXxwrXKWij0fxHWNqcA6QenwBQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyuy8Dbs9mmGPhbFxYvna6PDOJy1OYhHfJTj2hv9oZC1XkLHjQl
	aIu7BvwRcG+pWYASEtL2Xp3DSvyvNaKutDFyJk1BG4EKwnEDSZWdFeTIyIyt40WXzVA=
X-Gm-Gg: ATEYQzzl78z0e2QG1iHZU34SDLKFpZy8R3PrPw5TxZkfp83iSVlQi99bIpdLpS8nl7a
	F71grBxt/ZJpmLp8AqnU+8U5mFdgUef5e0NCltT4vhHD76mAjshdjxMkiRNEfglRit2ss4I/rtY
	hzmpsNjnT7Rl5JvWkGp3tUUnNosx2q+7zNczJSxaTGytZJkDUJL9mEGTxeu/5xHjBABvPp9pZH0
	qs3hq2nfdi9SJ9GUCClMsHhPXXAz40UeVJ+1PNDptHkBHgWglP3+8rvd6E+0roTwqO8ZuGb3EnO
	fQY1Qij160UgtssHzm1VHwj0uGoddQgEbP+yA8o6of27f5IFUXAhquybszNGkHXNduyKCQN9qJd
	drQyDkm8Ib1WXkbNfqzjYNcw2/dD5BbN4n2Itzgy3T34ZUCBvbwzspz9yoObx/1c7NkxI3gw6E+
	Y0/zvWM0dDbC9keZFzY6XPhmVFHbhMiAGjatKB
X-Received: by 2002:a05:600c:800f:b0:485:3177:d80c with SMTP id 5b1f17b1804b1-4854b0a45a8mr69825395e9.2.1773332853789;
        Thu, 12 Mar 2026 09:27:33 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73cdf2725csm5877790a12.13.2026.03.12.09.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:27:32 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] ocfs2: split transactions in dio completion to avoid
Date: Fri, 13 Mar 2026 00:27:22 +0800
Message-ID: <20260312162725.15523-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


v1->v2:
following the review comments, restore the i_size update code in
ocfs2_dio_end_io_write().

For easier merging, this patch is based on Joseph's patch:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 

Heming Zhao (1):
  ocfs2: split transactions in dio completion to avoid credit exhaustion

 fs/ocfs2/aops.c | 58 ++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

-- 
2.43.0


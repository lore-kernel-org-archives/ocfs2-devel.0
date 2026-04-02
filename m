Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622E0222580
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 02:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775096824; cv=none; b=NkpdTE/ixJ66Bu4qNXLjWnClcnEVycPpZDJIO8XrlKR1+IFixsNCBekRGl3SGQoh5F1A88LgMsSr6Tr+7F3BPFrNb+0w1r1FabL5guqEr4jFvS7Rj5RO1oIJN7cLGSOW9+xKQVGKYEgXX1/3/RrmDf0UkUIjpRLoOJzfu4A7CIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775096824; c=relaxed/simple;
	bh=XSyHT9Yhho3ZqzZ7Y9RsrkMYF7bTXiQf3ylyMz69iVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RaERB8O+9UIwIlqWa/aeDpuoGMkrSbB0sSyDgHP3V292lFuYtuKGHr5VcPqFmHGpNXhgXXnljATMkqkFchxXBCIsmPgvVTE7exOrq58A5CaZ9YWIk7pQn6IZ+IWygVzE6AmCCyFzOmOnxAEQmzSU6BQbKm2qtXts16nkU0TeX10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yx6WwhJI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yx6WwhJI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4836fc075d2so467385e9.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Apr 2026 19:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775096822; x=1775701622; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NiJ7ojtXxvzY9NiII4rnOQwHQ6pcB58BL1x+RwpAcn0=;
        b=Yx6WwhJIYcyXXU/Wr2wisVkm3pyhweu0Vi3bNGh1e9GOQA6F4t7hbz0qbxmu+zHTh+
         decDb+7ToRl8r4jmiuGFtaK+F8xWAqSmf92yyIJ6A4b5ZUMiQDLqemLEF3pEwEPr1VKM
         tL43aifjd03gM5nhD9fBWZr+2J3FSFpSAKG+PmbixMGt4Ph+xcja0cl2ayexRcrtB35L
         ymv/T8Kq1KpJY/JGglacmnaF2HkxIlJnAH/JXkcCRGSJirHnbfg54qPr51xY2GNN5+f+
         9psjFInW3qvrKAYut0o2DG+IVvBUBwvVKq+2mRksXVod9FzysQXjhI6R1/ew9IpRgy7B
         KIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775096822; x=1775701622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiJ7ojtXxvzY9NiII4rnOQwHQ6pcB58BL1x+RwpAcn0=;
        b=kkLWcaMtEUt4wMjYxtf9oTjgIu8g7DqG1eN2P2uzkPKnvZ9V30aYIwT2jbfUj/9eXp
         3SxVjDv13cNx4zOXeqfTHeoRJnDNtswedBexTwcE/DA6Pfg8CfdO1W7bo+Mt1xOp2phu
         iKBP/TVxNoQx7iYqKFvgro1+iHoX+x6znZR4gQVBbKBbCosKaQYmYdtf+sjF73jgW3I6
         F2hbN7eys8ew4w4PeWXiOg9dmGrMlB3CaXl9ruWrs14ijgOIqRsWfmhoVTA93V7ejXUQ
         PfansJ2lsDAqq4vQgNdZWxmnmdPU9X7GKSKrTYRNAWMDizMbwGTAQMcL6M1C7kCvwzyg
         jS5g==
X-Forwarded-Encrypted: i=1; AJvYcCVxs3T0+pM7ieh/fD0Kz0xjQQ/Pzc8uduhnLVLKT6Hd44j0teS7SQq5a4M2+5D5E/lBv+Rb8QZlgT/FHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwrBWthhMUbumD/S6buxRzaPGn5FxvP3+JjwHj0O3gO9GZJLmza
	Q0N/v3PTegA9jnAVYOFms36X9rMS682lSVKTOzLl9B9IdVLLktSTZJQ2R8BHnnMpR6Q=
X-Gm-Gg: ATEYQzymC8jQTB7YJkvrk3qG2UakOUSYtqgW+t3uBW34njkCN6zejeEsUx34HCbJ+kE
	6xzVbjh0TxUQ09qw7CC7zkYP8bQuyXGwhYpRURL26IyW74u57frOlPFzIY01A+qr64ZDVoGqUrH
	NciIsLYgP6aKJRVheaqKjdhgDPIkPzHenWaGnEnDU1YXzRiJSqnDbnRPEHUj9NhGB7qWZMJInST
	d2UOSXO2SSddKvXCA91Ta5DQy0+mfKTHEnLeZKsdbLsKbSHVvBvxqBFIWAlJkOgiADKpag8gd4W
	azR7i/gxAPj6JXICEVXsGhooAixcQt/S/tYnck8Tm7NiqEUPbzFiDH50SMw8s3KrB+HtUQv4LIG
	VvPkRt0Yz6aMD9QQ82sKijlo3v9R/C1ctaeVmTgQjaNfJrVHlekw3Y/N+Wdq7PP9P2LmcM9Ubhy
	oufTOpGYBHlXEtkH9ifdMXsHFn6Of3V0aIKKdW
X-Received: by 2002:a05:600c:3b27:b0:485:39a1:bcb3 with SMTP id 5b1f17b1804b1-48883597d44mr58382245e9.6.1775096821714;
        Wed, 01 Apr 2026 19:27:01 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9ca1869sm1268600b3a.56.2026.04.01.19.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 19:27:00 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v6 0/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu,  2 Apr 2026 10:26:53 +0800
Message-ID: <20260402022655.19714-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For easier merging, this patch is based on Joseph's patch [1].

v5->v6:
add a check for handle before updating i_size.

v4->v5:
change update inode size and remove orphan logic.
add above change in commit log.

v3->v4:
Remove [patch 2/2] as the revert operation is incorrect.

v2->v3:
Following the discussion, use 'batch' and 'handle' to control
restarting the jbd2 transaction.

v1->v2:
following the review comments, restore the i_size update code in
ocfs2_dio_end_io_write().

the runtime of the test script [2].
real    1m48.148s
user    0m0.344s
sys     0m22.684s

[1]:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 
[2]:
https://lore.kernel.org/ocfs2-devel/75f89a17-213b-42a0-a30e-d52fb2d077a6@linux.alibaba.com/T/#mbe2b5f52ee249178e1ad4c76d964de2dc818eb32

Heming Zhao (1):
  ocfs2: split transactions in dio completion to avoid credit exhaustion

 fs/ocfs2/aops.c | 71 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 28 deletions(-)

-- 
2.43.0


Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECADD31F99E
	for <ocfs2-devel@lists.linux.dev>; Thu,  2 Apr 2026 13:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137418; cv=none; b=UKziMZyM/FJpL8/j5dD1EIYuXX4jnxonFHENHAbubyDefxbjdF5jxkEOE4eBbLX/g17c5BpgGNBgdABvuK68QGgjsPlclWm/qIcHlZor7xYtE122qe2Smn1CX844tMW+WxFaiIOsF2Uvk9NCA2DCzi/J5xnt/EDjQe//2Yx1AoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137418; c=relaxed/simple;
	bh=OiRkbSD43RbdBIX5/Fw8odpIkY95zVVYXjNJmbpEaZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jSrC3d59FCEjsRF/ZYwGD1mk/KWrgWuAPlRIfeMaPwLNtRu5uFpGJr+2lNnlJtKMQcAOAeR2pUWsttlyLo6VsXtfwcN6sGsZBSrM3XHzAVIPUJVNU8Rt7dosQw8wkwedx9+Ed/w7Ivfen3gfUkdTv3qgAT9c4rt6qJDDFaMOAUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=POVWBcfh; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="POVWBcfh"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43b8cb81bc0so66065f8f.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Apr 2026 06:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775137415; x=1775742215; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fg4uu+2MeXf1ZLo/+x75lQh0oIunnnWZzlhaf/AuFuQ=;
        b=POVWBcfht4/LLLmNsNnCJH/yX3dx61JfzeHlRXNVldsaK88fWfhsRURs5CwEAco044
         mIK1HF4OckcSooN1IPKdii0YLZ5ITsjOvujrQBTL6TEmMB8P/svpV4hl8jzaplMF+FA0
         CqNblxNCjQR7MYSqAuvIgqwdQ5Mk7w/q+xJ5gQ1gII1rVdaukEgVsjZQMOmooUOp1QBS
         xgfAJzEoEY5dOZMwiGPKwVfDHyvLtdDX/CH3CFq2+SfxJnaC9n3sa4thZyk9TkWAmDWJ
         gyS3Mjo/ATibq2s4R4GMrciekZAt80eXpHhK0gyegUNRJ1zf9iyFoSbSnLDbw+6HQWij
         XKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775137415; x=1775742215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fg4uu+2MeXf1ZLo/+x75lQh0oIunnnWZzlhaf/AuFuQ=;
        b=jJffw1w5bY8iuEWAgBOKTHOZnUNUsFKGoidnGR6pZFkVIjcYxWh6QlpLX5Hl/ehFPt
         lEMnmnz5BSRlyEB+pVr555i+ND+P2Vcr/JsnuCImyxnXWgMDlLpKDRIkGf+R1RMBdMPu
         l18qV50b6VcpEzZ0v0OC3I0nAHRgfkf3WOgPP4QufNT+EsFCSnJ4p+TN7iUJrXh5Yclg
         NsixcvNyYtCDHzZr+oAC+S9vmoldoz5+lIzZBLbmIGG4hLUKIg4B62YBp5VUAkKArIPg
         gCKn2zdhkDHNoWjszRN48fqm8Lb0DkhioZhvjhWLkg+Ek2qr2IaMJY4bJoioKNoZanYs
         lpNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXCcvdA2HDEC+F8Yc+2L0a6qtJ8j3q34OwnM6IfgwvmwINdsBeYQiTsUhVdsF72m3DNmiac0Ma8dgV1Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywpt2VcGNk0DI57kCUBZzAX3q95HfHEdnKy6emYIuqYvQ4yjJ2v
	lOjasbsDBwEEySU/FOA5ujDWpn1MBbnQq3uj3dTUwxwgIyYgHrWXDs22bVGEO5xobEY=
X-Gm-Gg: ATEYQzwlALtKhmjPKCp4dSO8pMbHF5JS2OuSIFSVDUpMbIh2pRCfvpG7UgYxxmw16fD
	zY8fB5a4cSQFSeUo/dMWU1z0Dm+q2pobnoGTS/7tofLJFQIhNnRxOn14+RNvs8cs8o8YiDEUTrN
	mToz1MASf5LKdST/mW/JfZOe4SUDAq/ROOD6bbbHuURw7CaRWE5YPaNCEqAj/+Tt29102BH4UL3
	PWOOL0FhvAugecOrMicjC/AswXNJ2g/WI/RXgqkX6nuP9/0VZl1cISpI2xCdZaFHDr2xV+V1D7X
	gSJnL18DAs9F2Csbw5YumstGl7Z/Qmq0/ah8rKAhk2/yArixLEsm/sKiun5qv5OHoJqhK1BEMtA
	lZQmpXVgoPA6e/AxuARGxvhk42hBWve+63GxXsQTxzkfIiH7iQQotodm4Ss+cPT71NlPx/ffxdv
	rXtqD1NMm5B4sAQKn1sjN+ydpbjYmZOBNDmqES
X-Received: by 2002:a05:600c:450e:b0:487:22de:25 with SMTP id 5b1f17b1804b1-488835af512mr72099185e9.7.1775137415329;
        Thu, 02 Apr 2026 06:43:35 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27497c0f3sm31468005ad.41.2026.04.02.06.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 06:43:34 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	glass.su@suse.com
Subject: [PATCH v8 0/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Thu,  2 Apr 2026 21:43:26 +0800
Message-ID: <20260402134328.27334-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I appreciate Joseph's thorough review and his patience with my oversight.

For easier merging, this patch is based on Joseph's patch [1].

v7->v8:
Per Joseph's review, add a check for 'handle' before calling
ocfs2_start_trans().

v6->v7:
fix logic error regarding "handle == NULL".

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
real    1m49.387s
user    0m0.325s
sys     0m23.006s

[1]:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 
[2]:
https://lore.kernel.org/ocfs2-devel/75f89a17-213b-42a0-a30e-d52fb2d077a6@linux.alibaba.com/T/#mbe2b5f52ee249178e1ad4c76d964de2dc818eb32

Heming Zhao (1):
  ocfs2: split transactions in dio completion to avoid credit exhaustion

 fs/ocfs2/aops.c | 74 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 29 deletions(-)

-- 
2.43.0


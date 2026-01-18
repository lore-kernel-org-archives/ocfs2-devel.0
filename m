Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28642253EF
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Jan 2026 19:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768764207; cv=none; b=X82Be5/AaeWTF+1uLa2a7+5LMj7DsyWYiJM80H3Vf1RvCM4aLC6rK6BuPx2XYunribavo29f+uTewNCyjETyb0dSpVBREOErK8KQA0XYCghkIKW6loGmgyncY+PSTLbeuczSlBXZpDsBD0V+kfmkbfCj2Z8krai1A8PbTH/3x/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768764207; c=relaxed/simple;
	bh=53UopOiSS5GM7ARutLD39Ovf/BQMy7Mk8S2UQAf9p18=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LwiG7WJzM6ri2SFW5wswQQiqVr/I1SbqtUNoRF2u52vtwwPSgo/l97BX/oVwdBlHWIUjn5/u18jxwdmJ2UV9JWn2fK8JJWLn4C2GoHNimrDsPPkZwyfycbQNY5S6FZXK80Nh46MvNnI5vdEt2s3EyHYhrdWAnEt8cKZ8LHikQYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4J9Dk1A; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4J9Dk1A"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-45c798c92edso2272523b6e.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Jan 2026 11:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768764204; x=1769369004; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bDtxksZFS0nrsjFFEzMEftEkeVqAD5J3c5aurgBd+rU=;
        b=W4J9Dk1Ace9XKqSfIRO0rSGDZ7LgG5AfW2XnQJpq9lEF1YJIlwjjnGA2ZR63IUf6pz
         Uhxprm8du+VNhQF6wzzSnnjzuR3LoT1+wO8m9DLhcG5s0pYhvRrwOsS8q93xagPK1BvH
         8r/1fANUSBgs33mPnAw/WZPx2UaC12hVNH3YOtaH1kX1F3MxUyE1/sSQ2xoE1xETCl13
         x0peSECiJ1Y+jaX5zpKKZgu/GN25UQHkn2yXCCLCoMjWLxQDQINeHCwicGTZBguEohDT
         soL3/1hTzEbruRrTLzZGUaI8PuEkJa4wTXtsWSpFag/dn2l+YzSdVH8Qmob9BfgeVVmA
         x5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768764204; x=1769369004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDtxksZFS0nrsjFFEzMEftEkeVqAD5J3c5aurgBd+rU=;
        b=VfuxrJ49Cj+uvys8SFUJYWCNuCJHS5rMnFhoIDfA4W2ZRY+/KVzmOaelUbrRh0HkZJ
         e/IYTfH3WvBrwHyhwr9mSgQc/cmBcZ2MkYn9Ucv32iCZYFauMaEkXhRCFEqBQHAw/Y01
         7VH03JvAlyJJ6JQHGHL7A05o74L2SW2oW7EQLk+4dVgRjCg9j1PlZ5pPFBxpRwZi6M5e
         GZo1doqrA85jHD7DirFgC3w4LXSbbKGp/KiSvSNXq/4ozfVcBFnxL+2VZbqmX7VoXDxC
         hXrcD4nIojqhcL6wX2OeuVZE8wEwcIn1RNeE2bA0hktuODkcbYJU8pbxuLP5qqIR5oF0
         XBIg==
X-Gm-Message-State: AOJu0YwWq75wXmKq1EMD8WhZbIXzcozvUqGx704lr2c/dYSCddZDwz30
	1gsixtDtFmNAmYc0ezi9z6n8HcSVs1RrIz6nuYrUKD1rQ9tD50iDLgU4tpD0nw==
X-Gm-Gg: AY/fxX4dCgjP/GxdCctIlyupbSY7UQCmeSScM1onj4mlelqXnv5zrn8flqEZfMgPKVR
	yPXVgibTJbDw/sYrnPPEETqfrPYGpApx8t4q8g7Ov69KQAGKukBO7A2JlFq2IgVDBVcaxJzoh9l
	i4PN4Bu7HD5RhazWXKHkYad/DXtMCc1VTMY2Njg39/YdbPrSCSus+cHAI0ymKdPQy/YOk3o5Lx1
	B7A4LnKqn7etjjjksD5nDodcCjylo5k6ExAL66yCZMwmrl1SJKykXYdxFqwMvjX8Png4mrek4G2
	LkWsmcdr5mSX/V6nR0PsqImpzrBLKmLpG4RWdoRVyiPkz+RktIaP0MawNT2DQLILnm+23e6D8cL
	zCuwiCuDS5vZdaet2F2+Emg+3iaS5papqgvpqWGsrGmuF+H2K1Hp/q1kY7KxGNXU8azVLpbT3Pc
	gJ8ISCqd8AYlVN3Y4/42A6wKCHAf3VzypP
X-Received: by 2002:a05:6808:1986:b0:45c:90d8:c843 with SMTP id 5614622812f47-45c9c091394mr4106712b6e.37.1768764204403;
        Sun, 18 Jan 2026 11:23:24 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf000b80sm5543917a34.0.2026.01.18.11.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 11:23:23 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	stable@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] ocfs2: fix potential OOB access in ocfs2_adjust_adjacent_records()
Date: Sun, 18 Jan 2026 19:23:18 +0000
Message-Id: <20260118192318.44212-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_adjust_adjacent_records(), the code dereferences
right_child_el->l_recs[0] without verifying that the extent list
actually contains any records.

If right_child_el->l_next_free_rec is 0 (e.g., due to a corrupted
filesystem image), this results in an out-of-bounds access when
accessing l_recs[0].e_cpos.

In contrast, ocfs2_adjust_rightmost_records() explicitly validates
that l_next_free_rec is non-zero before accessing records.

This patch adds a check to ensure l_next_free_rec is not zero before
proceeding. If the list is empty, we log an error and return to avoid
reading invalid data.

Fixes: dcd0538ff4e8 ("ocfs2: sparse b-tree support")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 fs/ocfs2/alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 58bf58b68955..bc6f26613e6e 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1974,6 +1974,11 @@ static void ocfs2_adjust_adjacent_records(struct ocfs2_extent_rec *left_rec,
 {
 	u32 left_clusters, right_end;
 
+	if (le16_to_cpu(right_child_el->l_next_free_rec) == 0) {
+		mlog(ML_ERROR, "Extent list has no records\n");
+		return;
+	}
+
 	/*
 	 * Interior nodes never have holes. Their cpos is the cpos of
 	 * the leftmost record in their child list. Their cluster
-- 
2.25.1


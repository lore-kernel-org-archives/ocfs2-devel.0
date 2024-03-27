Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E466317BB3
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711519774; cv=none; b=TtPxpIMlmvO6JqqLgt70dLFNI+nH2sw0vaUOz1QeWPhnrXhT/mR7iM6M1Rhk6Q6Aj+8WL9g+/Opj7xau2ClDhhdA3xBocAFCGiw0uJ8QZ664uu02+gEI2uup2HueflUajgT0KradNUm0iiYGJwj6glTgF2zoBhbj+YvAFUXyCmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711519774; c=relaxed/simple;
	bh=IOtCI6S3S8zwk0hxblJ4yO7qkjd+2iXxGbl2RuVdwUI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Aj8rDKzTGUr7x7sLnfnN1rQSx2h277zBeyd54YfQyD18p3kXdVXX6B1zNoaO5W5KRWAL3BACey3bgFVTzMjxF9z4Ec2kDo0RkL9o3mEr0gh4JaPMyyVKjSQH9/nZ83/gqQAyioD+HpuVjIRyox3fBAti1RUXkS5TL7fZaylM8cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CKF3j2BQ; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CKF3j2BQ"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d68c6a4630so74197441fa.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 26 Mar 2024 23:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711519770; x=1712124570; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSHLKicfdHpoCUuEDOBtWZ/Mv/xYwg8o3haFByO2wf0=;
        b=CKF3j2BQXLgvY/bnNZ6wnkm+7HokK8k7JO4oSr/ozbsp/TR43p8AQi1zsHCB3V/h/+
         JgHS8rgw8YK65h8f+ndyJvh0Hj0iG00DOjC7BcUK2QLT0JnamqAoMDQ7rDqYAt5L9FyX
         O6kx08GX0N9EDIpq3MC8/poLouetXiOUSJY+XemaJZTaYsbQzeTeC7MzZL2fUlhc2pBw
         dXsxX7rnrIq40l55YJJ0pTKimoi7F+/5QDVsBefy21ULuzsK4GA/BUQCzIPaBF6ywtS/
         gZpBtheJXTPECFtTRItEg4o5uhlKRdAISold66fik2ol/WPCg5W/n504ZtVTDcqC0XQM
         l+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711519770; x=1712124570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GSHLKicfdHpoCUuEDOBtWZ/Mv/xYwg8o3haFByO2wf0=;
        b=D64DoaK4SWsoOzdUAFqAFaQ6fvp53XNo1U1xguEFQawnJwBMW4SmYXNuBvuyNN5RKM
         o+6zdxQmvf7NCVXbPRSfQN94aM1VFZr7y7ARvgpaHGuKGm7NkRWFyqWV64v715Te5f8V
         AMoWrr5g0KXlaEW5xTsuCIFInzXVnjMCIAyevVgHRbEgDJVHOOFJ1XfMusjzVt6dVVAm
         qoJWxmTnaaY9QeHBDXwHtGcPzDkCwOI/n3y2UQcAnlaxR1O7b8/XMdDqOgF6i4tniZRl
         R3k60TQMbCGRZpH0G3zigYpfMbn9ZXLGUjNN713qh4u1UiJcAsv94xNP/wPOAtHVTo1q
         gbdg==
X-Forwarded-Encrypted: i=1; AJvYcCXqTOA4OLufj5GciyT9km4UzypM+ulREd3ncX970Io9W4d/UVpUi07x37rDPsdK8t+TwQe+iYj5ujL3+bGJymoV3QUPuniITbhnAOw=
X-Gm-Message-State: AOJu0YxkyhfBnKJ6wdcteF4bcJsV/G+j8PdwEikLSGopPwsnVeNyF4r0
	FhuLF6B/+cQz9jygVR8tAAjm6niM+NJZUoKIC6wZu7Inrty7jVnOzNsJD7Cin0g=
X-Google-Smtp-Source: AGHT+IHxo8g9HYRZ0h9JGUTCGay4H6pKFJ9lZM1iZhaD3LNo+7N1wnoi6qPcQB/q/Pu/HZMmi6SMEA==
X-Received: by 2002:a2e:9e41:0:b0:2d6:8ac7:455 with SMTP id g1-20020a2e9e41000000b002d68ac70455mr180805ljk.40.1711519770283;
        Tue, 26 Mar 2024 23:09:30 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id s1-20020aa78281000000b006eacefd8fabsm93445pfm.64.2024.03.26.23.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 23:09:29 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH 3/3] ocfs2: speed up chain-list searching
Date: Wed, 27 Mar 2024 14:09:14 +0800
Message-Id: <20240327060914.2583-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240327060914.2583-1-heming.zhao@suse.com>
References: <20240327060914.2583-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_claim_suballoc_bits():
- Add short-circuit code to speed up searching

ocfs2_local_alloc_new_window():
- remove 1 sparse warning
```
fs/ocfs2/localalloc.c:1224:41: warning: incorrect type in argument 1 (different base types)
fs/ocfs2/localalloc.c:1224:41:    expected unsigned long long val1
fs/ocfs2/localalloc.c:1224:41:    got restricted __le32 [usertype] la_bm_off
```

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/localalloc.c | 2 +-
 fs/ocfs2/suballoc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 2391b96b8a3b..2758ae9164f3 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1221,7 +1221,7 @@ static int ocfs2_local_alloc_new_window(struct ocfs2_super *osb,
 			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
 
 	trace_ocfs2_local_alloc_new_window_result(
-		OCFS2_LOCAL_ALLOC(alloc)->la_bm_off,
+		le32_to_cpu(OCFS2_LOCAL_ALLOC(alloc)->la_bm_off),
 		le32_to_cpu(alloc->id1.bitmap1.i_total));
 
 bail:
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 4163554b0383..4c4c381b5148 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2008,7 +2008,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
-		if (!cl->cl_recs[i].c_free)
+		if (le32_to_cpu(cl->cl_recs[i].c_free) >= bits_wanted)
 			continue;
 
 		ac->ac_chain = i;
-- 
2.35.3


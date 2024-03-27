Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C32CCA7
	for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 08:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711527722; cv=none; b=A943MVK9o8N9jIpseRFLcprhv6ir9kaTbmixCzC6ccy8s+5T7ihW5SyA5yrH37ZWojNiuWYb7vx8tk56lqk3L+lg7XY9ntAcyP5RlCWEjFchq26HJQx8qjdyHmWARE/MCig11pj0xP5DtNdb+aKVeJUxV037r0NuhnJXJwAl52A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711527722; c=relaxed/simple;
	bh=h/qiDXSm8+bl3EeaEj8/X/mi9SQvsi0b0iRREux0DnQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UE7X7ejfYxbQd2nTGr5f5gaqD5Ez5ALU1enor4B30k6kTP0VKOWAiwk2LNPrhTKuIY5io3SnFeAcQEo89eQQ3spHbkOKO/3uz8z7kfz/IRwVCckczGev97Nn6cYJhT2X3colpbCP+KXT9PMAuLbdBYEbWzdv1fHMQRdjBRAh1SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TBkr9wYL; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TBkr9wYL"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d6ee81bc87so14112631fa.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 27 Mar 2024 01:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711527719; x=1712132519; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KrhO9V//Fg07pbAEupwmXYLu+am2K7Kl9+M+74C+Ik=;
        b=TBkr9wYLA9wY2KqoY+J1em6gUjRAESPSJIEBc975UNRSX4Dz668smqT152mw2T5svx
         K56puggBqnG70tCDSUex/jEQZOrRmGnNezydkOhonQTSUsUJvmmvRg3QwihgNKSZPCCc
         fxJidFZ0ReJPDWIa9wve9RgVS8OKuqqCRDkYClfYmGQBRHTunsJae/ocifhe7vUpVQIs
         UzWi/5/KHr3S3lFMguTum1DmQYwobrgRXANC9ODQEsupc0lZn+Aslwk53f+VjUclb0Nw
         Yk+iVTc7gS53iD8PR5bHrU+rzWX4hodshLE5fqrHUyD1ubYOkEFCE6Q9UydRoTel6l27
         cuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711527719; x=1712132519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KrhO9V//Fg07pbAEupwmXYLu+am2K7Kl9+M+74C+Ik=;
        b=BHeaufxqhMyb5tBiofcTHrJr06KxQNS2qoYADb0uxtOQMMXn0OdjJdcO1Jhdn3nnKD
         rVxJNo1jAZKxdZY5G/HUTESUwuVnj0yiQRmrTHWPFqVOAkm0pN+PXWhLUOnZbwzXqQpk
         nqiAw43JMqQIoh8sn3Wut2eWLcvVkK4nEn8sb7a0u87O03cmSZ7d0S1Jhkc/KwofK0Sg
         zHVLjp2jmtNU5kDMqP4xAlBsujGKdBME/a581dXb/vWngeVss0b1PHulkAgMxrk3MSyV
         fUajrwB25yXQVKUNiDKfX9THEuJpdsZrkSqK5LGRZ2PTx2HyDDurdjPCYhEEBoDcB46L
         mFeQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/J1dIOzE1YHiNInTeFk1DWTrKH2LMin/EFE4NBM7RzebzMVd4eTcVdiXC+cHHrkYbKWSIuqIxdhc+stmjbBDpo0ef08PUwvhtiFM=
X-Gm-Message-State: AOJu0YxSKC6TRmOI4lxg5TDqlvjMUFZ6sqyW95cyKusgtS4pKCb0etvz
	PoWtQU6bRzLtQgilv7K8A8a2bD4r9KpTGDXUxTQehqqkz4zeHgnJjWNBB2xOtOV5FHxAWgrHxx+
	v
X-Google-Smtp-Source: AGHT+IFiIBEz21Y9K4W2mC35j69plDNuY17Kk6if8xFWBgF9akQ+hM3UKi5+hPj8yTkBTFf9zvVpWw==
X-Received: by 2002:a2e:9b50:0:b0:2d6:d536:41ca with SMTP id o16-20020a2e9b50000000b002d6d53641camr1409192ljj.4.1711527719072;
        Wed, 27 Mar 2024 01:21:59 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id x2-20020a056a00188200b006ea858ea901sm3423022pfh.210.2024.03.27.01.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 01:21:58 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	ailiop@suse.com
Subject: [PATCH v4 3/3] ocfs2: speed up chain-list searching
Date: Wed, 27 Mar 2024 16:21:46 +0800
Message-Id: <20240327082146.6258-4-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240327082146.6258-1-heming.zhao@suse.com>
References: <20240327082146.6258-1-heming.zhao@suse.com>
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
index 4163554b0383..ebfa17dccf97 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2008,7 +2008,7 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
-		if (!cl->cl_recs[i].c_free)
+		if (le32_to_cpu(cl->cl_recs[i].c_free) < bits_wanted)
 			continue;
 
 		ac->ac_chain = i;
-- 
2.35.3


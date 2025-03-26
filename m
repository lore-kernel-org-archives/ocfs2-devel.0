Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809281F94A
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Mar 2025 01:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742951400; cv=none; b=I/zCCwZ3XaAckCn47yPrxUIraABYYYQydojgmH8pReZbvG2bFeXY+ju8sOno0c9wuxSKuwcan5CIzSSXoDlPADgo420bgrjSkWvLsUYNTO7gn/6apuvWwAKUWjmP/9ACWH2J6keQKnWKA6sjJKbM8rnncGIqsANfN48DvL5SABc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742951400; c=relaxed/simple;
	bh=9pMakLupZf1ZOgdVZRB8Xrg8ib6rp7vApnnpEdQilY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk3SIN/Pg7GuyDryUxSVM7VXxt6IEJsE5969SNEUx0VbSfSamH6Eyl00EE6DqViBeNhpp92uUc9EqtZIFAt+5JAKp21KSH5v7X/f9fH0puRddjw9Is1w9D3HXck0Z0mKhaj1+iuc4uG6ts56N1bzzRbH+5LSIKCAB1Iu72QHp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UL37w9Ui; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL37w9Ui"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff69365e1dso8664177a91.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 25 Mar 2025 18:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742951399; x=1743556199; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDUlb29vBiX6H2YK2qWRNwPg+NjBtOzJ4DqHPrOXp3o=;
        b=UL37w9UisFYUOXvepyBO4CZNSYm9+PLJwoNRx8TktX7dLs2s1ywQM3aYAY325CA44r
         nc8ZiSvnn1ESSb/sj/6xHewW+pa/19p/nYS65xpzibmb+L+tCNCaHiYmuOBkIxeyZMVu
         nsxdKSDSjMxAVu+YSsOJnOO+fQuyaMsP59Ex88UVSeNgrSwHx4Jq6YFETflQ1uCfHTVo
         pheccLHLab/mfPwfFPLc6Mkir0/1vyVerwTSvGIYTspQoU+slIOFsLnHMrqqGBWDmeiV
         1u210Ap0I0zn5GSiOFqp2mlS1UvaC7PJJsHiAmSwWKkyayt01UsoY7u51t5hnI6/Jehv
         8hbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742951399; x=1743556199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UDUlb29vBiX6H2YK2qWRNwPg+NjBtOzJ4DqHPrOXp3o=;
        b=PRocNImX+/6+qIrZ8FLz1RK8x4oMt1JaQRj4iGfG8hDA4wSPBBm6/qXua2b8m7t8Fe
         vrR1rth/1sf2HjV7QrpS5veDnb4tOUUc6s9CVyNZuspCPHNPjEhKisbNJ0AQvqRSQAjd
         GDPdPY7peXzs3QO7G/U/mHHj0YcUPkjzefI/W7sONsWUBlg31B9wWsRH34UTiuruZ5Ic
         oDQqZqFJc12Kp78L258KM7/IR6EXXZCn6ZwR78eCm02vaLs0KUzZwP/US7egSj/xmyHX
         3Oo3JpFfK1ywgxYqhXanWrRqL+NAwgMPnIc9KvtnZGkFZsXcXT/v7YI/LdBNQvHo495p
         Gkeg==
X-Forwarded-Encrypted: i=1; AJvYcCUgfB0yg/YFye6gzPgYF+sB35yrBYso3oFImd7Y0sF2NtxFohEIFzYyUYCsY2hYbcAtsC5O/XaOMlhQ8w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8dm1WWNrofrZmHvIX2IXoYkJC2tL1/d+bOCeriDAkSwO1wvSt
	wJADTVJmQ6rraWoLnOcW2X2MV6xELVv4fJ75vin4a9FOyvWGf2v1
X-Gm-Gg: ASbGncvY9YLIobAxA2LCy3JFl8UQ5ur0H5JGCGBBwGH+RlaKglNXSvWtL4vWMuEam9i
	DYDtKm2LhG4csk4EbKRD13ewrORep3TmuKFJYFpKIi94tpbiNRYZyGAXhOWAGM5QEdYwa6UjGAK
	emKBzSlyEcEvWvJzhNbfw2QjyzTUMK7dVbYXu21+rExHR67DVyxcp3my8dbJFV37PVkVfNJGFMP
	5vZGY3+5RpWtuuF6IaqUv/joH7iFRd06vOezrx1xKx//PSELuJUU8ugrSVxiFMSfQkDNUSb7XGe
	mVCA8HbWPuVhfk1AeBCnKjh0gOcQCEfWY0uo+lA0kVrN0wdF4/84ZlBLcJSLFqgY5JR2BgCt/Q=
	=
X-Google-Smtp-Source: AGHT+IEvHx3yUiDaq1adNzrPbXDj2nNf7JlV9ThMH85Xerks1PyOMSAuFX46YRrkWA6aK7ADD4RulQ==
X-Received: by 2002:a17:90b:2704:b0:2f6:d266:f467 with SMTP id 98e67ed59e1d1-3030ff06e33mr27059465a91.34.1742951398516;
        Tue, 25 Mar 2025 18:09:58 -0700 (PDT)
Received: from vaxr-ASUSPRO-D840MB-M840MB.. ([2001:288:7001:2703:7cf9:c75d:456:248c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf576aa7sm15186649a91.4.2025.03.25.18.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 18:09:57 -0700 (PDT)
From: I Hsin Cheng <richard120310@gmail.com>
To: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	I Hsin Cheng <richard120310@gmail.com>
Subject: [PATCH] Re: [syzbot] [ocfs2?] KMSAN: uninit-value in _find_next_bit
Date: Wed, 26 Mar 2025 09:09:52 +0800
Message-ID: <20250326010952.8878-1-richard120310@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <67ddd191.050a0220.25ae54.006a.GAE@google.com>
References: <67ddd191.050a0220.25ae54.006a.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 fs/ocfs2/quota_local.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 2956d888c131..c0bbfdab40ec 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(struct super_block *sb,
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;
-- 
2.43.0


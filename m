Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9040F272E5E
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 09:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755596518; cv=none; b=C8ewP5oApT+KmCvKggdfJQJovFEDqC9V2Kl0Rl67GjH9nkiFiV8d/YjfAa36Km3/ZOIBVwYfetO6NNIsWQdFm+29TjCLh5EOtd2MSe8DGef3zc16+SBAtGMYyiw3bG3+b0obbeI9Jqh9e5Hk+LfVFQrADoKfXfwtOwUtTidmYgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755596518; c=relaxed/simple;
	bh=Rn+8s1z9P5Tpkw9T71JqBJFM5aF2BjvuA2JqLXFJzxI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lWyJWyZO1qj6xG1MREhNUjMbXPxTPK8ejIgg2C0ZdYqrYl0FLDe2BMEZ9HDNrUVcq8aPpW0LpGHa1/TXAF9LtUfdabHmKekRSpqZgL5qMFRNFe8+exKlfv2n/0P6XA2Gz4o7UhWa+GMg1MAdc5NLgMJp56PcqXOqI3sPprZB3og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=doez4/m/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="doez4/m/"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a1b004a31so35642365e9.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 02:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755596515; x=1756201315; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uVLLl9OqNk7Zu3EPzfXMDRVe4XrWiVodoUaeSDsMNj8=;
        b=doez4/m/K2YeI5CqbFnfGFcd41lzMSZBaRbz//BumiNZ/MPjjkcHIxB1sgZo4/BOOr
         e/r4ZKgdo1pHkbXyLgqznuk4HnhMAj/8ASuuozx0ObTbOn8kKYlJN9mqrVf+AkKI8P5a
         rPMkcx2HWm4pHgQuIB5HAb1CNITpv4lRPBuWgaRTncyDKJLcyeE53RRqmBvsHMIV5t1G
         CgX8MtxcOkMFUiz1DNC+Logf6ceNbsj+z/njBynsqGkpXqwa+D1t2etk6yZmvh41lgvG
         peQCxwgmzRUu34fIPCz4QicUIwLJVIBNsKVUaOBnQcY/QsIvrK0XIo43q50djojLeC3u
         z4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755596515; x=1756201315;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uVLLl9OqNk7Zu3EPzfXMDRVe4XrWiVodoUaeSDsMNj8=;
        b=EqOiFDv/VrXZekMBUIhH/j8SuRi55liimfjylYjNm9eteAAyuDx3v1HnShtKWJ2f55
         Bm0iwqUlMQXLY/rARTTecaqkCZ3dpThK1jgFGiv6gBhipyTMSO5sHfhzBbHw8fm+naWu
         BCALu0A4sgh65a2+mpgpJjdrMX82X71L3AF+PssvTT7q/XOaXA5AuVLZEUh1E29ltw06
         LUTjMZy5uVhFMMVyaqLgHDzJ4RTzy47MQXXphnv7dortPvhkLIF5co082OVsO6nS5R2u
         57md+CTbHXVZ1tDcpqdnuDwPu70u9nZaPCEzdSneT5Ad0RaToyPjbMJMNG/fpWQhh3Rg
         PCqw==
X-Forwarded-Encrypted: i=1; AJvYcCVqDyYSWaGkLj43IAYCVQ1I0waipyGPHL5xyKvL1BbKESuvOutf5Y+g1uNrQkwnuLZdvfLBk19ePNNAJg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3/wZnSxFXUGycXKhp0IvE7JciUqFKjRarSEjDDcKgCJqZq4qs
	PR0qgIQ2JVQwUIgkLOoeum4g3RudlPreb1PzOUad8kbhk04lgih4YMv8TIZbDd2rfV4=
X-Gm-Gg: ASbGncuMLGeoCGN0TZyzoR3IsFi9aX3HwxzIMTeRvOchykfzppcryUQaw7puL3sKyw8
	LFTMznoeQhss0Zhs+I5MM5a/fFlPk8NdTtxkAqiYLTMXtkoMCpt1qbKKNgEJa9hjsNH6CYAP2F2
	hmxuE5sH8Reic1nukQW184/0+5NvOW11GXaCiPed5kUsUYJlDXWtxyIP6MYO2jQGU3a9Kwwg5u7
	7yzDklQoK84cnt8sdDvOgAiRMJKyfCMrr7/LdPVdnmU8DHBajg6SZZ3ZjUAvzuVQ2Loc9Bb0hut
	TUz1ytBEeRc/9i9rxdtrqlxDT8B+uy3+AqQdbGnfRbT3gx+WAhY9mBJSdFtmiGLWWpk81kJaMsI
	ykj3DDZzlBBYZS0aT4jgFR3lsEQD6J3ptBR67T5ZRfnml83LD4qGP0g==
X-Google-Smtp-Source: AGHT+IFmUB9GNTXpWwyDrW0I7+LgcmGoPg5Mmao/+q2ZsLIelBxWWUigl7kupDpLBula5DDMuHfjng==
X-Received: by 2002:a5d:5d0f:0:b0:3b7:8832:fdcc with SMTP id ffacd0b85a97d-3c0ecc3219emr1522505f8f.38.1755596514815;
        Tue, 19 Aug 2025 02:41:54 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077c5776fsm2929467f8f.61.2025.08.19.02.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 02:41:54 -0700 (PDT)
Date: Tue, 19 Aug 2025 12:41:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] ocfs2: remove unnecessary NULL check in ocfs2_grab_folios()
Message-ID: <aKRG39hyvDJcN2G7@stanley.mountain>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Smatch complains that checking "folios" for NULL doesn't make sense
because it has already been dereferenced at this point.  Really passing a
NULL "folios" pointer to ocfs2_grab_folios() doesn't make sense, and
fortunately none of the callers do that.  Delete the unnecessary NULL
check.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/ocfs2/alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 821cb7874685..162711cc5b20 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6928,8 +6928,7 @@ static int ocfs2_grab_folios(struct inode *inode, loff_t start, loff_t end,
 
 out:
 	if (ret != 0) {
-		if (folios)
-			ocfs2_unlock_and_free_folios(folios, numfolios);
+		ocfs2_unlock_and_free_folios(folios, numfolios);
 		numfolios = 0;
 	}
 
-- 
2.47.2


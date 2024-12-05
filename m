Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C811DA612
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733395731; cv=none; b=ryGBoAAbkKJ4i9s4dfarxGfiPM89AEBRYAY/HYZjH5wAvrRAHMHSVqDS20iU2iIC7tB7JbtJCuAPn8xPxQa37IFixL4GYI7fS/NVa+KQQ/a0LdcRXcoFzurGWMcOp9b3cHFg8h+4ZiWR/nerdLstk3zphSK7nFcxpkSqG5Wpwh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733395731; c=relaxed/simple;
	bh=vzXQjICMuoPOyTM60OHH8vNdn2RJrSYEWLd6HwtWudw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYXvgbjlQqU61y2X8zl85N+elQApmUk9gn3SulQxeFwQcKdAoXOuk1du0SMUXaYBOYwZ4uBo3PtqfRrablUY/2Yh1p+Kp5LbQgMG63xKFu3B1ekGvU1YLfsv1r0kyxE5ogWioEFI8Ef/jHx9WXxawRLZ1ftbrhA2nIaqdviP+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qnac0DTW; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qnac0DTW"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-385de1a5d6cso29763f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 05 Dec 2024 02:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733395726; x=1734000526; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+AL33YYB9tp8ze1zSblC79yxMnHDSWw4amoRXEM9yc=;
        b=Qnac0DTWT2F5HdrwG1y235A2i18fJEiGn3xia2LIDcRk9UGTae1gJTfvneRQmcykAa
         Kwbe8pRumUzonZJ1GR7wf4wWn6N6CiUFKGBbox57j3gRRgnsxtHBL+XPHi7jq4g9rjfn
         2d/3SIFNMXlT0HbATUuD13hmnrtdVJNZXjA3n1ZADULOgOOIEOBSw/7HY2NsW/UvVyIh
         NM+HcIG7CZE4tgg9X0/OJWdscyItz9L2D1mxvTV3d/nhtqL69kwFyGKaK8sZ660nNUD7
         Sje+yR42Gwq/XmvZoVVcq20XrHDDWCQffZs3olOXILPBLLsR1eALecuqdhF8A/V891DX
         rpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733395726; x=1734000526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C+AL33YYB9tp8ze1zSblC79yxMnHDSWw4amoRXEM9yc=;
        b=MLd7EZigof8chJ95knniIwVazbxZPHIxSpCz3uM4nVNOc4ak1wF/OyHPe/5p2W0Kp7
         n0eL58TSMZBe2ZkJ7drgUWUaBtM7mKM8Lq1DlncVZNxRpmstIP//ccirIJw3MzBW1c9S
         7HEfRjjHIIKUPfzi67uyKdO1ppzZvGWBOZjgbhWTyzxVvPxvi3NVKyRSGi7KHx3Aj6tT
         ig5IzyQbXpXFRT0jefes2BWIcDzQr+qcpUakyhJOwBLuU/Uj07N6qb3zQc0+J1BgOMrq
         DsKtggKoC3gtn+YB/l1hxg8i7/zzFcsWWCqq96ycTql1mAPDsOzVRxejL++xAC2H8TUP
         RGqg==
X-Forwarded-Encrypted: i=1; AJvYcCU+5c3LC691Oqh6oDw2Q7Ge5bpQPpvXXRJPsMFXS5PXjfRMeIxFrirGajHPKIFnHREHCNJWm/xdCBtJjw==@lists.linux.dev
X-Gm-Message-State: AOJu0YymNEVNyFAr0m/r0lUwNwlikRBcX8+dOjCoAe6p306VMI6rVjV+
	LRJCGVRQlGQBhueynmJD4UOoRC+RGVE6k2+sYEd4FhNsftiB4xsuYEvgR/JD4nXdM6+BO/g2VY/
	EBrE=
X-Gm-Gg: ASbGncsw/RzFh8pdcpQMUIw5DDXYdsoY707pcJsw63ICvn9JWO3paZTfE2Kge5+BZ0V
	FKFPJu/1r/6Uvib/jVBlW9McjoBwdhhKPmPJ6hPwQGI7dI50BajtrXObKmJIUIAKNLU+qvDGhCp
	+ZGfE930agTwRO4QRvo0mBTpIp5pwA9QAaAy21qYDKKsF0Uaby4vHuYdVHDEg/qpXQYJcoKTQ1j
	25HilZMFpcFc8YTWDsB0qxi6Fi7AtEAJDpWxcSLACiR1X8DWFnfdeUtKlwcRfbl
X-Google-Smtp-Source: AGHT+IGZYAkOMvEL8MelgV6Xeu7o3AlbkP/lwHtkE2elo0pACurI3cxRhl7VprMICDBndNqUFWtCTg==
X-Received: by 2002:a05:6000:1846:b0:385:e374:bee with SMTP id ffacd0b85a97d-385fd3c9b4cmr2918870f8f.4.1733395726268;
        Thu, 05 Dec 2024 02:48:46 -0800 (PST)
Received: from localhost.localdomain ([114.254.73.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef4600d14fsm1081629a91.45.2024.12.05.02.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 02:48:45 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Cc: Heming Zhao <heming.zhao@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ocfs2: fix the space leak in LA when releasing LA
Date: Thu,  5 Dec 2024 18:48:33 +0800
Message-ID: <20241205104835.18223-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241205104835.18223-1-heming.zhao@suse.com>
References: <20241205104835.18223-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
introduced an issue, the ocfs2_sync_local_to_main() ignores the last
contiguous free bits, which causes an OCFS2 volume to lose the last free
clusters of LA window during the release routine.

Please note, because commit dfe6c5692fb5 ("ocfs2: fix the la space leak
when unmounting an ocfs2 volume") was reverted, this commit is a
replacement fix for commit dfe6c5692fb5.

Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/localalloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 5df34561c551..d1aa04a5af1b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -971,9 +971,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
-	       left) {
-		if (bit_off == start) {
+	while (1) {
+		bit_off = ocfs2_find_next_zero_bit(bitmap, left, start);
+		if ((bit_off < left) && (bit_off == start)) {
 			count++;
 			start++;
 			continue;
@@ -998,6 +998,8 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 			}
 		}
 
+		if (bit_off >= left)
+			break;
 		count = 1;
 		start = bit_off + 1;
 	}
-- 
2.43.0


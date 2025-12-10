Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0D126561E
	for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 01:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331473; cv=none; b=FKIbhOey88wJPt552FKqQ4pDrM9paSp0A+OWH35cVRLKaHWGT1GbgN8Jb9imhnWRpDWwLpeHkzqODkp1D3xfqdUTk7KjigoA1hDqkgWyDb9XiHSHp3zaMHYaHrmZXf665ncR48kvRbkrHrja3Mr+OtcvzRhha/H6QWBR29my+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331473; c=relaxed/simple;
	bh=rIjBSk8W9vHLkEVzp7rPU63DurUszuJ0brbQFnUC4kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO0SLexSljhlZICnLWteOEetOpmCrXcpbWgoR4YdIjNTaZf8BlbAAG6aeJK1RWtMyLEavG4d1nMJKGelelksvKofAQrU9i/KPsEdXa9MJY+d7qGNoRxiC2JKqTXam5xxnKQOBmviWBKKrr72GDR9+8sZ98hrfrLr5i7xsJlDzdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NhqufsEr; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NhqufsEr"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b2cff817aso578916f8f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 09 Dec 2025 17:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765331468; x=1765936268; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqN1NKbSsmoO7F1QrFMDpSGOC06IfLpd/c1+vjKbvBI=;
        b=NhqufsEr5eR31hG/1MAmAp4G9FKAevwq06JT3hsoStl3zXcYYoYdpXZ+c96F/nmoop
         z1j46NXSh8GA0LHmEAtDF2ZNEcXFXImVTrOzeeQKvkm+0bL/zdmBrL2I/Ntqhrttk3nc
         hhqfSy1wcHKowk3P7VBE0nBdKoflM1yx2HyBO8dsRmTgRF9M+f+yluQ4QWuQCwexHELh
         Lrnq3sw9JwbfCyXRO5eeSVwwUoH6FMbXeMJRaom7d8oh8RbauS92Pn9Y4laZ7+iFsNcI
         rM2DV6KOtDS63j+lPMVim20aDvnwVUBJQesTmp11B1h/7zy8wKqpdBZN9M5NNgpQmZA0
         05FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331468; x=1765936268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vqN1NKbSsmoO7F1QrFMDpSGOC06IfLpd/c1+vjKbvBI=;
        b=ACfNne/tfrqeb4/cAcGsuMIzxcAZIyT5G5eLt3D8IFW2TWvjxaIhpymL+rl7HeANEZ
         1SPYRwNjRLBBYBf4P6ibEBBuzcWL9OSavY78KPO7JYgTfGaIYIHw/7yMHLzVtjJ6in4C
         2sSq6SRaeDQrMoWiyFUh+yaU9GLzMcIgsjb/P00UldirGF1IdgjX4gbIJBzvJvV2Xlzg
         4709PVfFXaGqV972/dMdDevkS0rKOZaM5WBm0N7OIh0vORst7CpWzrqH3fFAhjTSQ9k6
         mtG3VJR/IUIcnMVDrD2PMX12pMM0dKDyAzvz1ARfGGRs2/QuLcU02uSdZDeUph2SEF59
         ap4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVdOvs5ubPm3eP6km/LX6hoLpiWHLGTYi2byWft5jd19Ma2foU3RDAJ+00iAncuLo+lYTYqjRo6rVSwxg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwkTr6uGo6cgWK9+ykdjrTKyCIF9YmyJv8jpRtlLKcipMeBQwmL
	1XyY2HIkmTZJBDrZP1BW0ICvYi8BTzUsCljcyXRkBYNH91rfW+nXbPn0ZPDaMP0kFAo=
X-Gm-Gg: ASbGncvgRNMsxPbhuhiKqAU9FoBgzYzlXCnhGN28bnb9JzRRL9KZoQ2+Fm6xP8sRzc6
	8bcmYjopaBu/OLDIX/8f3YB8Xx/LLU/XT3h8EL8XC7WEcAFG7/15wVsILRTm8aQ/nN5nxlB3/Az
	1/tH11ri4t0VZnL6IkpnFLlUI7CrSMwhS0SqnyG3Fq/eK6IHrZCNj8UtBVeOC/Z8WTyVlSUq3Ve
	6ZPDgKRpd6fU/NwyKzKEvdpPxN0k4V+LSzBcSIs5VWrCDF0rHGSdbsLjfHrLqSlLbCARjutcZ4n
	IVSmWWwDdUb+0x+B6A3BrUmiDbtcMeXskUxw4w6OBy2gespjPN5oYA8JuRDjEtMDipkvqTRJQ7d
	WBlPBD61HP/DuI7k5gqQo1z3EVS7PeS3o2RMmmpaEeWON5UZR9f6ZKoU8ZCB+7zqf3m+jzIFXn/
	JHg6PmLWx5kh9fsHLbfdMJyCbJ
X-Google-Smtp-Source: AGHT+IF3Hyj99KVYH7eKgsob3BQ45Jd/nJmyOnYqu0haD+sew52kZzas8xvaY4Ad9Sm9iGclBL4nXw==
X-Received: by 2002:a05:600c:1992:b0:45f:2c33:2731 with SMTP id 5b1f17b1804b1-47a83794790mr3584915e9.2.1765331468395;
        Tue, 09 Dec 2025 17:51:08 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf748c6bcacsm15706689a12.0.2025.12.09.17.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:51:07 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ocfs2: fix reflink preserve cleanup issue
Date: Wed, 10 Dec 2025 09:50:48 +0800
Message-ID: <20251210015058.8327-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251210015058.8327-1-heming.zhao@suse.com>
References: <20251210015058.8327-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by error")
doesn't handle all cases and the cleanup job for preserved xattr
entries still has bug:
- the 'last' pointer should be shifted by one unit after cleanup
  an array entry.
- current code logic doesn't cleanup the first entry when xh_count is 1.

Note, commit c06c303832ec is also a bug fix for 0fe9b66c65f3.

Fixes: 0fe9b66c65f3 ("ocfs2: Add preserve to reflink.")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/xattr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index dc1761e84814..31d023f9e2ed 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6364,6 +6364,10 @@ static int ocfs2_reflink_xattr_header(handle_t *handle,
 					(void *)last - (void *)xe);
 				memset(last, 0,
 				       sizeof(struct ocfs2_xattr_entry));
+				last = &new_xh->xh_entries[le16_to_cpu(new_xh->xh_count)] - 1;
+			} else {
+				memset(xe, 0, sizeof(struct ocfs2_xattr_entry));
+				last = NULL;
 			}
 
 			/*
-- 
2.43.0


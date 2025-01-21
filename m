Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2461F12FD
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jan 2025 11:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737458535; cv=none; b=izmJwZo845X8T5vUcKCc/5pTrS0iI7MGh/8uGuafcUM5dNqkz6i20OD88occ1IxH+4sVLJwYrTXxJxDxiuLqokEavLwCcSw0IE/VxeJXHB9o5bC8fbDKDLJLyh6CrNa37TGaidS0U3dXtVoZ9XMzI6td9r4KVNgTiKI0gNXeFNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737458535; c=relaxed/simple;
	bh=9DbZbqnyxkcJKuwsY5jXw5wmG03s0ufb3catY8T+SO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fsg62yCAEMXNxpjQzSOz9tpweCZw2MVCw4mOZgnyXGDXZltRn6EKAVE+SX/rESvdsEyngrml0uWCepmbthSYH7pt3khyalNj4PPKnQnsNwHR15sBB5Rc07G7G2OLB41LcSN5bowYqGndfqst6o6pvECjdqpQa8DjBurPAHFPFq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=evk9j+mP; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="evk9j+mP"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa6647a7556so81512466b.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jan 2025 03:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737458532; x=1738063332; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cBGCejyyGRZofPEXo0GzRmqQZ9v4Xi5rLOBAzs3B77k=;
        b=evk9j+mPdzNsCJbLmSyT+JGm8KihWcv8t4xlziT/MaLLOf47HK5OzHttCLbUBXDhQs
         0J31Pei5+jUAB9V5KrP6rAHinjD6wIx9pigPdKskqu8hM5/brYVl5oZdtbUOZwePebOD
         nnY7cLlzyzge0Ymg6HyMaRGhUqsUwguoXj/x3gbLW+cievfB0K0ElGvjxRKa7Kb4uLoC
         OeZjGOz1RRw9ZLu3W102h9x9DaphAKzy3d1YHHj0S79umIqM/r8qyOzWOgzgYHTTGkbz
         n7BKOl7uN0RnxTq92YFgcbGiOvYhexpf57dFe4+b+ziyQHcCs3XwM1Kd/jSMUFftqPFE
         pcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737458532; x=1738063332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cBGCejyyGRZofPEXo0GzRmqQZ9v4Xi5rLOBAzs3B77k=;
        b=QFxcKwdtnSwMLDI4x2cQOYJBQ/ZsQANaL+MviYlnhvVO3FPMYAIgidAVPGV2Ne624p
         UtuFhxtxYNtEsRXDkJ43DxDIY81BeoiyMWwxSW4mq+E2+7zBsgpdS/p0Jl+Wr7GGc1LB
         egJG8munba0FA8yUPpHCZXKdewG6LX/At3rqjQeGFmDV5xN8kEffXzPckMSZXqfgbnPL
         +aKsv8H0HQSqTc8U2dc7cmYKOb7nfF+zDqoJTtSVqQaW49mV7GsKms9AD4Pqj/Rb2vMz
         S2aNBCqC1L53XGHpflTwij+xKXDsj/7e1+mkWC0jrOWKY3r7zbEE70X6SoQVAJBGrodU
         zamg==
X-Forwarded-Encrypted: i=1; AJvYcCVlZj1gjj6F20FZPqwEcDjZtvV/yRAIFkIIeC8rLH03ol/ZDMQqXG3B8jF5zX2S3QRLxCja6k+Df+FzVQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMhRBHv6Jo1M7GGl1ifcOhd5KZt+TwNu1/E06vJWQRGNd9NfQm
	FmrerGv/+H3VhluRWAUINogQXAdQSxRCEYGtgrHjvI1pgw4b2qvC49luBtyKNe4=
X-Gm-Gg: ASbGnct5Tz/9P1Fe5bW5QdalT7sce6V8PZ63MFvMa8Q+oykZIDhvL7Ggj+j9sMbexJn
	7rHZ73aAWNkV29TSR6zOFGbCldRVvGoXYJXP+6UoCaFFxz+FiqGy/onay2WRcGFOq/3a4tkkITn
	d0E19vyhglQ9qXxOd6wsBDsmOeop2Bu/UmoXRDIjmr3PxzcHPcTNjdSsesG14VCrFCAQaXXNmk5
	ZvluR87YBj29E8AOk/iFApww1EPw1oc6ZGjdmoJG5yFLWx2X2L60wAKAfAwa+tNo8lYAwBClM9h
	LCD+pjLv
X-Google-Smtp-Source: AGHT+IGLwTAv5U1MMduS4C/su64NdVIk3C/9u5AE7dcHcadMDWlbORhBGQtX1XfJMUxiDD6/JZitDg==
X-Received: by 2002:a17:907:86a3:b0:aac:619:6411 with SMTP id a640c23a62f3a-ab38b4e1a7amr657600666b.11.1737458530466;
        Tue, 21 Jan 2025 03:22:10 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c15bf82sm12701665a91.7.2025.01.21.03.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 03:22:09 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Fix incorrect CPU endianness conversion causing mount failure
Date: Tue, 21 Jan 2025 19:22:03 +0800
Message-ID: <20250121112204.12834-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
introduced a regression bug. The blksz_bits value is already converted
to CPU endian in the previous code; therefore, the code shouldn't use
le32_to_cpu() anymore.

Fixes: 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c79b4291777f..1e87554f6f41 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2340,7 +2340,7 @@ static int ocfs2_verify_volume(struct ocfs2_dinode *di,
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size bits: found %u, should be 9, 10, 11, or 12\n",
 			     blksz_bits);
-		} else if ((1 << le32_to_cpu(blksz_bits)) != blksz) {
+		} else if ((1 << blksz_bits) != blksz) {
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size: found %u, should be %u\n", 1 << blksz_bits, blksz);
 		} else if (le16_to_cpu(di->id2.i_super.s_major_rev_level) !=
-- 
2.43.0


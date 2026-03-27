Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40463BED61
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Mar 2026 06:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774593411; cv=none; b=VgUP+dSZGZvBZPpEUj484lMdGE+dxaI+ZWBEXyqMswi+gDlmJXzqttJjyLPxELM8/XorWC45TxE7aVAyqMR9piVEN7+MzJznCLCUTo3FORU+XQVGDCUo6F/jM0ufIFq5IfwnIbxuvyvA+rPjYTqHuSCWUjrx72ffEfTp1PkXwoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774593411; c=relaxed/simple;
	bh=jGmECUGT8ycRcHymLinad/wDpREVFjw+XOr7sjQP4ws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l/efPg7HCKFpFo8GgcJu15E8r8SuzzGmXVhyYlTj1mMRqRYi5CmgMfSNAtTzzP9hJRBLORrvtQGJE6FcjM/FIKQDQ0RKKhmIskjvW57Fhe2pxyE8pSP782vWFsDELMLTMXLYsIcYv0Oe9JXxKiNEvXpeBeS/9Ao/cYPfejVO0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PunqKkbX; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PunqKkbX"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4853a5ffc05so3451235e9.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 23:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774593399; x=1775198199; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XvWZO7Rqmp4NGtdct8NrCQLHEWLa6GISAJp97Z36OVs=;
        b=PunqKkbX10zU8SH4t4AwIrYzZX39HHwFT1Upzsrg9YW+bO34Hn73m2x9ZbjQXmI6I9
         4tG3bCnzreZZ/j75N0qQqEbNgz9kyZfxZExQwP6lj6vsgqe/ULMEfxOQnAHHxl6QuDLg
         FnG0tjh4WMvyl0yCOqs5UVbp921Z0UZBD6UJPFX4XJn1a3AE1oudnzGpkvosK0c8SfVh
         UXQ5ibygq5DYOAOgXE8CUD+PSPHlA8FXy5+oPGrmYKHnSJv3bwGx/1emw5cKILLnGYp4
         7VWSUzVHPgU8NN0IXPS/j53A1XQwJuMfx3W+XUZans9iO+Janw4NuQKSm48Z+W5FRPIf
         gJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774593399; x=1775198199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvWZO7Rqmp4NGtdct8NrCQLHEWLa6GISAJp97Z36OVs=;
        b=G5dGMvkn8OfPXZsNCmgOb6tMOFBUjN8xBCy+6ZVMrs1ZaFmL8HXts6rfh42tnjIrg/
         0hOeppQrAjJ3l9mCWKzqyoEXljE2HlmgaXZ4SdzzXNVMpLe4vEyCzpalYpDDiQO7tyfX
         faYZhlYky2y8qAzbnTru7ncI0zfPaTacQP1CoCj25oB7ZQhvLK9bWi/ecE7KmyycqnFH
         fHC88wI0P1ZL0lhfGcxsOPIVO1dEBN08kgS/E64yzpIJVVwVUlM5540gz9AMbD7NyN11
         MnJo5Q8KLVBrynY6i8w65YcZYdMvcKOkIKfB0bsoIbRC2cA3R14D5itBwWd5jSlp+bdA
         qT1A==
X-Forwarded-Encrypted: i=1; AJvYcCXyOAqHshThAteK0kxTkde8LSuYhhi5RKbIlfAhtx/srZArOHR4a5qAngl0tk9fr9gPE3PRAcgBZvYFbw==@lists.linux.dev
X-Gm-Message-State: AOJu0YycckYNHIyFFZncfQPHWJeuogm2rHqTpYWSlofzLPxaTTzbVCVB
	Hw9GmpCoD+gP0pFB1/Juml5u7Dzh6oZb07b1nhDeIC6O4Vn1gAWHC6u/sxUDLvMFDLI=
X-Gm-Gg: ATEYQzzCPENhRYPFEEy+RYlQ0b3JT0q9GUWG78QalqgbEYKqp8asX5rdSahpPnnRvob
	AzW8Kwgs+85ShLimX9U+rWhUU9jG/iPSaCFg6VwMxozjVB/npiQ5KCth3MCbyZ/7AHI0TY6XJSB
	w0pBKByT3LSeurjTL4RHktVtZFEM4D1d154YuvjKQSE3Eu6MeLJgfmmRfINY6dCzkra3eISlYn9
	1uNjifTycjDz5qVfuUHpFtpc4wfQv38A8Ul1xw7NPLJ3LUsXYf3SoAeHDDt9DmUEX6lLaX4HKqV
	okSok03p3YYmWtUSax732XDJPaOEk1fg/0byguSpDZ6TRVTpW8bXjt/4CrXd40oTNCL/8jRZklK
	tUO7foXXF/Kx399K8bOi6/9xrzyqvtd7t5eGyfFbNLBkx38uNkwJBmDM1/I2Wdzl0JFv+Ckdcu4
	BTdrEN/TSnzss42VMmaplhZmH1LUIX5pD3vlFh
X-Received: by 2002:a05:600c:4746:b0:471:ab1:18f5 with SMTP id 5b1f17b1804b1-48727f0728bmr9605555e9.7.1774593398738;
        Thu, 26 Mar 2026 23:36:38 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76739311d1sm3849190a12.15.2026.03.26.23.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 23:36:37 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	jack@suse.cz
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	glass.su@suse.com
Subject: [PATCH v5 0/1] ocfs2: split transactions in dio completion to avoid credit exhaustion
Date: Fri, 27 Mar 2026 14:36:24 +0800
Message-ID: <20260327063626.10225-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For easier merging, this patch is based on Joseph's patch [1].

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
real    1m49.489s
user    0m0.358s
sys     0m22.869s

[1]:
https://lore.kernel.org/ocfs2-devel/46yilbaq5z5x6gdfdpoa6lprf6sf3gbxriuku2odje4kx4bovf@jd735cphfutz/T/#t 
[2]:
https://lore.kernel.org/ocfs2-devel/75f89a17-213b-42a0-a30e-d52fb2d077a6@linux.alibaba.com/T/#mbe2b5f52ee249178e1ad4c76d964de2dc818eb32

Heming Zhao (1):
  ocfs2: split transactions in dio completion to avoid credit exhaustion

 fs/ocfs2/aops.c | 63 +++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

-- 
2.43.0


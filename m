Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AB6433CB
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172423; cv=none; b=IaWZdCDbbm3TkOf4cohrEL7RAkHg5nh0fcvY6xAuWoCzkKtURhk4bMJKJlc5ByYWZtuEScrRLYRqoD7cuCmptlkpteHDzxbD/NkOfG6MkKgjI5Eg3jfeqZePsROyXCMuHJhUrlF7gGYrZ7NcMtGxVaCuUmM4YltDnuEeZBch3fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172423; c=relaxed/simple;
	bh=4ZX0QI5PpJjmX41Ge1F+r4VpT9dZPAqSsC44fKYZ0LQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V4is1dfwWHVdH41/h/hRq1P0m+TDzUUOEzstBk9TZi7suSOlksRWEmrZdHGR7ywsYLcSjAkdm0nU7frS2Sfvnz6gYj3oQNzeLH3+t5/bklIkbra9MnEKKIrTwT42/uURDIrSxlbzEed9ivTtjPK+U7X1/Tp2xo/4tar9DdmY7RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AjjNo0md; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AjjNo0md"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaee0b309adso1721550966b.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 06:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736172419; x=1736777219; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LSNIgwcoqD1uX1A6woT5vmvpKh/AvW6vSCiT5Yyv61Y=;
        b=AjjNo0mdAsKLZTsLUVjdLh/dmptIq49q4Ziyykabz2Ghs2cRctHJinC9Pes8ju5tt+
         oaDTztrKT3p/nkKahaRNcjGGn28k9zm54wyJMgboLsQZ5OOGKBWXVI8fEo6yn9UBSyjN
         z9NybQYTZQZ7cBbmoM/4OgTOn0E1Ln+BNk4oTYFynYYq9BUBxNJ46rkyfurWpvD01TLi
         gqTmEwzo/Yn2qiNRQJe50P5eyWYWt8g3e7uKLu8Ksq26koJbtZlETmHWsrBUZ/B0lNJg
         5f9TxoX/JCS5ycaosZl+YJaWt53604wp0dZErNw+Ks9agqcTRBJmDYtPIm44XyUPlssq
         GJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736172419; x=1736777219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSNIgwcoqD1uX1A6woT5vmvpKh/AvW6vSCiT5Yyv61Y=;
        b=wo5PO/s2EupmjUvUqDa7xd2KQDbcBM9v0kgz07/RpM59dRuRAIPr4k12MtcY6NZUHu
         rLlwS9dnh9LfRgNcMtUIBoWsf4OF/+0pg4HB7bDzTYgKmomPUxBTkAgMOIfTiZ4fHQrM
         d2FAOZyk0hSmauNTjFN8XcGKqD32SnDekzpvIQIT/tCLx5PKc3ABH3GCuDiBTfLGVd0w
         mkTASUKGhv2aDUQrcPtc/+iMZbI0wRo7I2oFLFY4Bxkvh3DT/32PVAPn6EjY3IRVz0fx
         XsV6bVadG7yzOFTjL5NSRn7/d/xchyQL0nbwjFtHaGkRF9++K16dQ0+VuXXgePkGLJGH
         g9sA==
X-Gm-Message-State: AOJu0Yyug/kENMsY4dJ1Mn8eef3wTkVcOpw4mQRuCr23ppscBiMEmxeP
	/OMzxR8XDyKGpNuXHTZ4ZMM1uafAQsK8giTSJxQmw7IYa2jWzsUr2bA9WpZKUQusSjWUas7CBDn
	+SU8=
X-Gm-Gg: ASbGncuGm0lEaTFUGGr06XeCYwz1Pv2wS/MmSgHkpj0ROyfHHJoYNVuVjnqToa4ysJJ
	mr9JEkEKe6/VLIJaYgQ2QN/jATuYfBraDLsLcg5VjgVqyQwfYTZHBatx6TZZyX6dU0dVVLHMG7P
	3+PM/k3Y4SThh+wKXuVR+cC/qnMRjnmgEV/6KrtZhgRYpZoDseNMQEzthqh2W9RDYBghNF9Z3Oe
	6Njdw4Zj/Ww2METrlm9QIVf0yrd+RWA4O+ET9HUuSugSC8LSou02c8F
X-Google-Smtp-Source: AGHT+IEfrbk1rnAE7VaKWMlSG3DO7KLf/oX2kILWMkWGnQX6vOmdwfkXw/judOa2MEehlfY/+2yqSA==
X-Received: by 2002:a17:907:3e21:b0:aac:180e:b1d4 with SMTP id a640c23a62f3a-aac2d41d2e2mr4644717066b.27.1736172419287;
        Mon, 06 Jan 2025 06:06:59 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f4478a9108sm37496672a91.43.2025.01.06.06.06.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 06:06:58 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
Date: Mon,  6 Jan 2025 22:06:53 +0800
Message-Id: <20250106140653.92292-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While running fstests generic/329, the kernel workqueue
quota_release_workfn is dead looping in calling ocfs2_release_dquot().
The ocfs2 state is already readonly but ocfs2_release_dquot wants to
start a transaction but fails and returns.

=====================================================================
[ 2918.123602 ][  T275 ] On-disk corruption discovered. Please run
fsck.ocfs2 once the filesystem is unmounted.
[ 2918.124034 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:765
ERROR: status = -30
[ 2918.124452 ][  T275 ] (kworker/u135:1,275,11):ocfs2_release_dquot:795
ERROR: status = -30
[ 2918.124883 ][  T275 ] (kworker/u135:1,275,11):ocfs2_start_trans:357
ERROR: status = -30
[ 2918.125276 ][  T275 ] OCFS2: abort (device dm-0): ocfs2_start_trans:
Detected aborted journal
[ 2918.125710 ][  T275 ] On-disk corruption discovered. Please run
fsck.ocfs2 once the filesystem is unmounted.
=====================================================================

The function, ocfs2_release_dquot is much like dquot_release(), which is
called by ext4 to handle similar situation. So here fix it by marking
the dquot as inactive like what dquot_release() does.

Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/quota_global.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 2b0daced98eb..2c42966cea20 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -761,6 +761,11 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 	handle = ocfs2_start_trans(osb,
 		ocfs2_calc_qdel_credits(dquot->dq_sb, dquot->dq_id.type));
 	if (IS_ERR(handle)) {
+		/*
+		 * Mark dquot as inactive to avoid endless cycle in
+		 * quota_release_workfn().
+		 */
+		clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 		status = PTR_ERR(handle);
 		mlog_errno(status);
 		goto out_ilock;
-- 
2.47.1


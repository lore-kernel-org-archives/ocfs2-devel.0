Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691C61C695
	for <ocfs2-devel@lists.linux.dev>; Sat, 27 Dec 2025 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766857385; cv=none; b=C+mRX2wX97s3TpLCx9WC7B7V4lEBR9HpnQj5WRnRKuInHEF20yV+IRruOUXf6KPKxaSkUlDdEeHPSdDCN0QffGoqMz+J7NF3Hv+dkS7MFeSWkr964lGn1dVSpYui2/Vbza3EirXKzMdnHWjK1l7RWOG21BPYSB7TVClboSb4oAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766857385; c=relaxed/simple;
	bh=arJLIS3xL8O652kOhXAYNqd+jf5P514t+/AfZWo/zI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UikXqj4mEbaEZL1dEAVYHOXDMgD/LOcF6GyXutwHYyVvrSAjJYtP0x3dF17/75ORPDXOrAfT2skH2K6snSOVEfy8J7l0ycW036XYeQ0jYgsCiNWnipOMYw9yWrLODJh2zx0UC7D/feN7yZ9NmzyJOTXQW+R+bXuKmR54ffnFtss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jUTmzrHm; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUTmzrHm"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7cee045187so1420869566b.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 27 Dec 2025 09:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766857382; x=1767462182; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gSXaQ7IXj6RkdeOQrehfTxLs8tTRmxKEotG2v3wprbU=;
        b=jUTmzrHmaRv4jKl0eqT2Wcb7vLOxPRf8r1ahKj1QnpvcbbNTT8WxKufWcmrpdDoFSd
         WZrz9/S71A2XLkVpVHLz75ooDS+VwfF016IGP2GHvQ0PCyk2LpmLioKE8IZHUIX9+xyI
         SqBQPxMAcQ4MbCVW/vrUl8uqL1k4nOX+ZdlGZScLUEjVt+AuL/2Qg0IAdK+BjUKhaHHA
         DkZWtVnKmos4mLY5mXOF9mIMbR+wPvOrWTNGnr6HEAXQQUEBAFYTzfqrRIJKOQQwRFsb
         BjMUwRT8g3Rh/r9kxZY5/9qmKsCze0i+HoNiq7m7v75D/pjgjclp72cxdp2HV4j8iM+t
         RBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766857382; x=1767462182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSXaQ7IXj6RkdeOQrehfTxLs8tTRmxKEotG2v3wprbU=;
        b=tb3SqKnAal92zWPfW2x1pfG8qRp9EuEnwPY4H91pEFUYXW1BFInR6+OCB9cpSOjUEL
         RJGQtAgXkuwZaBx2eLA1PEdERIsnWj/5M5DwD+QpRFJQ2tnjQ1yY46GSlc7/REwR2+2F
         cEsqNcsIJSWEER4Nibnv5qRzhPYnH6EnN969dknMCIh5FqwSaunvuSXzFHnRU2m5PDwP
         ftnQ25VCKYD1I7vAGBkJage/xRQc9WRtZzO/7vKYulWAmT6WLZKwEpCZfNJpTO3LKVJv
         qSENYmEVGtkUg8nZafsOQg+85sE9G0t5bnw4LipGbOiD7vfa80LiY+Eekar+ok25Brfd
         okww==
X-Gm-Message-State: AOJu0YwudvqBarckcW+MT5cBVe62aOmALkWDl7PU3dwOoujmStsiBr+D
	+AzDr4mJ8mtm8Bhohgym6vvESxfbPBMXI8HRlQYHLZyYRwqfG/gwwW9dz2JQEQ==
X-Gm-Gg: AY/fxX4pjhUcSGS1OxDvWjh3QfqlJAUNfOTyglV0BSj1jaljSAvTsf0ARMVn6Eedw/e
	vHaDz3t5Mycld3Hgm2gVXNYoSVTNc5PcLVF8NXBK4ihM+tmTIumynFE8k9kQCyFtaIk6nl1bFvm
	6RD9+is7jJD5ouo/PjltQhNjOfNCN6V3QyeaN4yb1hbDKAC116DOqXGvnWlVH/1hcGdmqsQScti
	jaltJdaoykzNb7GxWq6Ey4I3xcBZ2ZzTQoheFqwnW8SsTfxMUIK49eZwTQcM6jCeJqpynN5SWyL
	pFQQu25P3urT5Q3NGWx4b7Fd8g1yF4T7R/EYgWAYGWIThP0IcoTHKwNNLV8MOiKkL8skuK4SR25
	TJTlFTFV6m6qZStiMWrPg2O5xWAaUbz2NRmyn+3dSGTtY25D04lILttAR0N2Tkd79DsiWFBawtc
	TECTg4ly2PslF9sg==
X-Google-Smtp-Source: AGHT+IF9toMKfHOr5wvZo5TAl984T9l70FGL4tb7U3M3rSJRyuQpV3XTy3AUnKWavM5kb4L5ZeIGlg==
X-Received: by 2002:a17:907:1b0f:b0:b3f:f6d:1d9e with SMTP id a640c23a62f3a-b80203fd532mr3359548766b.6.1766857381662;
        Sat, 27 Dec 2025 09:43:01 -0800 (PST)
Received: from prometheus ([85.11.110.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f4ef1fsm2804535566b.64.2025.12.27.09.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Dec 2025 09:43:01 -0800 (PST)
From: Szymon Wilczek <swilczek.lx@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
Date: Sat, 27 Dec 2025 18:42:51 +0100
Message-ID: <20251227174251.121668-1-swilczek.lx@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move ocfs2_extend_no_holes() to execute before ocfs2_lock_global_qf() to
fix a circular locking dependency reported by syzbot.

The issue occurs because ocfs2_extend_no_holes() internally calls
ocfs2_extend_allocation() which starts a transaction (acquiring
sb_start_intwrite). When called while holding the global quota file
lock, this conflicts with mount-time operations that acquire
sb_internal first, creating the following circular dependency:

  sb_internal -> ocfs2_sysfile_lock_key -> ocfs2_quota_ip_alloc_sem_key

By moving the quota file extension before acquiring the global quota
file lock, we ensure that any internal transactions complete before
quota locks are held, breaking the circular dependency.

Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Tested-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=51244a05705883616c95
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
---
 fs/ocfs2/quota_global.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index e85b1ccf81be..136aaaae27f3 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -821,6 +821,19 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	trace_ocfs2_acquire_dquot(from_kqid(&init_user_ns, dquot->dq_id),
 				  type);
 	mutex_lock(&dquot->dq_lock);
+	/*
+	 * Extend global quota file before acquiring global qf lock to avoid
+	 * lock inversion with sb_internal (via ocfs2_start_trans).
+	 */
+	if (need_alloc) {
+		WARN_ON(journal_current_handle());
+		status = ocfs2_extend_no_holes(gqinode, NULL,
+			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
+			i_size_read(gqinode));
+		if (status < 0)
+			goto out;
+	}
+
 	/*
 	 * We need an exclusive lock, because we're going to update use count
 	 * and instantiate possibly new dquot structure
@@ -843,19 +856,8 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
 	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
-	if (!dquot->dq_off) {	/* No real quota entry? */
+	if (!dquot->dq_off)	/* No real quota entry? */
 		ex = 1;
-		/*
-		 * Add blocks to quota file before we start a transaction since
-		 * locking allocators ranks above a transaction start
-		 */
-		WARN_ON(journal_current_handle());
-		status = ocfs2_extend_no_holes(gqinode, NULL,
-			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
-			i_size_read(gqinode));
-		if (status < 0)
-			goto out_dq;
-	}
 
 	handle = ocfs2_start_trans(osb,
 				   ocfs2_calc_global_qinit_credits(sb, type));
-- 
2.52.0


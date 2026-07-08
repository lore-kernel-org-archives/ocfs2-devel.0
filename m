Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9ED420876
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Jul 2026 06:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783491873; cv=none; b=K0U1GVVcTDC2vKBP9TKPI0AjXVJSrSiU7PNBrcsO1PbYRCDaR51+Nr+t73g/Du3t29Bb6wCzkmJK61AKrr7T4h/r6cCA+fkNLTleJMOmMEAskK6qpfQ9ylLD1yuOgeKCcg7EQlEUq7ZVS8Wxwt9dWL1dJaqYULXcumWUDhQj77g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783491873; c=relaxed/simple;
	bh=54HNHqmD1Kb/0MVV+fdyoDqHbuWGNtH2NcaMF+dhMyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u3o5qwbN+107lEhorllydyk+epXizCwoGtain52wbZ053R3/HKyBJjny27EssH6GLbtSaQFvqeOpntOK8O143buv36mPj7r6J2l3/TtkbLqxfBEO6bKnQznKhgDY5nCWaYdWXGFnxNIVclgt5dBjvtdq4XfPZZy9N1pqdPRYvLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V38Mfrxo; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V38Mfrxo"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-381891a9525so414013a91.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Jul 2026 23:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783491872; x=1784096672; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4qpikAqS5swMVwJB88wGEHNfN7682of6SZQWYwiU0nY=;
        b=V38MfrxorEW4q4O4cTlX37ZmnAkAOcDncNx8Wq21PdhlgCJkGTaehU4AjpY9QMJgQs
         G8iGUOMMEViPtmkIleoU+p+O11mgvjXST3BYrIeZx4R/nk/rqcui7omfviPd71L4JPm3
         Ty3PV31N2OFsLdnaiIR9VN2luJ61yR7ls2gbQZdP+lAiDqEOmcJQZZwqrlBHsPQe9IG+
         SyMSbbr8hwTSeKypVdLWX9SuO2aYl+lqOpBoYEL+IZVemwxtWNW2GqFsmy+hkTff5e43
         YTK2tZ6LhOZ/5N4pgtJaK9OabfVFrJkanNGZARXdvtCyRcYDR0L0ruxHZ8pI85HUpBwt
         JUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783491872; x=1784096672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qpikAqS5swMVwJB88wGEHNfN7682of6SZQWYwiU0nY=;
        b=BMBt1zVwxXuHInh4U3YSLSG5aOV+vJofUQuHdFeUS5el3VQp/9AOvl7asSKUSK1kg5
         Yv4SAFjTsMUxzK+U+9hee4hdTOxnzyXeL1gk0sQ2WywZ4BHnDOaXT0IQUSlqEd0mHCB0
         7vahne5V5Ybuew8n3gLplsa2t1c1g8VFC6NS4lGt0lawD7z2Ik9N+rA08FJTmvc8sNAp
         3Amtk9b9S3+UD9zOzfiy3lpdd18mYY7qQHmuIUa7/lLm/wVXqGuZJBGYQ3WdRDTZAITr
         KvatqLfhqEGiimXH4M45/FZ62L1H2t4zFZO6Qbp4nL3jRpNBBlAjr8zPWIHHUkv/VXSl
         bDKQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBzh0ndt4+cTbjOrKTjSmzRNIR1t0d4bACouOOwXGbznqtv9+RpVJXwqWEbSA6iS3is7Yv3SuVGPqrPw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzsotKZ44KbfqZakRXvdlCEgur/bRi2coFpBSnkv0dFYgSOWZNh
	iPccz6MAREEmgoQjx5ypf7dKuBfLk8IAajhzx3Ws7Htl3FWEvTOt0D7b
X-Gm-Gg: AfdE7clD3db2cxaaheyfrU7juEgd7tr6cGJCcMCsxiXQWF3dz7Ptg5Ydufmmp2J4keR
	Kzy1l9DDb4Sfs5VCNkdtpC+RZCHB7MrjeYL2mz3b3u5C3w9l0bDNc6HQV15rtfRBuJjSwvk58d6
	50i7pQJRx0zURK/tI3oLdDsPw84QPqK434sKIwj36/RcHoH2XEp6fHWU04nnSNEtBl0P/BODHS6
	BkCMgd3HheEAPsBDsMNl3eJbHXmZbd5X4QijPBU7rXFBmGqHQY/7X2jaY6mj0h4LvqV6sTv9vx+
	A4cb/+p/UeMyQPDh8c02lXfASnBZH0dB3zovLeG7FA5gQgtwKF3bcy+23I8AJBiZgh4xPRj59ug
	gXhzmuoF7tj0bCAU4yMPBecrPZhVosZu39Vpb5winE89sttlYpJCSAEolszyjzScCBBzvjYAu7s
	4xnpudZA==
X-Received: by 2002:a17:90b:384f:b0:37e:1c8f:3dff with SMTP id 98e67ed59e1d1-3893fb746dfmr1277792a91.11.1783491871880;
        Tue, 07 Jul 2026 23:24:31 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d20a361asm2181987a91.15.2026.07.07.23.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 23:24:31 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Tristan Ye <tristan.ye@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] ocfs2: free claimed clusters when defrag move fails
Date: Wed,  8 Jul 2026 14:22:12 +0800
Message-ID: <20260708062212.715437-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_defrag_extent() claims new clusters before calling
__ocfs2_move_extent(). If __ocfs2_move_extent() fails, the newly claimed
clusters have not been attached to the inode extent tree, but the error
path only logs the error and continues.

The following ocfs2_cow_sync_writeback() call can then overwrite the
original error with 0, while the claimed clusters are left allocated and
unreferenced.

Set need_free and leave through out_commit when __ocfs2_move_extent()
fails, so the claimed clusters are released and the original error is
returned to the caller.

Fixes: 202ee5facb2c ("Ocfs2/move_extents: defrag a range of extent.")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/ocfs2/move_extents.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index ad1678ee7cc4..4f1745d58a88 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -310,8 +310,11 @@ static int ocfs2_defrag_extent(struct ocfs2_move_extents_context *context,
 
 	ret = __ocfs2_move_extent(handle, context, cpos, new_len, phys_cpos,
 				  new_phys_cpos, ext_flags);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		need_free = 1;
+		goto out_commit;
+	}
 
 	if (partial && (new_len != *len))
 		*len = new_len;
-- 
2.43.0


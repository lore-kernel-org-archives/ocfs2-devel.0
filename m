Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D012E39FCE
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172403; cv=none; b=kFYat21pJdKXecA5LjEj1Sey7KxivxhG4Zbfvt0bam+ECbEvH0NMhnL7FyOSgtuONQ5XsfwV3MPuNHzwRzTX80SQVzPPI4oaGSWO3SmIOF4MOXmxpkz8zUSw92b3aYfa+qf/8XHAwXfCLsJ2yQOHGG0aOsU4FG5Dt8DOPEqk8Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172403; c=relaxed/simple;
	bh=EFfFOzewXvTX0SPyxnHE5SEQLL64IdmSNKcxKSDm1RY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MZmlCtpvPTK9f8wJ5waX7jnYuzER3VB4j5QP/WssRGaN4kOEQbPH3qfEXBf/8CuLmXW+y4F5wUxMyWywglOvtwCfOCbpS+AKFGgcuwQNH6ojP2FfCJtpEGHCD7G2ztZON4Ct6SA2yZSwhEN3U1iU6yrpC0SF9PuCYL9R5Hixe5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HkwCvdDF; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HkwCvdDF"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso30330692a12.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 06:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736172400; x=1736777200; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jXhVd3N8lJGtRPNx9eceLvvAWN3JZjCLxpVSt5wZ/Kk=;
        b=HkwCvdDFL4lXJx8k6mkQZfrVDh3inh22IglsBuMJ7UJDGvQU0RPDk6U/UUd1cbPK3a
         qvVGbC9rsgODpOPv1IF3hf1Lyh8nlNlIyXADnjB5W1gCf8Kefd1cZgHZfk7jfB5TYuhW
         EDtH1MKA6UnV23McJ7sRVGkjwHBosI3syhgKMfG91n38ZUfQO/F+BnWSvZAXjJt9C7+e
         1Vvlrt3J+65P65mJFvS0LdoguvJzbVAw6B5u1Hv4SDrnDEGXWu7SHzouTyKVoi4cCtJw
         xPvbE7vjbXvXvEXdj2Z4sP8deTVAh0NWbSF1nnMHDMee3c7lCrUvnW8PN9tRf9L7Mz9n
         WqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736172400; x=1736777200;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXhVd3N8lJGtRPNx9eceLvvAWN3JZjCLxpVSt5wZ/Kk=;
        b=REwgymHUsoBeZkQnmgTIpESJ/CJGSCSLcy15W4Tm3P3Fecf/WlSCMBm4RqakZ53LGM
         A7ek3x1qGZy4uBE0jnH9abqY0n652dQ2/Y9Hg+JWd0pdqlaNlybMvVbMNtxMNPpHSK2F
         feqSxp4NuVuGJ257tdoyt1B5UaE8M5fDPR0u4iAutE+tMJ9MKhk/kTJP4/NmTxeSgFIg
         0JjxPn6cOTp6X+2/QSnr07/IN6T9cALaD7zuboUmjfIksIapIvWhMNsgTlCOIF1Blq+2
         hC2tG+ZPq/glGh51eXj38Q80ZZ35yzi+pAmrB0z8jG+aCeueqWtyn49V+YKxsJ6HWQEq
         NXug==
X-Gm-Message-State: AOJu0Yzk2prO0eV+O/TPGk5IKlrOJc1vwj6Q6zUPsyeyAiKYXiR9meFU
	6ZneAOdQtbb2XRRAxOWDxfc4eRLSTI49iEuxSeF1jvOLw0sgZ7cyu1LtQbvllPPdsur1QiTjkjt
	iEA4=
X-Gm-Gg: ASbGnctVCYBGeeW7YN7ceH46aLnlyErvtAvJXUkUs1DOFLiSvaLgE6CQHjI73yAk6YI
	o8vWU9pmKAJje3ndivQq/SJIgdlWZR5bZiNB5wRho/hTz0ngyYxID+drMnun5TsRHEFj1e9UEnF
	RkZGa3HHIOlzDzq3PlKBgJS/tj845ajBuFAFWiaWOxJDp4p77T8zAXWWb4G+4GXd4jwWnoUGiIp
	dfRTJtEJ8VCCrOsq37G00GFrrPtPMcXdUEzz4uI4Cju0xPuIxp3mHNr
X-Google-Smtp-Source: AGHT+IE4KYBcqb3S1qhutl9O04fJRBUiNhMmQs5JgM5WQ9oezmPX8rQfaUS0p4j/DHzUYVALmfOcbA==
X-Received: by 2002:a17:907:2da1:b0:aa6:a8da:7ba3 with SMTP id a640c23a62f3a-aac2c005b85mr5640740466b.27.1736172399967;
        Mon, 06 Jan 2025 06:06:39 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9704dbsm293694525ad.98.2025.01.06.06.06.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 06:06:39 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] ocfs2: remove parameter parent_fe_bh from __ocfs2_mknod_locked
Date: Mon,  6 Jan 2025 22:06:34 +0800
Message-Id: <20250106140634.92241-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The parameter is not used in __ocfs2_mknod_locked(). So remove
it.

No functional change.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/namei.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 5550f8afa438..0ec63a1a94b8 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -508,7 +508,6 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 				struct inode *inode,
 				dev_t dev,
 				struct buffer_head **new_fe_bh,
-				struct buffer_head *parent_fe_bh,
 				handle_t *handle,
 				struct ocfs2_alloc_context *inode_ac,
 				u64 fe_blkno, u64 suballoc_loc, u16 suballoc_bit)
@@ -641,8 +640,8 @@ static int ocfs2_mknod_locked(struct ocfs2_super *osb,
 	}
 
 	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
-				    parent_fe_bh, handle, inode_ac,
-				    fe_blkno, suballoc_loc, suballoc_bit);
+				    handle, inode_ac, fe_blkno,
+				    suballoc_loc, suballoc_bit);
 }
 
 static int ocfs2_mkdir(struct mnt_idmap *idmap,
@@ -2576,7 +2575,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	clear_nlink(inode);
 	/* do the real work now. */
 	status = __ocfs2_mknod_locked(dir, inode,
-				      0, &new_di_bh, parent_di_bh, handle,
+				      0, &new_di_bh, handle,
 				      inode_ac, di_blkno, suballoc_loc,
 				      suballoc_bit);
 	if (status < 0) {
-- 
2.47.1


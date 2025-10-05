Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28A535971
	for <ocfs2-devel@lists.linux.dev>; Sun,  5 Oct 2025 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759677254; cv=none; b=NeVlQVqp86C50h1Rb4VXYjDauArJnheo8TXSKek89FhcJsxGpeYWUBKMBeSnikbCg6nASMyyE0V2CjVHFKrLNo0i7PF5ySRqoER4UGkGiDvPrmupPEOOy8FhEBbKc9QoG0mVT5wzjaiPlrTC+4xV+zUHlnl2w+G8Hd/nb1qZp/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759677254; c=relaxed/simple;
	bh=8TnJB3YQxRebJGGTR6fB5k3Fr5QTJA2vinNsLRimdFY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BY3CL/XLLudw4JyZX6MliTgQ5tKNhRUGTip6MKnCyFRaW7teElMsHVCpIna1eR4mqLy1Ywt8pGXBCoK99z2N0mkckxGgQ6iiNNec7+Zu81Gmzj8ZMCgOqE5lJm/Tt9A6UNuZIZCYpG+PS6fRho3tseakLZ2zcLRrbCFUj8ptlOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in; spf=none smtp.mailfrom=ee.vjti.ac.in; dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b=AWvXNVVh; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b="AWvXNVVh"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso3263440b3a.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 05 Oct 2025 08:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1759677252; x=1760282052; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gG6l4sZPIWetTmhsdiktxSijsm0HjkE1waDz9JdkO8I=;
        b=AWvXNVVhdFVYMr8n3AB244hyvYxy8AJZEkcHUSUToka/1cOJcTzhhwlaZInmcp5+Wx
         qlzrwcNC2k3svzH92rkELf8G8sGRDXTuz7Xj485HAxuFZ/ziXgOIn1MrWWhr6mBN3zvM
         JsKWy63EvW1y/xTFGxHbARd8vnlWLxwFv0YUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759677252; x=1760282052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gG6l4sZPIWetTmhsdiktxSijsm0HjkE1waDz9JdkO8I=;
        b=RSIVe42uRlUQWmv40l3cvTeXUYkTDTSjt7Km7836PWYYRDE2oiUiSvZwcLn4TY2GhA
         U6JbinLJXJg6FAgMMYhO36M3/HDInphi38h+ja1W6PGXqW3gx8pIQjUxVcFTlS3livLr
         kHh4tBpE0HpKWEABypmbRa6LY1OQkZWQLbBmbARGJI0cmJO6rJ3NS/NYPHQ7R7bJ95mS
         xvtXuz5uwab4Psgkz/lgs1CBMri6jFxbM8nXT9wi6o4We3xYVm3kOfYQ5nrXqyaIxFO+
         i2Z11WSTniczFzwOVmdplVOGWAixbYMIhCOh+wymM5XMzb6ZBtDQVxSqQY++gBoUSAe9
         8sDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtyO4K08SrEXNtSG16V4mXm67UiOdKTQJE0q2zZ/Y1LNfINpZBWwOjkihkXbcA51nvOpmUZEV7XVOVNQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyK48ClDNKgRAORCdzhUatnZJltXO12uOOvkTwIWyAoMkNjWPhg
	DDNDxdd+9gNdrFBzLC9581V1uKwRphNMPullAsOdqsEqcQR+xpQ8P/R4eO7apryJBsA=
X-Gm-Gg: ASbGnctht1pF2D7NixkCMu5JB+CWXwvR3VjuTvT5kc+bwszZR2wYxnpPXdyA47YjBxl
	GRu/mLkT69FWGLIIXVm7QUi0mSaHA+UCiTCdaEQH88RExUXOO97ZSeBcBDyNBzIwBFy8juFgUri
	RybF5iEqmaSaQrtHwCBjtR5MfqDrSrR/Zk5sWjftWRbbVo57KvUqD8Pc1m57fGSGvETr7gix/vr
	kVYfONvK8WLv/jbQ+myw5o4fdHCLOxrqimoLdm7a+Snv0uHMd/X6CCjsa7RggMtDeHTqUbndGOw
	3eGXUqYRasEE8WIA9grAdV/WBPClIwO9DMQE5SOqjTohXHI0ipaH+QgsOXuULedfHitSItyupDu
	vSdgaoAlZ7HyCZnCVGPjw6otoP82d/4RXONcaAexv/N0Qm0dhB/lXEBhiPciUZ8UL5YoFBaf9td
	9YKvKpsOmM6vNFaPY5mbgC0wU9Oj84jKbfXtOM
X-Google-Smtp-Source: AGHT+IGh0K+r8nflRBqpJ94if0tMDpZ97UVi7zrbovtIuV6dpxWvrRhjhNVlFvK8HpnBFUsSZQ597Q==
X-Received: by 2002:a17:903:198b:b0:267:da75:e0f with SMTP id d9443c01a7336-28e9a543a8emr91836865ad.11.1759677251745;
        Sun, 05 Oct 2025 08:14:11 -0700 (PDT)
Received: from ranegod-HP-ENVY-x360-Convertible-13-bd0xxx.. ([2405:201:31:d016:7b29:830:6e7c:1c3e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d111a37sm105437955ad.8.2025.10.05.08.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 08:14:11 -0700 (PDT)
From: ssrane_b23@ee.vjti.ac.in
X-Google-Original-From: ssranevjti@gmail.com
To: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Subject: [PATCH] ocfs2: Fix use-after-free in ocfs2_dx_dir_lookup_rec
Date: Sun,  5 Oct 2025 20:44:03 +0530
Message-Id: <20251005151403.9012-1-ssranevjti@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

A syzbot report triggered a KASAN use-after-free read when creating a
file on a corrupted OCFS2 filesystem image.

The crash occurs in an error-handling path within the
ocfs2_dx_dir_lookup_rec function. When the function fails to find a
matching extent record (`found` is false), it attempts to log details
about the corruption by reading from the `rec` variable.

According to the KASAN report, the memory pointed to by `rec` can be
invalid at this point, leading to a kernel crash.

Fix this by modifying the error message to use only variables that are
known to be safe, such as the inode number and the extent block's
buffer head block number. This preserves the valuable error log for
debugging corrupted filesystems while preventing the memory safety
violation.

Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
Tested-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
---
 fs/ocfs2/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..8c4dd61efa8d 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -820,8 +820,7 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 		ret = ocfs2_error(inode->i_sb,
 				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
 				  inode->i_ino,
-				  le32_to_cpu(rec->e_cpos),
-				  ocfs2_rec_clusters(el, rec));
+				  eb_bh ? (unsigned long long)eb_bh->b_blocknr : 0);
 		goto out;
 	}
 
-- 
2.34.1


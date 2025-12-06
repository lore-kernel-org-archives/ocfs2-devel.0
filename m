Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D032F3C12
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Dec 2025 13:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765026324; cv=none; b=uQKQB9OPCfgWfSk0f9i8h/Y/6hTYmEIiCa/mUxVjbe7JOWHxcyaFvkXZrdxScop+4z3DQeu7O6w33DqBYapm3J7kNLkjorzfVtc6/GNkfK+YxdzBjLl/KMc8HRApxmGcv6W2ViftwDuO+F/08jXWTSC8YjcgjwuIpXXFRYbWsZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765026324; c=relaxed/simple;
	bh=6X5kDN7/JNNk6xHEdutHVlh7/zoQavGjrY9t+Krr2yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOp6UFuc+5Dl5XdfEQA0b+Mh/lCIDdjqYvSvq9XIxTvNWGoDLS+1ksbJc9v2/zYyPnHw9SKckYV3QeQ9s/1bur5n2TZJ8IW73bbCgfSMGI4s9wH3pST75BQFmF2CbEq3LlWWhOJNWq9xQKU8zEHwPrHaKEcdx0v/GHBc5c/JFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOAg/tX4; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOAg/tX4"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-349b711d106so177576a91.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 06 Dec 2025 05:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765026321; x=1765631121; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/UfOG10d/LGTrj5h9V0wUVcOnBD2/yF2K6rlAVZC0c=;
        b=OOAg/tX4gXRfXjYQBoRZTVrEyQntUtlbw+2EzSWutGnoFd8LnwHOtN102YMwKhiRNM
         1RJrqxhxn1BzklF0togRvhFbL/Fe15z4IQXy5an/NL5Hljnvt+eFK5wX7BYn2+pFLeoC
         xtTewrIHk4kdrT3JOz75YRE963uMf3Kaziqbze3mTdcNcClN3XgWxpvfsDbSbiAJPmbs
         LpDMQQVBVSNcV9Es81TZX5QFMTcc2QibG9nx3iASE7P9/1EeUpehbW0vAqqLpZ0sE7Du
         B1BODYD3eZ/qF/z3TBJ2ZWuTRE8rMiF5oPEXdDf2CBk2rIkcO/giDK8n7IAKU5QL+qaA
         pwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765026321; x=1765631121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d/UfOG10d/LGTrj5h9V0wUVcOnBD2/yF2K6rlAVZC0c=;
        b=qtcNeIO1uiebiTwV06kAjEUOd6LrzoGhVeZe4iDGNBBQYTujtbTPpsmEtiRU0uVG6y
         ffWWHpmNX0tw79JcjVJhuif9TFPxo7FyW4gdLVsXC/pxhEuSBO9DAV1QcDXxebCwbtqV
         Wszm3LPho+VpWsoUaAOn791QTaOiMjqg57Trt8R5rvIBCJqpZiVDhW3HvCPlJJFAFz8/
         Dncctf35iRuPkyFfqXNKUYZc0y4SagYS3Ag8n1f1afVapLgjuiLtkStWPYpwq01tA8P9
         e9mJmD83wDjI+5QJhfFg0sV1lSOSu5KaYGC/yMia21uNvO+lqWK1lDuHITn5+9tK46NP
         NmBA==
X-Forwarded-Encrypted: i=1; AJvYcCWuV8bsVUQsPQNrYkBR536GWNZXb5KSV/HV3GBVfDlukTf1iLKt/LQm+BU0MGjGxbjbgIKhVtXfAbDFow==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMbVJxE4T2lmvoGQaWwJ1chStEfbpGu5qJEKINH0O30fhHGJb5
	dKGcEQaiakFA92k3dNrSvSOWqEjyNwMb4RnHa8OSSG+fTy7wGZSs2usK
X-Gm-Gg: ASbGncsMKcnDKe/KzWUqNLk/G5al1rAR6QNDjANSaldBaGzQRi08HOQc6m6TpDiJQr6
	UjXcQLJ/9/7tFedy4K9auEUdL4hFtAd8b1JeH8y/MhAlDvXzGl9tLQ24nL5HQl0b1kI9XgcqHTn
	0qZF0ITMsKTY6H5yxJckNRuUqxz1g188dwpe61JNjsyRNs3hdsXdNrzOE/ESsQ+MtScMdgZh8Ol
	/Qg4woUMod982mpVLZnlP0tCMqBTCC0/Mu9T4lImmIkX9mOkvIypFi99+bOmVOwA8wmjyi37Gad
	nBhH1jkApKDr0uvc1aJuWgX9qF4zlxL8vS6hsPFMGVPv75Tm6iwpBfyanvx5V3ssLbYzkcgvlZA
	bqY7HPpyuFVB23GvvLUIT8NtnAkx8J+PCFCdR+J/f81XGM/crtG7lS7/go/U15wzQEUYxrHxHZc
	c2DfZFuX0MxoAN4dyl2lUUpaCsIlwZE7vWB23c
X-Google-Smtp-Source: AGHT+IG15crDZgAYA1WBSd5D99afyw79cjz8bw85f+ph/SRLX8cY47hqjkmoXG7Xo9NbTA8gPhAXiA==
X-Received: by 2002:a17:90b:3dcd:b0:33b:bed8:891c with SMTP id 98e67ed59e1d1-349a2686506mr2004012a91.23.1765026321284;
        Sat, 06 Dec 2025 05:05:21 -0800 (PST)
Received: from localhost.localdomain ([114.79.178.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6817389fdsm7662563a12.1.2025.12.06.05.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 05:05:20 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot testing for ocfs2: Fix kernel BUG in ocfs2_write_block
Date: Sat,  6 Dec 2025 18:34:59 +0530
Message-ID: <20251206130503.168731-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
References: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 24172e0d79900908cf5ebf366600616d29c9b417

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/slot_map.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..79f9d1753bc1 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -193,6 +193,17 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
 	else
 		ocfs2_update_disk_slot_old(si, slot_num, &bh);
 	spin_unlock(&osb->osb_lock);
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		status = ocfs2_error(osb->sb,
+				     "Invalid Slot Map Buffer Head "
+				     "Block Number : %llu, Should be >= %d",
+				     le16_to_cpu(bh->b_blocknr),
+				     le16_to_cpu((int)OCFS2_SUPER_BLOCK_BLKNO));
+		if(!status) {
+			return -EIO;
+		}
+		return status;
+	}
 
 	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
 	if (status < 0)

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
-- 
2.43.0


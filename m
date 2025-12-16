Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6417E2561A2
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765915555; cv=none; b=YUazJI2KOvSy7bJmYyDpwhZm4wIqFjr8NO4E1ug8LGFkZCgMoqac+fYTZkV2uVSBpxv5MCvpD004ZnwZ/ZN/lrGZaDleFEwK+kAWv9DG76774+bPilb2waU7LF7yGSFItZet+divuMFKgeq+R6cUICNpreKlS8tsdj6WpM2S4Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765915555; c=relaxed/simple;
	bh=2gtWttGGpvweLIEYAm1LIdNsm1ecj87EixohqJgLCSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VEViD8l6qfvdwUOgkocuDXl1NUmM/n33UOe2SbD9QqpWC5G5NtvyAzwbU2038Eqe7l7f8DrZtS7ZWD4kqqEYuVgMOFVhQ9Ze+/5mJN55ndU/lPOQoULJXMJ3BW8GwrCCYJHrhSvV8MYBb2YVHmklXcYeUgzILJtb3OKEGKpd0cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqeRhUo0; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqeRhUo0"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a1022dda33so22010235ad.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 12:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765915554; x=1766520354; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nk5VEo3f/bbA5JsoMBtqnTR2AhljYyWjNqK2HiCPcog=;
        b=KqeRhUo0PaCmxIvWK/Kck/oaHZdJ+LtwzFuaa5r6uqYe9r+/ydcC4hNQSp01gEPute
         UTUmoJ5BiGhE51jztVkjc8fLWnX5fVvaPgQqPqftaPTCLqXtKjyO9NHb4xRYtiX9fS2D
         W9nti0f9RaFWBL82stWSqSK9WKlZKS7i6+HCQStEq7FAfOjeZkvnK49kHbn0ai7dX5ga
         kof6aMM6PGIzZtfTIPYZqIXzkd5XXP8mlGqUz5EsFDVdWKkhjbScMgS+c4Vo56oT5Oxd
         H03t71x8GdX39/6P1JKHeHDbUW7ibdy4jYduaFpMFe/Ya2aAxbFPq2l77afNhMGW7aMR
         i5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915554; x=1766520354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nk5VEo3f/bbA5JsoMBtqnTR2AhljYyWjNqK2HiCPcog=;
        b=qFdfOmrTwEXbi1pVR3M4YZQGsbyf0SngNaAZexbpTLbYRpWDBJbCCcHyviFAEy03Zh
         JYUmM0MNANBcJrSTebg/k8zLgtAA7EvqYLYDb8U8G8o9rZYgbcqErBHqYOqNrLxRi7YX
         m9VreNo4fBUOaYJQTaTNH/g/OsdKAXDP8zz5XtuIwB4I7dZkD/t3cbXTY7xFoTNk2mMe
         U6DX3PnpGtf/7QMTjR8noKkZva2MQmf4mFUQCH+pSfim76RzitAe6kn99qeraj0aGS2/
         a7UOq2DhQK13ZUhFCqHESM6tIvCyTDCr1J804plaoOopdh7B1v5wjYc3Vyeus54UT3RG
         cfkg==
X-Gm-Message-State: AOJu0YysYreXhXbfFe8i7tkzvE/3jv8Dx2HJc+CjnYeeXAJULCz4Os/k
	DU49wQw87CzdcUuKd2IUOw9BszvetqW9zKVb2m7efhkC+VyA0me/hc1A
X-Gm-Gg: AY/fxX58KbHyfDCgT/17RkebcT3xQE9adKM+Va0E5GDsLq6dEt1FUO4J+S9cMgJSiS6
	Rj9EgmUOBGmY6yZTHpjLYO6SNhltRu4DfBLDueimXl7H5x826logQtaOm/E+LZ3Kcqn3i09C1Tl
	iMR8hxMhGv27rG2fh/kew5a15o3CJrc/W+LJszSJcpE5/OpTKB+/DonJxdF5+NCtL48sUYKuiAx
	MuTZIRydREoQtAq94vu5XoyxPzORyJWnfsU1E3baHlYBJE9yg6UJA8JAnXexgEJyOigiP8tyYCw
	3aoZH4pIUF3Mgpta3FGK3fxE4gB2d6zjtgdZZ1/k7GYRnosqog1B/t/gzbxRznIeGBvbbegmICA
	AnNa/dnrZCEuVvZKt+k0rJc3jdo1trEKf9XOh/jmbqfWaQnBpSFSBINJUcIrZdGG5OHUsD2F1+F
	3XUls6kINNO17AqmiFDPKos+70MSc=
X-Google-Smtp-Source: AGHT+IFBB9lpgo0EscsFPmTDrekwuTdVKsOIVSCKfGeWbaP7aOmozgyPAliYKh+tJ6xigpQG1/qjWQ==
X-Received: by 2002:a17:903:234a:b0:2a0:9eed:5182 with SMTP id d9443c01a7336-2a09eed5585mr124313435ad.20.1765915553651;
        Tue, 16 Dec 2025 12:05:53 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38ae7sm175407925ad.35.2025.12.16.12.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 12:05:53 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: handle OCFS2_SUPER_BLOCK_FL flag in system dinode
Date: Wed, 17 Dec 2025 01:35:44 +0530
Message-ID: <20251216200544.4114-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ocfs2_populate_inode() is called during mount process, if the flag
OCFS2_SUPER_BLOCK_FL is set in on-disk system dinode, then BUG() is
triggered, causing kernel to panic. This is indicative of metadata
corruption.

This is fixed by calling ocfs2_error() to print the error log and the
corresponding inode is marked as 'bad', so that it is not used further
during the mount process. It is ensured that the fact of that inode being
bad is propagated to caller ocfs2_populate_inode() i.e.
ocfs2_read_locked_inode() using is_bad_inode() and further behind along
the call trace as well.

Reported-by: syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=779d072a1067a8b1a917
Tested-by: syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 12e5d1f73325..f439dc801845 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -347,7 +347,12 @@ void ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
 	} else if (fe->i_flags & cpu_to_le32(OCFS2_SUPER_BLOCK_FL)) {
 		/* we can't actually hit this as read_inode can't
 		 * handle superblocks today ;-) */
-		BUG();
+		ocfs2_error(sb,
+			    "System Inode %llu has "
+			    "OCFS2_SUPER_BLOCK_FL set",
+			    (unsigned long long)le64_to_cpu(fe->i_blkno));
+		make_bad_inode(inode);
+		return;
 	}
 
 	switch (inode->i_mode & S_IFMT) {
@@ -555,6 +560,11 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 
 	ocfs2_populate_inode(inode, fe, 0);
 
+	if (is_bad_inode(inode)) {
+		status = -EIO;
+		goto bail;
+	}
+
 	BUG_ON(args->fi_blkno != le64_to_cpu(fe->i_blkno));
 
 	if (buffer_dirty(bh) && !buffer_jbd(bh)) {
@@ -576,7 +586,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	if (can_lock)
 		ocfs2_inode_unlock(inode, lock_level);
 
-	if (status < 0)
+	if (status < 0 && !is_bad_inode(inode))
 		make_bad_inode(inode);
 
 	brelse(bh);

base-commit: d76bb1ebb5587f66b0f8b8099bfbb44722bc08b3
-- 
2.43.0


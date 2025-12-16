Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD8133344C
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911155; cv=none; b=oWKrP2fhil+M5LAbPRuoGZddNj4qPUVSM7GfBs7WvNSNG10AlP6n1xxauk5slZZDX8YtTtiEfU0wX1X/T8sM/l4dQ8bbG8xS+dXsuMrHBUxaYFzfaowqpkhdcRJgclyCKkei86BtqTN7o2Vz9BYGU67oC1vJzjze0m0tdqQyAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911155; c=relaxed/simple;
	bh=Nce/j4OPhu0+248jgrGHkXAmn+4nYy7iZSFUh66S8GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sG5s0zOmKL4F1E384j4NvBdyF24K5PYXfLJKqxnX5b4W1xfeLRooR79SNmMZSg0qtj202BDasuP9asT8XAMlU0OQDlrs+pHyRM5zIp/oKYbU1Ie5PbOSSvB/KiyscKuDAWLcGUVJn3MJnlAY+h79oA/7/tN6zVztD7f2tC0w90s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Io5jT13Z; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Io5jT13Z"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so4674412b3a.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Dec 2025 10:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765911153; x=1766515953; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykq7RwzbFDnHLDwmI3Df/wMgjpeIksVlYAA52SJcTZA=;
        b=Io5jT13ZzFbRbJc+MRwUIONSCyzTAD4K5YB2OdIHo/yAaFcEo18LMFvRuklYLuf/UF
         B4Z7wZOns9QQfvFqQf5vDwhtJN0CcqPApHcedqH4tM0/FoqxnefG25zdLtGqOPhad2en
         2eqZB9zyWrMl+Yh2XyKNl9Aliq5p5aZiuh+eNk4rJkcOQl8hqEUTWaOJcpafc2hnVBDN
         JAqsyWr9ZdYKNTc9X4cBrgMLTw2tjrGn4i5EcPizlHJRZQG23LceBZA2B+mlWDRmtMAC
         NMkEoG6uxW48OXK+W8Y5zoUovAyHVVmJV6yNYIHDaML4FMboK+oN2vbBk0T+ymVyR/PQ
         17ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765911153; x=1766515953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ykq7RwzbFDnHLDwmI3Df/wMgjpeIksVlYAA52SJcTZA=;
        b=Y1XIU63cECfFkCovNdwowQJ3cchUKglj9SEnNMUwRkV71CpzbS43K8lFkeE4D0/GcY
         OjhYyB/NAp6HUzZ+fYEay3dldf0xOEPuE3Nct1B5CP946Td2dCD21Ks7oByQDyOR74E/
         05CxLBupOoMT5xGgoLg/UOocod+L683Gd1ztn7qgmrpl26jCk/DRUa5NGm2zJbGQIG3t
         DV/H+Y0Q1/zYht0K7T0tTpOf/5WU8L2KOkUQ5dbIPiGOv1XLoFNHYiJSHQeqZdYSADX5
         UWaAECCHiWiC+ekOKHl9c5sTRH9sLcBQAO5VSLyQKokK8faaDi6F8OWLsG9/nPLm4dnv
         DXXg==
X-Forwarded-Encrypted: i=1; AJvYcCUKz/9LPNEpOpwPnybm1sUHISPE479WkkNi+RHVGuAjX5xBK3cqPHq/pD+ZgAcl2pnyrIKCROs8QJV4gA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxMXPh6vDTHSa0FOLyc+rdjFf1bCYhxx+GSWdUxO1HrclIJA+UH
	f5nDMDyI1DhIKPLRhomEAhpJbqI0sBqLZo8ceU5vwO8qhfTlxTXO+rOC
X-Gm-Gg: AY/fxX6piq7EbQLG58HMsUG0ypbsTc1byF94yBVg6vApK9QUKbKc8vMh6BdtwIomCoc
	IYi54fd67gO7Lxz940lwsZcEtnq3prYx2ipoPpIQoxbiZgdXva1Zmi4Vp4uSfZ5kfsRaHyvYyen
	fhKzDapyPCZTiBd6C24GhOnd9qO8XoYgQitCl9wgni2Z9vJriLHZySMMFNSicRcZdZ9ncFb9Jvm
	rT1Jcf5fykPM60Ln5bC7okjTpKdf0TAL+a+xlsNWqaFz3k7Uns2L8kNbvGaDFGQ8mimwQNfPVpI
	H8zEBf2uidG5fKkozjyWp8ru4iP3Ll1/iTgYFeQt/bLoTi69HXVr2X9SIXGD8qUrkeRhLkKrE7l
	HgGlcqdjKbNOgSwC5EjALdj7OAMbd8935CcWI8ld5JSPotlDAGeLyQIA0G3FJbfwNAVpUblY1HJ
	j+mvj1TK06P6jLPMLvdBHeyjP+S+daHXuZgx/QXQ==
X-Google-Smtp-Source: AGHT+IGVwwEIWOOfiq0wiziNtaloZ3g5RFzG1PEu9/2o7ZwdSSwjy0D0m/o071xxpN4FF/OMmYutKw==
X-Received: by 2002:a05:6a00:3491:b0:7e8:4471:ae6f with SMTP id d2e1a72fcca58-7f669e7d93amr14886162b3a.59.1765911152634;
        Tue, 16 Dec 2025 10:52:32 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7fcb5c6d9acsm274041b3a.0.2025.12.16.10.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 10:52:32 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+779d072a1067a8b1a917@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for ocfs2: handle OCFS2_SUPER_BLOCK_FL flag in system dinode
Date: Wed, 17 Dec 2025 00:22:19 +0530
Message-ID: <20251216185221.31843-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66f24c1c.050a0220.3eed3.0020.GAE@google.com>
References: <66f24c1c.050a0220.3eed3.0020.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git d76bb1ebb5587f66b0f8b8099bfbb44722bc08b3

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


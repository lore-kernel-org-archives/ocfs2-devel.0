Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1728C28DF07
	for <ocfs2-devel@lists.linux.dev>; Sat,  6 Dec 2025 15:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034413; cv=none; b=YGnlq6190rSQfztr735zffacbMvLcEYRtXMcBRkmrfucUktyiJ4qRsJuKq7cWWYr0hmhgfk4gcAT1hyq84/ZgnMlzxYzdwhzv6gSjydPwNtrWlEsPltGxJxt+tipPAxRqDmMRFvUgW3XvdWNmVa5EXttgh4rAL0/49Y/tcTcXLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034413; c=relaxed/simple;
	bh=eM75cyrHtDjfvkuA7J7bycjIgcyz7mqgwxWU4knwGbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz6zYAmpFQH4qcz1KYs8mViTWQ8oFSJlpQJCNJDoTY3jWrgGE/32C8jjV0/Bc+uiTcFEE2+ZvdmRsqhpJ+j+LEiv+dek/D6CK6r5hDqW8kC5x8BeR26wY/ETSAhHJjMWxmlMnr3fLvQKw8mFR8s9G8bV/5OGtiADBGzeocQgTPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RatRZp+O; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RatRZp+O"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-297ef378069so26911995ad.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 06 Dec 2025 07:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765034411; x=1765639211; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCPCQkfL2mOYEPsrZaUP+nIvR3clDz05tY/+zKlF6ng=;
        b=RatRZp+OUTD+QAYTvLrwgzfjuE6LpC3f5uMXNHeQ+gQRdUxZ0CwWWXf7G6Ux94EIhs
         G/b1vW9uEVqL2gHOMlVkAOUACXqHdCjMzpRSZ/WvyMYRkgyyHmC2ItWEt8dCfQlCVzEj
         8pPuvH4EgneUEbXmbqsegd44GrvFxwXBTZA9uddv8LaM1LittjUso9gYxcj5SNlteuv0
         uCS+QcQzYv4qUFbxrdnNJLHiHsnrw8MiFBs2YZH1OyTobKR3zEPAEXZXbxc4uAqMbSjl
         3vOPvDzFK/DZTuqBly5FBh6ei+R/L0r/rGu+1EGJvCXet6ttBM/mZW0rho/w0zgsbeK0
         OMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765034411; x=1765639211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QCPCQkfL2mOYEPsrZaUP+nIvR3clDz05tY/+zKlF6ng=;
        b=ld/u1g4JAwsj2jEPMjXsbYfgO6QmqIUE4T6saDKW2N4zkit3z/UATG8ETq5Tmv0xnd
         xRmux6W9+Bb3qiUKci/EunWFp7/k7GRUg/vStmyD405dERkB/WkKGlAqEu8RgCZR0/Pm
         qf1Rg6ByaXSuJWc7K7DAaybRqYszXJ/YDKAi7y1hnsDxJTSLbt8GTDLk666VRw1exWN9
         Q8QV9Vh61OlSjqIRwNKyWMFY7v8RWwnsNoQlrPamiYVAiQnQT8Gs7zoE61z44LjnmIhK
         JSa+BogGLxat0T9NDyd+m8Uf0zjYByFhR4DOe5h9FPZmCSLeQOW3CGDYCiXM4tC2EqYx
         dTPA==
X-Forwarded-Encrypted: i=1; AJvYcCUIiLGnb9+2YcpPJGfuVyKvZpqPmsYQ2/fo5/FtgY82dlVg0jxJAlBlQ2xOMJUxEXwtLX7Bshm+h09DRw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy780+E/ZH76L4NKhXm0SUf+JGEQPUfJX32mj+u97t3M0J19qaj
	FYgJcqFNSlDnk3+jLUBpShdvDTOCSBc7iX/HIX+K70kYqZ74j7cxBbU7
X-Gm-Gg: ASbGncv7SU38R0Cdc+urtPjcci1Br3mmZLzzm4a0iI/CeNVtNBUZtujZwPYlJjKP0FX
	uIfA4Mn7Abq+Kv6GcLq18u2JSuiCz82yFiOyqwgx5vVg5/E0h9O3hHXmMyPL0K2kyOCJjDraBt1
	6NhZWivfkwB+mNxXzTru3G5eWNpMFDnfHDETDX8vdSkRsL46mxUJj58uOUZ6EDuqvOv9QcCZMOI
	lH7r8cbZUo8zNeH4lxsswXYjUQB6YRbY48hHZbA3ftJOz4eVlR/crX58V6G4Ayv+8FwVZ5xUb3h
	qcYSAzkvgTfrgvGHLB2aC1oPx+BEE2KE7Hxgm+k1/h+GHXqQdut0cpMM5WYq0h8/5Kvy0zXhT3n
	jnBUCse5Ig3/vfnQAiSX4YgFmN3OjjTiU3R5OYfppphV8OYOVPKJx8UAD+o16fxq2NsdDq9pXe4
	sufQbG1I90vO9lJsrXFlcrMzt6Dg==
X-Google-Smtp-Source: AGHT+IFnfOwZ0UeUbpq7e0itNLkBPk11hq+DTlyLF5/8LEYFBfJIBWsTFtc8HqrDIuPDxGmgQkDn5g==
X-Received: by 2002:a17:902:da2d:b0:29d:9b3c:4fc9 with SMTP id d9443c01a7336-29df641f4e8mr17936935ad.57.1765034411185;
        Sat, 06 Dec 2025 07:20:11 -0800 (PST)
Received: from localhost.localdomain ([114.79.178.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeaac16fsm77009865ad.87.2025.12.06.07.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 07:20:10 -0800 (PST)
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
Date: Sat,  6 Dec 2025 20:49:59 +0530
Message-ID: <20251206152000.174746-1-activprithvi@gmail.com>
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
 fs/ocfs2/slot_map.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..788924fc3663 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -193,6 +193,16 @@ static int ocfs2_update_disk_slot(struct ocfs2_super *osb,
 	else
 		ocfs2_update_disk_slot_old(si, slot_num, &bh);
 	spin_unlock(&osb->osb_lock);
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		status = ocfs2_error(osb->sb,
+				     "Invalid Slot Map Buffer Head "
+				     "Block Number : %llu, Should be >= %d",
+				     le16_to_cpu(bh->b_blocknr),
+				     le16_to_cpu((int)OCFS2_SUPER_BLOCK_BLKNO));
+		if (!status)
+			return -EIO;
+		return status;
+	}
 
 	status = ocfs2_write_block(osb, bh, INODE_CACHE(si->si_inode));
 	if (status < 0)

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
-- 
2.43.0


Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6D62D97AC
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 11:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764589412; cv=none; b=tbB4rAY6vfaKpasQs36LikevDAfC/uChhJMP72NAOUaKpnZVswg2FVoOChy3FFQhmpJcFJxcKfFeW7Ydr9bfrJQI36JrdJPug9OSdu92k+Yw6KCmPGT0/ngMAguE34jnL2nnmyPkCF4FeyPOXM1QpJWh3Xrmg5cg/lVEH9zk1FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764589412; c=relaxed/simple;
	bh=KN/sMBFY22iUXIq38dFJGiUgyVdtQV2nI1plYk3m1lQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DeU9rvKJdHsW1klfm1SOeF4sLXMU6wI8AQ/mzI+a+KTEfpv256zM1yBVdjXvB8po2g9FT55B2FSvm1odilyRG/7iC2Vi6zkgIfZaXkcNY5jhACn7NejnF0jb2G6/S9FVwqpEE7GsBrZYz6OesJ5UFWiamWk8eswZtVQR+lcZVaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYbViqk+; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYbViqk+"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2980d9b7df5so48223375ad.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 03:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764589410; x=1765194210; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCKgBcPoalAy6f5rN4zp1ApZDY6VFFjy7LxYreKO+gg=;
        b=iYbViqk+VSdoohxOJnpFcyM8KBKWe7v47/Ck4fYsetXYoVTDBgWHx8pYhY3oc6Ux/x
         q4SkPOt2Y5YRe4w/a3nSwN9K6d8O3HHplGsAh4/WxNEteSfFYACIlQ6CxR8YuLC6zJd1
         OikZf2iWYNmTa4Vcwsv1uQuu1w4lEWvcfUfkk0FCnMVj2Hw3ZtE/d+4WExSRtAzuSz2W
         DK1F3BKgNtsgT5yOFkE21km6Itg7FRHs9I7ftyFFGtYZ81W7YyGeytysXe1Fx16xNaIl
         aIoqwa2y5C8coVItmbS84LoUbrP2D7z0yAXcz+oM/IHBsalvij4Ro/1SjdbMtWkYBu44
         1zsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764589410; x=1765194210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hCKgBcPoalAy6f5rN4zp1ApZDY6VFFjy7LxYreKO+gg=;
        b=rNxm/HuN+EW7zXiQ9r1KrWGCI6MvVwA2PhnQQsn3Qn6uHie84RD1teAJgkHERlP6he
         zaMQjNNshoO07j4/OCdQ6LNC7bF1Ie5KLMotzD08GoiS3IUuauAt9/c88PZXqiCqw5lw
         wnf9iohsK9oZCeh50Hd3d4YcXlhgo6NyBtS1g7PblwOauSEyRolM9H+W803AtvsPQhH5
         jSoLakPcnCTWiA9MKZ244Us/OHdmdq65x5VlqzbuXSgZCd02O1nwkca8nBZbEkJsU6LR
         jnHskBPemTlUhGeyhFkphZaIaKcXq9w+7PZUOFkxof91kRYw0q2vmjAl+x+IXdrJHaby
         s8ig==
X-Forwarded-Encrypted: i=1; AJvYcCU5WpDaQ/L0W1VDMALJ5FXltbixqWzGPcIduDOvlgU7tmt3aF0Bg4f3+AgvwEmo2x4KG53cT5SGJBRarA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/Mdrlqw073FZEPAA2KktK/kIHD2f695s3M8cjk5nPZ0VhCKQx
	/bq5txgE9H1GDoUPozb/96JdlxT7MolIowY30cJoHHSnFFRAw0tBfj36
X-Gm-Gg: ASbGncuNThMZj1ZA+zTjoZnF+CW8WwG08QOQi6RpwITSP/eYQvF0tfQkNL9zzfeIHJV
	S1jjUhAaei+spqh9C9DirVE9uw3qvoEizEFFdJZ2xfOF49K2BjCSz8/bdqSHZfZHBFcfG7nv9ya
	9WhTfp//yQ1YTIuD/hbx/826TMXWPNZ7l1QOsiJP1fDpSwIOmyb8cC8NYKJLzmJf7GM5/+Z3dJv
	+RvqGMAbEV1c7VAgJj8qe/HEEko4wRokSPnVBwB20LGdM4Y51QgabJ7y96RC4gY9/JntfakbLEW
	Rz9Bbp+PN79CFRR/X0u16JVnY8T5k3/TLFq9K9lcYgYgaexg7HnAm3pQWGy9ejjWV5w3ZL10aBG
	u6O2NcXQMY8gmcUZFoO+biARk8zlna42cOn8+Kx5L3WSg0yJsmPGQ/gUsWYpDf368/+oIBwfJZ9
	7ni1zbTXBQ7Nm/DXdhd3EaFzKdvFM=
X-Google-Smtp-Source: AGHT+IH3VyWoWSAzlZRlnmZUyiSjGpj2h1ooG28qgJGo6+8xqNmFAExebW4QEuZcT2FB4hHKpueTeA==
X-Received: by 2002:a17:902:f548:b0:295:4d97:84fc with SMTP id d9443c01a7336-29b6bf3bcc0mr399042665ad.32.1764589410402;
        Mon, 01 Dec 2025 03:43:30 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb4026bsm121775295ad.71.2025.12.01.03.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 03:43:30 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon,  1 Dec 2025 17:13:21 +0530
Message-Id: <20251201114321.121153-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <000000000000560ff106204134d2@google.com>
References: <000000000000560ff106204134d2@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 939f15e640f193616691d3bcde0089760e75b0d3

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..6c2c33a26056 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1992,6 +1992,15 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_next_free_rec) ||
+	    le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has invalid next "
+				     "free chain record %u, but only %u total\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno),
+				     le16_to_cpu(cl->cl_next_free_rec),
+				     le16_to_cpu(cl->cl_count));
+	}
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1


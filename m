Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE44E278753
	for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 10:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764499622; cv=none; b=dGuEkA3oKsJtVXSaXJI8isAGBgXIN07bkwz7TBOMW5aWUuwquyngfgILIaEWqJjwABzmZh7UwxxCHQuQDaXaPU72sV9690bnXdQq5bZGtT67lMYvaNWIVxRvUtud6FB0Rb6W04NatQXzHxKqxWzTqTFLgQDRERk+/Z5r5mljt0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764499622; c=relaxed/simple;
	bh=rlIrI/UmoKYEL0vlVjf1XS3AzQOskSjVa2f/87hoTwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HRoayNk8KAeRcH1DQvLQ0eKWlh+Wo98gUKCs/lbxRP1oCPILHVOzNCzggUXpIwwLSTfUJP5+vTFMZYjMVey1/jMteyJ9pocrrO9fpsRdoSbEVgzXAsWfejvXAKjhTRvwRhO94QVHbdy68wXYCEftLiWPWPdfj61w/vQO0BqLiQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gH6Gh/u0; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gH6Gh/u0"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29555415c5fso39427915ad.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 02:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764499619; x=1765104419; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qTNLxP/M5VH8d16ArvNC5jrTL5Ks/32ppFB8c0OA9Rk=;
        b=gH6Gh/u0L66C57iyBEPJ+UKTuVeO/cjbLsL77eGbGZb27huaXlUZ86Ryh3qD3qzEVj
         iIR4fd4bs61wpmJBfJWEZHSjRUOvwVS9NsxAhHeirhzFAjah8U6szGlkHaaGqe4enQ2o
         2KU7+Zvt7ZDVHJYNNfGePa+cr/VAJyugvoXHSsWjFBqm5mWDgCa3AF1DvCPvmeaeMWIn
         4CvXzfbQ+4Pv+YZQyJqQNM+MZT3v8MxGa3I0HKwmBwOsO8OeOf9MYKaZ/M7hLbSg54+i
         4S//o3coevLRl8MwnyarHFt5PCbTqgK1jMYY5WlXdrglQzdYRYWMfhBTwqDLmfzfFFwM
         E6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764499619; x=1765104419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTNLxP/M5VH8d16ArvNC5jrTL5Ks/32ppFB8c0OA9Rk=;
        b=bN5GRS7BnjKj7lZcyHfKWOKuy9ZipxsCQyEbMYFU8Wvw6gJ+zoZKGOu4AaUEbWEFXo
         J0ZUpF4fx8XF+9YVbkasvtIlqidzkh3n1CFggzln6ddeONzgrFUr0t5eBcTfP6O7tx6h
         Vp1QM7TG/kYnZx0h+3GPEhyII3Lj5sQqT7AoCApGnjbH/OHyiwtXmWM43JFb1+ISLizP
         93HzzFmhN/Evehvc94AxU5E8k0uqxd6Q4NVrJnyzypNj1unBnMroSE+YFB6GkCPR5Zry
         NA0IEsGFMfDkCFGmLn2K6phEZokRNg9e+SmpWQoswghtre2LYvR+5rzoYxscHCkOVat9
         JaZA==
X-Gm-Message-State: AOJu0YzamrI97FBP+eG/wLO7p2fQl1VuL1ntfJX/wpd7zBKAd9CUgOYB
	grskljy+TMLIo1DvaOIcIBqZ5mAFYC3RCbdyKH10byINUsiB6PgeNAQM
X-Gm-Gg: ASbGncua9FRsW5zxcyACAFoJ68R7ysLWrjmKCYP/tos5wqf7ThtefQiw/gk8fADaelt
	NjdU+pG4QarltJSuqibwT5foyBMISib4R5fIsDNJ1EpTh4ItNHOIUon1H+MJBsScxZx8oUa5+EJ
	JBUPdWpDMZqLQWc2BO3u76Edxfz8v5zFlLtmJ16qw2w9H2b61qq0Z6NCsorpYlHrp+65ikX00H7
	B6BUVB+ORATnkFejE6DwhUU88u0kke71Yce0Cl4l6i0b3xLbelaYuiCvFU1Ut2pTiyJHqAT0p2M
	mjNpTd4WGXHLWQlCF0yKY5REuy00sVWy4SJKKFxGu22IcbuFPQc0y1ZZy8kJ2LfY9W8aN8EjJk7
	bzguVxwH6mZPFWJYI5AsIyMamjYuEnTGSD9c5sYHj1QsvhJ+zbzP2mzW3GDUPaPPXx7wXPLLi83
	oPrGqWSNMVWj4j87uL/AYnjP7gd18=
X-Google-Smtp-Source: AGHT+IERaLvmsksXdm4uqqeOPDAGOjVLAPcWW+DVufQ2i3ULjffRh0sjXfMbZt3b4sdgIKb56s8bhw==
X-Received: by 2002:a17:903:2b07:b0:290:c94b:8381 with SMTP id d9443c01a7336-29b6c3db606mr396664675ad.7.1764499618952;
        Sun, 30 Nov 2025 02:46:58 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb471c6sm91492475ad.79.2025.11.30.02.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 02:46:58 -0800 (PST)
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
	syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Sun, 30 Nov 2025 16:16:37 +0530
Message-Id: <20251130104637.264258-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
`cl_next_free_rec` field of the allocation chain list is 0, triggring the
BUG_ON(!cl->cl_next_free_rec) condition and panicking the kernel.

To fix this, `cl_next_free_rec` is checked inside the caller of
ocfs2_find_victim_chain() i.e. ocfs2_claim_suballoc_bits() and if it is
equal to 0, ocfs2_error() is called, to log the corruption and force the
filesystem into read-only mode, to prevent further damage.

Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
 fs/ocfs2/suballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..84bb2d11c2aa 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
 
+	if (le16_to_cpu(cl->cl_next_free_rec) == 0) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has 0 chains\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno));
+		goto bail;
+	}
+
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;
 

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1


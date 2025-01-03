Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA918AE2
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Jan 2025 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735880538; cv=none; b=KD52petUl4QS5nEkxcsuG1sTwf1D6Q13VvksY2q18cHyHSsQTgqqt5sMsguuCEuGmaP4Ah28s2CCggYdbscg0yADpqah9rusYU/PSA6pVXP570wvBKWn8r6TE3SvbQz5ZL4HoHYZT59NkVjpplXY1a5PMs8vQlmGAMsNCXkikpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735880538; c=relaxed/simple;
	bh=1+Hnd89uiTgIAeZafNGuZoLl6tm6pr/nCM9ZfTkZc38=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V+fEPJ2wvIV8s6R6yBuW7rdX71jaDLnFQ5rcMEFjQyfFrDO9emIqZXdjt8ehffC2o8dA/sBOIIZ8AXo874hiy1ml97mMLy3eRwyBCgqGhdlh9sj8mzRMYjKXQ5hTSx+6/Fr+zibwORYHtubaMSy/A9f6GOr2hyflLLS6DrcpUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gauzxutv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gauzxutv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21644aca3a0so85195215ad.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Jan 2025 21:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735880536; x=1736485336; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E3P3lrAlF6U1N0DIATeaF3EsAEMs/Rqz7fzLm+i2faA=;
        b=gauzxutvbICYGILMPBVnslEwl3zIry5kIrxS4CFWhAx3APIBGgxWqjUl915jxgr5lN
         jzgt4xw6j4ANJuE3XibjIUmi8O/gJmZmkp734yljJzZM4Z8G+xz2eCy8hmQYiK3Q73J8
         uXmzjHKverdWwcMHVKSIMsbOkY3zGsBBgJAMYkZJDkaCgkxHqWDfWdaDqnQT5caoe1ho
         da8JeFLGXuFKIZ4rdMQ/L7KA6aRR4LSSWJMsvo8jr3+vlumOlUgp4/VhuiSorj0iDp1G
         yBqnT2EK114LagLNL9WpHx60+t+3EUAtns+q4NdGAutdph74TcIMaWgqks7S+XSETgLK
         ecYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735880536; x=1736485336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E3P3lrAlF6U1N0DIATeaF3EsAEMs/Rqz7fzLm+i2faA=;
        b=g3px3nhwZhe+zTO8RBv7a56YTlx8a1jC1eRunwtC7CiKbKrOzhCLgjKFDB6ThrtePX
         93h7twTrmEd8QM3RuwAdJ47vBD1YckDBO6ZQ3Dxei9FqH4cxs7rNTFZW9nhka76AcU0i
         DL5ArrkiPGNQhILWuFyb07UXZz18ui25nfZleH2wbWRBij1zAUMikBji7XTKUBL4Xygw
         gcgvbwwX2xDIB43uPA3XqP+I0q9sr0DHG+fQLWldoicvVxz2ZDkX4JUP4LO4VlBRsNO8
         TTcV1HVV8L0cqoXHVv6sSEoSKdmQ4VgaMmjp1Na9812zC76FEO/kPKzH6ofmfbFDaTNg
         lzCQ==
X-Gm-Message-State: AOJu0Yw9AguP9s8biobi46QaHCk2tdNWWfJ5/YcrnGyh0hcevv1ZAov7
	A/9EVnYVDvVMnkGdVyYKA6h/oJZ9+sMiKJRe1QWxJDNeJEbvs2kb71DBJvaBWSOdlQ==
X-Gm-Gg: ASbGncvOb1fSRWyy4F4R0rBq8LGHuiCc8qagyctqSV+H7ki0JbLDFKbZnRIwYL2hmv5
	/taw8RGZeC57qhwt10A+1ir9sR41I5UfsUowyKuOjk1XMXrE+fjIP9vLUVIxpUUkokdwebYtu9U
	jOGw29fFCvGE+EwMuQUAmwfRbReu94Qcnu8F4RT8Q1HdUfzUW8jtM7AKjbTCAKL+oMY/V8JTtJE
	JdRka35jZXuB0Jakynxj02n0EAzQqN/g1244DbHyRPgy0mL9uWdX1ze+XKOuyBVvHDI3X/WuBmg
	AD6T4+2gdQyWWw==
X-Google-Smtp-Source: AGHT+IHXbok6b2UfVzGCerqZKoox4cB6od0YpqYB7z6GZZefFHku7Okae/UeF9fztsC5A1GLbvW+NQ==
X-Received: by 2002:a05:6a21:1516:b0:1e1:bf32:7d3a with SMTP id adf61e73a8af0-1e5e079c48bmr72646157637.26.1735880535714;
        Thu, 02 Jan 2025 21:02:15 -0800 (PST)
Received: from localhost ([206.237.119.147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad816459sm26147861b3a.23.2025.01.02.21.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 21:02:15 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Subject: [PATCH v3 1/2] ocfs2: Check el->l_next_free_rec in ocfs2_get_clusters_nocache
Date: Fri,  3 Jan 2025 13:02:01 +0800
Message-Id: <20250103050202.825893-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Recently syzbot reported a use-after-free issue[1].

The root cause of the problem is that the journal
inode recorded in this file system image is corrupted.
The value of "di->id2.i_list.l_next_free_rec" is 8193,
which is greater than the value of "di->id2.i_list.l_count" (19).

To solve this problem, an additional check should be added
within ocfs2_get_clusters_nocache(). If the check fails, an error will
be returned and the file system will be set to read-only.

[1]: https://lore.kernel.org/all/67577778.050a0220.a30f1.01bc.GAE@google.com/T/

Reported-and-tested-by: syzbot+2313dda4dc4885c93578@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2313dda4dc4885c93578
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/ocfs2/extent_map.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..04794ac228d8 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -435,6 +435,15 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 		}
 	}
 
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		ret = ocfs2_error(inode->i_sb, "Invalid dinode #%llu: next_free_rec is %u, count is %u\n",
+				  (unsigned long long)di_bh->b_blocknr,
+				  le16_to_cpu(el->l_next_free_rec),
+				  le16_to_cpu(el->l_count));
+
+		goto out;
+	}
+
 	i = ocfs2_search_extent_list(el, v_cluster);
 	if (i == -1) {
 		/*
-- 
2.39.5


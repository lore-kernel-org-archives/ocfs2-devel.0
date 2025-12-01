Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C8D2BFC85
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 07:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764574568; cv=none; b=c464/zDMzCwAI02Hrqm4oOVdr+Vv6zfiLitkG1INPbkDXjdOEVIQ1Q6v6EeukZiWT6tGuuUxUlwhucX9wmLjpK1oIwNC30PYqSm7wJQ2GxFSKEik1JZ2dcjWG1UP7HX/g2VOES4OTvLsa2AGP7ijEaX5fbq3pTgsIwn4D/vOEw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764574568; c=relaxed/simple;
	bh=nMH63Z56zfzXEplEcwzH05DVa+x++79fLPO4XppCqHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qGAR9VUT5uBFVYCXohEe7/+iowH88Efn+xVZJ1PX9QBVXKYlaFzY/F8zzwGnuZfEb5l9JUaMTsmf02f0/8BAudbjEIxRURdqxrqk+83470kpqj2J7+jqZNrkXMICGECNRlAh/GV5FCe9W2t3M7fr8RVz0EVlhtgwWPCH3ZyScK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b70VfV1j; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b70VfV1j"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-343684a06b2so3678483a91.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 23:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764574565; x=1765179365; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLT0pt6hWb2B67LkFiPmXPfIwT4zlZdzrwjY8PVj22Q=;
        b=b70VfV1jTsOSVT6RZVi5IFcOvrTiqVbYqMrpBxPcpxnbwTy+wvFOmrOKNAMDaznnkJ
         pHRgAqzHLou1L4oYhVYLkRm/e6hsdQMKG2qHa6s+OsYFQuKmGTqV1WKoJusj+VJaRjhH
         6miPodX2Po5Yk5waC0Jo7Inzwq7Og76uNmObalnsPbQsccF3JXYcr8hPAf5f4Uh93xv0
         7fRf6dCAhHsFXf4U5R5sdQhLbbzBpaHAer/D4MwUZn3lO7869shbTBwCs4XSbSCfpeTB
         0+aOTCay7ojHbuA8AWcTE0CYI5S0PjRQxbGBOZd3zMVe1vTvEZkvyQm6ir3+DYhoVv8Z
         aUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764574565; x=1765179365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GLT0pt6hWb2B67LkFiPmXPfIwT4zlZdzrwjY8PVj22Q=;
        b=NxwNo/o3K0GqZxITvlGrN5d8laAwE6rnbYKVIeJuN6RU9kCQvV4ajS7+eNnuZi3s6Q
         tTE+qnaFmvvZEakfT//TFQk+XcveaM19VLqdl5ws+j4rVOJ3bByd24CB+6QrHuBeeb4W
         23fy97NnwRra0Luvi99T/vhziQlmgPz4pko9erVTIK4E/vcik53DoqoQAdq+LHnb99pA
         EvEL03sh4FObhtNl/EqejrFtAkzwSU1NDOIqNbUZ7N0yRFO5EE06yDnx+o32CKeNb4pg
         dvVUvqYa/ROE0K1q7qQcIFQEth/Y1Pj18+Svz/YNAUvL+L6gMDSuPF6JwPMHmLnfhM1o
         wmtw==
X-Forwarded-Encrypted: i=1; AJvYcCUBEU7Lae8mnAalajl7KtnysxBCW4Pn2Hu/dPJH1PVdTfVTsOegU3NcBBCoIb8JcVF69L59v4iY7MTbIA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2Mi55iKNQkceggpUbs+Da2u2wBOrLwUph+l/psTHaBl134GHw
	bV9E7cvfT3ohkY3mQe/LC6OAV2NB3BLlI2KCaFWqTBgK0b1+4TDdO3ui
X-Gm-Gg: ASbGncvF7QwG7Nf5M5YqjskzisPyPwEr4b/OfdQbQFVqWvSjln4fuIx2fPixyYkr2i+
	71taalg9edYqCrYzoCsDrzcB0O6XmaebYE7yq4RwiPH+TUwkuWUWDudqbxUMw8d0llrNwQIGp8Y
	s9K4hjJ25/dMIKXmOPLEabXPH1FNFQi76VariQ+4L8vIA+boYeVyBFwcLCYnWO+9buPZaJq5/zz
	us35YiCihVuXFvRNb5F7dqIkKK9OpXXrnRUwXCeWo/dEavCf2f2bIZrUd0tFOSSgbK6UnBrJPbv
	gjAonquPrOMl6ANwLLokMwpCuzXIVlmkJwfmGEUDuThKmlc8ahtd9ZZdBAYhiO5trDem1zILYVf
	MLbOc0kreIr67/em46ShJBYRKhUUs504H/zM7WWqYQ9/eXsAyg1tFU1lIh4Z5lKbL1+gLIHya2p
	QBS7LFrD109etjGPapl47MxdzSxmDFhDWwqX/h5w==
X-Google-Smtp-Source: AGHT+IHvaSToUZrjDyFtZY4DWr49mMEsEzOJr5YZg+cRS3dxBiGWZAaI1Zr5m1jJAp7M5LoSISNGHA==
X-Received: by 2002:a17:90b:5183:b0:32e:9f1e:4ee4 with SMTP id 98e67ed59e1d1-34733f2278bmr40210511a91.17.1764574565472;
        Sun, 30 Nov 2025 23:36:05 -0800 (PST)
Received: from localhost.localdomain ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476a560090sm15938123a91.7.2025.11.30.23.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 23:36:05 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,
	mark@fasheh.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for v2 for fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Date: Mon,  1 Dec 2025 13:05:38 +0530
Message-Id: <20251201073538.47128-1-activprithvi@gmail.com>
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
 fs/ocfs2/suballoc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..f4e4ef08e0f9 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1992,6 +1992,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
 	}
 
 	cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_next_free_rec) ||
+		le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		status = ocfs2_error(ac->ac_inode->i_sb,
+				     "Chain allocator dinode %llu has 0 chains\n",
+				     (unsigned long long)le64_to_cpu(fe->i_blkno));
+		goto bail;
+	}
 
 	victim = ocfs2_find_victim_chain(cl);
 	ac->ac_chain = victim;

base-commit: 939f15e640f193616691d3bcde0089760e75b0d3
-- 
2.34.1


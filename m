Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB553594D
	for <ocfs2-devel@lists.linux.dev>; Sat,  1 Mar 2025 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740840104; cv=none; b=e3awpq+ghU6+VKC2S0jnwb58LUXfUr8WCCuguh/5Sgoo3SDjcTXVcY3/5oA3qiCK35WUFe9tUu0gPH0/BfkvlueedbReBnEeRKGk0gwE+W2UfLgydffGotT8F4/lwFi1c7MC1B4qNIpqW0Slb3NVzF9xLzgHdEdQ/0LfbF2dl6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740840104; c=relaxed/simple;
	bh=iVyKzVfxR8LdP5by3NoY8zhrOtkB7jVDbkJlfjDY8OE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i33y+QhGTXfY+eBFUMVdcDqKH90N6ZvAnsxa7pY/0n0pQTNi74Rivh3Bsft9g1TgAuJumlUfif01CMu5UVjRVpEYQSthqTltJ9E3WE1ekV6Wb0osQyK1hi3BSsngAdX9G4c4DalRRtlQ4vn3HR4bp2JQmWl3SOKWBa00EHSIrQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kiplnksl; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiplnksl"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-390df942558so2401497f8f.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 01 Mar 2025 06:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740840101; x=1741444901; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XCZ2IYJ2ToIg9/KMdOINj9YW27Hjn4u6ydCp4dWPNz0=;
        b=kiplnkslCDdyR/x1Vrbgu7Hj5VXfM1n+zqxf1zoDgY4j47h5Au8VVhcb+dGFavXb7v
         +zKcYRoISDNvQTvRsSeZxK2W7WrjIjT8AXhqQBQhPwRiuiIYcO0OGpaOel4gf9DkJiKj
         9w3vAkCbgxHZOtAyIzpjPzttu15vEGjASYZWl7GuQu4a9BVZPJghtrYirpd3Tt4pCytf
         MbDJ+He6U8Jhu1JXJHs7igssnyH1sEONrM1Hq+5R5ThJ+Hiovb35av2zS7CBE8kITNNT
         HKBPVl4AJRIFM1tWHXRsi9wGAJUgzWsjSFdh33h8o+9P7bnfzpZqIbHpj+5rcuX4EXBO
         8voA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740840101; x=1741444901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XCZ2IYJ2ToIg9/KMdOINj9YW27Hjn4u6ydCp4dWPNz0=;
        b=o6+0nP51Nxh32ZdUypph9JC+Pcd4wMES1+br1LMNs/2HDnYMJKp7mRv0vvGxtOea1B
         XQvbGgFgu8aXbGRsacY/DwDwh0dmFMK9tSxvq+wPtTrsP4ClTNI2tHM66UBE28g/h2u5
         yCVs9sxEQ1B/FpXDtpsIUrvDT7BcmyZu9PsJqkpmk508WbCY14Mk2ri4jUB/19xQpvAL
         VNNtVoQjjzcSCW26/fcaKClTa9Lf7J2QUh6wQvAwHrzBJXUV1G0OxGNNXFuB0OFZnfIw
         jD4/nWkfECRpUH6RWQY5kENsr7isnyAsotgwmqGPdJSFxK67HQyE2cKv5wH8RxkUnYRl
         4XQg==
X-Gm-Message-State: AOJu0Ywzj8egVg/9XpjXT6EqPaI5mkfJV5wxRyC6FQMTRXVFRUmTNAWM
	6GXNG6dAB5v7mR6n9dKOxNhBJRIBIInc9mZdaqkZWjzwxVtWt/X9
X-Gm-Gg: ASbGncvAakH/D65Zolwj2KCIcYybhw7q7kCHEgY+s0V9ydLVv51mDzA3nQY3JHktGAM
	JhYQOazVGbpBv9WTFXEKJ4qs7zRbHDH4O9Yc0xxSI/izjuBr730HBHgK//1EZnmW45C83VgnC6F
	rUt+cacfMX5mraAkdreIl7AQRMwSiaRijUv7TbzdRiWRzO6KP9hba03MMGhISxyfFkT5+dqmGzI
	WlLJs+z6wNjWEUkyDT309nI0Uf1SZCkNcLLehbURoZBxsAgoBb+C0rEsdckdVQsV/WA63q7r2nK
	6lez2OPzLMl6r1ghfHDA0W85j5sfO5GsqRvencWqzfDlrXU7jvA9KhnU0Ko=
X-Google-Smtp-Source: AGHT+IE7BqfWKIc6fP9w4TydXM/STuAZnBVGkxNgCzpMCvHzilFb+OhHXakcpD6IR5NJpQlPSJwzCA==
X-Received: by 2002:a5d:6da3:0:b0:38d:d666:5448 with SMTP id ffacd0b85a97d-390eca52d9bmr7180064f8f.40.1740840100500;
        Sat, 01 Mar 2025 06:41:40 -0800 (PST)
Received: from localhost.localdomain ([2a02:c7c:6696:8300:913b:dad9:fe38:d4f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e4844a22sm8572051f8f.74.2025.03.01.06.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Mar 2025 06:41:39 -0800 (PST)
From: Qasim Ijaz <qasdev00@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+e41e83af7a07a4df8051@syzkaller.appspotmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: Validate chain list bits per cluster to prevent div-by-zero
Date: Sat,  1 Mar 2025 14:40:37 +0000
Message-Id: <20250301144037.45920-1-qasdev00@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call trace shows that the div error occurs on the following line where the code sets 
the e_cpos member of the extent record while dividing bg_bits by the bits per 
cluster value from the chain list:

		rec->e_cpos = cpu_to_le32(le16_to_cpu(bg->bg_bits) /
				  le16_to_cpu(cl->cl_bpc));
				  
Looking at the code disassembly we see the problem occurred during the divw instruction
which performs a 16-bit unsigned divide operation. The main ways a divide error can occur is
if:

1) the divisor is 0
2) if the quotient is too large for the designated register (overflow).

Normally the divisor being 0 is the most common cause for a division error to occur.

Focusing on the bits per cluster cl->cl_bpc (since it is the divisor) we see that cl is created in
ocfs2_block_group_alloc(), cl is derived from ocfs2_dinode->id2.i_chain. To fix this issue we should 
verify the cl_bpc member in the chain list to ensure it is valid and non-zero.

Looking through the rest of the OCFS2 code it seems like there are other places which could benefit 
from improved checks of the cl_bpc members of chain lists like the following:

In ocfs2_group_extend():

	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
		ret = -EINVAL;
		goto out_unlock;
	}

Reported-by: syzbot <syzbot+e41e83af7a07a4df8051@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=e41e83af7a07a4df8051
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
---
 fs/ocfs2/resize.c   | 4 ++--
 fs/ocfs2/suballoc.c | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..22352c027ecd 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -329,8 +329,8 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	group = (struct ocfs2_group_desc *)group_bh->b_data;
 
 	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
-	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
-		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
+	if (!cl_bpc || le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
+		       le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f7b483f0de2a..844cb36bd7ab 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -671,6 +671,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	if (!le16_to_cpu(cl->cl_bpc)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
-- 
2.39.5


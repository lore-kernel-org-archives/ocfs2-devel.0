Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565548248C
	for <ocfs2-devel@lists.linux.dev>; Sat, 29 Mar 2025 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743247045; cv=none; b=gUHAsYg506ScyfJ5LZVA7I18HYNwAQrbfJsGmxxd98U8ux8GrnoTJrNy5nFFrMVbMAuAFqlJuFJoHlvCDsO2uKhMCj1Vy3VzTFO4jiURuH14bMQninsRvDBc3SU230n38AWaeoiCYVaJBv+i29FECnWa7Vy5hS0GokHclpoFSos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743247045; c=relaxed/simple;
	bh=iVyKzVfxR8LdP5by3NoY8zhrOtkB7jVDbkJlfjDY8OE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cTlD8sj/VBGvpTc3FC95OjX3p/sf5K7GH5eiyJk45H31IKT86jY6scJ1bOfDFJl+BsCezc+kPh+uVfu4ZkoGzN2VKL08SeBEwoxTI7KEhzulDHmiW+DqlsPGNgvBo/imsfa61091AAUyJ2xYl5qgPi4/3u1Wl5UTOf6hIlpx0ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jr2RC6Dg; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jr2RC6Dg"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf257158fso21535395e9.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 29 Mar 2025 04:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743247040; x=1743851840; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XCZ2IYJ2ToIg9/KMdOINj9YW27Hjn4u6ydCp4dWPNz0=;
        b=Jr2RC6DgVkVpnJTv9xVvB9P9laf9tVHRcmcIrZsJN0MWi/oLBcQ0BWjXoiOA/LZ2vV
         3HT4dSvH/N7/MjbayaM9RKvnLmkIJsDXb0Hi7FQXTUVPvetOcfsVKGG7YtnSGWpNQ86Z
         2D53+ufzx1ObwxwdG3Fn0scsY9W85VKWk8M2qqZLjrjnB/8v+erULyvEDRdrBPpx4lez
         COng6dfwoSrym5jCKc9tQJY6dya/8O1jV6JQ0mYxotRd1PnHuqswSf7ovh4SRMDHRqZQ
         Pbh07Mz7L3yLgIHBotsCfhHNLlvPW0O2Fk6SIMlHLrTw3fO9BVKgcQ25OuAMN6tZOrzh
         vQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743247040; x=1743851840;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XCZ2IYJ2ToIg9/KMdOINj9YW27Hjn4u6ydCp4dWPNz0=;
        b=sAYQ/O3Lq2rU9Ws9HTvdHmNx5Phk15NGKYXWiwsHA3S99/YYZzBRsXSjBE59Au55KG
         TC9GpFmEWy7iWkCF4HNpjDdotQNEBMmBdMJNHwdtw0/wDMFVm5j1u/ksJ8cIu1raBPEF
         cWsnRpOnRaWPq3Y80VQMWq2ru+tEO455VfO/uy2KhLWD0cjVh6dHfyOKeUaX9xsQXpFL
         U5ORGqpOtXk0dJDc8CF2qEJ0aPAjNtW3mQvMfGzBs1kVXf0zxJIjKWr1Wqowh4aluy6H
         FhNkg/e2Kcio3jfS/JhRlGYmOT5gzMdJdiuNe6bMpY5uIitpoVeTdjskG+70T7f1D8n4
         DxiQ==
X-Gm-Message-State: AOJu0YzCRcQMgjaNN2+4ao7aLrhLC4i180INt7SaBHxMi5MtCAaJ7pXF
	vGSHlOGBClTNSepSdgNuIvZCzVwVOCu9D6YmPcjqcM9c1UwGZmWD
X-Gm-Gg: ASbGnctZeTihManrzrALAgs+OZ8FJkMkJuTiZae8TRqFrEadsVLhadJTpswvHtQ5Zmt
	nltixJg/AN/7w0kNSsbwL/ztomVxU5hxiK0EewAaRQ+p+3If3BY1JALS8KJg7ma3N7x0b8US+ux
	ek65iN5gvdjl7V2hditkgJCTPkR9qgEUJB5MgYgqrbDkWRmgZoczi4IVcuJS19D5QcEhO6RNmtj
	2UAf4Qom7bz+Jo9hn/DKTjDA8kYwxTNDdhA7838RfabNuCG+7KPPOJ+ul7fjk93g5WFZuY7t+Iw
	A/kg245FG8J2m19/YnhGA47xIJe5j+gHG8YqQsuOkaqIBg==
X-Google-Smtp-Source: AGHT+IGDbZteM2t+YPVw5ySzoBnXTQv1/QQFxNbONb1Mvy0uKs3/oMD8mkZWX/L6t/AP9Jyjt5WQWQ==
X-Received: by 2002:a05:600c:b98:b0:43d:16a0:d82c with SMTP id 5b1f17b1804b1-43db61d7b53mr27399475e9.2.1743247040450;
        Sat, 29 Mar 2025 04:17:20 -0700 (PDT)
Received: from qasdev.Home ([2a02:c7c:6696:8300:c564:b82e:4883:713c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8ff042bcsm57170215e9.28.2025.03.29.04.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Mar 2025 04:17:20 -0700 (PDT)
From: Qasim Ijaz <qasdev00@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot <syzbot+e41e83af7a07a4df8051@syzkaller.appspotmail.com>,
	stable@vger.kernel.org
Subject: [PATCH RESEND] ocfs2: Validate chain list bits per cluster to prevent div-by-zero
Date: Sat, 29 Mar 2025 11:16:54 +0000
Message-Id: <20250329111654.5764-1-qasdev00@gmail.com>
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


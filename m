Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFAF3358B9
	for <ocfs2-devel@lists.linux.dev>; Mon,  3 Aug 2026 03:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785726692; cv=none; b=TyJJGYcSXeBlHnshUnxckQ/E90rw9QuNAwyI+ouZ0UddVzykkMCxOL+zkRwzGTcJSNVL5hoNXt/yeks7Z9icIjf8yRWo9f99WLVfSaPQkOoZLVTl7i9+l0zy0DnIQEKPod2n5cAYn975dND4fF+2OUxuyaAPcN7ZmF80+plt++M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785726692; c=relaxed/simple;
	bh=0jxhpiy+to/ITrgWlDtmvBfGJrV5Jq/iRYsgjH9IhIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k2n6AuU86IyoIUVNRjgpBLdsi6k0ayiWQwsY3GZBj0LscYR2TmOm8ojy0DPkaQpnOza8D5CKGR8ZogTfei4CHJKk2HShCqDQHHtLGfPKbN2Zi3V838z6EeDZGQINl4Rgx8pDn/m/cssMZFUYYihTnwBJIF3HsU3GaH/RsUn93fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUKZ8prO; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUKZ8prO"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-848479c9bd5so2309257b3a.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 02 Aug 2026 20:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785726690; x=1786331490; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r/saykZZ/5vcW+2cy8muslZqFNi+RNrcC1xh2TUTBUI=;
        b=nUKZ8prOdK8CmajGAthUwqh7g+9CUSeTaxifRT7I+j4bQpU+mXCejcDYGmboB9ZJlm
         P26cvek1EmzIs0nXIl4Je72pYtVQ5QFRH8OXXRn9rTVZpYlhwhp6BJsvS9i8Fzr9kYqR
         2yWiPQeGt8f9IlJTO2qwRNTqNWfAgpbtZ7BUSl5W2NmRi/4V+kzzXWuKAnnuGVSq2kR7
         Pewp4yUARnInQbob7gXTKPXLAB5q+CEUa2MBLUrJZEOn5DqPphXPqln7RMT6oOtjAhC4
         16utJi1pXO+HX3fHInk1ZwG1195pQOGTvJdmKCA7LqbtW00h6ipNVXvxjJLT/m3lvyMS
         B0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785726690; x=1786331490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r/saykZZ/5vcW+2cy8muslZqFNi+RNrcC1xh2TUTBUI=;
        b=ItdQbmaR+FN1vwcWXMG1vWFbcnh5pQ411ON4zrDz5pbpc+2UB3N222CWltVuRqg9AK
         Pv/a5itHKv7GqPZTziEnrJmGrA+whCWoy414M4W0WSdTkJFQHOnYREr52bMpS0uLlTkC
         PUynjqZ7pPH83TWo4C2YUHd4s/nTr9tHCy0vNglSnPfPuaLW2XqtuEJyNcgK+B49E+vk
         tMumN9NOImo3LLZHwABCAVhVzH+ogfyxk9PfpQmyYLPXnBvGgMMYFd9fcPsbVClAtn0q
         CwyPWVHG7+sA/3ZaKT97z7eDWKv7aL/1vlAcFlxmetnj/fZK73cro1qrKaboN14RRg80
         FdgA==
X-Gm-Message-State: AOJu0Yy+F5jfeXxPe7uD99P8klTt6PmdtDUQk8YMWTfZjZBRdnkG/PF+
	9AoySNYKUuOVTrZPlQMq3oi+cFXzL1JuYZ8XdaEzPe4rI4btur9C63fB
X-Gm-Gg: AR+sD11kkZHqzltZ/ZwfYhSRYX0JAI5W6a+kARINYU+n4IPP2a1tVgHFHdikDFVLoU8
	GIR4UQKTi3v8zTay6HQeBQ2Rt7iXnxiFrK+KzTlXgWZGcYqyIVu5Yv45YO+XoOHyagFJ/4qXkfw
	qQbnzBBbp8WM25iIwQ5KOcpTgVuXhOhUELSlgCfD/UOQ+xwVHwNHh+P8hNzep+e6fS4gRURlvmN
	TU/pezPE6BcM9vb5Sgdw+Nodw68uPqjlAJtFiNdIT8b/qEt2ZYuNX6CdR+ldUjLnXcWAs8DXCiB
	lJ4jJCJ2CA5OjZN1ksBYYUxD7f29bjNJo7Jvei/AbbseqxIoZ7puClrzaB73wfklv7xUiAMzxyK
	/dxDqaN7WafardkUoUoBhfjrkm6SKfCcDBQtFL1HDP2SMFOAU6wsr4wQaPOQ1MaTMuG/zk7BP9w
	em8yPl4y9wkIdIYa96MQ62A8fiSj/0zXN+w838YSwAPJ1Ccy31EvyWePYhbjO/KIKwDp2udynbF
	rVRkZzgIudlakxkH+JfXjG4WJ2tDg==
X-Received: by 2002:a05:6a00:3d12:b0:84e:216d:7e52 with SMTP id d2e1a72fcca58-84ee479b0c4mr6605134b3a.14.1785726689723;
        Sun, 02 Aug 2026 20:11:29 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe39ea0a73sm2979886a12.23.2026.08.02.20.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:11:29 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	tao.ma@oracle.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	tom442288@tuta.io,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: validate global bitmap cl_bpc before resize
Date: Mon,  3 Aug 2026 11:11:16 +0800
Message-ID: <20260803031116.3994362-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted global bitmap inode can make online group extension scan past
the end of a group descriptor bitmap:

BUG: KASAN: use-after-free in _find_next_bit+0xef/0x120 lib/find_bit.c:157
Read of size 8 at addr ffff888021b52000 by task syz.0.34/409
Call Trace:
 <TASK>
 ...
 _find_next_bit+0xef/0x120 lib/find_bit.c:157
 find_next_bit include/linux/find.h:73 [inline]
 find_next_bit_le include/linux/find.h:518 [inline]
 ocfs2_find_max_contig_free_bits+0x53/0xb0 fs/ocfs2/suballoc.c:1292
 ocfs2_update_last_group_and_inode fs/ocfs2/resize.c:127 [inline]
 ocfs2_group_extend+0x83e/0x1ae0 fs/ocfs2/resize.c:350
 ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 ...

[CAUSE]
ocfs2_group_extend() trusts the global bitmap dinode's cl_bpc value.
If its high byte corrupted from zero to 0xc9 makes cl_bpc 51457.
Extending by seven clusters narrows their product to a u16 value of
32519 and raises a 2048-bit group to 34567 bits, beyond its 32256-bit
bitmap. The subsequent maximum-free-run scan then reads into the next
page.

[FIX]
Reject a global bitmap whose cl_bpc is not one before using it in any
resize arithmetic. The global allocator has exactly one bitmap bit per
cluster, so this validates the invariant at the cold online-resize
boundary and reports metadata corruption instead of enlarging bg_bits
past the descriptor.

Fixes: d659072f7368 ("[PATCH 1/2] ocfs2: Add group extend for online resize")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/resize.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 6375d5035972..556aaa319621 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -311,6 +311,14 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 		goto out_unlock;
 	}
 
+	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
+	if (cl_bpc != 1) {
+		ret = ocfs2_error(main_bm_inode->i_sb,
+				  "Invalid global bitmap bits per cluster %u\n",
+				  cl_bpc);
+		goto out_unlock;
+	}
+
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
 		ocfs2_group_bitmap_size(osb->sb, 0,
 					osb->s_feature_incompat) * 8) {
@@ -332,7 +340,6 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	}
 	group = (struct ocfs2_group_desc *)group_bh->b_data;
 
-	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(group->bg_bits) / cl_bpc + new_clusters >
 		le16_to_cpu(fe->id2.i_chain.cl_cpg)) {
 		ret = -EINVAL;
-- 
2.43.0


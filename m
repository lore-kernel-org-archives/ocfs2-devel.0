Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B2472639
	for <ocfs2-devel@lists.linux.dev>; Sun, 26 Oct 2025 13:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761485195; cv=none; b=cmWJweFLXkOpcxZMcviHWdCBdKMwgJVK4IRa3uUxX8xHeOG7go1fD0lUXVDCc+MlRZsi2vBlNRPML5vVrUK8J+v0w4UFDApHrFmAoEdyT9wsQUdwDYy84oDtBpZgrklMi0mdLV2CvMJrd8yBsXozxT8CecwXbh5NFkpkqAjdHiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761485195; c=relaxed/simple;
	bh=JhBg/DEYtFnFZiVEkgExHhvzklfayDTyXLhykAU3v5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sBfMFocUy+VDu6WmcxINYamYj6nJ4OHMJ1srdvl4DfG5baS1an6NxyfAuSuYI1JlYf/bijjou8xrx0l3VrCb2TNPpRjKZa1qgrP/iNcOTzfP6ZUAySe1yflytf2/zWPzuJ1aj1ft3t3qr1zZ8b1wH84CbPhixZ4ZixbwT/axY0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZUzfRHY; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZUzfRHY"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33d896debe5so4254028a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 26 Oct 2025 06:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761485193; x=1762089993; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IvVdsjYVtY6FXc76drGJeGdtb/RwYklmlZOHVZSsLtA=;
        b=cZUzfRHYniX3wOFrJcCxil5T11+cJX3XkcSIF3w2G9HPa7zhDbJq9e0LeOBQGsHDhH
         oqYFvvcXkytF6Xeieq/HLRcB9l8CGglU2+Tu1BwISSyH9X3sWlsUzMOP3+wLEWRrPydT
         4YgD2P0X8SyLCVQ3R83c7ytmP7G8TQRpefGuGRnl4dAY1pEtU68CX/fkBDlMe8p480zX
         EujXIVZFAiDtygpfBvYVMb5fIy+4EqkiNA0+jk2XdLbtTJHifTPcum5V+VVoQ4n+ntHw
         G99bSQZ/A0466xQsYXqP1b6SlfHO85+whBhRU+fszsk9rBe2HaZKUOdhQEcPL+ehCzzp
         ctiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761485193; x=1762089993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvVdsjYVtY6FXc76drGJeGdtb/RwYklmlZOHVZSsLtA=;
        b=YnsOuGvRR+M4UR/Iva8XvpwtwJ6rfg0ADWotjeZXrxvro55gvEQe64UGvAtknkrtcu
         8LVxKwpTIQVjmKCkIrI1uXyfeO5dA/9n/EF6bKuIbfAX6jCJgsi+nAUH9Ru6HevqUzyP
         4pmHx/CynbTdV6nmdL3A6Rgux4hIztcufG/ptWZKp+mZsIGCMC647/bm5roqB3BrAz4l
         Ojf0VNcxMBaAWlzEil2kMVBQy4N072JxqmQqTBcmY/L72k/o+5yF7cBVyGl6APMwdxFr
         zRGhl5gBoRdVL47kl6BUkI3a9MPv5eH2+Hv6Sufn8kVCqeWkGZT4Sy/VTmzxqXFljHIO
         YHiA==
X-Gm-Message-State: AOJu0YwBfK+FvEaeHCFhulJCJlfuIXdfv/y597Q2HpuXY1qn9GuuCZXz
	DL6+9zlMmfeObs/irAo+WiUPVfLZ0fpj6sIf2bAXv+a8Opl1a1S4W9jp
X-Gm-Gg: ASbGncu1D/F42EPQBuxBX/Rg2AnsMSHOCJSPfDvGo5G863kl3J2I4my87MdyR7b7qqT
	AomJay7jKNaIwxwzFCdH5EUtG7/VE1Ic32ldUvJzTizVR6fHgsWVv6HkaiiX/uUqeBz3rRwZFYC
	Qi6HZPptOukqX/jZDghQlEOtnT0IEkbGXh0ZZtm/oqddBhLx+Vz/gY7ICiDbik+Eg6rzIqGIcrX
	JszX3SSneySM5DDsH8fP1IF643bJD70hlF7P8lrHtyq+qw5VM8l9C20Oyy9tauzws06wpMDRg2t
	Xzs4QxWxpw3A7lOulh3bxA1TPvnWUoGINnU1SdZQ103GRN9MbakDmXEnSPhfO9xVFoxEVjRK50T
	/mDYB9G0LT7xNJ2QbKBmOXEo6I5zS1vdmU+YwbsdnO9Hg3U8tUbf+kUiSW1sQ448OpWLjm82tRg
	TliCgSVKrXc4uhcmOu61Fxg9u3rWp5QVAq5pI=
X-Google-Smtp-Source: AGHT+IEfSgoONaltrGxb9fBnmRXofDodRrDKu8WknVv+/bnHYU+2XnDqJZWq1FrL2wLBBvbJsoIF9A==
X-Received: by 2002:a17:90b:17c3:b0:33b:ae39:c297 with SMTP id 98e67ed59e1d1-33fd6502cb7mr10730797a91.16.1761485193038;
        Sun, 26 Oct 2025 06:26:33 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:18af:8c3a:faa4:5c0a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414069164sm5060678b3a.45.2025.10.26.06.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 06:26:32 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: validate cl_bpc in ocfs2_block_group_alloc to prevent divide-by-zero
Date: Sun, 26 Oct 2025 18:56:25 +0530
Message-ID: <20251026132625.12348-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The chain allocator field cl_bpc (blocks per cluster) is read from disk
and used in division operations without validation. A corrupted filesystem
image with cl_bpc=0 causes a divide-by-zero crash in the kernel:

  divide error: 0000 [#1] PREEMPT SMP KASAN
  RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
  RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
  Call Trace:
   ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
   ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
   ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
   ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306

This patch adds validation in ocfs2_block_group_alloc() to ensure cl_bpc
matches the expected value calculated from the superblock's cluster size
and block size. This validation follows the same pattern used elsewhere
in OCFS2 to verify on-disk structures against known-good values derived
from the superblock parameters.

The check is performed early in the allocation path, before any resources
are allocated or transactions started, ensuring clean error propagation.
If validation fails, the filesystem is marked read-only and the operation
returns -EUCLEAN (Structure needs cleaning), prompting the administrator
to run fsck.ocfs2.

The validation catches both:
- Zero values that cause divide-by-zero crashes
- Non-zero but incorrect values indicating filesystem corruption or
  mismatched filesystem geometry

With this fix, mounting a corrupted filesystem produces:
  OCFS2: ERROR (device loop0): ocfs2_block_group_alloc: Chain allocator
         74 has corrupted cl_bpc: ondisk=0 expected=16
  OCFS2: File system is now read-only.

Instead of a kernel crash.

Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/suballoc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..9f3db59890c3 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -667,10 +667,22 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	u16 alloc_rec;
 	struct buffer_head *bg_bh = NULL;
 	struct ocfs2_group_desc *bg;
+	u16 cl_bpc, expected_bpc;
 
 	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
 
 	cl = &fe->id2.i_chain;
+	cl_bpc = le16_to_cpu(cl->cl_bpc);
+	expected_bpc = 1 << (osb->s_clustersize_bits - alloc_inode->i_sb->s_blocksize_bits);
+	if (cl_bpc != expected_bpc) {
+		ocfs2_error(alloc_inode->i_sb,
+			"Chain allocator %llu has corrupted cl_bpc: ondisk=%u expected=%u\n",
+			(unsigned long long)le64_to_cpu(fe->i_blkno),
+			cl_bpc, expected_bpc);
+		status = -EUCLEAN;
+		goto bail;
+	}
+
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
 						   max_block, flags, &ac);
-- 
2.43.0


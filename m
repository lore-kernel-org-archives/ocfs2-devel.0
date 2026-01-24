Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DB1946C
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Jan 2026 05:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769230895; cv=none; b=E7QZCWQ4J5hcFjOwwDVpY8j3zSfcriK74AbOg1p8rlGj892faNk7eKWKWR/j2R2hT1tD0WuITfbupOiP/o4bEc0deoKTj8xHjgnE4fWg/sq2raAvPi9naTkuYQw6Xk4BwBYXjQKoFr0Btj7FEKtxZPj8a3pYSC+XhSjz/p8afwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769230895; c=relaxed/simple;
	bh=NuxKESorXkkj2kfNbIrVK8CRosZqJ8200rvI2f4jcqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oD2UeaoPYbQ6h3/jbBfM2lcFYhEK5mWKIWUvEJXwEhpo71kikFiudU88sOP57uGokp54O4+jNSMHHlxARZYs/8zC0V+v6yHae4LVQk1CcVtiQuY2DHbjTif8MKCQE4beMrW/h+Nycra7niJxztOYm4ipJaOzJlxPf2vFO0FNxDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BeOaldwm; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BeOaldwm"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82311f4070cso1150492b3a.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 23 Jan 2026 21:01:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769230893; x=1769835693; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E2YX76ut4F4+pCFown4SbvAuNnVLkheLVcPXYOrLSEg=;
        b=BeOaldwm69RS1J8CGEmfhbI7FncdMqVT0QM20tPDmoGmfTbNV5hZrye5QidllZuB10
         bQ8HmY4Zwe6yekLOH8/RYdDgih/eS1IZ7Q5PSoLPkXbbXXqYJOSTFz9WgouxkrT1zu9k
         naO0UE1NyKuBVdciGfmSTKxng+dlzWnLPG9MLKXMQniwPVluKT07R7WJXn1cXi5AszNe
         zfCObmdK0bYHUZjnt1FfletfF5SdEzvFyysDg0Cd4WDmixlvvw6OQORQggv6Q0NS+gRN
         TDh88JUQlArDIjPykb3ejTPgQM5pWUgXoDCvl5SpdS78YuXygx2dE/zWi5WRJnI9kw6d
         XFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769230893; x=1769835693;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2YX76ut4F4+pCFown4SbvAuNnVLkheLVcPXYOrLSEg=;
        b=PzXvVitu439A+zAh/2BW8J7BT7VV7kNV7AuL15eeG6UB/k70sHS21gJ3NIOCD+13Go
         V9kUunMkDtPWoun6z6U7/VqU8QBjxSK1NN220LMMfBBvywaMIyFiyHtTp8mfdZEJubXw
         lbiGiPnNTn5ml8ZzNyO9JdHFoIM9n3siuJ+2IQ9X9LwteByL2vg+9aXtdNHVyo24YJFq
         u210jmCWczFOFLk01/oma+4OBIqMxeJOxLy8lihImnCq9AcUTplUW5mTUnACW0gbljPH
         Oe5VO2nWPriqfuv3OYFKnYX8ZmjgHTlxAnpmGcUIWaPxXX9Y78EOQ3SBC4laVQGcy1XV
         dGRA==
X-Gm-Message-State: AOJu0YwLQBGxaJU+0UQl2Zou5agk2K7TQhdX+LJhlA4EdWxO+v4Yoq1N
	wYLmCQ+8bpcQDgFb1o9qUEDobJb3r8DSgRaiKRVh63CjbWPnNZYau0g9
X-Gm-Gg: AZuq6aLxBI0IDGEwhcgtwwpR6O0fcY1gCv5xIli8+U7Jq4w7PsYoKDlkvM/E/+oThFv
	S09JXUG3zNFNLb74xID+BbRRMAJrz+bXp+KjV7ps6hxGyWeavu0p+XSQ2gkomqNSW0P0qHIZ7Mu
	QvMFog8h5+mI+cjUaUM2r9h2Y2kTt3adKF8hwYZA1ZESn1yzXmhsaoQTOGWjFwAI9SDkH4I/22X
	qB8fCn/gBcyYuNknXolOTFzAyzjeVRrJIG62Og88VUQx/785r4MagGATi/ZIwm7JAA/2QWBekbp
	GkjCKSNk8OaWqxJ8axauavpTDsc3wTQcxzyVI/1S80W7Nvq21HDSnfNFjG/bJO8IJ4EnLkoS6rR
	smEvcla6wUg/jbcFDo43IFLi/8E1lbHdPJgXPxsfLgBKRJTICrC77tzoQkgr8EnKMjP1mj5kG2Q
	X7t3RqPN6GJkIPFDF6DmgeGIMtbbMBvAa9jTm90wKsG/Og3EJ5msGmSzyM5K8qFmGKBWY=
X-Received: by 2002:a05:6a00:1823:b0:81f:4e1c:1d3b with SMTP id d2e1a72fcca58-82317b304c6mr4649165b3a.23.1769230893292;
        Fri, 23 Jan 2026 21:01:33 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:db06:8149:7b0d:66a3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231873e632sm3546744b3a.46.2026.01.23.21.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 21:01:32 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: validate i_blkno and BITMAP_FL consistency in ocfs2_validate_inode_block
Date: Sat, 24 Jan 2026 10:31:24 +0530
Message-ID: <20260124050124.27926-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_is_cluster_bitmap() checks whether an inode is the global bitmap
by comparing ip_blkno with osb->bitmap_blkno. A corrupted filesystem
can have an inode with i_blkno and OCFS2_BITMAP_FL flag inconsistent:
- i_blkno matches bitmap_blkno but BITMAP_FL is not set, or
- BITMAP_FL is set but i_blkno does not match bitmap_blkno

In either case, ocfs2_is_cluster_bitmap() returns incorrect results,
triggering BUG_ON in ocfs2_block_group_search() or
ocfs2_cluster_group_search() causing a kernel panic.

Call trace:
  ocfs2_block_group_search+0x1c7/0x2c0 fs/ocfs2/suballoc.c:1611
  ocfs2_search_chain+0x38a/0x1010 fs/ocfs2/suballoc.c:1764
  ocfs2_claim_suballoc_bits+0x3a4/0x650 fs/ocfs2/suballoc.c:1978
  ocfs2_claim_new_inode+0x95/0x130 fs/ocfs2/suballoc.c:2137
  ocfs2_mknod_locked+0x129/0x510 fs/ocfs2/namei.c:568
  ocfs2_mknod+0x5c7/0x11d0 fs/ocfs2/namei.c:802
  ocfs2_create+0x136/0x170 fs/ocfs2/namei.c:852

Add validation in ocfs2_validate_inode_block() to check that i_blkno
and OCFS2_BITMAP_FL are consistent:
- If i_blkno matches bitmap_blkno, BITMAP_FL must be set
- If BITMAP_FL is set, i_blkno must match bitmap_blkno

This catches corrupted inodes early when reading from disk.

Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1
Tested-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260104014028.305029-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260110054443.604944-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v3:
  - Move validation to ocfs2_validate_inode_block() to catch corruption
    early when inode is read from disk (Joseph Qi)
  - Add check for both directions of inconsistency

v2:
  - Fix commit message - ocfs2_is_cluster_bitmap() checks ip_blkno
    against bitmap_blkno, not a flag (Joseph Qi)
---
 fs/ocfs2/inode.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b5fcc2725a29..2d80934d14b4 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1529,6 +1529,27 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	/*
+	 * Validate bitmap flag consistency with bitmap_blkno.
+	 * A corrupted inode with mismatched i_blkno and BITMAP_FL would
+	 * cause ocfs2_is_cluster_bitmap() to return incorrect results,
+	 * triggering BUG_ON in ocfs2_block_group_search() or
+	 * ocfs2_cluster_group_search().
+	 */
+	if (le64_to_cpu(di->i_blkno) == OCFS2_SB(sb)->bitmap_blkno &&
+	    !(di->i_flags & cpu_to_le32(OCFS2_BITMAP_FL))) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: i_blkno matches bitmap but BITMAP flag not set\n",
+				 (unsigned long long)bh->b_blocknr);
+		goto bail;
+	} else if (di->i_flags & cpu_to_le32(OCFS2_BITMAP_FL) &&
+		   le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: BITMAP flag set but i_blkno does not match bitmap\n",
+				 (unsigned long long)bh->b_blocknr);
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.43.0


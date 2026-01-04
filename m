Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FBB30DEB9
	for <ocfs2-devel@lists.linux.dev>; Sun,  4 Jan 2026 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767533715; cv=none; b=hfCDI2VJxSjWD7d4abr5uyTqXi1vzzjt3qqITYG5gaKZJzbTJlzJMl1Jk6qMwRKGsNUkFa1t9OZrgG71eDBZ8hvnR1m05EuxXEHo22osuobU9XGwu2/NQpercCQww2A6rvnX4wJpJGhu4VSSxL14NtYdmBAf1tx+th5nA5BtSjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767533715; c=relaxed/simple;
	bh=gsITpUOGdQDLvCVOzdeUMZ3zpJsx1qlz2qHxo5nVveo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lkp1e/QYiRk//WA8D/q7WbLDPJ8fQ0goB6iriC4NWmIBtUdbjl/vRuhHSrgI8fBKQStHMNBwxkM1cYl6YiO08RkgWmCOLEIexF622P5tay0JBrFWkpgobAVadlvR89aE+xfIE0cgOkrRG5fE5Cb8vIT6xFzyYTKnVUbkl41tpL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IDroqPIv; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IDroqPIv"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0c09bb78cso7549975ad.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 04 Jan 2026 05:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767533713; x=1768138513; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2BBSlS/sUmpDgECm0JFuorFD0hPkfViLXKE80/Mz72E=;
        b=IDroqPIve6uP1y5/S0d6iTHLxcb7FE3oN1JhycZ8wUUn9SOs/WwL2JNzAsQQvtGuEi
         RLAFheZ8uG1qhfAi4qozNzOhvNRA8MG4H0V107g7xfiwgLy+p9rjEjoiVXzpN07tIK14
         kZpNDx64CGRibtUH6ZUYVqK7JoGOIYaIIOzEBeDPy+lcV4plf64pb4GYXnKdv6/dcY6a
         mTsPIDR+ybIU9QVXmwfLA8Lc0Sb4ut/E/2BrKdsldt+PCCy40oBJtiqXsPGEDIyqZGki
         dow7HEjlypBYPgW0zmOQvNPhUdPOEcWAlKp+ctBFroj7g1pJUiOSzrYPNUV3ZLyn8OOF
         1AKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767533713; x=1768138513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2BBSlS/sUmpDgECm0JFuorFD0hPkfViLXKE80/Mz72E=;
        b=nBV9t3d1RUmtQUi2vFhHApDZ+WAU41p7lveM/BfDXJeLuiU0ejmpuCkOi01zxXxFhH
         Lph29wYa1Yori+06rOIRl+c9YtddHjZYT7bMGml8/bnWsUCejq86hCxlg54EWUEVaDAr
         Hg/+4Mf4dJkvg8i8AqplujQL11WDvZKT9KyBP/kGsXxeUDqi9sA25e9ERV/lIdAaFjiA
         0lk2VT6NkR10X9x4Apqj7f4MXxIjUqE8wuHy7p31CLnhw78iq+4hh5axzTVMskYbgsyj
         bESALmBePpPRueMbHBpYL4duCryU5z7W6jhI2HQtLHlCPPAZ96tYDo+jx62Fk59AhOwI
         qMBQ==
X-Gm-Message-State: AOJu0Yy7C9/d6s2DssH4KnBX6N8dZeeNgfX1fW7ACcc7CK1KEa1rvFpU
	cZsqtmagG9cYq6jGw7/vlH746uvqn3czsPD9R0D8aWJDYZg9f9LG5tXS
X-Gm-Gg: AY/fxX4p67E2gxy1Dn3kmsRRJaRIFn0h6gk5pn3+vw75zC8MW6gd+zdvgAUV5yJUILd
	Vy5bLw5oJxW7rRJBck0ZYyjCqDn63ze/WdpIS+98Za+iPn6Yp3UndRl/FHBOAcP5hGx6jV55aJr
	9SIJtcX3HMsvIPCFW7Sg7auYOxcU1mmkq3TlzHIZACXLvxro9e4/ZjGklEh4ARGjQeBTRqK6tvf
	mpv8YOj6GDx4SN0ovc7v3jBsYgmr1bpAvjzWKqIZfop2tKbshsoT8X1KRPXgRp3i0hCNG3ebDFW
	wBL2qApfwCKmdoQTNELVtbzCSh8L8jdKVwmhKmDocF/gGT9tbc0fV9WMzNOVeZXhv5rJqm1383d
	IBk28VDqndSDdpAEzrDYoA8GIVcgYZMl9NNko82i6Cxm4PCP91miz5lGN6Wo+Mp1HoUWEqHE9FO
	S1KWjvYsQjpygukZuoTfCwZ2R9qYnUDmK2OWRM+cEpzOiYGeV4IYsvgGz50Ie5cMxU694=
X-Google-Smtp-Source: AGHT+IGIlOvMhqWcVXHVVnRdmo2BxUI7PrzIbxyarhVVyfVzGIbsKISoPxKEzukQ5jH+92p+2N1zcw==
X-Received: by 2002:a17:903:1984:b0:2a0:d0ae:454d with SMTP id d9443c01a7336-2a3c09b7ae4mr40296305ad.22.1767533713379;
        Sun, 04 Jan 2026 05:35:13 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:3d5d:94a5:a074:8109])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm429756545ad.63.2026.01.04.05.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 05:35:12 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+7960178e777909060224@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: add check for free bits before allocation in ocfs2_move_extent()
Date: Sun,  4 Jan 2026 19:05:04 +0530
Message-ID: <20260104133504.14810-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check to verify the group descriptor has enough free bits before
attempting allocation in ocfs2_move_extent(). This prevents a kernel
BUG_ON crash in ocfs2_block_group_set_bits() when the move_extents ioctl
is called on a crafted or corrupted filesystem.

The existing validation in ocfs2_validate_gd_self() only checks static
metadata consistency (bg_free_bits_count <= bg_bits) when the descriptor
is first read from disk. However, during move_extents operations,
multiple allocations can exhaust the free bits count below the requested
allocation size, triggering BUG_ON(le16_to_cpu(bg->bg_free_bits_count)
< num_bits).

The debug trace shows the issue clearly:
  - Block group 32 validated with bg_free_bits_count=427
  - Repeated allocations decreased count: 427 -> 171 -> 43 -> ... -> 1
  - Final request for 2 bits with only 1 available triggers BUG_ON

By adding an early check in ocfs2_move_extent() right after
ocfs2_find_victim_alloc_group(), we return -ENOSPC gracefully instead of
crashing the kernel. This also avoids unnecessary work in
ocfs2_probe_alloc_group() and __ocfs2_move_extent() when the allocation
will fail.

Reported-by: syzbot+7960178e777909060224@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7960178e777909060224
Link: https://lore.kernel.org/all/20251231115801.293726-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
v2:
  - Fixed missing '<' in commit message (Joseph)
  - Moved check right after ocfs2_find_victim_alloc_group() to fail
    early and avoid unnecessary work (Joseph)
---
 fs/ocfs2/move_extents.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 99637e34d9da..c037fb34b1e3 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -662,6 +662,12 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 		goto out_commit;
 	}
 
+	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
+	if (le16_to_cpu(gd->bg_free_bits_count) < len) {
+		ret = -ENOSPC;
+		goto out_commit;
+	}
+
 	/*
 	 * probe the victim cluster group to find a proper
 	 * region to fit wanted movement, it even will perform
@@ -682,7 +688,6 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 		goto out_commit;
 	}
 
-	gd = (struct ocfs2_group_desc *)gd_bh->b_data;
 	ret = ocfs2_alloc_dinode_update_counts(gb_inode, handle, gb_bh, len,
 					       le16_to_cpu(gd->bg_chain));
 	if (ret) {
-- 
2.43.0


Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232F33CEBB1
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Apr 2026 09:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775035402; cv=none; b=ahx8QOYnU+Okffg+ZezRb8Ui0JqzLT323g0BQlZQUjtSNMOSOGQeZVaQmNrS9Z5H6uhmgLN3Ij336EMYC5v6OIJ4NqYx4z+kqpe38wKoaDfYnraxMhaYgzEhLm1NnVlrUz0IKaQ/q4k/yncO4p120n4iusSR8buGLsbNepccLDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775035402; c=relaxed/simple;
	bh=Iyb08bR1EKI5CR+3yx4hDlBhnzcgq3vDsYkqTe7ODpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sbtoqzpd105kqygYG8v1aqLCzJiPGLrMJJ3z672VzLtmcT4C72Ku3YhtbK9q8M9+KJxaMd66JXcz+YmOzYO1648sajEjOsQpCw+zT506n0610kK9S1Hk0xmyXbrsjdaRO0IoYQpRjx28XvuHFIVoCiLPVpi2FanD0W1GdUXobk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdpI6sBO; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdpI6sBO"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso3311802a91.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Apr 2026 02:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775035399; x=1775640199; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7aS3Bgq6XLNZ+UJEINrYzINd5Eyqo5xjkhdUwm3+Orc=;
        b=LdpI6sBOMNC+XPEhlyh/QDdb9r99c+7qjiJ+tD498N16m+eaIuf3eFA/QSPRGOioyA
         sLPFi2cUNX1UMOTF/h2JUR2Tz7BqsRjQ0SLFmMYqmFATheKnzbrq/VDSgVfWvv99l+Xk
         rxioTnu6Gh7csxlrF8IW2GkDz022kka+l4YyuXb4kxSADymrrHrFUulCRaKLDMZ/luGt
         7ws18POp20f+MYf8ArzppQIIUsUTthvNCtsAPviTbX9ggRMGZlKQFdorrYIixd2uF9Y8
         3/mWntA6S4KOtKiHpWzq92AbHmgwCn4LittVvqLsJkv+qeMBZIKY1ogO9xC2SBESemm3
         Yc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775035399; x=1775640199;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7aS3Bgq6XLNZ+UJEINrYzINd5Eyqo5xjkhdUwm3+Orc=;
        b=oyM1kkTXmRwbq1mTrtQdHc7K1CF79WZvdC0enb4oJC6g7f8N/uzAgevK5QsZT3zmvL
         e5zsIgQ3K9obdllzjBpqWGrMv2EjF4scxkr4y6dZRMfIvw1oohh/5Ve74brxYtKI5S4X
         i0oNhleeg1k0pLeyrBIyxm9vNO5Tuv4pHr0MMHBv41NvMoCAVvxTIBb7FSJXK6Itq9EL
         bMmt0X9BbKcYN3kaMIum0XQOscJufDEjLzl9K2A8aMzaIb9lqawHt73++PcglGKQFPz9
         AQqewF6Ee8ynx1nNtFpn0Hf1kZJwi3bz9STJ3RQOw/GEy4xqEDThQqrtRjVC3KeSt8UF
         0BKg==
X-Gm-Message-State: AOJu0Ywk+wm8MUGHyFNATgSsDUFfCu+bWHdkxyc6iToEMBgk8ptdDLmR
	oGRPOy3bmP6jUNbmM3cIAdyPmdUmhC7jXFJp1BtQ8+aLxuX9sL+bp/6U
X-Gm-Gg: ATEYQzxbBA9rXrGKwxW0bDpUAF8r2OexTuxSyVB1ZKmZ0lWQAvLYzddTdBRutKMfcKQ
	591FUj0JJomqmwPSQCMFhdu+F7A1tMZZHYooQsqcRtWW/xv4S5WMeIwH4Fg5FS2GlKlV6XDVQNe
	oUSvZ7YSeFN3knCgH967EGRzam5nHtCJzh0Yd68UC38y6/FtcB519ZJQY6Ax8uFb5oYu5A88O+/
	DroPBh2zFWzKt6aa+OJ+0aAHuomz5ydNad0IgX5JOCSsMNa5GglLByHC3EosNohkrbH+Xky1PvW
	dsr/IhBeZWmmylbbOf5JTWuWEvk7yxwHHPxyV8aZKzCYMEl3+HCsTuvAIuzhQK53644xev7yRGY
	qmrxA8xl3Bchsr1qdCLpN2fsJX3BMJXnxIsra3pm+GmTY6axJwnFLUcaZNW1Kbd4y2EpCwkg0nu
	Ia7xKdRI6QHJZWwgO6dm7LecLxcYBsYY6eNDgkpmHNiXFQox3eE1+LmzziRPuif1Hkvn4D95Q=
X-Received: by 2002:a17:90b:35d0:b0:355:35b0:8b78 with SMTP id 98e67ed59e1d1-35dc705f89bmr2619740a91.27.1775035399322;
        Wed, 01 Apr 2026 02:23:19 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe959886sm4252690a91.14.2026.04.01.02.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 02:23:18 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: handle invalid dinode in ocfs2_group_extend
Date: Wed,  1 Apr 2026 17:23:03 +0800
Message-ID: <20260401092303.3709187-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
kernel BUG at fs/ocfs2/resize.c:308!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_group_extend+0x10aa/0x1ae0 fs/ocfs2/resize.c:308
Code: 8b8520ff ffff83f8 860f8580 030000e8 5cc3c1fe
Call Trace:
 ...
 ocfs2_ioctl+0x175/0x6e0 fs/ocfs2/ioctl.c:869
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 ...

[CAUSE]
ocfs2_group_extend() assumes that the global bitmap inode block
returned from ocfs2_inode_lock() has already been validated and
BUG_ONs when the signature is not a dinode. That assumption is too
strong for crafted filesystems because the JBD2-managed buffer path
can bypass structural validation and return an invalid dinode to the
resize ioctl.

[FIX]
Validate the dinode explicitly in ocfs2_group_extend(). If the global
bitmap buffer does not contain a valid dinode, report filesystem
corruption with ocfs2_error() and fail the resize operation instead of
crashing the kernel.

Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/resize.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..ed7ed15ad9a7 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -303,9 +303,13 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
-	/* main_bm_bh is validated by inode read inside ocfs2_inode_lock(),
-	 * so any corruption is a code bug. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	/* JBD-managed buffers can bypass validation, so treat this as corruption. */
+	if (!OCFS2_IS_VALID_DINODE(fe)) {
+		ret = ocfs2_error(main_bm_inode->i_sb,
+				  "Invalid dinode #%llu\n",
+				  (unsigned long long)OCFS2_I(main_bm_inode)->ip_blkno);
+		goto out_unlock;
+	}
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
 		ocfs2_group_bitmap_size(osb->sb, 0,
-- 
2.43.0

Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168223A7F72
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 09:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775725386; cv=none; b=qYebzXXqi7Zv/MHK+4I3LfFt+Zgl5v3kR59ohviQ4L8pwHKqQwXRKzpR2ETh5E3lXeoitmpV1Q/qk4g1b14Q/Xt47htqTvc0o6N5IzWNLqtrnRgM9oZYmGC7WAvS/8HU5+h3A3YAJkk1Ewbq8FDC28qqpeiwWs3udA5htcUCd8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775725386; c=relaxed/simple;
	bh=ElzV0Jl3B3VXrYXot55+Rs8cV4aZeaZvE9Za46sEpoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YIEib+oan0T7TY3MvnyHY/PfgqFmXEnaZtKhYIo1HeSHuFWF97+LWEYWLXVzHCExgiBz5dHbIzOwVjQo5ZeTYfE5I6BACxrdkQfMt7wXEvCaEBwLeiX6Ryntrv7ch9y766eeqIhXt/iosa04eIpooBCGez6ncGJuNkKoXfh0yaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=emdzvmi/; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emdzvmi/"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-35c2fe0d90fso604672a91.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 02:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775725384; x=1776330184; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E3H4LfnSoxfxc6KcgVFxjyOCFkNDZuESS6c7o4Xlu1w=;
        b=emdzvmi/wWecJMcCCH4a+Lie7GtOlwlkGsLej0jzDHrLBF2CGUpxqtasSArk81/Ltz
         GoksHA1xKV32Wx0BYptM4S+A4Kghoo+qTMu+1ZPTOlvsRyjnCQfz9mWDPH9NJR9Ome4S
         bLCR7hIrXRamwyQLYMAuBEd9+BLnQ+GVAo2vag1f+OQ2obpb299kUt656MLE0PIgwXNl
         3OY8fs22N22Epl3xVCVTjalyAzA6r/RtZZFbJyoBuOWZCENnNuIvxPgggkwwmF83OX9G
         m8XyiCjsQdYWkctC9KeNfhVkWWpLi5CnSLFtUFQYQktd3gX2w1y7DwZz7Zu9y+b/aEhT
         XLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775725384; x=1776330184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3H4LfnSoxfxc6KcgVFxjyOCFkNDZuESS6c7o4Xlu1w=;
        b=RjvU7+g85cpB9on6rzyJskRkoj3rQeoIilK0JKlrrpsS5A3UTl08zV8K2hWrbZUV7Q
         Tdv8IZ9k0ULDkpcQse/09XTOFZOPMlFvPJMIOIOvpMYbd28jYslJtJ6ZvTh2kOkyxEkR
         KcPBSRpv+fhF36PvyW5Dk99HO9G2TzDYozAyzs8lmgejxKL6HjVdDeeCVtfx/lnRL4So
         rHZdS72BhBfxhxroe9AH5MVuD1u9tfMcs8aHX001CZvmMq02wiDQN6NnrqUB4Xs96viR
         i1PGehwZVP1gjRbsxLI1Q0JNPv5TedLKESkDNezfFog0Sx5QYlgUVVlc/MEAhCKSgDF9
         Dg/w==
X-Gm-Message-State: AOJu0YwfefJriLtMc9++K4w9UwUJUqXf4gI3L4eIAlUXIhBbKpxoNry8
	aa/MrsR7jUm5Xcg/gZx2IrRliIVcnSr5gGNF/gTzMi27hvxkexv3zllr
X-Gm-Gg: AeBDiev72A4SlJz7s+trGIFhoTPjWucCPtb77fZ6LWmzFmaoOwo8TSofizl3+YQQc3t
	rC7w/xJ+gxyKHG4JHlPbmicG5qcjRees8jSCVhdQDABhV4p28ghzWU37ov5CsbsSjEbOnpRpXVQ
	mfd8ageaSyf+wXNhhDUj+myMWu3af6SPtHuQX8bqQkCgOYJFE9+i7A96ncnHmxYLsxXCFTEuPzp
	tHFcrhev1KhaaJPjdQbT8JqntDGA8Fz4JlXBJz7d4WjbaA6iAIqqz7DCGwnpELhxN94YNRW35i2
	/2os6rusH+QTCO95SfE8hsIZn762s3TEu2gF34BHj7KFXlGW4QBQe3X7Aoz0qKKMQhqcPSYxACL
	+phj8RSx+nnykIQ6+3cnizDQ6vX7XCjhnBh4j34yw5jCL/Yr600j4BVbeFY9dzx6zoPpDKquXkw
	aoVpwXUR/ZX2vDb6nCEY4GNdxcYviwHm7iRcXnL7LFC1KemnEzNnSjS+8A4LTjG47O/KAIFuPRh
	FtGxe+L
X-Received: by 2002:a17:90b:48d2:b0:359:fdc0:4621 with SMTP id 98e67ed59e1d1-35de682817emr26707453a91.11.1775725384230;
        Thu, 09 Apr 2026 02:03:04 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e35017ee3sm2325621a91.13.2026.04.09.02.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 02:03:03 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate group add input before caching
Date: Thu,  9 Apr 2026 17:02:55 +0800
Message-ID: <20260409090255.3430951-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
OCFS2_IOC_GROUP_ADD can trigger a BUG_ON in
ocfs2_set_new_buffer_uptodate():

kernel BUG at fs/ocfs2/uptodate.c:509!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_set_new_buffer_uptodate+0x194/0x1e0 fs/ocfs2/uptodate.c:509
Code: ffffe88f 42b9fe4c 89e64889 dfe8b4df
Call Trace:
 ocfs2_group_add+0x3f1/0x1510 fs/ocfs2/resize.c:507
 ocfs2_ioctl+0x309/0x6e0 fs/ocfs2/ioctl.c:887
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7bbfb55a966d

[CAUSE]
ocfs2_group_add() calls ocfs2_set_new_buffer_uptodate() on a
user-controlled group block before ocfs2_verify_group_and_input()
validates that block number. That helper is only valid for newly
allocated metadata and asserts that the block is not already present in
the chosen metadata cache. The code also uses INODE_CACHE(inode) even
though the group descriptor belongs to main_bm_inode and later journal
accesses use that cache context instead.

[FIX]
Validate the on-disk group descriptor before caching it, then add it to
the metadata cache tracked by INODE_CACHE(main_bm_inode). Update the
error path to remove the buffer from the same cache context so the group
buffer lifetime stays consistent across validation, journaling, and
cleanup.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/resize.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..e45ab5592ee0 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -504,14 +504,14 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		goto out_unlock;
 	}
 
-	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), group_bh);
-
 	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_free_group_bh;
 	}
 
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(main_bm_inode), group_bh);
+
 	trace_ocfs2_group_add((unsigned long long)input->group,
 			       input->chain, input->clusters, input->frees);
 
@@ -575,7 +575,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 
 out_free_group_bh:
 	if (ret < 0)
-		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
+		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
 	brelse(group_bh);
 
 out_unlock:
-- 
2.43.0


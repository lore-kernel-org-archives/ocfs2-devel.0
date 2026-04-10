Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786E82D3A7C
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 02:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775786556; cv=none; b=rxb072glmVkg8wDU3B5lszZCbWRTdSbSUPDgLkWmgYStvZWaiwuauxvSSjcg79D3emiR1JwMpwcqzF3MarjGCznIEqD/Hd2jI8A23AgVJBnPqHMLml3u6hRYp/D6NTO3LUL1vIP/dkSNKOW7EI4ahM1XarUjK2zDInp+/6/apug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775786556; c=relaxed/simple;
	bh=1x1o3izrN5E2kluyZpoIKpfp3yuq0g44oixGstSh75A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JLaeFs0EZfx6A+Oxv/Mtn1LjYkOfH32OG9/rAUyT4KumE6soFpI8iyCiUvqg5t3yDH4Ki9PZ/0J4RrJgY4dGyAROHnf7qp4fMvL51/Vpu+Bvf7bULvUGpM+RflLgf6xWrKtf93s8Nifa1DzbXCjXrj83xJSmi3F1KQngZzUnsPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zm+5sOCY; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zm+5sOCY"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c76ffd06593so1074313a12.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 19:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775786554; x=1776391354; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=otfCIiZTFuJX/HFbuSk3FZpc1fHYY9CXa1topBDeWiA=;
        b=Zm+5sOCYjvcn3tgncziM6XWNAUspbXELpdHvPQidlaTn9gSwXrBsUAzt7NnIxafPOY
         UiVOw3yXzMb5vRU1UgpaXfKm9DaLhMQbw5Eeb+K0Bmy3ZIqg9n3stbTCeM3Mo+Wtu94k
         9xDvKXTJUzcJGibf2N3/hdiI/Wl+RNNAeajKBxXE9GoJ/TvEoDU0iR9YWrzNJoQc3sVE
         Df3ZcPYch2nGj8E95R6Q5+lh6sEL5qo9QIGTDLQdcMRT3ryESkXSMzQ/coYDRo4fawpM
         PPUQGffGSy18CQWb5O9yGoqzdQ/oHUKmdloKiHFmgN1M3bkkJHm1vb4/IlqUXjdy5Y4c
         cu3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775786554; x=1776391354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otfCIiZTFuJX/HFbuSk3FZpc1fHYY9CXa1topBDeWiA=;
        b=K46KaqvFrx77Ym4xK2zTH1TwFKJhTN39pIrp3gCxvuHAeUhy9/CgMNHDoEJmoQ+VB/
         a1xElkwUYBXSVoFkx13YQ77CpdoPD8FFDGhKrA5ifX/mBBjEBj9S6zKw2NdKhfgHUlHb
         pBselu2v+OXjoqXVMUSeidMO5Kre1jhpd+MowwzjNh1kbqAR9y0a1hjnkLTErsjxZzhC
         X88hHwN4WryR9US/+kQkuq2Ef51zrR1l7E2sGi2naZDRRUtV96ipGKZRybyWvElUu+0f
         jkDedu6zdh3NJJcMiEM0Xmn3ql44B8nSzK7+C2KM1TdGHfunQx4BF9Ki0jZDyZGZFydW
         sYgA==
X-Gm-Message-State: AOJu0YxcpastCrhREX/eYWJL+gvdTUJ2XEBG6ravG4SwRee/F3KODODO
	3LrH7Pupf3BNZ9o02UJ6xV76hyLBmS4tyL8JLe8NtTYGfuyiYV0l178U
X-Gm-Gg: AeBDieskzM0l35Eya6yf5cAIqSFWm8Ps8qWtvhRNnTyeAxLWCVQAizsXnpr5jLgwQR2
	jY2h5oMAZka4x5e//731ComaqNKVmv24IvyxlKvaGp/7WdrBAmJteyFYofb19LCpePIUfUO2Lim
	6FR0F/VkS4MtAl3fIXNk+GHoA7U6VwHcgz0g52BjtUuHw8/R49PA3FUwWw+lC8M1EFvELamlsRx
	vkR+JLL38o2ZhKooJUIefjvQGSNqmEDw9pimXBWpCEm3IBJ1OsACd35d33jt1vAidI7i73I5ScS
	pKxDKCulHzQzx4zIIBTza4gc+Y0aCuxTgEGz0gVuto6we3c/ib7oNzxB5VGOC61E5o0RyizWkG2
	xanaWjQpT3ycGOcVISAmHe8U33i8Be4eSfnEH0LVvA1dNbbQ7GEAtMKigaVIyOlE0GQsrIRi1s7
	ajludC4kE070EgffEPO/+eYXuYE9Pbr1e0W5wY1Gb4YX2++kwV8Hn5ri3pD5TZggUFqOWvkqtV5
	XAT7Ggo
X-Received: by 2002:a17:903:4502:b0:2b2:53f5:4627 with SMTP id d9443c01a7336-2b2d5939409mr9093285ad.4.1775786553548;
        Thu, 09 Apr 2026 19:02:33 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f099d6sm10512285ad.50.2026.04.09.19.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 19:02:33 -0700 (PDT)
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
Subject: [PATCH v3] ocfs2: validate group add input before caching
Date: Fri, 10 Apr 2026 10:02:08 +0800
Message-ID: <20260410020209.3786348-1-gality369@gmail.com>
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
the metadata cache tracked by INODE_CACHE(main_bm_inode). Keep the
validation failure path separate from the later cleanup path so we only
remove the buffer from that cache after it has actually been inserted.
This keeps the group buffer lifetime consistent across validation,
journaling, and cleanup.

Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v3:
- keep out_free_group_bh as the brelse() label
- add out_remove_cache for failures after cache insertion
- send ocfs2_start_trans() failure to out_remove_cache

v2:
- add the missing Fixes tag for the group-add introduction commit
- keep the validation failure path separate so cache removal only happens
  after the buffer has been inserted into main_bm_inode's cache
---
 fs/ocfs2/resize.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..5c6975d90ad6 100644
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
 
@@ -519,7 +519,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	if (IS_ERR(handle)) {
 		mlog_errno(PTR_ERR(handle));
 		ret = -EINVAL;
-		goto out_free_group_bh;
+		goto out_remove_cache;
 	}
 
 	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
@@ -573,9 +573,11 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 
-out_free_group_bh:
+out_remove_cache:
 	if (ret < 0)
-		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
+		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
+
+out_free_group_bh:
 	brelse(group_bh);
 
 out_unlock:
-- 
2.43.0


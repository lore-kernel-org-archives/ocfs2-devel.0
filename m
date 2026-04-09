Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3470A3DA5BB
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Apr 2026 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775749031; cv=none; b=joGf52M/qB/x3iLcyxIGZ24oyTrL/RwpMhsyUsEos25+dhgQMNeZT7kKLYLFa+6wotYwu7U0LCLuVXIklH5PLftLUsYv9EADh/xaOA+wGMf7NTJ5HeVkZo1jCiV3yYc9FyaEyo4Aa8qkio3jAUnElBU29ki3PO9W5j98XeF1pP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775749031; c=relaxed/simple;
	bh=Zm2Fauno77OaNWtmagHFrarSboCoCKWOc5i5qIsOyUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gUMOm7eCxNTLbA4MXCikcRXPlwuXZfQm5aRg+7meh6PFabc7XEl+szlWfvJgXdbbURbKGjo8WjO6zC+cSK8LgZ9bvVhgRnsxQ42TSFPSs0PhZbLIIawpi/HywpTbE5wqgvAOV+afjl58DjLIWMwr4goB0gU/O79dMkyDVspVe/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jNXLBhpI; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNXLBhpI"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so1151168a91.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 08:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775749029; x=1776353829; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/hGGjBUBi0wuXZXNWhX8YEVwbpFqEt8WVHdpMuWCEDI=;
        b=jNXLBhpI+9LaCT5xSX0X4XtKZDd46mMC6NQS8AmkLorcCm/71r/loBwDksAibV+X1f
         uwmrd10vYIPpNlX4gtAHi9Tnhw7k8E2djZTpJKiUNYO6nOqA0mjWKvG9Axjl3YXTkMXZ
         bnuODdPBwHneKPUNmeqP9wntsD3i7GyhC9ARs2hCURG1y5FD39Mt2Uk9phr5wHYzG1QF
         vO1ggnx10HE04WqnSJCyWbMPcO3bg/yOcEq1B8xLqtio0lSkieVjNxL10NC7zHtI39P7
         iiIeQmT6m0v0BjfDb+2djg4CIubjSykYt7XR9unJ5WfEgRnanUjD47/vjrU5qjYYiBn9
         f7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775749029; x=1776353829;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/hGGjBUBi0wuXZXNWhX8YEVwbpFqEt8WVHdpMuWCEDI=;
        b=XT9zyBVG3fBH3ZaLiH2mt3fcZ4BaaQbJ4iiXCdUehGJ59qHWu0m5CMG+dPyxv9jC1l
         vokpPAgoNXjdpVFSWIS8PPpm9AHhixVUAJC20sG5QgjcKNbf45nq85oE1iFXvNfIrSRY
         7QcndxtmYqMTCSD7HZIgwJLC/Zmdqd3QiqdOGzK1E+0tdUx1/hOux+eBaZSoOjrSRs1P
         IPNaU0DwZ7DJlreEUhx+nJSCvxzGqT8vUCxVJLZIsFkG3rqAxDCwqKi6oFGzHqccGRAW
         ZhRYYmYr81m/n9GZloEwdXGA834eYERoKBYcvT56UKtxf/28pP/j/95qlgh+Xz5OasAL
         0q9w==
X-Gm-Message-State: AOJu0YwYzgZrAGvYE+Eta314BL2EaZQSxQZIugkMbbuF3Ooqqs9uz30h
	zw37GY76QFsznjnJ6ODtCdwPha8dHYahyNCghSSjQp5HUZOCpdobRJmQ
X-Gm-Gg: AeBDiesD4Ez7DKIZO2eiS373ljvmbhnVM+pjc/qu6bPLWDuP+YHkQcId6yHDlCPj7uO
	p/IoaSd2bEBzqPpiwrcqO/h0rgWJdjoIhDJsF/WuZIsQwjLmSX+3upqQn7nOjWdiRPhenJHe+oy
	yTQOtwaY7QXCWL39AOONlJf4iGad7rt1Isj66jlVtTB+R5mxefLkADUunUbPkWyoi55bgzkkbKj
	4w2SIX991BwEFm+ZBk+hWn4USsVhtEUQ25/utZ0/PIxLjDKTAu0p1eB1bu6ma8Az2gkysgePz0W
	GlijDpNcIuMa6kbyFI4Ocgb2ufMTz/9XRlqHPAx3uBUd/kK7zdn2cpEl5ntKn3ue/fs05RLQl67
	lyIb1jUdmA16qLpTI/1NfuJoo+b+Px0sH49+kcdP1GaZfB5kursn27h63atyOqvPMz3mBJ+/Pl3
	KJN8qfupGYsdjzjZRRNF1IH8GRLbobp60MvzYXPxsX/xW1LIPJXzPrTt4o1wnFtZVUDxuCiA==
X-Received: by 2002:a17:90b:4fc4:b0:359:f22:8879 with SMTP id 98e67ed59e1d1-35de691c094mr24239367a91.22.1775749029405;
        Thu, 09 Apr 2026 08:37:09 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e34fd383dsm4819823a91.6.2026.04.09.08.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 08:37:08 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: validate group add input before caching
Date: Thu,  9 Apr 2026 23:36:51 +0800
Message-ID: <20260409153651.3575131-1-gality369@gmail.com>
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
v2:
- add the missing Fixes tag for the group-add introduction commit
- keep the validation failure path separate so cache removal only happens
  after the buffer has been inserted into main_bm_inode's cache
---

 fs/ocfs2/resize.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..6bb91b091b29 100644
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
-		goto out_free_group_bh;
+		goto out_brelse_group_bh;
 	}
 
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(main_bm_inode), group_bh);
+
 	trace_ocfs2_group_add((unsigned long long)input->group,
 			       input->chain, input->clusters, input->frees);
 
@@ -575,7 +575,9 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 
 out_free_group_bh:
 	if (ret < 0)
-		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
+		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
+
+out_brelse_group_bh:
 	brelse(group_bh);
 
 out_unlock:
-- 
2.43.0


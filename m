Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D7B39A04E
	for <ocfs2-devel@lists.linux.dev>; Sat,  9 May 2026 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778317822; cv=none; b=N2jlEWnbNq+/NBHviJip2KkuOvwmPEmgExNjNSDvRnkx2/LYFAWW0hk/kGGLAhs2pH/uiZ2Jk4Z+wT1V/DOOBY6aVhjjQ/X/AxB7x3Ju3uevrzMucCDE9Mti40HGp1zwGEyD0ytOB1TVuwoIwGB+Mb2+vPIup1iKHOHarGxer7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778317822; c=relaxed/simple;
	bh=WKWdM12bQXy2amWAqjn3073rgASxZAw+mgRRdxe7iKU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cAfd4DY/yUU+X7eoS1cZHS6Q5wFxR/xdYN55e+uge4H1H4FfYFK5rSPz/rFIcbKN0kESNu37RAiUY0fAKNutUtcyVpBfBXSEnR4t3S9HElEv2XKlcCL/bdzTQmqOAH7l5GhgA2lZLBLYEqOzyaQaTnP7/Hp3WgA5k13TRze1/v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MjpeoeiD; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjpeoeiD"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-834da62e52dso1238694b3a.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 09 May 2026 02:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778317817; x=1778922617; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=li5Xt1PaINpaL2UPymHHMMrcfub/KFmvLpc/g8W+eII=;
        b=MjpeoeiDaXhicpcn+NFGM59bn/jfiwocgXiZlvhjXmt2pA/iQVTpqtzB9WU/l0c7RH
         EV+909q/xvUAAM7aUGh/3qHfSdMVIUi9HyJ8QOCj/tePxvUUneUnEc6E38c4c6y+b2dN
         yKCiSUK+U/wl7LUNzPrU5jQngaGP0djWHgp+HrlBeQE32ASGTE+XGjYoytYQTvwwuCx7
         LalFy+FhlFyZeZXbM1k0gDqp/B/RqydgTKbdQIwa+L86lYUo2gl58jMNavYEjU2DeDbK
         GFeCTqspV5OsaeZ01groK/npmpZxmqqfUJqITbgG+lik2tYVSxAlakpgPKh64iGxy8pZ
         uWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778317817; x=1778922617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li5Xt1PaINpaL2UPymHHMMrcfub/KFmvLpc/g8W+eII=;
        b=DoHu1nQJklX33oNf7v2YeXpztXDUePkdiUFtrI1d3dhs3x0AWlv7YjI3EbkQH3jUNB
         xI7gQOFatNmMAnvfRA+FzkS6AHj4GN9xHtp1cbQ3+4Cniv5g4UKmxuQvnd8JHcYbfI+G
         GfUsOOxitaHDI1p2lT084W1+7jyMoAGs9ofoCnwHcU048b6xn7162QJrFH4mqmVZNtu7
         AIJI2kasqfFOJiCGne+0JvOoe0KHDJt25sSaj6UutO2R+p2/3RF3xz0lQptfjrI3jMuy
         FSvP/XVuOA8Xc7DjJ0cnPH5BQiaQCYMksA8fWmQszLbLHTnFgL8dVlxH3RxMm2LU/Cvf
         TIwQ==
X-Gm-Message-State: AOJu0Yyu1othn8o+SPSU4LVSnckKk4X9YsMIVJ99HTYPve4aqt8LHHgj
	P0wcxsISFfS23gypKR8woowfkTUbC4xy9GSPkpGwCkjy1xedQW76yhYM
X-Gm-Gg: Acq92OEXhE41NN/ZVlsuEhKO0TPmU72rrb1djVV8FkBeRgOz9i522GdCd49l5gWp5Z0
	AsDqNJi2Cstda4MrNY/QN7oeG3PKjWlWIQlbb1XCW00P4YUZp4h1gbe0n5GzWO3cSaO4s/O4qJM
	YZKh3Co7oh+XnYaCVSDlmx0xFoVhUrLj0yPmGY6jWxFZBkPULfN/WH+mJhlMe+fgL/aspgEE2uD
	Q7DvcFg2iwRkf9vpheznWX8rjCacR5U+XpU3gBgOwUaMnEFWdRNZcpOi+EUbRRSGTz+zfmrvyeq
	vrslh1nwy7N4tBELNdxP6LCvXkvSqq/abPeb3+nUtLGpBWXQwyDOEKyrsoujlYannNPY39iuWur
	1Mpm7U5fiEUvlDuNeq6hYoaRQQXc4QhZDjn8c+0xOkg+1dKaBX6yCLpHvd6mGKamVgdCMXl9j7w
	zYCtvvGZWkPReZ4HcCJ+tHRVCJB5ga9zO+kgw2bnSvQKZ3f0tXRJFPLwyk9TWZ+7MqVy6Y/1tP2
	sEV
X-Received: by 2002:aa7:88d6:0:b0:82a:6852:559e with SMTP id d2e1a72fcca58-83a5b8d8905mr15413203b3a.12.1778317816876;
        Sat, 09 May 2026 02:10:16 -0700 (PDT)
Received: from gmail.com ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965d35b3bsm13529609b3a.24.2026.05.09.02.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 02:10:16 -0700 (PDT)
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
Subject: [PATCH] ocfs2: reject inconsistent inode size before truncate
Date: Sat,  9 May 2026 17:10:04 +0800
Message-ID: <20260509091004.758218-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
openat(..., O_WRONLY|O_CREAT|O_TRUNC) can hit:

kernel BUG at fs/ocfs2/file.c:454!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_truncate_file+0x1204/0x13c0 fs/ocfs2/file.c:454
Call Trace:
 ocfs2_setattr+0xa6d/0x1fd0 fs/ocfs2/file.c:1212
 notify_change+0x4b5/0x1030 fs/attr.c:546
 do_truncate+0x1d2/0x230 fs/open.c:68
 handle_truncate fs/namei.c:3596 [inline]
 do_open fs/namei.c:3979 [inline]
 path_openat+0x260f/0x2ce0 fs/namei.c:4134
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x15b/0x220 fs/open.c:1463
 ...

[CAUSE]
ocfs2_truncate_file() treats di_bh->i_size matching inode->i_size as an
internal code invariant and BUGs if it is broken.

That assumption is too strong for corrupted metadata. The dinode block can
still be structurally valid enough to pass ocfs2_read_inode_block() while
no longer matching an already-instantiated VFS inode. On local mounts,
ocfs2_inode_lock_update() skips refresh entirely, so truncate can
observe the mismatch directly and crash instead of rejecting the
corruption.

[FIX]
Turn the BUG_ON into normal OCFS2 corruption handling. If truncate sees
di_bh->i_size disagree with inode->i_size, report it with ocfs2_error() and
abort before touching truncate state.

This keeps the fix at the first boundary that actually requires the
sizes to match and avoids widening checks into hotter generic
inode-lock paths.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -444,15 +444,17 @@ int ocfs2_truncate_file(struct inode *inode,
 	int status = 0;
 	struct ocfs2_dinode *fe = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	/* We trust di_bh because it comes from ocfs2_inode_lock(), which
-	 * already validated it */
+	/*
+	 * ocfs2_inode_lock() validated the dinode block, but truncation
+	 * still needs to reject an inode state that no longer matches
+	 * di_bh.
+	 */
 	fe = (struct ocfs2_dinode *) di_bh->b_data;
 
 	trace_ocfs2_truncate_file((unsigned long long)OCFS2_I(inode)->ip_blkno,
 				  (unsigned long long)le64_to_cpu(fe->i_size),
 				  (unsigned long long)new_i_size);
 
-	mlog_bug_on_msg(le64_to_cpu(fe->i_size) != i_size_read(inode),
-			"Inode %llu, inode i_size = %lld != di "
-			"i_size = %llu, i_flags = 0x%x\n",
-			(unsigned long long)OCFS2_I(inode)->ip_blkno,
-			i_size_read(inode),
-			(unsigned long long)le64_to_cpu(fe->i_size),
-			le32_to_cpu(fe->i_flags));
+	if (unlikely(le64_to_cpu(fe->i_size) != i_size_read(inode))) {
+		status = ocfs2_error(inode->i_sb,
+				     "Inode %llu has inconsistent i_size: inode = %lld, dinode = %llu, i_flags = 0x%x\n",
+				     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				     i_size_read(inode),
+				     (unsigned long long)le64_to_cpu(fe->i_size),
+				     le32_to_cpu(fe->i_flags));
+		goto bail;
+	}
 
 	if (new_i_size > le64_to_cpu(fe->i_size)) {
 		trace_ocfs2_truncate_file_error(
 			(unsigned long long)le64_to_cpu(fe->i_size),
-- 
2.43.0

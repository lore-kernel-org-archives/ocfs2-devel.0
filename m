Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298831917FB
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 04:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775793845; cv=none; b=WmX2Aoj5CIX4izyrAO8DB1f5sMFjzabAsw3eei7hGrmrdjGArRq2sbmGUzB03e1kkDrKM7jloVSUSS+8cPKzlFcHW/U/w1XZ84APyAXhyUMS5rfqGJDgV6XyurjlT9+2pCE34SW94QdLfQmf7fVZlm5fwkCnfCfQv/cgPw5BSHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775793845; c=relaxed/simple;
	bh=8FEFgHqZ/3Vz15DR/+rmlIBFg7lMuoAa2V8SWyRQd2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LykQVvaTlkzEPpc7rz7rIwisM6aIxp1P3lIjYS3o3CILDGYL4k0aI93EdaVzKXhDohr10SiNDuQtdnmhXTEGQhGSLzI8oMgZA1+FGIOJAFPPMJoDF7wxJprWnMvgzhmnYWyoFNJwwJPpCR5djMJHuF/t7QKfMk3hpBN61gNoJNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NZVdsALh; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NZVdsALh"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b0c8362d93so11163785ad.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 09 Apr 2026 21:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775793842; x=1776398642; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Crmw0XiLmJTudaBPwp2D4YgBmClNy6wRoSqg0r+HY08=;
        b=NZVdsALh2k6X9p/dqH51mx5HBngjoqD5D2UOb8maTRa0ntHU4hLDS3cminsx3H2m7l
         zmG0+e+uoYrq4AlFIlWK98g2oimhPZ8SoNfGdNhTFU3OGcwHiVfdrBZ8fmpcR2gNJA+Z
         paRU/ewIYmGHcAkrVC3zcB1VefY1L4kPJchhYuikctAGQVxoQU2oFQ0johi0wWNyeqwf
         wdWqD00knw9g315aVyDhPv0hPPaXZmDaRftF0g8Zbhp/ciFC3pe+svZQZ1fNHLQH21ag
         9Vm5hUmljZjB54qY8YcYdL/E0q7rIxQBc4w33sc2KlwbrqhWkIqQSo0o5z9sXsNzTFpU
         eSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775793842; x=1776398642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Crmw0XiLmJTudaBPwp2D4YgBmClNy6wRoSqg0r+HY08=;
        b=YnOIt+w4bQmceaETcaQkuvYxYbw2fc9AKzrOTUyKLk/wiD12UsLmP4lFSwx9ciVlQ1
         GvT0KghYPqRCi7orYwSL3If+N2ivTYdz0+13pHvjHURqVzR8ItnS1BVhGDjix6R33ay0
         HKAynsRZm+d1bshdNaIl5gEMaHjL9RjAVdEMoZCCjFhWey3VxHwAgnsJVFw+ptbRbV3W
         oIPKVhxy9JQPmKgW0GqDEKsmR3o1ynXgKR3cixyb65BQ849lkq4fhRgcyxhj1lQkep2X
         jiTikhhlfvckngpaG6vw/j+6yKleI0dFEucPfm3AxNb2tmRTiJUu9nv+ZD2N4UPjm1RZ
         EKHA==
X-Gm-Message-State: AOJu0YxzSnftYV20F9gSY7VdCda0s4ID1ZnumO011nMLazXqDiFQr1OG
	JhYrkKWKyamRljQ7D9utsrps572ByNmD7vnMdLAEa6qJANulNk10X4Zo
X-Gm-Gg: AeBDievwDxrECJomssnjy0vBVFc6I7tATP2FM3M5O9rlf2RvYdo9Nm5BYl+sYZU9zZ1
	w5NHeHnLnSUc3GQBag0m+v9So7xBKj7nfNbY7SphH7DPunA2Ub1zhJyQ7nMLVs/3TrgioLjpOk/
	QEogGJ8GocTVZ59ygqCstjF1kNhclpe0bwbdBIwLZLhm9Oq5O0WVjcEcxXxmfCWY9BVEh7AmNqA
	GjeopCdvolyUJKQqgZL5ygTYp4gEuHixl0nBiyIer2h608YO8nlK++cTkEulwAJENZXGBAt0l0g
	4sjc5RY6xrWUOXrsM8b3GZPmtKpIx4UeVOHiLRR6e8qoaxN1HoQ8AoKIf5JAlnHEPQc0fan1ZbG
	xrvD2KufMfxXIP27YRt+UiAr1Qxce3JCCXIKa+OhQqTHJAEw/LkpzMH1TxLkznVb3K374NxH2Vo
	HHkFSWGJPFBNtqO8G8hNxBrm0hkvpSeNYwOPEcf0Ehucjb0GYsVeWq4BdiJptxAvnnvW1yWTCUx
	B4ih6Mi
X-Received: by 2002:a17:902:b698:b0:2ab:230d:2d96 with SMTP id d9443c01a7336-2b2d5976d64mr11605535ad.11.1775793842299;
        Thu, 09 Apr 2026 21:04:02 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dd610esm11803225ad.20.2026.04.09.21.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 21:04:01 -0700 (PDT)
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
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: fix listxattr handling when the buffer is full
Date: Fri, 10 Apr 2026 12:03:39 +0800
Message-ID: <20260410040339.3837162-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
If an OCFS2 inode has both inline and block-based xattrs, listxattr()
can return a size larger than the caller's buffer when the inline names
consume that buffer exactly.

kernel BUG at mm/usercopy.c:102!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:usercopy_abort+0xb7/0xd0 mm/usercopy.c:102
Call Trace:
 __check_heap_object+0xe3/0x120 mm/slub.c:8243
 check_heap_object mm/usercopy.c:196 [inline]
 __check_object_size mm/usercopy.c:250 [inline]
 __check_object_size+0x5c5/0x780 mm/usercopy.c:215
 check_object_size include/linux/ucopysize.h:22 [inline]
 check_copy_size include/linux/ucopysize.h:59 [inline]
 copy_to_user include/linux/uaccess.h:219 [inline]
 listxattr+0xb0/0x170 fs/xattr.c:926
 filename_listxattr fs/xattr.c:958 [inline]
 path_listxattrat+0x137/0x320 fs/xattr.c:988
 __do_sys_listxattr fs/xattr.c:1001 [inline]
 __se_sys_listxattr fs/xattr.c:998 [inline]
 __x64_sys_listxattr+0x7f/0xd0 fs/xattr.c:998
 ...

[CAUSE]
Commit 936b8834366e ("ocfs2: Refactor xattr list and remove
ocfs2_xattr_handler().") replaced the old per-handler list accounting
with ocfs2_xattr_list_entry(), but it kept using size == 0 to detect
probe mode.

That assumption stops being true once ocfs2_listxattr() finishes the
inline-xattr pass. If the inline names fill the caller buffer exactly,
the block-xattr pass runs with a non-NULL buffer and a remaining size of
zero. ocfs2_xattr_list_entry() then skips the bounds check, keeps
counting block names, and returns a positive size larger than the
supplied buffer.

[FIX]
Detect probe mode by testing whether the destination buffer pointer is
NULL instead of whether the remaining size is zero.

That restores the pre-refactor behavior and matches the OCFS2 getxattr
helpers. Once the remaining buffer reaches zero while more names are
left, the block-xattr pass now returns -ERANGE instead of reporting a
size larger than the allocated list buffer.

Fixes: 936b8834366e ("ocfs2: Refactor xattr list and remove ocfs2_xattr_handler().")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -906,8 +906,8 @@ static int ocfs2_xattr_list_entry(struct super_block *sb,
 	prefix_len = strlen(prefix);
 	total_len = prefix_len + name_len + 1;
 	*result += total_len;

-	/* we are just looking for how big our buffer needs to be */
-	if (!size)
+	/* No buffer means we are only looking for the required size. */
+	if (!buffer)
 		return 0;
 
 	if (*result > size)
-- 
2.49.0

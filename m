Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B163451B3
	for <ocfs2-devel@lists.linux.dev>; Tue, 12 May 2026 02:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778552174; cv=none; b=JodJ8z9M2zlwmy45lqO52ZzVJvfqxtnrC87lmk55f/JazQ0zcg+I9b6Ar1V5ha+yfjvlysna1VXNk/BVkcFpfk7x+Fi8/uSxU5yQ8o+XzMh5BtpXiyEIT2wZH6CajCwkP4qZXf/9PiDSinid07pjT6C4LXvlQuqwdUzRMCu1wac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778552174; c=relaxed/simple;
	bh=P+q9UUBZTVPw5TkujswOPQoFe7jrHdnRfV8HXiKF0K8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lGdHaMumGxlTSSKu+WfCwvSNPNehz739EUyZpTsMWoT5vhPhYE2CgJokLdaDLLqkcU0aJ/fZ44HbeSsqZ2coZIqQFU1ISxs6Dr+ChYzKFkA3aYH+zJsEcauQa8o52GAXp65aSWJ9NGnm/vkCG9tQ6qnuQqcQE1zUhjAetmQhbvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QKAc1Qsg; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKAc1Qsg"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-835399c11e0so2234597b3a.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 11 May 2026 19:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778552171; x=1779156971; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o73m3dQgHqFuu5RPyAMqDNOcllL4aap7hOBC+h+RpYc=;
        b=QKAc1Qsg92QQFXvgZABda1fGeGznedl4f7i9ANFJdufUHgePEnzKznl8X7oiluBPG6
         Mrr8ZEI/YBOXRTGgHVEtlAGkpWOlrOx+idPlaxP1N/Qid806LRg+a2D2qsSOd9oCOn00
         WR6jbF65lUEsFQhlUf1dLkaGeDBKT9vIhqmsJ/V5ZiBI9CauDzYlx4DfT+FHDcCFBz4M
         ep7DWPHiUTq24P45YZ4sBEd7LeAU12lghalKPPWEcVz5DzntcODFQIK/11cn3dIXAi8U
         UoxQzq5rTwW8Tx9W1wq7CUgH0LQUyfnbGqlgOhp7e+sNGqz1XFjcL/AWMSpnNR8ilDZi
         skCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778552171; x=1779156971;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o73m3dQgHqFuu5RPyAMqDNOcllL4aap7hOBC+h+RpYc=;
        b=XmIMDTNKITQexOa2/0JtBxH7ARv+DjpQrC2VtedMuAFHK8aIWf+1/X4SQalgl3p+wj
         xUlEwxbH+BPH5GsjPj6Jgmtdm0pUmQMQ6OCGmP5UlGi/2ndrRW20JjpFTKk0RyIlzv4V
         Lk8/5BqqiM5o3ZD1JhHbqQmWJnAjSE0waal2wj0bLgQ6cYM8Pmg5HyKr1/7cng4uzjST
         Y++VD3vl60wItBgUSKR7IHoaH0GseHzSTlEnJ0RewHv5IQjAh2GhZxbmBVZBSh5oz6W+
         uM3YNiCtPyL8xIOF+L+z8Fm+PfQtfb0aslLV18G3MSKuXe/xYX/Wa35iZL/jejmoIpPM
         8iSg==
X-Gm-Message-State: AOJu0YyaS508wXHgMY6S7oBQclUdRJGNDbvib4/dQK4NSdSVvoDwrgTx
	8cEaIBIyLnMASlDx1It4MIzT54Sj6ErCwJk2emchXVYR7PERIEXPuRwu
X-Gm-Gg: Acq92OGhnWv1uPOdc7RPkL+4H5Qdffps4dhhe14NEK1LGJDZy/uR6jrjeQ6ZRTeiIuQ
	yGWVpfnv2w1xE2yrwGj3ZXBXyQv2W73mK4utZyZakiiqXt/qlPLB3/WVX8+LTt9BycSk7QEKbDf
	RtweJCR/BMVAMmaCMlleeqaejAE/+PvTLJJA+ygPfg7h9FYIZ1Rp3F7aGIIXehR8JIKxE3teqdi
	UcrD3nrPGUWGa3SM7M9qzx/ZnecXgG7p5P0z/6cH9ApfOEPv0m0OFJ23HF5OfVdC5PrnrE6eqED
	6jZD7T/KKkarZ1MhrfWvdMP+6XcjATHavCbbY8M7fCyVbTSUsAz5EfXrGLJdojREm/PaPdiQn3W
	s1QsTJiKvoAikhnLl5FoVfVAsjerfVCy51gieBZw6C5yq2P2PouxHYWKDpGKj050eS6395rCEdk
	cI2L4nGWYKpOKzKZn5LrZnfZ6V/IBXVt1mmD6fDoDkyTojLJ6dVl0N1LE+Z5jUEbB4Ut/uYAaU5
	flu
X-Received: by 2002:a05:6a00:2990:b0:82c:e692:1f91 with SMTP id d2e1a72fcca58-83a5dc5df18mr26811854b3a.39.1778552171071;
        Mon, 11 May 2026 19:16:11 -0700 (PDT)
Received: from gmail.com ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839682a52cesm20701081b3a.57.2026.05.11.19.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 19:16:10 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: reject inconsistent inode size before truncate
Date: Tue, 12 May 2026 10:16:00 +0800
Message-ID: <20260512021601.3936417-1-gality369@gmail.com>
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
inode-lock paths

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Tie the new truncate comment to the local mount case where inode refresh
  is skipped.

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
+	 * On local mounts ocfs2_inode_lock_update() skips the inode
+	 * refresh path, so truncation still needs to reject an inode
+	 * state that no longer matches di_bh.
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

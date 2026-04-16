Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABE633C51D
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 04:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776315481; cv=none; b=aUlGsTPl2wv4pcNuz4AnfwefKACfUPHOWlpLNhRNUU+qddLOq6zGjN4xpNazyNoPcr2IJwhBYstIo0TJwn/WCsCj5TvMWy0dxdB7/n/EWBhovM7H1qBEqeDDwZLOxj5SnVWj17jx2CIM/uHNlHt9WBIxK8iNBtbSVXqKgvWiWLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776315481; c=relaxed/simple;
	bh=8TMlI1pQleftFu9PClZwNbIJshve1ZBePZlu3huWhZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s0DB6aeGq+fcUw9WpjXFpiMIoIBvr4vLWbcnCUm1FXmB+IlMRzx5AMlnfav50Eu1oqk/M49AQPknyf7TA/1qcJWzmhC+6Jy6gQHh0PFaxsUpf0nQW3mRA+8jiM7QRgBl4WpdHIKPlnKwYlenr2CXHcwU64sRGmkTxuf7FSEbxYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I1Ef6Yr6; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I1Ef6Yr6"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8296d553142so3905929b3a.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 15 Apr 2026 21:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776315479; x=1776920279; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zrAYe9vzhFRW1N9dJjeeqEl+23S+heMZp+qckgpxyGo=;
        b=I1Ef6Yr6vIdS/NA2OplVIBH9HcE9jrEPjd7X+L6x+rBlBXXRvHceW/cQ6JMFwKmBgz
         uHORqcNQg/8g7AHDZqqFEyLcMTglpdeE09BqVTL+hdZLt9bHpwzsqU9auTFxynnSmsbS
         prmLa/MWCf48uNuBIA6qsXJb56G3jedWo4Dl9Mq89dG+JAoM0/EfFS/B1bxHVoEs+F3l
         HHAWdw3TBfmTr0ySjSIdPfPnm8K5/BDSE2sHdB3gVD8SL5in8FCgb00vkEm0yFXzeTjw
         4g3K8UMaTtLk2KdELXPvmlgob60nYtSTgpYAGfM1irby95oqzpjACe5deissfZGveCkn
         V1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776315479; x=1776920279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrAYe9vzhFRW1N9dJjeeqEl+23S+heMZp+qckgpxyGo=;
        b=beIoh77HQS2JuLpqbHIizgtucCU4NHsjzZq0WrQQKRBfHqb/DJXCnaGMqmTiDx7Utt
         qbD6MHEJZkrfPczTqPUuTFoOgrAG7A1x5SecjrPJnjJ3rzn1eiSuln1JW3pwEPJWWD80
         m3ZSixGjl+u3RIhW0G96nvKvFYz4o8Rj9NFERaXfKaZAhojZoZ9lh4sfu24buUXPp3m7
         Q1uV3LCaNZm2wqcLJp9wnqicxlhjBsUcXIbVubJaPQTt57IB9ZobQTIfxR+ZrgMvZPFz
         i5XMHeMoOS15gRpTKZelxlbUHZSgb7LLnVIJN7177+Asv7l8asTVc71VRyfSqtiXoewG
         LMkA==
X-Gm-Message-State: AOJu0YyvbLxuL+VCAae1O4ZHyKc6iJk6ExUz63BXVZHHuldY0u2fQfMF
	Qf40r/o9dqkkfOVLkAJ7rnTttnI3keYUl8E2oHRm+cumnYLDbOvCPKBZ
X-Gm-Gg: AeBDietnwTJyXCsGVAdy+bPAtOROVphJajMTU4urNS6P6MoeGFCmgIdUKCh1LbeFelO
	OHSB3377VTycxxRsKN9OchD5UweHLQdZ96zETLUykME7yQPjKOzazZyvcMH85Wj7wx3aY9ycR4X
	/4II9pF+eJcckkBoMSeMtUHSk+Q68Gb911cFv8D+9c1UiC7BKUguULc0OadIkF7HCnQz4ZkD8S1
	O+GhaMWBRWW2hqIP2qkMRyJw/tN7EXwb06RAhbIyJONa9FOs6q4f2ZR0xafALj8p0oDr0M6RIer
	mFPz4YFsBt3rpR3Bm4cHiXEBFl2pSbTQozYrLDVE/Bzu7KPjAFT2s9fM6FXSOcSeZrDGzawdXIx
	DFBpW+K8m//fqqB+pNmcEQHayDYRGtNkkrhh1sCGIMUu2v19oWbvGcP4ly8oBVx7us9DhmqBH3m
	uiXlvmxmWQM+KrrzHq34aKdklgjEe9tf1ZdlBkyd+htupKvXxFMFKdqQ4qZHx4I1tY9y+Hdx0=
X-Received: by 2002:a05:6a00:400c:b0:82f:7252:38cf with SMTP id d2e1a72fcca58-82f725245a7mr3437009b3a.16.1776315478875;
        Wed, 15 Apr 2026 21:57:58 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f738b399bsm1846716b3a.8.2026.04.15.21.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 21:57:58 -0700 (PDT)
From: gality369 <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	gality369 <gality369@gmail.com>
Subject: [PATCH v2] ocfs2: reject inconsistent local xattr entries
Date: Thu, 16 Apr 2026 12:57:45 +0800
Message-ID: <20260416045745.3133911-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupt OCFS2 xattr entry can set OCFS2_XATTR_ENTRY_LOCAL while
keeping xe_value_size larger than OCFS2_XATTR_INLINE_SIZE.

Once that entry reaches namevalue_size_xe(), the filesystem trips over:

kernel BUG at fs/ocfs2/xattr.c:231!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:namevalue_size_xe fs/ocfs2/xattr.c:231 [inline]
RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x2e4/0x330 fs/ocfs2/xattr.c:1638
Call Trace:
 ocfs2_xa_wipe_namevalue fs/ocfs2/xattr.c:1470 [inline]
 ocfs2_xa_remove_entry+0xae/0x1d0 fs/ocfs2/xattr.c:1941
 ocfs2_xa_remove fs/ocfs2/xattr.c:2043 [inline]
 ocfs2_xa_set+0x11a8/0x30a0 fs/ocfs2/xattr.c:2247
 ocfs2_xattr_ibody_set+0x302/0xc50 fs/ocfs2/xattr.c:2795
 __ocfs2_xattr_set_handle+0x7e6/0xdb0 fs/ocfs2/xattr.c:3416
 ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
 ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
 __vfs_removexattr+0x14d/0x1d0 fs/xattr.c:518
 cap_inode_killpriv+0x29/0x50 security/commoncap.c:355
 security_inode_killpriv+0x105/0x220 security/security.c:2724
 setattr_prepare+0x147/0x8a0 fs/attr.c:219
 ocfs2_setattr+0x504/0x1fd0 fs/ocfs2/file.c:1148
 notify_change+0x4b5/0x1030 fs/attr.c:546
 do_truncate+0x1d2/0x230 fs/open.c:68
 handle_truncate fs/namei.c:3596 [inline]
 do_open fs/namei.c:3979 [inline]
 path_openat+0x260f/0x2ce0 fs/namei.c:4134
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 ...

[CAUSE]
namevalue_size_xe() assumes on-disk xattr entries keep the local flag
and value size consistent, but OCFS2 does not reject an entry that
claims local storage for a value larger than the inline limit before
handing that entry to namevalue_size_xe().

The exact-match lookup path can return such an entry through xs->here,
and bucket defragmentation and splitting can also walk the corrupt entry
directly while reorganizing metadata.

[FIX]
Add a small validator for the local/value_size invariant and call it in
the paths that feed disk entries to namevalue_size_xe(): exact-match
lookup, bucket lookup results, bucket defragmentation, and bucket
splitting.

Corrupt metadata is now reported with ocfs2_error() and -EFSCORRUPTED
instead of crashing the kernel with BUG_ON().

Signed-off-by: gality369 <gality369@gmail.com>
---
No Fixes tag was added because this is more like a defensive check
that is long overdue, not a regression that can be clearly attributed
to a specific introduction commit.

[CHANGELOG]
- Fix Signed-off-by email address only; no code changes since v1.
---
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 86cfd4c2adf9..63b1e55b242f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -237,6 +237,23 @@ static int namevalue_size_xe(struct ocfs2_xattr_entry *xe)
 	return namevalue_size(xe->xe_name_len, value_len);
 }
 
+static int ocfs2_validate_xattr_entry(struct inode *inode,
+				      struct ocfs2_xattr_entry *xe)
+{
+	u64 value_len = le64_to_cpu(xe->xe_value_size);
+
+	if (value_len > OCFS2_XATTR_INLINE_SIZE &&
+	    ocfs2_xattr_is_local(xe)) {
+		ocfs2_error(inode->i_sb,
+			    "Inode %llu has corrupt xattr entry: local value_size %llu\n",
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			    value_len);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 
 static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
@@ -1099,6 +1116,7 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 	struct ocfs2_xattr_entry *entry;
 	size_t name_len;
 	int i, name_offset, cmp = 1;
+	int ret;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -1121,6 +1139,11 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 				return -EFSCORRUPTED;
 			}
 			cmp = memcmp(name, (xs->base + name_offset), name_len);
+			if (!cmp) {
+				ret = ocfs2_validate_xattr_entry(inode, entry);
+				if (ret)
+					return ret;
+			}
 		}
 		if (cmp == 0)
 			break;
@@ -3823,6 +3846,9 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
 
 		xe_name = bucket_block(bucket, block_off) + new_offset;
 		if (!memcmp(name, xe_name, name_len)) {
+			ret = ocfs2_validate_xattr_entry(inode, xe);
+			if (ret)
+				break;
 			*xe_index = i;
 			*found = 1;
 			ret = 0;
@@ -4463,6 +4489,10 @@ static int ocfs2_defrag_xattr_bucket(struct inode *inode,
 	xe = xh->xh_entries;
 	end = OCFS2_XATTR_BUCKET_SIZE;
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++, xe++) {
+		ret = ocfs2_validate_xattr_entry(inode, xe);
+		if (ret)
+			goto out;
+
 		offset = le16_to_cpu(xe->xe_name_offset);
 		len = namevalue_size_xe(xe);
 
@@ -4745,6 +4775,10 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	name_value_len = 0;
 	for (i = 0; i < start; i++) {
 		xe = &xh->xh_entries[i];
+		ret = ocfs2_validate_xattr_entry(inode, xe);
+		if (ret)
+			goto out;
+
 		name_value_len += namevalue_size_xe(xe);
 		if (le16_to_cpu(xe->xe_name_offset) < name_offset)
 			name_offset = le16_to_cpu(xe->xe_name_offset);
-- 
2.43.0

Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DCD23183F
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 07:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776322984; cv=none; b=LcPanC13by4OO2rRnUxm4V3Lee8ajvgxN5xOuNRU5pb9f6BeXxTsPJSlwHkdF0gpI1nCaCKXvysEOTPgop8lvVrffUxAb41+dINJx80GWifnLiZHSdUyIoKlld+0edReqig7NDeW3sbCe9/JgXbio6YnOViN2uLxN+4YWekDpc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776322984; c=relaxed/simple;
	bh=06tSmzb3uyiEydP/y4Tc2xYrMNoeAfwk71vRjS/qpAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KPSGHEQ8+dsemzYg0XCkFY+DFstshol3So4TiIGna8mf5jFZkBYFw26kF6LvrcCrpWyjzP++LInGLLMmmr9PisRj3pbMLqcCewyAZIHjXHn86k0dNR1ox/bUxUkMdmmQrgwNgPvGQzfM8RcREC0dl/DfZ5iwZ+ne7r2cKHZo1yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tAzBz6OV; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tAzBz6OV"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82d0b68837aso4189024b3a.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 00:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776322982; x=1776927782; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BmiIo4pDimTCK6yD7w6U/zwXcuTp5tvRAhBoqzdPhHQ=;
        b=tAzBz6OVLyXs8OB/dHCYWN4Yg1Q25ZkZYF1pSt7FiRsjkziiPi2HECfj2XMIvU65wR
         1f7JHVZ+cFFpYV56/DoqVvsc+lWZe7NNk38clY9UP5DJIlFc56s4ATYPMKNvVFq+Uexm
         r09A8YeR0NwJkQ3AX+YxTjriGU6owTAjlxyOhusw143kpUlBueiyRHSK31kHXJ8/Mc6l
         6oYmTfVooAPG0iwqcNmVfxNxSJ+LnT28kat+sHhYokyj+LLCaPgH8aJCX71NcQhrXoZG
         UuWHxaTueoj5zOZBjQgdfpIyayNOU1r/twJy/EhRnHrbh4sHzd0ahBnFiUHmVTKvTZOK
         ivWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776322982; x=1776927782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmiIo4pDimTCK6yD7w6U/zwXcuTp5tvRAhBoqzdPhHQ=;
        b=D0gH6YL9e1u+86PUPDvZUIZQnkD1lkakdp6Af1DoExW4RBCwQulgf0RVYAvLmWv4iY
         ORPnHpVYiDtt01pnJKqaysRj8cZYH0L73cTDPakKNznJ48CT/ev2poQ4zFL8nHfv48X6
         sR/jAEsfOKH6KpzLiRXkSeC4YlwjnPrZ5LhZAKCtZ+15spXX3060M8EeB/TyqbHnWhuj
         3ZOnaBCth4mE2EO+hf6yyaIyBqMwULoq/HuB7lpM8PCzZYFhyFGzyvAlMBnVsczLCVUQ
         dvWQbMAd4VQO+10JamW88mlHwxM3vA1VVHN7mv3fUZv/V5r6JaRwCz7pN4LrG8E9jSA6
         WyzA==
X-Gm-Message-State: AOJu0Ywi7OdtAXR2T2sCNOeuUsmf/VDqBKTnAx30Dz77TgjMMPSLTys+
	jBsMOJ123t0iTRPnTZANaeFlPQjt8CoKXF5IXMnZJ5VQY9DcyEAYRG7k
X-Gm-Gg: AeBDieu3Rno13q8BOoKCbp2uiA2TpbJsm7TjjjSHpai58PYcDeyQac7PVFEbJjrqOHH
	yuvMf8KlLUgks1uGG0zFS+yxz8HGki0I8bNo54tctmMS5mLRjVBsoYLbmzGHYsUPznw7bes/XOx
	FMS8HjUD/ycJpfPJNlODQ2frh7zSm415kMXNBysPSsJCXJ8NmGkyMAa8KWgW7naef2CWkUWeZNV
	/8Xg6XPbwb5aWvkG24GPUD9cpDM0H7jCDfQ0jewlWdkQdyGoH7QFcptgZNeZi1rwjwohAhdnLEA
	vgCD9uy+RdKql/jppsqHnZV1qJ7JxvALu5xmtN6oFkf7MlmZ8rko4hTXCJV+WxjynJCoL2bVf78
	lB8MWDQupfYvaOyJhYGz74hZBAyRQrBi2uNdfeaUvG/qIBauF+tDutWkvwDyEP4DVoWFEsCzK7c
	b+9n5xKW0kmbdmZrqrk6A0RyShrJ1hh1VGogXYx/h4vkOPs1lIWu1KPJhWKyprWNL3hIYyHXTTW
	sCyynj8AQ==
X-Received: by 2002:a05:6a20:e210:b0:398:8546:c3fc with SMTP id adf61e73a8af0-39fe3c62aeamr25991570637.7.1776322981958;
        Thu, 16 Apr 2026 00:03:01 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f6702f936sm4133610b3a.6.2026.04.16.00.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 00:03:01 -0700 (PDT)
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
Subject: [PATCH v3] ocfs2: reject inconsistent local xattr entries
Date: Thu, 16 Apr 2026 15:02:51 +0800
Message-ID: <20260416070251.481784-1-gality369@gmail.com>
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

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
No Fixes tag was added because this is more like a defensive check
that is long overdue, not a regression that can be clearly attributed
to a specific introduction commit.

[CHANGELOG]
- Fix Signed-off-by email address and name only; no code changes since v1.

Sorry for annoying everyone with a new patch version for such a minor fix.
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

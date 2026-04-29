Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D98140DFC4
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Apr 2026 02:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777429231; cv=none; b=GrCkUxo7KqPkxKz7uy7GlhRDaagFC5hzfKam4fi87o+YOXDw8QzcJdbHh15gkVFVqXecLXLDKA0Gvo54gYBA0XvhB2dQXbQBvqD2qbIiCZjtznJmfpFoD8oYc/kNVHb/hxVQ6PeRHzakv/fHWU5DLIYkZIYqyJfIHVLp8MqC5b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777429231; c=relaxed/simple;
	bh=Ke+9etmWZ1LmFVG84IReoMfK/YbTraDSF4t7TVPYwTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kV1CzLUwsr8b4pQjE/LEb+eQ2DqQ/rM23mGNaJ5UVt/jxwuSH0YjJetDqbezCq/R5p+He6u4b9utQXaUxWXhgfAWCt3jKblqOOvm5wlrrfM0wER92CAW61dxxDqwURmuToK4FscIOVVnnEHwHZlnz2x3NBNOGFzboCJshsADSTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g18+MlGS; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g18+MlGS"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso261457b3a.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Apr 2026 19:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777429229; x=1778034029; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ktD18KzMTUnc+4rPgU+clRQSsyYJUGFtwg9MNxlkxys=;
        b=g18+MlGSJ2HDzjIgpIl/YhtZgAc12Mj2KP2VfTnEbbMjhzO3NN84yCRC/CcVT7TivG
         +eIrO2Rdh+JsA5DkQsXO7N4dyLvVwB/rvmQuscFAJ3QwgCCbqwEQH9QVBo95hOaOvXt4
         S/WxLq78WXY6EpLYncwPq6PLqfpYIeamWuwFTem0KDD0uD3zhXqtNagag/wKLIdOJQX+
         Zutu0lmif3xcJofmYPW4rVITMd+CkcnhUrMtCKDkKvZJ65v6/vYSauHq5pdO2YtgXe+y
         e838aNLA2Mg7xUbhRUKnXAxXxaR9mjcfMeD8Be2fD3xeC+J3LBUgBQAsHGbO31obE+hq
         TU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777429229; x=1778034029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktD18KzMTUnc+4rPgU+clRQSsyYJUGFtwg9MNxlkxys=;
        b=EjS9LdJQKPPaxOkrKGP+KKW8HRgWU6cvqjpEvXZvTK7GnCx/VoNJS1a8fHMCzHzKSp
         nK5gZiG6iCXwWJO3rcMqDQUvqtNmSxJV3sGbhUwLhVtLNPrLvkJcTMaPr3rxkLw5bf0q
         aouTB0tVHInbqzi76FIVkQxStlradiOVkdHt/oqmEidhytw8dgMM9xvZ35yY+fOHIy3K
         u4pCOUGTaTUvPjvc59ORvEuz5Hyt3Jj99521vKCR9ywGxh3Eg/HTSNxlq0wJk70J2u1Q
         h1fmHSi/8qJ1lCimAu3jZcNxh/5v/atqrMHGDU1nP/38jYQQxY8zxrBumu6L3PFmbpT8
         ECnw==
X-Gm-Message-State: AOJu0YywC1KpiVO14L6ItrTXX8jJ1ACcOzUx09p8WQWxIC7yrfet6mZG
	qLf+aSq3D/6Al748cI71543gyMAyCc9qXmDRWMNb0BgdgN8aGPc3MQLv
X-Gm-Gg: AeBDievdQnuGb9aJlFIz3AuS7pfpBE/Fs/zcQxrSa/X3NdUqUDFrlOQF/wZZxDfJtOK
	yyUWog0QhI5w37uossQjpWi0M7aOZdMtPvGPkQILRgniTr+40kpR4IwmolrBdNd4wcBib0fJaXu
	FWtsUhCjbNFyyeaioclIlW2cXng5191l0m8kmNdc/ezLMmwxaNJ7gTSrYGTNBD3GHdEnvviUG3R
	Q6PoPL6r1sWc2IijWg04H+eHH8h9kbLjOLjXhRimeGnw6noJNq5ksxvPas78lffGKK8d8m9Xbqm
	GHrX2hk1sWbgtH6uuQiIKAfsSp10LJPhtCG15sNI33D8x9JDwRawCGGWfEo+xmEbagYMwR6DMF7
	lECCvTV3jpFdX1p+niYgT0saL9+KkvKserKshXnTDI7ubeXFmMCsOIpW3WYBaOJt7mPAZRaxB1+
	iyKUg3tmDUIQlgpwvRp+hnHIbj/E50Y6VaxNgECuf3f76IoL49rHA5P3ofC+us0Lep7drIceumO
	/JrdJPHpg==
X-Received: by 2002:a05:6a00:2e93:b0:82f:2d48:f8fc with SMTP id d2e1a72fcca58-834eb3e4d01mr1175514b3a.6.1777429229252;
        Tue, 28 Apr 2026 19:20:29 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5a1026sm425937b3a.4.2026.04.28.19.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 19:20:28 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate local xattr value bounds on lookup
Date: Wed, 29 Apr 2026 10:20:05 +0800
Message-ID: <20260429022005.1461600-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted local xattr entry can crash ACL lookup during open.

BUG: KASAN: use-after-free in ocfs2_xattr_block_get fs/ocfs2/xattr.c:1261 [inline]
BUG: KASAN: use-after-free in ocfs2_xattr_get_nolock+0x8cb/0x1110 fs/ocfs2/xattr.c:1312
Read of size 252 at addr ffff88801e7dbfb8 by task syz.0.1/347

Call Trace:
 ...
 ocfs2_xattr_block_get fs/ocfs2/xattr.c:1261 [inline]
 ocfs2_xattr_get_nolock+0x8cb/0x1110 fs/ocfs2/xattr.c:1312
 ocfs2_get_acl_nolock+0xb1/0x3d0 fs/ocfs2/acl.c:137
 ocfs2_iop_get_acl+0x197/0x260 fs/ocfs2/acl.c:313
 __get_acl+0x33a/0x480 fs/posix_acl.c:159
 get_inode_acl+0x2b/0x40 fs/posix_acl.c:184
 check_acl fs/namei.c:333 [inline]
 acl_permission_check fs/namei.c:419 [inline]
 generic_permission+0x509/0x670 fs/namei.c:472
 ocfs2_permission+0xeb/0x1a0 fs/ocfs2/file.c:1366
 do_inode_permission fs/namei.c:526 [inline]
 inode_permission+0x317/0x5a0 fs/namei.c:593
 may_open+0x10e/0x350 fs/namei.c:3565
 do_open fs/namei.c:3973 [inline]
 path_openat+0x500/0x2ce0 fs/namei.c:4134
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_open fs/open.c:1460 [inline]
 __se_sys_open fs/open.c:1456 [inline]
 __x64_sys_open+0x12d/0x1e0 fs/open.c:1456
 ...

[CAUSE]
The lookup helpers only validate the entry position and the name bytes.
Once a name matches, ocfs2_xattr_block_get() trusts xe_value_size and
memcpy()s that many bytes from inline xattr storage.

A local xattr entry is only valid when its inline value both fits the
local size limit and stays inside the current xattr block or bucket
block. That invariant is never checked for matched local entries, so
corrupted metadata can inflate xe_value_size and drive memcpy() past the
end of the source block.

[FIX]
Validate matched local xattr entries before returning them from
ocfs2_xattr_find_entry() and ocfs2_find_xe_in_bucket(). Reject entries
whose inline value exceeds the local limit or crosses the current block
boundary, and route the failure through normal OCFS2 corruption
handling.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -237,6 +237,29 @@
 	return namevalue_size(xe->xe_name_len, value_len);
 }
 
+static int ocfs2_validate_local_xe(struct inode *inode,
+				   struct ocfs2_xattr_entry *xe,
+				   void *base,
+				   void *end)
+{
+	char *nameval = base + le16_to_cpu(xe->xe_name_offset);
+	size_t name_len = OCFS2_XATTR_SIZE(xe->xe_name_len);
+	u64 value_size = le64_to_cpu(xe->xe_value_size);
+
+	if (value_size > OCFS2_XATTR_INLINE_SIZE)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has invalid local xattr value size %llu\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   (unsigned long long)value_size);
+
+	if (nameval + name_len + value_size > (char *)end)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has corrupt local xattr value bounds\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno);
+
+	return 0;
+}
+
 
 static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
@@ -1098,7 +1121,7 @@
 {
 	struct ocfs2_xattr_entry *entry;
 	size_t name_len;
-	int i, name_offset, cmp = 1;
+	int i, name_offset, cmp = 1, ret;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -1121,6 +1144,11 @@
 				return -EFSCORRUPTED;
 			}
 			cmp = memcmp(name, (xs->base + name_offset), name_len);
+			if (!cmp && ocfs2_xattr_is_local(entry)) {
+				ret = ocfs2_validate_local_xe(inode, entry, xs->base, xs->end);
+				if (ret)
+					return ret;
+			}
 		}
 		if (cmp == 0)
 			break;
@@ -3790,6 +3818,8 @@
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	size_t name_len = strlen(name);
 	struct ocfs2_xattr_entry *xe = NULL;
+	char *block;
+	char *block_end;
 	char *xe_name;
 
 	/*
@@ -3821,8 +3851,15 @@
 		}
 
 
-		xe_name = bucket_block(bucket, block_off) + new_offset;
+		block = bucket_block(bucket, block_off);
+		block_end = block + inode->i_sb->s_blocksize;
+		xe_name = block + new_offset;
 		if (!memcmp(name, xe_name, name_len)) {
+			if (ocfs2_xattr_is_local(xe)) {
+				ret = ocfs2_validate_local_xe(inode, xe, block, block_end);
+				if (ret)
+					break;
+			}
 			*xe_index = i;
 			*found = 1;
 			ret = 0;
-- 
2.43.0

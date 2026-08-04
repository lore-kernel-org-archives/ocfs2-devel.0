Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45EB1DDC33
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 11:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842898; cv=none; b=oIXGZc1qoHmRdFUjQlZnG8vypV734NaH6aXV19mRBzTYZWrsVLJIthseY0q8gCDMDL9YQLOlbx7WXhYQO8tbiKgmkAHimYnEQlJ3yhJ08P52J/K//sYQm3eVJitWIe6MPzOlzbnZL/HDuyRpID3/JdN8csFKTmIfVrikKLIu728=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842898; c=relaxed/simple;
	bh=KO2OV2STES7nLJI5YcagXubEzsSjxF6ir1qysG34SFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RsyhF6cimHsUd0JhWkXSdBuY/QbFwEXVR2NDdbk89m8IKMiLRyjYV4DlDn18gQpxhAPebiryyuL8AXAEhf5qxq5Nethx0TFH9J3MJIUXif+XlBm2qmxc4DuTlJ0koEugJOui49lHQN/GI3UtSxIj1WXDtzVnuCL0Y7K/fve+mLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bQvvODt0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQvvODt0"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2caf228a910so32970955ad.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 04 Aug 2026 04:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785842896; x=1786447696; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wLGM4HsxB9QNmi4xynGNGSDdZvCkfUWtP8BwxzK2OkI=;
        b=bQvvODt0C2N5YgpOvgRTmomrjLnb6cVH21fSQ/Q9yHB8GydBjG8ughkBZAWpr7UZXQ
         CiWiklLp5B0ZCt9A+hNWMBN/xPADf9RWIkgl6lmWJTq8SSfmmTRypnK3Ua/9lPCpdt5U
         aWOH3Jp0GoqAuY2ziXs5kjJV31BqmxV3jdU+S6PZ9GIjgzv0BisJtuVd8Ou3fIJ0n4jg
         ggr2myjy6vyh9t1UrunEU/NcJrIl5rG27fmwI2AOopyqg/zt3FCkGWWQ9dcdFGkgeK3X
         v1YRNK66xwQ37Vnltnc6lHRQqGrEPGxLqrhg9JOuCaXnRQXp5WKzcyneXyQAIiHiDyhE
         DTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785842896; x=1786447696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wLGM4HsxB9QNmi4xynGNGSDdZvCkfUWtP8BwxzK2OkI=;
        b=pAWbdOqJN7h11NbgkJelE388Um2i6dXLbtTVBErzB5LWs33hOdkkaKeciLVi+2jzPw
         GPRqIVhFfiFZncDtmRkNEpy7kdvDJZi5JklDxzHeZEWam8qavQggDoEJe2shhpDbGhbG
         MyoD+5P/PolXUADaeEWycRSXIdqkCUP3+YnTuLBlEgNmMz0u7co5Y0EEfy1O+GOyH/GG
         ULI4XUEezH3Ym1y671pzlgDksUqzEs3QtmNflBkmsz18JZCGp2EQwvVh1+0OSAOYXs2s
         sNdaunzPU1yiFJn836/PNgTxBS0m2mPvBwysxkryywOSFxSS+ZEAANsU8sOJHmIWNYJ2
         yiAw==
X-Gm-Message-State: AOJu0YwEJjRWt1ZmByANpCVkjE/54kDBN4OLHWD+Qpyahn1oIP8q1N+M
	sqmidKpGmLoGLDowf8GtYjZl5kKuEOXHRQHp4DNXauvYfQsjlJRnvS/G
X-Gm-Gg: AR+sD10i5gl4t8+RXm+Npe97BbFkFbFfy93XiisdX7Dz8J9ROwtXvuX4j8IQYgEMAbd
	KameyBkHRCfax3ysUOM2zfVNxF+NDOd/QVugHYDL4uvtJJv0MgzWvzu3Dm1F8zA+OBoEDJX2eIf
	5TuDYu/JohwEhQSsjoZB+pvhXl/DTSm7zh/7xvqm8T1ksxEf+WPtx5Tn3C3/ducLBLY7o1auFdr
	9qNxi5W0+8P+i75RP5hKW6bsgFQIwK5NQSgUVomWIzaCmBBegD00gS6dvZCp+DzqvW1RNLuvMZ5
	KdKyrSdhBYcgCqdy4FX4l0J5p9xfUyHr9zQkXXqXW3SNZoJ+aKKVj8c4inifh1WwkCgpJqSlLnl
	Hzze3DwFlmjBktRioil1tIofznqtdGibI2XWGm6ke2RwZ6hkRLMhUfWeJlZ+1nBlPP5GIi/reuC
	ZidfUCzyIXCqwglLYkQ+5M6gCTTFRhymnxRHhr716/0Yu93ug+TCF4CL6vLV9E+3tTDuDByA51b
	hAVLbS+kZhOm/mEttKESIjX8nQgRA==
X-Received: by 2002:a17:902:ce0b:b0:2cc:f4d4:299f with SMTP id d9443c01a7336-2d05229b34fmr146593905ad.27.1785842895912;
        Tue, 04 Aug 2026 04:28:15 -0700 (PDT)
Received: from gmail.com ([138.199.21.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0a9f936e2sm5751595ad.2.2026.08.04.04.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 04:28:15 -0700 (PDT)
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
Subject: [PATCH] ocfs2: reject inconsistent local xattr entries
Date: Tue,  4 Aug 2026 19:28:06 +0800
Message-ID: <20260804112806.1219362-1-gality369@gmail.com>
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
keeping xe_value_size larger than OCFS2_XATTR_INLINE_SIZE.Once
that entry reaches namevalue_size_xe(), the filesystem trips over:

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

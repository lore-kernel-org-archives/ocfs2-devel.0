Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5E248166
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 04:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776314898; cv=none; b=qQy0fF2UOEpFlcrxEohHuR+gr5yJ5w6GkPFGJqsMUKaeqAQ4bqUJpq/xziR0mOsGm7QsJXpOppSUoZDIpfpPU+xxgwaUa6qGjg+wJ30eOUbX0bwXC8DcpbfAymMWfiNoVR6/CEE2/ozbmoahbeczCYG2IsocpMDn9hOj6Ury1oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776314898; c=relaxed/simple;
	bh=1kl9AyYyf2KfnOWMYBK+l9GVAFM8MhdwPPSjig1yEKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hEU1m/8T74J4teO70YW49OUa+6oBcuRddBHEolIIbTUFkp+WL0HjWCh0lnE2SOJbA3jWjY8cqtPUblnoeSA4XfvdAqSz0VDKhDTW3Yz2eKa/JCt5aku28gwRYNfW0LOTZtKloOb4t58uCQarrr0eRhtTkfUHjOjGR79hi8oadYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cdd9zI71; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cdd9zI71"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35fc0d7c310so2217999a91.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 15 Apr 2026 21:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776314897; x=1776919697; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ocWoS6b1EZyIiNsa6xdsZkOFjYKaXDHdjKcTd1GQEq8=;
        b=cdd9zI71qWBZ5O+sxJ8B0L1S9b8BEqJ3t6Fkj08Ki7uWEGSDhLNcgdGnVyZciex2gV
         bofkSeT6bWRYxrQz43CzH8WD+m5Dm8w5Chj97UI1IvuQKFbTvTvpuHHxRMbXQmOTQrj1
         t65rgB98hrFx1gpyv/GL3UGxUlvWnyF9GhSVLhEGu9msr0lo253dc1Yi/I03uVMotE0p
         wHjUAFrb8mhmGBictjzz1ffs148BSoKCdtxk1yYL4s/2UPU//s/FUzmUbT5RfvSQXVyz
         XNNULLwJYYuDJzT1n9TXbsL82le7MvMror7PRqHyW94TuQyWB8BaKnIpH4oz5KPm39Dd
         hsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776314897; x=1776919697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocWoS6b1EZyIiNsa6xdsZkOFjYKaXDHdjKcTd1GQEq8=;
        b=PNgrjHy/W99HwQRjve3+IHeZi9tq5BSzYDiQSjrnGIs0vr2loNZhcOVEMhGnPwJte3
         /xgyGHPzwtqG8+zvKVfp5CwMb9HYi8QffuW/xfONJiYUWsrSxQOKiuBellBT5GqLOzY6
         4u6ZWMNbqHSc5oJVtpfuXdH2XMYNrUWlivtlxICiR8AfFepyJ9XRMw3esX9BeFGgMp+n
         om0R6Z3Xi0mQvlA3DOWgT8DcVDE3TBz//2k0V0Rct7+pJIO/jqZmNzDo1CA8HEUs2oCk
         i9jkcLXJM3wwIczyol9JGz3fr2T2XKhPJfdyzNP4wD0/+kMM4kHpqU4ZaC4zvWWiTc3M
         Smjw==
X-Gm-Message-State: AOJu0YwOV8Wpd60JNXFogZs97aALEt38UYvx+MixCXrRVjah2jOYX6sY
	xqjvo5Ti5VRCca8rNI5T4BQWpLL5BKx6owF9cmP1JZkHXzD24BMROH9a
X-Gm-Gg: AeBDietoi7EW+EmiRx6bSHzs0c4bJUQguC2GSu79m7qez4MUowSoVdm75mV0UMvBkEU
	1ydPrC8SXNdm2Vr9/U78PiOfR4MqPnqG520FnvkdlWVeWc1kaeKoNPmOqHXRdEnIu/X6qziG3fU
	F8LXLW8zJV0QIBGm0Fhmiym9ev7KmV7CI5lmvans9U198g6fcMTz164m/m/FXzHUJsQM1adakMB
	/ZpVq5KWpqpGeep3O0T+Pmr2MrOP9M05dPSMaxjQbIjPpyfZFaK4FJPmXlbwmJL5j+14QijHyyM
	hnvN56XQJ4lncUJ2gite/p1R3cA5VGEL1eliBq2dlG1RsPSrN8h5Q6MwqgWdw6q4jhVyKUspzAH
	GDoxuHuc0VYkhrY+hT3h3Na0GW8PKOJ6B5IuvZ1z3AFu59jx3zNENEbKAn5L1JxZg135eJnHnTX
	usYPMqRYD03BYUsF/qDc2M+58UTqcfvmuy3Wr6NoBswnJ57RZ0yelgHjAmCN4hE2meSoojMb0tf
	w==
X-Received: by 2002:a17:90b:3950:b0:35b:e4f8:7cc5 with SMTP id 98e67ed59e1d1-35e4284c7e0mr23281440a91.25.1776314896515;
        Wed, 15 Apr 2026 21:48:16 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36132c8bd25sm1010534a91.3.2026.04.15.21.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 21:48:15 -0700 (PDT)
From: gality369 <gality369@gmail.com>
X-Google-Original-From: gality369 <gality369@example.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	gality369 <gality369@example.com>
Subject: [PATCH] ocfs2: reject inconsistent local xattr entries
Date: Thu, 16 Apr 2026 12:48:06 +0800
Message-ID: <20260416044806.3007438-1-gality369@example.com>
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

Signed-off-by: gality369 <gality369@example.com>
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

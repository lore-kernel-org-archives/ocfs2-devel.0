Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F78A3E3C58
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 09:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776937287; cv=none; b=KrD25Z11Xfm4u2v1nBbkrefLsgqkhoF7eeLp3B4SG+NOPNIT8+vjQNxvI2jAapL0HfcKnnqew0Aqfw+4Y9CXFGC90J+EERnt8I14kaoqtnsgi/JGeO4R3Ox6GdIDdZ2zGHEwBqvqDdBuFfNYFKtBFkYADptRN3rDYA7CdO/Exw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776937287; c=relaxed/simple;
	bh=ihmAfo21IMLbCzr7j/S706oEA+WU7/yAbjbZECWwRKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/R8a7wx6Q8WyKU+XFiC1GXVtg48lMLXJQ9s+l5Y7vYphqmg7tlEJH5cydRAhbKt5kyERQ5cd+dL4449uj9vkgUvtQiHA25nzIx2Xq2ACXqnSpao/L6Fx70KRHqREWGY6hQQGpCjKTSDW+UPWm2akqVL64Qhc1UXHF8nI3jwYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJg+9196; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJg+9196"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82f6b592fc7so2962866b3a.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 02:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776937285; x=1777542085; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MjXWV2juw1vRp8krlN6jQn7bDWv+2fW54+D1FPrGink=;
        b=fJg+9196ZOXPAOzE+Sktcpnw9zHvCEOkcyiQgkFPKVSYo5B4O8ZHFVQgWBUNPklm/E
         3PqM49rjXzAmMsHP/2UN7E5DMb3jwSDgH+RIaJ3q3Dl4KStMSGyhzBoswVj4coTBe7iE
         W3KLqRgBe4uTMeuiKxDA+kBAVgD4lM9bc+U0iJ9xBVRb+74Rt7b2p2LvU4o5K9DfOvr7
         F/QsEMDw4SUprshiO8NmfWio1OWxnrYpHODuzK1M9dsi8HGD4bLaOuRl4jlOMLqQwx2N
         FCM5qGgmTrsRGk7GBXVgO+5pa+J/3VHfH5pdSx8AnZPGB0UrB8/F7hN+lbCGZKC88Baq
         t0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776937285; x=1777542085;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjXWV2juw1vRp8krlN6jQn7bDWv+2fW54+D1FPrGink=;
        b=e91ywusJk+9U0Ur1FVZI3F276/gsAro05BLag6GlS16bM2ANvuKfhx8QWdX8wgAcCP
         p1/SLNqiaz8PxdDbIwiDvXPDWCVgd8O3WNj8Ehvct81ByoTE1J53Rz4vmtf9Z8ocIbT+
         R/Hdws39XrRTZubYu40NYdPFrCYBjpX3DpbENKZANlR58JLVLnWoYKzwN3G1bR++9L+F
         l2XOTcgBkBBHhsVWQPACcaQmYVCgC7P3301DkMgpX9MOkz9Ma8SfJoerxlt43PV2GSiB
         cQ2IXDuJDORbar7Dgmnk5nR0K426eaOmWiZqCRA+iXp3agNTapgrbuAX2xe72YxvpL1w
         ntNw==
X-Gm-Message-State: AOJu0YzGVUIjy4+T3F9+mFBGj3YI6aRgMv7g1ho8+JeH+Nuj3/uPseh/
	L1hLec54vR7ucq55zVa/CZVhfgkHUl7bDtItcN0ym6xcfOXAQIs0uPGK5u2oE0Jxpk0=
X-Gm-Gg: AeBDiesUA3VFNfKFTsYtrerQoq9TohZMWB6lgP2SLCvj0HYQ9Flc6YZicCGGHss/cTh
	2Gn11rXiaIqO0gfCN1G16Q//HKWX19GEayVE0gvYz2E2uQXZg9OZTXph3B4oE91QiwmDCn+mMba
	IcQ8Z1M41nm13YB/nuJl+OnS5n9ClKdjjYc6ma63ga1AMcHl0uqGyEd7qsmoX3K82Sn6GomTks2
	wtel8PMlKoOi5LqYYEUYQ0x09xox9K2au+CZyodATgyLCdevbfKdIr9z7ZjNXKDOmeNsK28JKZE
	t3yFizuSxmOXjT+XTz36SPCpHPWYhwgPzT9ljC+5CMR/RaUWdhsKaAHlrvVxq1K0k9IEKjVKLrh
	O9bPSUAnml+RTg5kan9iU1BtsfTqTDDL7wU4Q0hErsL5SzJUExBJt1iZJKnilisQuTnl1AEvo1t
	p/mSGSERf9rd7DZy8IqqXMtSy4oQODRnhod5k6HBP8F1cjSLZUWwuEekE2a1lbxma1j9jZgiuy8
	PFdqnEMp1Dcct1NAYWz
X-Received: by 2002:a05:6a00:bb84:b0:82f:1d38:f693 with SMTP id d2e1a72fcca58-82f8c8e0f98mr27141046b3a.35.1776937285181;
        Thu, 23 Apr 2026 02:41:25 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e9cbb1dsm21547319b3a.14.2026.04.23.02.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 02:41:24 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: validate in-inode extent list on read
Date: Thu, 23 Apr 2026 17:41:15 +0800
Message-ID: <20260423094116.876696-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A fuzzed OCFS2 image can flip the high byte of
di->id2.i_list.l_next_free_rec. Later
openat("./file0", O_WRONLY|O_CREAT|O_TRUNC, ...) reaches
ocfs2_commit_truncate() and indexes past the in-inode extent array.

KASAN: use-after-free in ocfs2_commit_truncate+0x16ea/0x1aa0 fs/ocfs2/alloc.c:7310
Read of size 1 at addr ffff888023e900c7 by task syz.0.11/360

Call Trace:
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x650 mm/kasan/report.c:482
 kasan_report+0xfb/0x140 mm/kasan/report.c:595
 __asan_report_load1_noabort+0x14/0x30 mm/kasan/report_generic.c:378
 ocfs2_commit_truncate+0x16ea/0x1aa0 fs/ocfs2/alloc.c:7310
 ocfs2_truncate_file+0xcdd/0x13c0 fs/ocfs2/file.c:509
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
ocfs2_validate_inode_block() checks dinode header fields, but it does not
validate the in-inode extent list layout for regular extent-bearing
dinodes. A corrupted l_next_free_rec can therefore exceed the fixed
record count. Truncate later uses l_next_free_rec - 1 as the last record
index and reads rec->e_flags from beyond el->l_recs[].

[FIX]
Validate the in-inode extent list when the dinode is read. Reject lists
with an inconsistent l_count, an out-of-range l_next_free_rec, or
malformed used records before they reach truncate and the other extent
consumers that assume a valid in-inode extent list.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Rewrite the [BUG] and [CAUSE] sections around corrupted l_next_free_rec driving the truncate UAF
- Keep the code change unchanged because the existing read-side validation already blocks this variant
---
fs/ocfs2/inode.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++-
1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adc..7fcd1ee4fd46 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -215,6 +215,61 @@ static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
 	return 1;
 }
 
+static int ocfs2_validate_inode_extent_list(struct super_block *sb,
+					    struct buffer_head *bh,
+					    struct ocfs2_dinode *di)
+{
+	struct ocfs2_extent_list *el = &di->id2.i_list;
+	u16 count = le16_to_cpu(el->l_count);
+	u16 next_free = le16_to_cpu(el->l_next_free_rec);
+	u16 expected = ocfs2_extent_recs_per_inode_with_xattr(sb, di);
+	u32 prev_end = 0;
+	bool have_prev = false;
+	int i;
+
+	if (count != expected)
+		return ocfs2_error(sb,
+				   "Invalid dinode #%llu: extent list count %u (expected %u)\n",
+				   (unsigned long long)bh->b_blocknr, count,
+				   expected);
+
+	if (next_free > count)
+		return ocfs2_error(sb,
+				   "Invalid dinode #%llu: extent list index %u (count %u)\n",
+				   (unsigned long long)bh->b_blocknr, next_free,
+				   count);
+
+	for (i = 0; i < next_free; i++) {
+		struct ocfs2_extent_rec *rec = &el->l_recs[i];
+		u32 rec_cpos = le32_to_cpu(rec->e_cpos);
+		u32 rec_clusters = ocfs2_rec_clusters(el, rec);
+		u32 rec_end = rec_cpos + rec_clusters;
+
+		if (!rec_clusters) {
+			if (!el->l_tree_depth && i == 0)
+				continue;
+
+			return ocfs2_error(sb,
+					   "Invalid dinode #%llu: empty extent record %d at depth %u\n",
+					   (unsigned long long)bh->b_blocknr,
+					   i, le16_to_cpu(el->l_tree_depth));
+		}
+
+		if (have_prev &&
+		    ((el->l_tree_depth && rec_cpos != prev_end) ||
+		     (!el->l_tree_depth && rec_cpos < prev_end)))
+			return ocfs2_error(sb,
+					   "Invalid dinode #%llu: extent record %d starts at %u after previous end %u\n",
+					   (unsigned long long)bh->b_blocknr, i,
+					   rec_cpos, prev_end);
+
+		prev_end = rec_end;
+		have_prev = true;
+	}
+
+	return 0;
+}
+
 /*
  * here's how inodes get read from disk:
  * iget5_locked -> find_actor -> OCFS2_FIND_ACTOR
@@ -1552,6 +1607,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (ocfs2_dinode_has_extents(di)) {
+		rc = ocfs2_validate_inode_extent_list(sb, bh, di);
+		if (rc)
+			goto bail;
+	}
+
 	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
 	    !di->i_refcount_loc) {
 		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
@@ -1812,4 +1873,3 @@ const struct ocfs2_caching_operations ocfs2_inode_caching_ops = {
 	.co_io_lock		= ocfs2_inode_cache_io_lock,
 	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
 };
-
-- 
2.43.0

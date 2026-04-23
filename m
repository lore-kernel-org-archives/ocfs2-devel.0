Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E61F311C35
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 06:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776925201; cv=none; b=oQ8++fmvBRKthbTHUgUEEeI9ULPhfz8C/rB3a9mMlurfmwJeD+iuRtSYDShNX5OjKhZWTErS2d2i+i2cuK7jYiZwQuAxtQCEXbtpS2sV2xOLLYFhxm5QB+quNVaRDh5kWjyZqLrUiYpG6aqPQKt6fqeppJc8ZhnUW579z+sW4Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776925201; c=relaxed/simple;
	bh=K8ZsVQLPegV8e9sT9EjZu/XQUyr7UJGBZqU+kW5+Ans=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A5Vl7ilqnQJhmsErXAWtnoWfWj3nc19sACKAk0BMZYN+T3C7Nme1kecVzeQrn6popUWjW5VMKxkKvq0myGlVXVRbgvrqVQM3zbMNSI4TKAN53W59Mbk3GjnL6nLK4qhl+KXhDCV2G+Qq5hCwzOV1b4mb3Fe4WLQRT6R1qQF2fuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QK/+X4e8; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QK/+X4e8"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c797d5ad36bso1923669a12.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Apr 2026 23:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776925199; x=1777529999; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g7CjthhQ1zGt/55R1Df+u2r8XP4Pm/aFZFn2crSaK+k=;
        b=QK/+X4e8WF3adzgqOmjPWAtohtfQDbMjYmlI3YcFaYn3JGy0OUcPr1ZzHGZQ6ySojM
         F6iCP31YGwiKnCypRsymuhvdOWFqccQe7wQNr2Lfe9Q2Mlwr0BU2KKbyVSlmUH9zw5Ap
         dDZmzZ0Ojp8srD5S6/lrpaCPRzJf7u0FjjyoXmmrVHXD51RmORgRPe5Kqot9Uk4GI1o/
         vpjNzXO0Trx5/xeID/b6N8CLpPvtE/VyUrpWUwCkqNbmPkh4Dpt8Mh3OSTi1YsJcTxW9
         wbC9zkd+hezU0svRuL9/ywyUZeCFb7QC6qZHyXUsDQ88xYgCoBvjjn+LXjh0JJdSNLaX
         iQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776925199; x=1777529999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7CjthhQ1zGt/55R1Df+u2r8XP4Pm/aFZFn2crSaK+k=;
        b=AnG5k2ibwL3ey3J5oN1byTPbIR6NnudNk8NWVY42P7c0M4ohiBVR94Fej+BQ4vzw7w
         uDUsx8C1g6Q2AwAQQqw2hHLa5jgB4a5kuZqlAKw6RtK3hqPdeU7shod56c1FUDutx9kE
         0vM5PQulhGGUHuOr7jAZtOEaIsXKS/DP6YJLHYDvwbywcKEJiy1fqfWC1gQCvene3Qlz
         FXcd5Ej2aq7my3HFg8m4ZOIsbBKH9V4rP/l86nrKlYsvLkVrPXcrd/JPuoqIasYtSWr8
         2oQ7P9+bw6dXt1wbiACw/Zs02oGRqHO8i7KDAJAZ/Pf8N2qtB/zgnQ87lcI5k/Hk23NY
         sryA==
X-Gm-Message-State: AOJu0Yw9yaUX9vZCv4aFuw0BzA0TkITPmF1AwABbpCyDC/MfJsA+9tJX
	grMdiyynJG9P38W9TMW6a//b9Y80QEyQHcOS4PDbbR72m6VP+EJ/x2/T
X-Gm-Gg: AeBDieviiYk2PQpHoHj3KiwuB4/nftcYBIZKoziK0Nx+YAI5WxQWozdc8iY89MFCA2H
	rGTWuStmgaip22oNL2Yd2apbVURh0gxowvG2Tel3W9+AKwBAIm41w05gy8oNo2XnNMHadP1Tdx8
	hukEtk/csomdaASohN8tjmso1+nr7b1Jj0O7iGBhzf99/QoSX1jv2dyqVB3AaAD09fqDMQ5riw1
	RkyGt94QIlSIp2guRYQ6fiZufRNf2/2gzxV2LnP5sGwNEp44wyqvafpWtA7wvJjjuDnIULN9JBS
	LTJgtiw8eEkljl90qLrRojIhxWx48oBvH69wUA04Nyv3psX0x7BiJyEKZ1aStg9RgpgzBSCR/ux
	fP/mAegwuxVc+VVCTzey/4M1BOcizwaoJmvqTx86WAe9ZNQ+ZkH1W4Y1dq8IQtL+XwJtwnMt0xd
	2hpzKvE3DGaLz7Tn9RcesAL+jDaU/jjlwWsaogj9wkAHBwjzL44/8Nr92iKikmhRHcemXE0hKV3
	tvk8dpRuA==
X-Received: by 2002:a05:6a20:9146:b0:3a2:dabf:fef7 with SMTP id adf61e73a8af0-3a2dac003bamr15064662637.26.1776925198873;
        Wed, 22 Apr 2026 23:19:58 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c798b56a758sm9376262a12.18.2026.04.22.23.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 23:19:58 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate in-inode extent ordering on read
Date: Thu, 23 Apr 2026 14:19:49 +0800
Message-ID: <20260423061949.3586636-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted image can make creat("./file0") truncate an inode
whose in-inode extent records overlap.

kernel BUG at fs/ocfs2/alloc.c:5581!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_remove_extent+0xdbc/0x1600 fs/ocfs2/alloc.c:5581
Code: 0f85c7f9 ffffe873 a7cffe48 c7c76025 4e86c605 a0db9605
Call Trace:
 ocfs2_remove_btree_range+0x98b/0x1520 fs/ocfs2/alloc.c:5778
 ocfs2_commit_truncate+0x6b3/0x1aa0 fs/ocfs2/alloc.c:7372
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
 __do_sys_creat fs/open.c:1530 [inline]
 __se_sys_creat fs/open.c:1524 [inline]
 ...

[CAUSE]
ocfs2_validate_inode_block() checks dinode header fields, but it does not
validate the ordering invariants of used records in di->id2.i_list.
A corrupted inode can therefore carry overlapping leaf extents into memory.
Later truncate code derives the removal range from the rightmost record.
ocfs2_remove_extent() then re-finds the extent by cpos and can hit an
earlier, overlapping record instead. That violates the remove_extent()
assumption that the requested range is contained in the matched record.

[FIX]
Validate the in-inode extent list while reading the dinode.
Reject lists whose record count is inconsistent, whose
next_free index is out of range, or whose used records are
empty, out of order, or overlapping. This stops corrupted
extent layouts before they reach truncate and the other
paths that assume a sorted extent list.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
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

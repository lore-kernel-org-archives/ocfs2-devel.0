Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538833C7E18
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 03:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776913764; cv=none; b=EU8VVzxI6CVRClVtsrbtCnIS82ZavdEnf38PVqo5GRt+1t7AwiVrGI/Zodr1asKvUTVR754kuGSo1a80HnTnUh/mA7bQUMLMUQ4MtvKmd4kJwNjMYspoUCkOlVW3ltBpJkOJC1JAvuc8Y/yZ/aOGWNsDyL7+5cWLKxgXP9xsuGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776913764; c=relaxed/simple;
	bh=MLH66ojpKVhwLhBTehIr39sCh+EmmhiE41yyw5U6QAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nUwgI/sGs2Xo/jRXMGA+SgFDc59RfWI4UAWLy3w/yfCECAnbnG0hLNzWoJoV2ZBwtKLPo8kqNABov488fnb03uQahoaBMLCeR/C32c/kQzEGdMtVDcHyfwtLBI9iBVp2V9eQd18Svr/Sz/6Oot/0fLvsG0FlP87Osv4B/jhYZko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cK/RTtii; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cK/RTtii"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-358ed696623so2814904a91.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 22 Apr 2026 20:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776913762; x=1777518562; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3VW1kTSn+x/uimseDbthu+BoZ7rGPr/N04/pCvrInfM=;
        b=cK/RTtiiNcuxqkv40dMBk4gZzSgYW38o2tXhTvR93NMIRbvJJDxJKwsyU6ZAsZOqfj
         kggr7LmJ7BnhuUVn+3bnv4DBQrd2vFVD+OeeJ+lwp1RACaIR47p+wKFe0PGvL3vuzkL0
         I7Tf+TgqADA35ak/MDsJlpGkjTsxnzpyp/bc/qPfQ9n0olOHhwjwF6WN8+vCuhq5ZAw+
         VsF9mHyF5yDWMKnPqZByfZsNxD5po3BD2Lj0ITDbF3EjTNgknfmSqhOlrO+FKx6G4CZW
         okPHRfygdl4PsvzJFGTZo7wvlRQU2ZQUo/6660PKoevaCdbpTw04AgupHxSlou56XW2D
         vGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776913762; x=1777518562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VW1kTSn+x/uimseDbthu+BoZ7rGPr/N04/pCvrInfM=;
        b=lHoRcYDh4+EwLyu8mDD/08/KicyAuKTTKfiLGlTF9gWMfL9rno2UjeI2z4Aq+g6zEC
         XVxFLP0vtZFY6biCFFOmcNOc5Mmgcqo08RD0Iam/MQs/UEoj4I2PMFVf/VnhlBa/67kM
         uXmOGfsPw5Qf62j4kxdfMItBMaNh5osqWSDis0sgqqg9kldLyglwV4vZlM/dsxlq+vAf
         /V8aG8PQ+GRlzOC7I0DjuDhy+N6QqvatpEDNSHjVHo5HhaILJCZm57LaLAUtDfXSWcFD
         urhPtZw/iwFrbLKmotrMqfOrmCQxyMEFSwkD5y4/YHY1sweeJOrZIfBf6T3pf7tZUX7K
         B4Vg==
X-Gm-Message-State: AOJu0YzUYkVzuF2KpVEE1ejYDjHd6/MtIOxUrf0qrWcHAH2efZGSathT
	4dBAVRAADhYQKmIxnBR7PbMrmUxIO9x/EMBa38VYF7QyUieKvWH97tBI
X-Gm-Gg: AeBDieu2raB/ExsWMnRvGDBMikYijcvLRLj50MqPD9JY6vBVoLwAGcbDM1jgKKLY6Pc
	J/bX+bB3o7aotDNv+2j16+0hRFUv2XEpfv05mR7CbfwP619W9pLwT87l0FtWyxrSMO3ZUf97i2C
	oTxOLGeO+PE0DfMqsPIO6oVlrXGhlrsekmzH7FDcUGNzLH83OagKVRcOoL+4eqFZIbHmkSso43k
	Ek7mQJ7xXRs9z9Lvv9mJZsBCTQ8jYQTr3IMBDyPV/Fu/uAEVZPeQGIryRvLWdSyHjxIiTfSas4B
	+x+JVzJroo5ob9Zek5GQpSueDrR22zfOfphb/+FI9PM+rm1QYeRwIxU4epI2pdaC19rJnp07vNy
	6/4m1ZnbxuRjehXyBK2ZlojdEPI/C5b8jsF2XhqgeijgVhtFwqlbA6/oZ3n6pDJNlOG8W0ARpOy
	Kazm4oqpDxPbIvLwE+A6/SyQmtK+wKY2lYGGo+yFf/FSl5eDDOsSQbB/FjgnUxKGdDjUCm8NXff
	NG2tWhbNQ==
X-Received: by 2002:a17:90b:3d83:b0:35f:c1e1:a263 with SMTP id 98e67ed59e1d1-36140478347mr25261231a91.19.1776913761492;
        Wed, 22 Apr 2026 20:09:21 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-361410b998fsm18469310a91.13.2026.04.22.20.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 20:09:20 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: validate dx entry list counts on read
Date: Thu, 23 Apr 2026 11:09:11 +0800
Message-ID: <20260423030911.3532135-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupt indexed directory dx leaf can carry de_num_used larger than
de_count. When unlinkat() removes an indexed entry, that corrupt count
reaches ocfs2_dx_list_remove_entry() and drives an oversized memmove():

BUG: KASAN: use-after-free in ocfs2_dx_list_remove_entry fs/ocfs2/dir.c:1246 [inline]
BUG: KASAN: use-after-free in ocfs2_delete_entry_dx fs/ocfs2/dir.c:1363 [inline]
BUG: KASAN: use-after-free in ocfs2_delete_entry+0xb47/0x1070 fs/ocfs2/dir.c:1417
Read of size 401648 at addr ffff888020b8bd20 by task syz.0.1/347
Call Trace:
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x650 mm/kasan/report.c:482
 kasan_report+0xfb/0x140 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x11c/0x200 mm/kasan/generic.c:200
 __asan_memmove+0x23/0x80 mm/kasan/shadow.c:94
 ocfs2_dx_list_remove_entry fs/ocfs2/dir.c:1246 [inline]
 ocfs2_delete_entry_dx fs/ocfs2/dir.c:1363 [inline]
 ocfs2_delete_entry+0xb47/0x1070 fs/ocfs2/dir.c:1417
 ocfs2_unlink+0xb79/0x1900 fs/ocfs2/namei.c:991
 vfs_unlink+0x2c2/0x900 fs/namei.c:4673
 do_unlinkat+0x474/0x680 fs/namei.c:4737
 __do_sys_unlinkat fs/namei.c:4778 [inline]
 __se_sys_unlinkat fs/namei.c:4771 [inline]
 __x64_sys_unlinkat+0xae/0x130 fs/namei.c:4771
 ...

[CAUSE]
DX leaf and inline dx root blocks validate signatures and ECC, but they
do not validate the geometry of struct ocfs2_dx_entry_list. Corrupt
de_count/de_num_used values therefore survive block read and are later
used as traversal bounds and memmove/memset lengths in lookup, delete
and rebalance paths. In the unlink case, lookup can still find the
target entry before the bad bound matters, and the same corrupt
de_num_used then reaches ocfs2_dx_list_remove_entry().

[FIX]
Validate dx entry-list geometry in the metadata read callbacks. de_count
must match the block layout for the current superblock, and de_num_used
must not exceed de_count. Do this for both dx leaves and inline dx
roots so corrupted metadata is rejected before any caller walks or
rewrites de_entries[].

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
No Fixes tag is included because this is a missing metadata validation
check, not a regression attributable to a single introducing commit.

v2:
- Reframe the bug report around the unlinkat-triggered UAF
- Keep the code change unchanged because it fixes the same root cause
---
fs/ocfs2/dir.c | 40 ++++++++++++++++++++++++++++++++++++++--
1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8e6b03238327..a89634e20b32 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -578,6 +578,29 @@ static int ocfs2_read_dir_block_direct(struct inode *dir, u64 phys,
 	return ret;
 }
 
+static int ocfs2_validate_dx_entry_list(struct super_block *sb, u64 blkno,
+					struct ocfs2_dx_entry_list *entry_list,
+					unsigned int expected,
+					const char *owner)
+{
+	unsigned int count = le16_to_cpu(entry_list->de_count);
+	unsigned int num_used = le16_to_cpu(entry_list->de_num_used);
+
+	if (count != expected)
+		return ocfs2_error(sb,
+				   "%s # %llu has invalid de_count %u (expected %u)\n",
+				   owner, (unsigned long long)blkno, count,
+				   expected);
+
+	if (num_used > count)
+		return ocfs2_error(sb,
+				   "%s # %llu has invalid de_num_used %u (de_count %u)\n",
+				   owner, (unsigned long long)blkno, num_used,
+				   count);
+
+	return 0;
+}
+
 static int ocfs2_validate_dx_root(struct super_block *sb,
 				  struct buffer_head *bh)
 {
@@ -604,7 +625,14 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		goto bail;
 	}
 
-	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
+	if (dx_root->dr_flags & OCFS2_DX_FLAG_INLINE) {
+		ret = ocfs2_validate_dx_entry_list(sb, bh->b_blocknr,
+						   &dx_root->dr_entries,
+						   ocfs2_dx_entries_per_root(sb),
+						   "Dir Index Root");
+		if (ret)
+			goto bail;
+	} else {
 		struct ocfs2_extent_list *el = &dx_root->dr_list;
 
 		if (le16_to_cpu(el->l_count) != ocfs2_extent_recs_per_dx_root(sb)) {
@@ -660,13 +688,21 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 		mlog(ML_ERROR,
 		     "Checksum failed for dir index leaf block %llu\n",
 		     (unsigned long long)bh->b_blocknr);
-		return ret;
+		goto bail;
 	}
 
 	if (!OCFS2_IS_VALID_DX_LEAF(dx_leaf)) {
 		ret = ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
 				  7, dx_leaf->dl_signature);
+		goto bail;
 	}
 
+	ret = ocfs2_validate_dx_entry_list(sb, bh->b_blocknr,
+					   &dx_leaf->dl_list,
+					   ocfs2_dx_entries_per_leaf(sb),
+					   "Dir Index Leaf");
+
+bail:
+
 	return ret;
 }
-- 
2.43.0

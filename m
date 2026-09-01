Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0DD3B4407
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 12:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788267152; cv=none; b=YCWVJRvWNKrVVqzaI6TPE/l04OgOEVE4IxR5yT48Wn7Vam2YyUOLw1gMhfVUNTb5tg1SPjgGAogeb4qP+xRjDIwuK5cxqs9IF8+eZMF8/Ld8OjwMVoP4L4xQjRWFp9VzcISEnbnlGR7o+jxpBW7oS+rbRdXtP+TAn1uus/tSI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788267152; c=relaxed/simple;
	bh=3fdhbvtZHapHmAJHfQZfQ/YhwSthMb3hqixQt20jWMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iwj3U/Arwyfi0U/hKnNCLNph+7DoSLO535otXYBHtgV4bLoZEY8yKGCdEuZGghsL7p98ZtHBwQLd6B9YK44UeDT1H/j3Yvnfxur3dGSY3nIUdyzJd2d+ypcgno0PB629AGC3xqQDT1yfmfHbHIo0GIzx17XSMCM++B54A/kN70E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mqyltGDW; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mqyltGDW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788267145; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7vka9VM/L3gSN7zivj6LmGqDaWWWAAI2Tki83h4L2AE=;
	b=mqyltGDWYNkrKKJ61aCjXkJ24yHjbTP1Q3Ua78CZFHLoAOKR2/BhdFoCegLIoSUvuU4US1q9GPJVugP/gYsuxUiJOi4DNbpASNWtr1Be1sqEVS3q0Ttq+ZDJ8umU2dqQ9JYqLTO07A+8gVt/VFK5v21mFtsCOaApp7iZcZCraS4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA8Sdj1_1788267144;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA8Sdj1_1788267144 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 20:52:24 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] ocfs2: validate suballoc slot and bit of xattr and dir index blocks
Date: Tue,  1 Sep 2026 20:52:20 +0800
Message-Id: <20260901125221.1634686-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260901125221.1634686-1-joseph.qi@linux.alibaba.com>
References: <20260901125221.1634686-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_xattr_block() and ocfs2_validate_dx_root() do not
validate xb_suballoc_slot, xb_suballoc_bit, dr_suballoc_slot and
dr_suballoc_bit at all.  Since xattr blocks and dir index root blocks
are allocated from a per-slot suballocator at runtime, their suballoc
slots must be within range and their suballoc bits must fit in a block
group bitmap.

Otherwise a corrupted image can carry an out-of-range slot.  When the
xattr block or dir index is removed, ocfs2_xattr_block_remove() or
ocfs2_dx_dir_remove_index() passes the unvalidated slot to
ocfs2_get_system_file_inode() and get_local_system_inode() will either
hit BUG_ON(slot == OCFS2_INVALID_SLOT) or compute an out-of-bounds
index into the local_system_inodes array.  Similarly an oversized
suballoc bit will error out the filesystem in
_ocfs2_free_suballoc_bits().

Furthermore ocfs2_validate_dx_root() does not verify dr_blkno against
the physical block number like the extent and xattr block validators
do, so a misplaced dir index root block can pass validation.

Reject misplaced dir index root blocks, out-of-range suballoc slots
and oversized suballoc bits during validation.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c   | 35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.c | 25 +++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0075e1624310..6bb6aa133f01 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -605,6 +605,41 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le64_to_cpu(dx_root->dr_blkno) != bh->b_blocknr) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has an invalid dr_blkno of %llu\n",
+				  (unsigned long long)bh->b_blocknr,
+				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno));
+		goto bail;
+	}
+
+	/*
+	 * Dir index root blocks are allocated from a per-slot suballocator,
+	 * so the slot must be in range.  Otherwise removing the index passes
+	 * it to get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(dx_root->dr_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has invalid dr_suballoc_slot %u\n",
+				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+				  le16_to_cpu(dx_root->dr_suballoc_slot));
+		goto bail;
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise removing the index will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
+	 */
+	if (le16_to_cpu(dx_root->dr_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has invalid dr_suballoc_bit %u\n",
+				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+				  le16_to_cpu(dx_root->dr_suballoc_bit));
+		goto bail;
+	}
+
 	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
 		struct ocfs2_extent_list *el = &dx_root->dr_list;
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 143d6f75f9c9..34f102db2a0e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -532,6 +532,31 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
+	/*
+	 * Xattr blocks are allocated from a per-slot suballocator, so the
+	 * slot must be in range.  Otherwise freeing the block passes it to
+	 * get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(xb->xb_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		return ocfs2_error(sb,
+				   "Extended attribute block #%llu has an invalid xb_suballoc_slot of %u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(xb->xb_suballoc_slot));
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise freeing the block will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
+	 */
+	if (le16_to_cpu(xb->xb_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		return ocfs2_error(sb,
+				   "Extended attribute block #%llu has an invalid xb_suballoc_bit of %u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(xb->xb_suballoc_bit));
+	}
+
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		size_t region_offset =
 			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
-- 
2.39.3


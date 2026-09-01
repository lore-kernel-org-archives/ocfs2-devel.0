Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10972931DC
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 06:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788244396; cv=none; b=RIEAJl1HzBmB/YlfPQ3r6Q87UJ3gjmbM4zBOPCw/hgd2B+LzxLpsXGvSXl34GEMdd/PwdwPV/dX79ZQ4ILZ4/HOyEPCNNYOcRe+cm7Jm1Fz1xApGnDxDZO5jyKER2uowzcrgSC8lY2nl9jP0t92QshOhwu7Z7WTL2hqlmDGkBVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788244396; c=relaxed/simple;
	bh=QlFEeV6RHIe0/cFeTsdKxeR1dRa4QtplurHQwxtqkg4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pmeEmwHi812taPdo/cdeK94T4ZEWZykhtWDgiIF1bnn4Yzm+XMoCVqlhLgaZyanyFsZjxDar0UzfL32t5Ukibe+1i+jWpQLHpA6Noi9TIqas/oK572Y7hqWGKtC49AoSl05EdKZjoaPrChBDrEyLJA2HW6PpPpaa1uq+pmkHLTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lSpPNH3O; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lSpPNH3O"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788244385; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=6FHgHx7/gtlO3ZBPegU8P+k/3JGXORJVFTUjJl3ljDs=;
	b=lSpPNH3OOD4eqOvUY+R/jgt3RTD/EBXwtCjy5Mms0Oda2EKWhpdrsZ+EOyQqy+NjyOXO9TOFNS1qCVaqs83/8vJRwfwRo8oAr2dPyTubzuOpcxIG4ol7iBhWccC7IAKJyZriPwcP3IpVCkQ97kxDoO92zqHK7F6q9NyMb311cyY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA4XObN_1788244384;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA4XObN_1788244384 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 14:33:05 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] ocfs2: validate suballoc slot and bit of xattr and dir index blocks
Date: Tue,  1 Sep 2026 14:33:00 +0800
Message-Id: <20260901063301.984933-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260901063301.984933-1-joseph.qi@linux.alibaba.com>
References: <20260901063301.984933-1-joseph.qi@linux.alibaba.com>
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
suballoc bit will trigger BUG_ON((count + start_bit) >
ocfs2_bits_per_group(cl)) in _ocfs2_free_suballoc_bits().

Reject out-of-range suballoc slots and oversized suballoc bits during
validation.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c   | 27 +++++++++++++++++++++++++++
 fs/ocfs2/xattr.c | 25 +++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0075e1624310..0c3c4a13d9a5 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -605,6 +605,33 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		goto bail;
 	}
 
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
+	 * _ocfs2_free_suballoc_bits() and trigger BUG_ON() there.
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
index 143d6f75f9c9..897eba83904b 100644
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
+	 * _ocfs2_free_suballoc_bits() and trigger BUG_ON() there.
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


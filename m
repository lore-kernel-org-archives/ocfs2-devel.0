Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F8E3BB670
	for <ocfs2-devel@lists.linux.dev>; Mon, 31 Aug 2026 06:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158051; cv=none; b=SlFtvCcsL+dUFGgUFQ5l8Ls7AMRH/RSVn6476Eq6hyEjeNiQ6fjEPq2Aoiu0i4EdDRHV/ezYZE5wRY+3sreWOfcIGUpx2XgerszYs0TXdS0bkGBOlqUAVdeBvVLgsjNJlM3pm0ykN+wBntnY5T9tQq0Cr8vgsMUSCNzLySBAnDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158051; c=relaxed/simple;
	bh=eGEpIjWJqdf8UYbb2QkQk0bxAPkQ7us4f4toxIOYLMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RRe6sSobmIjJ3TBQO9UOkVymvi93b8L0Y9G1uBgR2XZIl58TOqSYj6jvz3dUGR5lhDsWfXk8B0JWntI8dgrbzgxC8AzAQDsQyT/Qe7Va8kBhG0UWq9Cb8VzSRqoZru1OhfbnH4gJHEaMlKEjhtKXto2RXaK5enBGYt0LJphKKa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FpTlJB3h; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FpTlJB3h"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788158044; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=EIZTiLjzMsj8zvXrmlEKp70ozCBmN/0RJICpv67UVnE=;
	b=FpTlJB3hUBqD6bYwIwwDWXuQ0hx48NXuSeHfx60GrEq5qLp7K/oGGCXeyHqe/EeqGfRWUywuSrv69DfFNnQB6zH8axsVzeLySa4+MCr9MNT7kuj+U7cevtv6hVKJpxuLZsa8XW2syeMwSxaL3taxZQ9lVp4xF7glktN6pV0QOLM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X9tzGpc_1788157731;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9tzGpc_1788157731 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 14:28:52 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ocfs2: validate suballoc slot of xattr and dir index blocks
Date: Mon, 31 Aug 2026 14:28:47 +0800
Message-Id: <20260831062848.2743436-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
References: <20260831062848.2743436-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_xattr_block() and ocfs2_validate_dx_root() do not
validate xb_suballoc_slot and dr_suballoc_slot against the mounted
filesystem's slot range.  Since xattr blocks and dir index root blocks
are allocated from a per-slot suballocator at runtime, their suballoc
slots must be within range.

Otherwise a corrupted image can carry an out-of-range slot.  When the
xattr block or dir index is removed, ocfs2_xattr_block_remove() or
ocfs2_dx_dir_remove_index() passes the unvalidated slot to
ocfs2_get_system_file_inode() and get_local_system_inode() will either
hit BUG_ON(slot == OCFS2_INVALID_SLOT) or compute an out-of-bounds
index into the local_system_inodes array.

Reject out-of-range suballoc slots during validation.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c   | 14 ++++++++++++++
 fs/ocfs2/xattr.c | 13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 0075e1624310..eb9850610ba3 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -605,6 +605,20 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
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
 	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
 		struct ocfs2_extent_list *el = &dx_root->dr_list;
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0062cbeb1e8b..5acc8091d06f 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -517,6 +517,19 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
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
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		size_t region_offset =
 			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
-- 
2.39.3


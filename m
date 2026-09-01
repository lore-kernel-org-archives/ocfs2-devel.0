Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215B924501D
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788267150; cv=none; b=aqvE1Wg0mtren8xDVRGAdXbqq+6q7/Q0WPHPbmlqx+U0va3gkvI7lDXkZMzdV+XIvrsvqj+MBRJspuiv7fjGRzgWyqOkHHzF22i21cdJ/TtOXlhOSMJzafBwjud23W9/qiacoJhKI6HHlFFI5kml1QkOQo2RLtE+7rxnJ0utQWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788267150; c=relaxed/simple;
	bh=rb90407IamfvPzbb5Hx2p57gpHuGWgSAczEOtLj4bCI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oiQ4PjdbAyBfhbPD9+7UKqrWWRdpHVPSRxtm/VKr+EXdvSbWDw+LrEjFgZeUiIcCjV1LxeO9qdwCDN+9szgBUezCOirK1kGqVd85ABhd9IaOnhmYJ+H/vl3UBTj7GyiXg7MAE+SPkNJ8I2D9EWTTzEztpQm+AmEa3undfKXYs9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Yeoevb5C; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Yeoevb5C"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788267144; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=cPyHDElzFBExETDV5STE/OBF7qM20J0I8zifjlYmqoc=;
	b=Yeoevb5CFBD3Ac/VR/2Qof1jDqNYt1gSD51C4dJbIaSBHslMsr340w46TfETaFe5Hf0sSoQCHEVfjSTgUD8gEqogixHjxnTMiPDknAQffJsS9eBicxqEUb8c+A6vDZvNGlxBMmEq3bfmAxF1qNA7V/XssoQBEJe1cPiaaDosf4o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA8AofH_1788267143;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA8AofH_1788267143 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 20:52:24 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] ocfs2: validate suballoc bit during inode read
Date: Tue,  1 Sep 2026 20:52:19 +0800
Message-Id: <20260901125221.1634686-3-joseph.qi@linux.alibaba.com>
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

i_suballoc_bit of a dinode is currently not validated at all.  A
corrupted dinode can carry an abnormally large i_suballoc_bit, which
bypasses ocfs2_validate_inode_block().  When the inode is deleted,
ocfs2_remove_inode() calls ocfs2_free_dinode(), which passes the
unvalidated bit to _ocfs2_free_suballoc_bits() and triggers
BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)).

A suballocator block group bitmap is contained in a single block and
starts after the group descriptor header, so a valid suballoc bit must
be smaller than the number of bits fitting in the remaining space.
Reject oversized i_suballoc_bit values during dinode validation.  The
bound is derived from ocfs2_group_bitmap_size() so it is also tight
when discontig_bg caps the suballocator bitmap at
OCFS2_MAX_BG_BITMAP_SIZE.

Note the above check alone is not sufficient since the freeing path
compares the bit against ocfs2_bits_per_group(), which is derived from
cl_cpg/cl_bpc of the allocator dinode that is not validated against
the actual group capacity and can be artificially smaller on a
corrupted image.  Convert this BUG_ON in _ocfs2_free_suballoc_bits()
to ocfs2_error() as well.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c    | 16 ++++++++++++++++
 fs/ocfs2/ocfs2.h    | 12 ++++++++++++
 fs/ocfs2/suballoc.c | 18 +++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9228d6ef23c2..92f3450010fb 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1547,6 +1547,22 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	/*
+	 * A suballocator block group bitmap is contained in a single block
+	 * and starts after the group descriptor header, so a valid suballoc
+	 * bit can never exceed ocfs2_suballoc_bits_per_block().  Otherwise
+	 * deleting the inode will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() via ocfs2_free_dinode() and trigger
+	 * BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)), since any
+	 * group holds at most ocfs2_suballoc_bits_per_block() bits.
+	 */
+	if (le16_to_cpu(di->i_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc bit %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_bit));
+		goto bail;
+	}
+
 	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
 	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index b747cdec1787..e3bb3cc0b25a 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -593,6 +593,18 @@ static inline int ocfs2_supports_discontig_bg(struct ocfs2_super *osb)
 	return 0;
 }
 
+/*
+ * A suballocator block group bitmap starts right after the group
+ * descriptor header, so a suballoc bit can never exceed this number
+ * of bits.  Derive it from ocfs2_group_bitmap_size() which also caps
+ * it at OCFS2_MAX_BG_BITMAP_SIZE when discontig_bg is enabled.
+ */
+static inline u32 ocfs2_suballoc_bits_per_block(struct super_block *sb)
+{
+	return ocfs2_group_bitmap_size(sb, 1,
+				       OCFS2_SB(sb)->s_feature_incompat) * 8;
+}
+
 static inline unsigned int ocfs2_link_max(struct ocfs2_super *osb)
 {
 	if (ocfs2_supports_indexed_dirs(osb))
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 453b56be9624..ce22d0c3d287 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -3040,10 +3040,22 @@ static int _ocfs2_free_suballoc_bits(handle_t *handle,
 	/* The alloc_bh comes from ocfs2_free_dinode() or
 	 * ocfs2_free_clusters().  The callers have all locked the
 	 * allocator and gotten alloc_bh from the lock call.  This
-	 * validates the dinode buffer.  Any corruption that has happened
-	 * is a code bug. */
+	 * validates the dinode buffer. */
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
-	BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl));
+
+	/*
+	 * ocfs2_bits_per_group() is derived from cl_cpg and cl_bpc of the
+	 * allocator dinode, which are not validated against the volume
+	 * geometry.  A corrupted image can carry a suballoc bit beyond it,
+	 * so error out instead of crashing.
+	 */
+	if ((count + start_bit) > ocfs2_bits_per_group(cl)) {
+		return ocfs2_error(alloc_inode->i_sb,
+				   "Allocator #%llu: freeing bits %u+%u exceeds bits per group %u\n",
+				   (unsigned long long)le64_to_cpu(fe->i_blkno),
+				   count, start_bit,
+				   ocfs2_bits_per_group(cl));
+	}
 
 	trace_ocfs2_free_suballoc_bits(
 		(unsigned long long)OCFS2_I(alloc_inode)->ip_blkno,
-- 
2.39.3


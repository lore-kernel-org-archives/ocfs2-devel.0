Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295BA2E54D1
	for <ocfs2-devel@lists.linux.dev>; Tue,  1 Sep 2026 06:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788244395; cv=none; b=czlfFrJpXvtFJ8nllsmKsEJKqT+i3sYLjT3R11D84wH1itTRYbR0WHnUvRpWqAAPJ+3jmR1H5S+2ENWaj24kYwYqhauMChdiO71RNPtduHhmcNzmZls2aeKMdOCygX1+xTCd4MrkCU3pIRxUTJCAeKA+VsqFasx31/xc7IIG7DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788244395; c=relaxed/simple;
	bh=h8kkhzO2ImVgjkG1e2qZ/ZXPIitu6FWdseOO3TZP70c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hpeK930MX+Wo9mEfprHIgJ4q6djobiga/XS68/Fd0DThrnskqaqDcDcvNOAGVGg72LD8IuT5WbGcCvK4+1sgNaE1Rn1iV8KYCQLHpSiSQMliarHFyXAsXHZBUwaJVj5YKhwlV5s3rgX4Cz2pRt4iQS0zZyWO8rBP3+HTHDbj4h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=tt5qHlP3; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="tt5qHlP3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788244384; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=GyVRRq71oNkvnJvOiM8YXwHI5/MyS+0QmarDgfjWn34=;
	b=tt5qHlP3HX0oxO/nMq6Rz7nX8Hle8VBavvFeemTHh9sP2lSSQmq4l64aJ4Ip2yARRfuarkohdPYF7lBQmvBkeOID63GQ8lUATXyjiRx1lO6zV6Na2HmYOOhtnwwCXt4YTmoj5duAtWgCyM7Kbf6V34fiw+Aj39PQ0uAyrow7dKY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XA47zDB_1788244383;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XA47zDB_1788244383 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 01 Sep 2026 14:33:04 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] ocfs2: validate suballoc bit during inode read
Date: Tue,  1 Sep 2026 14:32:59 +0800
Message-Id: <20260901063301.984933-3-joseph.qi@linux.alibaba.com>
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

i_suballoc_bit of a dinode is currently not validated at all.  A
corrupted dinode can carry an abnormally large i_suballoc_bit, which
bypasses ocfs2_validate_inode_block().  When the inode is deleted,
ocfs2_remove_inode() calls ocfs2_free_dinode(), which passes the
unvalidated bit to _ocfs2_free_suballoc_bits() and triggers
BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)).

A suballocator block group bitmap is contained in a single block and
starts after the group descriptor header, so a valid suballoc bit must
be smaller than the number of bits fitting in the remaining space.
Reject oversized i_suballoc_bit values during dinode validation.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 16 ++++++++++++++++
 fs/ocfs2/ocfs2.h | 11 +++++++++++
 2 files changed, 27 insertions(+)

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
index b747cdec1787..b6ead97605b3 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -593,6 +593,17 @@ static inline int ocfs2_supports_discontig_bg(struct ocfs2_super *osb)
 	return 0;
 }
 
+/*
+ * A suballocator block group bitmap starts right after the group
+ * descriptor header and extends to the end of the group block, so a
+ * suballoc bit can never exceed this number of bits.
+ */
+static inline u32 ocfs2_suballoc_bits_per_block(struct super_block *sb)
+{
+	return (sb->s_blocksize - offsetof(struct ocfs2_group_desc,
+					   bg_bitmap)) * 8;
+}
+
 static inline unsigned int ocfs2_link_max(struct ocfs2_super *osb)
 {
 	if (ocfs2_supports_indexed_dirs(osb))
-- 
2.39.3


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963712;
	b=u0VR5dL8G7PUl+2CUKuZn/P941CRW6f7Gr4kqNPhLU5NkJmowux0oUTolog0qALV+mRk
	 oN5r2Be4Oi4BodBopBFGU9hcmvFXOufDDidfiPeeeWskgLJjSj92wUM+JELiMtveWls1v
	 MiK8jsyeu7NitBoSfNW4sUo+AUwDD3UIZfvMl1oVo3rhITXLWwr3+k7J6+L0I7WOYB9on
	 BJmshu/YKHXkw2w5ShrZOz40Nm0s4AM5dBX0Dv1u9ofI7r9dWer7/RRehUI7EpYSrIyxT
	 CxBJ3PVCkGILVTfjgxHyEoE0UY1+umF7yjPhqMby8RCw8z/5OSvsota9H4GJBKX+nfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963712;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p4vwbYYLQrtjR0iELFGwWmSzIE6lZ4pD21prPC9EqQg=;
	b=qqduDKbyYudXBQYL5WFlNuYzBzg7JERD4diU+HHmItq6OQaPBJ3YEcK0kUlvOjfjCQKm
	 o4U6I6nuivEXlRxlrZGmpvUIAWuriH1oJEAL55G7g6WYMf3b5g5nnmc7G7GnjA6pFNjBJ
	 lCni/Gog+dIC95620TdIdY7Z0fO3sp3c1Bkkz1jcsCdu5i0DwXozda8C0zgNNxeMzvFt6
	 tNp9sg7XZTOu2+vbuHXg5BHzes8Qzn8enMmioNqLaUs5VvMpHyBHq96gqauVK8K//qOuK
	 2trpXgbtK5nrk4Yx3AxhQZ9ThrtHgQFcgt8JztNc/r+HZTBUEHGLb4WTPHz3N4jz7eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=txLLXU6I;
	arc=none smtp.remote-ip=115.124.30.97
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4826606D812
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4826606D812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=txLLXU6I
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963702; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=p4vwbYYLQrtjR0iELFGwWmSzIE6lZ4pD21prPC9EqQg=;
	b=txLLXU6IinJiMyAMv5rc2BIKZLjKR1I66q0XabQFbDRTQpB2KbCvi1+aCav+mxIsW9vywuIo+AeZ7T9wjoe7OdzAH+h9qEN55Zj8UsAt5KcCrcEYnWSfoPO5UrBG+inCOIbky8J2hPr9zK+gSsMTbMyT2rtN5Sca+Ct5DUCupPs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBTHoH_1793963700;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBTHoH_1793963700 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:00 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 02/31] ocfs2: abstract the zero nlink or mode dinode check
Date: Fri,  6 Nov 2026 19:14:29 +0800
Message-Id: <20261106111458.1467464-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
References: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_inode_block() open-codes the test for a dinode that has
no links or no mode.  Fold the condition into a predicate so it reads
like the neighbouring ocfs2_dinode_has_*() helpers, and so the filecheck
variant can share it.

Reuse ocfs2_read_links_count() rather than testing i_links_count and
i_links_count_hi separately.  OCFS2_LINKS_HI_SHIFT is 16 and both fields
are 16 bits wide, so the combined count is zero exactly when both raw
fields are zero.

The OCFS2_ORPHANED_FL carve-out moves into the predicate along with the
rest of the condition, in the same early-return style as
ocfs2_dinode_has_size_without_clusters().

The return code and the log message stay at the call site: filecheck
reports the same conditions with a different code and must not call
ocfs2_error().

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 371857673712..209066321932 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -67,6 +67,21 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 						      struct buffer_head *bh);
 
+static bool ocfs2_dinode_has_zero_nlink_or_mode(struct ocfs2_dinode *di)
+{
+	/*
+	 * An open-unlinked inode legitimately has a zero link count on disk:
+	 * ocfs2_unlink() drops the last link and ocfs2_orphan_add() sets
+	 * OCFS2_ORPHANED_FL, while OCFS2_VALID_FL is only cleared later by
+	 * ocfs2_remove_inode().  DIO orphans keep their link count, so they
+	 * need no exemption here.
+	 */
+	if (le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL)
+		return false;
+
+	return !ocfs2_read_links_count(di) || !di->i_mode;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1482,15 +1497,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	/*
-	 * An open-unlinked inode legitimately has a zero link count on disk:
-	 * ocfs2_unlink() drops the last link and ocfs2_orphan_add() sets
-	 * OCFS2_ORPHANED_FL, while OCFS2_VALID_FL is only cleared later by
-	 * ocfs2_remove_inode().  DIO orphans keep their link count, so they
-	 * need no exemption here.
-	 */
-	if (!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
-	    ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode)) {
+	if (ocfs2_dinode_has_zero_nlink_or_mode(di)) {
 		mlog(ML_ERROR, "Invalid dinode #%llu: "
 			"Corrupt state (nlink = %u or mode = %u) detected!\n",
 		        (unsigned long long)bh->b_blocknr,
-- 
2.39.3


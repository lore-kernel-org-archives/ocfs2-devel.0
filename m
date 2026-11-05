Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872176;
	b=AvTOD+tfyN3AqLlXvyrzGhBXgh4KMl8A0QqbQhkCLQck5B8GkufvBsI+Al4u0FTTGUq3
	 neMsbfvFSRzqSSyheTF8lEmy8SXQVPY0ZhERtYAmRNGY/wNDv00V/zqsZNkVoqGUOy5CQ
	 +C3Rn1W7tuQBsVKRrLNA5j6YY95JMuzaELRdj697KnAPpsoIYnrrlN7nDMt6QDvOy/aLP
	 F6WaHL2IbUzH/cBj38z9ZIFW9rzqaxWZzQ8GQVoYnnj7IEvp/jEp4zC2mv6M3PlF2mHXK
	 T6l/IeJPOouEww+rlg3CHbcJyOieL+oxbpddAbJhbli19vY4tgBL4UUr8FDOK0toDEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872176;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kCvgsly8FCsXc0g7/2zskbLWDNvOjLoguzel/K4aeGE=;
	b=yzd9nRIelabtl6oLAxPk6xvhPMKQB4M0ciysi+29VFlvHhn85q4isFlMU6QjphW/LiG0
	 3eHjOtbgRZlFoHIA4Ux6RxtZmRPnCTlo79Ja2eO0xrEDyZw5QUYNH1PNHeHEn35SPWB/e
	 TC0SVpGmR3ByJoG6w6pXWuwn6MjXTjKUS0y+yIE0W/f6uKbPpi740QA2N2Xko4ra5zzRH
	 7b/SlIvbuAnHxGNkRiSgupm///yuLmuhiUXj6P+eaJVxMdKe1C1Ydm8DUHTeTYeT3DGPJ
	 F8O6fXkGkK0V6grjE7lUfvcmjv2TzUwc1x6ENAsJfPqOogcY2AhUON5TZYHbJ5uIhEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RoDFaRBy;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B97606D831
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22B97606D831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RoDFaRBy
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872174; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=kCvgsly8FCsXc0g7/2zskbLWDNvOjLoguzel/K4aeGE=;
	b=RoDFaRBy6BxYoppdNolUhvNXCvRNIcdGoes2UPos2MCSzz1Q4o2aWtE08LOqNaTBRWEO+rKdIkmz5u43nlhCQSgxPT9s7vJ66nrUS2Amhy3RRrOmY6E3SmhG4yvG0Bpiu/pMuQFITVpiaGqBp65W1DFmlPxvgSNVDEmfnyBIH2U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8QR0g_1793872172;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8QR0g_1793872172 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:33 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 06/30] ocfs2: abstract the dinode suballoc bit check
Date: Thu,  5 Nov 2026 17:49:02 +0800
Message-Id: <20261105094926.3203416-7-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
References: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
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

Fold the i_suballoc_bit against ocfs2_suballoc_bits_per_block() test into
a predicate.  The rationale comment stays at the call site, next to the
error it explains.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 412c8149d306..89970378daf4 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -101,6 +101,12 @@ static bool ocfs2_dinode_has_out_of_range_suballoc_slot(struct super_block *sb,
 		(u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1;
 }
 
+static bool ocfs2_dinode_has_bad_suballoc_bit(struct super_block *sb,
+					      struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb);
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1590,7 +1596,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	 * BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)), since any
 	 * group holds at most ocfs2_suballoc_bits_per_block() bits.
 	 */
-	if (le16_to_cpu(di->i_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+	if (ocfs2_dinode_has_bad_suballoc_bit(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc bit %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_suballoc_bit));
-- 
2.39.3


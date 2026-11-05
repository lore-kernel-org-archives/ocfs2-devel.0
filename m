Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872179;
	b=DMbDrZb9pYy4VMsqUd08GPhoT85szW5WLXu6xPEZ062f8mNry7wzY7JlcXc+wzdC56nh
	 JbvgsNjgdc9iX8YxOpIrAi6Ys6SyXt3OQ/VHtIHMSzn3xNR6c0fD+vsTvuOGZp1ZvHL35
	 3JaWpzr/T8RncCuGbBhMCBnaVhCtmC/sM/qJTfkEEPTeQEfQNVCCYYKOpXy/opuZMgpvh
	 kTLhAg5HVKqzolve2SBarP7JWNKbszhMW1oQBj+xTrYKXCJlLZXBDZH4qodFGFvedR4dc
	 eWCZF98iDrwbsdVKndY+0hNvsuVuK45303tVwqyqW0YE4WPl3hqguwavKxWbP9QZd/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872179;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ufdNPwLudyf2sLsCMjFPaB3Adk3xxkzUT/kSYdmHeBU=;
	b=XgwBW1D13QYbEkALQFWiYLEM+cvKx+LxdaSyGRSnvvgCYFWiB9ulglyCvRF4lr+QST0f
	 gNx6syB3+QLfzRfVYvy9w0XqCMRb8H9kxtTZDfMH4QR3YmyEG2OVBHVuV+QJtdYtAfdPD
	 0jOluiyjZ8Lr4lzwCe32fDFw4w1uX7Tc0l5MdT1YUI/ONfQ9geZNP2aFP9uD/I4iGW05U
	 /OhxvWuSc1UDwkECVwwqGUytVfoq+byWQTbmyZlkDwLJcLv26M19lFjhKSamcvshPgoW5
	 2ZCyJIjS6vEWH7Ua0LFJR8rwGNVLUDQ+kVFbpNjboHU484t6dxOEk+w1RdoMG9agh5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CG0sQzJ5;
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638F0606EE8E
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 638F0606EE8E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CG0sQzJ5
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872176; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ufdNPwLudyf2sLsCMjFPaB3Adk3xxkzUT/kSYdmHeBU=;
	b=CG0sQzJ5IlrfrhFKl1HWfKUNN8lsoePHBdV1tKs/1ftG9Qq+0A6/jHureG9xZfW0ZXM59GXkcdQn2UA+ez8RkBa7/4WZs+actQcw2Y1VTKbdfcrSpCklwHkivPcqJ9RBKIR0wqxpK3NI0LayFNLcJUXlsAT+Jg4B0Kc9TtxYtyM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K70t_1793872174;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K70t_1793872174 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:35 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 08/30] ocfs2: abstract the dinode DIO orphaned slot check
Date: Thu,  5 Nov 2026 17:49:04 +0800
Message-Id: <20261105094926.3203416-9-joseph.qi@linux.alibaba.com>
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

Fold the OCFS2_DIO_ORPHANED_FL guarded i_dio_orphaned_slot range test
into a predicate, mirroring the orphaned slot one.  The flag test stays
inside it for the same reason: the slot field is only meaningful while
the inode is DIO orphaned.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 33572a91324d..8c23170bb595 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -114,6 +114,13 @@ static bool ocfs2_dinode_has_bad_orphaned_slot(struct super_block *sb,
 		le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
 }
 
+static bool ocfs2_dinode_has_bad_dio_orphaned_slot(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	return (le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+		le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1617,8 +1624,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
-	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+	if (ocfs2_dinode_has_bad_dio_orphaned_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_dio_orphaned_slot));
-- 
2.39.3


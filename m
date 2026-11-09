Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226916;
	b=LkZR8e3UArkTnHJPEoA2tBM7XpVC7PnX5CQfovwDtgEIvtB9NbrCAr+zPknj+CvXX2MQ
	 AnVQyKHRjqrN6r+0xzV9KpOdj8sX1FMBe2hRSBczQvTISytZ+RyHbjKxYG70FpFTBLzr8
	 ESY24rfriDITxONE9I09visUswY67SX89gc4REdJithINot3RZMA+c8cq8tz3WUSaieSl
	 0f7MzzAzYGBy4tV6Ts0td6hhlYp2d6ugMWc2HYcIR4fqHr7PloKP3itRG9LAPdr2Gi0fR
	 NSvITgZUYGC0rqww6qSXOlyyXSyqig7DQEX3FPxeMoRKHUqgxGQEkMdM82/iEhzVuaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226916;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7eutQ+YAugIK3ZO4F19YZ1QUaoTdV7knKC5HCz1LcuI=;
	b=RaixE/bIsw/DwvPmdBs4lbS1AKproscx+vCizmPqfZ2YaYwUA+NwzLXpiINopo0eXY+C
	 a1CYWnWuaxRjdySo4IDVeM2Kaeg4Pi+YDkvFuusLzZt3V/sXBA4pput95Z8dN8i8rrYmB
	 A6Mrkztz77fgjSEdKoWZ7xyMy77JEbLFlEnJpY1GIsadBAhKMg8NBSJVpvwr3TqiIOpEU
	 7gpCw31qJpr7LxJnALhb81vgiJq6pXbFT2AOHmyWhoMb9/1pCt0KAVP/s5KRCDNET1V5J
	 9iBRKnFiC2P9mi/76cYMUuu/7/EuuiJ0AsfM1pIjDfdCY+ose0vH5xd0T05utN/mx7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=thqMl+Ed;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B67606A325
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:21:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15B67606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=thqMl+Ed
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226914; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7eutQ+YAugIK3ZO4F19YZ1QUaoTdV7knKC5HCz1LcuI=;
	b=thqMl+Edg1gfR0N1SKQIG5E/IFxe2tCn/2O7qRvB8+9t+GvuSbgiCuJCJrDNWtue+DhnuWj/rs9BlTxL2L2lXkDKKDT77QXT2PMYwgnFmoK6lYqMUSHzhhr1VBrjnw7eV5oSG5wYwXLvWLkRa/xwwodzXchpjul5yHe1rawBXvk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8aqe_1794226912;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8aqe_1794226912 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:21:53 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 06/31] ocfs2: abstract the dinode suballoc slot checks
Date: Mon,  9 Nov 2026 20:20:56 +0800
Message-Id: <20261109122121.21473-7-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
References: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
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

The suballoc slot validation is a nested if/else-if whose two arms carry
different error messages.  Split it into two predicates so each message
stays at its own call site without having to re-test the slot value to
work out which arm fired.

The arms were already mutually exclusive, so two sequential tests are
equivalent to the if/else-if.

Keep the OCFS2_INVALID_SLOT exclusion in the range predicate.
OCFS2_INVALID_SLOT is 65535, which is greater than max_slots - 1, so
without it every system inode mkfs.ocfs2 creates from the global
allocator would be rejected.

ocfs2_get_suballoc_slot_bit() in suballoc.c open-codes an identical range
test, and is deliberately not converted.  The dinode validator pairs the
range predicate with ocfs2_dinode_has_invalid_suballoc_slot(), which also
rejects OCFS2_INVALID_SLOT on a non-system inode, so that pair is stricter
than what ocfs2_get_suballoc_slot_bit() accepts.  The range predicate on
its own is not stricter, it is the same test.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 6b78b3f3c5fa..0929deb3e4b4 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -98,6 +98,19 @@ static bool ocfs2_dinode_has_wrong_fs_generation(struct super_block *sb,
 	return le32_to_cpu(di->i_fs_generation) != OCFS2_SB(sb)->fs_generation;
 }
 
+static bool ocfs2_dinode_has_invalid_suballoc_slot(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT &&
+		!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL);
+}
+
+static bool ocfs2_dinode_has_out_of_range_suballoc_slot(struct super_block *sb,
+							struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
+		(u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1564,15 +1577,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	 * deleting it would pass the slot to get_local_system_inode() via
 	 * ocfs2_remove_inode() and trigger BUG_ON(slot == OCFS2_INVALID_SLOT).
 	 */
-	if (le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT) {
-		if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)) {
-			rc = ocfs2_error(sb,
-					 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
-					 (unsigned long long)bh->b_blocknr,
-					 le16_to_cpu(di->i_suballoc_slot));
-			goto bail;
-		}
-	} else if ((u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+	if (ocfs2_dinode_has_invalid_suballoc_slot(di)) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_slot));
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_out_of_range_suballoc_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_suballoc_slot));
-- 
2.39.3


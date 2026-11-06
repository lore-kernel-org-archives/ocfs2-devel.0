Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963708;
	b=G/gmeO/9hSuNFURnMZdat1NHiUT0I3ow9QKnxhq5D5xOgX2E+ZPa0f58ERTq/idzsKMk
	 xlUeY+umdWrIqqzk4Fo+OtdYbWvneM570eRe9kevGCVZYgLKiJmAkN8yfjdy5oGOxCulp
	 mSoAJWw8645LMtE2ov3aY7p+yM4DoCm59Ka56OglVSrSnVfl4twahrJPjFdE0QMOEvn58
	 DtgifpWx1fLbkydwEjbUYk3rOlss7R6xxxRQWp2gzWSTsKKecWIv+ZfUwdG3+M4JuKf6N
	 f4YG7jeKU/l9gAm7iotg8hdg/Cm5t0+m+p9nsbpN84j/8QMIxa2Kxc5o1fg2xuMSX0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963708;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7eutQ+YAugIK3ZO4F19YZ1QUaoTdV7knKC5HCz1LcuI=;
	b=yfFPoOlbyqqCSD4g364XEFWBWgQLupVaPJOqnIebV0VLR+ELgi2aIlGfz1ehhy/hyB3I
	 vK/p+ORQN8i/xvrC4h+pUR3MrY3hj8QxDNS73goCal3PhVcdrP/M1EdFZuiGcNa1/uQQO
	 2OS0zmoyoFcgsIOa53sHEKrKcxNyPz/w9RbuTanpk+5Tyr/MytGnbvCfJo7nRnzcb8sxq
	 tIzE+lhjv+cP8H5v9gm55gb2V5IRMmyAM57rEDLrqz/H+xUpsLgxKPLFpVZ1ZIsMO1xKT
	 if9RdPhVtVX9VjgaJFscSyjw9DBsEOIxsexlYLKFU4l5/kYmnxGJ0NGwsGaZlf5f5Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="xB7Fn/Da";
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0849606A335
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0849606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xB7Fn/Da
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963705; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7eutQ+YAugIK3ZO4F19YZ1QUaoTdV7knKC5HCz1LcuI=;
	b=xB7Fn/Da4Ll0ObXwBQDg7M1w9pXDjKKHWY7dlb+KyiRdSXh6gXZLGqupQIiZh4bHOiRxtoWx5BtV+Im4LyvR8ONK3fPLRwRzod1WmjSb3tMdoUdyP0J24Tlj5CqVv/DvaI3/CvnPV/Q5X0TulsMSGu1BUyu17QIuepUuXyN/RHQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBTHph_1793963704;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBTHph_1793963704 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:04 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 06/31] ocfs2: abstract the dinode suballoc slot checks
Date: Fri,  6 Nov 2026 19:14:33 +0800
Message-Id: <20261106111458.1467464-7-joseph.qi@linux.alibaba.com>
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


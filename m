Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872176;
	b=dTNGOcOgYrtt/avymudEAVZQLdzwvtlnjzuL6Bug728Ln2IF7x6ocVliC2pjdRIAhpI2
	 nXo1PJlq2dss5kRUIt5uWXCKElf7eLvu0FAziADpBoGp9BM92oBJ7hamGFkKiTA/hW8el
	 hScFRAxLs8wYUatOImC94zAlFvAq/89OfM+HUEkDf9hQdNonKo7Bur71+3R6YtEzBK9yK
	 RO0p2ZlKIdFa3vlt1Fg1m+8jrNGcKwx3aM8luDNlbOye4I2Hzxy7XEMFJUzA1mH/kJofW
	 RVHuB9HHJ23KKzmdSdkaET8UUasGWEBseSpuaXeERw3kum9zs2XDqMdTQJ8LifZN4/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872176;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EdvOzSA0ips8bwQUfNOy8LK7YnXn3SMJmmzqT2NcLQI=;
	b=1UzE5aVs9Cv5NVfg2fzpXQHhZG6KanVbj5R9FTEIwEtRyKTZWipDMsPMpO9LYGxg3FBG
	 AHqBLROOIGMxGa6xOFf+2t+Sb9rh1NrPbe6u5bQVDPO2Zm0YcJFxMG72o6G9hT+VG4Hu5
	 GK6MEOV/+HhbLl6d+M5Rz0mkB8uzlppe80nlv/IHiNZedeXRK8jfyuoQVd0CsOoR8cvDY
	 E/krZ8MqU+Ke18BWrJLyy53KXr3VrzoSZZU5Sgp0kf4pnUfD7whEbVr9QizC+H0mjhZ7E
	 Nb+WXtKZClAVcjXnblsVTQCZ5B1i/KpQVhfNtvyF4xUhleLcuXAD7GA1QsG4w/wY0Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SbB8Lwmn;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55952606D81F
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55952606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SbB8Lwmn
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872173; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=EdvOzSA0ips8bwQUfNOy8LK7YnXn3SMJmmzqT2NcLQI=;
	b=SbB8LwmnqhBS0oFEwHs3NlI+vhAD0OV1/j926zHkgXLMrs5DiOqbfg4CA3yMAlJb0W113vfwlXOJ0ieko5GH3DSOyB07Kl24AWsMmZUzmwo5hH1MnyjGuglke3DN41HrlGjiSnBzBRUolA95QuH3iQP704N9ZCAqqTM/aOTMCco=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K7.c_1793872171;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K7.c_1793872171 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:32 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 05/30] ocfs2: abstract the dinode suballoc slot checks
Date: Thu,  5 Nov 2026 17:49:01 +0800
Message-Id: <20261105094926.3203416-6-joseph.qi@linux.alibaba.com>
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

The suballoc slot validation is a nested if/else-if whose two arms carry
different error messages.  Split it into two predicates so each message
stays at its own call site without having to re-test the slot value to
work out which arm fired.

The arms were already mutually exclusive, so two sequential tests are
equivalent to the if/else-if.

Keep the OCFS2_INVALID_SLOT exclusion in the range predicate.
OCFS2_INVALID_SLOT is 65535, which is greater than max_slots - 1, so
without it every system inode mkfs.ocfs2 creates from the global
allocator would be rejected.  ocfs2_validate_group_descriptor() in
suballoc.c open-codes a similar range test that deliberately permits
OCFS2_INVALID_SLOT for all inodes; it is left alone because this
predicate is stricter.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8eefda8fe4a6..412c8149d306 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -88,6 +88,19 @@ static bool ocfs2_dinode_has_wrong_fs_generation(struct super_block *sb,
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
@@ -1553,15 +1566,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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


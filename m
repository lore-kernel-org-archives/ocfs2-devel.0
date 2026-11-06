Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963710;
	b=lHhtcWBdm6b5CQXAkYlWtuR3n6lUEqJwej/5c83BtW3+DneJWK2hSlQF/z/70qHN+znf
	 jtUJZAF2jeb9Q/bOfFA0kZoSodh9obAj6XLMQlX4s+uHIIj29zIOE2QsuGLEG/f7UAol6
	 j2h0t1leFPrwJ+RVV5uSWeRot5m26082dM0Kw46YbHqUIEaU9kHCLwdk9eN7mcY3c+vwx
	 jJIBu0NUS/KiczSy2ZPmx2rwSfpN3Gng6GHP72AExankzeqbuXbLaP1vV0u5pbgdG4WRI
	 +4t/GFUngt2lO1cbjY/c1fiYcrUPA4mvOr9VsYbNH4pJnpioqBhlbEJ2xeh+6JufYGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963710;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ly/DHPYaYtg4H5d7I4tI+XKSj5VHoc0rWfr4sQj575E=;
	b=w01hT8wetQpaW3QVWW9DvpARDTh6xH0VZ/Z8XEUMY5FMMalPxnocfyWemgCm1tGW318a
	 iDujUbC1D/Cbong/w3G8QZBDg/fzYcC/Z92mwU1RtXSs2UO1jwGzBPFiHaGDBD3Rmrk0y
	 JPqM9er+0o1cLZc5Kx3jcXzwxxhV4lOpE58IE8ZS1SYFHiKxcZCwPJ9zFfxPDhJr8LbsP
	 sQU4ELhwTULFmtH7sbrvoDU/qfjpxfXuipvCIpKDOdHahLxZFwwxKN1HdCNNkCthmDtgF
	 Qe1OdNdxRofItnOfNLRJhRIvtqRXjfF3BLR4KGdT1PAaMDGdm1MtBMJuHXIxe8LhtkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eEg2XrXJ;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB71E606A33D
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB71E606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=eEg2XrXJ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963701; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ly/DHPYaYtg4H5d7I4tI+XKSj5VHoc0rWfr4sQj575E=;
	b=eEg2XrXJ4zd65dFv0/caibkxYXd83hvt/OHO0ngPd8QAH1LoSOFAXqblzlRKo1oUVyflvowU7X8nfua+IOJgAoa3vtTFqfK4n8IGA4BfK1cBoWfCmtprFjY4kQn+cktR1/jcnt0p3tMsHOG/twmxucWW3us+BK4yAl5E7E8PHYA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBd-12_1793963699;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBd-12_1793963699 cluster:ay36)
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
Subject: [PATCH v2 01/31] ocfs2: exempt orphaned dinodes from the zero nlink check
Date: Fri,  6 Nov 2026 19:14:28 +0800
Message-Id: <20261106111458.1467464-2-joseph.qi@linux.alibaba.com>
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

An open-unlinked inode legitimately has a zero link count on disk.
ocfs2_unlink() drops the last link and writes it out with
ocfs2_set_links_count(), ocfs2_orphan_add() then sets OCFS2_ORPHANED_FL,
and OCFS2_VALID_FL is only cleared much later by ocfs2_remove_inode().
The zero nlink check added by the commit below rejects such an inode as
-EFSCORRUPTED even though it is perfectly valid.

That commit describes its own change as a check for "(i_mode == 0,
i_nlink == 0, non-orphan)", but the code it added has no orphan exemption
and ORs the two conditions rather than ANDing them, so a zero link count
alone is enough to fail even when i_mode is valid.  Add the exemption the
changelog describes.

Orphan recovery hits this on every pass.  OCFS2_FI_FLAG_ORPHAN_RECOVERY
clears can_lock in ocfs2_read_locked_inode(), so the block is read with
ocfs2_read_blocks_sync() and then validated by the explicit
ocfs2_validate_inode_block() call in that branch.  The read helper having
no validate callback of its own does not mean the path skips validation.
ocfs2_orphan_filldir() then ignores the resulting ocfs2_iget() failure
("Skip bad inodes so that recovery can continue"), so the orphan is never
wiped: its space is leaked permanently and the "Corrupt state" message is
logged again on every mount.

The same applies to an orphaned dinode read through
ocfs2_read_inode_block(), for example from ocfs2_delete_inode() once the
buffer has been evicted.

Note that a zero i_mode is already rejected by the later
ocfs2_valid_inode_mode() check, since fs_umode_to_ftype(0) is FT_UNKNOWN,
so the nlink arm was not what protected against the zombie inode the
original commit was fixing.

DIO orphans need no exemption: ocfs2_add_inode_to_orphan() is the only
caller that passes dio=true to ocfs2_orphan_add(), and it never drops a
link, so those inodes keep a positive link count.

Fixes: 7efb45f9685f ("ocfs2: invalidate inode if i_mode is zero after block read")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7005e59519b2..371857673712 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1482,7 +1482,15 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
+	/*
+	 * An open-unlinked inode legitimately has a zero link count on disk:
+	 * ocfs2_unlink() drops the last link and ocfs2_orphan_add() sets
+	 * OCFS2_ORPHANED_FL, while OCFS2_VALID_FL is only cleared later by
+	 * ocfs2_remove_inode().  DIO orphans keep their link count, so they
+	 * need no exemption here.
+	 */
+	if (!(le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode)) {
 		mlog(ML_ERROR, "Invalid dinode #%llu: "
 			"Corrupt state (nlink = %u or mode = %u) detected!\n",
 		        (unsigned long long)bh->b_blocknr,
-- 
2.39.3


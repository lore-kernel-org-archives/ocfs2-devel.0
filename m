Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226925;
	b=CVN7tuS/PdqFgyA+tSIM7tamvDbEmn/hftOp3FF+9DdDiJms/jbeFGLIgGNjIxA9UdjK
	 7C8sphTH25GKx7SwsLa+8eJL9rp+LPxLrjNzT43tgKTpjJ5ikzkdXu/z8kCCtJ+SC93kC
	 yRGzmrWpkOlnrSrYjiqr7JshC/2CUITobvBIqIhg0FcDDOFxc1LZ12NpzaQ6NOpohdbp8
	 hommI+LfP6VHKr9eVV7N+mFazInLQGZrke3ZfEmVUNYdnprquDg/o+fB8TEO0fOvcZGd9
	 /UBeKhONO7YXVXPJSASkm1tXXUMTT/hyS1ANyVyPEN77HiWIulBWPDiM9/s5FLygCPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226925;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iQ725nX9UdgX+EvgHWCaaetNVZXMZujjh3zhcuCl3JA=;
	b=clODfF/u91zFiOt3xS63p1vqFb++dulPRnkhr6lg1fMLeo625VRAi3Gz9Fk0jiJnJd+E
	 8wj5oaOh3hd2ldsX4ZRA2ucCMDrfozEJRzJK8Bt2Vwc+RzWHd4CUO8lWE6aCM9P1C6Pl5
	 SyKbmQ3ERQ7orseXnIij/9X4jp5LCBLK8eIL9a/yofVD/1S11DKL1FBnVzNcb9E3li0WI
	 hbyHTZmwRGHouxGzt+buFpgQ1l2TafZxygNtByhj2sDy9bl6/H1NGiyTB6GFf+CK7w2Ht
	 cZ0+F9QE+ZnhpQWbTf3YrajaPPL5PcFb5838j3vDm9d5FBvaE1J7HENNSCi3SrLDq7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IplUi5FR;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB30606D820
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DB30606D820
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IplUi5FR
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226915; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=iQ725nX9UdgX+EvgHWCaaetNVZXMZujjh3zhcuCl3JA=;
	b=IplUi5FRPw8m5gs/qSXgmEczbRad3bHuphkuDlK4VUXNuxpootp+oFMoNy+h/2ipq2HDQCYMHQTZHch8f7Z+LdaDoOxbAHS2wk/I2Z731otheguT+bsHmSZ77bTfAKtlvUaRcUUfx413cPkrM+RRWFutOLeGSZz8++nggG+GUJ0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOjdoY_1794226913;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOjdoY_1794226913 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:21:54 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 07/31] ocfs2: abstract the dinode suballoc bit check
Date: Mon,  9 Nov 2026 20:20:57 +0800
Message-Id: <20261109122121.21473-8-joseph.qi@linux.alibaba.com>
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

Fold the i_suballoc_bit against ocfs2_suballoc_bits_per_block() test into
a predicate.  The rationale comment stays at the call site, next to the
error it explains.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0929deb3e4b4..3be98328925d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -111,6 +111,12 @@ static bool ocfs2_dinode_has_out_of_range_suballoc_slot(struct super_block *sb,
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
@@ -1601,7 +1607,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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


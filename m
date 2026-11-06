Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963717;
	b=l+Zidxm0OJ8cAOMT3s9bDT0Z6PmixQoUM9KFWqE5e6Bggb2q5kWyu5hmqvHGUO82sk5K
	 jBHokOt4Bz5FzDvzYZGPKSZquK/UZkxNK+pJGvu0a6juIhTwRfKKVHDygFNAkckZj+3TW
	 qWCjZ1G7K2mQcs/TmwqagBn3dxpKGPD7UL61Ak1yFZhAV5MzZZ0qRRzSgMg2lM4sF7VM6
	 OWQbvXPOCNVM1weXACHQq90HvVDS4eldSS+8C0dSVuxe6gr9P/5ZlwX9Oxl+w2iZBGTKd
	 GKqIsFDluLscf7Q5s5RUA8WlY2mNW6k9Zh/B/cRdXjH3Dfl0Sb641LZXeaF/6EOEYBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963717;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uIrrmAqeFkXmdArDrckr4XQGdXW7TtcrWwvKk/frjms=;
	b=KRIdn+Auu8L2ZJYvwO+5c1EY+juJIHvit8gL+Dev7Lq8kuZOM1oLnNULNHW7ZeZJVDIn
	 kBrPs/16DjVbq8/EiUJi3qs5nwbZ6M7D0yPwGQA30yw/bZSza9Ow3nSCHB3Q411ysv/ru
	 BHBaJwoNsBr3MrlGAx+tYxHW0Pc5vduvTXLBZYs8jrfRV6jIzbl6Il7V4oR+E0FyaK9hz
	 MTB9ulR3d4Iz6yFV5ZuU1OwAxiAqgNHvqTsDcMp3me2ESleHPxhwKtL0PB0RdRUSkO0+X
	 N7VwLCvRqtmpcMkpd6bDHzgGjF4mOrIWYp0zs5TVyUpx1/aZw2GrnUi8FE350sbXVbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hKSgigVC;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0150D606A32F
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0150D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hKSgigVC
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963713; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uIrrmAqeFkXmdArDrckr4XQGdXW7TtcrWwvKk/frjms=;
	b=hKSgigVCnE5JMzuI5IE9Vl60dyQAGD9NU2sqP4TJ0U17wX4BnDM/2TbEwJWLugHWoETzVsK0kXLEp84IKQW8Mo1MQ9a94ad6TwtnwO8uRVMM5ErVnOORcjiGl/rBuDx2rN3cQF1D1bkI1rxXttmLI74Z2cLA4AtN6PuJ4QE8etY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBf72M_1793963712;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBf72M_1793963712 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:13 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 15/31] ocfs2: abstract the chain list dinode guard and count check
Date: Fri,  6 Nov 2026 19:14:42 +0800
Message-Id: <20261106111458.1467464-16-joseph.qi@linux.alibaba.com>
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

Introduce ocfs2_dinode_has_chain_list() for the OCFS2_CHAIN_FL test that
selects the id2.i_chain union arm, and ocfs2_dinode_has_bad_chain_count()
for the cl_count against ocfs2_chain_recs_per_inode() test.

This mirrors the guard predicates already used for the inline-data and
fast symlink groups, and ocfs2_dinode_has_extents() for the extent list
group.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index dbb4563dbc70..71aded2c88f7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -226,6 +226,18 @@ static bool ocfs2_dinode_has_unterminated_fast_symlink(struct super_block *sb,
 	return strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size;
 }
 
+static bool ocfs2_dinode_has_chain_list(struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL;
+}
+
+static bool ocfs2_dinode_has_bad_chain_count(struct super_block *sb,
+					     struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_chain.cl_count) !=
+		ocfs2_chain_recs_per_inode(sb);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1840,12 +1852,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
-	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
+	if (ocfs2_dinode_has_chain_list(di)) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
 		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
 				sb->s_blocksize_bits);
 
-		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
+		if (ocfs2_dinode_has_bad_chain_count(sb, di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
 					 (unsigned long long)bh->b_blocknr,
 					 le16_to_cpu(cl->cl_count));
-- 
2.39.3


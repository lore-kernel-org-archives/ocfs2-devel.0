Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226928;
	b=T6jsqgrPY98UXJZEUWfL8YmJeHNoDOrSS99kTwm6lDr2uYq0xuuqLDM9aMTbQvzgH3iN
	 eeKoNOt99qri/sh+60Nt4wWYtxkelb5n6gMJ/09SDtZxl8jiyNIONkJiBAeXpnN3vDmGL
	 A8aHzhGR/D09gcsMciosN0jfBE5CeNMwmiyv0Dvaut5XXX4Noh7cQHseui4+o+yZBfEHD
	 aDyc2JMePQEjWHu4HdYtrqR6NMZivdPZ+minOjbwghUMFwKeVNaGTXdH1IGbezRZu41uc
	 JRuu2+ChB+vRMTToPo9xYM8zpSoG1VcnHor51YoBvrv5yqAWGJ1ee0u5AhS0NbFKiAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226928;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=v2LSCJtn6vzEarQFue48CenoRyzB1aR39rmzqttV9kg=;
	b=npwDcVg2G6qmCZVaLgEqK8OHiRyYB3nQq8LO5AVSTJMO7svOxd5Jp/cmKkkA0Viik2y1
	 vsNvD7Xj02yUF8TIArx2x0upcTbm1wI+s4w2S6u5o3gD80wHVOUAuadPTtwsJQYCimkIH
	 2RzOsT30lw4n2mLDnawKK0PFMRDj4AVwiylVCtfVs/QZhuPqPaStTt6CWUiSTqMsgIZnB
	 VzWPOE4N9vkloi8JbOz6iGsbvuR0Q0SIOFDATIrGf9BEbXiEmx5rNrOVkxDEOYDHW1Zui
	 3dC2XBJtfXFVyNU94Q0Vk4pLDAQNVfMx6Bi7Z/Rki6gh7wlc7ukc1Fp3M4qZiy65+Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HTT9opoR;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19AC606A330
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A19AC606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HTT9opoR
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226924; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=v2LSCJtn6vzEarQFue48CenoRyzB1aR39rmzqttV9kg=;
	b=HTT9opoRKmxN54HWUajzRdUHy3oU33LcFYPfYTs+j0dm1mSaNLab+1PD7VKb7I6EZ2K/d737eF0LYbM1d15/0yAz2rfe3Pq55+kmBXI8fejGl2Lfz5ctc/CQ9mKbFWUnZnAN6HS3yLlWjcneMvjuXp/9v0giFWCTc46KNx93LPo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOZNkq_1794226923;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOZNkq_1794226923 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:03 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 17/31] ocfs2: abstract the chain list bits per cluster check
Date: Mon,  9 Nov 2026 20:21:07 +0800
Message-Id: <20261109122121.21473-18-joseph.qi@linux.alibaba.com>
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

Fold the cl_bpc test into a predicate that computes the expected bits per
cluster itself, and drop the u16 bpc local from
ocfs2_validate_inode_block().  No log message prints it, so keeping it at
the call site would leave an unused variable.

The two bitmap_blkno conditions are preserved: the global bitmap inode
itself is exempt from the bits-per-cluster check.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0ad86aaa9ab3..34129e25a6ac 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -244,6 +244,16 @@ static bool ocfs2_dinode_has_bad_chain_next_free(struct ocfs2_dinode *di)
 		le16_to_cpu(di->id2.i_chain.cl_count);
 }
 
+static bool ocfs2_dinode_has_bad_chain_bpc(struct super_block *sb,
+					   struct ocfs2_dinode *di)
+{
+	u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
+
+	return OCFS2_SB(sb)->bitmap_blkno &&
+		OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
+		le16_to_cpu(di->id2.i_chain.cl_bpc) != bpc;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1860,8 +1870,6 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 
 	if (ocfs2_dinode_has_chain_list(di)) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
-		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
-				sb->s_blocksize_bits);
 
 		if (ocfs2_dinode_has_bad_chain_count(sb, di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
@@ -1875,9 +1883,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 le16_to_cpu(cl->cl_next_free_rec));
 			goto bail;
 		}
-		if (OCFS2_SB(sb)->bitmap_blkno &&
-		    OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
-		    le16_to_cpu(cl->cl_bpc) != bpc) {
+		if (ocfs2_dinode_has_bad_chain_bpc(sb, di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
 					 (unsigned long long)bh->b_blocknr,
 					 le16_to_cpu(cl->cl_bpc));
-- 
2.39.3


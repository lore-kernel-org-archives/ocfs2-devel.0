Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226925;
	b=zj/BYgOx+em3uyQqWjdTUCU7usKPulqG63NCGf625WOnfuy2PbOj2nz5p3LUuAsQ7Sa8
	 QkpdiFJmcGmK3Rv8hFOe/t1mIcTs0bwMPZ5J+NRE2cFVk1fLHjtpnIoV0coN7WTNyNFSg
	 t0vVpusb2Z0kqCJV4TQ5qhpMtzINUPOj3cMDPoTjDTU8nKMcGx+zFUSZg3vFMx5hdM5p2
	 /z1tfHOzkCXcTKt0NRhHb7YftOsp/7biKr8lGTGj2PnMKw66nLW9pm42B6ESvWs5hTs9J
	 dZTGFs2TNxOLWZcLDkzUeAG0fPwjcXlTe8/e9iTiTbO7K9QhITJ7nYwP7aWNLDXqGmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226925;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DzTSlh9T8WL7TXENBVvmpXROLhx1mNSREYu24yi9dUY=;
	b=CmYfx5lIqckHeVQ8+jl52rFkTamobVgJ4SSPeA02S5A75yatdY3jJzOTJN3clfA8uaCk
	 1iuEKYjlBpq5ZTxP1iDwofhTtHuOFV9Zx179eyEozVhO8iz+KiTMVxC5f+UjWeom07mov
	 1kgIHXDlWsoibI1dBqEfMF5MWTlKh10i4x9F4OVA8PFmzi7DPNwtyoNQ412+qG9KBy0mM
	 oZdb/RBW//SuJPedFff0oy2JG7dgo/jPKdHFhixWtHwgBZzJksQGyL8AQda/u44hEbLbT
	 UbOR1V7llJhGo/L42nf5fNmGfc1rgfLqLpkEv7ayfA0MGdA9q7ahXSOgxbYf6QTUsLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="ioB33og/";
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D9606D821
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C10D9606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ioB33og/
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226917; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=DzTSlh9T8WL7TXENBVvmpXROLhx1mNSREYu24yi9dUY=;
	b=ioB33og/5LFYrY2XSAByQuldrmCQ1xjBez7/aGH4QsmZs28TWjFabvh+55kBcM/bgtOR2Peohu5LOZJV5Ljq6EHg1IFZLPp1aFqDjeKsuShH3YtmqLh+ZX8HDbNddkQl2ya7DxunyCRGXJpCpdLxaMyY+ShXOtPDoJzxWhkZPu8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8arM_1794226916;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8arM_1794226916 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:21:57 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 10/31] ocfs2: abstract the inline data dinode guard and cluster check
Date: Mon,  9 Nov 2026 20:21:00 +0800
Message-Id: <20261109122121.21473-11-joseph.qi@linux.alibaba.com>
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

Introduce ocfs2_dinode_has_inline_data() for the OCFS2_INLINE_DATA_FL
test that selects the id2.i_data union arm, and
ocfs2_dinode_has_inline_clusters() for the rule that an inline-data
inode must not also have allocated clusters.

The guard stays above the sub-checks: reading id_count or i_clusters
against the wrong id2 arm would produce false positives on valid inodes.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 17d546a9245d..2aac1918562a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -164,6 +164,16 @@ static bool ocfs2_dinode_has_size_without_clusters(struct super_block *sb,
 	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
 }
 
+static bool ocfs2_dinode_has_inline_data(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL;
+}
+
+static bool ocfs2_dinode_has_inline_clusters(struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->i_clusters) != 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1726,10 +1736,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	if (rc)
 		goto bail;
 
-	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+	if (ocfs2_dinode_has_inline_data(di)) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
-		if (le32_to_cpu(di->i_clusters)) {
+		if (ocfs2_dinode_has_inline_clusters(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: %u clusters\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3


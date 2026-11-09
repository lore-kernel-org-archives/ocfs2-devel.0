Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226930;
	b=dLA9tRxEBAOzOkzPQ4GvfY6FyNwZUat479w+fCEdW9jl7j1UVy8RlFg/kANvR0zVO/So
	 sJCe+WolqYDgeruOSo9sWARJO7AyrXs+0FVEbXIInNfKhrXaiSBxtnbYJyMFtiX9ABmYj
	 KdbSh5/YvPCkROtpV3U+cZjF4fghigt63th9mlH5SPF5KVlfoUjRGs7m837e9gis7L2N9
	 JlCrbSDALeXEsN0udRyclbst/gL/iXWzhOn/UG2jjR9nmOujT7/+fkS4/+ROZZRW2GW+P
	 pqaSh0Wgc1sh1cJmyULyJRQER8rXns+tyuuh/heFYrxC43Zq4rBvTPFElYiHJMnLwdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226930;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vsfdyaWyExPFfGu7+uGFOwgf+7DxEdrZIMMx+sL7n4w=;
	b=vpoD41xUsOwZrgcayHwQ/fxG+F/Km1n7ry8mBBdAbj+a87hQIEPCowxHpLWVTzq9qWur
	 J7f7vS+pp8XEllIIr3Rs78mz8Z6hc3aMobNEJfGCzLE+YJvm/020woRyj5a+/OFLjRtnD
	 6syZCfvdP1CeOmEQTPIXdbbd23vljicfK0Y8gKvqBt5s3MZO9NTRFmJbUNhQyR/c1gNOF
	 Lft+LR1hYYHegy+u2qolaGHQPr1esUv1JaU92twRy0/cWMkWTC5aRM3LgE5uaeQ/eFJR2
	 4oXV10MLeouEmxDrQw/BL9EEx3xbi4GghkUSf3rYGfrlFM1BS7z8SQlsO2v/7QfIHTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ybwGD25F;
	arc=none smtp.remote-ip=115.124.30.97
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAA7606EE98
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BAA7606EE98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ybwGD25F
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226927; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=vsfdyaWyExPFfGu7+uGFOwgf+7DxEdrZIMMx+sL7n4w=;
	b=ybwGD25FBUqRnzaRxVeFEOgJxkPSL7gyU9tR25X7ThK0GaQNG/XtEtl78iqTT3FZdEXhsXO8apD4lUZHN8wvbozXHCQ4XIUhxRUJ6h9jix6vQIl7/Ej88YMpQVKLO7MhfJ9q6AH6Tfu/JaTi4iQY51W8RK1QiRxrsBiXTyZpwOc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8atq_1794226925;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8atq_1794226925 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:05 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 19/31] ocfs2: abstract the zero extent list count check
Date: Mon,  9 Nov 2026 20:21:09 +0800
Message-Id: <20261109122121.21473-20-joseph.qi@linux.alibaba.com>
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

Fold the l_count == 0 test into a predicate, the first of the extent list
group guarded by ocfs2_dinode_has_extents().

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 501a11d2b071..551263f290bf 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -260,6 +260,11 @@ static bool ocfs2_dinode_has_refcount_without_loc(struct ocfs2_dinode *di)
 		!di->i_refcount_loc;
 }
 
+static bool ocfs2_dinode_has_zero_extent_count(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_list.l_count) == 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1908,7 +1913,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		u16 count = le16_to_cpu(el->l_count);
 		u16 next_free = le16_to_cpu(el->l_next_free_rec);
 
-		if (count == 0) {
+		if (ocfs2_dinode_has_zero_extent_count(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_count is zero\n",
 					 (unsigned long long)bh->b_blocknr);
-- 
2.39.3


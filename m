Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963722;
	b=G2Fk+DsXnkvLSiU5cDBX4p/UmL3neTsEqm3qjKkENMe665N0jdsJS/EznQBdw6HXLNWX
	 1A14/pO+DbruQmt53IkCUylB3LY8qLxRqNi6qYmOu7450JxfyvM383ed1fFfGVax3GdL6
	 C18uLx5Bjtm7EDdgNool/QyHZvU/DdfIw2R60/BfCTMdiE/EGiGUDsYvTpIN0MhqAmn5Q
	 /iT5Qr7FB0Elupf5fUopM10cQTiUFqSyAt5pQMSjC4PuwWQ7k3cbLIvZZ5RmT/swpirHK
	 OkxdGBvFXNPU+D1u9udLajNsnEMf+LtpVN8v4GrGA+yAyn2zrathW4zKUoPg+hg20gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963722;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vsfdyaWyExPFfGu7+uGFOwgf+7DxEdrZIMMx+sL7n4w=;
	b=rpSN0DYLt7fe59BG3GLqfmDCTqFDAVLmfD9WL0MHbmUeb8yDwKViHVYZvA0eGvPqi0tr
	 T0yRVhojN9Ano2MaawY23a5KiyreMDfeBaszi8/J56hlAF7T6P7hxSSdV+xyh+bSjLp3o
	 F6S68kWxGO9iCsxIXrIdQYuTXI4CVbtYkBSDBPGLEQKdCDb8rYSubWImU38XFhJj1z9LA
	 hMA/VWfWDaGB8Ovaiu+XQlD2SDT/tGk7QH6vMPCOL+twSvBLuFzDqN6R9nNCSDV8fa/Xk
	 ZDr6IH5Vx8qmg4vGuXrkVLs/BOeqxgMiEpCaTTtuY508dsvn+XlpFLz7NkgeKC0D/WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xq4X6qbA;
	arc=none smtp.remote-ip=115.124.30.112
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A6260A2602
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58A6260A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=xq4X6qbA
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963717; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=vsfdyaWyExPFfGu7+uGFOwgf+7DxEdrZIMMx+sL7n4w=;
	b=xq4X6qbA23JzVaBmEFhGiZP0+IA7sPcGnvLxp4gIgqe1hOzRZcARJXG3mHDqw9paS+3F95t+w32kHtAnVQDluazDEuF+IZV+IoRR0qCFGNbewAdz1Jt/F0Dg60lLSIYNxoa1FvzhrJUo6TeGSMIUk7ElpIOpXmj5XKffVBoOYRo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBf736_1793963716;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBf736_1793963716 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:16 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 19/31] ocfs2: abstract the zero extent list count check
Date: Fri,  6 Nov 2026 19:14:46 +0800
Message-Id: <20261106111458.1467464-20-joseph.qi@linux.alibaba.com>
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


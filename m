Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226929;
	b=GngP0yMFszM5jGfNX6m+je4WVIiewMwUS814+gLqsU8O1PcUgImRO8x5G69LC7FVjYLt
	 0dgqrsheGldmyNCUvi4y5Tt+4YZFAVt5KKRn6Tk18qUMz+9OVUZQRmcVgc04fATlwObAC
	 tB+Me4c+1nCyPCUNkjGrp0kUl/8zbXrL7bbFoJrGmOfoLgeVDon5dOCaZ/3wqyD0XgepF
	 a3S3OhS3apGAe9wFxVbh+Pi76nqN1ek8wd70zOekc5HbAkOQSfcBt+lXNRYplkqeVExIB
	 UrPFQCxEbUPxlOI00VTmuXRhYBZgixqU4iw5DHTncd9KPgkStEWyMzi1mtCY04iqb8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226929;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=S0ETzPYAK7L4Q6qh6RWf4Zk64gt5whgKepcRIZEMrfU=;
	b=XucReK6G472GWZ/PBvUpD3U3veX2Y2wnR8nfVas74IcTifzzJ0vh9c/85FwlNP/7MikC
	 LaDxWG1ixWR2xtoY5v/l/GKyEnkP81gPfvx3peonTybnh4OQ+rj4KyumLruhHFMg3OAfy
	 oyM4GsV2kccyk9lS5GVGM+/OhJpwzwrbop3acV6ADwZAgqKnehWQdVX4qtBzJiyXOxXiA
	 DzxWuf8jG5zSAa+NqpXek+YRJhiLqi8BUSi46II5OikrLN/yDIrq0vg9AaP+73Tog7Mwy
	 F6cE3/v8r8cuvwaKvu9kA4LrSPJEtVetkqODe57vAWrz1tnCt0BppvrCLdeRG/N3scA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wNsDy4mF;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5A7606D81A
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B5A7606D81A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wNsDy4mF
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226927; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=S0ETzPYAK7L4Q6qh6RWf4Zk64gt5whgKepcRIZEMrfU=;
	b=wNsDy4mFfGFIQqvqdy3KBuysQqenKDffSf4C4DQUp/3GfWwyl0SHoyjOIJ0Q1D71GMeb4aqXw/DEeGWBC/M2UkFD0sODgOHe1a/H9rKo5bhLxVdAjdyjJ79nzw4tsNVNXZBQR6p8CNbkSkYc4igJQiPd+RYY1qahATVG9tiBuWw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOZNlV_1794226925;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOZNlV_1794226925 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:06 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 20/31] ocfs2: abstract the oversized extent list count check
Date: Mon,  9 Nov 2026 20:21:10 +0800
Message-Id: <20261109122121.21473-21-joseph.qi@linux.alibaba.com>
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

Fold the l_count against ocfs2_extent_recs_per_inode() test into a
predicate.

Move the rationale for using the no-xattr maximum into the predicate,
next to the bound it explains, rather than leaving it at the call site
where the bound is no longer computed.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 551263f290bf..8c4ea3d048d1 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -265,6 +265,19 @@ static bool ocfs2_dinode_has_zero_extent_count(struct ocfs2_dinode *di)
 	return le16_to_cpu(di->id2.i_list.l_count) == 0;
 }
 
+static bool ocfs2_dinode_has_oversized_extent_count(struct super_block *sb,
+						    struct ocfs2_dinode *di)
+{
+	/*
+	 * The exact capacity depends on i_xattr_inline_size, another
+	 * unvalidated on-disk field. Inline xattrs only shrink the list, so
+	 * the no-xattr maximum is a safe upper bound that a valid l_count
+	 * never exceeds.
+	 */
+	return le16_to_cpu(di->id2.i_list.l_count) >
+		ocfs2_extent_recs_per_inode(sb);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1919,13 +1932,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 (unsigned long long)bh->b_blocknr);
 			goto bail;
 		}
-		/*
-		 * The exact capacity depends on i_xattr_inline_size, another
-		 * unvalidated on-disk field. Inline xattrs only shrink the
-		 * list, so the no-xattr maximum is a safe upper bound that a
-		 * valid l_count never exceeds.
-		 */
-		if (count > ocfs2_extent_recs_per_inode(sb)) {
+		if (ocfs2_dinode_has_oversized_extent_count(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
 					 (unsigned long long)bh->b_blocknr, count,
-- 
2.39.3


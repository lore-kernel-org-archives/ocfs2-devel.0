Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872189;
	b=rip8thLo6ViN0ZGsP2spNzNjq1R7eTICuxVQC2noDViBBdtLW5AiRxsEX4PGEwKkMwuS
	 RwNZxp4ZgXs7F5nu/N+LlNBZjg3ROMXPKusoHHQCuoEJfUx/1SiVU9/wzhQk7f2/SPaLM
	 n/VkMGckBg4HW7bcGDQ1perYeIZ72nY6SdW7Jw7txmGliY6/IzuGruwTGYO32pkyIl5XI
	 u+aXJaJFkD7p68VHrHe7w2WbDda3faZGV3yfxCAJFT4tv7V9XXCNPDdzUxRrLRet4oGtX
	 pbjb6CgSoKMdBoFnZ9VCQKdj60tSmL8q5OvsIzRzj1G8mh3OokBVrrEXywdo3xTsTtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872189;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DQ1+acxGA/cVA3xPDg8bZPRUvTTb0uWDFMTwgPkJtB4=;
	b=Zx+uZY6VkcSWvmWGR66C7wiyoCxZwdltPy70bMN2HgDFjS+4TS4aOQ1hl+P2ql20vxil
	 MUVZq+7Hy6j2aS0jz+0qh6SFoM0gvF9ShH44ONKStNqGGTE9dtZ37nRBFP5g0TFEP7rlf
	 8+5RwHo0ZeccgWHa+fMhAubp0N8MP5cXMuQJCzRWB0MEyGZ/BWMVxenvV3v2X/e5wzYFP
	 MOx6CiGwp8dE3DwJczaI7CBQ+DskkqR1ro6flkMKCx1reRVUkAvBnKvTKR0IR1jhezWan
	 WQ3CapEVBGG5CZOI7xo5WX4byYzHMhRLmyRROBpXckQgxV117pCN/F6PI1fWNmBDinw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=siEyV8ed;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC226083629
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EC226083629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=siEyV8ed
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872186; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=DQ1+acxGA/cVA3xPDg8bZPRUvTTb0uWDFMTwgPkJtB4=;
	b=siEyV8edNhD2IhYfp4Jl9lx0/AVQ6BhzswlsBYLzca5Dfb6ddqhWAw0QfKjshjSpAXhXoi20lU5Ckhgt09X1URCpvCWIUXmQX0ZweS5D346P1vqoCCERyj8jFIhPpVhEu6c5hqIlB8KAdBPrALL+wxBX77K6xuA+R7uyRq4rjDs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZde_1793872185;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZde_1793872185 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:45 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 19/30] ocfs2: abstract the oversized extent list count check
Date: Thu,  5 Nov 2026 17:49:15 +0800
Message-Id: <20261105094926.3203416-20-joseph.qi@linux.alibaba.com>
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
index 70fb032ce891..f68f8a26e6ab 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -255,6 +255,19 @@ static bool ocfs2_dinode_has_zero_extent_count(struct ocfs2_dinode *di)
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
@@ -1908,13 +1921,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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


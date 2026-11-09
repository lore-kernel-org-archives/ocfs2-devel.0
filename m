Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226936;
	b=G4mUkPmMac8VcOajQRjZs8oOtOtbzCkFuopof2m3pLxNROFnZpPfwCUgAe/20Qb2+Ew6
	 7yrTUWSQ/Clcq9oWzA/y78hApwfy2Mw7DlDtxBhzIMtD63UutYhuwyjf6byAdUpV6fXTv
	 sL602oxUxS79+weo86KVCytqjbQz9ACUP3cToJLFTCj1Jkppr1c7vdNnkxDlrxgvxI4OS
	 hPnwo/adx/k3VRzldPzwa+IjBM1Op7QhABQ7F6D+g17ItRDE8LFRl8zThSii5t1WGbZJi
	 220jJbkLiDfmjz9U5zGYHlah99FvLhl+3hLo3VjAxWt5WwOx6yUZMFpSfmNUxc3v1Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226936;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IYY0cQWeCGGeLPowFR5ATBEysByyfJHPA9/ZmkBd9LQ=;
	b=AKp02S41n1Bjz87AYWX64OmLKL4j181TSnB1Uajltczdbk2L7WccphFzMSD2Uzme2uGB
	 djsWfBaPoWNvUYNqjkiOzgE/Rze2nsAexAxl9sL6yYv0TMBAwJOK9oIzlVni+2ZQX3nZb
	 HlWVuJ5yXBRGPoFMOHH8rM/+CQDwgXo9jPosHi4OEEkQSpfWjj/8NQmYcaj+Ariidfikx
	 YL5zSyU0v59x3BlFyvLr3dO6pVBid6H2/jeeUBXmIsiBgfkZ0UDObl5h/QDZG4ywlmkXH
	 TXorAXn1l59Fk/yxZtzWoqo+RKoHa2sGaCouBfXGDuvnMj+0SeMCNNNKchXMJ6Ix+lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CcuEXumQ;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82342606EEBC
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82342606EEBC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=CcuEXumQ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226928; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=IYY0cQWeCGGeLPowFR5ATBEysByyfJHPA9/ZmkBd9LQ=;
	b=CcuEXumQb3ZVAZkrncMhLvhvmq/JLdfDpR5Zy5qh9W41BZk42RXSKUgqhx4UOCVlZcbwktU2StxOHQWUVeC1ewxydPA7dNx2hMOxeruwVvu06puAFjXK+3/JU9T29abGQe03O8l/bAWKzaEL6iR53DqhbdMRRSylN7VOWNPjJ5k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOjdst_1794226926;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOjdst_1794226926 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:07 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 21/31] ocfs2: abstract the extent list next free record check
Date: Mon,  9 Nov 2026 20:21:11 +0800
Message-Id: <20261109122121.21473-22-joseph.qi@linux.alibaba.com>
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

Fold the l_next_free_rec against l_count test into a predicate and use it
in both ocfs2_validate_inode_block() and
ocfs2_filecheck_repair_inode_block(), which open-coded the same
comparison.  Repair keeps its ocfs2_dinode_has_extents() guard, which
selects the id2.i_list union arm.

This completes the split of ocfs2_validate_inode_block()'s open-coded
conditions into ocfs2_dinode_has_*() predicates.  Every return code and
log message stayed at its call site, so the normal validator still
escalates through ocfs2_error() while filecheck reports its own
OCFS2_FILECHECK_ERR_* codes without touching the error handling state.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8c4ea3d048d1..9db147de1982 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -278,6 +278,12 @@ static bool ocfs2_dinode_has_oversized_extent_count(struct super_block *sb,
 		ocfs2_extent_recs_per_inode(sb);
 }
 
+static bool ocfs2_dinode_has_bad_extent_next_free(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+		le16_to_cpu(di->id2.i_list.l_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1939,7 +1945,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 ocfs2_extent_recs_per_inode(sb));
 			goto bail;
 		}
-		if (next_free > count) {
+		if (ocfs2_dinode_has_bad_extent_next_free(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
 					 (unsigned long long)bh->b_blocknr, next_free, count);
@@ -2110,7 +2116,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 	}
 
 	if (ocfs2_dinode_has_extents(di) &&
-	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+	    ocfs2_dinode_has_bad_extent_next_free(di)) {
 		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
 		changed = 1;
 		mlog(ML_ERROR,
-- 
2.39.3


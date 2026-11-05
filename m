Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872186;
	b=QOEAZZ1txuDwei0jPWYlLStCPIAXBgYHRE5GiNa2si54b+Th9MM5TBmg8l7xyy/oKZgT
	 PGHeNcqHveD4d22DbWqbtO7umu4sue4rxrjyhVvEcqgpRPXvktL8K6wrNbTdLT0FOkLJv
	 W3IWZ2CQkJNkkvvcMvP+FFvc1AAryXKfn6rEZnqVnmfX2T6tJIf6PbZwCfLTIGlRdNrjE
	 Pe+dgPG24/A8b3s/2oobqKPRJHDn1Yb5CWhTeyGDz3gdkhlrldQrJ4O+e9T9Pw+1SBSVn
	 woYwznfVytwykwP7lKvzCgS1m8w/rsVGhMiLn5dLV0XMZx/HsZwFJFp4hpt0QLvj4pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872186;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=C2Z3StpfU4XxydRapmodv+x7EPRd6xtroao8ik+0NGU=;
	b=I8ujmOsYFf8UT9011a3FqgUJBGvMCuQiSm8ntqBB1G94+fRovVEVeZnMFf6tNcIzuNAA
	 SO6ZXnusyetq1VphbqlcAvYSQqUwRFWedtb4F+8XaIbyh1p6KtFFzXhOGw5zgvJgHnYHh
	 NiwuRqfinwjXSTFqvQHQrQmhuCO8CZ6OsS3I5HLRqXUwrlwHxYDep+hXaTcySdeVpTxq2
	 KnTYKhrDUCg2IUmorOJAqvl5yTLSBeWjoAKmnZit7Ss6XJzKClyeIKOhVStWINZ9YMCBK
	 vRAEPJKIwLVyOfZGE95oDyx7KIt+VYOEK0QkB5AmaiQIAQbiVkm+ozAhVgMLfomniBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="tgIIx7/r";
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98C26082BF7
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D98C26082BF7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tgIIx7/r
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872177; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=C2Z3StpfU4XxydRapmodv+x7EPRd6xtroao8ik+0NGU=;
	b=tgIIx7/rlrZ3wLHaQBkkBtAEb1vflOsqMyb/gT/fyel6VBMNq2lrjy8cVMzYM/ue9uI8CVj1teLLgRKD5qqag5I9R8uZU8rb6wFEIpQUooz92SAOefwWgVJTQ+eMsmi9/8mp+n2jjbr5WdP+J5mys8Z8hxl3jUp7ivczi6f89pE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZa0_1793872176;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZa0_1793872176 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:37 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 10/30] ocfs2: abstract the inline data id_count bound check
Date: Thu,  5 Nov 2026 17:49:06 +0800
Message-Id: <20261105094926.3203416-11-joseph.qi@linux.alibaba.com>
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

Fold the id_count against ocfs2_max_inline_data_with_xattr() test into a
predicate.

The comparison stays signed.  ocfs2_max_inline_data_with_xattr() returns
int and subtracts the unvalidated on-disk i_xattr_inline_size from the
space available in the inode block, so it can go negative on small block
sizes.  Caching it in an unsigned local would turn a negative maximum
into a huge bound and silently accept the oversized id_count.  The
message keeps its %d for the same reason.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 96e4d5c5bfa8..d2fb111cb193 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -164,6 +164,19 @@ static bool ocfs2_dinode_has_inline_clusters(struct ocfs2_dinode *di)
 	return le32_to_cpu(di->i_clusters) != 0;
 }
 
+static bool ocfs2_dinode_has_oversized_inline_data(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	/*
+	 * The maximum is a signed int and can go negative, because
+	 * i_xattr_inline_size is itself unvalidated.  Keep the comparison
+	 * signed: an unsigned bound would turn a negative maximum into a
+	 * huge one and let the oversized id_count through.
+	 */
+	return le16_to_cpu(di->id2.i_data.id_count) >
+		ocfs2_max_inline_data_with_xattr(sb, di);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1736,8 +1749,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 			goto bail;
 		}
 
-		if (le16_to_cpu(data->id_count) >
-		    ocfs2_max_inline_data_with_xattr(sb, di)) {
+		if (ocfs2_dinode_has_oversized_inline_data(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3


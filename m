Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226921;
	b=btAgynBJ7CFx27Z1savaQaVFr6m2SRJttiYlA65/gPZ175ksiPH7zGd6OUslA2G6RZE3
	 enL6hN4UswE9cghlojWBvXdqMHdY4mBbaWtYGaHYzW/P/VSSTXYELCtj8CrEQ/KZEornA
	 R/mBD3/2NvYAiDEPwTttSNB/k5q2rO6acGbIUXVOXD/mqTxK0pqM0gP4eiRE22PuVPobB
	 TGA1YzYpOC3n1VL94h4YqtkZOwPMEVzUed12Bg+VnUdG1v0jpHE+/Z4H4+sLnZsK1/vA6
	 YM3TqYQk/fHM/KmEsxd46YQZgrFeOUtwGMEf2jt30Xd+/sNNkmhhz8NtVgGPTMkbzAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226921;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fMu03X4wbz04Z9kIe0M1Zt3sPWaYbThV3APfzRBOM2g=;
	b=zL8doXZuEspAB6cGRZziHLBQiaQjOcmnImLnEd+cQp0VNZnB9N9CtGgenHhqr6x+9gtl
	 4AjwN6ZFxrv8z86V9wqJifJFgkt5KuzGoi7mQEj6lftePv85TJiEnzX7ACUJOa1o1OI0y
	 08fV7I6oOALQ/jl73rKaQwftULwLRCa4VV5m5+ZNInIgVwB1X5eSKOND4kF99wAtVoGJA
	 zTi7Y8k/OWlqSrx7nwD44+KTSKVq05oxXz6vc9ly71hK4CdCSeSy/bHENy87XW8VXduUK
	 q66ozeQ6MEiXEafdSZ69OVgVSJMRpSw4RMtZh8WLnHMw4hzfjvzSptSaXq0YvEOmVAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DqOgmZVm;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BED606D80E
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4BED606D80E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DqOgmZVm
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226918; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=fMu03X4wbz04Z9kIe0M1Zt3sPWaYbThV3APfzRBOM2g=;
	b=DqOgmZVmmNXJhONveADONeCsUhK6KJYOd/WlDlxj/J6ox/QSVqpdbCoOzKJjNRP5rqeTIL7BR06R+TBrH8z0v0nW3bk8fNRfhkMbf/rEpgq6VQs1Kcgt25Ln1yGN+bN0KOaKKZT2nVcykSGMv7aCHn1ODFXpgKCVdFjICHyC68U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOZNis_1794226917;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOZNis_1794226917 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:21:58 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 11/31] ocfs2: abstract the inline data id_count bound check
Date: Mon,  9 Nov 2026 20:21:01 +0800
Message-Id: <20261109122121.21473-12-joseph.qi@linux.alibaba.com>
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
index 2aac1918562a..259f44661f37 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -174,6 +174,19 @@ static bool ocfs2_dinode_has_inline_clusters(struct ocfs2_dinode *di)
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
@@ -1747,8 +1760,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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


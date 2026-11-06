Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963715;
	b=QDkLF1Zn7SFg9cdsksaRJXom2Sqyg40aEh8QE4q8Cc/nJ90leFrrSKt5AgGIGAbo9Zvq
	 bAOXf+WjS+fsdnpg6qEV3IjXAVYCB6LuBNdbNkash8awQ6ZflKKIzo/JVywIn977jh/h8
	 YgdACY6aqqbvc/8yvgMEBTGmiNswgnVuSQBuAkdjB/Vpto1v0ESfPoGJsts10rkK9xdME
	 GK9KmBgO8UUz5CFzd7qIoTUj0AqNEoFCjugb3o8LdxJyomR1vSNFTrUtdg09vXqeQIsJU
	 inyE1+skuG1s5LW+BOC7+RzCj6czzTSGPHBb7GEu4PcLZX8b/KEeoRj8cRTBPAmqVWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963715;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n8+HoblF225Tt3vxaL9HSaElLmee0Y46cRpv5cYHL+w=;
	b=gbpdA/TRyoIJwnbWhJbZCRhNbeYvhDAl0V8aym6U0ACgJstpheouYvaMHWGaEv/8Qsmc
	 cVDQk6QRhx2P3xaA8OgTZhQnIl7KQmRuhLosvchhdqdwRY10pZnPbcPzkcVXKBeRMNv3H
	 eMOWS9obha9cpc4c8yrZPkkwP06SZaaZfcF65Qk4EZ013Y4EYdhYrP/hxBTA0dNzHakIn
	 cpAPCt3S48DqZwqAHOrvXcbK2FaC/ZGeF1hWHVjwhnEA3WfOpTHI8Ak+BTfIhdgKK5IYr
	 9dZJKh9zvjjF4idQGD/+AS8SQApuU29VJyfQOxcuNhLvBHeWpPG9yOzWH+nhfKPsejw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vQoeg2WW;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B323606EEB6
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B323606EEB6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=vQoeg2WW
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963710; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=n8+HoblF225Tt3vxaL9HSaElLmee0Y46cRpv5cYHL+w=;
	b=vQoeg2WWibUj2moFdydkczvG6jSd0P9IebSs4Y9xh/vlEL3V1khL8sXhdZKSDsDK2+38P4YUqkz7De03g99n5ko1W+uLsKcFEaoLacZiUzP47hsO/4nIDsRQGmz7X5m65PwuoLh1/d30rdRe/wBm49KHAMYwwz17FauLm3hsPWg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBVuyO_1793963709;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBVuyO_1793963709 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:10 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 12/31] ocfs2: abstract the inline data i_size bound check
Date: Fri,  6 Nov 2026 19:14:39 +0800
Message-Id: <20261106111458.1467464-13-joseph.qi@linux.alibaba.com>
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

Fold the i_size against id_count test into a predicate, completing the
inline-data group.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 259f44661f37..8e867f6f394a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -187,6 +187,11 @@ static bool ocfs2_dinode_has_oversized_inline_data(struct super_block *sb,
 		ocfs2_max_inline_data_with_xattr(sb, di);
 }
 
+static bool ocfs2_dinode_has_inline_size_over_count(struct ocfs2_dinode *di)
+{
+	return le64_to_cpu(di->i_size) > le16_to_cpu(di->id2.i_data.id_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1769,7 +1774,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 			goto bail;
 		}
 
-		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+		if (ocfs2_dinode_has_inline_size_over_count(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3


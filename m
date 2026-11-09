Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226922;
	b=aSmLTRIR5nE2DO/mSWcn9y//UFyY7Q+iD5s5y92S/4AbC1TLKlblYzNEUEIvGUvRRwmF
	 4RoJYb9iYX96GNzRjgTLeOFH+ckM5Kq4aj5v9M8DtdvUYktIFF+FwGnBjnsSVg5te+YF/
	 mKoEzuytGMrzaErZhNjGPSu8xIomlWvH3FkcnRSBHh2x/7u5c+RrExxOsG+lURMCXRSS5
	 NPgblEp8qlOBgflVgtkNdxQ6kLIBPCmyGSSUEzyV7zjZfuB5JImhidTWcvaux/fNdazk+
	 OZ2CrvKm7wv9RlN5Q9nVsEDzr1l4XayhuO3utuZmoGprX1oRr3n7E7Kg0vEbW+FP3yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226922;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n8+HoblF225Tt3vxaL9HSaElLmee0Y46cRpv5cYHL+w=;
	b=BQI902n1bEePET1rtAcCvxJceWDbWc+SHpzmUZI5uWnE/4QflM/axswKuP/n0PGhY7LK
	 vKDOEk4EHggmfjWbtb5Ft3yejlzcAr0RU4Io8knPLFeb4Lkhxtn+RVwdBtPub4l7svOrk
	 lSumZc2L+gMBUlriE0nEZrStJDGcLVfMb5/0GC9D1IiC8QIpPJlHj6qo5+DOys24hjl1U
	 oa/00AgARd/LLjMGdbDxMWxBg5nEQVlo7YVd82kPXOEoNhwWbXcwe1cXML57b7+MaR8+D
	 ys37PLVx5OOchDBwt10lrs68/SU0PxiHG55e2ifCUJeSchKAjkOR1E0+GKd5aMU0NPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UM+nx1IE;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80D0606D828
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E80D0606D828
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=UM+nx1IE
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226920; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=n8+HoblF225Tt3vxaL9HSaElLmee0Y46cRpv5cYHL+w=;
	b=UM+nx1IE9qEsxc8T0O9s7OfPW2AKMPIx+QE5jYTtr1QvnYRCOuvkeLcRZWnKBIO2KCfVP+0tNIx25VLOJZLp4jEvPJzsxlJEldetAexHbMsKQFvyXjcUnbXHbeG0APPuj/ZzbSn/vHBpEb3zlLtzV9QB2903ctI+F9VSlIb+UfU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOjdq1_1794226918;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOjdq1_1794226918 cluster:ay36)
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
Subject: [PATCH v3 12/31] ocfs2: abstract the inline data i_size bound check
Date: Mon,  9 Nov 2026 20:21:02 +0800
Message-Id: <20261109122121.21473-13-joseph.qi@linux.alibaba.com>
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


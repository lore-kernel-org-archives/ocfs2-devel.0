Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963720;
	b=JcZLaYcatibbtSRF1o6MbsCkKlCJlfX4QlssSTZzPXRoILwNrFtmIRJrxM9qNMez575d
	 xsFEeqDZMeqxxLuldnk2+yQU1PeGBxRox3vZsIXBc7s8258Q/P7+7Qd1lm2BV/+dAAKdh
	 45HfJocqf7RazplNSDDwPBrZSMOF72NdK4AXxqsZhV+Y3iPewnMSiYssNrt/uZqvI1fcj
	 /cOUAdKARk/mFf7DD9pNpRb3+BDK3j0k6+HcJySXgPTshNHk26Wox9UFD1/ZnbKLa6kOM
	 D+GFPevv2NN0m4WXfKLCEnhV7MAVKuJPPtqvNzEaEdIiPtHl/Wn6bYY00uiwLFyLR2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963720;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wPmDIpWtXs2t9rH++Th9Ed787MYi8Cj6sYHa/JhU+Lg=;
	b=vNwlBEXZbcxMcSVNbWfRfgodYVXoZ5Pq4JTNpyt4MJ5G50XXHzGgn2uqpKxomv6owDJ/
	 dj5MsB7CdIgg39DTHfIio73ytGMtgC3d6YFr5tXCeVVbRV4zHurZf5leQkBqoPybG6R1o
	 m2dNLJLdcSi9YIKeKPfYg7XUrnpGV6IzPeyzpIGxK2qPcpie90s23XSxZsIYhlwJTjkj2
	 E/d/w5NPQFdv8dKrmaRgaudRVbASYnw0wFYYETbZddIURJAeVS2MLEzyZIMmhj8+qcn2+
	 W9Lu0RvyIQNCDeGh5mH4mIMPGN5/SJDcdRskeI4abCkl8R9pKr69w8mEdOjch7i8Q4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=demk5P5k;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58D7606D825
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B58D7606D825
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=demk5P5k
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963716; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wPmDIpWtXs2t9rH++Th9Ed787MYi8Cj6sYHa/JhU+Lg=;
	b=demk5P5k2soRiosCR7mb1cg+LE/r+tQBT6CIsnORCbKN4eupenjYgHiOKmOslWN7ZjdNl3COrHE1MRWBNs+DAe2eFIlICUpPWicfqny/OJ/bLmO3IsDjrlB/kfGCTfTdW6leL5LPK7AtBtawFqh8Fae09MJ5goxdgxqp24kIpM4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBa-6e_1793963715;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBa-6e_1793963715 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:15 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 18/31] ocfs2: abstract the dinode refcount location check
Date: Fri,  6 Nov 2026 19:14:45 +0800
Message-Id: <20261106111458.1467464-19-joseph.qi@linux.alibaba.com>
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

Fold the OCFS2_HAS_REFCOUNT_FL without i_refcount_loc test into a
predicate.  The flag test stays inside it, since i_refcount_loc is only
meaningful for a reflink-capable inode.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 34129e25a6ac..501a11d2b071 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -254,6 +254,12 @@ static bool ocfs2_dinode_has_bad_chain_bpc(struct super_block *sb,
 		le16_to_cpu(di->id2.i_chain.cl_bpc) != bpc;
 }
 
+static bool ocfs2_dinode_has_refcount_without_loc(struct ocfs2_dinode *di)
+{
+	return (le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
+		!di->i_refcount_loc;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1891,8 +1897,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
-	if ((le16_to_cpu(di->i_dyn_features) & OCFS2_HAS_REFCOUNT_FL) &&
-	    !di->i_refcount_loc) {
+	if (ocfs2_dinode_has_refcount_without_loc(di)) {
 		rc = ocfs2_error(sb, "Inode #%llu has refcount flag but no i_refcount_loc\n",
 				(unsigned long long)bh->b_blocknr);
 		goto bail;
-- 
2.39.3


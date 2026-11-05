Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872188;
	b=WDXZ5b/CPyfnPdWVHU7PlZ45COwIrG59Ae1Dc4JzTce4dLoyTrz7/Ib/dwj7b8bTWPXv
	 MMzb+hRJWLIiZBhpKzE5iG0ifO8p7dEWsBaj1xZZwQnni9CK/gqZWNlGI2sNbjm7Yq5ry
	 UrRQOj/1IFqcP1oq48mCMgwugeNLvnYBPD0+k1vb1lqNoIBHiZp5HzaltxAf1pIL+m3mZ
	 bWW6C7VKdtmh5kvUerhOWWEUkP3y10TgEM9M5/pgnyltJv0dguCfqt23k5sK1h7R1pt1R
	 m+5Gj5kCTmfFZi2TdckMc8wOX23VTd6uek9U7qDEUWz5UPk8lLnOhmrAQP08LTrwq7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872188;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vVWDe/gofAAgbjP4k8uYhsTh1XR2zdl1WA9yNr6YGcA=;
	b=XmbhzEOQX2gzKrYt3jG/Bdg2ZnF9N+0vxtpYEA3xetNs6yj/JU+b0DukvxGFZcE5QtLc
	 85f2TJC8ZjANI1xF4IfvVOxUG33Nx4QRuieqH+lxJFAOYxqDuWcK6XWaJZDrzddLDF2ui
	 6AQdAfMX3hkCTEjCL75P38TnkUy17NtIF14veM3D2hBk9RLHRanXh28UXRk6J2WJ8M9rq
	 5+bOqAbCIRDWmZKcB9zvolCvky8gcekg5RBhfobDVCwoALFl2OKLd8Ecgdb0iN0jLbJMM
	 lY5MPaPF79gPOsENy9So6fp3oftcm7BmxAMe1T8eAaHXy7J37KdimnHkd9HUBBgfPuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PeKjslMw;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E827B6083613
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E827B6083613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=PeKjslMw
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872184; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=vVWDe/gofAAgbjP4k8uYhsTh1XR2zdl1WA9yNr6YGcA=;
	b=PeKjslMwRoZ/uVJBSI2/KGEwPmH7T//1wRfno++CAZPrRcr2BcP/uVopVv/Q3ZlzLfps23Qmf0AsxbPlqPPkrGAU89p4m9EPNVlBLtDPIbMgeuI3TJq8xWb4sORhZr7FcC1n6GLvn+H89bPNFL81b7zxHcxPqTa3T5LPgbwZeyY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZcu_1793872183;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZcu_1793872183 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:43 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 17/30] ocfs2: abstract the dinode refcount location check
Date: Thu,  5 Nov 2026 17:49:13 +0800
Message-Id: <20261105094926.3203416-18-joseph.qi@linux.alibaba.com>
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

Fold the OCFS2_HAS_REFCOUNT_FL without i_refcount_loc test into a
predicate.  The flag test stays inside it, since i_refcount_loc is only
meaningful for a reflink-capable inode.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7f3995ca771b..b4ef4077e09c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -244,6 +244,12 @@ static bool ocfs2_dinode_has_bad_chain_bpc(struct super_block *sb,
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
@@ -1880,8 +1886,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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


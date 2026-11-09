Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226929;
	b=tiMGqJt2E7e/enypPo7UKCb0r+Y+oz/rkhAD4sexB2883oPERk2ocWfx7tV+MoE8yyix
	 6cYDJZ2/l80VTsoRD6fxB0VgbLH8Fi7NwgEHAdKdtghwxoQ5jpQ8JOJ1h539liGwrBB0O
	 kVrqCDV77nQ6pN6PUZc/YWVTDoZVuTvmu9hEhIbgRAb0EWb5vihxPSjD5Ws0gzzxASLor
	 oasUdOn42YEwEENYXeY4P5ztdD4986C1J6u/pmJFApuft3qPj9S6QrBz5ANFg7RJbP9gS
	 k0OZ1tLLJqvYR2yjYxqv7I5hPMavGXOTJ1S7s1fMau934snEPtM9dlZ2cziSr22TtFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226929;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wPmDIpWtXs2t9rH++Th9Ed787MYi8Cj6sYHa/JhU+Lg=;
	b=E5vHYteRZ2WAp4ishpDFntDhito9RosXtQmGbze7cfv1qGYsPFoRGkpE69DX3wd2wn37
	 Sh3Y/04nJ3384nT3WXJgs0i0EynbjTG1DKEbzgL11WK62ROMnP6fA4vgNwqXRf132waBl
	 uVaoYME1s1mYXxldyeGWAoUuQDaUUgPTQREO47wOpVSLzfkdtT+azLfDIhX/3bl67TkyZ
	 42rngGqtBs7HIQbgxL1q8x7QrKpif0Ebt9P6zvqQITQ4NZ69FgizxOcsSM/F9lI1ZVsbY
	 5kWCKM5h4L437VCyumZeskmgAVOGjvPz0/UAkY7ZwnsyIN/WV83UjGsfhcG7lgqCaow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=yYVU+qWo;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC49606D82F
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BC49606D82F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=yYVU+qWo
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226925; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wPmDIpWtXs2t9rH++Th9Ed787MYi8Cj6sYHa/JhU+Lg=;
	b=yYVU+qWov3lJwH3a31/ip/iVGSA2A3SH8rcLIST5EPEohJ/2pGP0ON+4CW8nNm+c9t9Z1yXYX73HC4AfjsoggkKP1NrI3Dr21clr7xu//xpRHAQtaUA8k4DbauMdDUetCfmzPsZ1xWCw8xHIxkRa64aaTWHS2YfzWctEHxOjEN8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8atW_1794226924;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8atW_1794226924 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:04 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 18/31] ocfs2: abstract the dinode refcount location check
Date: Mon,  9 Nov 2026 20:21:08 +0800
Message-Id: <20261109122121.21473-19-joseph.qi@linux.alibaba.com>
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


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226938;
	b=MNBeMzkfTj45weWklI3AtCeEQLvHBzjOZlrGvRqx/NGP4x+6+06KqQlhONI1DfZQdDJP
	 5kDuNW+y9gHVTyUN3PDjALAmJSzS7o2nHOL4ur4onSglSdrrWG47l5myAQ8ncQRbiGBlt
	 cRx4qWj5QRsHJ28gIzurZeBS25c71extD9vKSD3Es7s2haQCcjlplFfQaUwS+YCAhpm6b
	 O3DHe3QmVAo1aaV2n1rkLOGalF+RdzMsC88/vZUqdxj8gfTddsSLJqSKU01zIIVEmQ28D
	 q68IEsGQL6YCNKart5jxpHEt9Hn+PCM/Yv3Uvwv9F6VXd4wNOBs1Vu5owFEmRJDRkhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226938;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UFpQwiXOBYDZTKfuhC4f7xhc7V7ByrsPsGNV0IJYJD4=;
	b=X7m3pSXXpkB5bdK4a06YMOCQQmIRoyE7pIe05nd6ocIZc9R7pWNQKChOWQwfW+weF2LW
	 2snmo5gf91EKIHEpAzJoFs5v0+4jwjiZDAtwANYMON8QehDUcc+D6o7xDBnbeSWRhuHL+
	 BAP6FW210/5Hyj4S3P0B48PvVOBtK3sf/9mc/4bN74ZcXrP/ImWi41DO096UeF6Sllwr7
	 MOdD8JMg2LpJF5DH5NpRChFAWxtabB5ZAWbAKf4gZ5c/OyDfmt4EPw3fqV9ZmOBtZr0ee
	 z3m00aU4qCW4kxixPpMVFhDhC8ZikKuFteatHfUfbbiydq9SP8TylCY4xfkeHABFF9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JPnZU87U;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BC560A2600
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4BC560A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JPnZU87U
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226936; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=UFpQwiXOBYDZTKfuhC4f7xhc7V7ByrsPsGNV0IJYJD4=;
	b=JPnZU87UTDECzicvypkkrshrZVWwbOZNQCucejncKx2rjovxYhUbZ12z9yx6npxtCSFi5ygoIihKs4uCaf0n3z/2RTRJJJTN9YPsZm0dMlinEtBoidUJuFg4OAb8N8kfivy47yj480U1rYbNXnavmjMP+vY6tKj4jbkrUPWQS/M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOjduc_1794226934;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOjduc_1794226934 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:15 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 30/31] ocfs2: check dinode refcount location in online filecheck
Date: Mon,  9 Nov 2026 20:21:20 +0800
Message-Id: <20261109122121.21473-31-joseph.qi@linux.alibaba.com>
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

Wire the OCFS2_HAS_REFCOUNT_FL without i_refcount_loc predicate into the
filecheck validator.  A reflink-capable inode with no refcount tree
location cannot be reflinked or have its refcount tree removed cleanly.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7e299b2dc8c0..6a7dff8a6a05 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2196,6 +2196,14 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (ocfs2_dinode_has_refcount_without_loc(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: inode #%llu has refcount flag but no i_refcount_loc\n",
+		     (unsigned long long)bh->b_blocknr);
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 bail:
 	return rc;
 }
-- 
2.39.3


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872193;
	b=lDe8qG2OLSsfkTxnuWdzokqQb0LfzlFz8hyx+4UH37BBi4y+2xXsOGzedLxx6NOENRS3
	 4ydEE5wzkgaJd9AAq+la8iT3sp7/DZQUImQDkex90ejbfKRVGn6nOBUi5vZCcei+HHoY5
	 LqlhHmptjE95N8g/eLxW4Q45xATU0WNfetqSXno0OGcBqzNuRasQJZQYSLKths0Q6y4QT
	 EUz7s3SrinlfSj7J6TQzA1Beb7DZ4j6qETzfL3qPoFMH2m6Jv/R5YmGRoSQZkSsNTUXPi
	 SD7PIaCysOCuZ3sJKxOpEdr3twrYpTAPTvxxRc2Udza0ySCUbn/zypEBlExDTwL6nLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872193;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=j7EPhho6X4WeJbT4WBRO+f19XJgmFg2S1eGKVkdT/7U=;
	b=ZjhHTVc/oPLyXPEvF1kmZd4F3mWittEVOEfqUtysTKIFIbQFbHesLZHBtTFKz073LkE3
	 qZ3EqirGoCDDGpYZxtr6CgjFSre8/NgUFXmD1ZZeeJIFo0kvTyINRCe8sUjsI8XOg3mMq
	 LEa1YYvLyWQA3y9l12BCfQuEIwgACaijOUk7ElMuY3P8ps92FsdWzDM2Y0HQ8qfdUMNee
	 w+MUTcav172p2BFOOUKXBb7aRxRadaMz2mQpPcdbXRBEpDvIvy8GU5+3r8S5cDi3OofNs
	 Co+FtFRdxy+K0mFqdRuN19n/uJywLQXI7TnjqlQRejRzFCVc5oPbJLmtMThCUiCy7og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oSMkFQ9m;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3050F60A2625
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3050F60A2625
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oSMkFQ9m
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872191; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=j7EPhho6X4WeJbT4WBRO+f19XJgmFg2S1eGKVkdT/7U=;
	b=oSMkFQ9m1TEjKnRwWoZ3zNRMibhztHnxdyJPPqJCKoHuPHYu3IS6UH9pv5n6XkrzOcJFpfDIurhOCJi/OcPQXj91sIfnm0/S5l14QKu83vR6Uvx7cmvF3S0sQ7FQ438Udt4E1huY6TJAbmZ8vM+Gz7/9Y4/SmLpx13gL1cBgdps=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K77E_1793872189;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K77E_1793872189 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:50 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 24/30] ocfs2: check dinode suballoc bit in online filecheck
Date: Thu,  5 Nov 2026 17:49:20 +0800
Message-Id: <20261105094926.3203416-25-joseph.qi@linux.alibaba.com>
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

Wire the suballoc bit range predicate into the filecheck validator.  A
suballocator group bitmap lives in a single block, so a bit at or beyond
ocfs2_suballoc_bits_per_block() can never be valid; accepting it would
later trip the BUG_ON() in _ocfs2_free_suballoc_bits() when the inode is
deleted.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 7cde33f0f616..0c515ba37ea0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2036,6 +2036,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_bad_suballoc_bit(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc bit %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_bit));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
-- 
2.39.3


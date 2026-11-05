Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872195;
	b=PFX/uPHDi2oJK8taMPkN2IrPp6CQNdoPgY+KdXC6PLKByG8LsHJBmNTskZLwEw5T5zeF
	 hODLWV2i+Q9Dw8zSThfWeA3JXE+nuV4elrn1Wvl2QAZhwi5EHU96Qtc5I1nOtSUSTuuYk
	 wr800pC1l5sXJ58ziSnHpY4oft3cHRYXeZo3gyf12IwJo3SjahUZBmnFnbjS4cKTIcjly
	 WdyyB98w7Bbl+I0pC56BveCKzPQcDvePsq1i7SyfkIMbv8i9I+TwnanWNf/HCL2TKWsZ+
	 uKIX24BqBaVStHCmM/cFfLY/YpgpZNWsn172DR/empXpjwIkFlNawpwKDviOTlgAKlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872195;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jJI4f0Df9QirktikvS42P/+FiXAktxHwsYl/ayhir8Y=;
	b=nMx9JDsr/UKrcZDoVFkLOnKKXeC/AzfBX9XLgb/wvsfsYXhCTH89eVGP4WZtV2GrD4DE
	 Y7xoAFcHxyP5VvFOdrxlXECFi402CCD0PwpR7m54WESGaZYbJz2bpyt5l4t36UkAFWvjy
	 yJCR8vJ2UTNDH170fY6Ypps31dch+sLskJgbHbltpNreHaRAJ5/Ld49t9Ccn+g/hGJEZk
	 vYCypWKmmmI5bYYuMoicjFJen2oS3MSXkpNq1/hSnDRORDfP2PNDj1ui21/3AubQSbeoa
	 AlFbIGzoG3cQj1Nu1ESs1q5vvZnrJ9sufEzhg9AJb9gx2xmKx0+3pX+ZdSPMav6WeBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ICd7jpTo;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2846460A263E
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2846460A263E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ICd7jpTo
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872191; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=jJI4f0Df9QirktikvS42P/+FiXAktxHwsYl/ayhir8Y=;
	b=ICd7jpToPonBF//GvAVWXoqKy7oLezzNnpVb7Us+bjuN6htVQ2ZlORSugGkKQw3i9g5c6x/8NR0B2osZxZXhXyWKAehM+Q6a5apC1BPjsqYOyBFSUl5Y7rGbqyEz8DxYaBR19wIiQvdMg2CDbfz2ogHmANtcO0jIwvWYQ0O9z/s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZfg_1793872190;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZfg_1793872190 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:51 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 25/30] ocfs2: check dinode orphaned slots in online filecheck
Date: Thu,  5 Nov 2026 17:49:21 +0800
Message-Id: <20261105094926.3203416-26-joseph.qi@linux.alibaba.com>
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

Wire both orphaned slot predicates into the filecheck validator.  Each
predicate keeps its flag guard, so a stale slot field on an inode that
is not orphaned is still accepted.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0c515ba37ea0..db8cdf4d8627 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2045,6 +2045,24 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_bad_orphaned_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: orphaned slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_orphaned_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_bad_dio_orphaned_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: DIO orphaned slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_dio_orphaned_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
-- 
2.39.3


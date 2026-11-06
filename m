Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963728;
	b=HuAWhobGfBzRZQx2E6XGZT2eMX183l7BacqksQRMwDG6LRSFTVE6T4W3gAGuh9agb/qG
	 n/sL8wfvQjlbxKdLB5/J8L9NujC5GK783rf0nt7PddOFVSx4GoOEwxlf/E51hYuRPmNFg
	 SFu429D6ML/nGvY03uV0Es8JEj2IetyqghmeatxMrMS37gS2ujMhB1VVsopxeyyAbu/AR
	 9Tsx3dptLRDZDIwaAUFoNqIKZTDAy9T0gzFEKjI2/FCR6b9b5visbD6FCchQRG1MUqLkK
	 TZBRggxqjxG+e2ouhTptQMQLlUH5I16YF4NPlDZJa/6FzXGb3ptU2xDCxMnu1W4fung==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963728;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=068c0HrULK/YT5JzIUdf1WM9tJawCe/rpcrXrDwrry4=;
	b=Fj77jZz0ziRUMJFzUOYx7E52eEI5E09b96sP3RLnym2dtUbNa1tKslJb/BwZ/GrFExF8
	 fPgbiVySFdassQ/CQjfCvugHxResql91eaMu7H0csJ2YZUQRrxU3sjkEY4U/AQK2naCYa
	 nDyJTrqiOcbWsYPzKp4AMCi0/NFpVqlLBRpx51cL31FD7FWgwDCY1AZS4c6mCLxMxeoIy
	 b2yXYQ3xn3e4PBZFU/xpKC5dE6xMbHM/n+QqmytINVjvkzptBaX6yLKAwGCU1KFqd+oPB
	 vreB5KFduYCSvdRp3XXDkloyHepmleT4sdenlqeBsMAk71FukwGBic4SFSkjlM6u6AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QXIziDIe;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7B60A6F41
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DE7B60A6F41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QXIziDIe
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963723; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=068c0HrULK/YT5JzIUdf1WM9tJawCe/rpcrXrDwrry4=;
	b=QXIziDIebCLuOrIWGECaSGAacmvpLvtSKjO1CAlZleK0+xLInVD7mrF/13qpoFUb0aFy7+kTdtiQmRqjsnvvv3lP7LaVA8vpa2TEeoWPeL+BTuhYQokNoIBevgzIThhknlLExaslq3jHrWkNIztoGanVlQTZPXT5HjAv8rIPR+Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBf74W_1793963722;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBf74W_1793963722 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:23 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 26/31] ocfs2: check dinode orphaned slots in online filecheck
Date: Fri,  6 Nov 2026 19:14:53 +0800
Message-Id: <20261106111458.1467464-27-joseph.qi@linux.alibaba.com>
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

Wire both orphaned slot predicates into the filecheck validator.  Each
predicate keeps its flag guard, so a stale slot field on an inode that
is not orphaned is still accepted.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2709c139ecff..89c6570d5f9d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2056,6 +2056,24 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
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


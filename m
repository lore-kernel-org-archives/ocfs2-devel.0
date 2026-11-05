Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872194;
	b=y3tReTBO9xrFV+fkjRFZcUZBiVD/IXofzVfXnmaGTCZ8glRUMl+xhCWiKKMZsEnGvIOE
	 L5fLiuWRItQvbQm129k0SPWEmFqi4oQUnfaSXXagaES7WPc3yBTYwP44olGCZZQoUwvuy
	 btLH6W9pEeSy9+HbLobTOomVsMgSYP2TJBuKTSQCrsI3EH5TkahFxNel2U6Kl4c8cj4oN
	 CRfhYPaZoexRAb5+i7oI0MZvA9W94GC2hQdO2ZYesl+Oui0Won2Wl8t22K4ar9+Z8jV3h
	 lmts8P2KBnLCaRg6XLj6+/NFzbFhKRY7Yf+igGhE6ShWPvEcWIeba64KAvz4uxF4B3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872194;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=byl5MxQXhfbd4TVh3cI6SsnxKUyD+oHLNtVrLi5gjAE=;
	b=3DtIXdl6pMKgubB7E4maZ6ufabBPHvjf6/hg5AuXbonfQVHAT1wCITD2c0S5utV6T7fl
	 80xu7vBEa/0f2BJrSRvlnVCj5XPMHCOeNjAat62ADcb6Yln+g1pvEFyJfS6ga5N/8jKbz
	 nZFRXWs9Tw04RoGfkZVz0sczpMNSaBAk0a5qUFLaUbZmJ0aO4xzyyKqabPDjd+IdeUN1J
	 AIstgrfLyLSoeE5KkOo3LDdKnj5ISJ3yOmcVvkfDsSbCp2fl/mNw2eISzW2aUHmjMjS6g
	 GqWemnTKTFOM/sv20XABxmzWuPDEzemD16WmC1P+gLNXOt435GXTcggUxcEyYuhv3xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ODilHX0J;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4208760A2628
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4208760A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ODilHX0J
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872190; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=byl5MxQXhfbd4TVh3cI6SsnxKUyD+oHLNtVrLi5gjAE=;
	b=ODilHX0J7abN5NhWYi85vjLY0L7ITa6KKDBPAHIVhf6zQewZQIfAnulvgV/6lF5x53MPUwYd6McVJfV+UXOLO+SZJabt0Re0B6a+kq/znNAh1cjrkV7D2EIgUPkRkY+YDtLx3+/3ax6+rWJ20ppvTTYK3SKsePPGWBHPTo31D3Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K76e_1793872188;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K76e_1793872188 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:49 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 23/30] ocfs2: check dinode suballoc slot in online filecheck
Date: Thu,  5 Nov 2026 17:49:19 +0800
Message-Id: <20261105094926.3203416-24-joseph.qi@linux.alibaba.com>
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

Wire both suballoc slot predicates into the filecheck validator.  An
OCFS2_INVALID_SLOT on a non-system inode and an out-of-range slot keep
their separate messages, so the log still distinguishes the two.

The range predicate excludes OCFS2_INVALID_SLOT, so system inodes
created by mkfs.ocfs2 from the global allocator are still accepted.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 07b9445bb538..7cde33f0f616 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2018,6 +2018,24 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_invalid_suballoc_slot(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u for non-system inode\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_out_of_range_suballoc_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
-- 
2.39.3


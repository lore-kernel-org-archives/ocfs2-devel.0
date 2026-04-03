Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E72389E03
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775207292; cv=none; b=t1xNP602sEzh5YoDuROIIrqC/zsfZRn+eBtyxfd6TqoA9NePWO4ku5CoYInmpDGotJe/ahkRLr1Pqw30shvjtfEig9FEhvpj2YmOk3GGzCCEDG/qWDmSsVbNRWs8N3Y5grMsHr+lsUM5nH24+NzPRPY3RN3TZAOcJS0lJrE3zVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775207292; c=relaxed/simple;
	bh=3sXjutqgIKHS+W6WA2F3yrs2jEN20n7ZVeeWkwfD3UM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tR3Ojmyc39nj5kGQVOm2ObHG/HmeI6CIH4TKCc57hwJbladlKcbAoiq6rHIcPwnPATrA49iuj5CcDXrws79j5vAiYnAB+v3ts8aVWnx0SpHDXH20Rw+hLu6crrNgJtYwuEMjDfMv4pJYVlO0m6K61aSMRPDlxkkjcq5SVf0Y7Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Um+jIB+p; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Um+jIB+p"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775207287; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=hlKPn4y+yxU2tcXJIzv72CtTy7V2nwR6H/B4diAaeZE=;
	b=Um+jIB+pjMnUoiX4EKG22uT7iX0jzI/ccFBp6mzofDQk7kknvRIVBQPYwznhdGpshPyPLJufAy0wleE5Cn0e1m+fz+MeQKrv/A+la3IDsviYVUNDf3Q8AbgogvAvNZHDUJJ395WjukVshu0yi8Qk4GeWF4EKM8s81rj47RNUIFI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0JqO8O_1775207286;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JqO8O_1775207286 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 17:08:07 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ocfs2: validate extent block list fields during block read
Date: Fri,  3 Apr 2026 17:08:02 +0800
Message-Id: <20260403090803.3860971-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add extent list validation to ocfs2_validate_extent_block() so that
corrupted on-disk fields are caught early at block read time rather
than during extent tree traversal.

Two checks are added:

  - l_count must equal the expected value from
    ocfs2_extent_recs_per_eb(), catching blocks with a corrupted record
    count before any array iteration.

  - l_next_free_rec must not exceed l_count, preventing out-of-bounds
    access when iterating over extent records.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/alloc.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 344fd4d95fbc..8639806bcbb8 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -917,11 +917,32 @@ static int ocfs2_validate_extent_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation)
+	if (le32_to_cpu(eb->h_fs_generation) != OCFS2_SB(sb)->fs_generation) {
 		rc = ocfs2_error(sb,
 				 "Extent block #%llu has an invalid h_fs_generation of #%u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le32_to_cpu(eb->h_fs_generation));
+		goto bail;
+	}
+
+	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has invalid l_count %u (expected %u)\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_list.l_count),
+				 ocfs2_extent_recs_per_eb(sb));
+		goto bail;
+	}
+
+	if (le16_to_cpu(eb->h_list.l_next_free_rec) > le16_to_cpu(eb->h_list.l_count)) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has invalid l_next_free_rec %u (l_count %u)\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_list.l_next_free_rec),
+				 le16_to_cpu(eb->h_list.l_count));
+		goto bail;
+	}
+
 bail:
 	return rc;
 }
-- 
2.39.3


Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F03B1E487
	for <ocfs2-devel@lists.linux.dev>; Sat, 25 Oct 2025 12:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761395546; cv=none; b=uovzdS7+7LMKldI5lGrLDLExQe9mOO5uxby+5jOtzu7YnqZtfsPLs8zr6TQ42Q7S8y4HvoulDA0e+kXcpMvbXfqyI1M8M2+w4U4v6e1cv8ZK6m+jZ89LAVDnEr1r0maogXr1sGbt1n+XeKvH6kwvssByJt2n0ExTF02PVB1qjzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761395546; c=relaxed/simple;
	bh=bKtCQZeY01x+B2cRHqvjTuXRaaYy/xhx3/4vV8NPOdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rFpy42h7SVOGAu5nu6NHRJ+ieUY6xSHrMUNO4kDzTYcyGDt2Th+qm/dM+Sm6IjKVlYHtc5yPzN9oDIQxdQJn0Ty30Vb2XIiKuZHKzkY9Tvqtd3I9Am5039ouz/vv9MMjAqmYKykt0pxqfB7qr0kKi8E7HVeRdOO5l3SylIMIykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qTkN+v8v; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qTkN+v8v"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761395540; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=8qkCxbBowUMsv9z5ivWjwIJlzY14VXRnGA0epcgBQak=;
	b=qTkN+v8vDFGgWbofYR+fpbbY1AazPGuYeYbVJckNFqCMMQHXHxz05pnxSzD90nMrjFVYsb/71HoOVJmbY3WOPbXv77BVKxzDmAudockSzkLFUOmhOl/COgNMIbfARWL6TXvMCG6fspFO6tgdLXw/EpBAMnRTyeCoE8G8uBON0WM=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wqwts6-_1761395539 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 25 Oct 2025 20:32:19 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ocfs2: convert to host endian in ocfs2_validate_inode_block
Date: Sat, 25 Oct 2025 20:32:18 +0800
Message-Id: <20251025123218.3997866-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251025123218.3997866-1-joseph.qi@linux.alibaba.com>
References: <20251025123218.3997866-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert to host endian when checking OCFS2_VALID_FL to keep consistent
with other checks.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0a0a96054bfe..dc4044a565b5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1481,7 +1481,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (!(di->i_flags & cpu_to_le32(OCFS2_VALID_FL))) {
+	if (!(le32_to_cpu(di->i_flags) & OCFS2_VALID_FL)) {
 		rc = ocfs2_error(sb,
 				 "Invalid dinode #%llu: OCFS2_VALID_FL not set\n",
 				 (unsigned long long)bh->b_blocknr);
-- 
2.39.3


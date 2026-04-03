Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273B2386554
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775207292; cv=none; b=EOoXOOtTRsv7dGZ2IJKMofK7yOu3HzayLtj7ig5AxK+OuFYxwg+G3GXAVlnYT1XESqeo7iJ8KM7DeISYlQgKDL4oKvCrno0ysn+0x+D9DFWCiuoZ0CuNJStXtqyOXlFMfjBYSWwTGTCtg4TwdNi60vsPAIO1ucpynzLTxcvN0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775207292; c=relaxed/simple;
	bh=9kuk44SM25nMs/1+zgEYpPfIKfNAvjiTqEybT+vzrXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=afVbhD9KkoVyxCL7b9uUuQczeoVT+3fnA7b0g8td33Wbh7ZYcupEf8n48yPgTrO8j9lcG7bNUQz4XMk2Drr+hGN72ooFHxu1hH4PJY0V9t1Dv3FtBJn2KK6E0AoPK3zFMWUAjHrraVVCme4KE6Cfx3rxeZPg4xZsJ2ulxj6BurU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aLRGMPsy; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aLRGMPsy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775207288; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=9u4i4CuYLhmblA3aqm/e9wXf2wX7ubkTsct3lQ7y2BQ=;
	b=aLRGMPsyzInLhZSn7CfVk13y6VgRvAG3VJDoScsttqz4/VA4//iJrP5+BmLpbGD7YsGeORD5g4zJDwd8sEsdnBd8Wl02mW9iLtTMLnnqyrWM+5YLUObvL4aPG3LqtQJE0P+LRKDYVjNnlWVprJI3Xrsxq149/G/2shcXiNJNwhQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0JsYHD_1775207287;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JsYHD_1775207287 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 17:08:08 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ocfs2: remove redundant l_next_free_rec check in __ocfs2_find_path()
Date: Fri,  3 Apr 2026 17:08:03 +0800
Message-Id: <20260403090803.3860971-5-joseph.qi@linux.alibaba.com>
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

The l_next_free_rec > l_count check after ocfs2_read_extent_block() in
__ocfs2_find_path() is now redundant, as ocfs2_validate_extent_block()
already performs this validation at block read time.

Remove the duplicate check to avoid maintaining the same validation in
two places.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/alloc.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 8639806bcbb8..08e137928080 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1878,18 +1878,6 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 		eb = (struct ocfs2_extent_block *) bh->b_data;
 		el = &eb->h_list;
 
-		if (le16_to_cpu(el->l_next_free_rec) >
-		    le16_to_cpu(el->l_count)) {
-			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has bad count in extent list at block %llu (next free=%u, count=%u)\n",
-				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    (unsigned long long)bh->b_blocknr,
-				    le16_to_cpu(el->l_next_free_rec),
-				    le16_to_cpu(el->l_count));
-			ret = -EROFS;
-			goto out;
-		}
-
 		if (func)
 			func(data, bh);
 	}
-- 
2.39.3


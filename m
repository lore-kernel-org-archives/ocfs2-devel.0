Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795575314;
	b=RA3dsg7oB6/TqwrMtnkPlTn1vsYPIU3nVraRF7hoa1lrRobfY9eNyX/4TsA6ZR1tqZd2
	 +xez4mClfPozWyBzgbG7oETw4MXVpvS3/w7pWeAuz2gIoVigVKRhsgeIn6YKCZSk8mDwR
	 wGGdsVnzHaetyVQf004Iy6cHUyUdCzwzTW0SzIs35zwK1/FFxHti1HJ+KAnsi22086+UH
	 noeiJ3o0TUSVQRrKZiwxfdIZQ4T6kh5q3bFWvaMcV9//QvWtLwcz4O+n9hYV1kz25i8zE
	 EB9F99pbxmI0WTmZ7FzifsM5Iga0yk3xEWhZdNlTG+Rl943xwPCkzJYzW1U8sLKsdAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795575314;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7erDcdDpY9NgN6nZQZC3/oBpIWFULdc3fCICAN/BOIA=;
	b=oU1cPmFIpGNW47QItxElRe0oKg25u38SerTGX3F0yFM5GGDFN0EOC9LumWdGnRSb9OZB
	 DmJzzVQJf/hDo68lP/lOGiKgNL0tmnZ7M/Ikwn05bw7qVQPjTKY4MR07lYiiX7etMXpbf
	 05ZUuVW7+vrIScEBcf9un8y/HqhXsYSEEAsrdlHYoPvgJWJhVFHyBMokaSOeJ0IuXL1x3
	 i7O9DU5CDixWvqDhzdVUA1uLTVUrKkYn8v9y1Gtq+jk4XI+MibXvNnUerLgT1UN6NXteX
	 fQLpbYF8WfWcjE8Jcz5mbb4Gq9HhkH1h8k8FVTDM0ZpqnZKAinV5OLTQyZ5FayV7ibw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NnZ9gMHZ;
	arc=none smtp.remote-ip=115.124.30.130
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAC1606A68B
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:55:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BAC1606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NnZ9gMHZ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795575309; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7erDcdDpY9NgN6nZQZC3/oBpIWFULdc3fCICAN/BOIA=;
	b=NnZ9gMHZZ2ZpX7gMR0Y9k6gljIGMpK5+Ypg77fDSif0tNWseB/rrwo+0vxZ42FgJkzWJzge4678hsKnI8WxqtRVjIyWM4n8YaUOom/VTPBbju5SkMqnVXN3NzsZjU8m5s9wMlzikw+eHyqWMlTt+FlaTV3mT/oORKwuAIv02gyM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XFQ97YH_1795575307;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFQ97YH_1795575307 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Nov 2026 10:55:07 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ocfs2: check chain allocator clusters per group in online filecheck
Date: Wed, 25 Nov 2026 10:55:05 +0800
Message-Id: <20261125025505.343454-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261125025505.343454-1-joseph.qi@linux.alibaba.com>
References: <20261125025505.343454-1-joseph.qi@linux.alibaba.com>
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

The online filecheck validator reports every dinode condition that
ocfs2_validate_inode_block() checks, with its own message and an
-OCFS2_FILECHECK_ERR_INVALIDINO code instead of ocfs2_error().

Add the clusters per group check there too, so a corrupt cl_cpg is
reported by the filecheck interface as well rather than only being
discovered when the suballocator extends the allocator.  As for the
other chain list conditions this is not repairable, so it reports
INVALIDINO and leaves the block untouched.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 0ef1e06840f0..bf3b30da86d2 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2221,6 +2221,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 			goto bail;
 		}
+
+		if (ocfs2_dinode_has_bad_chain_cpg(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: clusters per group %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_cpg));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
 	}
 
 	if (ocfs2_dinode_has_refcount_without_loc(di)) {
-- 
2.39.3


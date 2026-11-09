Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226942;
	b=nRJ43Xfm0UZf4+uzsJXYPtSB0vltkdfav8cAL5CBcoDgiOiQv9bwWY95zZElX9L3bZDh
	 oPVsAiCSQCwAZHhm5RqPA8xnUWvKvyQpabqA2GyUSMpQ/YcWFaYHdqhq+GQ2JPQ4D/Wzs
	 qAlatDsAK6z78jD2ozKnez+BW/l+Zx1uI/EXZi4ML6Jx6znrGKmy8NzMlF8KIZ3V+F2V+
	 y/XmXbSesZtzIFe/NU1Uik/wYhl+/xlMHtsVdEnCo6XmtUY9A0TLZjBUw59NyJIxgb9Hn
	 QDJBuXy7C2cZltnnbX35SbD6Tx7+ccnkYkMSuzprJaFM0O3trcjs7JPmBeHBMTARSzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226942;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Aafpolxy4G2IXnRkI9yBrWFY/qXCVvN/DDtZZv0gSZ8=;
	b=NjBoR74Pm9D5vpGDn166/iEUuTj3T8mVcuIzmjnU7ztjP4S6hM+ryY5ksa2smeK5Y9iO
	 yeiquWBDNeWkXcpQA/qIXjTgUhw2wgs9KW3NvvTZXbn9z0UrhXEznsjbf80nXbgjTwfeg
	 HTOsK/PouFY4zdGNkH1uP/P2sZdEi7yIZo/z1EJb5PYjLSY+6q2NnycC5+d8zT8yEp5KX
	 61kuEEAB3YyFkrscQ74QINl8hLi2aO1q7/9Xr7QYKRcQINWzy1taW3LzLLSeFK7iypr8J
	 V9kv5FdjmnBxUiDLXudUplTQBz3gTk/TbVld4jRVWmvS2FCO5WZQcm7tqPOGj4vZXwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pHCKog1Z;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512AA6082BDB
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 512AA6082BDB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pHCKog1Z
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226936; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Aafpolxy4G2IXnRkI9yBrWFY/qXCVvN/DDtZZv0gSZ8=;
	b=pHCKog1ZEh5lLz4a+7Iab8CBwMA596ZI7Rw7Hzpc/mXyP0EV4dpQwzOC+AdBu0ZPa5LdflothAX1gs6+LBXHibG67iM4A3eOqhKy0SgTD0nrqgLt1GkWWqj1z4+ypibx+9gKNUP77tMqOL8cdYIUqqAGzGi6JJOkPJQUmHLoVGo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8axI_1794226934;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8axI_1794226934 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:14 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 29/31] ocfs2: check chain list dinodes in online filecheck
Date: Mon,  9 Nov 2026 20:21:19 +0800
Message-Id: <20261109122121.21473-30-joseph.qi@linux.alibaba.com>
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

Wire the chain-list guard and its three sub-checks into the filecheck
validator: cl_count against ocfs2_chain_recs_per_inode(),
cl_next_free_rec against cl_count, and cl_bpc against the cluster to
block size ratio.

The bits-per-cluster predicate keeps the two bitmap_blkno conditions, so
the global bitmap inode itself remains exempt.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 132864f860fa..7e299b2dc8c0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2165,6 +2165,37 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (ocfs2_dinode_has_chain_list(di)) {
+		struct ocfs2_chain_list *cl = &di->id2.i_chain;
+
+		if (ocfs2_dinode_has_bad_chain_count(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: chain list count %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_count));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_bad_chain_next_free(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: chain list index %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_next_free_rec));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_bad_chain_bpc(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: bits per cluster %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_bpc));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+	}
+
 bail:
 	return rc;
 }
-- 
2.39.3


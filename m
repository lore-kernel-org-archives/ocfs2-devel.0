Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE1C282F7
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 02:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725244604; cv=none; b=LSyfxgNRI5ZjIL6vSJ5p40iNlTUEW9PkZvUzGVxzBlQIno873ARH4tqOK13Q4MGf++lApPtwtE2s7QQVf59HRQfknAq7U122gWF+n0dtgXOXhrfbywW87jrYmDEI8xdcAJsXIHtccFIYv1w8ILtjX1bDEWvSg++ehAEqzHH+cz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725244604; c=relaxed/simple;
	bh=gvaTHUNn91ypwBekQZaPcb418U5xnX/PcHGbttiUAfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=crwg2Qi3MjDAbKDRkxmj9BnHnu3b1aeVyC9NWQtCxAFhsMUf0Jh7Y82Cct4lJhJqEs4FQA5gMRBT938kHnYdZz9iI7GEygnDoU6OEWRCeg7w9pjWQjjP+U/y5TezNSsk/w8nftB5+6l/UlLVx9Ao5iSL6qhmGx68ZtU9BQD5juo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jwbDeiu2; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jwbDeiu2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725244600; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Ir3tb/AMSasYPRpDdduGuFl2yf0Pry+tCjwl0Nq2JNY=;
	b=jwbDeiu2bvi8SwqAam5dX6Lmp311TKC4/ZUL4N5Yi6hN6oT7BexWGTX2M3zC8Nlhxp8s0cyw9+HzFrXFzeCR8F9TadhgKxpsJsSw8KJdlCiuSPjKhtVmyZnXGXI5WVXZrPY+Z6YTiJMKyQ8iTcJ6SqS5J/5bq1Vm0KzKbcOOSRg=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WE17hqx_1725244598)
          by smtp.aliyun-inc.com;
          Mon, 02 Sep 2024 10:36:39 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jlbec@evilplan.org,
	mark@fasheh.com,
	syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v5 2/2] ocfs2: Fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
Date: Mon,  2 Sep 2024 10:36:36 +0800
Message-Id: <20240902023636.1843422-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240902023636.1843422-1-joseph.qi@linux.alibaba.com>
References: <20240902023636.1843422-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lizhi Xu <lizhi.xu@windriver.com>

When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
bh is NULL.

Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/buffer_head_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index e62c7e1de4eb..8f714406528d 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -388,7 +388,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		/* Always set the buffer in the cache, even if it was
 		 * a forced read, or read-ahead which hasn't yet
 		 * completed. */
-		ocfs2_set_buffer_uptodate(ci, bh);
+		if (bh)
+			ocfs2_set_buffer_uptodate(ci, bh);
 	}
 	ocfs2_metadata_cache_io_unlock(ci);
 
-- 
2.39.3


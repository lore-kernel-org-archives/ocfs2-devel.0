Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5B8313273;
	Mon, 25 May 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779729587; cv=none; b=ojoXI6/MomNMZUayzlQuSdZS9MCFt5Ny1oOqk7sQ4VpAJ0MqoNYvNvbTqmZDrrGTUgMkY3Z8sICYeJxDSJ8FKRmUyTyklueutq7DlTQIooPcE+2TdZs8kI/wXU20w3R9ievf9vDv7C3CYcbFejdwtFhgLCB/Mfd6b8KwoOUh2V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779729587; c=relaxed/simple;
	bh=UMFKMjRf3/71+wHDwCokaLnBN6/Y2/+8Lv26TAqWhsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dk2LbZHWdFTFk3II7JJkJNJWsFJ2BTMnO36rhGQIM3XXUyWQSMVXPbkn/0nPZ/rYvD7vfIVINFPukles6YSjyd+CsH+PvnLe7/JHMzjo9x4CuYc6SrGYXVgIkHDpGWoF35KXxnM33rQ17wZH/ISDiQmQtSoZplHTriWAAX1hpeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ncYTTwLL; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ncYTTwLL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=/dqSTzOK3wYb9sfU5a+ZubrylMJVr8TE59+VqXwCTxs=; b=ncYTTwLLvWeuf2PrRI3AR9hSXB
	MwTbwtBz9qFmzlP+tisxWHhD2G4tl6VAiFc2A4f6vw7aIBYFIgGhRjLy0tgDP8wf2GnmYt8VY8Y04
	KGnYmnuXalFRlSljMz0Tdwnz7i9HvqqM7JUIXnMG6ujeXMlDOOVOEkbRQLBHQhuIW1d8CnXgrpEhD
	b738aDUqHEZz1N3Zdasmr1OZsvc1pf9/D42eaTEThlMEo51AfEop+8iuD61GCo2tdz+9EuSlxaSty
	AC+2KmqNw3PGG3Z7dndaZKtdnjW7792x5Egc3JB/Gae+iRWbvajCIkZ/2ImIgVK0aEAhRXAmN6X0f
	bl4qYOiw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYxr-0000000HOBt-0O9U;
	Mon, 25 May 2026 17:19:43 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 19/34] ocfs2: Convert ocfs2_read_block to bh_submit()
Date: Mon, 25 May 2026 18:19:12 +0100
Message-ID: <20260525171931.4144395-20-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525171931.4144395-1-willy@infradead.org>
References: <20260525171931.4144395-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call by using bh_submit() instead of
submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: ocfs2-devel@lists.linux.dev
---
 fs/ocfs2/buffer_head_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 3e42ca700db0..44a4fa3dfbc0 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -144,9 +144,8 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 #endif
 		}
 
-		get_bh(bh); /* for end_buffer_read_sync() */
-		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(REQ_OP_READ, bh);
+		get_bh(bh); /* for bh_end_read() */
+		bh_submit(bh, REQ_OP_READ, bh_end_read);
 	}
 
 read_failure:
-- 
2.47.3


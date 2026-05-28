Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D4C2E738D;
	Thu, 28 May 2026 17:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989529; cv=none; b=eI1pqqGLjxvi4GSkq8pD83m7HEFo3yOyCMJwmVB5htUJz06SGEkIQMoGO4ZMO0g6jWy++XOLkxeBxYX36R+od1oH2j5LxxFZrHkwyMqXJ34x1DTZClEcnrxopUmpmP+Y7eUeSvPCfhYGbzGlV7560UbrqLn59xkgOPdMW9ksfyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989529; c=relaxed/simple;
	bh=0Zx08z0vN9Jyi4HS9H8i9nyvWN6GnLOgppnG02FsSpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjzOrF2z3EMRizk86foHu9XdNAKyfuUAJf0rR0C6JkRsD9Y54CPwYgbRNnP/nnjlGMuvnv1BFKSLvW5Awor68XzDiHUCcdaCBjrF7dLfuYObTk0BAMlS5JlW2Cmq+5D395NMU1miBCJ0iarKBnwpQH51GI/CpM8qy2awvU+MHf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FABkLCSB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FABkLCSB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=hGwNxE5lcUX9w38Uimt8+4mc+coN4a4M2IVgll87TTc=; b=FABkLCSBuxqQU/7X8g9Ju3OPv/
	pMNOKlLuTgF/JYnEseV2vaNXvqnmIBaw4oRP3MC7xOtQ30GK8ZCfc8j8/tp9sx3iK2Ry8wqPTKouw
	wEu6SrozmJe7gPwfOfUZNAqfxW3oFRvPtt+b+VtFygtkwS/wX2P1LZ8tmytiXqQzSoXuK5hjaCh2/
	crGhU0suFfyTVJ3tUQlsLVi5t6HHZh5AjYredFLNx1r5RSQctjoi0O2TQ8dnF2z/zSNM7+q3TRgWR
	peKxakiig+MFMaEVIVKpnGoSsCFatOtSZrdlHFdNno8QUmhTBVdTk9/yK04BXlHDgtKEhwr61WuI1
	snpEwv+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaJ-00000004aa0-24ld;
	Thu, 28 May 2026 17:31:55 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 18/34] ocfs2: Convert ocfs2_write_block to bh_submit()
Date: Thu, 28 May 2026 18:31:31 +0100
Message-ID: <20260528173150.1093780-19-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528173150.1093780-1-willy@infradead.org>
References: <20260528173150.1093780-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid an extra indirect function call and changing the buffer
refcount by using bh_submit() instead of submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
---
 fs/ocfs2/buffer_head_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 701d27d908d4..714daa4bbda2 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -62,9 +62,7 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 	/* remove from dirty list before I/O. */
 	clear_buffer_dirty(bh);
 
-	get_bh(bh); /* for end_buffer_write_sync() */
-	bh->b_end_io = end_buffer_write_sync;
-	submit_bh(REQ_OP_WRITE, bh);
+	bh_submit(bh, REQ_OP_WRITE, bh_end_write);
 
 	wait_on_buffer(bh);
 
-- 
2.47.3


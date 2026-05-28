Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D092D3FC5DA;
	Thu, 28 May 2026 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989521; cv=none; b=SLZdsiKAclWuyestooUMRhAqlZeQY8ChhS9dZkr24mR9jYmSIV47ZooGmbfz0CD3rY6iSVVjp2oLnV2tzTTg82k68R8obbwvZt7XWzMWLxq/dscN6oEBzWT76uAWha2TCKr1VPei0YLVQlBphzaA0meU+KqjW+r38DoI/QtGMNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989521; c=relaxed/simple;
	bh=vfRADDNPVZ8sx4ZKU9CrfBA+usPX+mp1sh6ydRerImE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6u8lDhZ7TC+VwaWezQ95vzJIk5GmSN7l7+KHuDjHu528qZ2heZK9M6cMnxemqRMj30J6KGRNYwesM2PkiVviR/c2r3CkRGTO/u8YvVKvFCL35poq4UCC7hikuGfTbI79MGnOeD13g87D2G5vO9957m4dz/vNizjPCL4WOBVQgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZuRFFk0v; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZuRFFk0v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=wKCIA8nNtXAcajdwEA1V/6DxmDfMAIKgu4bLXNFO92g=; b=ZuRFFk0vUFPvZfxmi1FwNiGTvJ
	e42ZB2wddwBr+2jGG3hMovUUb0D4dkVOcpYn+LJiE81jVF8vFiGUFzLReTkVXOqav0JKIZMBEaKMn
	oi8thHkZuhFlvbBGc8QjjIgIOJWpDvRsXDO/Bg88DtXEWPpfNyBnjL4VGg6qaCCs+Jv0yjdC9joNH
	wAvqJXVNehRh1dfbo14NEwSMUUhaH22rkdrnF6cPI68dfBWS5jXda8co6QgPBTZc5O+1EV+cRhWLv
	X7waURnbc71bes74rL2BwJWPZekJ+HCorgAnDyGRQ0EDkikx35QRp6LxqfIeZ9E6yoQQS2h1Mu6oL
	eK0G/rTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaJ-00000004aaC-3GqT;
	Thu, 28 May 2026 17:31:55 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 19/34] ocfs2: Convert ocfs2_read_block to bh_submit()
Date: Thu, 28 May 2026 18:31:32 +0100
Message-ID: <20260528173150.1093780-20-willy@infradead.org>
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

Avoid an extra indirect function call and changing the buffer refcount
by using bh_submit() instead of submit_bh().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
---
 fs/ocfs2/buffer_head_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 714daa4bbda2..9edaeef5c4b9 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -143,9 +143,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 #endif
 		}
 
-		get_bh(bh); /* for end_buffer_read_sync() */
-		bh->b_end_io = end_buffer_read_sync;
-		submit_bh(REQ_OP_READ, bh);
+		bh_submit(bh, REQ_OP_READ, bh_end_read);
 	}
 
 read_failure:
-- 
2.47.3


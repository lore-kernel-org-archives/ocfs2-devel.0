Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D02403E8A;
	Thu, 28 May 2026 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779989528; cv=none; b=BANwTDgvupPmFcO/oBFTcAbfOoxufPHdisoaXEUQXthjNZDqilJgy10VZvLGVySxsHRR7boAhnhSeT8VgW8r3vNBsb+L1qJGNiWYheq18SXQHWGYYeJWQsiLFejLAt9JAWFCa6sR5pKRieFxXlh2BntAY/06YkCe36a0s+Oll4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779989528; c=relaxed/simple;
	bh=CyFmYM26d76ZkKYJSY4JJTzUecNTStW7eaF21ieUwJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5JC8JAiKjvBn3NSape/ebxSa+5Ztw0KyxwWnDIUjc7BbMwaB38NC0+uCbe+EgYRK9KJk9ogLaCj7SBsACQZ2j3/rxSV+bg0mi17+yt/M7ZtTeZaVl3Pqu+pGDvZops3gzKm6EPHOCO5ByNtWjSE7gfEUsAVXvxj2DVelGZ2OM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DPyO18ag; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DPyO18ag"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5YL3wQRMlJ9Mc2LQfJNBK+sNFYnQQTh8sKR9rJ/ClMM=; b=DPyO18agiPx7qw6V7UCwQ83m/7
	J6CenD3HiGatR0wU94N+VHStI+2zQ2u6FUiVnkLLc1vHb4XlnDGY+jl/BO5usENlEpAIGncRsrBUG
	bqGb7JPqt6hHI1CfITVRwoFUs82kOWtacYEYC0YAKn1bIiwHan0nVDBQwJJYJ+BoV9yv1j70TxNQ+
	yL33bkZ05zdfxQx+hcrQIa4dOIgKTeV7XBAFraLEklNEEzD2mK0jXJmOxj8D6in/Df4bSHOxCxBBM
	4F4pddivvxUJ2r/jWypoCBAVAqV9+qMJJiYwed6yXcFlPx4oCVSSerSXa36rz1nsDE1btLc1pNmNk
	cAD6oXMw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeaJ-00000004aaF-3tnn;
	Thu, 28 May 2026 17:31:55 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH v2 20/34] ocfs2: Convert ocfs2_read_blocks to bh_submit()
Date: Thu, 28 May 2026 18:31:33 +0100
Message-ID: <20260528173150.1093780-21-willy@infradead.org>
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
index 9edaeef5c4b9..185ff4dcba75 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -319,11 +319,9 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				continue;
 			}
 
-			get_bh(bh); /* for end_buffer_read_sync() */
 			if (validate)
 				set_buffer_needs_validate(bh);
-			bh->b_end_io = end_buffer_read_sync;
-			submit_bh(REQ_OP_READ, bh);
+			bh_submit(bh, REQ_OP_READ, bh_end_read);
 			continue;
 		}
 	}
-- 
2.47.3


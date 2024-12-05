Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FD2224B01;
	Thu,  5 Dec 2024 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419037; cv=none; b=FP1pVdPi/KyEVfVKtsiF5vdesRGw65dxP/1YHv/uLfwLi1yPbieU67GO8JKKJr88m5x324Lfp2utqMuGRZpkLjRMYWwHcXqOqWVbvQx1hQHRNqYyK9ifQ0JxvLswtB45VQ1C2kG6dXGTLM3BeDOuWurSqenpJCmRivX+uiwkt20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419037; c=relaxed/simple;
	bh=XzqZe47Br96RJjSNvIIZDKG/U/HC3VdMf6AvgKiRS30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=au1/Ckl2MoVlDrUJ5I3E+xG+CiTgPjBcbJ79s1Sl7jPZdL3wh54NuVE50Z2m7vOxy8Q7Th8STQyIaTd0s9cCRG69CHbAmuoFIKqfEt4xYBTGRwqjtiBjevGA+HawALj/ae1N2gC9d8YkG+Sj1LoGjoh1WDYnMS2zuPl+u6jP0d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FAPypP8P; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FAPypP8P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=uMpWjAoCXwStx8LVwMyFrNoBQli1b1MJmeVAnjw+Jis=; b=FAPypP8Ps5+Z7HoQBezVb4bLdq
	mNnGykT2LxliiHJds8o5m6kuejSXLv83YoExiqyhT4XEHbJ21o1TmgVMrRd6uw3dForpJyVsVlu6P
	CkAt8UQWn3XBAqhPUzvKg+3WVJSrJO/vADVfoG7CcAFlC6HySUMZjqN+M0N6aAExcyqW5GAbZksQU
	tFxT22CoGTZoP5vnQiNg7KUJi2JcU9lud0Ti5/FwM23sUQtwLy3ZG70HVKa/kSi96Od9RMH6hLJC0
	gFVygV+zo39V5Q55Nztq0lqS7PdDt/c66ECDR2ga4PRGlZMwEKfSzx0m7m0cHKd2qMHeceRK+3JfZ
	endEMUmg==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTF-0000000DLFm-2kV1;
	Thu, 05 Dec 2024 17:16:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ocfs2-devel@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>,
	stable@vger.kernel.org
Subject: [PATCH 01/23] ocfs2: Handle a symlink read error correctly
Date: Thu,  5 Dec 2024 17:16:29 +0000
Message-ID: <20241205171653.3179945-2-willy@infradead.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241205171653.3179945-1-willy@infradead.org>
References: <20241205171653.3179945-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we can't read the buffer, be sure to unlock the page before
returning.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
---
 fs/ocfs2/symlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index d4c5fdcfa1e4..f5cf2255dc09 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -65,7 +65,7 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
 
 	if (status < 0) {
 		mlog_errno(status);
-		return status;
+		goto out;
 	}
 
 	fe = (struct ocfs2_dinode *) bh->b_data;
@@ -76,9 +76,10 @@ static int ocfs2_fast_symlink_read_folio(struct file *f, struct folio *folio)
 	memcpy(kaddr, link, len + 1);
 	kunmap_atomic(kaddr);
 	SetPageUptodate(page);
+out:
 	unlock_page(page);
 	brelse(bh);
-	return 0;
+	return status;
 }
 
 const struct address_space_operations ocfs2_fast_symlink_aops = {
-- 
2.45.2


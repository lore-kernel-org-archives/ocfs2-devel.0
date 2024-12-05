Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3A4225771
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419052; cv=none; b=eWrZ+uYPCVXWj0/CZbIQu3dQJ/2kzZxHulDZ16VZvVib1hrbjk/Nz3NBuhvTgQFtj60xugIoRpP6+pJQ946sbMCx0VbVqc04nrN68KYcM2axbIXyfP7mQva3ktpN4vRnvVKDf8eZ6oZftH6M822WZ/znkt/HbfZkyr4c54qco1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419052; c=relaxed/simple;
	bh=6fR8f8+LGeDTaaQVeUbng9ZDbQRCBSI7JuuVlSd5RQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nks02ftSDmewektoIPvrJbe0WcQ4b+Dm4VQ7yIiYE6uA4RRrTJYjHXvfm8EDK3bxX/oz9bNPf0QmAys5zPn9hH9vEvsQpZHHDscFeLEStEhg4NkpdJO51LQN2x4uKSJdmJsvVghbieliE08wjXmBJQDZgulbX2IZG3Yc/Aebx8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pbe1xFZt; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pbe1xFZt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=fdg2uRUNQgIAA/fpwgKroqdo3N6ku16P/WgOrL/JiCw=; b=pbe1xFZtdnM16W5D5vC4uefLmc
	sZONyQi6g3oobbwUk60OkKKngoc82Dsx8wyXwsOY+R+7/3x4+WomCrZ3bcmfk5iXPGE2Qd+oqAkLv
	Tk+ff9kordJdxS5TUeYPZbKTWwdweXEDuu994oeyo58GqKpq9YkqReBvUJoHB5kmHJk0vG57wmC+N
	DbGnA8/R4wxoUvpQRddGakUMf7aelGMjF5pyJJ+t9Ukkv7Zte2JYt87zclg3Wug4wIPQ14VwZyqEF
	2ATE64IgI6Y6Wott6sMnyxBf1Sw/ibCfR8M0S5RGAM+k3HAjps+GOCSF+/Y1oxTtjG/9bv2oOFEPB
	E8aucP2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLG4-1Fqa;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 08/23] ocfs2: Convert ocfs2_inode_lock_with_page() to ocfs2_inode_lock_with_folio()
Date: Thu,  5 Dec 2024 17:16:36 +0000
Message-ID: <20241205171653.3179945-9-willy@infradead.org>
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

From: Mark Tinguely <mark.tinguely@oracle.com>

Saves a hidden call to compound_head().

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c    |  2 +-
 fs/ocfs2/dlmglue.c | 18 ++++++++----------
 fs/ocfs2/dlmglue.h |  6 ++----
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1896a1d24173..161f2dc00b00 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -283,7 +283,7 @@ static int ocfs2_read_folio(struct file *file, struct folio *folio)
 
 	trace_ocfs2_readpage((unsigned long long)oi->ip_blkno, folio->index);
 
-	ret = ocfs2_inode_lock_with_page(inode, NULL, 0, &folio->page);
+	ret = ocfs2_inode_lock_with_folio(inode, NULL, 0, folio);
 	if (ret != 0) {
 		if (ret == AOP_TRUNCATED_PAGE)
 			unlock = 0;
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 60df52e4c1f8..acebfa19ea6f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2529,30 +2529,28 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 
 /*
  * This is working around a lock inversion between tasks acquiring DLM
- * locks while holding a page lock and the downconvert thread which
- * blocks dlm lock acquiry while acquiring page locks.
+ * locks while holding a folio lock and the downconvert thread which
+ * blocks dlm lock acquiry while acquiring folio locks.
  *
- * ** These _with_page variantes are only intended to be called from aop
- * methods that hold page locks and return a very specific *positive* error
+ * ** These _with_folio variantes are only intended to be called from aop
+ * methods that hold folio locks and return a very specific *positive* error
  * code that aop methods pass up to the VFS -- test for errors with != 0. **
  *
  * The DLM is called such that it returns -EAGAIN if it would have
  * blocked waiting for the downconvert thread.  In that case we unlock
- * our page so the downconvert thread can make progress.  Once we've
+ * our folio so the downconvert thread can make progress.  Once we've
  * done this we have to return AOP_TRUNCATED_PAGE so the aop method
  * that called us can bubble that back up into the VFS who will then
  * immediately retry the aop call.
  */
-int ocfs2_inode_lock_with_page(struct inode *inode,
-			      struct buffer_head **ret_bh,
-			      int ex,
-			      struct page *page)
+int ocfs2_inode_lock_with_folio(struct inode *inode,
+		struct buffer_head **ret_bh, int ex, struct folio *folio)
 {
 	int ret;
 
 	ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK);
 	if (ret == -EAGAIN) {
-		unlock_page(page);
+		folio_unlock(folio);
 		/*
 		 * If we can't get inode lock immediately, we should not return
 		 * directly here, since this will lead to a softlockup problem.
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index e5da5809ed95..a3ebd7303ea2 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -137,10 +137,8 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 			 int ex,
 			 int arg_flags,
 			 int subclass);
-int ocfs2_inode_lock_with_page(struct inode *inode,
-			      struct buffer_head **ret_bh,
-			      int ex,
-			      struct page *page);
+int ocfs2_inode_lock_with_folio(struct inode *inode,
+		struct buffer_head **ret_bh, int ex, struct folio *folio);
 /* Variants without special locking class or flags */
 #define ocfs2_inode_lock_full(i, r, e, f)\
 		ocfs2_inode_lock_full_nested(i, r, e, f, OI_LS_NORMAL)
-- 
2.45.2


Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603A1226EF3
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419053; cv=none; b=ElJeXgfYLDI+d16K2NtwapE+XGU0i8ekFR3QMx0RdnpRWgJO80P3672rV/HZr/iVuWfGbOvYcmeYHe1bhU13qBmoLdE0HmMaGW2uVtfUP9MwN9eCs5iKTogEcITHPtgh51tNm8v2VDlXqD/Iyo1WM4IKhCzjv1V3WPmCCNthqRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419053; c=relaxed/simple;
	bh=6gJwNN85u+Uc2sqOfJPWF/35FiDjJm+yWGhdSV9O67s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7eYErJ1bLr6qrNOz3NsjxnRmCciLMD3+5EVtw45hVVGT2G3fdpcpCfFChaiP/mMb9GXwY+Ljew4M2EQZgbucaRIiDnRUVyj1l9K+jbeo8h5p2q4Bz0imBaOL2aQOi4uxIbIzXXbk/DozXl9kPosxYHgx8ZYxK4zFjj9rtllitI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gqj2rWhk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gqj2rWhk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Rm0ZzPISzXdjYe07sannLWkZ5pHNky3BouRz2PDCbQA=; b=Gqj2rWhk22xH9HNV+Efk47X/If
	IEjo/ttX9QCxQ99zhf43NwN7Ic4ncTRrVpS9xnQVFKZyrc5foIcExUNrD+skjjRr8OoZGrAszXN1L
	sPgOj3RdHxvKWZcrfgB+qGd32B+IKPZSzKY1Uygaf2nC3rfrbStZUPRMp5K/5u+sCWvppDVkFEwcH
	IptwAGlDeNJdqHN9XCyxH3WjhjO/DevGcwMzCPrzCx7sZF3+NNOSEhvBEsGP+oI8iXIRFC7KNXm9w
	EtRy5a9O4qtL6z/TCEN+geoMBgldY0dT7PIWch8Je/cfdJBms5gvPnelIijGLGjtxMRJn5R4m5Mqe
	FTBRcZwQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTG-0000000DLFz-0Qwi;
	Thu, 05 Dec 2024 17:16:58 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ocfs2-devel@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH 06/23] ocfs2: Pass mmap_folio around instead of mmap_page
Date: Thu,  5 Dec 2024 17:16:34 +0000
Message-ID: <20241205171653.3179945-7-willy@infradead.org>
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

Saves a few hidden calls to compound_head() and accesses to
page->mapping.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/aops.c | 37 ++++++++++++++++++-------------------
 fs/ocfs2/aops.h |  6 +++---
 fs/ocfs2/mmap.c |  2 +-
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c5e9c3462b84..aac644a0d25d 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1023,7 +1023,7 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 				      struct ocfs2_write_ctxt *wc,
 				      u32 cpos, loff_t user_pos,
 				      unsigned user_len, int new,
-				      struct page *mmap_page)
+				      struct folio *mmap_folio)
 {
 	int ret = 0, i;
 	unsigned long start, target_index, end_index, index;
@@ -1068,18 +1068,18 @@ static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 			 * and wants us to directly use the page
 			 * passed in.
 			 */
-			lock_page(mmap_page);
+			folio_lock(mmap_folio);
 
 			/* Exit and let the caller retry */
-			if (mmap_page->mapping != mapping) {
-				WARN_ON(mmap_page->mapping);
-				unlock_page(mmap_page);
+			if (mmap_folio->mapping != mapping) {
+				WARN_ON(mmap_folio->mapping);
+				folio_unlock(mmap_folio);
 				ret = -EAGAIN;
 				goto out;
 			}
 
-			get_page(mmap_page);
-			wc->w_pages[i] = mmap_page;
+			folio_get(mmap_folio);
+			wc->w_pages[i] = &mmap_folio->page;
 			wc->w_target_locked = true;
 		} else if (index >= target_index && index <= end_index &&
 			   wc->w_type == OCFS2_WRITE_DIRECT) {
@@ -1536,9 +1536,8 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size)
 }
 
 static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
-					  struct inode *inode, loff_t pos,
-					  unsigned len, struct page *mmap_page,
-					  struct ocfs2_write_ctxt *wc)
+		struct inode *inode, loff_t pos, size_t len,
+		struct folio *mmap_folio, struct ocfs2_write_ctxt *wc)
 {
 	int ret, written = 0;
 	loff_t end = pos + len;
@@ -1553,7 +1552,7 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	 * Handle inodes which already have inline data 1st.
 	 */
 	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
-		if (mmap_page == NULL &&
+		if (mmap_folio == NULL &&
 		    ocfs2_size_fits_inline_data(wc->w_di_bh, end))
 			goto do_inline_write;
 
@@ -1577,7 +1576,7 @@ static int ocfs2_try_to_write_inline_data(struct address_space *mapping,
 	 * Check whether the write can fit.
 	 */
 	di = (struct ocfs2_dinode *)wc->w_di_bh->b_data;
-	if (mmap_page ||
+	if (mmap_folio ||
 	    end > ocfs2_max_inline_data_with_xattr(inode->i_sb, di))
 		return 0;
 
@@ -1644,9 +1643,9 @@ static int ocfs2_zero_tail(struct inode *inode, struct buffer_head *di_bh,
 }
 
 int ocfs2_write_begin_nolock(struct address_space *mapping,
-			     loff_t pos, unsigned len, ocfs2_write_type_t type,
-			     struct folio **foliop, void **fsdata,
-			     struct buffer_head *di_bh, struct page *mmap_page)
+		loff_t pos, unsigned len, ocfs2_write_type_t type,
+		struct folio **foliop, void **fsdata,
+		struct buffer_head *di_bh, struct folio *mmap_folio)
 {
 	int ret, cluster_of_pages, credits = OCFS2_INODE_UPDATE_CREDITS;
 	unsigned int clusters_to_alloc, extents_to_split, clusters_need = 0;
@@ -1669,7 +1668,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 
 	if (ocfs2_supports_inline_data(osb)) {
 		ret = ocfs2_try_to_write_inline_data(mapping, inode, pos, len,
-						     mmap_page, wc);
+						     mmap_folio, wc);
 		if (ret == 1) {
 			ret = 0;
 			goto success;
@@ -1721,7 +1720,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			(long long)i_size_read(inode),
 			le32_to_cpu(di->i_clusters),
-			pos, len, type, mmap_page,
+			pos, len, type, mmap_folio,
 			clusters_to_alloc, extents_to_split);
 
 	/*
@@ -1797,7 +1796,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 * extent.
 	 */
 	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
-					 cluster_of_pages, mmap_page);
+					 cluster_of_pages, mmap_folio);
 	if (ret) {
 		/*
 		 * ocfs2_grab_pages_for_write() returns -EAGAIN if it could not lock
@@ -1848,7 +1847,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 	 * to VM code.
 	 */
 	if (wc->w_target_locked)
-		unlock_page(mmap_page);
+		folio_unlock(mmap_folio);
 
 	ocfs2_free_write_ctxt(inode, wc);
 
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 1d1b4b7edba0..1cb46072ad84 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -37,9 +37,9 @@ typedef enum {
 } ocfs2_write_type_t;
 
 int ocfs2_write_begin_nolock(struct address_space *mapping,
-			     loff_t pos, unsigned len, ocfs2_write_type_t type,
-			     struct folio **foliop, void **fsdata,
-			     struct buffer_head *di_bh, struct page *mmap_page);
+		loff_t pos, unsigned len, ocfs2_write_type_t type,
+		struct folio **foliop, void **fsdata,
+		struct buffer_head *di_bh, struct folio *mmap_folio);
 
 int ocfs2_read_inline_data(struct inode *inode, struct page *page,
 			   struct buffer_head *di_bh);
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 93b886f16c40..6a314e9f2b49 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -91,7 +91,7 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 		len = ((size - 1) & ~PAGE_MASK) + 1;
 
 	err = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
-				       &locked_folio, &fsdata, di_bh, &folio->page);
+				       &locked_folio, &fsdata, di_bh, folio);
 	if (err) {
 		if (err != -ENOSPC)
 			mlog_errno(err);
-- 
2.45.2


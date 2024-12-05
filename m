Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF66224B19
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419042; cv=none; b=eQwFeP8OIeqTH8EouwM4HnnpUR+6Iqt/xK+R6HL0icNJmN+7IOf0pfkqCeEd7+y8eru8i5GaM/RUg/uBVjQsZq8NcVqDbE/pio6Zrz6tdJpwglTFJgc7QTvYvkcA9J8yJ4+vZjsu9QukCmGYuEga0IuBh/pHRxpTv/DPIf6OqX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419042; c=relaxed/simple;
	bh=+pEHFCJRYVp9wtgA/S5vssAiOAjG8k4Bx/srLVrStww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDJENvK/6HAcf9GmygbQ3j7N17rLwrLksrxHg8u1Qo+bNY8xPt1wiDNtJSx93f44rElSMNRtI5YABY5o9UwqvOwX225Le7sJfZuhuqn8taPLpOM87VT6dRUqVjzjSrGw3x6hTPKf/PafVEYaGpyjweVhl5nbtfKKwQDp04LWJds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GRccSQdO; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GRccSQdO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Z/xqKKp3dYECHXezf7zpZ7Z3huCAA1R3z+3QlvEr5Tc=; b=GRccSQdOCFSr63KZrg0GM9oLYp
	zjVZnoZ7CEw8Ry7MojmiWArqfoW8xu+FgdEB847nR44MDchs34yTFlurdzyU0sy2xLDMtKbi1J/HS
	WWJb+fAwLIF+02q7fxL1gNH00/bq8iCVRyl3s97gkBUu7mb4e3jGzTSqJWVSDYyCLJzKkL6af7RXh
	1Aob6bazhOrRR+CG3vHlHT/1Iu9nCO1TXqU5mnH5Tffxk5npjpKZYJ78ByPMo1my+b+WLNK0kZCxm
	t0d9dysaR7zr5dZVpNeSRy1I2hv7qutGM4gegURAGHYXEm43kwOXYMvVmYf/9dR2t7oRyhEXSPARo
	9OoRslxA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTF-0000000DLFo-3FlE;
	Thu, 05 Dec 2024 17:16:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ocfs2-devel@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH 02/23] ocfs2: Convert ocfs2_page_mkwrite() to use a folio
Date: Thu,  5 Dec 2024 17:16:30 +0000
Message-ID: <20241205171653.3179945-3-willy@infradead.org>
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

Pass the folio into __ocfs2_page_mkwrite() and use it throughout.
Does not attempt to support large folios.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/mmap.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 6ef4cb045ccd..93b886f16c40 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -44,13 +44,13 @@ static vm_fault_t ocfs2_fault(struct vm_fault *vmf)
 }
 
 static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
-			struct buffer_head *di_bh, struct page *page)
+			struct buffer_head *di_bh, struct folio *folio)
 {
 	int err;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
-	loff_t pos = page_offset(page);
+	loff_t pos = folio_pos(folio);
 	unsigned int len = PAGE_SIZE;
 	pgoff_t last_index;
 	struct folio *locked_folio = NULL;
@@ -72,9 +72,9 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 	 *
 	 * Let VM retry with these cases.
 	 */
-	if ((page->mapping != inode->i_mapping) ||
-	    (!PageUptodate(page)) ||
-	    (page_offset(page) >= size))
+	if ((folio->mapping != inode->i_mapping) ||
+	    !folio_test_uptodate(folio) ||
+	    (pos >= size))
 		goto out;
 
 	/*
@@ -87,11 +87,11 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 	 * worry about ocfs2_write_begin() skipping some buffer reads
 	 * because the "write" would invalidate their data.
 	 */
-	if (page->index == last_index)
+	if (folio->index == last_index)
 		len = ((size - 1) & ~PAGE_MASK) + 1;
 
 	err = ocfs2_write_begin_nolock(mapping, pos, len, OCFS2_WRITE_MMAP,
-				       &locked_folio, &fsdata, di_bh, page);
+				       &locked_folio, &fsdata, di_bh, &folio->page);
 	if (err) {
 		if (err != -ENOSPC)
 			mlog_errno(err);
@@ -112,7 +112,7 @@ static vm_fault_t __ocfs2_page_mkwrite(struct file *file,
 
 static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
 {
-	struct page *page = vmf->page;
+	struct folio *folio = page_folio(vmf->page);
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	struct buffer_head *di_bh = NULL;
 	sigset_t oldset;
@@ -141,7 +141,7 @@ static vm_fault_t ocfs2_page_mkwrite(struct vm_fault *vmf)
 	 */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, page);
+	ret = __ocfs2_page_mkwrite(vmf->vma->vm_file, di_bh, folio);
 
 	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
-- 
2.45.2


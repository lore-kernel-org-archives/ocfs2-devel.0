Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A037322579D
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419023; cv=none; b=QfL+PPKvmlkLPMx0oHdxzw6YfaxdZCZdSKZ3OsoVaC2KNP40B5TaHrx+2KQuAut9Wr43mBLakPF1eU2MKXuLeRms9pIHdsSxYGoGEV1UL0udUl63NN2LZsyynbFlnwu10X2T7pS1j3EazkTFBioOyv287+a1+a1jvPDGDX8b/oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419023; c=relaxed/simple;
	bh=uFeWHBGTjdPxajyLI5qqpAR4Ejy3DGLOS9zTG5Fdkdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rr0ooSwsggZ/RLpT3n/kUX6oiZIMOroAL2c7juHJ+ayPezm9ETZhPB/j+P7o3WAsbep1yfom+ezfOX6jpR7yvhQGMIEgoHtDr2bQGYLKq1KiDiNEb+sFKWotKi8bkT8k3b/FT9dn8AGQjc1IA0hXSUOIAgFtSoTIF8SNxD3/cWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FJ3CJRC5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FJ3CJRC5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=72BKIgdnaEH0NqQiIR5xnue352hkq41VyzkpRVNz0Q8=; b=FJ3CJRC5zVsSv5SydpU+3CvYAL
	Q2NP9ZlAokNR7QB3yvtRkbD1uBLJCT8R7JvfKFF4aDLZZMrK2lkn/0UskCIl2KG/4jBzyY6bz03xr
	9zmNaL25aPJfCgmgjBj1FNSnuc9lA05lsp6QxCWOw2GiQ2ILRKEzsRXCIvxHh+CH/CIg3Q5LCfXpR
	mzl8vAkszA/F7ZHPwJgGJmGyFKMfy2sJzsQ9qyMQSNJd2/Gg99yx/6jtNZloIdkVWTxvvh/VuBiWF
	97ldk9R+C1a3HyastQuVYkQSGro8WQOL0sy4RFqQ/vh2A5o1QMQMQu0hLkari/oWtTw77DmxGubKv
	Ydc0pv1g==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTH-0000000DLGT-1E4k;
	Thu, 05 Dec 2024 17:16:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 18/23] ocfs2: Convert ocfs2_map_and_dirty_page() to ocfs2_map_and_dirty_folio()
Date: Thu,  5 Dec 2024 17:16:46 +0000
Message-ID: <20241205171653.3179945-19-willy@infradead.org>
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

All callers now have a folio, so skip the folio->page->folio conversion.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ocfs2/alloc.c        | 17 ++++++++---------
 fs/ocfs2/alloc.h        |  6 +++---
 fs/ocfs2/refcounttree.c |  5 ++---
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index dfcdafc11377..c8d9d5e9a7fd 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6808,11 +6808,10 @@ static int ocfs2_zero_func(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
-			      unsigned int from, unsigned int to,
-			      struct page *page, int zero, u64 *phys)
+void ocfs2_map_and_dirty_folio(struct inode *inode, handle_t *handle,
+		size_t from, size_t to, struct folio *folio, int zero,
+		u64 *phys)
 {
-	struct folio *folio = page_folio(page);
 	int ret, partial = 0;
 	loff_t start_byte = folio_pos(folio) + from;
 	loff_t length = to - from;
@@ -6871,8 +6870,8 @@ static void ocfs2_zero_cluster_folios(struct inode *inode, loff_t start,
 		BUG_ON(from > PAGE_SIZE);
 		BUG_ON(to > PAGE_SIZE);
 
-		ocfs2_map_and_dirty_page(inode, handle, from, to, &folio->page, 1,
-					 &phys);
+		ocfs2_map_and_dirty_folio(inode, handle, from, to, folio, 1,
+				&phys);
 
 		start = (folio->index + 1) << PAGE_SHIFT;
 	}
@@ -7120,7 +7119,7 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 
 		/*
 		 * Save two copies, one for insert, and one that can
-		 * be changed by ocfs2_map_and_dirty_page() below.
+		 * be changed by ocfs2_map_and_dirty_folio() below.
 		 */
 		block = phys = ocfs2_clusters_to_blocks(inode->i_sb, bit_off);
 
@@ -7143,8 +7142,8 @@ int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 			goto out_unlock;
 		}
 
-		ocfs2_map_and_dirty_page(inode, handle, 0, page_end, &folio->page, 0,
-					 &phys);
+		ocfs2_map_and_dirty_folio(inode, handle, 0, page_end, folio, 0,
+				&phys);
 	}
 
 	spin_lock(&oi->ip_lock);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index 6a2aca1a062e..1c0c83362904 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -254,9 +254,9 @@ static inline int ocfs2_is_empty_extent(struct ocfs2_extent_rec *rec)
 	return !rec->e_leaf_clusters;
 }
 
-void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
-			      unsigned int from, unsigned int to,
-			      struct page *page, int zero, u64 *phys);
+void ocfs2_map_and_dirty_folio(struct inode *inode, handle_t *handle,
+		size_t from, size_t to, struct folio *folio, int zero,
+		u64 *phys);
 /*
  * Structures which describe a path through a btree, and functions to
  * manipulate them.
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 68e0339690e9..693665a36855 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2975,9 +2975,8 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 			}
 		}
 
-		ocfs2_map_and_dirty_page(inode,
-					 handle, from, to,
-					 &folio->page, 0, &new_block);
+		ocfs2_map_and_dirty_folio(inode, handle, from, to,
+				folio, 0, &new_block);
 		folio_mark_accessed(folio);
 unlock:
 		folio_unlock(folio);
-- 
2.45.2


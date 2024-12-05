Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23248224AEA
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Dec 2024 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733419034; cv=none; b=er7a1B05n7+RBI7G/LYmmEYMF3597lUWxuO2JciqoBViKGXQXQ/7xHnpxjI4nS7et10sIPG5bpUZujnLc99aKuzVVtU1JxcRgMUgZ7VQ46Vh7ViHdNLYL904t3hmRdMHXogWwHNmTRwYCfKA4g0f69OBTfmHVuLNqt7Hn+SCpmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733419034; c=relaxed/simple;
	bh=0A575wCl2HUBBGtTSEuDb6LYB5hQSlqPy3SmcA6eOoY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mTtmLHm9hEu/hjNN3pK1jjaHiBU6FUM19mCm5WtV5ejeX3dMpBGCw6dTr6XRxOmt+7JowVETqTJQQXZs9BFQ14H+Yh+bs2mxz8tHjGuXMOgJKlBoyd7/WcN6MhzPNbzMhRj0lcTPkLEF9AfFTKQnwm100HcaPfsICqXg+OM5oXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HEqDBoLX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HEqDBoLX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=j8ECil4+4JEDU4aiMhzhES+hIyRqOUIZJtv3yGATVfM=; b=HEqDBoLX7BaepvfUcxNhkx8IDe
	HGcB04oH8xQiuzzUwQMKt3ODg1IUtFp9zSyM5BPJZUKZKYFIVwjyDId7ypZpIT7z6jYFoBi6FtSZw
	zI4wC1DnAIi61E8VbKlfiC5NgtAC9z3mNb7tgXEZXe9xHLIE2QZrsWXtHIfXoTPMJ3dbxNVk73RaP
	eXwXk3Q3TVBGlchga+GziTEAGShroKvXZ1jk4JVFASxiakaNp2MW/LYigEhpsPRK6kv17hUsYBKlq
	7OkvuqXgE0/gaTAuRybPgkTl1TxrYarldwSn9LRDRb6BjNCqfflurdEy9C8JWuJrw/+kGmghQUyPr
	t24gJhvA==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tJFTF-0000000DLFk-15Y9;
	Thu, 05 Dec 2024 17:16:57 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ocfs2-devel@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH 00/23] Convert ocfs2 to use folios
Date: Thu,  5 Dec 2024 17:16:28 +0000
Message-ID: <20241205171653.3179945-1-willy@infradead.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mark did a conversion of ocfs2 to use folios and sent it to me as a
giant patch for review ;-)

So I've redone it as individual patches, and credited Mark for the patches
where his code is substantially the same.  It's not a bad way to do it;
his patch had some bugs and my patches had some bugs.  Hopefully all
our bugs were different from each other.  And hopefully Mark likes all
the changes I made to his code!

The first patch is really independent of the rest, but a later patch
depends on it, so I don't want to send it separately.

Mark Tinguely (17):
  ocfs2: Convert w_target_page to w_target_folio
  ocfs2: Use a folio in ocfs2_zero_new_buffers()
  ocfs2: Use a folio in ocfs2_write_begin_inline()
  ocfs2: Convert ocfs2_readpage_inline() to take a folio
  ocfs2: Convert ocfs2_inode_lock_with_page() to
    ocfs2_inode_lock_with_folio()
  ocfs2: Convert w_pages to w_folios
  ocfs2: Convert ocfs2_write_failure() to use a folio
  ocfs2: Use a folio in ocfs2_write_end_nolock()
  ocfs2: Use a folio in ocfs2_prepare_page_for_write()
  ocfs2: Use a folio in ocfs2_map_and_dirty_page()
  ocfs2: Convert ocfs2_map_page_blocks() to ocfs2_map_folio_blocks()
  ocfs2: Convert ocfs2_clear_page_regions() to
    ocfs2_clear_folio_regions()
  ocfs2: Use an array of folios instead of an array of pages
  ocfs2: Convert ocfs2_duplicate_clusters_by_page() to use a folio
  ocfs2: Convert ocfs2_map_and_dirty_page() to
    ocfs2_map_and_dirty_folio()
  ocfs2: Support large folios in ocfs2_zero_cluster_folios()
  ocfs2: Support large folios in ocfs2_write_zero_page()

Matthew Wilcox (Oracle) (6):
  ocfs2: Handle a symlink read error correctly
  ocfs2: Convert ocfs2_page_mkwrite() to use a folio
  ocfs2: Pass mmap_folio around instead of mmap_page
  ocfs2: Convert ocfs2_read_inline_data() to take a folio
  ocfs2: Use a folio in ocfs2_fast_symlink_read_folio()
  ocfs2: Remove ocfs2_start_walk_page_trans() prototype

 fs/ocfs2/alloc.c        | 132 ++++++++--------
 fs/ocfs2/alloc.h        |   8 +-
 fs/ocfs2/aops.c         | 335 +++++++++++++++++++---------------------
 fs/ocfs2/aops.h         |  17 +-
 fs/ocfs2/dlmglue.c      |  18 +--
 fs/ocfs2/dlmglue.h      |   6 +-
 fs/ocfs2/file.c         |   8 +-
 fs/ocfs2/mmap.c         |  18 +--
 fs/ocfs2/refcounttree.c |  35 ++---
 fs/ocfs2/symlink.c      |  16 +-
 10 files changed, 276 insertions(+), 317 deletions(-)

-- 
2.45.2


From: Jan Kara <jack@suse.cz>
Date: Tue, 24 Aug 2010 14:28:03 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix deadlock when allocating page
Message-ID: <1282652883-21019-1-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We cannot call grab_cache_page() when holding filesystem locks or with
a transaction started as grab_cache_page() calls page allocation with
GFP_KERNEL flag and thus page reclaim can recurse back into the filesystem
causing deadlocks or various assertion failures. We have to use
find_or_create_page() instead and pass it GFP_NOFS as we do with other
allocations.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/alloc.c        |    2 +-
 fs/ocfs2/file.c         |    2 +-
 fs/ocfs2/refcounttree.c |    5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 215e12c..592fae5 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6672,7 +6672,7 @@ int ocfs2_grab_pages(struct inode *inode, loff_t start, loff_t end,
 	last_page_bytes = PAGE_ALIGN(end);
 	index = start >> PAGE_CACHE_SHIFT;
 	do {
-		pages[numpages] = grab_cache_page(mapping, index);
+		pages[numpages] = find_or_create_page(mapping, index, GFP_NOFS);
 		if (!pages[numpages]) {
 			ret = -ENOMEM;
 			mlog_errno(ret);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 81296b4..b28cce8 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -774,7 +774,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 	BUG_ON(abs_to > (((u64)index + 1) << PAGE_CACHE_SHIFT));
 	BUG_ON(abs_from & (inode->i_blkbits - 1));
 
-	page = grab_cache_page(mapping, index);
+	page = find_or_create_page(mapping, index, GFP_NOFS);
 	if (!page) {
 		ret = -ENOMEM;
 		mlog_errno(ret);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 73a11cc..0afeda8 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2960,7 +2960,7 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 		if (map_end & (PAGE_CACHE_SIZE - 1))
 			to = map_end & (PAGE_CACHE_SIZE - 1);
 
-		page = grab_cache_page(mapping, page_index);
+		page = find_or_create_page(mapping, page_index, GFP_NOFS);
 
 		/*
 		 * In case PAGE_CACHE_SIZE <= CLUSTER_SIZE, This page
@@ -3179,7 +3179,8 @@ static int ocfs2_cow_sync_writeback(struct super_block *sb,
 		if (map_end > end)
 			map_end = end;
 
-		page = grab_cache_page(context->inode->i_mapping, page_index);
+		page = find_or_create_page(context->inode->i_mapping,
+					   page_index, GFP_NOFS);
 		BUG_ON(!page);
 
 		wait_on_page_writeback(page);
-- 
1.6.4.2

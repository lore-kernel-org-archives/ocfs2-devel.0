From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 29 Jun 2010 16:35:39 +0800
Subject: [Ocfs2-devel] [PATCH 2/4] ocfs2: Add readahead support for CoW.
In-Reply-To: <4C29AE6C.1050205@oracle.com>
References: <4C29AE6C.1050205@oracle.com>
Message-ID: <1277800541-6844-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add a new function ocfs2_readahead_for_cow so that
we start readahead before we start our CoW.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7636174..03ec6ac 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3392,6 +3392,28 @@ static int ocfs2_replace_cow(struct ocfs2_cow_context *context)
 	return ret;
 }
 
+static void ocfs2_readahead_for_cow(struct inode *inode,
+				    struct file *file,
+				    u32 start, u32 len)
+{
+	struct address_space *mapping;
+	pgoff_t index;
+	unsigned long num_pages;
+	int cs_bits = OCFS2_SB(inode->i_sb)->s_clustersize_bits;
+
+	if (!file)
+		return;
+
+	mapping = file->f_mapping;
+	num_pages = (len << cs_bits) >> PAGE_CACHE_SHIFT;
+	if (!num_pages)
+		num_pages = 1;
+
+	index = ((loff_t)start << cs_bits) >> PAGE_CACHE_SHIFT;
+	page_cache_sync_readahead(mapping, &file->f_ra, file,
+				  index, num_pages);
+}
+
 /*
  * Starting at cpos, try to CoW write_len clusters.  Don't CoW
  * past max_cpos.  This will stop when it runs into a hole or an
@@ -3427,6 +3449,8 @@ static int ocfs2_refcount_cow_hunk(struct inode *inode,
 
 	BUG_ON(cow_len == 0);
 
+	ocfs2_readahead_for_cow(inode, file, cow_start, cow_len);
+
 	context = kzalloc(sizeof(struct ocfs2_cow_context), GFP_NOFS);
 	if (!context) {
 		ret = -ENOMEM;
-- 
1.7.1.GIT

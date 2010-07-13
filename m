From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 13 Jul 2010 23:30:04 +0800
Subject: [Ocfs2-devel] [PATCH v4] ocfs2: Don't duplicate page passes i_size
	during CoW.
In-Reply-To: <1279032644-8050-1-git-send-email-tao.ma@oracle.com>
References: <1279032644-8050-1-git-send-email-tao.ma@oracle.com>
Message-ID: <1279035004-8280-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,
	I suddenly thought there is a bug in my previous patch.

In ppc where page size may be larger than cluster size, we may increase
'end' to an invalid page end which our current cow can't handle. So here
is the updated one.

Regards,
Tao

From fd6d19b09efa9d7305375132e0cfb6a8eec9108a Mon Sep 17 00:00:00 2001
From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 13 Jul 2010 22:51:01 +0800
Subject: [PATCH v4] ocfs2: Don't duplicate page passes i_size during CoW.

During CoW, actually all the pages after i_size contains
garbage data, so don't read and duplicate them.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 1cf9cda..4f07bb1 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -2931,6 +2931,13 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
 
 	offset = ((loff_t)cpos) << OCFS2_SB(sb)->s_clustersize_bits;
 	end = offset + (new_len << OCFS2_SB(sb)->s_clustersize_bits);
+	/*
+	 * We only duplicate pages until we reach the page contains i_size - 1.
+	 * So trim 'end' to the boundary of that page.
+	 */
+	if (end > i_size_read(context->inode))
+		end = min(end,
+			 (loff_t)PAGE_CACHE_ALIGN(i_size_read(context->inode)));
 
 	while (offset < end) {
 		page_index = offset >> PAGE_CACHE_SHIFT;
-- 
1.7.1.571.gba4d01

From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 16 Jul 2008 17:22:22 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Fix oops when racing files
	truncates with writes into an mmap region
Message-ID: <1216254142-28879-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch fixes an oops that is reproduced when one races writes to a mmap-ed
region with another process truncating the file.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/aops.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 17964c0..699144a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1066,12 +1066,15 @@ static void ocfs2_write_failure(struct inode *inode,
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
 
-		if (ocfs2_should_order_data(inode))
-			walk_page_buffers(wc->w_handle, page_buffers(tmppage),
-					  from, to, NULL,
-					  ocfs2_journal_dirty_data);
-
-		block_commit_write(tmppage, from, to);
+		if (page_has_buffers(tmppage)) {
+			if (ocfs2_should_order_data(inode))
+				walk_page_buffers(wc->w_handle,
+						  page_buffers(tmppage),
+						  from, to, NULL,
+						  ocfs2_journal_dirty_data);
+
+			block_commit_write(tmppage, from, to);
+		}
 	}
 }
 
@@ -1894,12 +1897,14 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 			to = PAGE_CACHE_SIZE;
 		}
 
-		if (ocfs2_should_order_data(inode))
-			walk_page_buffers(wc->w_handle, page_buffers(tmppage),
-					  from, to, NULL,
-					  ocfs2_journal_dirty_data);
-
-		block_commit_write(tmppage, from, to);
+		if (page_has_buffers(tmppage)) {
+			if (ocfs2_should_order_data(inode))
+				walk_page_buffers(wc->w_handle,
+						  page_buffers(tmppage),
+						  from, to, NULL,
+						  ocfs2_journal_dirty_data);
+			block_commit_write(tmppage, from, to);
+		}
 	}
 
 out_write_size:
-- 
1.5.4.3

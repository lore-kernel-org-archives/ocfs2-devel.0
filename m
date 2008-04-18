From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 18 Apr 2008 15:03:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Use GFP_NOFS in kmalloc during
	localalloc window move
Message-ID: <1208556239-15691-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

kmalloc() during a localalloc window move can trigger the mm to prune
the dcache which inturn can trigger the fs to delete an inode causing
it start a recursive transaction.

The fix also makes the change in kmalloc during localalloc shutdown
just to be safe.

Fixes oss bugzilla#901
http://oss.oracle.com/bugzilla/show_bug.cgi?id=901

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/localalloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index e187b3e..99492d9 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -260,7 +260,7 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	bh = osb->local_alloc_bh;
 	alloc = (struct ocfs2_dinode *) bh->b_data;
 
-	alloc_copy = kmalloc(bh->b_size, GFP_KERNEL);
+	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		goto out_commit;
@@ -935,7 +935,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	 * local alloc shutdown won't try to double free main bitmap
 	 * bits. Make a copy so the sync function knows which bits to
 	 * free. */
-	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_KERNEL);
+	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		mlog_errno(status);
-- 
1.5.3.6

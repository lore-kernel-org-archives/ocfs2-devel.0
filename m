From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Date: Sun, 10 Mar 2013 22:50:29 -0000
Subject: [Ocfs2-devel] [PATCH] fs: fs2fs: Replaced calls to kmalloc and
	memcpy with kmemdup
Message-ID: <1362829777-6924-1-git-send-email-gheorghiuandru@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Alexandru Gheorghiu <gheorghiuandru@gmail.com>

Replaced calls to kmalloc followd by memcpy with a single call to kmemdup.
This patch was found using coccicheck.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 fs/ocfs2/localalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index aebeacd..839183f 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -434,12 +434,11 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	bh = osb->local_alloc_bh;
 	alloc = (struct ocfs2_dinode *) bh->b_data;
 
-	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
+	alloc_copy = kmemdup(alloc, bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		goto out_commit;
 	}
-	memcpy(alloc_copy, alloc, bh->b_size);
 
 	status = ocfs2_journal_access_di(handle, INODE_CACHE(local_alloc_inode),
 					 bh, OCFS2_JOURNAL_ACCESS_WRITE);
@@ -1244,13 +1243,12 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	 * local alloc shutdown won't try to double free main bitmap
 	 * bits. Make a copy so the sync function knows which bits to
 	 * free. */
-	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
+	alloc_copy = kmemdup(alloc, osb->local_alloc_bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		mlog_errno(status);
 		goto bail;
 	}
-	memcpy(alloc_copy, alloc, osb->local_alloc_bh->b_size);
 
 	status = ocfs2_journal_access_di(handle,
 					 INODE_CACHE(local_alloc_inode),
-- 
1.7.9.5

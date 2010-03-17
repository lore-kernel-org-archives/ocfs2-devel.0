From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 16 Mar 2010 23:59:14 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: remove ocfs2_local_alloc_in_range()
In-Reply-To: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
Message-ID: <1268809154-1020-6-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Inodes are always allocated from the global bitmap now so we don't need this
any more. Also, the existing implementation bounces reservations around
needlessly.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/localalloc.c |   51 -------------------------------------------------
 fs/ocfs2/suballoc.c   |    6 +----
 2 files changed, 1 insertions(+), 56 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ebab3c0..6515ca7 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -484,46 +484,6 @@ out:
 	return status;
 }
 
-/* Check to see if the local alloc window is within ac->ac_max_block */
-static int ocfs2_local_alloc_in_range(struct inode *inode,
-				      struct ocfs2_alloc_context *ac,
-				      u32 bits_wanted)
-{
-	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
-	struct ocfs2_dinode *alloc;
-	struct ocfs2_local_alloc *la;
-	int start;
-	u64 block_off;
-
-	if (!ac->ac_max_block)
-		return 1;
-
-	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
-	la = OCFS2_LOCAL_ALLOC(alloc);
-
-	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, &bits_wanted, NULL);
-	if (start == -1) {
-		mlog_errno(-ENOSPC);
-		return 0;
-	}
-
-	/*
-	 * Converting (bm_off + start + bits_wanted) to blocks gives us
-	 * the blkno just past our actual allocation.  This is perfect
-	 * to compare with ac_max_block.
-	 */
-	block_off = ocfs2_clusters_to_blocks(inode->i_sb,
-					     le32_to_cpu(la->la_bm_off) +
-					     start + bits_wanted);
-	mlog(0, "Checking %llu against %llu\n",
-	     (unsigned long long)block_off,
-	     (unsigned long long)ac->ac_max_block);
-	if (block_off > ac->ac_max_block)
-		return 0;
-
-	return 1;
-}
-
 /*
  * make sure we've got at least bits_wanted contiguous bits in the
  * local alloc. You lose them when you drop i_mutex.
@@ -616,17 +576,6 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 		mlog(0, "Calling in_range for max block %llu\n",
 		     (unsigned long long)ac->ac_max_block);
 
-	if (!ocfs2_local_alloc_in_range(local_alloc_inode, ac,
-					bits_wanted)) {
-		/*
-		 * The window is outside ac->ac_max_block.
-		 * This errno tells the caller to keep localalloc enabled
-		 * but to get the allocation from the main bitmap.
-		 */
-		status = -EFBIG;
-		goto bail;
-	}
-
 	ac->ac_inode = local_alloc_inode;
 	/* We should never use localalloc from another slot */
 	ac->ac_alloc_slot = osb->slot_num;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 62c570c..0120a4b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -861,11 +861,7 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 		status = ocfs2_reserve_local_alloc_bits(osb,
 							bits_wanted,
 							*ac);
-		if (status == -EFBIG) {
-			/* The local alloc window is outside ac_max_block.
-			 * use the main bitmap. */
-			status = -ENOSPC;
-		} else if ((status < 0) && (status != -ENOSPC)) {
+		if ((status < 0) && (status != -ENOSPC)) {
 			mlog_errno(status);
 			goto bail;
 		}
-- 
1.6.4.2

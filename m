From: mfasheh at suse.com <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 15:15:16 -0700
Subject: [Ocfs2-devel] [PATCH 2/5] ocfs2: use
	ocfs2_alloc_dinode_update_counts() instead of open coding
In-Reply-To: <1281737719-27008-2-git-send-email-mfasheh@suse.com>
References: <1281737719-27008-1-git-send-email-mfasheh@suse.com>
	<1281737719-27008-2-git-send-email-mfasheh@suse.com>
Message-ID: <1281737719-27008-3-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Mark Fasheh <mfasheh@suse.com>

ocfs2_search_chain() makes the same updates as
ocfs2_alloc_dinode_update_counts to the alloc inode. Instead of open coding
the bitmap update, use our helper function.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/suballoc.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a8e6a95..75f43ed 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1708,7 +1708,6 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 {
 	int status;
 	u16 chain;
-	u32 tmp_used;
 	u64 next_group;
 	struct inode *alloc_inode = ac->ac_inode;
 	struct buffer_head *group_bh = NULL;
@@ -1796,22 +1795,14 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 		}
 	}
 
-	/* Ok, claim our bits now: set the info on dinode, chainlist
-	 * and then the group */
-	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(alloc_inode),
-					 ac->ac_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
+	status = ocfs2_alloc_dinode_update_counts(alloc_inode, handle,
+						  ac->ac_bh, res->sr_bits,
+						  chain);
+	if (status) {
 		mlog_errno(status);
 		goto bail;
 	}
 
-	tmp_used = le32_to_cpu(fe->id1.bitmap1.i_used);
-	fe->id1.bitmap1.i_used = cpu_to_le32(res->sr_bits + tmp_used);
-	le32_add_cpu(&cl->cl_recs[chain].c_free, -res->sr_bits);
-	ocfs2_journal_dirty(handle, ac->ac_bh);
-
 	status = ocfs2_block_group_set_bits(handle,
 					    alloc_inode,
 					    bg,
-- 
1.6.4.2

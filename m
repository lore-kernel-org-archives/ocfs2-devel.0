From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Mar 2009 13:01:05 -0700
Subject: [Ocfs2-devel] [PATCH 15/32] ocfs2: Allocate inode groups from
	global_bitmap.
In-Reply-To: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
References: <1237320082-12921-1-git-send-email-mfasheh@suse.com>
Message-ID: <1237320082-12921-16-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Tao Ma <tao.ma@oracle.com>

Inode groups used to be allocated from local alloc file,
but since we want all inodes to be contiguous enough, we
will try to allocate them directly from global_bitmap.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/suballoc.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 487f00c..b7a065e 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -48,7 +48,8 @@
 #include "buffer_head_io.h"
 
 #define NOT_ALLOC_NEW_GROUP		0
-#define ALLOC_NEW_GROUP			1
+#define ALLOC_NEW_GROUP			0x1
+#define ALLOC_GROUPS_FROM_GLOBAL	0x2
 
 #define OCFS2_MAX_INODES_TO_STEAL	1024
 
@@ -64,7 +65,8 @@ static int ocfs2_block_group_fill(handle_t *handle,
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
-				   u64 max_block);
+				   u64 max_block,
+				   int flags);
 
 static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
@@ -116,6 +118,7 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
 						u16 *bg_bit_off);
 static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 					     u32 bits_wanted, u64 max_block,
+					     int flags,
 					     struct ocfs2_alloc_context **ac);
 
 void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
@@ -403,7 +406,8 @@ static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
-				   u64 max_block)
+				   u64 max_block,
+				   int flags)
 {
 	int status, credits;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bh->b_data;
@@ -423,7 +427,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	cl = &fe->id2.i_chain;
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
-						   max_block, &ac);
+						   max_block, flags, &ac);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -531,7 +535,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				       struct ocfs2_alloc_context *ac,
 				       int type,
 				       u32 slot,
-				       int alloc_new_group)
+				       int flags)
 {
 	int status;
 	u32 bits_wanted = ac->ac_bits_wanted;
@@ -587,7 +591,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		if (alloc_new_group != ALLOC_NEW_GROUP) {
+		if (!(flags & ALLOC_NEW_GROUP)) {
 			mlog(0, "Alloc File %u Full: wanted=%u, free_bits=%u, "
 			     "and we don't alloc a new group for it.\n",
 			     slot, bits_wanted, free_bits);
@@ -596,7 +600,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 		}
 
 		status = ocfs2_block_group_alloc(osb, alloc_inode, bh,
-						 ac->ac_max_block);
+						 ac->ac_max_block, flags);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -740,7 +744,9 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 	atomic_set(&osb->s_num_inodes_stolen, 0);
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
-					     osb->slot_num, ALLOC_NEW_GROUP);
+					     osb->slot_num,
+					     ALLOC_NEW_GROUP |
+					     ALLOC_GROUPS_FROM_GLOBAL);
 	if (status >= 0) {
 		status = 0;
 
@@ -806,6 +812,7 @@ bail:
  * things a bit. */
 static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 					     u32 bits_wanted, u64 max_block,
+					     int flags,
 					     struct ocfs2_alloc_context **ac)
 {
 	int status;
@@ -823,7 +830,8 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 	(*ac)->ac_max_block = max_block;
 
 	status = -ENOSPC;
-	if (ocfs2_alloc_should_use_local(osb, bits_wanted)) {
+	if (!(flags & ALLOC_GROUPS_FROM_GLOBAL) &&
+	    ocfs2_alloc_should_use_local(osb, bits_wanted)) {
 		status = ocfs2_reserve_local_alloc_bits(osb,
 							bits_wanted,
 							*ac);
@@ -861,7 +869,8 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 			   u32 bits_wanted,
 			   struct ocfs2_alloc_context **ac)
 {
-	return ocfs2_reserve_clusters_with_limit(osb, bits_wanted, 0, ac);
+	return ocfs2_reserve_clusters_with_limit(osb, bits_wanted, 0,
+						 ALLOC_NEW_GROUP, ac);
 }
 
 /*
-- 
1.5.6

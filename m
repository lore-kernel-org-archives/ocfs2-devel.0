From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 28 Nov 2008 06:58:44 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Allocate inode groups from
	global_bitmap.
In-Reply-To: <492F946F.1060409@oracle.com>
References: <492F946F.1060409@oracle.com>
Message-ID: <1227826725-13107-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Inode groups used to be allocated from local alloc file, but since
we want all inodes to be contiguous enough, we will try to allocate
them directly from global_bitmap.

Add a new flag named "ALLOC_NEW_GROUP_FROM_GLOBAL", if we pass this
flag into allocation, don't try local alloc.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f75782f..98e32b2 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -47,7 +47,8 @@
 #include "buffer_head_io.h"
 
 #define NOT_ALLOC_NEW_GROUP		0
-#define ALLOC_NEW_GROUP			1
+#define ALLOC_NEW_GROUP			0x1
+#define ALLOC_NEW_GROUP_FROM_GLOBAL	0x2
 
 #define OCFS2_MAX_INODES_TO_STEAL	1024
 
@@ -63,7 +64,8 @@ static int ocfs2_block_group_fill(handle_t *handle,
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
-				   u64 max_block);
+				   u64 max_block,
+				   int flags);
 
 static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
@@ -115,7 +117,8 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
 						u16 *bg_bit_off);
 static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 					     u32 bits_wanted, u64 max_block,
-					     struct ocfs2_alloc_context **ac);
+					     struct ocfs2_alloc_context **ac,
+					     int flags);
 
 void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 {
@@ -370,7 +373,8 @@ static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
 				   struct buffer_head *bh,
-				   u64 max_block)
+				   u64 max_block,
+				   int flags)
 {
 	int status, credits;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bh->b_data;
@@ -390,7 +394,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	cl = &fe->id2.i_chain;
 	status = ocfs2_reserve_clusters_with_limit(osb,
 						   le16_to_cpu(cl->cl_cpg),
-						   max_block, &ac);
+						   max_block, &ac, flags);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -498,7 +502,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				       struct ocfs2_alloc_context *ac,
 				       int type,
 				       u32 slot,
-				       int alloc_new_group)
+				       int flags)
 {
 	int status;
 	u32 bits_wanted = ac->ac_bits_wanted;
@@ -554,7 +558,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		if (alloc_new_group != ALLOC_NEW_GROUP) {
+		if (!(flags & ALLOC_NEW_GROUP)) {
 			mlog(0, "Alloc File %u Full: wanted=%u, free_bits=%u, "
 			     "and we don't alloc a new group for it.\n",
 			     slot, bits_wanted, free_bits);
@@ -563,7 +567,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 		}
 
 		status = ocfs2_block_group_alloc(osb, alloc_inode, bh,
-						 ac->ac_max_block);
+						 ac->ac_max_block, flags);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -707,7 +711,9 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 	atomic_set(&osb->s_num_inodes_stolen, 0);
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
-					     osb->slot_num, ALLOC_NEW_GROUP);
+					     osb->slot_num,
+					     ALLOC_NEW_GROUP |
+					     ALLOC_NEW_GROUP_FROM_GLOBAL);
 	if (status >= 0) {
 		status = 0;
 
@@ -773,7 +779,8 @@ bail:
  * things a bit. */
 static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 					     u32 bits_wanted, u64 max_block,
-					     struct ocfs2_alloc_context **ac)
+					     struct ocfs2_alloc_context **ac,
+					     int flags)
 {
 	int status;
 
@@ -790,7 +797,8 @@ static int ocfs2_reserve_clusters_with_limit(struct ocfs2_super *osb,
 	(*ac)->ac_max_block = max_block;
 
 	status = -ENOSPC;
-	if (ocfs2_alloc_should_use_local(osb, bits_wanted)) {
+	if (!(flags & ALLOC_NEW_GROUP_FROM_GLOBAL) &&
+	    ocfs2_alloc_should_use_local(osb, bits_wanted)) {
 		status = ocfs2_reserve_local_alloc_bits(osb,
 							bits_wanted,
 							*ac);
@@ -828,7 +836,8 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 			   u32 bits_wanted,
 			   struct ocfs2_alloc_context **ac)
 {
-	return ocfs2_reserve_clusters_with_limit(osb, bits_wanted, 0, ac);
+	return ocfs2_reserve_clusters_with_limit(osb, bits_wanted, 0, ac,
+						 ALLOC_NEW_GROUP);
 }
 
 /*
-- 
1.5.4.GIT

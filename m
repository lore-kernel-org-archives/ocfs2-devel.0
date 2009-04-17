From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:24 -0700
Subject: [Ocfs2-devel] [PATCH 11/26] ocfs2: Allocate inode groups from
	global_bitmap.
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-12-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

Mainline commit 60ca81e82dae4aa2e8ae84cf96b4d08535931669

Inode groups used to be allocated from local alloc file,
but since we want all inodes to be contiguous enough, we
will try to allocate them directly from global_bitmap.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0f1f2e9..13e7b88 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -47,7 +47,8 @@
 #include "buffer_head_io.h"
 
 #define NOT_ALLOC_NEW_GROUP		0
-#define ALLOC_NEW_GROUP			1
+#define ALLOC_NEW_GROUP			0x1
+#define ALLOC_GROUPS_FROM_GLOBAL	0x2
 
 #define OCFS2_MAX_INODES_TO_STEAL	1024
 
@@ -62,7 +63,8 @@ static int ocfs2_block_group_fill(handle_t *handle,
 				  struct ocfs2_chain_list *cl);
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
-				   struct buffer_head *bh);
+				   struct buffer_head *bh,
+				   int flags);
 
 static int ocfs2_cluster_group_search(struct inode *inode,
 				      struct buffer_head *group_bh,
@@ -110,6 +112,10 @@ static inline void ocfs2_block_to_cluster_group(struct inode *inode,
 						u64 data_blkno,
 						u64 *bg_blkno,
 						u16 *bg_bit_off);
+static int __ocfs2_reserve_clusters(struct ocfs2_super *osb,
+				    u32 bits_wanted,
+				    struct ocfs2_alloc_context **ac,
+				    int flags);
 
 void ocfs2_free_ac_resource(struct ocfs2_alloc_context *ac)
 {
@@ -274,7 +280,8 @@ static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
  */
 static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 				   struct inode *alloc_inode,
-				   struct buffer_head *bh)
+				   struct buffer_head *bh,
+				   int flags)
 {
 	int status, credits;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) bh->b_data;
@@ -292,9 +299,9 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 	mlog_entry_void();
 
 	cl = &fe->id2.i_chain;
-	status = ocfs2_reserve_clusters(osb,
-					le16_to_cpu(cl->cl_cpg),
-					&ac);
+	status = __ocfs2_reserve_clusters(osb,
+					  le16_to_cpu(cl->cl_cpg),
+					  &ac, flags);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -402,7 +409,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				       struct ocfs2_alloc_context *ac,
 				       int type,
 				       u32 slot,
-				       int alloc_new_group)
+				       int flags)
 {
 	int status;
 	u32 bits_wanted = ac->ac_bits_wanted;
@@ -458,7 +465,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		if (alloc_new_group != ALLOC_NEW_GROUP) {
+		if (!(flags & ALLOC_NEW_GROUP)) {
 			mlog(0, "Alloc File %u Full: wanted=%u, free_bits=%u, "
 			     "and we don't alloc a new group for it.\n",
 			     slot, bits_wanted, free_bits);
@@ -466,7 +473,7 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 			goto bail;
 		}
 
-		status = ocfs2_block_group_alloc(osb, alloc_inode, bh);
+		status = ocfs2_block_group_alloc(osb, alloc_inode, bh, flags);
 		if (status < 0) {
 			if (status != -ENOSPC)
 				mlog_errno(status);
@@ -593,7 +600,9 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 	atomic_set(&osb->s_num_inodes_stolen, 0);
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
-					     osb->slot_num, ALLOC_NEW_GROUP);
+					     osb->slot_num,
+					     ALLOC_NEW_GROUP |
+					     ALLOC_GROUPS_FROM_GLOBAL);
 	if (status >= 0) {
 		status = 0;
 
@@ -661,6 +670,14 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 			   u32 bits_wanted,
 			   struct ocfs2_alloc_context **ac)
 {
+	return __ocfs2_reserve_clusters(osb, bits_wanted, ac, 0);
+}
+
+static int __ocfs2_reserve_clusters(struct ocfs2_super *osb,
+				    u32 bits_wanted,
+				    struct ocfs2_alloc_context **ac,
+				    int flags)
+{
 	int status;
 
 	mlog_entry_void();
@@ -675,7 +692,8 @@ int ocfs2_reserve_clusters(struct ocfs2_super *osb,
 	(*ac)->ac_bits_wanted = bits_wanted;
 
 	status = -ENOSPC;
-	if (ocfs2_alloc_should_use_local(osb, bits_wanted)) {
+	if (!(flags & ALLOC_GROUPS_FROM_GLOBAL) &&
+	    ocfs2_alloc_should_use_local(osb, bits_wanted)) {
 		status = ocfs2_reserve_local_alloc_bits(osb,
 							bits_wanted,
 							*ac);
-- 
1.5.6.3

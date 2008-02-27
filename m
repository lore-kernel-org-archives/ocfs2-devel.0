From: Tao Ma <tao.ma@oracle.com>
Date: Wed Feb 27 22:59:10 2008
Subject: [Ocfs2-devel] [PATCH 1/3] Add a new parameter for
	ocfs2_reserve_suballoc_bits.V2
In-Reply-To: <20080228063438.GA27318@tma-pc1.cn.oracle.com>
Message-ID: <20080228065904.GA29259@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In some cases(Inode stealing from other nodes), we may not want
ocfs2_reserve_suballoc_bits to allocate new groups from the
global_bitmap since it may already be full. So add a new parameter
for this.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 72c198a..3be4e73 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -46,6 +46,9 @@
 
 #include "buffer_head_io.h"
 
+#define NOT_ALLOC_NEW_GROUP		0
+#define ALLOC_NEW_GROUP			1
+
 static inline void ocfs2_debug_bg(struct ocfs2_group_desc *bg);
 static inline void ocfs2_debug_suballoc_inode(struct ocfs2_dinode *fe);
 static inline u16 ocfs2_find_victim_chain(struct ocfs2_chain_list *cl);
@@ -391,7 +394,8 @@ bail:
 static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 				       struct ocfs2_alloc_context *ac,
 				       int type,
-				       u32 slot)
+				       u32 slot,
+				       int alloc_new_group)
 {
 	int status;
 	u32 bits_wanted = ac->ac_bits_wanted;
@@ -446,6 +450,14 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 			goto bail;
 		}
 
+		if (alloc_new_group != ALLOC_NEW_GROUP) {
+			mlog(0, "Alloc File %u Full: wanted=%u, free_bits=%u, "
+			     "and we don't alloc a new group for it.\n",
+			     slot, bits_wanted, free_bits);
+			status = -ENOSPC;
+			goto bail;
+		}
+
 		status = ocfs2_block_group_alloc(osb, alloc_inode, bh);
 		if (status < 0) {
 			if (status != -ENOSPC)
@@ -490,7 +502,8 @@ int ocfs2_reserve_new_metadata(struct ocfs2_super *osb,
 	(*ac)->ac_group_search = ocfs2_block_group_search;
 
 	status = ocfs2_reserve_suballoc_bits(osb, (*ac),
-					     EXTENT_ALLOC_SYSTEM_INODE, slot);
+					     EXTENT_ALLOC_SYSTEM_INODE,
+					     slot, ALLOC_NEW_GROUP);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -527,7 +540,7 @@ int ocfs2_reserve_new_inode(struct ocfs2_super *osb,
 
 	status = ocfs2_reserve_suballoc_bits(osb, *ac,
 					     INODE_ALLOC_SYSTEM_INODE,
-					     osb->slot_num);
+					     osb->slot_num, ALLOC_NEW_GROUP);
 	if (status < 0) {
 		if (status != -ENOSPC)
 			mlog_errno(status);
@@ -557,7 +570,8 @@ int ocfs2_reserve_cluster_bitmap_bits(struct ocfs2_super *osb,
 
 	status = ocfs2_reserve_suballoc_bits(osb, ac,
 					     GLOBAL_BITMAP_SYSTEM_INODE,
-					     OCFS2_INVALID_SLOT);
+					     OCFS2_INVALID_SLOT,
+					     ALLOC_NEW_GROUP);
 	if (status < 0 && status != -ENOSPC) {
 		mlog_errno(status);
 		goto bail;
-- 
1.5.3.GIT

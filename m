From: Mark Fasheh <mfasheh@suse.com>
Date: Wed,  2 Apr 2008 13:15:04 -0700
Subject: [Ocfs2-devel] [PATCH 54/62] ocfs2: Add a new parameter for
	ocfs2_reserve_suballoc_bits
In-Reply-To: <12071674291040-git-send-email-mfasheh@suse.com>
References: <12071673121124-git-send-email-mfasheh@suse.com>
	<1207167318479-git-send-email-mfasheh@suse.com>
	<12071673203909-git-send-email-mfasheh@suse.com>
	<12071673232465-git-send-email-mfasheh@suse.com>
	<12071673263948-git-send-email-mfasheh@suse.com>
	<12071673282579-git-send-email-mfasheh@suse.com>
	<1207167330482-git-send-email-mfasheh@suse.com>
	<12071673321172-git-send-email-mfasheh@suse.com>
	<12071673341888-git-send-email-mfasheh@suse.com>
	<12071673362069-git-send-email-mfasheh@suse.com>
	<12071673391031-git-send-email-mfasheh@suse.com>
	<12071673413492-git-send-email-mfasheh@suse.com>
	<1207167343926-git-send-email-mfasheh@suse.com>
	<12071673461268-git-send-email-mfasheh@suse.com>
	<12071673481928-git-send-email-mfasheh@suse.com>
	<12071673492775-git-send-email-mfasheh@suse.com>
	<12071673511262-git-send-email-mfasheh@suse.com>
	<12071673543752-git-send-email-mfasheh@suse.com>
	<1207167355295-git-send-email-mfasheh@suse.com>
	<12071673571757-git-send-email-mfasheh@suse.com>
	<12071673591158-git-send-email-mfasheh@suse.com>
	<12071673613757-git-send-email-mfasheh@suse.com>
	<1207167363119-git-send-email-mfasheh@suse.com>
	<12071673661674-git-send-email-mfasheh@suse.com>
	<12071673681650-git-send-email-mfasheh@suse.com>
	<12071673701937-git-send-email-mfasheh@suse.com>
	<12071673722691-git-send-email-mfasheh@suse.com>
	<12071673731276-git-send-email-mfasheh@suse.com>
	<12071673753788-git-send-email-mfasheh@suse.com>
	<12071673772233-git-send-email-mfasheh@suse.com>
	<1207167379283-git-send-email-mfasheh@suse.com>
	<12071673821008-git-send-email-mfasheh@suse.com>
	<12071673843208-git-send-email-mfasheh@suse.com>
	<12071673872568-git-send-email-mfasheh@suse.com>
	<12071673882492-git-send-email-mfasheh@suse.com>
	<1207167390414-git-send-email-mfasheh@suse.com>
	<1207167392537-git-send-email-mfasheh@suse.com>
	<12071673941659-git-send-email-mfasheh@suse.com>
	<12071673964014-git-send-email-mfasheh@suse.com>
	<1207167398684-git-send-email-mfasheh@suse.com>
	<12071674013954-git-send-email-mfasheh@suse.com>
	<12071674033903-git-send-email-mfasheh@suse.com>
	<12071674061934-git-send-email-mfasheh@suse.com>
	<12071674083120-git-send-email-mfasheh@suse.com>
	<12071674103432-git-send-email-mfasheh@suse.com>
	<1207167413855-git-send-email-mfasheh@suse.com>
	<12071674151752-git-send-email-mfasheh@suse.com>
	<12071674171596-git-send-email-mfasheh@suse.com>
	<12071674193441-git-send-email-mfasheh@suse.com>
	<12071674213882-git-send-email-mfasheh@suse.com>
	<12071674242631-git-send-email-mfasheh@suse.com>
	<1207167425415-git-send-email-mfasheh@suse.com>
	<1207167427753-git-send-email-mfasheh@suse.com>
	<12071674291040-git-send-email-mfasheh@suse.com>
Message-ID: <12071674312495-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Tao Ma <tao.ma@oracle.com>

From: Tao Ma <tao.ma@oracle.com>

In some cases(Inode stealing from other nodes), we may not want
ocfs2_reserve_suballoc_bits to allocate new groups from the
global_bitmap since it may already be full. So add a new parameter
for this.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
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
1.5.4.1

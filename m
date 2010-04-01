From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  1 Apr 2010 10:59:10 +0800
Subject: [Ocfs2-devel] [PATCH 13/15] ocfs2: ocfs2_group_bitmap_size has to
	handle old volume.
In-Reply-To: <4BB40AB4.8040205@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
Message-ID: <1270090752-18935-13-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_group_bitmap_size has to handle the case when the
volume don't have discontiguous block group support.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    5 +++--
 fs/ocfs2/resize.c   |    4 ++--
 fs/ocfs2/suballoc.c |    3 ++-
 fs/ocfs2/super.c    |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 42641f8..29f32ad 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -1346,11 +1346,12 @@ static inline u16 ocfs2_local_alloc_size(struct super_block *sb)
 }
 
 static inline int ocfs2_group_bitmap_size(struct super_block *sb,
-					  int suballocator)
+					  int suballocator,
+					  int support_discontig_bg)
 {
 	int size;
 
-	if (suballocator)
+	if (suballocator && support_discontig_bg)
 		size = OCFS2_MAX_BG_BITMAP_SIZE;
 	else
 		size = sb->s_blocksize -
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 0ff4835..e6eca60 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -319,7 +319,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
+				 ocfs2_group_bitmap_size(osb->sb, 0, 0) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small. "
 		     "Force to do offline resize.");
 		ret = -EINVAL;
@@ -500,7 +500,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
 
 	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
-				 ocfs2_group_bitmap_size(osb->sb, 0) * 8) {
+				 ocfs2_group_bitmap_size(osb->sb, 0, 0) * 8) {
 		mlog(ML_ERROR, "The disk is too old and small."
 		     " Force to do offline resize.");
 		ret = -EINVAL;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 0878b5d..0bf6151 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -394,7 +394,8 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	memset(bg, 0, sb->s_blocksize);
 	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
 	bg->bg_generation = cpu_to_le32(OCFS2_SB(sb)->fs_generation);
-	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1));
+	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1,
+				  ocfs2_supports_discontig_bg(osb)));
 	bg->bg_chain = cpu_to_le16(my_chain);
 	bg->bg_next_group = cl->cl_recs[my_chain].c_blkno;
 	bg->bg_parent_dinode = cpu_to_le64(OCFS2_I(alloc_inode)->ip_blkno);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index de8547f..b6171df 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2226,7 +2226,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	osb->bitmap_blkno = OCFS2_I(inode)->ip_blkno;
 	iput(inode);
 
-	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb, 0) * 8;
+	osb->bitmap_cpg = ocfs2_group_bitmap_size(sb, 0, 0) * 8;
 
 	status = ocfs2_init_slot_info(osb);
 	if (status < 0) {
-- 
1.5.5

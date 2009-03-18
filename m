From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 19 Mar 2009 05:08:43 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix 2 warning during ocfs2 make.
Message-ID: <1237410523-8639-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

fs/ocfs2/dir.c: In function ?ocfs2_extend_dir?:
fs/ocfs2/dir.c:2700: warning: ?ret? may be used uninitialized in this function

fs/ocfs2/suballoc.c: In function ?ocfs2_get_suballoc_slot_bit?:
fs/ocfs2/suballoc.c:2216: warning: comparison is always true due to limited range of data type

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/dir.c      |    2 +-
 fs/ocfs2/suballoc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index e71160c..eeac241 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2697,7 +2697,7 @@ static int ocfs2_dx_dir_index_block(struct inode *dir,
 				    u32 *num_dx_entries,
 				    struct buffer_head *dirent_bh)
 {
-	int ret, namelen, i;
+	int ret = 0, namelen, i;
 	char *de_buf, *limit;
 	struct ocfs2_dir_entry *de;
 	struct buffer_head *dx_leaf_bh;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index b4ca591..eb21dbb 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2213,7 +2213,7 @@ static int ocfs2_get_suballoc_slot_bit(struct ocfs2_super *osb, u64 blkno,
 		goto bail;
 	}
 
-	if (le16_to_cpu(inode_fe->i_suballoc_slot) != OCFS2_INVALID_SLOT &&
+	if (le16_to_cpu(inode_fe->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
 	    (u32)le16_to_cpu(inode_fe->i_suballoc_slot) > osb->max_slots - 1) {
 		mlog(ML_ERROR, "inode %llu has invalid suballoc slot %u\n",
 		     blkno, (u32)le16_to_cpu(inode_fe->i_suballoc_slot));
-- 
1.6.2.rc2.16.gf474c

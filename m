From: Joel Becker <joel.becker@oracle.com>
Date: Wed Mar 28 18:50:59 2007
Subject: [Ocfs2-devel] [PATCH 1/3] ocfs2: Wrap access of directory
	allocations with ip_alloc_sem.
References: <20070329005041.518030000@oracle.com>
Message-ID: <20070329005717.511050000@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2_I(inode)->ip_alloc_sem is a read-write semaphore protecting
local concurrent access of ocfs2 inodes.  However, ocfs2 directories were
not taking the semaphore while they accessed or modified the allocation
tree.

ocfs2_extend_dir() needs to take the semaphore in a write mode when it
adds to the allocation.  All other directory users get there via
ocfs2_bread(), which takes the semaphore in read mode.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c   |    7 ++++++-
 fs/ocfs2/inode.c |    2 ++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 66821e1..fd41f8b 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -402,7 +402,7 @@ static int ocfs2_extend_dir(struct ocfs2
 			    struct buffer_head **new_de_bh)
 {
 	int status = 0;
-	int credits, num_free_extents;
+	int credits, num_free_extents, drop_alloc_sem = 0;
 	loff_t dir_i_size;
 	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) parent_fe_bh->b_data;
 	struct ocfs2_alloc_context *data_ac = NULL;
@@ -451,6 +451,9 @@ static int ocfs2_extend_dir(struct ocfs2
 		credits = OCFS2_SIMPLE_DIR_EXTEND_CREDITS;
 	}
 
+	down_write(&OCFS2_I(dir)->ip_alloc_sem);
+	drop_alloc_sem = 1;
+
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		status = PTR_ERR(handle);
@@ -496,6 +499,8 @@ static int ocfs2_extend_dir(struct ocfs2
 	*new_de_bh = new_bh;
 	get_bh(*new_de_bh);
 bail:
+	if (drop_alloc_sem)
+		up_write(&OCFS2_I(dir)->ip_alloc_sem);
 	if (handle)
 		ocfs2_commit_trans(osb, handle);
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 28ab56f..480d90f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1121,8 +1121,10 @@ struct buffer_head *ocfs2_bread(struct i
 		return NULL;
 	}
 
+	down_read(&OCFS2_I(inode)->ip_alloc_sem);
 	tmperr = ocfs2_extent_map_get_blocks(inode, block, 1,
 					     &p_blkno, NULL);
+	up_read(&OCFS2_I(inode)->ip_alloc_sem);
 	if (tmperr < 0) {
 		mlog_errno(tmperr);
 		goto fail;
-- 
1.4.2.3

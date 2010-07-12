From: Joe Perches <joe@perches.com>
Date: Mon, 12 Jul 2010 13:50:19 -0700
Subject: [Ocfs2-devel] [PATCH 27/36] fs/ocfs2: Remove unnecessary casts of
	private_data
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Message-ID: <c75b92bbfb63964703ae99733f39696af4550f07.1278967121.git.joe@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/dlm/dlmdebug.c |    6 +++---
 fs/ocfs2/dlmfs/dlmfs.c  |    3 +--
 fs/ocfs2/dlmglue.c      |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 0cd24cf..5efdd37 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -419,7 +419,7 @@ static loff_t debug_buffer_llseek(struct file *file, loff_t off, int whence)
 
 static int debug_buffer_release(struct inode *inode, struct file *file)
 {
-	struct debug_buffer *db = (struct debug_buffer *)file->private_data;
+	struct debug_buffer *db = file->private_data;
 
 	if (db)
 		kfree(db->buf);
@@ -715,7 +715,7 @@ static int debug_lockres_open(struct inode *inode, struct file *file)
 		goto bail;
 	}
 
-	seq = (struct seq_file *) file->private_data;
+	seq = file->private_data;
 	seq->private = dl;
 
 	dlm_grab(dlm);
@@ -731,7 +731,7 @@ bail:
 
 static int debug_lockres_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq = (struct seq_file *)file->private_data;
+	struct seq_file *seq = file->private_data;
 	struct debug_lockres *dl = (struct debug_lockres *)seq->private;
 
 	if (dl->dl_res)
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index a43ebb1..c2903b8 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -182,8 +182,7 @@ static int dlmfs_file_release(struct inode *inode,
 {
 	int level, status;
 	struct dlmfs_inode_private *ip = DLMFS_I(inode);
-	struct dlmfs_filp_private *fp =
-		(struct dlmfs_filp_private *) file->private_data;
+	struct dlmfs_filp_private *fp = file->private_data;
 
 	if (S_ISDIR(inode->i_mode))
 		BUG();
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 39eb16a..5e02a89 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2966,7 +2966,7 @@ static const struct seq_operations ocfs2_dlm_seq_ops = {
 
 static int ocfs2_dlm_debug_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq = (struct seq_file *) file->private_data;
+	struct seq_file *seq = file->private_data;
 	struct ocfs2_dlm_seq_priv *priv = seq->private;
 	struct ocfs2_lock_res *res = &priv->p_iter_res;
 
@@ -3000,7 +3000,7 @@ static int ocfs2_dlm_debug_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	seq = (struct seq_file *) file->private_data;
+	seq = file->private_data;
 	seq->private = priv;
 
 	ocfs2_add_lockres_tracking(&priv->p_iter_res,
-- 
1.7.1.337.g6068.dirty

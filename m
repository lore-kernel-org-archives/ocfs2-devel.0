From: Rob Jones <rob.jones@codethink.co.uk>
Date: Wed, 10 Sep 2014 15:49:18 +0100
Subject: [Ocfs2-devel] [PATCH 3/3] fs: ocfs2: Use __seq_open_private() not
	seq_open()
In-Reply-To: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
References: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
Message-ID: <1410360558-28399-4-git-send-email-rob.jones@codethink.co.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, dan.carpenter@oracle.com, akpm@linux-foundation.org, jlbec@evilplan.org, mfasheh@suse.com, linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk

Reduce boilerplate code by using seq_open_private() instead of seq_open()

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 fs/ocfs2/dlmglue.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 6bd690b..503184d 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2897,37 +2897,24 @@ static int ocfs2_dlm_debug_release(struct inode *inode, struct file *file)
 
 static int ocfs2_dlm_debug_open(struct inode *inode, struct file *file)
 {
-	int ret;
 	struct ocfs2_dlm_seq_priv *priv;
-	struct seq_file *seq;
 	struct ocfs2_super *osb;
 
-	priv = kzalloc(sizeof(struct ocfs2_dlm_seq_priv), GFP_KERNEL);
+	priv = __seq_open_private(file, &ocfs2_dlm_seq_ops, sizeof(*priv));
 	if (!priv) {
-		ret = -ENOMEM;
-		mlog_errno(ret);
-		goto out;
+		mlog_errno(-ENOMEM);
+		return -ENOMEM;
 	}
+
 	osb = inode->i_private;
 	ocfs2_get_dlm_debug(osb->osb_dlm_debug);
 	priv->p_dlm_debug = osb->osb_dlm_debug;
 	INIT_LIST_HEAD(&priv->p_iter_res.l_debug_list);
 
-	ret = seq_open(file, &ocfs2_dlm_seq_ops);
-	if (ret) {
-		kfree(priv);
-		mlog_errno(ret);
-		goto out;
-	}
-
-	seq = file->private_data;
-	seq->private = priv;
-
 	ocfs2_add_lockres_tracking(&priv->p_iter_res,
 				   priv->p_dlm_debug);
 
-out:
-	return ret;
+	return 0;
 }
 
 static const struct file_operations ocfs2_dlm_debug_fops = {
-- 
1.7.10.4

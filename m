From: Rob Jones <rob.jones@codethink.co.uk>
Date: Wed, 10 Sep 2014 15:49:17 +0100
Subject: [Ocfs2-devel] [PATCH 2/3] fs: ocfs2: use seq_open_private() not
	seq_open()
In-Reply-To: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
References: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
Message-ID: <1410360558-28399-3-git-send-email-rob.jones@codethink.co.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, dan.carpenter@oracle.com, akpm@linux-foundation.org, jlbec@evilplan.org, mfasheh@suse.com, linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk

Reduce boilerplate code by using seq_open_private() instead of seq_open()

Note that the code in and using sc_common_open() has been quite
extensively changed. Not least because there was a latent memory
leak in the code as was: if sc_common_open() failed, the previously
allocated buffer was not freed.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 fs/ocfs2/cluster/netdebug.c |   78 +++++++++++--------------------------------
 1 file changed, 19 insertions(+), 59 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 73ba819..27d1242 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -185,29 +185,13 @@ static const struct seq_operations nst_seq_ops = {
 static int nst_fop_open(struct inode *inode, struct file *file)
 {
 	struct o2net_send_tracking *dummy_nst;
-	struct seq_file *seq;
-	int ret;
 
-	dummy_nst = kmalloc(sizeof(struct o2net_send_tracking), GFP_KERNEL);
-	if (dummy_nst == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	dummy_nst->st_task = NULL;
-
-	ret = seq_open(file, &nst_seq_ops);
-	if (ret)
-		goto out;
-
-	seq = file->private_data;
-	seq->private = dummy_nst;
+	dummy_nst = __seq_open_private(file, &nst_seq_ops, sizeof(*dummy_nst));
+	if (!dummy_nst)
+		return -ENOMEM;
 	o2net_debug_add_nst(dummy_nst);
 
-	dummy_nst = NULL;
-
-out:
-	kfree(dummy_nst);
-	return ret;
+	return 0;
 }
 
 static int nst_fop_release(struct inode *inode, struct file *file)
@@ -412,33 +396,27 @@ static const struct seq_operations sc_seq_ops = {
 	.show = sc_seq_show,
 };
 
-static int sc_common_open(struct file *file, struct o2net_sock_debug *sd)
+static int sc_common_open(struct file *file, int ctxt)
 {
+	struct o2net_sock_debug *sd;
 	struct o2net_sock_container *dummy_sc;
-	struct seq_file *seq;
-	int ret;
 
-	dummy_sc = kmalloc(sizeof(struct o2net_sock_container), GFP_KERNEL);
-	if (dummy_sc == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	dummy_sc->sc_page = NULL;
+	dummy_sc = kzalloc(sizeof(*dummy_sc), GFP_KERNEL);
+	if (!dummy_sc)
+		return -ENOMEM;
 
-	ret = seq_open(file, &sc_seq_ops);
-	if (ret)
-		goto out;
+	sd = __seq_open_private(file, &sc_seq_ops, sizeof(*sd));
+	if (!sd) {
+		kfree(dummy_sc);
+		return -ENOMEM;
+	}
 
-	seq = file->private_data;
-	seq->private = sd;
+	sd->dbg_ctxt = ctxt;
 	sd->dbg_sock = dummy_sc;
-	o2net_debug_add_sc(dummy_sc);
 
-	dummy_sc = NULL;
+	o2net_debug_add_sc(dummy_sc);
 
-out:
-	kfree(dummy_sc);
-	return ret;
+	return 0;
 }
 
 static int sc_fop_release(struct inode *inode, struct file *file)
@@ -453,16 +431,7 @@ static int sc_fop_release(struct inode *inode, struct file *file)
 
 static int stats_fop_open(struct inode *inode, struct file *file)
 {
-	struct o2net_sock_debug *sd;
-
-	sd = kmalloc(sizeof(struct o2net_sock_debug), GFP_KERNEL);
-	if (sd == NULL)
-		return -ENOMEM;
-
-	sd->dbg_ctxt = SHOW_SOCK_STATS;
-	sd->dbg_sock = NULL;
-
-	return sc_common_open(file, sd);
+	return sc_common_open(file, SHOW_SOCK_STATS);
 }
 
 static const struct file_operations stats_seq_fops = {
@@ -474,16 +443,7 @@ static const struct file_operations stats_seq_fops = {
 
 static int sc_fop_open(struct inode *inode, struct file *file)
 {
-	struct o2net_sock_debug *sd;
-
-	sd = kmalloc(sizeof(struct o2net_sock_debug), GFP_KERNEL);
-	if (sd == NULL)
-		return -ENOMEM;
-
-	sd->dbg_ctxt = SHOW_SOCK_CONTAINERS;
-	sd->dbg_sock = NULL;
-
-	return sc_common_open(file, sd);
+	return sc_common_open(file, SHOW_SOCK_CONTAINERS);
 }
 
 static const struct file_operations sc_seq_fops = {
-- 
1.7.10.4

From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 2 May 2008 11:35:10 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 fixes
Message-ID: <20080502183510.GE15434@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Some fixes/cleanups that I pulled into ocfs2.git after we sent our feature merge.
The /sys/o2cb fix in particular has been asked about a couple times.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/cluster/sys.c  |    2 +-
 fs/ocfs2/dlm/dlmdebug.c |    8 +++++---
 fs/ocfs2/file.c         |    4 ++++
 fs/ocfs2/localalloc.c   |    4 ++--
 fs/ocfs2/stack_o2cb.c   |    2 +-
 fs/ocfs2/stack_user.c   |    2 +-
 fs/ocfs2/symlink.c      |    2 ++
 7 files changed, 16 insertions(+), 8 deletions(-)

Adrian Bunk (3):
      ocfs2: make struct ocfs2_control_device static
      ocfs2: make struct o2cb_stack_ops static
      ocfs2/dlm: dlmdebug.c: make 2 functions static

Joel Becker (1):
      ocfs2: Correct merge of 52f7c21 (Move /sys/o2cb to /sys/fs/o2cb)

Sunil Mushran (2):
      ocfs2: Allow uid/gid/perm changes of symlinks
      ocfs2: Use GFP_NOFS in kmalloc during localalloc window move

diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index 98429fd..bc702da 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -65,7 +65,7 @@ int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_kset = kset_create_and_add("o2cb", NULL, NULL);
+	o2cb_kset = kset_create_and_add("o2cb", NULL, fs_kobj);
 	if (!o2cb_kset)
 		return -ENOMEM;
 
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 5f6d858..1b81dcb 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -44,7 +44,8 @@
 #define MLOG_MASK_PREFIX ML_DLM
 #include "cluster/masklog.h"
 
-int stringify_lockname(const char *lockname, int locklen, char *buf, int len);
+static int stringify_lockname(const char *lockname, int locklen, char *buf,
+			      int len);
 
 void dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 {
@@ -251,7 +252,8 @@ EXPORT_SYMBOL_GPL(dlm_errname);
  *
  * For more on lockname formats, please refer to dlmglue.c and ocfs2_lockid.h.
  */
-int stringify_lockname(const char *lockname, int locklen, char *buf, int len)
+static int stringify_lockname(const char *lockname, int locklen, char *buf,
+			      int len)
 {
 	int out = 0;
 	__be64 inode_blkno_be;
@@ -368,7 +370,7 @@ static void dlm_debug_free(struct kref *kref)
 	kfree(dc);
 }
 
-void dlm_debug_put(struct dlm_debug_ctxt *dc)
+static void dlm_debug_put(struct dlm_debug_ctxt *dc)
 {
 	if (dc)
 		kref_put(&dc->debug_refcnt, dlm_debug_free);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9154c82..57e0d30 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1048,6 +1048,10 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	mlog_entry("(0x%p, '%.*s')\n", dentry,
 	           dentry->d_name.len, dentry->d_name.name);
 
+	/* ensuring we don't even attempt to truncate a symlink */
+	if (S_ISLNK(inode->i_mode))
+		attr->ia_valid &= ~ATTR_SIZE;
+
 	if (attr->ia_valid & ATTR_MODE)
 		mlog(0, "mode change: %d\n", attr->ia_mode);
 	if (attr->ia_valid & ATTR_UID)
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ce0dc14..be774bd 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -260,7 +260,7 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 	bh = osb->local_alloc_bh;
 	alloc = (struct ocfs2_dinode *) bh->b_data;
 
-	alloc_copy = kmalloc(bh->b_size, GFP_KERNEL);
+	alloc_copy = kmalloc(bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		goto out_commit;
@@ -931,7 +931,7 @@ static int ocfs2_local_alloc_slide_window(struct ocfs2_super *osb,
 	 * local alloc shutdown won't try to double free main bitmap
 	 * bits. Make a copy so the sync function knows which bits to
 	 * free. */
-	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_KERNEL);
+	alloc_copy = kmalloc(osb->local_alloc_bh->b_size, GFP_NOFS);
 	if (!alloc_copy) {
 		status = -ENOMEM;
 		mlog_errno(status);
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index ac1d74c..bbd1667 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -385,7 +385,7 @@ static int o2cb_cluster_this_node(unsigned int *node)
 	return 0;
 }
 
-struct ocfs2_stack_operations o2cb_stack_ops = {
+static struct ocfs2_stack_operations o2cb_stack_ops = {
 	.connect	= o2cb_cluster_connect,
 	.disconnect	= o2cb_cluster_disconnect,
 	.hangup		= o2cb_cluster_hangup,
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 7428663..b503772 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -635,7 +635,7 @@ static const struct file_operations ocfs2_control_fops = {
 	.owner   = THIS_MODULE,
 };
 
-struct miscdevice ocfs2_control_device = {
+static struct miscdevice ocfs2_control_device = {
 	.minor		= MISC_DYNAMIC_MINOR,
 	.name		= "ocfs2_control",
 	.fops		= &ocfs2_control_fops,
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 7134007..ba9dbb5 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -167,9 +167,11 @@ const struct inode_operations ocfs2_symlink_inode_operations = {
 	.readlink	= page_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
+	.setattr	= ocfs2_setattr,
 };
 const struct inode_operations ocfs2_fast_symlink_inode_operations = {
 	.readlink	= ocfs2_readlink,
 	.follow_link	= ocfs2_follow_link,
 	.getattr	= ocfs2_getattr,
+	.setattr	= ocfs2_setattr,
 };

From: Joel Becker <joel.becker@oracle.com>
Date: Wed, 10 Feb 2010 01:27:52 -0800
Subject: [Ocfs2-devel] [PATCH 09/11] ocfs2_dlmfs: Don't honor truncate. The
	size of a dlmfs file is LVB_LEN
In-Reply-To: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1265794074-19539-10-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com

We want folks using dlmfs to be able to use the LVB in places other than
just write(2)/read(2).  By ignoring truncate requests, we allow 'echo
"contents" > /dlm/space/lockname' to work.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index e21ce0e..13ac2bf 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -220,6 +220,23 @@ static int dlmfs_file_release(struct inode *inode,
 	return 0;
 }
 
+/*
+ * We do ->setattr() just to override size changes.  Our size is the size
+ * of the LVB and nothing else.
+ */
+static int dlmfs_file_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	int error;
+	struct inode *inode = dentry->d_inode;
+
+	attr->ia_valid &= ~ATTR_SIZE;
+	error = inode_change_ok(inode, attr);
+	if (!error)
+		error = inode_setattr(inode, attr);
+
+	return error;
+}
+
 static unsigned int dlmfs_file_poll(struct file *file, poll_table *wait)
 {
 	int event = 0;
@@ -634,6 +651,7 @@ static const struct super_operations dlmfs_ops = {
 
 static const struct inode_operations dlmfs_file_inode_operations = {
 	.getattr	= simple_getattr,
+	.setattr	= dlmfs_file_setattr,
 };
 
 static int dlmfs_get_sb(struct file_system_type *fs_type,
-- 
1.6.6.1

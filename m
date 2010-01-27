From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 27 Jan 2010 14:13:31 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2_dlmfs: Use poll() to signify BASTs.
Message-ID: <20100127221330.GA21942@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

o2dlm's userspace filesystem is an easy way to use the DLM from
userspace.  It is intentionally simple. For example, it does not allow
for asynchronous behavior or lock conversion.  This is intentional to
keep the interface simple.

Because there is no asynchronous notification, there is no way for a
process holding a lock to know another node needs the lock.  This is the
number one complaint of ocfs2_dlmfs users.  Turns out, we can solve this
very easily.  We add poll() support to ocfs2_dlmfs.  When a BAST is
received, the lock's file descriptor will receive POLLIN.

This is trivial to implement.  Userdlm already has an appropriate
waitqueue, and the lock knows when it is blocked.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmfs.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 02bf178..aea0c40 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -179,6 +179,22 @@ static int dlmfs_file_release(struct inode *inode,
 	return 0;
 }
 
+static unsigned int dlmfs_file_poll(struct file *file, poll_table *wait)
+{
+	int event = 0;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct dlmfs_inode_private *ip = DLMFS_I(inode);
+
+	poll_wait(file, &ip->ip_lockres.l_event, wait);
+
+	spin_lock(&ip->ip_lockres.l_lock);
+	if (ip->ip_lockres.l_flags & USER_LOCK_BLOCKED)
+		event = POLLIN | POLLRDNORM;
+	spin_unlock(&ip->ip_lockres.l_lock);
+
+	return event;
+}
+
 static ssize_t dlmfs_file_read(struct file *filp,
 			       char __user *buf,
 			       size_t count,
@@ -549,6 +565,7 @@ static int dlmfs_fill_super(struct super_block * sb,
 static const struct file_operations dlmfs_file_operations = {
 	.open		= dlmfs_file_open,
 	.release	= dlmfs_file_release,
+	.poll		= dlmfs_file_poll,
 	.read		= dlmfs_file_read,
 	.write		= dlmfs_file_write,
 };
-- 
1.6.6


-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

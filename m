From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 04 Apr 2013 11:42:24 -0000
Subject: [Ocfs2-devel] [patch 1/2 v2] Ocfs2/move_extents: fix error handling
	in ioctl
In-Reply-To: <515D45FE.7020605@oracle.com>
Message-ID: <20130404114030.GA25020@longonot.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Smatch complains that if we hit an error (for example if the file is
immutable) then "range" has uninitialized stack data and we copy it to
the user.

I've re-written the error handling to avoid this problem and make it a
little cleaner as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: check for argp earlier

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 9f8dcad..8f3d3cb 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -1057,42 +1057,40 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 	struct inode *inode = file_inode(filp);
 	struct ocfs2_move_extents range;
-	struct ocfs2_move_extents_context *context = NULL;
+	struct ocfs2_move_extents_context *context;
+
+	if (!argp)
+		return -EINVAL;
 
 	status = mnt_want_write_file(filp);
 	if (status)
 		return status;
 
 	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
-		goto out;
+		goto out_drop;
 
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
 		status = -EPERM;
-		goto out;
+		goto out_drop;
 	}
 
 	context = kzalloc(sizeof(struct ocfs2_move_extents_context), GFP_NOFS);
 	if (!context) {
 		status = -ENOMEM;
 		mlog_errno(status);
-		goto out;
+		goto out_drop;
 	}
 
 	context->inode = inode;
 	context->file = filp;
 
-	if (argp) {
-		if (copy_from_user(&range, argp, sizeof(range))) {
-			status = -EFAULT;
-			goto out;
-		}
-	} else {
-		status = -EINVAL;
-		goto out;
+	if (copy_from_user(&range, argp, sizeof(range))) {
+		status = -EFAULT;
+		goto out_free;
 	}
 
 	if (range.me_start > i_size_read(inode))
-		goto out;
+		goto out_free;
 
 	if (range.me_start + range.me_len > i_size_read(inode))
 			range.me_len = i_size_read(inode) - range.me_start;
@@ -1124,25 +1122,24 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
 		if (status)
-			goto out;
+			goto out_copy;
 	}
 
 	status = ocfs2_move_extents(context);
 	if (status)
 		mlog_errno(status);
-out:
+out_copy:
 	/*
 	 * movement/defragmentation may end up being partially completed,
 	 * that's the reason why we need to return userspace the finished
 	 * length and new_offset even if failure happens somewhere.
 	 */
-	if (argp) {
-		if (copy_to_user(argp, &range, sizeof(range)))
-			status = -EFAULT;
-	}
+	if (copy_to_user(argp, &range, sizeof(range)))
+		status = -EFAULT;
 
+out_free:
 	kfree(context);
-
+out_drop:
 	mnt_drop_write_file(filp);
 
 	return status;

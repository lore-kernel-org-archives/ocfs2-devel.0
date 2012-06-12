From: Jan Kara <jack@suse.cz>
Date: Tue, 12 Jun 2012 16:20:40 +0200
Subject: [Ocfs2-devel] [PATCH 19/27] ocfs2: Convert to new freezing mechanism
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Message-ID: <1339510848-16992-20-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Protect ocfs2_page_mkwrite() and ocfs2_file_aio_write() using the new freeze
protection. We also protect several ioctl entry points which were missing the
protection. Finally, we add freeze protection to the journaling mechanism so
that iput() of unlinked inode cannot modify a frozen filesystem.

CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: ocfs2-devel at oss.oracle.com
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c    |   11 +++++++++--
 fs/ocfs2/ioctl.c   |   14 ++++++++++++--
 fs/ocfs2/journal.c |    7 ++++++-
 fs/ocfs2/mmap.c    |    2 ++
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 061591a..9b1e3d4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1971,6 +1971,7 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int ret;
 
 	if ((cmd == OCFS2_IOC_RESVSP || cmd == OCFS2_IOC_RESVSP64) &&
 	    !ocfs2_writes_unwritten_extents(osb))
@@ -1985,7 +1986,12 @@ int ocfs2_change_file_space(struct file *file, unsigned int cmd,
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	return __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
+	ret = mnt_want_write_file(file);
+	if (ret)
+		return ret;
+	ret = __ocfs2_change_file_space(file, inode, file->f_pos, cmd, sr, 0);
+	mnt_drop_write_file(file);
+	return ret;
 }
 
 static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
@@ -2261,7 +2267,7 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	if (iocb->ki_left == 0)
 		return 0;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb);
 
 	appending = file->f_flags & O_APPEND ? 1 : 0;
 	direct_io = file->f_flags & O_DIRECT ? 1 : 0;
@@ -2434,6 +2440,7 @@ out_sems:
 		ocfs2_iocb_clear_sem_locked(iocb);
 
 	mutex_unlock(&inode->i_mutex);
+	sb_end_write(inode->i_sb);
 
 	if (written)
 		ret = written;
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index d96f7f8..f20edcb 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -928,7 +928,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (get_user(new_clusters, (int __user *)arg))
 			return -EFAULT;
 
-		return ocfs2_group_extend(inode, new_clusters);
+		status = mnt_want_write_file(filp);
+		if (status)
+			return status;
+		status = ocfs2_group_extend(inode, new_clusters);
+		mnt_drop_write_file(filp);
+		return status;
 	case OCFS2_IOC_GROUP_ADD:
 	case OCFS2_IOC_GROUP_ADD64:
 		if (!capable(CAP_SYS_RESOURCE))
@@ -937,7 +942,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&input, (int __user *) arg, sizeof(input)))
 			return -EFAULT;
 
-		return ocfs2_group_add(inode, &input);
+		status = mnt_want_write_file(filp);
+		if (status)
+			return status;
+		status = ocfs2_group_add(inode, &input);
+		mnt_drop_write_file(filp);
+		return status;
 	case OCFS2_IOC_REFLINK:
 		if (copy_from_user(&args, argp, sizeof(args)))
 			return -EFAULT;
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 0a42ae9..2dd36af 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -355,11 +355,14 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 	if (journal_current_handle())
 		return jbd2_journal_start(journal, max_buffs);
 
+	sb_start_intwrite(osb->sb);
+
 	down_read(&osb->journal->j_trans_barrier);
 
 	handle = jbd2_journal_start(journal, max_buffs);
 	if (IS_ERR(handle)) {
 		up_read(&osb->journal->j_trans_barrier);
+		sb_end_intwrite(osb->sb);
 
 		mlog_errno(PTR_ERR(handle));
 
@@ -388,8 +391,10 @@ int ocfs2_commit_trans(struct ocfs2_super *osb,
 	if (ret < 0)
 		mlog_errno(ret);
 
-	if (!nested)
+	if (!nested) {
 		up_read(&journal->j_trans_barrier);
+		sb_end_intwrite(osb->sb);
+	}
 
 	return ret;
 }
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 9cd4108..d150372 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -136,6 +136,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	sigset_t oldset;
 	int ret;
 
+	sb_start_pagefault(inode->i_sb);
 	ocfs2_block_signals(&oldset);
 
 	/*
@@ -165,6 +166,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 out:
 	ocfs2_unblock_signals(&oldset);
+	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 
-- 
1.7.1

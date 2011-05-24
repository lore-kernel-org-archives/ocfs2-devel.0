From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 24 May 2011 18:53:47 +0800
Subject: [Ocfs2-devel] [PATCH 13/15] Ocfs2/move_extents: move/defrag extents
	within a certain range.
In-Reply-To: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
References: <1306234429-28078-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1306234429-28078-14-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

the basic logic of moving extents for a file is pretty like punching-hole
sequence, walk the extents within the range as user specified, calculating
an appropriate len to defrag/move, then let ocfs2_defrag/move_extent() to
do the actual moving.

This func ends up setting 'OCFS2_MOVE_EXT_FL_COMPLETE' to userpace if operation
gets done successfully.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c        |    5 +
 fs/ocfs2/move_extents.c |  312 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/move_extents.h |    2 +
 3 files changed, 319 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index fd248ed..5910059 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -26,6 +26,7 @@
 #include "dir.h"
 #include "buffer_head_io.h"
 #include "suballoc.h"
+#include "move_extents.h"
 
 #include <linux/ext2_fs.h>
 
@@ -951,6 +952,8 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 0);
+	case OCFS2_IOC_MOVE_EXT:
+		return ocfs2_ioctl_move_extents(filp, (void __user *)arg);
 	default:
 		return -ENOTTY;
 	}
@@ -993,6 +996,8 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 1);
+	case OCFS2_IOC_MOVE_EXT:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index d701cfe..b5e960a 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -827,3 +827,315 @@ static void ocfs2_calc_extent_defrag_len(u32 *alloc_size, u32 *len_defraged,
 		*len_defraged = 0;
 	}
 }
+
+static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
+				struct ocfs2_move_extents_context *context)
+{
+	int ret = 0, flags, do_defrag, skip = 0;
+	u32 cpos, phys_cpos, move_start, len_to_move, alloc_size;
+	u32 len_defraged = 0, defrag_thresh = 0, new_phys_cpos = 0;
+
+	struct inode *inode = context->inode;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
+	struct ocfs2_move_extents *range = context->range;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if ((inode->i_size == 0) || (range->me_len == 0))
+		return 0;
+
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	context->refcount_loc = le64_to_cpu(di->i_refcount_loc);
+
+	ocfs2_init_dinode_extent_tree(&context->et, INODE_CACHE(inode), di_bh);
+	ocfs2_init_dealloc_ctxt(&context->dealloc);
+
+	/*
+	 * TO-DO XXX:
+	 *
+	 * - xattr extents.
+	 */
+
+	do_defrag = context->auto_defrag;
+
+	/*
+	 * extents moving happens in unit of clusters, for the sake
+	 * of simplicity, we may ignore two clusters where 'byte_start'
+	 * and 'byte_start + len' were within.
+	 */
+	move_start = ocfs2_clusters_for_bytes(osb->sb, range->me_start);
+	len_to_move = (range->me_start + range->me_len) >>
+						osb->s_clustersize_bits;
+	if (len_to_move >= move_start)
+		len_to_move -= move_start;
+	else
+		len_to_move = 0;
+
+	if (do_defrag)
+		defrag_thresh = range->me_thresh >> osb->s_clustersize_bits;
+	else
+		new_phys_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
+							 range->me_goal);
+
+	mlog(0, "Inode: %llu, start: %llu, len: %llu, cstart: %u, clen: %u, "
+	     "thresh: %u\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+	     (unsigned long long)range->me_start,
+	     (unsigned long long)range->me_len,
+	     move_start, len_to_move, defrag_thresh);
+
+	cpos = move_start;
+	while (len_to_move) {
+		ret = ocfs2_get_clusters(inode, cpos, &phys_cpos, &alloc_size,
+					 &flags);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		if (alloc_size > len_to_move)
+			alloc_size = len_to_move;
+
+		/*
+		 * XXX: how to deal with a hole:
+		 *
+		 * - skip the hole of course
+		 * - force a new defragmentation
+		 */
+		if (!phys_cpos) {
+			if (do_defrag)
+				len_defraged = 0;
+
+			goto next;
+		}
+
+		if (do_defrag) {
+			ocfs2_calc_extent_defrag_len(&alloc_size, &len_defraged,
+						     defrag_thresh, &skip);
+			/*
+			 * skip large extents
+			 */
+			if (skip) {
+				skip = 0;
+				goto next;
+			}
+
+			mlog(0, "#Defrag: cpos: %u, phys_cpos: %u, "
+			     "alloc_size: %u, len_defraged: %u\n",
+			     cpos, phys_cpos, alloc_size, len_defraged);
+
+			ret = ocfs2_defrag_extent(context, cpos, phys_cpos,
+						  alloc_size, flags);
+		} else {
+			ret = ocfs2_move_extent(context, cpos, phys_cpos,
+						&new_phys_cpos, alloc_size,
+						flags);
+
+			new_phys_cpos += alloc_size;
+		}
+
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out;
+		}
+
+		context->clusters_moved += alloc_size;
+next:
+		cpos += alloc_size;
+		len_to_move -= alloc_size;
+	}
+
+	range->me_flags |= OCFS2_MOVE_EXT_FL_COMPLETE;
+
+out:
+	range->me_moved_len = ocfs2_clusters_to_bytes(osb->sb,
+						      context->clusters_moved);
+	range->me_new_offset = ocfs2_clusters_to_bytes(osb->sb,
+						       context->new_phys_cpos);
+
+	ocfs2_schedule_truncate_log_flush(osb, 1);
+	ocfs2_run_deallocs(osb, &context->dealloc);
+
+	return ret;
+}
+
+static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
+{
+	int status;
+	handle_t *handle;
+	struct inode *inode = context->inode;
+	struct ocfs2_dinode *di;
+	struct buffer_head *di_bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (!inode)
+		return -ENOENT;
+
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return -EROFS;
+
+	mutex_lock(&inode->i_mutex);
+
+	/*
+	 * This prevents concurrent writes from other nodes
+	 */
+	status = ocfs2_rw_lock(inode, 1);
+	if (status) {
+		mlog_errno(status);
+		goto out;
+	}
+
+	status = ocfs2_inode_lock(inode, &di_bh, 1);
+	if (status) {
+		mlog_errno(status);
+		goto out_rw_unlock;
+	}
+
+	/*
+	 * rememer ip_xattr_sem also needs to be held if necessary
+	 */
+	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+
+	status = __ocfs2_move_extents_range(di_bh, context);
+
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
+	if (status) {
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
+	/*
+	 * We update ctime for these changes
+	 */
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
+	status = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status) {
+		mlog_errno(status);
+		goto out_commit;
+	}
+
+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	inode->i_ctime = CURRENT_TIME;
+	di->i_ctime = cpu_to_le64(inode->i_ctime.tv_sec);
+	di->i_ctime_nsec = cpu_to_le32(inode->i_ctime.tv_nsec);
+
+	ocfs2_journal_dirty(handle, di_bh);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+
+out_inode_unlock:
+	brelse(di_bh);
+	ocfs2_inode_unlock(inode, 1);
+out_rw_unlock:
+	ocfs2_rw_unlock(inode, 1);
+out:
+	mutex_unlock(&inode->i_mutex);
+
+	return status;
+}
+
+int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
+{
+	int status;
+
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct ocfs2_move_extents range;
+	struct ocfs2_move_extents_context *context = NULL;
+
+	status = mnt_want_write(filp->f_path.mnt);
+	if (status)
+		return status;
+
+	status = -EINVAL;
+
+	if ((!S_ISREG(inode->i_mode)) || !(filp->f_mode & FMODE_WRITE))
+		goto out;
+
+	if (inode->i_flags & (S_IMMUTABLE|S_APPEND)) {
+		status = -EPERM;
+		goto out;
+	}
+
+	context = kzalloc(sizeof(struct ocfs2_move_extents_context), GFP_NOFS);
+	if (!context) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto out;
+	}
+
+	context->inode = inode;
+	context->file = filp;
+
+	if (!argp) {
+		memset(&range, 0, sizeof(range));
+		range.me_len = (u64)-1;
+		range.me_flags |= OCFS2_MOVE_EXT_FL_AUTO_DEFRAG;
+		context->auto_defrag = 1;
+	} else {
+		if (copy_from_user(&range, (struct ocfs2_move_extents *)argp,
+				   sizeof(range))) {
+			status = -EFAULT;
+			goto out;
+		}
+	}
+
+	if (range.me_start > i_size_read(inode))
+		goto out;
+
+	if (range.me_start + range.me_len > i_size_read(inode))
+			range.me_len = i_size_read(inode) - range.me_start;
+
+	context->range = &range;
+
+	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
+		context->auto_defrag = 1;
+		if (!range.me_thresh)
+			/*
+			 * ok, the default theshold for the defragmentation
+			 * is 1M, since our maximum clustersize was 1M also.
+			 * any thought?
+			 */
+			range.me_thresh = 1024 * 1024;
+	} else {
+		/*
+		 * first best-effort attempt to validate and adjust the goal
+		 * (physical address in block), while it can't guarantee later
+		 * operation can succeed all the time since global_bitmap may
+		 * change a bit over time.
+		 */
+
+		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
+		if (status)
+			goto out;
+	}
+
+	status = ocfs2_move_extents(context);
+	if (status)
+		mlog_errno(status);
+out:
+	/*
+	 * movement/defragmentation may end up being partially completed,
+	 * that's the reason why we need to return userspace the finished
+	 * length and new_offset even if failure happens somewhere.
+	 */
+	if (argp) {
+		if (copy_to_user((struct ocfs2_move_extents *)argp, &range,
+				sizeof(range)))
+			status = -EFAULT;
+	}
+
+	kfree(context);
+
+	mnt_drop_write(filp->f_path.mnt);
+
+	return status;
+}
diff --git a/fs/ocfs2/move_extents.h b/fs/ocfs2/move_extents.h
index eba4044..d9f0f29 100644
--- a/fs/ocfs2/move_extents.h
+++ b/fs/ocfs2/move_extents.h
@@ -17,4 +17,6 @@
 #ifndef OCFS2_MOVE_EXTENTS_H
 #define OCFS2_MOVE_EXTENTS_H
 
+int ocfs2_ioctl_move_extents(struct file *filp,  void __user *argp);
+
 #endif /* OCFS2_MOVE_EXTENTS_H */
-- 
1.5.5

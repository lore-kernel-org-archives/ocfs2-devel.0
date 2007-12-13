From: Tao Ma <tao.ma@oracle.com>
Date: Thu Dec 13 23:58:44 2007
Subject: [Ocfs2-devel] [PATCH 4/4] Implement "GROUP_ADD" for online
	resize.take 3
In-Reply-To: <20071214073744.GA26638@tma-pc1.cn.oracle.com>
Message-ID: <20071214075641.GA26713@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Modification from V2 to V3:
1. Modify the call sequence for ocfs2_commit_trans so that we will always
   call it after a successful start_trans.
2. As we need to update the group's bg_next_group in the kernel, move the group
   read in the main function and add the writeout of this group also.
3. Add the update of i_size of the inode.
4. Use the new defined ioctl numbers.

User can do offline resize using tunefs.ocfs2 when a volume isn't
mounted. Now the support for online resize is added into ocfs2.

Please note that the node where online resize goes must already
has the volume mounted. We don't mount it behind the user and the
operation would fail if we find it isn't mounted. As for other
nodes, we don't care whether the volume is mounted or not.

global_bitmap, super block and all the backups will be updated
in the kernel. And if super block or backup's update fails, we
just output some error message in dmesg and continue the work.

The whole process is derived from ext3 and divided into 2 steps:
1. If the last group isn't full, tunefs.ocfs2 will call
   OCFS2_IOC_GROUP_EXTEND first to extend it. All the main work is
   done in kernel.
2. For every new groups, tunefs.ocfs2 will call OCFS2_IOC_GROUP_ADD
   to add them one by one. The new group descriptor is initialized
   in userspace, we only check it in the kernel and update the
   global_bitap, super blocks etc.

This patch includes the implentation for the 2nd step.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ioctl.c    |    9 ++
 fs/ocfs2/journal.h  |    3 +
 fs/ocfs2/ocfs2_fs.h |   12 +++
 fs/ocfs2/resize.c   |  238 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/resize.h   |    1 +
 5 files changed, 263 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 03ee69b..a4dda60 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -119,6 +119,7 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 	int new_clusters;
 	int status;
 	struct ocfs2_space_resv sr;
+	struct ocfs2_new_group_input input;
 
 	switch (cmd) {
 	case OCFS2_IOC_GETFLAGS:
@@ -147,6 +148,12 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 			return -EFAULT;
 
 		return ocfs2_group_extend(inode, new_clusters);
+	case OCFS2_IOC_GROUP_ADD:
+	case OCFS2_IOC_GROUP_ADD64:
+		if (copy_from_user(&input, (int __user *) arg, sizeof(input)))
+			return -EFAULT;
+
+		return ocfs2_group_add(inode, &input);
 	default:
 		return -ENOTTY;
 	}
@@ -170,6 +177,8 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case OCFS2_IOC_UNRESVSP:
 	case OCFS2_IOC_UNRESVSP64:
 	case OCFS2_IOC_GROUP_EXTEND:
+	case OCFS2_IOC_GROUP_ADD:
+	case OCFS2_IOC_GROUP_ADD64:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 0ba3a42..220f3e8 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -281,6 +281,9 @@ int                  ocfs2_journal_dirty_data(handle_t *handle,
 /* group extend. inode update and last group update. */
 #define OCFS2_GROUP_EXTEND_CREDITS	(OCFS2_INODE_UPDATE_CREDITS + 1)
 
+/* group add. inode update and the new group update. */
+#define OCFS2_GROUP_ADD_CREDITS	(OCFS2_INODE_UPDATE_CREDITS + 1)
+
 /* get one bit out of a suballocator: dinode + group descriptor +
  * prev. group desc. if we relink. */
 #define OCFS2_SUBALLOC_ALLOC (3)
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 19ac421..4255517 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -231,7 +231,19 @@ struct ocfs2_space_resv {
 #define OCFS2_IOC_RESVSP64	_IOW ('X', 42, struct ocfs2_space_resv)
 #define OCFS2_IOC_UNRESVSP64	_IOW ('X', 43, struct ocfs2_space_resv)
 
+/* Used to pass group descriptor data when online resize is done */
+struct ocfs2_new_group_input {
+	__u64 group;		/* Group descriptor's blkno. */
+	__u32 clusters;		/* Total number of clusters in this group */
+	__u32 frees;		/* Total free clusters in this group */
+	__u16 chain;		/* Chain for this group */
+	__u16 reserved1;
+	__u32 reserved2;
+};
+
 #define OCFS2_IOC_GROUP_EXTEND	_IOW('o', 1, int)
+#define OCFS2_IOC_GROUP_ADD	_IOW('o', 2,struct ocfs2_new_group_input)
+#define OCFS2_IOC_GROUP_ADD64	_IOW('o', 3,struct ocfs2_new_group_input)
 
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index e480639..60721ba 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -396,3 +396,241 @@ out:
 	mlog_exit_void();
 	return ret;
 }
+
+static int ocfs2_check_new_group(struct inode *inode,
+				 struct ocfs2_dinode *di,
+				 struct ocfs2_new_group_input *input,
+				 struct buffer_head *group_bh)
+{
+	int ret;
+	struct ocfs2_group_desc *gd;
+	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
+	unsigned int max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) *
+				le16_to_cpu(di->id2.i_chain.cl_bpc);
+
+
+	gd = (struct ocfs2_group_desc *)group_bh->b_data;
+
+	ret = -EIO;
+	if (!OCFS2_IS_VALID_GROUP_DESC(gd))
+		mlog(0, "Group descriptor # %llu isn't valid.\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno));
+	else if (di->i_blkno != gd->bg_parent_dinode)
+		mlog(0, "Group descriptor # %llu has bad parent "
+		     "pointer (%llu, expected %llu)\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		     (unsigned long long)le64_to_cpu(gd->bg_parent_dinode),
+		     (unsigned long long)le64_to_cpu(di->i_blkno));
+	else if (le16_to_cpu(gd->bg_bits) > max_bits)
+		mlog(0, "Group descriptor # %llu has bit count of %u\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		     le16_to_cpu(gd->bg_bits));
+	else if (le16_to_cpu(gd->bg_free_bits_count) > le16_to_cpu(gd->bg_bits))
+		mlog(0, "Group descriptor # %llu has bit count %u but "
+		     "claims that %u are free\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		     le16_to_cpu(gd->bg_bits),
+		     le16_to_cpu(gd->bg_free_bits_count));
+	else if (le16_to_cpu(gd->bg_bits) > (8 * le16_to_cpu(gd->bg_size)))
+		mlog(0, "Group descriptor # %llu has bit count %u but "
+		     "max bitmap bits of %u\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		     le16_to_cpu(gd->bg_bits),
+		     8 * le16_to_cpu(gd->bg_size));
+	else if (le16_to_cpu(gd->bg_chain) != input->chain)
+		mlog(0, "Group descriptor # %llu has bad chain %u "
+		     "while input has %u set.\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		    le16_to_cpu(gd->bg_chain), input->chain);
+	else if (le16_to_cpu(gd->bg_bits) != input->clusters * cl_bpc)
+		mlog(0, "Group descriptor # %llu has bit count %u but "
+		     "input has %u clusters set\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		     le16_to_cpu(gd->bg_bits), input->clusters);
+	else if (le16_to_cpu(gd->bg_free_bits_count) != input->frees * cl_bpc)
+		mlog(0, "Group descriptor # %llu has free bit count %u but "
+		     "it should have %u set\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		     le16_to_cpu(gd->bg_bits),
+		     input->frees * cl_bpc);
+	else
+		ret = 0;
+
+	return ret;
+}
+
+static int ocfs2_verify_group_and_input(struct inode *inode,
+					struct ocfs2_dinode *di,
+					struct ocfs2_new_group_input *input,
+					struct buffer_head *group_bh)
+{
+	u16 cl_count = le16_to_cpu(di->id2.i_chain.cl_count);
+	u16 cl_cpg = le16_to_cpu(di->id2.i_chain.cl_cpg);
+	u16 next_free = le16_to_cpu(di->id2.i_chain.cl_next_free_rec);
+	u32 cluster = ocfs2_blocks_to_clusters(inode->i_sb, input->group);
+	u32 total_clusters = le32_to_cpu(di->i_clusters);
+	int ret = -EINVAL;
+
+	if (cluster < total_clusters)
+		mlog(0, "add a group which is in the current volume.\n");
+	else if (input->chain >= cl_count)
+		mlog(0, "input chain exceeds the limit.\n");
+	else if (next_free != cl_count && next_free != input->chain)
+		mlog(0, "the add group should be in chain %u\n", next_free);
+	else if (total_clusters + input->clusters < total_clusters)
+		mlog(0, "add group's clusters overflow.\n");
+	else if (input->clusters > cl_cpg)
+		mlog(0, "the cluster exceeds the maximum of a group\n");
+	else if (input->frees > input->clusters)
+		mlog(0, "the free cluster exceeds the total clusters\n");
+	else if (total_clusters % cl_cpg != 0)
+		mlog(0, "the last group isn't full. Use group extend first.\n");
+	else if (input->group != ocfs2_which_cluster_group(inode, cluster))
+		mlog(0, "group blkno is invalid\n");
+	else if ((ret = ocfs2_check_new_group(inode, di, input, group_bh)))
+		mlog(0, "group descriptor check failed.\n");
+	else
+		ret = 0;
+
+	return ret;
+}
+
+/* Add a new group descriptor to global_bitmap. */
+int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
+{
+	int ret;
+	handle_t *handle;
+	struct buffer_head *main_bm_bh = NULL;
+	struct inode *main_bm_inode = NULL;
+	struct ocfs2_dinode *fe = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *group_bh = NULL;
+	struct ocfs2_group_desc *group = NULL;
+	struct ocfs2_chain_list *cl;
+	struct ocfs2_chain_rec *cr;
+	u16 cl_bpc;
+
+	mlog_entry_void();
+
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return -EROFS;
+
+	main_bm_inode = ocfs2_get_system_file_inode(osb,
+						    GLOBAL_BITMAP_SYSTEM_INODE,
+						    OCFS2_INVALID_SLOT);
+	if (!main_bm_inode) {
+		ret = -EINVAL;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	mutex_lock(&main_bm_inode->i_mutex);
+
+	ret = ocfs2_meta_lock(main_bm_inode, &main_bm_bh, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_mutex;
+	}
+
+	fe = (struct ocfs2_dinode *)main_bm_bh->b_data;
+
+	if (le16_to_cpu(fe->id2.i_chain.cl_cpg) !=
+				 ocfs2_group_bitmap_size(osb->sb) * 8) {
+		mlog(0, "The disk is too old and small."
+		     " Force to do offline resize.");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
+	if (ret < 0)
+		goto out;
+
+	ocfs2_set_new_buffer_uptodate(inode, group_bh);
+
+	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	mlog(0, "Add a new group  %llu in chain = %u, length = %u\n",
+	     input->group, input->chain, input->clusters);
+
+	handle = ocfs2_start_trans(osb, OCFS2_GROUP_ADD_CREDITS);
+	if (IS_ERR(handle)) {
+		mlog_errno(PTR_ERR(handle));
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
+	cl = &fe->id2.i_chain;
+	cr = &cl->cl_recs[input->chain];
+
+	ret = ocfs2_journal_access(handle, main_bm_inode, group_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	group = (struct ocfs2_group_desc *)group_bh->b_data;
+	group->bg_next_group = cr->c_blkno;
+
+	ret = ocfs2_journal_dirty(handle, group_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	ret = ocfs2_journal_access(handle, main_bm_inode, main_bm_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_commit;
+	}
+
+	if (input->chain == le16_to_cpu(cl->cl_next_free_rec)) {
+		le16_add_cpu(&cl->cl_next_free_rec, 1);
+		memset(cr, 0, sizeof(struct ocfs2_chain_rec));
+	}
+
+	cr->c_blkno = le64_to_cpu(input->group);
+	le32_add_cpu(&cr->c_total, input->clusters * cl_bpc);
+	le32_add_cpu(&cr->c_free, input->frees * cl_bpc);
+
+	le32_add_cpu(&fe->id1.bitmap1.i_total, input->clusters *cl_bpc);
+	le32_add_cpu(&fe->id1.bitmap1.i_used,
+		     (input->clusters - input->frees) * cl_bpc);
+	le32_add_cpu(&fe->i_clusters, input->clusters);
+
+	ocfs2_journal_dirty(handle, main_bm_bh);
+
+	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
+	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
+	le64_add_cpu(&fe->i_size, input->clusters << osb->s_clustersize_bits);
+	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
+	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
+
+	ocfs2_update_super_and_backups(main_bm_inode, input->clusters);
+
+out_commit:
+	ocfs2_commit_trans(osb, handle);
+out_unlock:
+	if (group_bh)
+		brelse(group_bh);
+
+	if (main_bm_bh)
+		brelse(main_bm_bh);
+
+	ocfs2_meta_unlock(main_bm_inode, 1);
+
+out_mutex:
+	mutex_unlock(&main_bm_inode->i_mutex);
+	iput(main_bm_inode);
+
+out:
+	mlog_exit_void();
+	return ret;
+}
diff --git a/fs/ocfs2/resize.h b/fs/ocfs2/resize.h
index 3acb79a..f38841a 100644
--- a/fs/ocfs2/resize.h
+++ b/fs/ocfs2/resize.h
@@ -27,5 +27,6 @@
 #define OCFS2_RESIZE_H
 
 int ocfs2_group_extend(struct inode * inode, int new_clusters);
+int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input);
 
 #endif /* OCFS2_RESIZE_H */
-- 
gitgui.0.9.0.gd794

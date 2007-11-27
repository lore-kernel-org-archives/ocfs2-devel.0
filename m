From: Tao Ma <tao.ma@oracle.com>
Date: Tue Nov 27 00:22:59 2007
Subject: [Ocfs2-devel] [PATCH 3/3] Implement "GROUP_ADD" for online resize,
	take 2
In-Reply-To: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
Message-ID: <20071127082149.GA4486@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

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
 fs/ocfs2/ioctl.c    |    7 ++
 fs/ocfs2/ocfs2.h    |    1 +
 fs/ocfs2/ocfs2_fs.h |   11 +++
 fs/ocfs2/resize.c   |  231 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 250 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 60698de..ac30fe5 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -118,6 +118,7 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 	u32 new_clusters;
 	int status;
 	struct ocfs2_space_resv sr;
+	struct ocfs2_new_group_input input;
 
 	switch (cmd) {
 	case OCFS2_IOC_GETFLAGS:
@@ -146,6 +147,11 @@ int ocfs2_ioctl(struct inode * inode, struct file * filp,
 			return -EFAULT;
 
 		return ocfs2_group_extend(inode, new_clusters);
+	case OCFS2_IOC_GROUP_ADD:
+		if (copy_from_user(&input, (int __user *) arg, sizeof(input)))
+			return -EFAULT;
+
+		return ocfs2_group_add(inode, &input);
 	default:
 		return -ENOTTY;
 	}
@@ -169,6 +175,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case OCFS2_IOC_UNRESVSP:
 	case OCFS2_IOC_UNRESVSP64:
 	case OCFS2_IOC_GROUP_EXTEND:
+	case OCFS2_IOC_GROUP_ADD:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 8a6925b..805a76e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -531,6 +531,7 @@ static inline unsigned int ocfs2_pages_per_cluster(struct super_block *sb)
  * and return that block offset. */
 u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
 int ocfs2_group_extend(struct inode * inode, u32 new_clusters);
+int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input);
 
 #define ocfs2_set_bit ext2_set_bit
 #define ocfs2_clear_bit ext2_clear_bit
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 4b5813d..969c310 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -231,7 +231,18 @@ struct ocfs2_space_resv {
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
 #define OCFS2_IOC_GROUP_EXTEND	_IOW('f', 7, unsigned long)
+#define OCFS2_IOC_GROUP_ADD	_IOW('f', 8,struct ocfs2_new_group_input)
 
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 5c863af..efd7805 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -364,3 +364,234 @@ out:
 	mlog_exit_void();
 	return ret;
 }
+
+static int ocfs2_check_new_group(struct inode *inode,
+				 struct ocfs2_dinode *di,
+				 struct ocfs2_new_group_input *input)
+{
+	int ret;
+	struct ocfs2_group_desc *gd;
+	struct buffer_head *group_bh = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
+	u64 cr_blkno;
+	unsigned int max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) *
+				le16_to_cpu(di->id2.i_chain.cl_bpc);
+
+	ret = ocfs2_read_block(osb, input->group, &group_bh, 0, NULL);
+	if (ret < 0)
+		goto out;
+
+	gd = (struct ocfs2_group_desc *)group_bh->b_data;
+	cr_blkno = le64_to_cpu(di->id2.i_chain.cl_recs[input->chain].c_blkno);
+
+	ret = -EIO;
+	if (!OCFS2_IS_VALID_GROUP_DESC(gd))
+		OCFS2_RO_ON_INVALID_GROUP_DESC(inode->i_sb, gd);
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
+	else if (le64_to_cpu(gd->bg_next_group) != cr_blkno)
+		mlog(0, "Group descriptor # %llu has next group set as %llu "
+		     "while the chain head has  %llu set\n",
+		     (unsigned long long)le64_to_cpu(gd->bg_blkno),
+		     le64_to_cpu(gd->bg_next_group), cr_blkno);
+	else
+		ret = 0;
+out:
+	if (group_bh)
+		brelse(group_bh);
+
+	return ret;
+}
+
+static int ocfs2_verify_group_input(struct inode *inode,
+				    struct ocfs2_dinode *di,
+				    struct ocfs2_new_group_input *input)
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
+	else if ((ret = ocfs2_check_new_group(inode, di, input)))
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
+	ret = ocfs2_verify_group_input(main_bm_inode, fe, input);
+	if (ret) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	mlog(0, "Add a new group  %llu in chain = %u, length = %u\n",
+	     input->group, input->chain, input->clusters);
+
+	handle = ocfs2_start_trans(osb, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		mlog_errno(PTR_ERR(handle));
+		handle = NULL;
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	ret = ocfs2_journal_access(handle, main_bm_inode, main_bm_bh,
+				   OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
+	cl = &fe->id2.i_chain;
+	cr = &cl->cl_recs[input->chain];
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
+	le64_add_cpu(&fe->i_size, input->clusters << osb->s_clustersize_bits);
+
+	ret = ocfs2_journal_dirty(handle, main_bm_bh);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	ret = ocfs2_commit_trans(osb, handle);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
+
+	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
+	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
+	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
+
+	ocfs2_update_super_and_backups(main_bm_inode, input->clusters);
+
+out_unlock:
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
-- 
gitgui.0.9.0.gd794

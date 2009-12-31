From: Tristan Ye <tristan.ye@oracle.com>
Date: Thu, 31 Dec 2009 16:18:44 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_INFO_IOC ioctls for
	ocfs2 v4.
In-Reply-To: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
References: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1262247524-26824-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Major changes from v3 to v4:

Incorporate Joel and Tao's comments.

The reason why we need this ioctl is to offer the none-privileged
end-user a possibility to get filesys info gathering.

We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
structure to kernel containing an array of request pointers and request
count, such as,

* From userspace:

struct ocfs2_info_blocksize brq = {
	.ir_request = {
		.ir_magic = OCFS2_INFO_MAGIC,
		.ir_code = OCFS2_INFO_BLOCKSIZE,
		...
	}
	...
}

struct ocfs2_info_clustersize crq = {
	...
}

uint64_t reqs[2] = {(unsigned long)&brq,
		    (unsigned long)&crq};

struct ocfs2_info info = {
	.ir_requests = reqs,
	.ir_count = 2,
}

ret = ioctl(fd, OCFS2_IOC_INFO, &info);

* In kernel:

Get the request pointers from *info*, then handle each request one bye one.

Idea here is to make the spearated request small enough to guarantee
a better backward&forward compatibility since a small piece of request
would be less likely to be broken if filesys on raw disk get changed.

Currently, following 8 ioctls get implemented per the requirement from
userspace tool o2info, and I believe it will grow over time:-)

	OCFS2_INFO_CLUSTERSIZE
	OCFS2_INFO_BLOCKSIZE
	OCFS2_INFO_SLOTNUM
	OCFS2_INFO_LABEL
	OCFS2_INFO_UUID
	OCFS2_INFO_FS_FEATURES
	OCFS2_INFO_FREEFRAG
	OCFS2_INFO_FREEINODE

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c |  660 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 660 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 31fbb06..f2e7f03 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -22,6 +22,9 @@
 #include "ioctl.h"
 #include "resize.h"
 #include "refcounttree.h"
+#include "sysfile.h"
+#include "buffer_head_io.h"
+#include "suballoc.h"
 
 #include <linux/ext2_fs.h>
 
@@ -108,6 +111,656 @@ bail:
 	return status;
 }
 
+int ocfs2_info_handle_blocksize(struct inode *inode,
+				struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_blocksize req_bs;
+
+	if (copy_from_user(&req_bs, user_req,
+			   sizeof(struct ocfs2_info_blocksize))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	req_bs.ir_blocksize = inode->i_sb->s_blocksize;
+	req_bs.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_blocksize __user *)user_req,
+			 &req_bs,
+			 sizeof(struct ocfs2_info_blocksize))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_clustersize(struct inode *inode,
+				  struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_clustersize req_cs;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_cs, user_req,
+			   sizeof(struct ocfs2_info_clustersize))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	req_cs.ir_clustersize = osb->s_clustersize;
+	req_cs.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_clustersize __user *)user_req,
+			 &req_cs,
+			 sizeof(struct ocfs2_info_clustersize))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_slotnum(struct inode *inode,
+			      struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_slotnum req_sn;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_sn, user_req,
+			   sizeof(struct ocfs2_info_slotnum))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	req_sn.ir_slotnum = osb->max_slots;
+	req_sn.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_slotnum __user *)user_req,
+			 &req_sn,
+			 sizeof(struct ocfs2_info_slotnum))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_label(struct inode *inode,
+			    struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_label req_lb;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_lb, user_req,
+			   sizeof(struct ocfs2_info_label))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	memcpy(req_lb.ir_label, osb->vol_label, OCFS2_MAX_VOL_LABEL_LEN);
+	req_lb.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_label __user *)user_req,
+			 &req_lb,
+			 sizeof(struct ocfs2_info_label))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_uuid(struct inode *inode,
+			   struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_uuid req_uuid;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_uuid, user_req,
+			   sizeof(struct ocfs2_info_uuid))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	memcpy(req_uuid.ir_uuid_str, osb->uuid_str, OCFS2_INFO_VOL_UUIDSTR_LEN);
+	req_uuid.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_uuid __user *)user_req,
+			 &req_uuid,
+			 sizeof(struct ocfs2_info_uuid))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_fs_features(struct inode *inode,
+				  struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_fs_features req_fs;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	if (copy_from_user(&req_fs, user_req,
+			   sizeof(struct ocfs2_info_fs_features))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	req_fs.ir_compat_features = osb->s_feature_compat;
+	req_fs.ir_incompat_features = osb->s_feature_incompat;
+	req_fs.ir_ro_compat_features = osb->s_feature_ro_compat;
+	req_fs.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_fs_features __user *)user_req,
+			 &req_fs,
+			 sizeof(struct ocfs2_info_fs_features))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+void ocfs2_info_update_ffg(struct ocfs2_info_freefrag *ffg,
+			   unsigned int chunksize)
+{
+	int index;
+
+	index = __ilog2_u32(chunksize);
+	if (index >= OCFS2_INFO_MAX_HIST)
+		index = OCFS2_INFO_MAX_HIST - 1;
+
+	ffg->ir_ffg.ir_fc_hist.ir_fc_chunks[index]++;
+	ffg->ir_ffg.ir_fc_hist.ir_fc_clusters[index] += chunksize;
+
+	if (chunksize > ffg->ir_ffg.ir_max)
+		ffg->ir_ffg.ir_max = chunksize;
+
+	if (chunksize < ffg->ir_ffg.ir_min)
+		ffg->ir_ffg.ir_min = chunksize;
+
+	ffg->ir_ffg.ir_avg += chunksize;
+	ffg->ir_ffg.ir_free_chunks_real++;
+}
+
+int ocfs2_info_scan_chain(struct inode *gb_inode,
+			  struct ocfs2_dinode *gb_dinode,
+			  struct ocfs2_info_freefrag *ffg,
+			  struct ocfs2_chain_rec *rec,
+			  unsigned int chunks_in_group)
+{
+	int status = 0, used;
+	u64 blkno;
+
+	struct buffer_head *bh = NULL;
+	struct ocfs2_group_desc *bg = NULL;
+
+	unsigned int max_bits, num_clusters;
+	unsigned int offset = 0, cluster, chunk;
+	unsigned int chunk_free, last_chunksize = 0;
+
+	if (!le32_to_cpu(rec->c_free))
+		goto bail;
+
+	do {
+		if (!bg)
+			blkno = le64_to_cpu(rec->c_blkno);
+		else
+			blkno = le64_to_cpu(bg->bg_next_group);
+
+		if (bh) {
+			brelse(bh);
+			bh = NULL;
+		}
+
+		status = ocfs2_read_group_descriptor(gb_inode, gb_dinode,
+						     blkno, &bh);
+		if (status < 0) {
+			mlog(ML_ERROR, "Can't read the group descriptor # "
+			     "%llu from device.", (unsigned long long)blkno);
+			status = -EIO;
+			goto bail;
+		}
+
+		bg = (struct ocfs2_group_desc *)bh->b_data;
+
+		if (!le16_to_cpu(bg->bg_free_bits_count))
+			continue;
+
+		max_bits = le16_to_cpu(bg->bg_bits);
+		offset = 0;
+
+		for (chunk = 0; chunk < chunks_in_group; chunk++) {
+
+			/* Last chunk may be not a entire one */
+			if ((offset + ffg->ir_chunksize) > max_bits)
+				num_clusters = max_bits - offset;
+			else
+				num_clusters = ffg->ir_chunksize;
+
+			chunk_free = 0;
+			for (cluster = 0; cluster < num_clusters; cluster++) {
+				used = ocfs2_test_bit(offset,
+						(unsigned long *)bg->bg_bitmap);
+				if (!used) {
+					last_chunksize++;
+					chunk_free++;
+				}
+
+				if (used && (last_chunksize)) {
+					ocfs2_info_update_ffg(ffg,
+							      last_chunksize);
+					last_chunksize = 0;
+				}
+
+				offset++;
+			}
+
+			if (chunk_free == ffg->ir_chunksize)
+				ffg->ir_ffg.ir_free_chunks++;
+		}
+
+		/* we need to update the info of last free chunk */
+		if (last_chunksize)
+			ocfs2_info_update_ffg(ffg, last_chunksize);
+
+	} while (le64_to_cpu(bg->bg_next_group));
+
+bail:
+	brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_scan_bitmap(struct inode *gb_inode,
+			   struct ocfs2_dinode *gb_dinode,
+			   struct ocfs2_info_freefrag *ffg,
+			   struct ocfs2_chain_list *cl)
+{
+	int status = 0, i;
+	unsigned int chunks_in_group;
+	struct ocfs2_chain_rec *rec = NULL;
+
+	chunks_in_group = le16_to_cpu(cl->cl_cpg) / ffg->ir_chunksize + 1;
+
+	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i++) {
+
+		rec = &(cl->cl_recs[i]);
+		status = ocfs2_info_scan_chain(gb_inode, gb_dinode,
+					       ffg, rec, chunks_in_group);
+		if (status)
+			goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_freefrag(struct inode *inode,
+			       struct ocfs2_info_request __user *user_req)
+{
+	int status = 0, unlock = 0;
+
+	struct ocfs2_info_freefrag req_ffg;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *bh = NULL;
+	struct inode *gb_inode = NULL;
+	struct ocfs2_dinode *gb_dinode = NULL;
+	struct ocfs2_chain_list *cl = NULL;
+
+	if (copy_from_user(&req_ffg, user_req,
+			   sizeof(struct ocfs2_info_freefrag))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	/*
+	 * chunksize from userspace should be power of 2,
+	 */
+	if ((req_ffg.ir_chunksize & (req_ffg.ir_chunksize - 1)) ||
+	    (!req_ffg.ir_chunksize)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
+	memset(&req_ffg.ir_ffg, 0, sizeof(struct ocfs2_info_freefrag_stats));
+	req_ffg.ir_ffg.ir_min = ~0U;
+
+	gb_inode = ocfs2_get_system_file_inode(osb,
+					       GLOBAL_BITMAP_SYSTEM_INODE,
+					       OCFS2_INVALID_SLOT);
+	if (!gb_inode) {
+		mlog(ML_ERROR, "failed to get bitmap inode\n");
+		status = -EIO;
+		goto bail;
+	}
+
+	mutex_lock(&gb_inode->i_mutex);
+
+	if (!(req_ffg.ir_request.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		status = ocfs2_inode_lock(gb_inode, &bh, 0);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail_mutex_unlock;
+		}
+		unlock = 1;
+
+	} else {
+		status = ocfs2_read_inode_block(gb_inode, &bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
+	gb_dinode = (struct ocfs2_dinode *)bh->b_data;
+
+	req_ffg.ir_ffg.ir_clusters =
+			le32_to_cpu(gb_dinode->id1.bitmap1.i_total);
+	req_ffg.ir_ffg.ir_free_clusters = req_ffg.ir_ffg.ir_clusters -
+				le32_to_cpu(gb_dinode->id1.bitmap1.i_used);
+
+	cl = &(gb_dinode->id2.i_chain);
+
+	/* Chunksize from userspace should be less than clusters in a group */
+	if (req_ffg.ir_chunksize > le16_to_cpu(cl->cl_cpg)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
+	status = ocfs2_info_scan_bitmap(gb_inode, gb_dinode, &req_ffg, cl);
+	if (status)
+		goto bail;
+
+	if (req_ffg.ir_ffg.ir_free_chunks_real)
+		req_ffg.ir_ffg.ir_avg = (req_ffg.ir_ffg.ir_avg /
+					req_ffg.ir_ffg.ir_free_chunks_real);
+
+	req_ffg.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_freefrag __user *)user_req,
+			 &req_ffg,
+			 sizeof(struct ocfs2_info_freefrag))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	if (unlock)
+		ocfs2_inode_unlock(gb_inode, 0);
+
+bail_mutex_unlock:
+	if (gb_inode)
+		mutex_unlock(&gb_inode->i_mutex);
+
+	iput(gb_inode);
+	brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_scan_inode_alloc(struct inode *inode_alloc,
+				struct ocfs2_info_freeinode *fi,
+				__u32 slotnum,
+				int flags)
+{
+	int status = 0, unlock = 0;
+
+	struct buffer_head *bh = NULL;
+	struct ocfs2_dinode *dinode_alloc = NULL;
+
+	mutex_lock(&inode_alloc->i_mutex);
+
+	if (!(flags & OCFS2_INFO_FL_NON_COHERENT)) {
+		status = ocfs2_inode_lock(inode_alloc, &bh, 0);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail_mutex_unlock;
+		}
+		unlock = 1;
+
+	} else {
+
+		status = ocfs2_read_inode_block(inode_alloc, &bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
+	dinode_alloc = (struct ocfs2_dinode *)bh->b_data;
+
+	fi->ir_fi_stat[slotnum].ir_total =
+		le32_to_cpu(dinode_alloc->id1.bitmap1.i_total);
+	fi->ir_fi_stat[slotnum].ir_free =
+		le32_to_cpu(dinode_alloc->id1.bitmap1.i_total) -
+		le32_to_cpu(dinode_alloc->id1.bitmap1.i_used);
+bail:
+	if (unlock)
+		ocfs2_inode_unlock(inode_alloc, 0);
+
+bail_mutex_unlock:
+	mutex_unlock(&inode_alloc->i_mutex);
+
+	iput(inode_alloc);
+	brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_freeinode(struct inode *inode,
+				struct ocfs2_info_request __user *user_req)
+{
+	int status = 0, i;
+
+	struct ocfs2_info_freeinode req_fi;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *inode_alloc = NULL;
+
+
+	if (copy_from_user(&req_fi, user_req,
+			   sizeof(struct ocfs2_info_freeinode))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	req_fi.ir_slotnum = osb->max_slots;
+
+	for (i = 0; i < req_fi.ir_slotnum; i++) {
+		inode_alloc =
+			ocfs2_get_system_file_inode(osb,
+						    INODE_ALLOC_SYSTEM_INODE,
+						    i);
+		if (!inode_alloc) {
+			mlog(ML_ERROR, "unable to get alloc inode in slot %u\n",
+			     (u32)i);
+			status = -EIO;
+			goto bail;
+		}
+
+		status = ocfs2_info_scan_inode_alloc(inode_alloc, &req_fi, i,
+						req_fi.ir_request.ir_flags);
+		if (status < 0)
+			goto bail;
+	}
+
+	req_fi.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_freeinode __user *)user_req,
+			 &req_fi,
+			 sizeof(struct ocfs2_info_freeinode))) {
+		status = -EFAULT;
+	}
+
+bail:
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_unknown(struct inode *inode,
+			      struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_request req;
+
+	if (copy_from_user(&req, user_req, sizeof(struct ocfs2_info_request))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	req.ir_flags &= ~OCFS2_INFO_FL_FILLED;
+
+	if (copy_to_user((struct ocfs2_info_request __user *)user_req, &req,
+			 sizeof(struct ocfs2_info_request))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_request(struct inode *inode,
+			      struct ocfs2_info_request __user *user_req)
+{
+	int status = 0;
+	struct ocfs2_info_request req;
+
+	if (copy_from_user(&req, user_req, sizeof(struct ocfs2_info_request))) {
+		status = -EFAULT;
+		goto bail;
+	}
+
+	if (req.ir_magic != OCFS2_INFO_MAGIC) {
+		status = -EINVAL;
+		goto bail;
+	}
+
+	switch (req.ir_code) {
+	case OCFS2_INFO_BLOCKSIZE:
+		if (req.ir_size != sizeof(struct ocfs2_info_blocksize)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_blocksize(inode, user_req);
+		break;
+	case OCFS2_INFO_CLUSTERSIZE:
+		if (req.ir_size != sizeof(struct ocfs2_info_clustersize)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_clustersize(inode, user_req);
+		break;
+	case OCFS2_INFO_SLOTNUM:
+		if (req.ir_size != sizeof(struct ocfs2_info_slotnum)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_slotnum(inode, user_req);
+		break;
+	case OCFS2_INFO_LABEL:
+		if (req.ir_size != sizeof(struct ocfs2_info_label)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_label(inode, user_req);
+		break;
+	case OCFS2_INFO_UUID:
+		if (req.ir_size != sizeof(struct ocfs2_info_uuid)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_uuid(inode, user_req);
+		break;
+	case OCFS2_INFO_FS_FEATURES:
+		if (req.ir_size != sizeof(struct ocfs2_info_fs_features)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_fs_features(inode, user_req);
+		break;
+	case OCFS2_INFO_FREEFRAG:
+		if (req.ir_size != sizeof(struct ocfs2_info_freefrag)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_freefrag(inode, user_req);
+		break;
+	case OCFS2_INFO_FREEINODE:
+		if (req.ir_size != sizeof(struct ocfs2_info_freeinode)) {
+			status = -EINVAL;
+			break;
+		}
+		status = ocfs2_info_handle_freeinode(inode, user_req);
+		break;
+	default:
+		status = ocfs2_info_handle_unknown(inode, user_req);
+		break;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info)
+{
+	int i, status = 0;
+	u64 req_addr;
+	struct ocfs2_info_request __user *reqp;
+
+	if ((info->info_count > OCFS2_INFO_MAX_REQUEST) ||
+	    (!info->info_requests)) {
+		status = -EINVAL;
+		goto bail;
+	}
+
+	for (i = 0; i < info->info_count; i++) {
+		status = -EFAULT;
+		if (get_user(req_addr, (u64 __user *)(info->info_requests) + i))
+			goto bail;
+
+		reqp = (struct ocfs2_info_request *)req_addr;
+		if (!reqp) {
+			status = -EINVAL;
+			goto bail;
+		}
+
+		status = ocfs2_info_handle_request(inode, reqp);
+		if (status)
+			goto bail;
+	}
+
+bail:
+	mlog_exit(status);
+	return status;
+}
+
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -117,6 +770,7 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	struct ocfs2_space_resv sr;
 	struct ocfs2_new_group_input input;
 	struct reflink_arguments args;
+	struct ocfs2_info info;
 	const char *old_path, *new_path;
 	bool preserve;
 
@@ -173,6 +827,12 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		preserve = (args.preserve != 0);
 
 		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
+	case OCFS2_IOC_INFO:
+		if (copy_from_user(&info, (struct ocfs2_info __user *)arg,
+				   sizeof(struct ocfs2_info)))
+			return -EFAULT;
+
+		return ocfs2_info_handle(inode, &info);
 	default:
 		return -ENOTTY;
 	}
-- 
1.5.5

From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 29 Mar 2011 10:11:25 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
	'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <1301364686-4846-1-git-send-email-tristan.ye@oracle.com>
References: <1301364686-4846-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1301364686-4846-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The new code is dedicated to calculate free inodes number of all inode_allocs,
then return the info to userpace in terms of an array.

Specially, flag 'OCFS2_INFO_FL_NON_COHERENT', manipulated by '--cluster-coherent'
from userspace, is now going to be involved. setting the flag on means no cluster
coherency considered, usually, userspace tools choose none-coherency strategy by
default for the sake of performace.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c       |  129 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/ocfs2_ioctl.h |   11 ++++
 2 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index fa09ded..ae7f89d 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -23,6 +23,9 @@
 #include "ioctl.h"
 #include "resize.h"
 #include "refcounttree.h"
+#include "sysfile.h"
+#include "dir.h"
+#include "buffer_head_io.h"
 
 #include <linux/ext2_fs.h>
 
@@ -53,6 +56,11 @@ static inline void o2info_clear_request_filled(struct ocfs2_info_request *req)
 	req->ir_flags &= ~OCFS2_INFO_FL_FILLED;
 }
 
+static inline int o2info_coherent(struct ocfs2_info_request *req)
+{
+	return (!(req->ir_flags & OCFS2_INFO_FL_NON_COHERENT));
+}
+
 static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
 {
 	int status;
@@ -312,6 +320,123 @@ bail:
 	return status;
 }
 
+int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
+				struct inode *inode_alloc, u64 blkno,
+				struct ocfs2_info_freeinode *fi, u32 slot)
+{
+	int status = 0, unlock = 0;
+
+	struct buffer_head *bh = NULL;
+	struct ocfs2_dinode *dinode_alloc = NULL;
+
+	if (inode_alloc)
+		mutex_lock(&inode_alloc->i_mutex);
+
+	if (o2info_coherent(&fi->ifi_req)) {
+		status = ocfs2_inode_lock(inode_alloc, &bh, 0);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+		unlock = 1;
+	} else {
+		status = ocfs2_read_blocks_sync(osb, blkno, 1, &bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
+	}
+
+	dinode_alloc = (struct ocfs2_dinode *)bh->b_data;
+
+	fi->ifi_stat[slot].lfi_total =
+		le32_to_cpu(dinode_alloc->id1.bitmap1.i_total);
+	fi->ifi_stat[slot].lfi_free =
+		le32_to_cpu(dinode_alloc->id1.bitmap1.i_total) -
+		le32_to_cpu(dinode_alloc->id1.bitmap1.i_used);
+
+bail:
+	if (unlock)
+		ocfs2_inode_unlock(inode_alloc, 0);
+
+	if (inode_alloc)
+		mutex_unlock(&inode_alloc->i_mutex);
+
+	brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_info_handle_freeinode(struct inode *inode,
+				struct ocfs2_info_request __user *req)
+{
+	u32 i;
+	u64 blkno = -1;
+	char namebuf[40];
+	int status = -EFAULT, type = INODE_ALLOC_SYSTEM_INODE;
+	struct ocfs2_info_freeinode *oifi = NULL;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct inode *inode_alloc = NULL;
+
+	oifi = kzalloc(sizeof(struct ocfs2_info_freeinode), GFP_KERNEL);
+	if (!oifi) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto bail;
+	}
+
+	if (o2info_from_user(*oifi, req))
+		goto bail;
+
+	oifi->ifi_slotnum = osb->max_slots;
+
+	for (i = 0; i < oifi->ifi_slotnum; i++) {
+		if (o2info_coherent(&oifi->ifi_req)) {
+			inode_alloc = ocfs2_get_system_file_inode(osb, type, i);
+			if (!inode_alloc) {
+				mlog(ML_ERROR, "unable to get alloc inode in "
+				    "slot %u\n", i);
+				status = -EIO;
+				goto bail;
+			}
+		} else {
+			ocfs2_sprintf_system_inode_name(namebuf,
+							sizeof(namebuf),
+							type, i);
+			status = ocfs2_lookup_ino_from_name(osb->sys_root_inode,
+							    namebuf,
+							    strlen(namebuf),
+							    &blkno);
+			if (status < 0) {
+				status = -ENOENT;
+				goto bail;
+			}
+		}
+
+		status = ocfs2_info_scan_inode_alloc(osb, inode_alloc, blkno, oifi, i);
+		if (status < 0)
+			goto bail;
+
+		iput(inode_alloc);
+		inode_alloc = NULL;
+	}
+
+	o2info_set_request_filled(&oifi->ifi_req);
+
+	if (o2info_to_user(*oifi, req))
+		goto bail;
+
+	status = 0;
+bail:
+	if (status)
+		o2info_set_request_error(&oifi->ifi_req, req);
+
+	kfree(oifi);
+
+	return status;
+}
+
 int ocfs2_info_handle_unknown(struct inode *inode,
 			      struct ocfs2_info_request __user *req)
 {
@@ -383,6 +508,10 @@ int ocfs2_info_handle_request(struct inode *inode,
 		if (oir.ir_size == sizeof(struct ocfs2_info_journal_size))
 			status = ocfs2_info_handle_journal_size(inode, req);
 		break;
+	case OCFS2_INFO_FREEINODE:
+		if (oir.ir_size == sizeof(struct ocfs2_info_freeinode))
+			status = ocfs2_info_handle_freeinode(inode, req);
+		break;
 	default:
 		status = ocfs2_info_handle_unknown(inode, req);
 		break;
diff --git a/fs/ocfs2/ocfs2_ioctl.h b/fs/ocfs2/ocfs2_ioctl.h
index b46f39b..6b4b39a 100644
--- a/fs/ocfs2/ocfs2_ioctl.h
+++ b/fs/ocfs2/ocfs2_ioctl.h
@@ -142,6 +142,16 @@ struct ocfs2_info_journal_size {
 	__u64 ij_journal_size;
 };
 
+struct ocfs2_info_freeinode {
+	struct ocfs2_info_request ifi_req;
+	struct ocfs2_info_local_freeinode {
+		__u64 lfi_total;
+		__u64 lfi_free;
+	} ifi_stat[OCFS2_MAX_SLOTS];
+	__u32 ifi_slotnum; /* out */
+	__u32 ifi_pad;
+};
+
 /* Codes for ocfs2_info_request */
 enum ocfs2_info_type {
 	OCFS2_INFO_CLUSTERSIZE = 1,
@@ -151,6 +161,7 @@ enum ocfs2_info_type {
 	OCFS2_INFO_UUID,
 	OCFS2_INFO_FS_FEATURES,
 	OCFS2_INFO_JOURNAL_SIZE,
+	OCFS2_INFO_FREEINODE,
 	OCFS2_INFO_NUM_TYPES
 };
 
-- 
1.5.5

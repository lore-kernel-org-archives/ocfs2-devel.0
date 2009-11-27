From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 27 Nov 2009 16:24:36 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO ioctl
	for ocfs2.
In-Reply-To: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We implement the request as simple as possible to avoid
a possible extending if disk format get changed.

Completenss of a request include the info required and a flag(FL_FILLED)
filled being returned to the end-user.

Note: the requests in a series from userspace should be NULL-terminated.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/ioctl.c |  184 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 184 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 31fbb06..0ac5218 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -108,6 +108,188 @@ bail:
 	return status;
 }
 
+static int ocfs2_get_request_info(struct inode *inode,
+				  unsigned long arg)
+{
+
+	int ret = 0, i = 0, num_reqs = 0;
+
+	struct ocfs2_info_request req, *preq = NULL;
+	struct ocfs2_info_request **reqs;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	typedef struct ocfs2_info_request OIR, *POIR;
+	typedef struct ocfs2_info_request_clustersize OIRC, *POIRC;
+	typedef struct ocfs2_info_request_blocksize OIRB, *POIRB;
+	typedef struct ocfs2_info_request_slotnum OIRS, *POIRS;
+	typedef struct ocfs2_info_request_label OIRL, *POIRL;
+	typedef struct ocfs2_info_request_uuid OIRU, *POIRU;
+	typedef struct ocfs2_info_request_fs_features OIRF, *POIRF;
+
+	/*
+	 * The requests series from userspace need to be NULL-terminated.
+	 */
+	do {
+		preq = *((POIR *)((char *)arg + i * sizeof(POIR)));
+		if (!preq)
+			break;
+		i++;
+
+	} while (preq);
+
+	num_reqs = i;
+
+	reqs = kmalloc(sizeof(POIR) * num_reqs, GFP_KERNEL);
+	if (!reqs) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
+	ret = ocfs2_inode_lock(inode, NULL, 0);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	for (i = 0; i < num_reqs; i++) {
+
+		reqs[i] = NULL;
+
+		preq = *((POIR *)((char *)arg + i * sizeof(POIR)));
+
+		if (copy_from_user(&req, preq, sizeof(req))) {
+			ret = -EFAULT;
+			goto bail;
+		}
+
+		switch (req.ir_code) {
+		case OCFS2_INFO_CLUSTERSIZE:
+			reqs[i] = kmalloc(sizeof(OIRC), GFP_KERNEL);
+
+			if (copy_from_user(reqs[i], preq, sizeof(OIRC))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			((POIRC)(reqs[i]))->ir_clustersize = osb->s_clustersize;
+			reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
+
+			if (copy_to_user(preq, reqs[i], sizeof(OIRC))) {
+				ret = EFAULT;
+				goto bail;
+			}
+
+			break;
+		case OCFS2_INFO_BLOCKSIZE:
+			reqs[i] = kmalloc(sizeof(OIRB), GFP_KERNEL);
+
+			if (copy_from_user(reqs[i], preq, sizeof(OIRB))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			((POIRB)(reqs[i]))->ir_blocksize =
+					inode->i_sb->s_blocksize;
+			reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
+
+			if (copy_to_user(preq, reqs[i], sizeof(OIRB))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			break;
+		case OCFS2_INFO_SLOTNUM:
+			reqs[i] = kmalloc(sizeof(OIRS), GFP_KERNEL);
+
+			if (copy_from_user(reqs[i], preq, sizeof(OIRS))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			((POIRS)(reqs[i]))->ir_slotnum = osb->max_slots;
+			reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
+
+			if (copy_to_user(preq, reqs[i], sizeof(OIRS))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			break;
+		case OCFS2_INFO_LABEL:
+			reqs[i] = kmalloc(sizeof(OIRL), GFP_KERNEL);
+
+			if (copy_from_user(reqs[i], preq, sizeof(OIRL))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			memmove(((POIRL)(reqs[i]))->ir_label, osb->vol_label,
+				OCFS2_MAX_VOL_LABEL_LEN);
+			reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
+
+			if (copy_to_user(preq, reqs[i], sizeof(OIRL))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			break;
+		case OCFS2_INFO_UUID:
+			reqs[i] = kmalloc(sizeof(OIRU), GFP_KERNEL);
+
+			if (copy_from_user(reqs[i], preq, sizeof(OIRU))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			memmove(((POIRU)(reqs[i]))->ir_uuid, osb->uuid,
+				OCFS2_VOL_UUID_LEN);
+			reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
+
+			if (copy_to_user(preq, reqs[i], sizeof(OIRU))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			break;
+		case OCFS2_INFO_FS_FEATURES:
+			reqs[i] = kmalloc(sizeof(OIRF), GFP_KERNEL);
+
+			if (copy_from_user(reqs[i], preq, sizeof(OIRF))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			((POIRF)(reqs[i]))->ir_compat_features =
+						osb->s_feature_compat;
+			((POIRF)(reqs[i]))->ir_incompat_features =
+						osb->s_feature_incompat;
+			((POIRF)(reqs[i]))->ir_ro_compat_features =
+						osb->s_feature_ro_compat;
+			reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
+
+			if (copy_to_user(preq, reqs[i], sizeof(OIRF))) {
+				ret = -EFAULT;
+				goto bail;
+			}
+
+			break;
+		default:
+			break;
+		}
+
+	}
+bail:
+	for (i = 0; i < num_reqs; i++)
+		kfree(reqs[i]);
+
+	kfree(reqs);
+
+	ocfs2_inode_unlock(inode, 0);
+
+	mlog_exit(ret);
+	return ret;
+}
+
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -173,6 +355,8 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		preserve = (args.preserve != 0);
 
 		return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
+	case OCFS2_IOC_INFO:
+		return ocfs2_get_request_info(inode, arg);
 	default:
 		return -ENOTTY;
 	}
-- 
1.5.5

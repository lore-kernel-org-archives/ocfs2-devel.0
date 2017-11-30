From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:24:36 -0800
Subject: [Ocfs2-devel] [patch 09/11] ocfs2: add ocfs2_try_rw_lock() and
 ocfs2_try_inode_lock()
Message-ID: <5a208524.YNjds5YG/DJrjcbf%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Gang He <ghe@suse.com>
Subject: ocfs2: add ocfs2_try_rw_lock() and ocfs2_try_inode_lock()

Patch series "ocfs2: add nowait aio support".

VFS layer has introduced the non-blocking aio flag IOCB_NOWAIT, which
tells the kernel to bail out if an AIO request will block for reasons such
as file allocations, or writeback triggering, or would block while
allocating requests while performing direct I/O.

Subsequently, pwritev2/preadv2 also can leverage this part of kernel code.
So far, ext4/xfs/btrfs have supported this feature.  Add the related code
for the ocfs2 file system.  


This patch (of 3):

Add ocfs2_try_rw_lock and ocfs2_try_inode_lock functions, which will be
used in non-blocking IO scenarios.

[ghe at suse.com: v2]
  Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1511944612-2D9629-2D2-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=W4UpDjVlWv5DIIPCelEteB-SienntqWxnPDHSOG7DBo&s=O9wstNpVrzaQNqjJyE21XFRb16ul0wQp9AtfJ4Jr9hI&e=
Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1511775987-2D841-2D2-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=W4UpDjVlWv5DIIPCelEteB-SienntqWxnPDHSOG7DBo&s=fhdJtmG-qeTxswCoTvc42Is_mJIFHda4B0pHag4jzFk&e=
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |   21 +++++++++++++++++++++
 fs/ocfs2/dlmglue.h |    4 ++++
 2 files changed, 25 insertions(+)

diff -puN fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock
+++ a/fs/ocfs2/dlmglue.c
@@ -1742,6 +1742,27 @@ int ocfs2_rw_lock(struct inode *inode, i
 	return status;
 }
 
+int ocfs2_try_rw_lock(struct inode *inode, int write)
+{
+	int status, level;
+	struct ocfs2_lock_res *lockres;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	mlog(0, "inode %llu try to take %s RW lock\n",
+	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
+	     write ? "EXMODE" : "PRMODE");
+
+	if (ocfs2_mount_local(osb))
+		return 0;
+
+	lockres = &OCFS2_I(inode)->ip_rw_lockres;
+
+	level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
+
+	status = ocfs2_cluster_lock(osb, lockres, level, DLM_LKF_NOQUEUE, 0);
+	return status;
+}
+
 void ocfs2_rw_unlock(struct inode *inode, int write)
 {
 	int level = write ? DLM_LOCK_EX : DLM_LOCK_PR;
diff -puN fs/ocfs2/dlmglue.h~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock fs/ocfs2/dlmglue.h
--- a/fs/ocfs2/dlmglue.h~ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock
+++ a/fs/ocfs2/dlmglue.h
@@ -116,6 +116,7 @@ void ocfs2_lock_res_free(struct ocfs2_lo
 int ocfs2_create_new_inode_locks(struct inode *inode);
 int ocfs2_drop_inode_locks(struct inode *inode);
 int ocfs2_rw_lock(struct inode *inode, int write);
+int ocfs2_try_rw_lock(struct inode *inode, int write);
 void ocfs2_rw_unlock(struct inode *inode, int write);
 int ocfs2_open_lock(struct inode *inode);
 int ocfs2_try_open_lock(struct inode *inode, int write);
@@ -140,6 +141,9 @@ int ocfs2_inode_lock_with_page(struct in
 /* 99% of the time we don't want to supply any additional flags --
  * those are for very specific cases only. */
 #define ocfs2_inode_lock(i, b, e) ocfs2_inode_lock_full_nested(i, b, e, 0, OI_LS_NORMAL)
+#define ocfs2_try_inode_lock(i, b, e)\
+		ocfs2_inode_lock_full_nested(i, b, e, OCFS2_META_LOCK_NOQUEUE,\
+		OI_LS_NORMAL)
 void ocfs2_inode_unlock(struct inode *inode,
 		       int ex);
 int ocfs2_super_lock(struct ocfs2_super *osb,
_

From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:31:31 +0100
Subject: [Ocfs2-devel] [PATCH 06/10] quota: Unexport dqblk_v1.h and
	dqblk_v2.h
In-Reply-To: <1227623495-16708-5-git-send-email-jack@suse.cz>
References: <y> <1227623495-16708-1-git-send-email-jack@suse.cz>
	<1227623495-16708-2-git-send-email-jack@suse.cz>
	<1227623495-16708-3-git-send-email-jack@suse.cz>
	<1227623495-16708-4-git-send-email-jack@suse.cz>
	<1227623495-16708-5-git-send-email-jack@suse.cz>
Message-ID: <1227623495-16708-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Unexport header files dqblk_v[12].h since except for quota format ID they
don't contain information userspace should be interested in. Move ID
definitions to quota.h.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/Kbuild     |    2 --
 include/linux/dqblk_v1.h |    3 ---
 include/linux/dqblk_v2.h |    3 ---
 include/linux/quota.h    |    4 ++++
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 0fd2da3..4c32642 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -56,8 +56,6 @@ header-y += dlm_device.h
 header-y += dlm_netlink.h
 header-y += dm-ioctl.h
 header-y += dn.h
-header-y += dqblk_v1.h
-header-y += dqblk_v2.h
 header-y += dqblk_xfs.h
 header-y += efs_fs_sb.h
 header-y += elf-fdpic.h
diff --git a/include/linux/dqblk_v1.h b/include/linux/dqblk_v1.h
index 9cea901..3713a72 100644
--- a/include/linux/dqblk_v1.h
+++ b/include/linux/dqblk_v1.h
@@ -5,9 +5,6 @@
 #ifndef _LINUX_DQBLK_V1_H
 #define _LINUX_DQBLK_V1_H
 
-/* Id of quota format */
-#define QFMT_VFS_OLD 1
-
 /* Root squash turned on */
 #define V1_DQF_RSQUASH 1
 
diff --git a/include/linux/dqblk_v2.h b/include/linux/dqblk_v2.h
index ff8af1b..18000a5 100644
--- a/include/linux/dqblk_v2.h
+++ b/include/linux/dqblk_v2.h
@@ -7,9 +7,6 @@
 
 #include <linux/dqblk_qtree.h>
 
-/* Id number of quota format */
-#define QFMT_VFS_V0 2
-
 /* Numbers of blocks needed for updates */
 #define V2_INIT_ALLOC QTREE_INIT_ALLOC
 #define V2_INIT_REWRITE QTREE_INIT_REWRITE
diff --git a/include/linux/quota.h b/include/linux/quota.h
index ec82beb..d72d5d8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -70,6 +70,10 @@
 #define Q_GETQUOTA 0x800007	/* get user quota structure */
 #define Q_SETQUOTA 0x800008	/* set user quota structure */
 
+/* Quota format type IDs */
+#define	QFMT_VFS_OLD 1
+#define	QFMT_VFS_V0 2
+
 /* Size of block in which space limits are passed through the quota
  * interface */
 #define QIF_DQBLKSIZE_BITS 10
-- 
1.6.0.4

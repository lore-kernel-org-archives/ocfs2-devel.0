From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 14 Aug 2019 22:42:31 +0200
Subject: [Ocfs2-devel] [PATCH v5 04/18] fs: compat_ioctl: move FITRIM
	emulation into file systems
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
Message-ID: <20190814204259.120942-5-arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, yangerkun <yangerkun@huawei.com>, Jan Kara <jack@suse.cz>, Wang Shilong <wshilong@ddn.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, Eric Biggers <ebiggers@google.com>, ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com

Remove the special case for FITRIM, and make file systems
handle that like all other ioctl commands with their own
handlers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c  | 2 --
 fs/ecryptfs/file.c | 1 +
 fs/ext4/ioctl.c    | 1 +
 fs/f2fs/file.c     | 1 +
 fs/hpfs/dir.c      | 1 +
 fs/hpfs/file.c     | 1 +
 fs/nilfs2/ioctl.c  | 1 +
 fs/ocfs2/ioctl.c   | 1 +
 8 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 1e740f4406d3..b20228c19ccd 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -345,8 +345,6 @@ static int ppp_scompress(struct file *file, unsigned int cmd,
 static unsigned int ioctl_pointer[] = {
 /* Little t */
 COMPATIBLE_IOCTL(TIOCOUTQ)
-/* 'X' - originally XFS but some now in the VFS */
-COMPATIBLE_IOCTL(FITRIM)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index feecb57defa7..5fb45d865ce5 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -378,6 +378,7 @@ ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return rc;
 
 	switch (cmd) {
+	case FITRIM:
 	case FS_IOC32_GETFLAGS:
 	case FS_IOC32_SETFLAGS:
 	case FS_IOC32_GETVERSION:
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 442f7ef873fc..7a6e0f0f69e2 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1227,6 +1227,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 	case EXT4_IOC_MOVE_EXT:
 	case EXT4_IOC_RESIZE_FS:
+	case FITRIM:
 	case EXT4_IOC_PRECACHE_EXTENTS:
 	case EXT4_IOC_SET_ENCRYPTION_POLICY:
 	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3e58a6f697dd..befd2692160c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3216,6 +3216,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC_RELEASE_VOLATILE_WRITE:
 	case F2FS_IOC_ABORT_VOLATILE_WRITE:
 	case F2FS_IOC_SHUTDOWN:
+	case FITRIM:
 	case F2FS_IOC_SET_ENCRYPTION_POLICY:
 	case F2FS_IOC_GET_ENCRYPTION_PWSALT:
 	case F2FS_IOC_GET_ENCRYPTION_POLICY:
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index d85230c84ef2..f32f15669996 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -325,4 +325,5 @@ const struct file_operations hpfs_dir_ops =
 	.release	= hpfs_dir_release,
 	.fsync		= hpfs_file_fsync,
 	.unlocked_ioctl	= hpfs_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 1ecec124e76f..b36abf9cb345 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -215,6 +215,7 @@ const struct file_operations hpfs_file_ops =
 	.fsync		= hpfs_file_fsync,
 	.splice_read	= generic_file_splice_read,
 	.unlocked_ioctl	= hpfs_ioctl,
+	.compat_ioctl	= compat_ptr_ioctl,
 };
 
 const struct inode_operations hpfs_file_iops =
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 91b9dac6b2cc..4ba73dbf3e8d 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1354,6 +1354,7 @@ long nilfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case NILFS_IOCTL_SYNC:
 	case NILFS_IOCTL_RESIZE:
 	case NILFS_IOCTL_SET_ALLOC_RANGE:
+	case FITRIM:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index d6f7b299eb23..2d517b5ec6ac 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -985,6 +985,7 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			return -EFAULT;
 
 		return ocfs2_info_handle(inode, &info, 1);
+	case FITRIM:
 	case OCFS2_IOC_MOVE_EXT:
 		break;
 	default:
-- 
2.20.0

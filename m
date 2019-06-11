From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Mon, 10 Jun 2019 21:47:01 -0700
Subject: [Ocfs2-devel] [PATCH 6/6] xfs: clean up xfs_merge_ioc_xflags
In-Reply-To: <156022836912.3227213.13598042497272336695.stgit@magnolia>
References: <156022836912.3227213.13598042497272336695.stgit@magnolia>
Message-ID: <156022842153.3227213.3285668171167534801.stgit@magnolia>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clean up the calling convention since we're editing the fsxattr struct
anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7b19ba2956ad..a67bc9afdd0b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -829,35 +829,31 @@ xfs_ioc_ag_geometry(
  * Linux extended inode flags interface.
  */
 
-STATIC unsigned int
+static inline void
 xfs_merge_ioc_xflags(
-	unsigned int	flags,
-	unsigned int	start)
+	struct fsxattr	*fa,
+	unsigned int	flags)
 {
-	unsigned int	xflags = start;
-
 	if (flags & FS_IMMUTABLE_FL)
-		xflags |= FS_XFLAG_IMMUTABLE;
+		fa->fsx_xflags |= FS_XFLAG_IMMUTABLE;
 	else
-		xflags &= ~FS_XFLAG_IMMUTABLE;
+		fa->fsx_xflags &= ~FS_XFLAG_IMMUTABLE;
 	if (flags & FS_APPEND_FL)
-		xflags |= FS_XFLAG_APPEND;
+		fa->fsx_xflags |= FS_XFLAG_APPEND;
 	else
-		xflags &= ~FS_XFLAG_APPEND;
+		fa->fsx_xflags &= ~FS_XFLAG_APPEND;
 	if (flags & FS_SYNC_FL)
-		xflags |= FS_XFLAG_SYNC;
+		fa->fsx_xflags |= FS_XFLAG_SYNC;
 	else
-		xflags &= ~FS_XFLAG_SYNC;
+		fa->fsx_xflags &= ~FS_XFLAG_SYNC;
 	if (flags & FS_NOATIME_FL)
-		xflags |= FS_XFLAG_NOATIME;
+		fa->fsx_xflags |= FS_XFLAG_NOATIME;
 	else
-		xflags &= ~FS_XFLAG_NOATIME;
+		fa->fsx_xflags &= ~FS_XFLAG_NOATIME;
 	if (flags & FS_NODUMP_FL)
-		xflags |= FS_XFLAG_NODUMP;
+		fa->fsx_xflags |= FS_XFLAG_NODUMP;
 	else
-		xflags &= ~FS_XFLAG_NODUMP;
-
-	return xflags;
+		fa->fsx_xflags &= ~FS_XFLAG_NODUMP;
 }
 
 STATIC unsigned int
@@ -1504,7 +1500,7 @@ xfs_ioc_setxflags(
 		return -EOPNOTSUPP;
 
 	__xfs_ioc_fsgetxattr(ip, false, &fa);
-	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, fa.fsx_xflags);
+	xfs_merge_ioc_xflags(&fa, flags);
 
 	error = mnt_want_write_file(filp);
 	if (error)

From: Fabian Frederick <fabf@skynet.be>
Date: Sun, 21 May 2017 17:42:17 +0200
Subject: [Ocfs2-devel] [PATCH 07/11 linux-next] ocfs2: use magic.h
Message-ID: <20170521154217.27917-1-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mark Fasheh <mfasheh@versity.com>, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, fabf@skynet.be

Filesystems generally use SUPER_MAGIC values from magic.h
instead of a local definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/ocfs2_fs.h        | 5 ++---
 include/uapi/linux/magic.h | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 44d178b..5bb4a89 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -25,6 +25,8 @@
 #ifndef _OCFS2_FS_H
 #define _OCFS2_FS_H
 
+#include <linux/magic.h>
+
 /* Version */
 #define OCFS2_MAJOR_REV_LEVEL		0
 #define OCFS2_MINOR_REV_LEVEL          	90
@@ -56,9 +58,6 @@
 #define OCFS2_MIN_BLOCKSIZE		512
 #define OCFS2_MAX_BLOCKSIZE		OCFS2_MIN_CLUSTERSIZE
 
-/* Filesystem magic number */
-#define OCFS2_SUPER_MAGIC		0x7461636f
-
 /* Object signatures */
 #define OCFS2_SUPER_BLOCK_SIGNATURE	"OCFSV2"
 #define OCFS2_INODE_SIGNATURE		"INODE01"
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 905eaa2..2621eaf 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -47,6 +47,7 @@
 #define NFS_SUPER_MAGIC		0x6969
 #define NILFS_SUPER_MAGIC	0x3434
 #define NSFS_MAGIC		0x6e736673
+#define OCFS2_SUPER_MAGIC	0x7461636f
 #define OPENPROM_SUPER_MAGIC	0x9fa1
 #define ORANGEFS_SUPER_MAGIC	0x20030528
 #define OVERLAYFS_SUPER_MAGIC	0x794c7630
-- 
2.9.3

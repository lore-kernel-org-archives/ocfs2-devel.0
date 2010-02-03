From: Tao Ma <tao.ma@oracle.com>
Date: Wed,  3 Feb 2010 14:01:00 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: move OCFS2_SUPER_MAGIC to
	include/linux/magic.h
Message-ID: <1265176860-24630-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Tao Ma <tao.ma@oracle.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com

move OCFS2_SUPER_MAGIC to include/linux/magic.h

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel at oss.oracle.com
---
 fs/ocfs2/ocfs2_fs.h   |    3 ---
 fs/ocfs2/super.c      |    1 +
 include/linux/magic.h |    1 +
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 1a1a679..c3cab28 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -56,9 +56,6 @@
 #define OCFS2_MIN_BLOCKSIZE		512
 #define OCFS2_MAX_BLOCKSIZE		OCFS2_MIN_CLUSTERSIZE
 
-/* Filesystem magic number */
-#define OCFS2_SUPER_MAGIC		0x7461636f
-
 /* Object signatures */
 #define OCFS2_SUPER_BLOCK_SIGNATURE	"OCFSV2"
 #define OCFS2_INODE_SIGNATURE		"INODE01"
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 2606991..8d72e12 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -42,6 +42,7 @@
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
 #include <linux/smp_lock.h>
+#include <linux/magic.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 76285e0..e27b13c 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -36,6 +36,7 @@
 #define MSDOS_SUPER_MAGIC	0x4d44		/* MD */
 #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
 #define NFS_SUPER_MAGIC		0x6969
+#define OCFS2_SUPER_MAGIC	0x7461636f
 #define OPENPROM_SUPER_MAGIC	0x9fa1
 #define PROC_SUPER_MAGIC	0x9fa0
 #define QNX4_SUPER_MAGIC	0x002f		/* qnx4 fs detection */
-- 
1.5.5

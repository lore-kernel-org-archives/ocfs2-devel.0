From: Tao Ma <tm@tao.ma>
Date: Thu, 23 Dec 2010 15:30:52 +0800
Subject: [Ocfs2-devel] [PATCH 09/34] ocfs2: Remove DISK_ALLOC from masklog.
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <1293089477-5019-9-git-send-email-tm@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Tao Ma <tao.ma@oracle.com>

Since all 4 files, localalloc.c, suballoc.c, alloc.c and
resize.c, which use DISK_ALLOC are changed to trace events,
Remove masklog DISK_ALLOC totally.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c           |    1 -
 fs/ocfs2/cluster/masklog.c |    1 -
 fs/ocfs2/cluster/masklog.h |    1 -
 fs/ocfs2/localalloc.c      |    1 -
 fs/ocfs2/resize.c          |    1 -
 fs/ocfs2/suballoc.c        |    1 -
 6 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 9bdfaf8..fc2105c 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -30,7 +30,6 @@
 #include <linux/swap.h>
 #include <linux/quotaops.h>
 
-#define MLOG_MASK_PREFIX ML_DISK_ALLOC
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 41260fb..b395c6a 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -93,7 +93,6 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(DLM_RECOVERY),
 	define_mask(AIO),
 	define_mask(JOURNAL),
-	define_mask(DISK_ALLOC),
 	define_mask(SUPER),
 	define_mask(FILE_IO),
 	define_mask(EXTENT_MAP),
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 707e119..70df956 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -95,7 +95,6 @@
 #define ML_DLM_RECOVERY	0x0000000000001000ULL /* dlm master functions */
 #define ML_AIO		0x0000000000002000ULL /* ocfs2 aio read and write */
 #define ML_JOURNAL	0x0000000000004000ULL /* ocfs2 journalling functions */
-#define ML_DISK_ALLOC	0x0000000000008000ULL /* ocfs2 disk allocation */
 #define ML_SUPER	0x0000000000010000ULL /* ocfs2 mount / umount */
 #define ML_FILE_IO	0x0000000000020000ULL /* ocfs2 file I/O */
 #define ML_EXTENT_MAP	0x0000000000040000ULL /* ocfs2 extent map caching */
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index a311b1f..210c352 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -29,7 +29,6 @@
 #include <linux/highmem.h>
 #include <linux/bitops.h>
 
-#define MLOG_MASK_PREFIX ML_DISK_ALLOC
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 761d20d..ec55add 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -27,7 +27,6 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
-#define MLOG_MASK_PREFIX ML_DISK_ALLOC
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index f656e81..c4ebfe7 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 
-#define MLOG_MASK_PREFIX ML_DISK_ALLOC
 #include <cluster/masklog.h>
 
 #include "ocfs2.h"
-- 
1.7.0.4

From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  6 Nov 2009 14:50:22 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Trivial cleanup of jbd
	compatibility layer removal
Message-ID: <1257547822-4246-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 53ef99cad9878f02f27bb30bc304fc42af8bdd6e removed the
JBD compatibility layer from OCFS2. This patch removes the last remaining
remnants of that.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/ocfs2.h    |    7 +------
 fs/ocfs2/uptodate.c |    5 -----
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index eae4046..d963d86 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -35,12 +35,7 @@
 #include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/lockdep.h>
-#ifndef CONFIG_OCFS2_COMPAT_JBD
-# include <linux/jbd2.h>
-#else
-# include <linux/jbd.h>
-# include "ocfs2_jbd_compat.h"
-#endif
+#include <linux/jbd2.h>
 
 /* For union ocfs2_dlm_lksb */
 #include "stackglue.h"
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index b6284f2..c613693 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -53,11 +53,6 @@
 #include <linux/highmem.h>
 #include <linux/buffer_head.h>
 #include <linux/rbtree.h>
-#ifndef CONFIG_OCFS2_COMPAT_JBD
-# include <linux/jbd2.h>
-#else
-# include <linux/jbd.h>
-#endif
 
 #define MLOG_MASK_PREFIX ML_UPTODATE
 
-- 
1.6.3.3

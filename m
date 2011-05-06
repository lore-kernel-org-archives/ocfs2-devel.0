From: Robin Dong <hao.bigrat@gmail.com>
Date: Fri, 06 May 2011 08:02:58 -0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: change incorrect 'extern' keyword to
	'static' in dlmfs
Message-ID: <1304668900-20573-1-git-send-email-sanbai@taobao.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Change function param_set_dlmfs_capabilities from 'extern' to 'static' since
function param_get_dlmfs_capabilities is also 'static'.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index b2df490..dd2675e 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -88,7 +88,7 @@ struct workqueue_struct *user_dlm_worker;
  *		  signifies a bast fired on the lock.
  */
 #define DLMFS_CAPABILITIES "bast stackglue"
-extern int param_set_dlmfs_capabilities(const char *val,
+static int param_set_dlmfs_capabilities(const char *val,
 					struct kernel_param *kp)
 {
 	printk(KERN_ERR "%s: readonly parameter\n", kp->name);
-- 
1.7.1

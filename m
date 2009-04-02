From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:45 +0800
Subject: [Ocfs2-devel] [PATCH 06/42] ocfs2: hook remove refcount tree into
	truncate.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-6-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index c63a7c5..9088d7b 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -51,6 +51,7 @@
 #include "xattr.h"
 
 #include "buffer_head_io.h"
+#include "refcounttree.h"
 
 
 /*
@@ -7295,6 +7296,10 @@ start:
 	goto start;
 
 bail:
+	if (!status && OCFS2_I(inode)->ip_clusters == 0) {
+		/* remove the refcount tree. */
+		status = ocfs2_remove_refcount_tree(inode, fe_bh);
+	}
 
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 
-- 
1.6.2.rc2.16.gf474c

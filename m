From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 26 Jul 2012 13:05:10 -0000
Subject: [Ocfs2-devel] [patch] ocfs2/dlm: use GFP_ATOMIC inside a spin_lock
Message-ID: <20120726130505.GA30865@elgon.mountain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

My static checker complains that this is called with a spin_lock held
in dlm_master_requery_handler() from dlmrecovery.c.  Probably the reason
we have not received any bug reports about this is that recovery is not
a common operation.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..33ecbe0 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2020,7 +2020,7 @@ int dlm_dispatch_assert_master(struct dlm_ctxt *dlm,
 			       int ignore_higher, u8 request_from, u32 flags)
 {
 	struct dlm_work_item *item;
-	item = kzalloc(sizeof(*item), GFP_NOFS);
+	item = kzalloc(sizeof(*item), GFP_ATOMIC);
 	if (!item)
 		return -ENOMEM;
 

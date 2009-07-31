From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 31 Jul 2009 14:28:02 -0500
Subject: [Ocfs2-devel] [PATCH] Remove redundant BUG_ON in __dlm_queue_ast
Message-ID: <20090731192802.GA13139@baloo.cartoons>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

    Remove redundant BUG_ON()

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
---

diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index d07ddbe..81eff8e 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -103,7 +103,6 @@ static void __dlm_queue_ast(struct dlm_ctxt *dlm, struct dlm_lock *lock)
 		     lock->ast_pending, lock->ml.type);
 		BUG();
 	}
-	BUG_ON(!list_empty(&lock->ast_list));
 	if (lock->ast_pending)
 		mlog(0, "lock has an ast getting flushed right now\n");
 

-- 
Goldwyn

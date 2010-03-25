From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 25 Mar 2010 23:51:03 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove a useless statement
Message-ID: <201003251552.o2PFqg0O005532@rcsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When we are downconvert a lock to NL from PR, we don't need access lvb. So we
clear LKM_VALBLK from _flags_ in __dlmconvert_master(). While we don't check
LKM_VALBLK on _flags_ any more and _flags_ is never passed to any other
function. Thus the clearing statement is useless though harmless. For making
code clean, I made this patch to remove the useless statement.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmconvert.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index f283bce..44b40a8 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -173,7 +173,6 @@ static enum dlm_status __dlmconvert_master(struct dlm_ctxt *dlm,
 					     "into lvb: converting %s->%s\n",
 					     dlm_lock_mode_name(lock->ml.type),
 					     dlm_lock_mode_name(type));
-					flags &= ~(LKM_VALBLK);
 				}
 				break;
 		}
-- 
1.6.6.1

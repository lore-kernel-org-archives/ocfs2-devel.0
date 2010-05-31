From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 31 May 2010 14:43:10 -0400
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: print lockres under spin lock
Message-ID: <201005311047.o4VAlbJC019347@rcsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

print lockres under lockres->spinlock.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmconvert.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmconvert.c b/fs/ocfs2/dlm/dlmconvert.c
index 9f30491..a0edf7e 100644
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -235,10 +235,10 @@ switch_queues:
 	list_move_tail(&lock->list, &res->converting);
 
 unlock_exit:
-	spin_unlock(&lock->spinlock);
 	if (status == DLM_DENIED) {
 		__dlm_print_one_lock_resource(res);
 	}
+	spin_unlock(&lock->spinlock);
 	if (status == DLM_NORMAL)
 		*kick_thread = 1;
 	return status;
-- 
1.6.6.1

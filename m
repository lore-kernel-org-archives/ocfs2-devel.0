From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 3 Sep 2009 15:56:33 +0800
Subject: [Ocfs2-devel] [PATCH 1/1]ocfs2: add spinlock protection when
	dealing with lockres->purge.
Message-ID: <200909030758.n837wl02001895@rgminet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

when we check/modify lockres->purge, we should with the protection of lockres->spinlock.
in dlm_purge_lockres(), the checking/modifying is not with the protectin.
this patch fixes it.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmthread.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index d490b66..98569e8 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -212,14 +212,18 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 		spin_lock(&dlm->spinlock);
 	}
 
+	spin_lock(&res->spinlock);
 	if (!list_empty(&res->purge)) {
 		mlog(0, "removing lockres %.*s:%p from purgelist, "
 		     "master = %d\n", res->lockname.len, res->lockname.name,
 		     res, master);
 		list_del_init(&res->purge);
+		spin_unlock(&res->spinlock);
 		dlm_lockres_put(res);
 		dlm->purge_count--;
-	}
+	} else
+		spin_unlock(&res->spinlock);
+
 	__dlm_unhash_lockres(res);
 
 	/* lockres is not in the hash now.  drop the flag and wake up
-- 
1.6.2.5

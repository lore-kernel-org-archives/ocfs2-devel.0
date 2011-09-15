From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 15 Sep 2011 10:06:42 +0800
Subject: [Ocfs2-devel] [PATCH] Wakeup down-convert thread just after
	clearing OCFS2_LOCK_UPCONVERT_FINISHING -v2
Message-ID: <201109150206.p8F26atI019193@acsmt358.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In down convert thread, when the ocfs2_lock_res is in OCFS2_LOCK_UPCONVERT_FINISHING
state, it is requeued for next run of ocfs2_downconvert_thread_do_work(). If not
waked up, the DC thread just sleep there without even there are ocfs2_lock_res' left
in the list.

So when clearing the OCFS2_LOCK_UPCONVERT_FINISHING flag, we need also to wake up dc
thread accordingly.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..a2e8278 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1206,6 +1206,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
 	wake_up(&lockres->l_event);
+	ocfs2_wake_downconvert_thread(ocfs2_get_lockres_osb(lockres));
 }
 
 /* Note: If we detect another process working on the lock (i.e.,
@@ -1502,6 +1503,7 @@ unlock:
 	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
 
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
+	ocfs2_wake_downconvert_thread(osb);
 out:
 	/*
 	 * This is helping work around a lock inversion between the page lock
-- 
1.7.5.2

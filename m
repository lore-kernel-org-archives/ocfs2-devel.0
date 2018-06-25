From: Ashish Samant <ashish.samant@oracle.com>
Date: Mon, 25 Jun 2018 11:26:32 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Fix locking for res->tracking and
	dlm->tracking_list
Message-ID: <1529951192-4686-1-git-send-email-ashish.samant@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_init_lockres() we access and modify res->tracking and
dlm->tracking_list without holding dlm->track_lock. This can cause list
corruptions and can end up in kernel panic.

Fix this by locking res->tracking and dlm->tracking_list with
dlm->track_lock instead of dlm->spinlock.

Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
CC: stable at vger.kernel.org
---
 fs/ocfs2/dlm/dlmmaster.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index aaca094..826f056 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -584,9 +584,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
 
 	res->last_used = 0;
 
-	spin_lock(&dlm->spinlock);
+	spin_lock(&dlm->track_lock);
 	list_add_tail(&res->tracking, &dlm->tracking_list);
-	spin_unlock(&dlm->spinlock);
+	spin_unlock(&dlm->track_lock);
 
 	memset(res->lvb, 0, DLM_LVB_LEN);
 	memset(res->refmap, 0, sizeof(res->refmap));
-- 
1.9.1

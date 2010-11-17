From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 18 Nov 2010 00:22:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: another miss of setting
	DLM_LOCK_RES_IN_PROGRESS
Message-ID: <201011171624.oAH75GsW002380@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Another miss of setting DLM_LOCK_RES_IN_PROGRESS.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlm/dlmlock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 69cf369..701dcee 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -139,6 +139,8 @@ static enum dlm_status dlmlock_master(struct dlm_ctxt *dlm,
 		return status;
 	}
 	__dlm_wait_on_lockres(res);
+	res->state |= DLM_LOCK_RES_IN_PROGRESS;
+
 	__dlm_lockres_reserve_ast(res);
 
 	if (dlm_can_grant_new_lock(res, lock)) {
-- 
1.7.2.3

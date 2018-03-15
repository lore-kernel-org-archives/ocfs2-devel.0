From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 15 Mar 2018 20:24:40 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/dlm: clean up unused argument for
	dlm_destroy_recovery_area()
Message-ID: <1521116681-14602-1-git-send-email-ge.changwei@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index ec8f758..b36808c 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -62,7 +62,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node);
 static int dlm_init_recovery_area(struct dlm_ctxt *dlm, u8 dead_node);
 static int dlm_request_all_locks(struct dlm_ctxt *dlm,
 				 u8 request_from, u8 dead_node);
-static void dlm_destroy_recovery_area(struct dlm_ctxt *dlm, u8 dead_node);
+static void dlm_destroy_recovery_area(struct dlm_ctxt *dlm);
 
 static inline int dlm_num_locks_in_lockres(struct dlm_lock_resource *res);
 static void dlm_init_migratable_lockres(struct dlm_migratable_lockres *mres,
@@ -739,7 +739,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8 dead_node)
 	}
 
 	if (destroy)
-		dlm_destroy_recovery_area(dlm, dead_node);
+		dlm_destroy_recovery_area(dlm);
 
 	return status;
 }
@@ -764,7 +764,7 @@ static int dlm_init_recovery_area(struct dlm_ctxt *dlm, u8 dead_node)
 
 		ndata = kzalloc(sizeof(*ndata), GFP_NOFS);
 		if (!ndata) {
-			dlm_destroy_recovery_area(dlm, dead_node);
+			dlm_destroy_recovery_area(dlm);
 			return -ENOMEM;
 		}
 		ndata->node_num = num;
@@ -778,7 +778,7 @@ static int dlm_init_recovery_area(struct dlm_ctxt *dlm, u8 dead_node)
 	return 0;
 }
 
-static void dlm_destroy_recovery_area(struct dlm_ctxt *dlm, u8 dead_node)
+static void dlm_destroy_recovery_area(struct dlm_ctxt *dlm)
 {
 	struct dlm_reco_node_data *ndata, *next;
 	LIST_HEAD(tmplist);
-- 
2.7.4

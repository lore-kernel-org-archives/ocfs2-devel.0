From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 17 Apr 2009 13:37:35 -0700
Subject: [Ocfs2-devel] [PATCH 22/26] ocfs2/dlm: Show the number of
	lockres/mles in dlm_state
In-Reply-To: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
References: <1240000659-6201-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1240000659-6201-23-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e64ff14607ac90b2f3349550a41cc8dc0c0b1324

This patch shows the number of lockres' and mles in the debugfs file, dlm_state.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmdebug.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index d7decaa..bf9fa27 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -763,6 +763,8 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 	int out = 0;
 	struct dlm_reco_node_data *node;
 	char *state;
+	int cur_mles = 0, tot_mles = 0;
+	int i;
 
 	spin_lock(&dlm->spinlock);
 
@@ -805,6 +807,40 @@ static int debug_state_print(struct dlm_ctxt *dlm, struct debug_buffer *db)
 				 db->buf + out, db->len - out);
 	out += snprintf(db->buf + out, db->len - out, "\n");
 
+	/* Lock Resources: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"Lock Resources: %d (%d)\n",
+			atomic_read(&dlm->res_cur_count),
+			atomic_read(&dlm->res_tot_count));
+
+	for (i = 0; i < DLM_MLE_NUM_TYPES; ++i)
+		tot_mles += atomic_read(&dlm->mle_tot_count[i]);
+
+	for (i = 0; i < DLM_MLE_NUM_TYPES; ++i)
+		cur_mles += atomic_read(&dlm->mle_cur_count[i]);
+
+	/* MLEs: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"MLEs: %d (%d)\n", cur_mles, tot_mles);
+
+	/*  Blocking: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"  Blocking: %d (%d)\n",
+			atomic_read(&dlm->mle_cur_count[DLM_MLE_BLOCK]),
+			atomic_read(&dlm->mle_tot_count[DLM_MLE_BLOCK]));
+
+	/*  Mastery: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"  Mastery: %d (%d)\n",
+			atomic_read(&dlm->mle_cur_count[DLM_MLE_MASTER]),
+			atomic_read(&dlm->mle_tot_count[DLM_MLE_MASTER]));
+
+	/*  Migration: xxx (xxx) */
+	out += snprintf(db->buf + out, db->len - out,
+			"  Migration: %d (%d)\n",
+			atomic_read(&dlm->mle_cur_count[DLM_MLE_MIGRATION]),
+			atomic_read(&dlm->mle_tot_count[DLM_MLE_MIGRATION]));
+
 	/* Lists: Dirty=Empty  Purge=InUse  PendingASTs=Empty  ... */
 	out += snprintf(db->buf + out, db->len - out,
 			"Lists: Dirty=%s  Purge=%s  PendingASTs=%s  "
-- 
1.5.6.3

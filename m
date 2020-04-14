From: Vasily Averin <vvs@virtuozzo.com>
Date: Tue, 14 Apr 2020 09:17:01 +0300
Subject: [Ocfs2-devel] [PATCH v3 1/4] ocfs2: debug_lockres_ops should
 properly handle position index
In-Reply-To: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
References: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
Message-ID: <a77539f7-b602-39de-dabc-d15ad43e110e@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently debug_lockres_ops ignores position index argument,
and it leads to incorrect output in case of read with offset.
Link: https://oss.oracle.com/pipermail/ocfs2-devel/2020-March/014822.html

By design .start function should skip first *pos elements,
and .next function must update position index unconditionally.

debug_lockres_ops was reworked to satisfy these requirements:
- .start and .next functions iterates on dlm->tracking_list
    by using seq_list_* primitives
- .show generates output related to selected dlm_lock_resource
- .stop function is used to release taken dlm_lock_resource

Cc: stable at vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!KOf5kpSuieredwp9lEzV0BQklJAQy4ix8PUtCrqkLdv2TsSnX570XW7JT9gBvV6thJkj2g$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/dlm/dlmdebug.c | 78 ++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 4b8b41d23e91..1887affbbf2c 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -542,63 +542,63 @@ static void *lockres_seq_start(struct seq_file *m, loff_t *pos)
 {
 	struct debug_lockres *dl = m->private;
 	struct dlm_ctxt *dlm = dl->dl_ctxt;
-	struct dlm_lock_resource *oldres = dl->dl_res;
 	struct dlm_lock_resource *res = NULL;
-	struct list_head *track_list;
+	struct list_head *lh;
 
 	spin_lock(&dlm->track_lock);
-	if (oldres)
-		track_list = &oldres->tracking;
-	else {
-		track_list = &dlm->tracking_list;
-		if (list_empty(track_list)) {
-			dl = NULL;
-			spin_unlock(&dlm->track_lock);
-			goto bail;
-		}
-	}
-
-	list_for_each_entry(res, track_list, tracking) {
-		if (&res->tracking == &dlm->tracking_list)
-			res = NULL;
-		else
-			dlm_lockres_get(res);
-		break;
+	lh = seq_list_start(&dlm->tracking_list, *pos);
+	if (lh) {
+		res = list_entry(lh, struct dlm_lock_resource, tracking);
+		dlm_lockres_get(res);
 	}
+	dl->dl_res = res;
 	spin_unlock(&dlm->track_lock);
+	/* passed to seq_show */
+	return res ? dl : NULL;
+}
 
-	if (oldres)
-		dlm_lockres_put(oldres);
+static void *lockres_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct debug_lockres *dl = (struct debug_lockres *)v;
+	struct dlm_ctxt *dlm = dl->dl_ctxt;
+	struct dlm_lock_resource *oldres = dl->dl_res;
+	struct dlm_lock_resource *res = NULL;
+	struct list_head *lh;
 
+	spin_lock(&dlm->track_lock);
+	lh = seq_list_next(&oldres->tracking, &dlm->tracking_list, pos);
+	if (lh) {
+		res = list_entry(lh, struct dlm_lock_resource, tracking);
+		dlm_lockres_get(res);
+	}
 	dl->dl_res = res;
-
-	if (res) {
-		spin_lock(&res->spinlock);
-		dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
-		spin_unlock(&res->spinlock);
-	} else
-		dl = NULL;
-
-bail:
-	/* passed to seq_show */
-	return dl;
+	spin_unlock(&dlm->track_lock);
+	dlm_lockres_put(oldres);
+	return res ? dl : NULL;
 }
 
 static void lockres_seq_stop(struct seq_file *m, void *v)
 {
-}
+	struct debug_lockres *dl = (struct debug_lockres *)v;
+	struct dlm_lock_resource *res = dl->dl_res;
 
-static void *lockres_seq_next(struct seq_file *m, void *v, loff_t *pos)
-{
-	return NULL;
+	if (res) {
+		dlm_lockres_put(res);
+		dl->dl_res = NULL;
+	}
 }
 
-static int lockres_seq_show(struct seq_file *s, void *v)
+static int lockres_seq_show(struct seq_file *m, void *v)
 {
 	struct debug_lockres *dl = (struct debug_lockres *)v;
+	struct dlm_lock_resource *res = dl->dl_res;
 
-	seq_printf(s, "%s", dl->dl_buf);
-
+	if (res) {
+		spin_lock(&res->spinlock);
+		dump_lockres(res, dl->dl_buf, dl->dl_len - 1);
+		spin_unlock(&res->spinlock);
+		seq_printf(m, "%s", dl->dl_buf);
+	}
 	return 0;
 }
 
-- 
2.17.1

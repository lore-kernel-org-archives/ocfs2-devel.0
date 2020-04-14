From: Vasily Averin <vvs@virtuozzo.com>
Date: Tue, 14 Apr 2020 09:17:19 +0300
Subject: [Ocfs2-devel] [PATCH v3 3/4] ocfs2: nst_seq_ops should properly
 handle position index
In-Reply-To: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
References: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
Message-ID: <ab62a217-2ff9-8a60-eade-6349afae917c@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently nst_seq_ops ignores position index argument,
and it leads to incorrect output in case of read with offset.

By design .start function should skip first *pos elements,
and .next function must update position index unconditionally.

Cc: stable at vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!McCQFYlmRnNmoAtY2bRAeiRzKSgC0c8B5r-Oy1meJpaRZaM5TbD5lECuzD96ZyERbIiA3Q$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/cluster/netdebug.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 667a5c5e1f66..8ca8a407781b 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -60,7 +60,8 @@ void o2net_debug_del_nst(struct o2net_send_tracking *nst)
 }
 
 static struct o2net_send_tracking
-			*next_nst(struct o2net_send_tracking *nst_start)
+			*next_nst(struct o2net_send_tracking *nst_start,
+				  loff_t pos)
 {
 	struct o2net_send_tracking *nst, *ret = NULL;
 
@@ -73,7 +74,7 @@ static struct o2net_send_tracking
 			break;
 
 		/* use st_task to detect real nsts in the list */
-		if (nst->st_task != NULL) {
+		if ((nst->st_task != NULL) && (pos-- == 0)) {
 			ret = nst;
 			break;
 		}
@@ -87,7 +88,7 @@ static void *nst_seq_start(struct seq_file *seq, loff_t *pos)
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
 
 	spin_lock(&o2net_debug_lock);
-	nst = next_nst(dummy_nst);
+	nst = next_nst(dummy_nst, *pos);
 	spin_unlock(&o2net_debug_lock);
 
 	return nst;
@@ -97,8 +98,9 @@ static void *nst_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
 
+	(*pos)++;
 	spin_lock(&o2net_debug_lock);
-	nst = next_nst(dummy_nst);
+	nst = next_nst(dummy_nst, 0);
 	list_del_init(&dummy_nst->st_net_debug_item);
 	if (nst)
 		list_add(&dummy_nst->st_net_debug_item,
@@ -115,7 +117,7 @@ static int nst_seq_show(struct seq_file *seq, void *v)
 	s64 sock, send, status;
 
 	spin_lock(&o2net_debug_lock);
-	nst = next_nst(dummy_nst);
+	nst = next_nst(dummy_nst, 0);
 	if (!nst)
 		goto out;
 
-- 
2.17.1

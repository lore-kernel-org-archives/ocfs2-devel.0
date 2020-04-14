From: Vasily Averin <vvs@virtuozzo.com>
Date: Tue, 14 Apr 2020 09:17:09 +0300
Subject: [Ocfs2-devel] [PATCH v3 2/4] ocfs2: ocfs2_dlm_seq_ops should
 properly handle position index
In-Reply-To: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
References: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
Message-ID: <7c0ed8e6-c3bc-9ec9-3136-c1b24a49f78e@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently ocfs2_dlm_seq_ops ignores position index argument,
and it leads to incorrect output in case of read with offset.

By design .start function should skip first *pos elements,
and .next function must update position index unconditionally.

Cc: stable at vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!MW4at7q5bwj5ULIntJ6umw403Evx0mZ3_sIwjVdK1ltQi595oNDR7IyKESTtl61485TN7g$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/dlmglue.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 152a0fc4e905..3f5fe6af9f3a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3022,7 +3022,8 @@ struct ocfs2_dlm_seq_priv {
 };
 
 static struct ocfs2_lock_res *ocfs2_dlm_next_res(struct ocfs2_lock_res *start,
-						 struct ocfs2_dlm_seq_priv *priv)
+						 struct ocfs2_dlm_seq_priv *priv,
+						 loff_t pos)
 {
 	struct ocfs2_lock_res *iter, *ret = NULL;
 	struct ocfs2_dlm_debug *dlm_debug = priv->p_dlm_debug;
@@ -3038,7 +3039,7 @@ static struct ocfs2_lock_res *ocfs2_dlm_next_res(struct ocfs2_lock_res *start,
 
 		/* We track our "dummy" iteration lockres' by a NULL
 		 * l_ops field. */
-		if (iter->l_ops != NULL) {
+		if ((iter->l_ops != NULL) && (pos-- == 0)) {
 			ret = iter;
 			break;
 		}
@@ -3053,7 +3054,7 @@ static void *ocfs2_dlm_seq_start(struct seq_file *m, loff_t *pos)
 	struct ocfs2_lock_res *iter;
 
 	spin_lock(&ocfs2_dlm_tracking_lock);
-	iter = ocfs2_dlm_next_res(&priv->p_iter_res, priv);
+	iter = ocfs2_dlm_next_res(&priv->p_iter_res, priv, *pos);
 	if (iter) {
 		/* Since lockres' have the lifetime of their container
 		 * (which can be inodes, ocfs2_supers, etc) we want to
@@ -3080,8 +3081,9 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
-	iter = ocfs2_dlm_next_res(iter, priv);
+	iter = ocfs2_dlm_next_res(iter, priv, 0);
 	list_del_init(&dummy->l_debug_list);
 	if (iter) {
 		list_add(&dummy->l_debug_list, &iter->l_debug_list);
-- 
2.17.1

From: Vasily Averin <vvs@virtuozzo.com>
Date: Wed, 26 Feb 2020 09:53:36 +0300
Subject: [Ocfs2-devel] [PATCH v2 2/4] ocfs2_dlm_seq_next should increase
	position index
In-Reply-To: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
References: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
Message-ID: <aa7c77d4-8e90-2ddc-212b-8f75ebe778f4@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Cc: stable at vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!MSixDxrphasW57tPl4VD6FKe6ZxcdQkP0oN-cWbZFdRxlNR1AOaFgm3-OunznZSXFEf0Nw$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/dlmglue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index cb9e6a7..170eb75 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3080,6 +3080,7 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	struct ocfs2_lock_res *iter = v;
 	struct ocfs2_lock_res *dummy = &priv->p_iter_res;
 
+	(*pos)++;
 	spin_lock(&ocfs2_dlm_tracking_lock);
 	iter = ocfs2_dlm_next_res(iter, priv);
 	list_del_init(&dummy->l_debug_list);
-- 
1.8.3.1

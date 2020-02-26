From: Vasily Averin <vvs@virtuozzo.com>
Date: Wed, 26 Feb 2020 09:53:53 +0300
Subject: [Ocfs2-devel] [PATCH v2 3/4] nst_seq_next should increase position
	index
In-Reply-To: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
References: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
Message-ID: <9d6e22d4-9884-c002-af25-9d1e41e80052@virtuozzo.com>
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
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!PE9FFsjnlLuJDzt36R28ZRQGJ-jhWo4rlejw_3MAX2zd1KvSlIomyKIzzBvc5psf88EhGw$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/cluster/netdebug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 02bf4a1..26fc6a2 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -97,6 +97,7 @@ static void *nst_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
 
+	++(*pos);
 	spin_lock(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
 	list_del_init(&dummy_nst->st_net_debug_item);
-- 
1.8.3.1

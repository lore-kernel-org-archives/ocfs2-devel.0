From: Vasily Averin <vvs@virtuozzo.com>
Date: Wed, 26 Feb 2020 09:54:25 +0300
Subject: [Ocfs2-devel] [PATCH v2 4/4] sc_seq_next should increase position
	index
In-Reply-To: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
References: <109025ac-74e9-6afe-3790-c7adbdaa3053@linux.alibaba.com>
Message-ID: <af1a46c3-39ee-c68a-27f6-4830922dc49b@virtuozzo.com>
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
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!OngcjY3Xm--sW3K-NHZ9tpRCS9bSp-bm45QwSwULt5bj3vAbmwAs1_LXYQm9uQ3rK7wmDA$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/cluster/netdebug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 26fc6a2..71ddd65 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -251,6 +251,7 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
+	++(*pos);
 	spin_lock(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
 	list_del_init(&dummy_sc->sc_net_debug_item);
-- 
1.8.3.1

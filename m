From: Vasily Averin <vvs@virtuozzo.com>
Date: Tue, 14 Apr 2020 09:17:30 +0300
Subject: [Ocfs2-devel] [PATCH v3 4/4] ocfs2: sc_seq_ops should properly
 handle position index
In-Reply-To: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
References: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
Message-ID: <9994b940-bb66-3334-9a47-f821cc197e5d@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently sc_seq_ops ignores position index argument,
and it leads to incorrect output in case of read with offset.

By design .start function should skip first *pos elements,
and .next function must update position index unconditionally.

Cc: stable at vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!MJIyl9g4rZXkCRJpUtfNR70zABIYk0zKHrl00gKDdYZpx41lpyanlE7z50esOWCIqgd95w$ 
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/ocfs2/cluster/netdebug.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index 8ca8a407781b..832fd762e4ef 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -213,7 +213,8 @@ struct o2net_sock_debug {
 };
 
 static struct o2net_sock_container
-			*next_sc(struct o2net_sock_container *sc_start)
+			*next_sc(struct o2net_sock_container *sc_start,
+				 loff_t pos)
 {
 	struct o2net_sock_container *sc, *ret = NULL;
 
@@ -226,7 +227,7 @@ static struct o2net_sock_container
 			break;
 
 		/* use sc_page to detect real scs in the list */
-		if (sc->sc_page != NULL) {
+		if ((sc->sc_page != NULL) && (pos-- == 0)) {
 			ret = sc;
 			break;
 		}
@@ -241,7 +242,7 @@ static void *sc_seq_start(struct seq_file *seq, loff_t *pos)
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
 	spin_lock(&o2net_debug_lock);
-	sc = next_sc(dummy_sc);
+	sc = next_sc(dummy_sc, *pos);
 	spin_unlock(&o2net_debug_lock);
 
 	return sc;
@@ -252,8 +253,9 @@ static void *sc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
+	++(*pos);
 	spin_lock(&o2net_debug_lock);
-	sc = next_sc(dummy_sc);
+	sc = next_sc(dummy_sc, 0);
 	list_del_init(&dummy_sc->sc_net_debug_item);
 	if (sc)
 		list_add(&dummy_sc->sc_net_debug_item, &sc->sc_net_debug_item);
@@ -354,7 +356,7 @@ static int sc_seq_show(struct seq_file *seq, void *v)
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
 	spin_lock(&o2net_debug_lock);
-	sc = next_sc(dummy_sc);
+	sc = next_sc(dummy_sc, 0);
 
 	if (sc) {
 		if (sd->dbg_ctxt == SHOW_SOCK_CONTAINERS)
-- 
2.17.1

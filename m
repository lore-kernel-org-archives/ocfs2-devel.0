From: Jeff Mahoney <jeffm@suse.com>
Date: Mon, 9 Jan 2006 12:42:35 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2: actually free hb set on cluster removal
Message-ID: <20060109174235.GB25744@locomotive.unixthugs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


 This patch actually frees the hb set when the cluster dir is removed.

 Since heartbeat threads are stopped when the individual heartbeat sets are
 removed, this just cleans up the allocation.

 fs/ocfs2/cluster/nodemanager.c |    1 +
 1 files changed, 1 insertion(+)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

diff -ruNpX dontdiff linux-2.6.15-staging2/fs/ocfs2/cluster/nodemanager.c linux-2.6.15-ocfs2/fs/ocfs2/cluster/nodemanager.c
--- linux-2.6.15-staging2/fs/ocfs2/cluster/nodemanager.c	2006-01-08 20:07:52.077646720 -0500
+++ linux-2.6.15-ocfs2/fs/ocfs2/cluster/nodemanager.c	2006-01-08 18:08:59.630943432 -0500
@@ -685,6 +685,7 @@ static void o2nm_cluster_group_drop_item
 	BUG_ON(o2nm_single_cluster != cluster);
 	o2nm_single_cluster = NULL;
 
+	o2hb_free_hb_set(cluster->cl_group.default_groups[1]);
 	for (i = 0; cluster->cl_group.default_groups[i]; i++) {
 		killme = &cluster->cl_group.default_groups[i]->cg_item;
 		cluster->cl_group.default_groups[i] = NULL;
-- 
Jeff Mahoney
SuSE Labs

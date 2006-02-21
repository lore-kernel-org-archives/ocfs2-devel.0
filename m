From: Jeff Mahoney <jeffm@suse.com>
Date: Tue, 21 Feb 2006 11:57:31 -0500
Subject: [Ocfs2-devel] [PATCH 07/14] ocfs2: actually free hb set on cluster
	removal
Message-ID: <20060221165731.GA11903@locomotive.unixthugs.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


 This patch actually frees the hb set when the cluster dir is removed.

 fs/ocfs2/cluster/nodemanager.c |    1 +
 1 files changed, 1 insertion(+)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

diff -ruNpX ../dontdiff linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/nodemanager.c linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/nodemanager.c
--- linux-2.6.16-rc4.ocfs2-staging1/fs/ocfs2/cluster/nodemanager.c	2006-02-21 11:44:38.000000000 -0500
+++ linux-2.6.16-rc4.ocfs2-staging2/fs/ocfs2/cluster/nodemanager.c	2006-02-21 11:44:38.000000000 -0500
@@ -701,6 +701,7 @@ static void o2nm_cluster_group_drop_item
 	BUG_ON(o2nm_single_cluster != cluster);
 	o2nm_single_cluster = NULL;
 
+	o2hb_free_hb_set(cluster->cl_group.default_groups[1]);
 	for (i = 0; cluster->cl_group.default_groups[i]; i++) {
 		killme = &cluster->cl_group.default_groups[i]->cg_item;
 		cluster->cl_group.default_groups[i] = NULL;

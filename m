From: piaojun <piaojun@huawei.com>
Date: Fri, 13 Oct 2017 15:01:15 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: cleanup unused func declaration
	and assignment
Message-ID: <59E064BB.8000005@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/alloc.c             | 2 --
 fs/ocfs2/cluster/heartbeat.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index a177eae..31a416d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3585,8 +3585,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 		 * The easy case - we can just plop the record right in.
 		 */
 		*left_rec = *split_rec;
-
-		has_empty_extent = 0;
 	} else
 		le16_add_cpu(&left_rec->e_leaf_clusters, split_clusters);

diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 3ef5137..a9e67ef 100644
--- a/fs/ocfs2/cluster/heartbeat.h
+++ b/fs/ocfs2/cluster/heartbeat.h
@@ -79,10 +79,8 @@ void o2hb_fill_node_map(unsigned long *map,
 			unsigned bytes);
 void o2hb_exit(void);
 int o2hb_init(void);
-int o2hb_check_node_heartbeating(u8 node_num);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num);
 int o2hb_check_node_heartbeating_from_callback(u8 node_num);
-int o2hb_check_local_node_heartbeating(void);
 void o2hb_stop_all_regions(void);
 int o2hb_get_all_regions(char *region_uuids, u8 numregions);
 int o2hb_global_heartbeat_active(void);
-- 

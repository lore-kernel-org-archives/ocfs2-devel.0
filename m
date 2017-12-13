From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 13 Dec 2017 03:19:53 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: clean up unused function
 declaration in heartbeat.h
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F5A7ED@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
  fs/ocfs2/cluster/heartbeat.h | 2 --
  1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.h b/fs/ocfs2/cluster/heartbeat.h
index 3ef5137dc362..a9e67efc0004 100644
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
2.11.0

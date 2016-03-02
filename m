From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed,  2 Mar 2016 15:58:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2hb: remove useless force cast
Message-ID: <1456905498-22495-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 8ec85cac894e..023c72d35498 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1315,19 +1315,19 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 
 	case O2HB_DB_TYPE_REGION_LIVENODES:
 		spin_lock(&o2hb_live_lock);
-		reg = (struct o2hb_region *)db->db_data;
+		reg = db->db_data;
 		memcpy(map, reg->hr_live_node_bitmap, db->db_size);
 		spin_unlock(&o2hb_live_lock);
 		break;
 
 	case O2HB_DB_TYPE_REGION_NUMBER:
-		reg = (struct o2hb_region *)db->db_data;
+		reg = db->db_data;
 		out += snprintf(buf + out, PAGE_SIZE - out, "%d\n",
 				reg->hr_region_num);
 		goto done;
 
 	case O2HB_DB_TYPE_REGION_ELAPSED_TIME:
-		reg = (struct o2hb_region *)db->db_data;
+		reg = db->db_data;
 		lts = reg->hr_last_timeout_start;
 		/* If 0, it has never been set before */
 		if (lts)
@@ -1336,7 +1336,7 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 		goto done;
 
 	case O2HB_DB_TYPE_REGION_PINNED:
-		reg = (struct o2hb_region *)db->db_data;
+		reg = db->db_data;
 		out += snprintf(buf + out, PAGE_SIZE - out, "%u\n",
 				!!reg->hr_item_pinned);
 		goto done;
-- 
1.7.9.5

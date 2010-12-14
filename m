From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Dec 2010 14:14:30 -0800
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2/cluster: Show pin state for each
	o2hb region
In-Reply-To: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
References: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1292364871-18461-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds a per o2hb region debugfs file that shows whether that region
is pinned or not.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1f5afa6..199a98e 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -82,6 +82,7 @@ static unsigned long o2hb_failed_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 #define O2HB_DB_TYPE_REGION_LIVENODES	4
 #define O2HB_DB_TYPE_REGION_NUMBER	5
 #define O2HB_DB_TYPE_REGION_ELAPSED_TIME	6
+#define O2HB_DB_TYPE_REGION_PINNED	7
 struct o2hb_debug_buf {
 	int db_type;
 	int db_size;
@@ -101,6 +102,7 @@ static struct o2hb_debug_buf *o2hb_db_failedregions;
 #define O2HB_DEBUG_FAILEDREGIONS	"failed_regions"
 #define O2HB_DEBUG_REGION_NUMBER	"num"
 #define O2HB_DEBUG_REGION_ELAPSED_TIME	"elapsed_time_in_ms"
+#define O2HB_DEBUG_REGION_PINNED	"pinned"
 
 static struct dentry *o2hb_debug_dir;
 static struct dentry *o2hb_debug_livenodes;
@@ -241,9 +243,11 @@ struct o2hb_region {
 	struct dentry		*hr_debug_livenodes;
 	struct dentry		*hr_debug_regnum;
 	struct dentry		*hr_debug_elapsed_time;
+	struct dentry		*hr_debug_pinned;
 	struct o2hb_debug_buf	*hr_db_livenodes;
 	struct o2hb_debug_buf	*hr_db_regnum;
 	struct o2hb_debug_buf	*hr_db_elapsed_time;
+	struct o2hb_debug_buf	*hr_db_pinned;
 
 	/* let the person setting up hb wait for it to return until it
 	 * has reached a 'steady' state.  This will be fixed when we have
@@ -1180,6 +1184,12 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 						 reg->hr_last_timeout_start));
 		goto done;
 
+	case O2HB_DB_TYPE_REGION_PINNED:
+		reg = (struct o2hb_region *)db->db_data;
+		out += snprintf(buf + out, PAGE_SIZE - out, "%u\n",
+				!!reg->hr_item_pinned);
+		goto done;
+
 	default:
 		goto done;
 	}
@@ -1424,6 +1434,7 @@ static void o2hb_region_release(struct config_item *item)
 	debugfs_remove(reg->hr_debug_livenodes);
 	debugfs_remove(reg->hr_debug_regnum);
 	debugfs_remove(reg->hr_debug_elapsed_time);
+	debugfs_remove(reg->hr_debug_pinned);
 	debugfs_remove(reg->hr_debug_dir);
 
 	spin_lock(&o2hb_live_lock);
@@ -1988,6 +1999,18 @@ static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
 		goto bail;
 	}
 
+	reg->hr_debug_pinned = 
+			o2hb_debug_create(O2HB_DEBUG_REGION_PINNED,
+					  reg->hr_debug_dir,
+					  &(reg->hr_db_pinned),
+					  sizeof(*(reg->hr_db_pinned)),
+					  O2HB_DB_TYPE_REGION_PINNED,
+					  0, 0, reg);
+	if (!reg->hr_debug_pinned) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
 	ret = 0;
 bail:
 	return ret;
-- 
1.7.1

From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:35 -0700
Subject: [Ocfs2-devel] [PATCH 21/22] ocfs2/cluster: Show per region
	heartbeat elapsed time
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-22-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch adds a per region debugfs file that shows the elapsed time
since the time the o2hb timer was last armed.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index e8676ac..29aee21 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -81,6 +81,7 @@ static unsigned long o2hb_failed_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 #define O2HB_DB_TYPE_FAILEDREGIONS	3
 #define O2HB_DB_TYPE_REGION_LIVENODES	4
 #define O2HB_DB_TYPE_REGION_NUMBER	5
+#define O2HB_DB_TYPE_REGION_ELAPSED_TIME	6
 struct o2hb_debug_buf {
 	int db_type;
 	int db_size;
@@ -99,6 +100,7 @@ static struct o2hb_debug_buf *o2hb_db_failedregions;
 #define O2HB_DEBUG_QUORUMREGIONS	"quorum_regions"
 #define O2HB_DEBUG_FAILEDREGIONS	"failed_regions"
 #define O2HB_DEBUG_REGION_NUMBER	"num"
+#define O2HB_DEBUG_REGION_ELAPSED_TIME	"elapsed_time_in_ms"
 
 static struct dentry *o2hb_debug_dir;
 static struct dentry *o2hb_debug_livenodes;
@@ -209,8 +211,10 @@ struct o2hb_region {
 	struct dentry		*hr_debug_dir;
 	struct dentry		*hr_debug_livenodes;
 	struct dentry		*hr_debug_regnum;
+	struct dentry		*hr_debug_elapsed_time;
 	struct o2hb_debug_buf	*hr_db_livenodes;
 	struct o2hb_debug_buf	*hr_db_regnum;
+	struct o2hb_debug_buf	*hr_db_elapsed_time;
 
 	/* let the person setting up hb wait for it to return until it
 	 * has reached a 'steady' state.  This will be fixed when we have
@@ -1132,6 +1136,13 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 				reg->hr_region_num);
 		goto done;
 
+	case O2HB_DB_TYPE_REGION_ELAPSED_TIME:
+		reg = (struct o2hb_region *)db->db_data;
+		out += snprintf(buf + out, PAGE_SIZE - out, "%u\n",
+				jiffies_to_msecs(jiffies -
+						 reg->hr_last_timeout_start));
+		goto done;
+
 	default:
 		goto done;
 	}
@@ -1925,6 +1936,18 @@ static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
 		goto bail;
 	}
 
+	reg->hr_debug_elapsed_time =
+			o2hb_debug_create(O2HB_DEBUG_REGION_ELAPSED_TIME,
+					  reg->hr_debug_dir,
+					  &(reg->hr_db_elapsed_time),
+					  sizeof(*(reg->hr_db_elapsed_time)),
+					  O2HB_DB_TYPE_REGION_ELAPSED_TIME,
+					  0, 0, reg);
+	if (!reg->hr_debug_elapsed_time) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
 	ret = 0;
 bail:
 	return ret;
-- 
1.7.0.4

From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:32 -0700
Subject: [Ocfs2-devel] [PATCH 18/22] ocfs2/cluster: Create debugfs files for
	live, quorum and failed region bitmaps
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-19-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch prints the bitmaps of live, quorum and failed regions. This
information will be useful in debugging cluster issues.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   63 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f890656..b06b9e5 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -76,6 +76,9 @@ static unsigned long o2hb_quorum_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 static unsigned long o2hb_failed_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 
 #define O2HB_DB_TYPE_LIVENODES		0
+#define O2HB_DB_TYPE_LIVEREGIONS	1
+#define O2HB_DB_TYPE_QUORUMREGIONS	2
+#define O2HB_DB_TYPE_FAILEDREGIONS	3
 struct o2hb_debug_buf {
 	int db_type;
 	int db_size;
@@ -84,12 +87,21 @@ struct o2hb_debug_buf {
 };
 
 static struct o2hb_debug_buf *o2hb_db_livenodes;
+static struct o2hb_debug_buf *o2hb_db_liveregions;
+static struct o2hb_debug_buf *o2hb_db_quorumregions;
+static struct o2hb_debug_buf *o2hb_db_failedregions;
 
 #define O2HB_DEBUG_DIR			"o2hb"
 #define O2HB_DEBUG_LIVENODES		"livenodes"
+#define O2HB_DEBUG_LIVEREGIONS		"live_regions"
+#define O2HB_DEBUG_QUORUMREGIONS	"quorum_regions"
+#define O2HB_DEBUG_FAILEDREGIONS	"failed_regions"
 
 static struct dentry *o2hb_debug_dir;
 static struct dentry *o2hb_debug_livenodes;
+static struct dentry *o2hb_debug_liveregions;
+static struct dentry *o2hb_debug_quorumregions;
+static struct dentry *o2hb_debug_failedregions;
 
 static LIST_HEAD(o2hb_all_regions);
 
@@ -1085,6 +1097,9 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 
 	switch (db->db_type) {
 	case O2HB_DB_TYPE_LIVENODES:
+	case O2HB_DB_TYPE_LIVEREGIONS:
+	case O2HB_DB_TYPE_QUORUMREGIONS:
+	case O2HB_DB_TYPE_FAILEDREGIONS:
 		spin_lock(&o2hb_live_lock);
 		memcpy(map, db->db_data, db->db_size);
 		spin_unlock(&o2hb_live_lock);
@@ -1146,6 +1161,12 @@ static const struct file_operations o2hb_debug_fops = {
 void o2hb_exit(void)
 {
 	kfree(o2hb_db_livenodes);
+	kfree(o2hb_db_liveregions);
+	kfree(o2hb_db_quorumregions);
+	kfree(o2hb_db_failedregions);
+	debugfs_remove(o2hb_debug_failedregions);
+	debugfs_remove(o2hb_debug_quorumregions);
+	debugfs_remove(o2hb_debug_liveregions);
 	debugfs_remove(o2hb_debug_livenodes);
 	debugfs_remove(o2hb_debug_dir);
 }
@@ -1189,6 +1210,48 @@ static int o2hb_debug_init(void)
 		mlog_errno(ret);
 		goto bail;
 	}
+
+	o2hb_debug_liveregions = o2hb_debug_create(O2HB_DEBUG_LIVEREGIONS,
+						   o2hb_debug_dir,
+						   &o2hb_db_liveregions,
+						   sizeof(*o2hb_db_liveregions),
+						   O2HB_DB_TYPE_LIVEREGIONS,
+						   sizeof(o2hb_live_region_bitmap),
+						   O2NM_MAX_REGIONS,
+						   o2hb_live_region_bitmap);
+	if (!o2hb_debug_liveregions) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	o2hb_debug_quorumregions =
+			o2hb_debug_create(O2HB_DEBUG_QUORUMREGIONS,
+					  o2hb_debug_dir,
+					  &o2hb_db_quorumregions,
+					  sizeof(*o2hb_db_quorumregions),
+					  O2HB_DB_TYPE_QUORUMREGIONS,
+					  sizeof(o2hb_quorum_region_bitmap),
+					  O2NM_MAX_REGIONS,
+					  o2hb_quorum_region_bitmap);
+	if (!o2hb_debug_quorumregions) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	o2hb_debug_failedregions =
+			o2hb_debug_create(O2HB_DEBUG_FAILEDREGIONS,
+					  o2hb_debug_dir,
+					  &o2hb_db_failedregions,
+					  sizeof(*o2hb_db_failedregions),
+					  O2HB_DB_TYPE_FAILEDREGIONS,
+					  sizeof(o2hb_failed_region_bitmap),
+					  O2NM_MAX_REGIONS,
+					  o2hb_failed_region_bitmap);
+	if (!o2hb_debug_failedregions) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
 	ret = 0;
 bail:
 	if (ret)
-- 
1.7.0.4

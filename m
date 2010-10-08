From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu,  7 Oct 2010 17:15:33 -0700
Subject: [Ocfs2-devel] [PATCH 19/22] ocfs2/cluster: Create debugfs dir/files
	for each region
In-Reply-To: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
References: <1286496936-17072-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1286496936-17072-20-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch creates debugfs directory for each o2hb region and creates
files to expose the region number and the per region live node bitmap.
This information will be useful in debugging cluster issues.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |   77 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b06b9e5..f28de4b 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -79,6 +79,8 @@ static unsigned long o2hb_failed_region_bitmap[BITS_TO_LONGS(O2NM_MAX_REGIONS)];
 #define O2HB_DB_TYPE_LIVEREGIONS	1
 #define O2HB_DB_TYPE_QUORUMREGIONS	2
 #define O2HB_DB_TYPE_FAILEDREGIONS	3
+#define O2HB_DB_TYPE_REGION_LIVENODES	4
+#define O2HB_DB_TYPE_REGION_NUMBER	5
 struct o2hb_debug_buf {
 	int db_type;
 	int db_size;
@@ -96,6 +98,7 @@ static struct o2hb_debug_buf *o2hb_db_failedregions;
 #define O2HB_DEBUG_LIVEREGIONS		"live_regions"
 #define O2HB_DEBUG_QUORUMREGIONS	"quorum_regions"
 #define O2HB_DEBUG_FAILEDREGIONS	"failed_regions"
+#define O2HB_DEBUG_REGION_NUMBER	"num"
 
 static struct dentry *o2hb_debug_dir;
 static struct dentry *o2hb_debug_livenodes;
@@ -203,6 +206,12 @@ struct o2hb_region {
 	unsigned long		hr_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	unsigned int		hr_region_num;
 
+	struct dentry		*hr_debug_dir;
+	struct dentry		*hr_debug_livenodes;
+	struct dentry		*hr_debug_regnum;
+	struct o2hb_debug_buf	*hr_db_livenodes;
+	struct o2hb_debug_buf	*hr_db_regnum;
+
 	/* let the person setting up hb wait for it to return until it
 	 * has reached a 'steady' state.  This will be fixed when we have
 	 * a more complete api that doesn't lead to this sort of fragility. */
@@ -1083,6 +1092,7 @@ static int o2hb_thread(void *data)
 static int o2hb_debug_open(struct inode *inode, struct file *file)
 {
 	struct o2hb_debug_buf *db = inode->i_private;
+	struct o2hb_region *reg;
 	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	char *buf = NULL;
 	int i = -1;
@@ -1105,6 +1115,19 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 		spin_unlock(&o2hb_live_lock);
 		break;
 
+	case O2HB_DB_TYPE_REGION_LIVENODES:
+		spin_lock(&o2hb_live_lock);
+		reg = (struct o2hb_region *)db->db_data;
+		memcpy(map, reg->hr_live_node_bitmap, db->db_size);
+		spin_unlock(&o2hb_live_lock);
+		break;
+
+	case O2HB_DB_TYPE_REGION_NUMBER:
+		reg = (struct o2hb_region *)db->db_data;
+		out += snprintf(buf + out, PAGE_SIZE - out, "%d\n",
+				reg->hr_region_num);
+		goto done;
+
 	default:
 		goto done;
 	}
@@ -1342,6 +1365,12 @@ static void o2hb_region_release(struct config_item *item)
 	if (reg->hr_slots)
 		kfree(reg->hr_slots);
 
+	kfree(reg->hr_db_regnum);
+	kfree(reg->hr_db_livenodes);
+	debugfs_remove(reg->hr_debug_livenodes);
+	debugfs_remove(reg->hr_debug_regnum);
+	debugfs_remove(reg->hr_debug_dir);
+
 	spin_lock(&o2hb_live_lock);
 	list_del(&reg->hr_all_item);
 	spin_unlock(&o2hb_live_lock);
@@ -1856,10 +1885,52 @@ static struct o2hb_heartbeat_group *to_o2hb_heartbeat_group(struct config_group
 		: NULL;
 }
 
+static int o2hb_debug_region_init(struct o2hb_region *reg, struct dentry *dir)
+{
+	int ret = -ENOMEM;
+
+	reg->hr_debug_dir =
+		debugfs_create_dir(config_item_name(&reg->hr_item), dir);
+	if (!reg->hr_debug_dir) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	reg->hr_debug_livenodes =
+			o2hb_debug_create(O2HB_DEBUG_LIVENODES,
+					  reg->hr_debug_dir,
+					  &(reg->hr_db_livenodes),
+					  sizeof(*(reg->hr_db_livenodes)),
+					  O2HB_DB_TYPE_REGION_LIVENODES,
+					  sizeof(reg->hr_live_node_bitmap),
+					  O2NM_MAX_NODES, reg);
+	if (!reg->hr_debug_livenodes) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	reg->hr_debug_regnum =
+			o2hb_debug_create(O2HB_DEBUG_REGION_NUMBER,
+					  reg->hr_debug_dir,
+					  &(reg->hr_db_regnum),
+					  sizeof(*(reg->hr_db_regnum)),
+					  O2HB_DB_TYPE_REGION_NUMBER,
+					  0, O2NM_MAX_NODES, reg);
+	if (!reg->hr_debug_regnum) {
+		mlog_errno(ret);
+		goto bail;
+	}
+
+	ret = 0;
+bail:
+	return ret;
+}
+
 static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *group,
 							  const char *name)
 {
 	struct o2hb_region *reg = NULL;
+	int ret;
 
 	reg = kzalloc(sizeof(struct o2hb_region), GFP_KERNEL);
 	if (reg == NULL)
@@ -1884,6 +1955,12 @@ static struct config_item *o2hb_heartbeat_group_make_item(struct config_group *g
 
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
+	ret = o2hb_debug_region_init(reg, o2hb_debug_dir);
+	if (ret) {
+		config_item_put(&reg->hr_item);
+		return ERR_PTR(ret);
+	}
+
 	return &reg->hr_item;
 }
 
-- 
1.7.0.4

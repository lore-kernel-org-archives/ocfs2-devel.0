From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:31:05 -0700
Subject: [Ocfs2-devel] [PATCH 11/13] ocfs2/cluster: Fix output in file
	elapsed_time_in_ms
In-Reply-To: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
References: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1308868267-5981-12-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The o2hb debugfs file, elapsed_time_in_ms, should return values only after the
timer is armed atleast once.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/cluster/heartbeat.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 4728a74..a4e855e 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1198,6 +1198,7 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 	struct o2hb_debug_buf *db = inode->i_private;
 	struct o2hb_region *reg;
 	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
+	unsigned long lts;
 	char *buf = NULL;
 	int i = -1;
 	int out = 0;
@@ -1234,9 +1235,11 @@ static int o2hb_debug_open(struct inode *inode, struct file *file)
 
 	case O2HB_DB_TYPE_REGION_ELAPSED_TIME:
 		reg = (struct o2hb_region *)db->db_data;
-		out += snprintf(buf + out, PAGE_SIZE - out, "%u\n",
-				jiffies_to_msecs(jiffies -
-						 reg->hr_last_timeout_start));
+		lts = reg->hr_last_timeout_start;
+		/* If 0, it has never been set before */
+		if (lts)
+			lts = jiffies_to_msecs(jiffies - lts);
+		out += snprintf(buf + out, PAGE_SIZE - out, "%lu\n", lts);
 		goto done;
 
 	case O2HB_DB_TYPE_REGION_PINNED:
-- 
1.7.4.1

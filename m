From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 29 Jul 2011 18:06:23 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: limit the number of inodes in
	orphanscan
Message-ID: <201107291006.p6TA6aSZ010899@acsmt358.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During orphanscan, limit the scan number in a single loop to avoid OOM.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/journal.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 7d4e1ca..1c0487b 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -56,6 +56,7 @@
 DEFINE_SPINLOCK(trans_inc_lock);
 
 #define ORPHAN_SCAN_SCHEDULE_TIMEOUT 300000
+#define ORPHAN_SCAN_ITEMS_PER_LOOP 1000
 
 static int ocfs2_force_read_journal(struct inode *inode);
 static int ocfs2_recover_node(struct ocfs2_super *osb,
@@ -1926,6 +1927,7 @@ struct ocfs2_orphan_filldir_priv {
 	struct inode		*head;
 	struct ocfs2_super	*osb;
 	struct 			inode *orphan_dir;
+	int			count;
 };
 
 static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
@@ -1964,6 +1966,12 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
 	}
 	spin_unlock(&o_orphandir->ip_lock);
 
+	/*
+	 * reading limited number of inodes in a single loop to avoid OOM
+	 */
+	if ( ++p->count == ORPHAN_SCAN_ITEMS_PER_LOOP )
+		return -EAGAIN;
+
 	return 0;
 }
 
@@ -1978,6 +1986,7 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 
 	priv.osb = osb;
 	priv.head = *head;
+	priv.count = 0;
 
 	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
 						       ORPHAN_DIR_SYSTEM_INODE,
-- 
1.7.5.2

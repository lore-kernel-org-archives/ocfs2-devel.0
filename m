From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 29 Jul 2011 18:06:14 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: fix slow deleting
Message-ID: <201107291006.p6TA6S24005662@acsmt356.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a case that the application deletes a large number(XX kilo) of files in
short time (5 minutes). The deletions of some specific files are extreamly slow
(costing xx~xxx seconds). That is unacceptable.

Reading out the dir entries and the relavent inodes cost time. And we are doing
that with i_mutex held, it causes unlink path waiting on the mutex for long time.

fix:
make the orphanscan work with lower priority. That means when unlink/delete_inode,
come, orphanscan should break the walking in orphandir and release the lock(mutex and
cluster lock). 

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dlmglue.c |   11 +++++++++++
 fs/ocfs2/inode.c   |   11 +++++++++++
 fs/ocfs2/inode.h   |    9 +++++++++
 fs/ocfs2/journal.c |   32 +++++++++++++++++++++++++-------
 fs/ocfs2/namei.c   |    9 +++++++++
 5 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 7642d7c..957e7da 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1043,6 +1043,17 @@ static void ocfs2_blocking_ast(struct ocfs2_dlm_lksb *lksb, int level)
 		ocfs2_schedule_blocked_lock(osb, lockres);
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
 
+	if (needs_downconvert) {
+		if (lockres->l_type == OCFS2_LOCK_TYPE_META) {
+			struct ocfs2_inode_info *oi;
+			oi = container_of(lockres, struct ocfs2_inode_info,
+					  ip_inode_lockres);
+			spin_lock_irqsave(&oi->ip_lock, flags);
+			oi->ip_flags |= OCFS2_ORPHANDIR_NEED_BREAK;
+			spin_unlock_irqrestore(&oi->ip_lock, flags);
+		}
+	}
+
 	wake_up(&lockres->l_event);
 
 	ocfs2_wake_downconvert_thread(osb);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b4c8bb6..05b105c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -715,6 +715,7 @@ static int ocfs2_wipe_inode(struct inode *inode,
 	struct buffer_head *orphan_dir_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
+	struct ocfs2_inode_info *o_orphandir;
 
 	if (!(OCFS2_I(inode)->ip_flags & OCFS2_INODE_SKIP_ORPHAN_DIR)) {
 		orphaned_slot = le16_to_cpu(di->i_orphaned_slot);
@@ -732,6 +733,16 @@ static int ocfs2_wipe_inode(struct inode *inode,
 			goto bail;
 		}
 
+		/*
+		 * deleting entry from orphandir has higher priority than orphan
+		 * scan to avoid long time waiting on mutex or cluster lock which
+		 * is held by orphan scan.
+		 */
+		o_orphandir = OCFS2_I(orphan_dir_inode);
+		spin_lock(&o_orphandir->ip_lock);
+		o_orphandir->ip_flags |= OCFS2_ORPHANDIR_NEED_BREAK;
+		spin_unlock(&o_orphandir->ip_lock);
+
 		/* Lock the orphan dir. The lock will be held for the entire
 		 * delete_inode operation. We do this now to avoid races with
 		 * recovery completion on other nodes. */
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 1c508b1..b589163 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -103,6 +103,15 @@ struct ocfs2_inode_info
 /* Tell the inode wipe code it's not in orphan dir */
 #define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000080
 
+/*
+ * The following one is for only orphan dirs
+ * This flag is set in unlink and delete_inode path and gets cleared in the
+ * orphanscan path.
+ * It's used to break the time cost orphanscan work which holds mutex and
+ * cluster lock so that unlink/delete_inode can get a chance to go.
+ */
+#define OCFS2_ORPHANDIR_NEED_BREAK	0x00000100
+
 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
 	return container_of(inode, struct ocfs2_inode_info, vfs_inode);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 295d564..7d4e1ca 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1925,6 +1925,7 @@ void ocfs2_orphan_scan_start(struct ocfs2_super *osb)
 struct ocfs2_orphan_filldir_priv {
 	struct inode		*head;
 	struct ocfs2_super	*osb;
+	struct 			inode *orphan_dir;
 };
 
 static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
@@ -1932,6 +1933,7 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
 {
 	struct ocfs2_orphan_filldir_priv *p = priv;
 	struct inode *iter;
+	struct ocfs2_inode_info *o_orphandir = OCFS2_I(p->orphan_dir);
 
 	if (name_len == 1 && !strncmp(".", name, 1))
 		return 0;
@@ -1950,17 +1952,29 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
 	OCFS2_I(iter)->ip_next_orphan = p->head;
 	p->head = iter;
 
+	/*
+	 * there is an unlink/delete_inode on local or a remote node, let orphan
+	 * scan break so that unlink/delete_inode can go through without long wait.
+	 */
+	spin_lock(&o_orphandir->ip_lock);
+	if (o_orphandir->ip_flags & OCFS2_ORPHANDIR_NEED_BREAK) {
+		o_orphandir->ip_flags &= ~OCFS2_ORPHANDIR_NEED_BREAK;
+		spin_unlock(&o_orphandir->ip_lock);
+		return -EAGAIN;
+	}
+	spin_unlock(&o_orphandir->ip_lock);
+
 	return 0;
 }
 
 static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 			       int slot,
-			       struct inode **head)
+			       struct inode **head,
+			       loff_t *pos)
 {
 	int status;
 	struct inode *orphan_dir_inode = NULL;
 	struct ocfs2_orphan_filldir_priv priv;
-	loff_t pos = 0;
 
 	priv.osb = osb;
 	priv.head = *head;
@@ -1974,16 +1988,16 @@ static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 		return status;
 	}
 
+	priv.orphan_dir = orphan_dir_inode;
 	mutex_lock(&orphan_dir_inode->i_mutex);
 	status = ocfs2_inode_lock(orphan_dir_inode, NULL, 0);
 	if (status < 0) {
 		mlog_errno(status);
 		goto out;
 	}
-
-	status = ocfs2_dir_foreach(orphan_dir_inode, &pos, &priv,
+	status = ocfs2_dir_foreach(orphan_dir_inode, pos, &priv,
 				   ocfs2_orphan_filldir);
-	if (status) {
+	if (status && status != -EAGAIN) {
 		mlog_errno(status);
 		goto out_cluster;
 	}
@@ -2059,16 +2073,18 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 	struct inode *inode = NULL;
 	struct inode *iter;
 	struct ocfs2_inode_info *oi;
+	loff_t pos = 0;
 
 	trace_ocfs2_recover_orphans(slot);
 
+cnt_scan:
 	ocfs2_mark_recovering_orphan_dir(osb, slot);
-	ret = ocfs2_queue_orphans(osb, slot, &inode);
+	ret = ocfs2_queue_orphans(osb, slot, &inode, &pos);
 	ocfs2_clear_recovering_orphan_dir(osb, slot);
 
 	/* Error here should be noted, but we want to continue with as
 	 * many queued inodes as we've got. */
-	if (ret)
+	if (ret && ret != -EAGAIN)
 		mlog_errno(ret);
 
 	while (inode) {
@@ -2095,6 +2111,8 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 		inode = iter;
 	}
 
+	if (ret == -EAGAIN)
+		goto cnt_scan;
 	return ret;
 }
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index e5d738c..af04bda 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1875,6 +1875,7 @@ static int ocfs2_lookup_lock_orphan_dir(struct ocfs2_super *osb,
 	struct inode *orphan_dir_inode;
 	struct buffer_head *orphan_dir_bh = NULL;
 	int ret = 0;
+	struct ocfs2_inode_info *o_orphandir;
 
 	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
 						       ORPHAN_DIR_SYSTEM_INODE,
@@ -1885,6 +1886,14 @@ static int ocfs2_lookup_lock_orphan_dir(struct ocfs2_super *osb,
 		return ret;
 	}
 
+	/*
+	 * unlink has higher priority than orphan scan work.
+	 */
+	o_orphandir = OCFS2_I(orphan_dir_inode);
+	spin_lock(&o_orphandir->ip_lock);
+	o_orphandir->ip_flags |= OCFS2_ORPHANDIR_NEED_BREAK;
+	spin_unlock(&o_orphandir->ip_lock);
+
 	mutex_lock(&orphan_dir_inode->i_mutex);
 
 	ret = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
-- 
1.7.5.2

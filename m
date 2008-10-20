From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Oct 2008 19:23:49 +0200
Subject: [Ocfs2-devel] [PATCH] quota: Add helpers to allow ocfs2 specific
	quota initialization and freeing
In-Reply-To: y
References: y
Message-ID: <1224523442408-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

OCFS2 needs to peek whether quota structure is already in memory so
that it can avoid expensive cluster locking in that case. Similarly
when freeing dquots, it checks whether it is the last quota structure
user or not.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c               |   30 ++++++++++++++++++++++++++++--
 include/linux/quotaops.h |    2 ++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 3fde18b..c5016a2 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -660,6 +660,24 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 }
 
 /*
+ * Check whether dquot is in memory.
+ * MUST be called with either dqptr_sem or dqonoff_mutex held
+ */
+int dquot_is_cached(struct super_block *sb, unsigned int id, int type)
+{
+	unsigned int hashent = hashfn(sb, id, type);
+	int ret = 0;
+
+        if (!sb_has_quota_active(sb, type))
+		return 0;
+	spin_lock(&dq_list_lock);
+	if (find_dquot(hashent, sb, id, type) == NODQUOT)
+		ret = 1;
+	spin_unlock(&dq_list_lock);
+	return ret;
+}
+
+/*
  * Get reference to dquot
  * MUST be called with either dqptr_sem or dqonoff_mutex held
  */
@@ -1184,17 +1202,23 @@ out_err:
  * 	Release all quotas referenced by inode
  *	Transaction must be started at an entry
  */
-int dquot_drop(struct inode *inode)
+int dquot_drop_locked(struct inode *inode)
 {
 	int cnt;
 
-	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (inode->i_dquot[cnt] != NODQUOT) {
 			dqput(inode->i_dquot[cnt]);
 			inode->i_dquot[cnt] = NODQUOT;
 		}
 	}
+	return 0;
+}
+
+int dquot_drop(struct inode *inode)
+{
+	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
+	dquot_drop_locked(inode);
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return 0;
 }
@@ -2306,7 +2330,9 @@ EXPORT_SYMBOL(dquot_release);
 EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 EXPORT_SYMBOL(dquot_initialize);
 EXPORT_SYMBOL(dquot_drop);
+EXPORT_SYMBOL(dquot_drop_locked);
 EXPORT_SYMBOL(vfs_dq_drop);
+EXPORT_SYMBOL(dquot_is_cached);
 EXPORT_SYMBOL(dquot_alloc_space);
 EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 94f00ec..4cb298d 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -27,6 +27,8 @@ void sync_dquots(struct super_block *sb, int type);
 
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
+int dquot_drop_locked(struct inode *inode);
+int dquot_is_cached(struct super_block *sb, unsigned int id, int type);
 
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
-- 
1.5.2.4

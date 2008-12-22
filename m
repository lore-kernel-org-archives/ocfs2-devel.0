From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 22 Dec 2008 13:47:58 -0800
Subject: [Ocfs2-devel] [PATCH 17/56] quota: Add helpers to allow ocfs2
	specific quota initialization, freeing and recovery
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229982517-3455-18-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>

From: Jan Kara <jack@suse.cz>

OCFS2 needs to peek whether quota structure is already in memory so
that it can avoid expensive cluster locking in that case. Similarly
when freeing dquots, it checks whether it is the last quota structure
user or not. Finally, it needs to get reference to dquot structure for
specified id and quota type when recovering quota file after crash.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c               |   38 ++++++++++++++++++++++++++++++++------
 include/linux/quotaops.h |    4 ++++
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 6784892..8774be6 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -211,8 +211,6 @@ static struct hlist_head *dquot_hash;
 
 struct dqstats dqstats;
 
-static void dqput(struct dquot *dquot);
-
 static inline unsigned int
 hashfn(const struct super_block *sb, unsigned int id, int type)
 {
@@ -568,7 +566,7 @@ static struct shrinker dqcache_shrinker = {
  * NOTE: If you change this function please check whether dqput_blocks() works right...
  * MUST be called with either dqptr_sem or dqonoff_mutex held
  */
-static void dqput(struct dquot *dquot)
+void dqput(struct dquot *dquot)
 {
 	int ret;
 
@@ -662,10 +660,28 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
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
+	if (find_dquot(hashent, sb, id, type) != NODQUOT)
+		ret = 1;
+	spin_unlock(&dq_list_lock);
+	return ret;
+}
+
+/*
  * Get reference to dquot
  * MUST be called with either dqptr_sem or dqonoff_mutex held
  */
-static struct dquot *dqget(struct super_block *sb, unsigned int id, int type)
+struct dquot *dqget(struct super_block *sb, unsigned int id, int type)
 {
 	unsigned int hashent = hashfn(sb, id, type);
 	struct dquot *dquot, *empty = NODQUOT;
@@ -1184,17 +1200,23 @@ out_err:
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
@@ -2308,7 +2330,11 @@ EXPORT_SYMBOL(dquot_release);
 EXPORT_SYMBOL(dquot_mark_dquot_dirty);
 EXPORT_SYMBOL(dquot_initialize);
 EXPORT_SYMBOL(dquot_drop);
+EXPORT_SYMBOL(dquot_drop_locked);
 EXPORT_SYMBOL(vfs_dq_drop);
+EXPORT_SYMBOL(dqget);
+EXPORT_SYMBOL(dqput);
+EXPORT_SYMBOL(dquot_is_cached);
 EXPORT_SYMBOL(dquot_alloc_space);
 EXPORT_SYMBOL(dquot_alloc_inode);
 EXPORT_SYMBOL(dquot_free_space);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index e840ca5..e3a1027 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -24,6 +24,10 @@ void sync_dquots(struct super_block *sb, int type);
 
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
+int dquot_drop_locked(struct inode *inode);
+struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
+void dqput(struct dquot *dquot);
+int dquot_is_cached(struct super_block *sb, unsigned int id, int type);
 
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
-- 
1.5.6

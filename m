From: Jan Kara <jack@suse.cz>
Date: Thu, 13 May 2010 21:57:57 +0200
Subject: [Ocfs2-devel] [PATCH 1/7] quota: Refactor dquot_transfer code so
	that OCFS2 can pass in its references
In-Reply-To: <1273780683-3638-1-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
Message-ID: <1273780683-3638-2-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, __dquot_transfer() acquires its own references of dquot structures
that will be put into inode. But for OCFS2, this creates a lock inversion
between dq_lock (waited on in dqget) and transaction start (started in
ocfs2_setattr). Currently, deadlock is impossible because dq_lock is acquired
only during dquot_acquire and dquot_release and we already hold a reference to
dquot structures in ocfs2_setattr so neither of these functions can be called
while we call dquot_transfer. But this is rather subtle and it is hard to teach
lockdep about it. So provide __dquot_transfer function that can be passed dquot
references directly. OCFS2 can then pass acquired dquot references directly to
__dquot_transfer with proper locking.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         |   61 +++++++++++++++++++--------------------------
 include/linux/quotaops.h |    1 +
 2 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 0d09727..7c624e1 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1703,16 +1703,19 @@ EXPORT_SYMBOL(dquot_free_inode);
 
 /*
  * Transfer the number of inode and blocks from one diskquota to an other.
+ * On success, dquot references in transfer_to are consumed and references
+ * to original dquots that need to be released are placed there. On failure,
+ * references are kept untouched.
  *
  * This operation can block, but only after everything is updated
  * A transaction must be started when entering this function.
+ *
  */
-static int __dquot_transfer(struct inode *inode, qid_t *chid, unsigned long mask)
+int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 {
 	qsize_t space, cur_space;
 	qsize_t rsv_space = 0;
-	struct dquot *transfer_from[MAXQUOTAS];
-	struct dquot *transfer_to[MAXQUOTAS];
+	struct dquot *transfer_from[MAXQUOTAS] = {};
 	int cnt, ret = 0;
 	char warntype_to[MAXQUOTAS];
 	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
@@ -1722,19 +1725,12 @@ static int __dquot_transfer(struct inode *inode, qid_t *chid, unsigned long mask
 	if (IS_NOQUOTA(inode))
 		return 0;
 	/* Initialize the arrays */
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		transfer_from[cnt] = NULL;
-		transfer_to[cnt] = NULL;
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		warntype_to[cnt] = QUOTA_NL_NOWARN;
-	}
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (mask & (1 << cnt))
-			transfer_to[cnt] = dqget(inode->i_sb, chid[cnt], cnt);
-	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode)) {	/* File without quota accounting? */
 		up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
-		goto put_all;
+		return 0;
 	}
 	spin_lock(&dq_data_lock);
 	cur_space = inode_get_bytes(inode);
@@ -1786,46 +1782,41 @@ static int __dquot_transfer(struct inode *inode, qid_t *chid, unsigned long mask
 
 	mark_all_dquot_dirty(transfer_from);
 	mark_all_dquot_dirty(transfer_to);
-	/* The reference we got is transferred to the inode */
+	/* Pass back references to put */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		transfer_to[cnt] = NULL;
-warn_put_all:
+		transfer_to[cnt] = transfer_from[cnt];
+warn:
 	flush_warnings(transfer_to, warntype_to);
 	flush_warnings(transfer_from, warntype_from_inodes);
 	flush_warnings(transfer_from, warntype_from_space);
-put_all:
-	dqput_all(transfer_from);
-	dqput_all(transfer_to);
 	return ret;
 over_quota:
 	spin_unlock(&dq_data_lock);
 	up_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
-	/* Clear dquot pointers we don't want to dqput() */
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		transfer_from[cnt] = NULL;
-	goto warn_put_all;
+	goto warn;
 }
+EXPORT_SYMBOL(__dquot_transfer);
 
 /* Wrapper for transferring ownership of an inode for uid/gid only
  * Called from FSXXX_setattr()
  */
 int dquot_transfer(struct inode *inode, struct iattr *iattr)
 {
-	qid_t chid[MAXQUOTAS];
-	unsigned long mask = 0;
+	struct dquot *transfer_to[MAXQUOTAS] = {};
+	struct super_block *sb = inode->i_sb;
+	int ret;
 
-	if (iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) {
-		mask |= 1 << USRQUOTA;
-		chid[USRQUOTA] = iattr->ia_uid;
-	}
-	if (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid) {
-		mask |= 1 << GRPQUOTA;
-		chid[GRPQUOTA] = iattr->ia_gid;
-	}
-	if (sb_any_quota_active(inode->i_sb) && !IS_NOQUOTA(inode))
-		return __dquot_transfer(inode, chid, mask);
+	if (!sb_any_quota_active(sb) || IS_NOQUOTA(inode))
+		return 0;
 
-	return 0;
+	if (iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid)
+		transfer_to[USRQUOTA] = dqget(sb, iattr->ia_uid, USRQUOTA);
+	if (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)
+		transfer_to[GRPQUOTA] = dqget(sb, iattr->ia_uid, GRPQUOTA);
+
+	ret = __dquot_transfer(inode, transfer_to);
+	dqput_all(transfer_to);
+	return ret;
 }
 EXPORT_SYMBOL(dquot_transfer);
 
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 8a78187..370abb1 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -76,6 +76,7 @@ int vfs_get_dqblk(struct super_block *sb, int type, qid_t id,
 int vfs_set_dqblk(struct super_block *sb, int type, qid_t id,
 		struct fs_disk_quota *di);
 
+int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
 int dquot_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
-- 
1.6.4.2

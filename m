From: Jan Kara <jack@suse.cz>
Date: Wed, 26 Feb 2014 12:05:55 +0100
Subject: [Ocfs2-devel] [PATCH 3/6] quota: Provide function to grab quota
	structure reference
In-Reply-To: <1393412758-9764-1-git-send-email-jack@suse.cz>
References: <1393412758-9764-1-git-send-email-jack@suse.cz>
Message-ID: <1393412758-9764-4-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Provide dqgrab() function to get quota structure reference when we are
sure it already has at least one active reference. Make use of this
function inside quota code.

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 4 ++--
 include/linux/quotaops.h | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 831d49a4111f..e3f09e34d0b2 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -528,7 +528,7 @@ restart:
 		if (atomic_read(&dquot->dq_count)) {
 			DEFINE_WAIT(wait);
 
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			prepare_to_wait(&dquot->dq_wait_unused, &wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock(&dq_list_lock);
@@ -624,7 +624,7 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 			/* Now we have active dquot from which someone is
  			 * holding reference so we can safely just increase
 			 * use count */
-			atomic_inc(&dquot->dq_count);
+			dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
 			dqstats_inc(DQST_LOOKUPS);
 			err = sb->dq_op->write_dquot(dquot);
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 6965fe394c3b..1d3eee594cd6 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -46,6 +46,14 @@ void inode_reclaim_rsv_space(struct inode *inode, qsize_t number);
 void dquot_initialize(struct inode *inode);
 void dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, struct kqid qid);
+static inline struct dquot *dqgrab(struct dquot *dquot)
+{
+	/* Make sure someone else has active reference to dquot */
+	WARN_ON_ONCE(!atomic_read(&dquot->dq_count));
+	WARN_ON_ONCE(!test_bit(DQ_ACTIVE_B, &dquot->dq_flags));
+	atomic_inc(&dquot->dq_count);
+	return dquot;
+}
 void dqput(struct dquot *dquot);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
-- 
1.8.1.4

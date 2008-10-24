From: Jan Kara <jack@suse.cz>
Date: Sat, 25 Oct 2008 00:07:54 +0200
Subject: [Ocfs2-devel] [PATCH 01/29] quota: Add callbacks for allocating and
	destroying dquot structures
In-Reply-To: <122488610212-git-send-email-jack@suse.cz>
References: <122488610212-git-send-email-jack@suse.cz>
Message-ID: <12248861021475-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Some filesystems would like to keep private information together with each
dquot. Add callbacks alloc_dquot and destroy_dquot allowing filesystem to
allocate larger dquots from their private slab in a similar fashion we
currently allocate inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c            |   19 +++++++++++++++----
 include/linux/quota.h |    2 ++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index ad7e590..c228b31 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -417,6 +417,14 @@ out_dqlock:
 	return ret;
 }
 
+static void destroy_dquot(struct dquot *dquot)
+{
+	if (dquot->dq_sb->dq_op->destroy_dquot)
+		dquot->dq_sb->dq_op->destroy_dquot(dquot);
+	else
+		kmem_cache_free(dquot_cachep, dquot);
+}
+
 /* Invalidate all dquots on the list. Note that this function is called after
  * quota is disabled and pointers from inodes removed so there cannot be new
  * quota users. There can still be some users of quotas due to inodes being
@@ -465,7 +473,7 @@ restart:
 		remove_dquot_hash(dquot);
 		remove_free_dquot(dquot);
 		remove_inuse(dquot);
-		kmem_cache_free(dquot_cachep, dquot);
+		destroy_dquot(dquot);
 	}
 	spin_unlock(&dq_list_lock);
 }
@@ -529,7 +537,7 @@ static void prune_dqcache(int count)
 		remove_dquot_hash(dquot);
 		remove_free_dquot(dquot);
 		remove_inuse(dquot);
-		kmem_cache_free(dquot_cachep, dquot);
+		destroy_dquot(dquot);
 		count--;
 		head = free_dquots.prev;
 	}
@@ -631,7 +639,10 @@ static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 {
 	struct dquot *dquot;
 
-	dquot = kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
+	if (sb->dq_op->alloc_dquot)
+		dquot = sb->dq_op->alloc_dquot(sb, type);
+	else
+		dquot = kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
 	if(!dquot)
 		return NODQUOT;
 
@@ -684,7 +695,7 @@ we_slept:
 		dqstats.lookups++;
 		spin_unlock(&dq_list_lock);
 		if (empty)
-			kmem_cache_free(dquot_cachep, empty);
+			destroy_dquot(empty);
 	}
 	/* Wait for dq_lock - after this we know that either dquot_release() is already
 	 * finished or it will be canceled due to dq_count > 1 test */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 376a050..eeae7a9 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -294,6 +294,8 @@ struct dquot_operations {
 	int (*free_inode) (const struct inode *, unsigned long);
 	int (*transfer) (struct inode *, struct iattr *);
 	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
+	struct dquot *(*alloc_dquot)(struct super_block *, int);	/* Allocate memory for new dquot (can be NULL if no special entries dquot are needed) */
+	void (*destroy_dquot)(struct dquot *);		/* Free memory for dquot (can be NULL if alloc_dquot is NULL) */
 	int (*acquire_dquot) (struct dquot *);		/* Quota is going to be created on disk */
 	int (*release_dquot) (struct dquot *);		/* Quota is going to be deleted from disk */
 	int (*mark_dirty) (struct dquot *);		/* Dquot is marked dirty */
-- 
1.5.2.4

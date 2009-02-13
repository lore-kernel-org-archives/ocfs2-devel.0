From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:15:52 -0800
Subject: [Ocfs2-devel] [PATCH 05/40] ocfs2: move ip_created_trans to struct
	ocfs2_caching_info
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Similar ip_last_trans, ip_created_trans tracks the creation of a journal
managed inode.  This specifically tracks what transaction created the
inode.  This is so the code can know if the inode has ever been written
to disk.

This behavior is desirable for any journal managed object.  We move it
to struct ocfs2_caching_info as ci_created_trans so that any object
using ocfs2_caching_info can rely on this behavior.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/inode.c    |    1 -
 fs/ocfs2/inode.h    |    4 ----
 fs/ocfs2/journal.h  |    6 +++---
 fs/ocfs2/ocfs2.h    |    3 +++
 fs/ocfs2/super.c    |    1 -
 fs/ocfs2/uptodate.c |    4 +++-
 6 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9cefa54..7c3a380 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1099,7 +1099,6 @@ void ocfs2_clear_inode(struct inode *inode)
 
 	/* Clear all other flags. */
 	oi->ip_flags = 0;
-	oi->ip_created_trans = 0;
 	oi->ip_dir_start_lookup = 0;
 	oi->ip_blkno = 0ULL;
 
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index 7467f1d..4660962 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -60,10 +60,6 @@ struct ocfs2_inode_info
 
 	u32				ip_dir_start_lookup;
 
-	/* next two are protected by trans_inc_lock */
-	/* which transaction were we created on? Zero if none. */
-	unsigned long			ip_created_trans;
-
 	struct ocfs2_caching_info	ip_metadata_cache;
 
 	struct ocfs2_extent_map		ip_extent_map;
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index ef75dbb..ff4b526 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -118,9 +118,9 @@ static inline int ocfs2_inode_is_new(struct inode *inode)
 		return 0;
 	spin_lock(&trans_inc_lock);
 	ret = !(time_after(OCFS2_SB(inode->i_sb)->journal->j_trans_id,
-			   OCFS2_I(inode)->ip_created_trans));
+			   INODE_CACHE(inode)->ci_created_trans));
 	if (!ret)
-		OCFS2_I(inode)->ip_created_trans = 0;
+		INODE_CACHE(inode)->ci_created_trans = 0;
 	spin_unlock(&trans_inc_lock);
 	return ret;
 }
@@ -129,7 +129,7 @@ static inline void ocfs2_inode_set_new(struct ocfs2_super *osb,
 				       struct inode *inode)
 {
 	spin_lock(&trans_inc_lock);
-	OCFS2_I(inode)->ip_created_trans = osb->journal->j_trans_id;
+	INODE_CACHE(inode)->ci_created_trans = osb->journal->j_trans_id;
 	spin_unlock(&trans_inc_lock);
 }
 
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 04cd9ef..049ba23 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -73,6 +73,9 @@ struct ocfs2_caching_info {
 	 */
 	const struct ocfs2_caching_operations *ci_ops;
 
+	/* next two are protected by trans_inc_lock */
+	/* which transaction were we created on? Zero if none. */
+	unsigned long		ci_created_trans;
 	/* last transaction we were a part of. */
 	unsigned long		ci_last_trans;
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b0532d2..6497559 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1448,7 +1448,6 @@ static void ocfs2_inode_init_once(void *data)
 	spin_lock_init(&oi->ip_lock);
 	ocfs2_extent_map_init(&oi->vfs_inode);
 	INIT_LIST_HEAD(&oi->ip_io_markers);
-	oi->ip_created_trans = 0;
 	oi->ip_dir_start_lookup = 0;
 
 	init_rwsem(&oi->ip_alloc_sem);
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 81c8220..b6284f2 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -124,8 +124,10 @@ static void ocfs2_metadata_cache_reset(struct ocfs2_caching_info *ci,
 	ci->ci_flags |= OCFS2_CACHE_FL_INLINE;
 	ci->ci_num_cached = 0;
 
-	if (clear)
+	if (clear) {
+		ci->ci_created_trans = 0;
 		ci->ci_last_trans = 0;
+	}
 }
 
 void ocfs2_metadata_cache_init(struct ocfs2_caching_info *ci,
-- 
1.5.6.5

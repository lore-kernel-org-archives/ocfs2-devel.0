From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 28 Sep 2015 20:38:05 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: only take lock if dio entry when
	recover orphans
Message-ID: <560934AD.5050107@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We have no need to take inode mutex, rw and inode lock if it is not dio
entry when recover orphans. Optimize it by adding a flag
OCFS2_INODE_DIO_ORPHAN_ENTRY to ocfs2_inode_info to reduce contention.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/inode.h   |  2 ++
 fs/ocfs2/journal.c | 86 +++++++++++++++++++++++++++++-------------------------
 2 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index ca3431e..aac8b86 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -112,6 +112,8 @@ struct ocfs2_inode_info
 #define OCFS2_INODE_OPEN_DIRECT		0x00000020
 /* Tell the inode wipe code it's not in orphan dir */
 #define OCFS2_INODE_SKIP_ORPHAN_DIR     0x00000040
+/* Entry in orphan dir with 'dio-' prefix */
+#define OCFS2_INODE_DIO_ORPHAN_ENTRY	0x00000080

 static inline struct ocfs2_inode_info *OCFS2_I(struct inode *inode)
 {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index bde475f..627d88c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2033,6 +2033,10 @@ static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
 	if (IS_ERR(iter))
 		return 0;

+	if (!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
+			OCFS2_DIO_ORPHAN_PREFIX_LEN))
+		OCFS2_I(iter)->ip_flags |= OCFS2_INODE_DIO_ORPHAN_ENTRY;
+
 	/* Skip inodes which are already added to recover list, since dio may
 	 * happen concurrently with unlink/rename */
 	if (OCFS2_I(iter)->ip_next_orphan) {
@@ -2179,25 +2183,51 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 		iter = oi->ip_next_orphan;
 		oi->ip_next_orphan = NULL;

-		mutex_lock(&inode->i_mutex);
-		ret = ocfs2_rw_lock(inode, 1);
-		if (ret < 0) {
-			mlog_errno(ret);
-			goto next;
-		}
-		/*
-		 * We need to take and drop the inode lock to
-		 * force read inode from disk.
-		 */
-		ret = ocfs2_inode_lock(inode, &di_bh, 1);
-		if (ret) {
-			mlog_errno(ret);
-			goto unlock_rw;
-		}
+		if (oi->ip_flags & OCFS2_INODE_DIO_ORPHAN_ENTRY) {
+			mutex_lock(&inode->i_mutex);
+			ret = ocfs2_rw_lock(inode, 1);
+			if (ret < 0) {
+				mlog_errno(ret);
+				goto unlock_mutex;
+			}
+			/*
+			 * We need to take and drop the inode lock to
+			 * force read inode from disk.
+			 */
+			ret = ocfs2_inode_lock(inode, &di_bh, 1);
+			if (ret) {
+				mlog_errno(ret);
+				goto unlock_rw;
+			}

-		di = (struct ocfs2_dinode *)di_bh->b_data;
+			di = (struct ocfs2_dinode *)di_bh->b_data;

-		if (inode->i_nlink == 0) {
+			if (di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)) {
+				ret = ocfs2_truncate_file(inode, di_bh,
+						i_size_read(inode));
+				if (ret < 0) {
+					if (ret != -ENOSPC)
+						mlog_errno(ret);
+					goto unlock_inode;
+				}
+
+				ret = ocfs2_del_inode_from_orphan(osb, inode,
+						di_bh, 0, 0);
+				if (ret)
+					mlog_errno(ret);
+			}
+unlock_inode:
+			ocfs2_inode_unlock(inode, 1);
+			brelse(di_bh);
+			di_bh = NULL;
+unlock_rw:
+			ocfs2_rw_unlock(inode, 1);
+unlock_mutex:
+			mutex_unlock(&inode->i_mutex);
+
+			/* clear dio flag in ocfs2_inode_info */
+			oi->ip_flags &= ~OCFS2_INODE_DIO_ORPHAN_ENTRY;
+		} else {
 			spin_lock(&oi->ip_lock);
 			/* Set the proper information to get us going into
 			 * ocfs2_delete_inode. */
@@ -2205,28 +2235,6 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 			spin_unlock(&oi->ip_lock);
 		}

-		if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
-				(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
-			ret = ocfs2_truncate_file(inode, di_bh,
-					i_size_read(inode));
-			if (ret < 0) {
-				if (ret != -ENOSPC)
-					mlog_errno(ret);
-				goto unlock_inode;
-			}
-
-			ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
-			if (ret)
-				mlog_errno(ret);
-		} /* else if ORPHAN_NO_NEED_TRUNCATE, do nothing */
-unlock_inode:
-		ocfs2_inode_unlock(inode, 1);
-		brelse(di_bh);
-		di_bh = NULL;
-unlock_rw:
-		ocfs2_rw_unlock(inode, 1);
-next:
-		mutex_unlock(&inode->i_mutex);
 		iput(inode);
 		inode = iter;
 	}
-- 
1.8.4.3

From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 27 May 2015 10:52:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix race between crashed dio and rm
Message-ID: <5565316F.2020203@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There is a race case between crashed dio and rm, which will lead to
OCFS2_VALID_FL not set read-only.

N1                              N2
------------------------------------------------------------------------
dd with direct flag
                                rm file
crashed with an dio entry left
in orphan dir
                                clear OCFS2_VALID_FL in
                                ocfs2_remove_inode
                                recover N1 and read the corrupted inode,
                                and set filesystem read-only

So we skip the inode deletion this time and wait for dio entry
recovered first.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/inode.c   | 9 +++++++++
 fs/ocfs2/journal.c | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b254416..c0a9211 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -971,6 +971,7 @@ static void ocfs2_delete_inode(struct inode *inode)
 	int wipe, status;
 	sigset_t oldset;
 	struct buffer_head *di_bh = NULL;
+	struct ocfs2_dinode *di = NULL;

 	trace_ocfs2_delete_inode(inode->i_ino,
 				 (unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -1025,6 +1026,14 @@ static void ocfs2_delete_inode(struct inode *inode)
 		goto bail_unlock_nfs_sync;
 	}

+	di = (struct ocfs2_dinode *)di_bh->b_data;
+	/* Skip inode deletion and wait for dio orphan entry recovered
+	 * first */
+	if (unlikely(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
+		ocfs2_cleanup_delete_inode(inode, 0);
+		goto bail_unlock_inode;
+	}
+
 	/* Query the cluster. This will be the final decision made
 	 * before we go ahead and wipe the inode. */
 	status = ocfs2_query_inode_wipe(inode, di_bh, &wipe);
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 72db49c..be77f3c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2195,7 +2195,9 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 			 * ocfs2_delete_inode. */
 			oi->ip_flags |= OCFS2_INODE_MAYBE_ORPHANED;
 			spin_unlock(&oi->ip_lock);
-		} else if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
+		}
+
+		if ((orphan_reco_type == ORPHAN_NEED_TRUNCATE) &&
 				(di->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL))) {
 			ret = ocfs2_truncate_file(inode, di_bh,
 					i_size_read(inode));
-- 
1.8.4.3

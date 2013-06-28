From: Younger Liu <younger.liu@huawei.com>
Date: Fri, 28 Jun 2013 14:50:59 +0800
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: need rollback when journal_access
	failed in ocfs2_orphan_add()
Message-ID: <51CD3253.3020200@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While adding a file into orphan dir in ocfs2_orphan_add(),
it calls __ocfs2_add_entry() before ocfs2_journal_access_di(). 
If ocfs2_journal_access_di() failed, the file is added into 
orphan dir, and orphan dir dinode updated, but file dinode 
has not been updated.
Accordingly, the data is not consistent between file dinode 
and orphan dir.

So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(),
and if ocfs2_journal_access_di() failed, orphan_fe and 
orphan_dir_inode->i_nlink need rollback. 

This bug is introduced by commits 3939fda4.

Compared with the PATCH V2, this patch cleans up mlog_errno(status) 
which was called two times for the same error.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ocfs2/namei.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f53471d..52061b3 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2012,6 +2012,21 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 		goto leave;
 	}
 
+	/*
+	 * We're going to journal the change of i_flags and i_orphaned_slot.
+	 * It's safe anyway, though some callers may duplicate the journaling.
+	 * Journaling within the func just make the logic look more
+	 * straightforward.
+	 */
+	status = ocfs2_journal_access_di(handle,
+					 INODE_CACHE(inode),
+					 fe_bh,
+					 OCFS2_JOURNAL_ACCESS_WRITE);
+	if (status < 0) {
+		mlog_errno(status);
+		goto leave;
+	}
+
 	/* we're a cluster, and nlink can change on disk from
 	 * underneath us... */
 	orphan_fe = (struct ocfs2_dinode *) orphan_dir_bh->b_data;
@@ -2026,22 +2041,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 				   orphan_dir_bh, lookup);
 	if (status < 0) {
 		mlog_errno(status);
-		goto leave;
-	}
-
-	/*
-	 * We're going to journal the change of i_flags and i_orphaned_slot.
-	 * It's safe anyway, though some callers may duplicate the journaling.
-	 * Journaling within the func just make the logic look more
-	 * straightforward.
-	 */
-	status = ocfs2_journal_access_di(handle,
-					 INODE_CACHE(inode),
-					 fe_bh,
-					 OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
+		goto rollback;
 	}
 
 	fe->i_flags |= cpu_to_le32(OCFS2_ORPHANED_FL);
@@ -2057,11 +2057,16 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	trace_ocfs2_orphan_add_end((unsigned long long)OCFS2_I(inode)->ip_blkno,
 				   osb->slot_num);
 
+rollback:
+	if (status < 0) {
+		if (S_ISDIR(inode->i_mode))
+			ocfs2_add_links_count(orphan_fe, -1);
+		set_nlink(orphan_dir_inode, ocfs2_read_links_count(orphan_fe));
+	}
+
 leave:
 	brelse(orphan_dir_bh);
 
-	if (status)
-		mlog_errno(status);
 	return status;
 }
 
-- 
1.7.9.7

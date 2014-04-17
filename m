From: alex chen <alex.chen@huawei.com>
Date: Thu, 17 Apr 2014 19:05:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: should add inode into orphan dir after
 updating entry in ocfs2_rename()
Message-ID: <534FB566.4050608@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

There are two files a and b in dir /mnt/ocfs2.
    node A                           node B
mv a b
In ocfs2_rename(), after calling
ocfs2_orphan_add(), the inode of
file b will be added into orphan
dir.

If ocfs2_update_entry() fails,
ocfs2_rename return error and mv
operation fails. But file b still
exists in the parent dir.

ocfs2_queue_orphan_scan
-> ocfs2_queue_recovery_completion
-> ocfs2_complete_recovery
-> ocfs2_recover_orphans
The inode of the file b will be
put with iput().

ocfs2_evict_inode
-> ocfs2_delete_inode
-> ocfs2_wipe_inode
-> ocfs2_remove_inode
OCFS2_VALID_FL in the inode
i_flags will be cleared.

                                   The file b still can be accessed
                                   on node B.
                                   ls /mnt/ocfs2
                                   When first read the file b with
                                   ocfs2_read_inode_block(). It will
                                   validate the inode using
                                   ocfs2_validate_inode_block().
                                   Because OCFS2_VALID_FL not set in
                                   the inode i_flags, so the file
                                   system will be readonly.

So we should add inode into orphan dir after updating entry in
ocfs2_rename().

Signed-off-by: alex.chen <alex.chen@huawei.com>
---
 fs/ocfs2/namei.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f4d609b..36534ee 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1081,6 +1081,7 @@ static int ocfs2_rename(struct inode *old_dir,
 	struct ocfs2_dir_lookup_result old_entry_lookup = { NULL, };
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 	struct ocfs2_dir_lookup_result target_insert = { NULL, };
+	bool should_add_orphan = false;

 	/* At some point it might be nice to break this function up a
 	 * bit. */
@@ -1287,6 +1288,7 @@ static int ocfs2_rename(struct inode *old_dir,
 				mlog_errno(status);
 				goto bail;
 			}
+			should_add_orphan = true;
 		}
 	} else {
 		BUG_ON(new_dentry->d_parent->d_inode != new_dir);
@@ -1331,17 +1333,6 @@ static int ocfs2_rename(struct inode *old_dir,
 			goto bail;
 		}

-		if (S_ISDIR(new_inode->i_mode) ||
-		    (ocfs2_read_links_count(newfe) == 1)) {
-			status = ocfs2_orphan_add(osb, handle, new_inode,
-						  newfe_bh, orphan_name,
-						  &orphan_insert, orphan_dir);
-			if (status < 0) {
-				mlog_errno(status);
-				goto bail;
-			}
-		}
-
 		/* change the dirent to point to the correct inode */
 		status = ocfs2_update_entry(new_dir, handle, &target_lookup_res,
 					    old_inode);
@@ -1356,6 +1347,15 @@ static int ocfs2_rename(struct inode *old_dir,
 		else
 			ocfs2_add_links_count(newfe, -1);
 		ocfs2_journal_dirty(handle, newfe_bh);
+		if (should_add_orphan) {
+			status = ocfs2_orphan_add(osb, handle, new_inode,
+					newfe_bh, orphan_name,
+					&orphan_insert, orphan_dir);
+			if (status < 0) {
+				mlog_errno(status);
+				goto bail;
+			}
+		}
 	} else {
 		/* if the name was not found in new_dir, add it now */
 		status = ocfs2_add_entry(handle, new_dentry, old_inode,
-- 
1.8.4.3

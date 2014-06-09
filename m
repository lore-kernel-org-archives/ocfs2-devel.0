From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 09 Jun 2014 13:03:59 -0700
Subject: [Ocfs2-devel] [patch 1/8] ocfs2: should add inode into orphan dir
	after updating entry in ocfs2_rename()
Message-ID: <20140609200400.1AB405A4A6F@corp2gmr1-2.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: should add inode into orphan dir after updating entry in ocfs2_rename()

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
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-should-add-inode-into-orphan-dir-after-updating-entry-in-ocfs2_rename
+++ a/fs/ocfs2/namei.c
@@ -1098,6 +1098,7 @@ static int ocfs2_rename(struct inode *ol
 	struct ocfs2_dir_lookup_result old_entry_lookup = { NULL, };
 	struct ocfs2_dir_lookup_result orphan_insert = { NULL, };
 	struct ocfs2_dir_lookup_result target_insert = { NULL, };
+	bool should_add_orphan = false;
 
 	/* At some point it might be nice to break this function up a
 	 * bit. */
@@ -1304,6 +1305,7 @@ static int ocfs2_rename(struct inode *ol
 				mlog_errno(status);
 				goto bail;
 			}
+			should_add_orphan = true;
 		}
 	} else {
 		BUG_ON(new_dentry->d_parent->d_inode != new_dir);
@@ -1348,17 +1350,6 @@ static int ocfs2_rename(struct inode *ol
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
@@ -1373,6 +1364,15 @@ static int ocfs2_rename(struct inode *ol
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
_

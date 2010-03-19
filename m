From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 19 Mar 2010 09:21:09 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Journaling i_flags and
	i_orphaned_slot when adding inode to orphan dir.
Message-ID: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, some callers were missing to journal the dirty inode after
adding it to orphan dir.

Now we're going to journal such modifications within the ocfs2_orphan_add()
itself, It's safe to do so, though some existing caller may duplicate this,
and it makes the logic look more straightforward anyway.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/namei.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 50fb26a..5ad79ec 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -84,7 +84,7 @@ static int ocfs2_prepare_orphan_dir(struct ocfs2_super *osb,
 static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
-			    struct ocfs2_dinode *fe,
+			    struct buffer_head *fe_bh,
 			    char *name,
 			    struct ocfs2_dir_lookup_result *lookup,
 			    struct inode *orphan_dir_inode);
@@ -877,7 +877,7 @@ static int ocfs2_unlink(struct inode *dir,
 	fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
 	if (inode_is_unlinkable(inode)) {
-		status = ocfs2_orphan_add(osb, handle, inode, fe, orphan_name,
+		status = ocfs2_orphan_add(osb, handle, inode, fe_bh, orphan_name,
 					  &orphan_insert, orphan_dir);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1295,7 +1295,7 @@ static int ocfs2_rename(struct inode *old_dir,
 		if (S_ISDIR(new_inode->i_mode) ||
 		    (ocfs2_read_links_count(newfe) == 1)) {
 			status = ocfs2_orphan_add(osb, handle, new_inode,
-						  newfe, orphan_name,
+						  newfe_bh, orphan_name,
 						  &orphan_insert, orphan_dir);
 			if (status < 0) {
 				mlog_errno(status);
@@ -1909,7 +1909,7 @@ leave:
 static int ocfs2_orphan_add(struct ocfs2_super *osb,
 			    handle_t *handle,
 			    struct inode *inode,
-			    struct ocfs2_dinode *fe,
+			    struct buffer_head *fe_bh,
 			    char *name,
 			    struct ocfs2_dir_lookup_result *lookup,
 			    struct inode *orphan_dir_inode)
@@ -1917,6 +1917,7 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	struct buffer_head *orphan_dir_bh = NULL;
 	int status = 0;
 	struct ocfs2_dinode *orphan_fe;
+	struct ocfs2_dinode *fe = (struct ocfs2_dinode *) fe_bh->b_data;
 
 	mlog_entry("(inode->i_ino = %lu)\n", inode->i_ino);
 
@@ -1957,6 +1958,21 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
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
 	le32_add_cpu(&fe->i_flags, OCFS2_ORPHANED_FL);
 
 	/* Record which orphan dir our inode now resides
@@ -1964,6 +1980,8 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,
 	 * dir to lock. */
 	fe->i_orphaned_slot = cpu_to_le16(osb->slot_num);
 
+	ocfs2_journal_dirty(handle, fe_bh);
+
 	mlog(0, "Inode %llu orphaned in slot %d\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno, osb->slot_num);
 
@@ -2125,7 +2143,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	}
 
 	di = (struct ocfs2_dinode *)new_di_bh->b_data;
-	status = ocfs2_orphan_add(osb, handle, inode, di, orphan_name,
+	status = ocfs2_orphan_add(osb, handle, inode, new_di_bh, orphan_name,
 				  &orphan_insert, orphan_dir);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.5.5

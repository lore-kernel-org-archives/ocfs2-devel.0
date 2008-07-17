From: Sabuj Pattanayek <sabujp@gmail.com>
Date: Thu, 17 Jul 2008 04:07:26 -0500
Subject: [Ocfs2-devel] ocfs2_jbd2.patch for linux-2.6.26
Message-ID: <e64671580807170207ob041c82qaaed5009996c4dda@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

Here's a patch to make OCFS2 work with JBD2, i.e. so we can create
volumes greater than 16T. Patch and compile against the 2.6.26
mainline kernel sources:

--- ./fs/ocfs2/ocfs2.h.old	2008-07-17 01:23:30.000000000 -0500
+++ ./fs/ocfs2/ocfs2.h	2008-07-17 01:24:24.000000000 -0500
@@ -34,7 +34,7 @@
 #include <linux/workqueue.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
-#include <linux/jbd.h>
+#include <linux/jbd2.h>

 /* For union ocfs2_dlm_lksb */
 #include "stackglue.h"
--- ./fs/ocfs2/aops.c.old	2008-07-17 01:43:50.000000000 -0500
+++ ./fs/ocfs2/aops.c	2008-07-17 01:47:37.000000000 -0500
@@ -662,7 +662,7 @@
 {
 	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;

-	journal_invalidatepage(journal, page, offset);
+	jbd2_journal_invalidatepage(journal, page, offset);
 }

 static int ocfs2_releasepage(struct page *page, gfp_t wait)
@@ -671,7 +671,7 @@

 	if (!page_has_buffers(page))
 		return 0;
-	return journal_try_to_free_buffers(journal, page, wait);
+	return jbd2_journal_try_to_free_buffers(journal, page, wait);
 }

 static ssize_t ocfs2_direct_IO(int rw,
--- ./fs/ocfs2/journal.c.old	2008-07-17 01:53:31.000000000 -0500
+++ ./fs/ocfs2/journal.c	2008-07-17 02:05:43.000000000 -0500
@@ -215,9 +215,9 @@
 		goto finally;
 	}

-	journal_lock_updates(journal->j_journal);
-	status = journal_flush(journal->j_journal);
-	journal_unlock_updates(journal->j_journal);
+	jbd2_journal_lock_updates(journal->j_journal);
+	status = jbd2_journal_flush(journal->j_journal);
+	jbd2_journal_unlock_updates(journal->j_journal);
 	if (status < 0) {
 		up_write(&journal->j_trans_barrier);
 		mlog_errno(status);
@@ -264,7 +264,7 @@

 	down_read(&osb->journal->j_trans_barrier);

-	handle = journal_start(journal, max_buffs);
+	handle = jbd2_journal_start(journal, max_buffs);
 	if (IS_ERR(handle)) {
 		up_read(&osb->journal->j_trans_barrier);

@@ -290,7 +290,7 @@

 	BUG_ON(!handle);

-	ret = journal_stop(handle);
+	ret = jbd2_journal_stop(handle);
 	if (ret < 0)
 		mlog_errno(ret);

@@ -332,7 +332,7 @@
 #ifdef OCFS2_DEBUG_FS
 	status = 1;
 #else
-	status = journal_extend(handle, nblocks);
+	status = jbd2_journal_extend(handle, nblocks);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -341,7 +341,7 @@

 	if (status > 0) {
 		mlog(0, "journal_extend failed, trying journal_restart\n");
-		status = journal_restart(handle, nblocks);
+		status = jbd2_journal_restart(handle, nblocks);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
@@ -393,11 +393,11 @@
 	switch (type) {
 	case OCFS2_JOURNAL_ACCESS_CREATE:
 	case OCFS2_JOURNAL_ACCESS_WRITE:
-		status = journal_get_write_access(handle, bh);
+		status = jbd2_journal_get_write_access(handle, bh);
 		break;

 	case OCFS2_JOURNAL_ACCESS_UNDO:
-		status = journal_get_undo_access(handle, bh);
+		status = jbd2_journal_get_undo_access(handle, bh);
 		break;

 	default:
@@ -422,7 +422,7 @@
 	mlog_entry("(bh->b_blocknr=%llu)\n",
 		   (unsigned long long)bh->b_blocknr);

-	status = journal_dirty_metadata(handle, bh);
+	status = jbd2_journal_dirty_metadata(handle, bh);
 	if (status < 0)
 		mlog(ML_ERROR, "Could not dirty metadata buffer. "
 		     "(bh->b_blocknr=%llu)\n",
@@ -435,7 +435,7 @@
 int ocfs2_journal_dirty_data(handle_t *handle,
 			     struct buffer_head *bh)
 {
-	int err = journal_dirty_data(handle, bh);
+	int err = jbd2_journal_dirty_data(handle, bh);
 	if (err)
 		mlog_errno(err);
 	/* TODO: When we can handle it, abort the handle and go RO on
@@ -444,7 +444,7 @@
 	return err;
 }

-#define OCFS2_DEFAULT_COMMIT_INTERVAL 	(HZ * JBD_DEFAULT_MAX_COMMIT_AGE)
+#define OCFS2_DEFAULT_COMMIT_INTERVAL 	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)

 void ocfs2_set_journal_params(struct ocfs2_super *osb)
 {
@@ -457,9 +457,9 @@
 	spin_lock(&journal->j_state_lock);
 	journal->j_commit_interval = commit_interval;
 	if (osb->s_mount_opt & OCFS2_MOUNT_BARRIER)
-		journal->j_flags |= JFS_BARRIER;
+		journal->j_flags |= JBD2_BARRIER;
 	else
-		journal->j_flags &= ~JFS_BARRIER;
+		journal->j_flags &= ~JBD2_BARRIER;
 	spin_unlock(&journal->j_state_lock);
 }

@@ -524,7 +524,7 @@
 	mlog(0, "inode->ip_clusters = %u\n", OCFS2_I(inode)->ip_clusters);

 	/* call the kernels journal init function now */
-	j_journal = journal_init_inode(inode);
+	j_journal = jbd2_journal_init_inode(inode);
 	if (j_journal == NULL) {
 		mlog(ML_ERROR, "Linux journal layer error\n");
 		status = -EINVAL;
@@ -655,9 +655,9 @@
 	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);

 	if (ocfs2_mount_local(osb)) {
-		journal_lock_updates(journal->j_journal);
-		status = journal_flush(journal->j_journal);
-		journal_unlock_updates(journal->j_journal);
+		jbd2_journal_lock_updates(journal->j_journal);
+		status = jbd2_journal_flush(journal->j_journal);
+		jbd2_journal_unlock_updates(journal->j_journal);
 		if (status < 0)
 			mlog_errno(status);
 	}
@@ -673,7 +673,7 @@
 	}

 	/* Shutdown the kernel journal system */
-	journal_destroy(journal->j_journal);
+	jbd2_journal_destroy(journal->j_journal);

 	OCFS2_I(inode)->ip_open_count--;

@@ -698,15 +698,15 @@
 {
 	int olderr;

-	olderr = journal_errno(journal);
+	olderr = jbd2_journal_errno(journal);
 	if (olderr) {
 		mlog(ML_ERROR, "File system error %d recorded in "
 		     "journal %u.\n", olderr, slot);
 		mlog(ML_ERROR, "File system on device %s needs checking.\n",
 		     sb->s_id);

-		journal_ack_err(journal);
-		journal_clear_err(journal);
+		jbd2_journal_ack_err(journal);
+		jbd2_journal_clear_err(journal);
 	}
 }

@@ -721,7 +721,7 @@

 	osb = journal->j_osb;

-	status = journal_load(journal->j_journal);
+	status = jbd2_journal_load(journal->j_journal);
 	if (status < 0) {
 		mlog(ML_ERROR, "Failed to load journal!\n");
 		goto done;
@@ -765,7 +765,7 @@

 	BUG_ON(!journal);

-	status = journal_wipe(journal->j_journal, full);
+	status = jbd2_journal_wipe(journal->j_journal, full);
 	if (status < 0) {
 		mlog_errno(status);
 		goto bail;
@@ -1157,19 +1157,19 @@
 	}

 	mlog(0, "calling journal_init_inode\n");
-	journal = journal_init_inode(inode);
+	journal = jbd2_journal_init_inode(inode);
 	if (journal == NULL) {
 		mlog(ML_ERROR, "Linux journal layer error\n");
 		status = -EIO;
 		goto done;
 	}

-	status = journal_load(journal);
+	status = jbd2_journal_load(journal);
 	if (status < 0) {
 		mlog_errno(status);
 		if (!igrab(inode))
 			BUG();
-		journal_destroy(journal);
+		jbd2_journal_destroy(journal);
 		goto done;
 	}

@@ -1177,9 +1177,9 @@

 	/* wipe the journal */
 	mlog(0, "flushing the journal.\n");
-	journal_lock_updates(journal);
-	status = journal_flush(journal);
-	journal_unlock_updates(journal);
+	jbd2_journal_lock_updates(journal);
+	status = jbd2_journal_flush(journal);
+	jbd2_journal_unlock_updates(journal);
 	if (status < 0)
 		mlog_errno(status);

@@ -1195,7 +1195,7 @@
 	if (!igrab(inode))
 		BUG();

-	journal_destroy(journal);
+	jbd2_journal_destroy(journal);

 done:
 	/* drop the lock on this nodes journal */
--- ./fs/ocfs2/journal.h.old	2008-07-17 01:23:23.000000000 -0500
+++ ./fs/ocfs2/journal.h	2008-07-17 01:24:01.000000000 -0500
@@ -27,7 +27,7 @@
 #define OCFS2_JOURNAL_H

 #include <linux/fs.h>
-#include <linux/jbd.h>
+#include <linux/jbd2.h>

 enum ocfs2_journal_state {
 	OCFS2_JOURNAL_FREE = 0,
--- ./fs/ocfs2/super.c.old	2008-07-17 02:06:33.000000000 -0500
+++ ./fs/ocfs2/super.c	2008-07-17 03:51:45.000000000 -0500
@@ -205,9 +205,9 @@
 		ocfs2_schedule_truncate_log_flush(osb, 0);
 	}

-	if (journal_start_commit(OCFS2_SB(sb)->journal->j_journal, &target)) {
+	if (jbd2_journal_start_commit(OCFS2_SB(sb)->journal->j_journal, &target)) {
 		if (wait)
-			log_wait_commit(OCFS2_SB(sb)->journal->j_journal,
+			jbd2_log_wait_commit(OCFS2_SB(sb)->journal->j_journal,
 					target);
 	}
 	return 0;
@@ -873,7 +873,7 @@
 			if (option < 0)
 				return 0;
 			if (option == 0)
-				option = JBD_DEFAULT_MAX_COMMIT_AGE;
+				option = JBD2_DEFAULT_MAX_COMMIT_AGE;
 			mopt->commit_interval = HZ * option;
 			break;
 		case Opt_localalloc:
@@ -1536,9 +1536,9 @@
 	}

 	if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
-	    > (u32)~0UL) {
+	    > (u64)~0UL) {
 		mlog(ML_ERROR, "Volume might try to write to blocks beyond "
-		     "what jbd can address in 32 bits.\n");
+		     "what jbd2 can address in 64 bits.\n");
 		status = -EINVAL;
 		goto bail;
 	}
--- ./fs/ocfs2/file.c.old	2008-07-17 01:48:27.000000000 -0500
+++ ./fs/ocfs2/file.c	2008-07-17 01:50:09.000000000 -0500
@@ -184,7 +184,7 @@
 		goto bail;

 	journal = osb->journal->j_journal;
-	err = journal_force_commit(journal);
+	err = jbd2_journal_force_commit(journal);

 bail:
 	mlog_exit(err);
@@ -2040,7 +2040,7 @@
 		 */
 		if (old_size != i_size_read(inode) ||
 		    old_clusters != OCFS2_I(inode)->ip_clusters) {
-			ret = journal_force_commit(osb->journal->j_journal);
+			ret = jbd2_journal_force_commit(osb->journal->j_journal);
 			if (ret < 0)
 				written = ret;
 		}
--- ./fs/ocfs2/uptodate.c.old	2008-07-17 01:23:46.000000000 -0500
+++ ./fs/ocfs2/uptodate.c	2008-07-17 01:24:38.000000000 -0500
@@ -53,7 +53,7 @@
 #include <linux/highmem.h>
 #include <linux/buffer_head.h>
 #include <linux/rbtree.h>
-#include <linux/jbd.h>
+#include <linux/jbd2.h>

 #define MLOG_MASK_PREFIX ML_UPTODATE

More patches and testing dumps will be posted in the ocfs2-tools-devel
list for mkfs.ocfs2 and tunefs.ocfs2 .

Cheers,
Sabuj Pattanayek (t35t0r/irc.freenode.net/#linux-cluster)
Center For Structural Biology, Senior SysAdmin
http://structbio.vanderbilt.edu

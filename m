From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 16 Sep 2010 14:21:59 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Start ocfs2cmt even in local mode.
In-Reply-To: <4C91B707.8030502@oracle.com>
References: <4C91B707.8030502@oracle.com>
Message-ID: <1284618120-7989-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently in local mode, we don't start ocfs2cmt thread,
so all the journal flush work is done by jbd2.

But we now need to flush the journal if the truncate log has
collected too much clusters because in this case all the bits
which hasn't been committed can't be allocated again(check
function ocfs2_test_bg_bit_allocatable for details).

This patch just reverts some modification of commit c271c5c
so that now we can start journal commit by ourselves by calling
ocfs2_start_checkpoint. The changes include:
1. Start ocfs2cmt no matter whether we are in local mode or not.
2. Remove the 'local' parameter from ocfs2_journal_load since now
   we don't care.
3. Always increase j_num_trans in ocfs2_start_trans to make commit
   thread work.
4. Revert the change in ocfs2_journal_shutdown.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/journal.c |   45 ++++++++++++---------------------------------
 fs/ocfs2/journal.h |    3 +--
 fs/ocfs2/super.c   |    5 +----
 3 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9b57c03..e927532 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -374,10 +374,8 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 			ocfs2_abort(osb->sb, "Detected aborted journal");
 			handle = ERR_PTR(-EROFS);
 		}
-	} else {
-		if (!ocfs2_mount_local(osb))
-			atomic_inc(&(osb->journal->j_num_trans));
-	}
+	} else
+		atomic_inc(&(osb->journal->j_num_trans));
 
 	return handle;
 }
@@ -966,23 +964,9 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 
 	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
-		jbd2_journal_lock_updates(journal->j_journal);
-		status = jbd2_journal_flush(journal->j_journal);
-		jbd2_journal_unlock_updates(journal->j_journal);
-		if (status < 0)
-			mlog_errno(status);
-	}
-
-	if (status == 0) {
-		/*
-		 * Do not toggle if flush was unsuccessful otherwise
-		 * will leave dirty metadata in a "clean" journal
-		 */
-		status = ocfs2_journal_toggle_dirty(osb, 0, 0);
-		if (status < 0)
-			mlog_errno(status);
-	}
+	status = ocfs2_journal_toggle_dirty(osb, 0, 0);
+	if (status < 0)
+		mlog_errno(status);
 
 	/* Shutdown the kernel journal system */
 	jbd2_journal_destroy(journal->j_journal);
@@ -1023,7 +1007,7 @@ static void ocfs2_clear_journal_error(struct super_block *sb,
 	}
 }
 
-int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
+int ocfs2_journal_load(struct ocfs2_journal *journal, int replayed)
 {
 	int status = 0;
 	struct ocfs2_super *osb;
@@ -1049,18 +1033,13 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local, int replayed)
 	}
 
 	/* Launch the commit thread */
-	if (!local) {
-		osb->commit_task = kthread_run(ocfs2_commit_thread, osb,
-					       "ocfs2cmt");
-		if (IS_ERR(osb->commit_task)) {
-			status = PTR_ERR(osb->commit_task);
-			osb->commit_task = NULL;
-			mlog(ML_ERROR, "unable to launch ocfs2commit thread, "
-			     "error=%d", status);
-			goto done;
-		}
-	} else
+	osb->commit_task = kthread_run(ocfs2_commit_thread, osb, "ocfs2cmt");
+	if (IS_ERR(osb->commit_task)) {
+		status = PTR_ERR(osb->commit_task);
 		osb->commit_task = NULL;
+		mlog(ML_ERROR, "unable to launch ocfs2commit thread, "
+		     "error=%d", status);
+	}
 
 done:
 	mlog_exit(status);
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index b5baaa8..b960d5a 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -188,8 +188,7 @@ int    ocfs2_journal_init(struct ocfs2_journal *journal,
 void   ocfs2_journal_shutdown(struct ocfs2_super *osb);
 int    ocfs2_journal_wipe(struct ocfs2_journal *journal,
 			  int full);
-int    ocfs2_journal_load(struct ocfs2_journal *journal, int local,
-			  int replayed);
+int    ocfs2_journal_load(struct ocfs2_journal *journal, int replayed);
 int    ocfs2_check_journals_nolocks(struct ocfs2_super *osb);
 void   ocfs2_recovery_thread(struct ocfs2_super *osb,
 			     int node_num);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fa1be1b..3aa44cf 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2366,7 +2366,6 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 {
 	int status;
 	int dirty;
-	int local;
 	struct ocfs2_dinode *local_alloc = NULL; /* only used if we
 						  * recover
 						  * ourselves. */
@@ -2394,10 +2393,8 @@ static int ocfs2_check_volume(struct ocfs2_super *osb)
 		     "recovering volume.\n");
 	}
 
-	local = ocfs2_mount_local(osb);
-
 	/* will play back anything left in the journal. */
-	status = ocfs2_journal_load(osb->journal, local, dirty);
+	status = ocfs2_journal_load(osb->journal, dirty);
 	if (status < 0) {
 		mlog(ML_ERROR, "ocfs2 journal load failed! %d\n", status);
 		goto finally;
-- 
1.7.1.571.gba4d01

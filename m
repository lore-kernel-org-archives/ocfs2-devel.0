From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb 26 20:16:59 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in journal.c
Message-ID: <200402270216.i1R2GnW8007425@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is a patch that fixes some small 2.6 issues with
journal.c

* journal_get_write_access now has an additional "credits" argument
  that appears to be safe to pass in as null.  (Other people are
  doing it and the code in the latest bk tree always test for null
  before attempting to incrementing it.)
* small typo in an ocfs_iget call
* remaining call to daemonize that is moved to the 2.6 safe
  ocfs_daemonize call
* WARNING!!! Here is the thing I am not sure about!
  The lock_journal/unlock_journal calls do not exist anymore.
  There is a journal_[un]lock_updates() function, but it is 
  unclear when to use that function.

  I just removed the [un]lock_journal calls around a line where
  we were tweaking the commit interval.

    --rusty

Index: src/journal.c
===================================================================
--- src/journal.c	(revision 36)
+++ src/journal.c	(working copy)
@@ -656,7 +656,7 @@
 		break;
 
 	case OCFS_JOURNAL_ACCESS_WRITE:
-		status = journal_get_write_access(handle->k_handle, bh);
+		status = journal_get_write_access(handle->k_handle, bh, NULL);
 		break;
 
 	default:
@@ -898,7 +898,7 @@
 	OCFS_BH_PUT_DATA(bh);
 	fe = NULL;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	inode = ocfs_iget (sb, &args);
+	inode = ocfs_iget (osb->sb, &args);
 #else
 	inode = ocfs_get_inode_from_offset(osb, args.offset, bh);
 #endif
@@ -934,9 +934,13 @@
 
 	LOG_TRACE_STR("Returned from journal_init_inode");
 	LOG_TRACE_ARGS("k_journal->j_maxlen = %u\n", k_journal->j_maxlen);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	k_journal->j_commit_interval = OCFS_DEFAULT_COMMIT_INTERVAL;
+#else
 	lock_journal(k_journal);
 	k_journal->j_commit_interval = OCFS_DEFAULT_COMMIT_INTERVAL;
 	unlock_journal(k_journal);
+#endif
 
 	/* yay, pass the proper info back to our journal structure. */
 	osb->journal.osb = osb;
@@ -1368,12 +1372,14 @@
 	ocfs_super *osb = ((struct ocfs_recover_arg *) arg)->osb;
 	int node_num = ((struct ocfs_recover_arg *) arg)->node_num;
 	int status = 0;
+	char proc[16];
 
 	LOG_ENTRY_ARGS("(node_num=%d, osb->node_num = %d)\n", node_num,
 		       osb->node_num);
 
-	daemonize();
-	reparent_to_init();
+	sprintf (proc, "ocfs2rec-%d", osb->osb_id);
+	ocfs_daemonize (proc, strlen(proc));
+
 #ifdef HAVE_NPTL
 	spin_lock_irq (&current->sighand->siglock);
 	sigfillset(&current->blocked);
@@ -1522,7 +1528,7 @@
 	OCFS_BH_PUT_DATA(bh);
 	fe = NULL;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	inode = ocfs_iget (sb, &args);
+	inode = ocfs_iget (osb->sb, &args);
 #else
 	inode = ocfs_get_inode_from_offset(osb, args.offset, bh);
 #endif

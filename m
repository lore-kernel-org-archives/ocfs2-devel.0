From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Mon Apr 26 02:55:38 2004
Subject: [Ocfs2-devel] Patch to fix OCFS2 bug 58 "system halt when unmounta
	volumeimmediately after read/write"
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E81@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

	Finally, I manifest my analysis in last email to the bug 58 is
correct via the patch attached in this mail. This patch is again svn
version 857. As for a lot of changes since svn 866, I will try to
generate a new one for the latest version soon.

	Since OCFS2 svn version 847, the approach to release inode is
changed from right after file operations into the journal commit thread.
This causes system halt in kernel 2.6 if a volume is unmounted before
the journal cache is written back.

	In my patch, I send a signal to the journal commit thread right
after a file is asked to close in ocfs_file_release(). I also change the
signal process code in ocfs_commit_thread(). Please refer to the
attachment.

	Any comment?

	Thank you.

------------------------------------------------------
--- linux.old/fs/ocfs2/journal.c	2004-04-20 16:58:23.000000000
+0800
+++ linux/fs/ocfs2/journal.c	2004-04-25 08:57:02.000000000 +0800
@@ -1760,30 +1760,6 @@
 				LOG_TRACE_STR("FLUSH_EVENT: timed out");
 				break;
 			case -EINTR:
-				/* journal shutdown has asked me to do
-				 * one last commit cache and then exit
*/
-				if (journal->state ==
OCFS_JOURNAL_IN_SHUTDOWN)
-					finish = 1;
-				if (signal_pending(current)) {
-					/* ignore the actual signal */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-					dequeue_signal_lock(current, 
-
&current->blocked, 
-							    &info);
-#else
-#ifdef HAVE_NPTL
-					spin_lock_irq
(&current->sighand->siglock);
-
dequeue_signal(&current->blocked, 
-						       &info);
-
spin_unlock_irq(&current->sighand->siglock);

-#else 
-
spin_lock_irq(&current->sigmask_lock);
-
dequeue_signal(&current->blocked, 
-						       &info);
-
spin_unlock_irq(&current->sigmask_lock);
-#endif /* !HAVE_NPTL */
-#endif /* 2.4.x kernel */
-				}
 				LOG_TRACE_STR("FLUSH_EVENT:
interrupted");
 				break;
 			case 0:
@@ -1794,8 +1770,26 @@
 				break;
 		}
 
+		if (signal_pending(current)) {
+		/* ignore the actual signal */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+		dequeue_signal_lock(current, &current->blocked, &info);
+#else
+#ifdef HAVE_NPTL
+		spin_lock_irq (&current->sighand->siglock);
+		dequeue_signal(&current->blocked, &info);
+		spin_unlock_irq(&current->sighand->siglock);

+#else 
+		spin_lock_irq(&current->sigmask_lock);
+		dequeue_signal(&current->blocked, &info);
+		spin_unlock_irq(&current->sigmask_lock);
+#endif /* !HAVE_NPTL */
+#endif /* 2.4.x kernel */
+		}
+
 		if ((OcfsGlobalCtxt.flags &
OCFS_FLAG_SHUTDOWN_VOL_THREAD) ||
-		    (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED))
+		    (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED)
||
+		    (journal->state == OCFS_JOURNAL_IN_SHUTDOWN))
 			finish = 1;
 
 		//if (!osb->needs_flush && status != 0)

--- linux.old/fs/ocfs2/file.c	2004-04-20 16:58:23.000000000 +0800
+++ linux/fs/ocfs2/file.c	2004-04-25 08:57:08.000000000 +0800
@@ -366,6 +366,11 @@
 	ocfs_up_sem (&(OCFS_I(inode)->main_res));
 	ocfs_sync_inode(inode);
 
+	if(osb->commit && osb->commit->c_task) {
+		send_sig (SIGINT, osb->commit->c_task, 0);
+		yield();
+	}
+
 	if (last_close) {
 		if (inode->i_data.nrpages)
 			ocfs_truncate_inode_pages(inode, 0);



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-inode-count.patch
Type: application/octet-stream
Size: 2395 bytes
Desc: ocfs2-inode-count.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040426/39208548/ocfs2-inode-count.obj

From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Mon Apr 26 04:19:14 2004
Subject: [Ocfs2-devel] Patch to fix OCFS2 bug 58 "system halt when
	unmountavolumeimmediately after read/write"
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E82@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

Hi,

	I changed a little to my original patch. I also send signal in ocfs_rename() and ocfs_unlink(). This new patch is against the latest svn version 867. I have run xiaofeng's test suite many times and got no problems by now.

	Please refer to the attachment.
	Thanks.

----------------------------------------------------
--- ocfs2.old/src/journal.c	2004-04-20 16:58:23.000000000 +0800
+++ ocfs2/src/journal.c	2004-04-25 08:57:02.000000000 +0800
@@ -1646,30 +1646,6 @@
 				LOG_TRACE_STR("FLUSH_EVENT: timed out");
 				break;
 			case -EINTR:
-				/* journal shutdown has asked me to do
-				 * one last commit cache and then exit */
-				if (journal->state == OCFS_JOURNAL_IN_SHUTDOWN)
-					finish = 1;
-				if (signal_pending(current)) {
-					/* ignore the actual signal */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-					dequeue_signal_lock(current, 
-							    &current->blocked, 
-							    &info);
-#else
-#ifdef HAVE_NPTL
-					spin_lock_irq (&current->sighand->siglock);
-					dequeue_signal(&current->blocked, 
-						       &info);
-					spin_unlock_irq(&current->sighand->siglock);					
-#else 
-					spin_lock_irq(&current->sigmask_lock);
-					dequeue_signal(&current->blocked, 
-						       &info);
-					spin_unlock_irq(&current->sigmask_lock);
-#endif /* !HAVE_NPTL */
-#endif /* 2.4.x kernel */
-				}
 				LOG_TRACE_STR("FLUSH_EVENT: interrupted");
 				break;
 			case 0:
@@ -1680,8 +1680,26 @@
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
 		if ((OcfsGlobalCtxt.flags & OCFS_FLAG_SHUTDOWN_VOL_THREAD) ||
-		    (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED))
+		    (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED) ||
+		    (journal->state == OCFS_JOURNAL_IN_SHUTDOWN))
 			finish = 1;
 
 		//if (!osb->needs_flush && status != 0)

--- ocfs2.old/src/file.c	2004-04-20 16:58:23.000000000 +0800
+++ ocfs2/src/file.c	2004-04-25 08:57:08.000000000 +0800
@@ -357,6 +357,11 @@
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

--- ocfs2.old/src/namei.c	2004-04-25 11:05:59.398985280 +0800
+++ ocfs2/src/namei.c	2004-04-25 11:06:54.390625280 +0800
@@ -632,6 +632,10 @@
                 }
 
 		inode->i_nlink--;
+		if(osb->commit && osb->commit->c_task) {
+			send_sig (SIGINT, osb->commit->c_task, 0);
+			yield();
+		}
 		retval = 0;
 	}
 
@@ -1280,6 +1284,11 @@
 
 		if (new_inode)
 			fsync_inode_buffers(old_inode);
+	
+		if(osb->commit && osb->commit->c_task) {
+			send_sig (SIGINT, osb->commit->c_task, 0);
+			yield();
+		}
 	}
 
 	old_inode->i_nlink++;


*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: ocfs2-devel-bounces@oss.oracle.com [mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Zhang, Sonic
Sent: 2004��4��26�� 15:56
To: Ocfs2-Devel
Subject: [Ocfs2-devel] Patch to fix OCFS2 bug 58 "system halt when unmountavolumeimmediately after read/write"

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


-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-inode-count.patch
Type: application/octet-stream
Size: 2910 bytes
Desc: ocfs2-inode-count.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040426/18eeb1be/ocfs2-inode-count.obj

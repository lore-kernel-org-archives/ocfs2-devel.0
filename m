From: Zhang, Sonic <sonic.zhang@intel.com>
Date: Tue Mar 30 22:10:34 2004
Subject: [Ocfs2-devel] Can you check the patch for bug 48 and commit?
Message-ID: <37FBBA5F3A361C41AB7CE44558C3448E03B65E4D@PDSMSX403.ccr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

	OK, I made the same NPTL fix. 
	Please see the attachment.

-------------------------------------------------------------
--- ocfs2.old/src/nm.c	2004-03-31 12:02:10.075066064 +0800
+++ ocfs2/src/nm.c	2004-03-31 12:02:09.973081568 +0800
@@ -254,6 +254,7 @@
 	__u64 cfg_seq_num;
 	int which, pruned, prune_iters = 0;
 	struct buffer_head *bh = NULL;
+	siginfo_t info;
 
 	LOG_ENTRY ();
 
@@ -444,6 +445,19 @@
 		}
 		set_current_state (TASK_INTERRUPTIBLE);
 		schedule_timeout (osb->hbt - j);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+		dequeue_signal_lock(current, &current->blocked, &info);
+#else
+#ifdef HAVE_NPTL
+		spin_lock_irq(&current->sighand->siglock);
+		dequeue_signal(&current->blocked, &info);
+		spin_unlock_irq(&current->sighand->siglock);					
+#else 
+		spin_lock_irq(&current->sigmask_lock);
+		dequeue_signal(&current->blocked, &info);
+		spin_unlock_irq(&current->sigmask_lock);
+#endif /* !HAVE_NPTL */
+#endif /* 2.4.x kernel */
 	}
 
         /* Flush all scheduled tasks */



*********************************************
Sonic Zhang
Software Engineer
Intel China Software Lab
Tel: (086)021-52574545-1667
iNet: 752-1667
********************************************* 

-----Original Message-----
From: Mark Fasheh [mailto:mark.fasheh@oracle.com] 
Sent: 2004��3��30�� 11:11
To: Zhang, Sonic
Cc: Ocfs2-Devel
Subject: Re: [Ocfs2-devel] Can you check the patch for bug 48 and commit?

On Tue, Mar 30, 2004 at 10:53:13AM +0800, Zhang, Sonic wrote:
> Hi Mark,
> 
> Can you check the patch for bug 48 in the attachment and commit? I haven't
> found it in the svn tree.
That's because I was still looking at the signals part of the patch :)
I needed to do some reading in schedule() to make sure what I though was
going on, really is. Also, I think the correct approach is to do both, the
signal handling, *and* to define the timeout value itself as a function of
HZ, rather than a hard number of jiffies.

> This patch adds lines of signal process code, which makes the thread
> ocfs_volume_thread() really go to sleep after receive the SIGTERM signal.
> So, it gives routine ocfs_journal_set_unmounted() a chance to run and
> check the lock status before thread ocfs_volume_thread() wakes up.
You need to update from cvs because half of that patch is already in. Also,
can you make the same NPTL fix in it that I did for ocfs_commit_thread? See
the svn logs to know what I'm talking about.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-nm-reboot2.patch
Type: application/octet-stream
Size: 884 bytes
Desc: ocfs2-nm-reboot2.patch
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20040331/7280d7ff/ocfs2-nm-reboot2.obj

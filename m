From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 24 18:18:59 2004
Subject: [Ocfs2-devel] Bug 48 "[kernel 2.6 porting] System halt during
	reboot after mount an OCFS volume." in bugzilla is fixed.
In-Reply-To: <4060FB02.9090402@intel.com>
References: <4060FB02.9090402@intel.com>
Message-ID: <20040325001852.GH10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 24, 2004 at 11:05:38AM +0800, Sonic Zhang wrote:
> Hi all,
> 
> I successfully root cause and fix bug 48 "[kernel 2.6 porting] System halt 
> during reboot after mount an OCFS volume.".
> 
> In current OCFS v2 driver, ocfs_volume_thread, ocfs_recv_thread and 
> ocfs_commit_thread are assumed to be terminated by the ocfs_dismount_volume 
> routine. But, if the system reboots, all processes and kernel threads will 
> receive signal SIGTERM before ocfs_dismount_volume routine is called.  
> 
> These kernel threads don't exit correctly. For example, they don't know 
> they should exit loop after received signal SIGTERM and clear their 
> task_struct pointers in ocfs_super to indiate their status. That's the 
> cause of the system halt in ocfs_dismount_volume routine when system 
> reboots.
You're correct that some of these threads aren't handling certain signals
properly, but I think you're going about it the wrong way. We *want* these
threads to stay alive until the actual umount process begins. In fact, if
you kill the commit_cache thread early, and the volume is still busy (with
metadata updates), you could miss your last flush! This could result in
metadata corruption!

What we really want is that a thread ignores all signals except for a small
set, which it only acts on if a certain flag is set. For the commit thread,
this would be OCFS_JOURNAL_IN_SHUTDOWN. NM thread, I believe already checks
the osb shutdown flags, and doesn't need to be changed. Can you try this
patch instead and tell me if it fixes your problem?

Basically in this patch, commit_thread just checks to make sure that the
volume is being unmounted before setting the "finish" flag. Otherwise, it
ignores the signal.

I'm a tad green to the in-kernel signal API's so I'm hoping others will
review what I did and let me know if I'm wrong :)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com

Index: journal.c
===================================================================
--- journal.c	(revision 806)
+++ journal.c	(working copy)
@@ -1745,6 +1745,7 @@ int ocfs_commit_thread(void *arg)
 	ocfs_commit_task *commit = osb->commit;
 	char name[16];
 	ocfs_journal * journal = &osb->journal;
+	siginfo_t info;
 
 	sprintf (name, "ocfs2cmt-%d", osb->osb_id);
 	ocfs_daemonize (name, strlen(name));
@@ -1765,7 +1766,16 @@ int ocfs_commit_thread(void *arg)
 				LOG_TRACE_STR("FLUSH_EVENT: timed out");
 				break;
 			case -EINTR:
-				finish = 1;
+				/* journal shutdown has asked me to do
+				 * one last commit cache and then exit */
+				if (journal->state == OCFS_JOURNAL_IN_SHUTDOWN)
+					finish = 1;
+				if (signal_pending(current)) {
+					spin_lock_irq(&current->sigmask_lock);
+					/* ignore the actual signal */
+					dequeue_signal(&current->blocked, &info);
+					spin_unlock_irq(&current->sigmask_lock);
+				}
 				LOG_TRACE_STR("FLUSH_EVENT: interrupted");
 				break;
 			case 0:
@@ -1778,7 +1788,7 @@ int ocfs_commit_thread(void *arg)
 
 		if ((OcfsGlobalCtxt.flags & OCFS_FLAG_SHUTDOWN_VOL_THREAD) ||
 		    (osb->osb_flags & OCFS_OSB_FLAGS_BEING_DISMOUNTED))
-			break;
+			finish = 1;
 
 		//if (!osb->needs_flush && status != 0)
 		//	continue;
@@ -1788,18 +1798,13 @@ int ocfs_commit_thread(void *arg)
 
 		if (down_trylock(&osb->trans_lock) != 0) {
 			LOG_TRACE_ARGS("commit thread: trylock failed, miss=%d\n", misses);
-			if (++misses < OCFS_COMMIT_MISS_MAX)
+			if (++misses < OCFS_COMMIT_MISS_MAX && finish == 0)
 				continue;
 			LOG_TRACE_ARGS("commit thread: about to down\n");
 			down(&osb->trans_lock);
 			misses = 0;
 		}
 
-		/* journal shutdown has asked me to do one last commit cache */
-		/* this commit cache will leave trans lock held! */
-		if (journal->state == OCFS_JOURNAL_IN_SHUTDOWN)
-			finish = 1;
-
 		status = ocfs_commit_cache (osb, false);
 		if (status < 0)
 			LOG_ERROR_STATUS(status);

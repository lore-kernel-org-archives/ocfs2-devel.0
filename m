From: Christoph Hellwig <hch@lst.de>
Date: Thu Jun  3 06:00:54 2004
Subject: [Ocfs2-devel] [PATCH] provide dequeue_signal_lock for 2.4
Message-ID: <20040603110049.GC13534@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

(vs format-changes branch)

Index: src/journal.c
===================================================================
--- src/journal.c	(revision 994)
+++ src/journal.c	(working copy)
@@ -1594,26 +1594,13 @@
 				 * one last commit cache and then exit */
 				if (journal->state == OCFS_JOURNAL_IN_SHUTDOWN)
 					finish = 1;
+
+				/* ignore the actual signal */
 				if (signal_pending(current)) {
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
+					dequeue_signal_lock(current,
+						&current->blocked, &info);
 				}
+
 				LOG_TRACE_STR("FLUSH_EVENT: interrupted");
 				break;
 			case 0:
Index: src/nm.c
===================================================================
--- src/nm.c	(revision 994)
+++ src/nm.c	(working copy)
@@ -461,24 +461,10 @@
 		}
 		set_current_state (TASK_INTERRUPTIBLE);
 		schedule_timeout (osb->hbt - j);
-		/* this should all just be in some common function as
-		 * it's totally duplicated. */
-		if (signal_pending(current)) {
-			/* ignore the actual signal */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+
+		/* ignore the actual signal */
+		if (signal_pending(current))
 			dequeue_signal_lock(current, &current->blocked, &info);
-#else
-#ifdef HAVE_NPTL
-			spin_lock_irq (&current->sighand->siglock);
-			dequeue_signal(&current->blocked, &info);
-			spin_unlock_irq(&current->sighand->siglock);
-#else 
-			spin_lock_irq(&current->sigmask_lock);
-			dequeue_signal(&current->blocked, &info);
-			spin_unlock_irq(&current->sigmask_lock);
-#endif /* !HAVE_NPTL */
-#endif /* 2.4.x kernel */
-		}
 	}
 
 	/* Flush all scheduled tasks */
@@ -1434,24 +1420,9 @@
 	ocfs_daemonize (OCFS_DROP_RO_THREAD_NAME, strlen(OCFS_DROP_RO_THREAD_NAME));
 	status = _ocfs_drop_readonly_cache_lock(arg);
 
-	/* this should all just be in some common function as
-	 * it's totally duplicated. */
-	if (signal_pending(current)) {
-		/* ignore the actual signal */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+	/* ignore the actual signal */
+	if (signal_pending(current))
 		dequeue_signal_lock(current, &current->blocked, &info);
-#else
-#ifdef HAVE_NPTL
-		spin_lock_irq (&current->sighand->siglock);
-		dequeue_signal(&current->blocked, &info);
-		spin_unlock_irq(&current->sighand->siglock);
-#else 
-		spin_lock_irq(&current->sigmask_lock);
-		dequeue_signal(&current->blocked, &info);
-		spin_unlock_irq(&current->sigmask_lock);
-#endif /* !HAVE_NPTL */
-#endif /* 2.4.x kernel */
-	}
 
 	/* Flush all scheduled tasks */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
Index: src/inc/ocfs_compat.h
===================================================================
--- src/inc/ocfs_compat.h	(revision 994)
+++ src/inc/ocfs_compat.h	(working copy)
@@ -31,6 +31,24 @@
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 
+#ifdef HAVE_NPTL
+static inline void dequeue_signal_lock(struct task_struct *task,
+		sigset_t *blocked, siginfo_t *info)
+{
+	spin_lock_irq(&task->sighand->siglock);
+	dequeue_signal(blocked, info);
+	spin_unlock_irq(&task->sighand->siglock);
+}
+#else
+static inline void dequeue_signal_lock(struct task_struct *task,
+		sigset_t *blocked, siginfo_t *info)
+{
+	spin_lock_irq(&task->sigmask_lock);
+	dequeue_signal(blocked, info);
+	spin_unlock_irq(&task->sigmask_lock);
+}
+#endif
+
 #ifdef __ia64__
 extern inline void prefetch(const void *x);
 extern inline void prefetchw(const void *x);

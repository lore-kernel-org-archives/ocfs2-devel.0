From: Christoph Hellwig <hch@lst.de>
Date: Tue Jun 15 03:34:52 2004
Subject: [Ocfs2-devel] Re: [PATCH] workqueue compat glue for 2.4
In-Reply-To: <20040606081054.GA28366@lst.de>
References: <20040606081054.GA28366@lst.de>
Message-ID: <20040615083439.GA12168@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Version for today's f-c branch:


Index: src/nm.c
===================================================================
--- src/nm.c	(revision 1014)
+++ src/nm.c	(working copy)
@@ -119,11 +119,7 @@
 
 finally:
 	/* Flush all scheduled tasks */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	flush_scheduled_work ();
-#else
-	flush_scheduled_tasks ();
-#endif
+	flush_scheduled_work();
 
 	if (OcfsIpcCtxt.send_sock) {
 		sock_release (OcfsIpcCtxt.send_sock);
@@ -150,11 +146,7 @@
 	ocfs_super *osb;
 	ocfs_vote_request_ctxt ctxt;
 	__u8 publish_sect[512];
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	struct work_struct ipc_wq;
-#else
-	struct tq_struct ipc_tq;
-#endif
 };
 
 void ocfs_process_vote_worker(void *val)
@@ -222,13 +214,8 @@
 	
 	sv->osb = osb;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	INIT_WORK (&sv->ipc_wq, ocfs_process_vote_worker, sv);
-	schedule_work (&sv->ipc_wq);
-#else
-	INIT_TQUEUE (&sv->ipc_tq, ocfs_process_vote_worker, sv);
-	schedule_task (&sv->ipc_tq);
-#endif
+	INIT_WORK(&sv->ipc_wq, ocfs_process_vote_worker, sv);
+	schedule_work(&sv->ipc_wq);
 
 bail:
 	/* if no error, then the workqueue should clear it? */
@@ -463,11 +450,7 @@
 	}
 
 	/* Flush all scheduled tasks */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	flush_scheduled_work ();
-#else
-	flush_scheduled_tasks ();
-#endif
+	flush_scheduled_work();
 
 	complete (&(osb->dlm_complete));
 eek:
@@ -1429,11 +1412,7 @@
 	}
 
 	/* Flush all scheduled tasks */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	flush_scheduled_work ();
-#else
-	flush_scheduled_tasks ();
-#endif
+	flush_scheduled_work();
 
 #warning   need a way to wait on all of these threads on dismount
 	return status;
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 1014)
+++ src/journal.c	(working copy)
@@ -1642,11 +1641,7 @@
 
 
 	/* Flush all scheduled tasks */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	flush_scheduled_work ();
-#else
-	flush_scheduled_tasks ();
-#endif
+	flush_scheduled_work();
 	complete (&(commit->c_complete));
 	return 0;
 }
Index: src/vote.c
===================================================================
--- src/vote.c	(revision 1014)
+++ src/vote.c	(working copy)
@@ -102,11 +102,7 @@
 	LOG_ENTRY ();
 
 	/* Initialize the workitem with our worker routine and Q it. */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	INIT_WORK (&recv_ctxt->ipc_wq, ocfs_dlm_recv_msg, recv_ctxt);
-#else
-	INIT_TQUEUE (&recv_ctxt->ipc_tq, ocfs_dlm_recv_msg, recv_ctxt);
-#endif
 
 	memset (&sin, 0, sizeof (sin));
 	oldfs = get_fs ();
@@ -133,11 +129,7 @@
 			NIPQUAD (sin.sin_addr.s_addr));
 
 	if (status == 0)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-		schedule_work (&recv_ctxt->ipc_wq);
-#else
-		schedule_task (&recv_ctxt->ipc_tq);
-#endif
+		schedule_work(&recv_ctxt->ipc_wq);
 
 bail:
 	LOG_EXIT_STATUS (status);
Index: src/volcfg.c
===================================================================
--- src/volcfg.c	(revision 1014)
+++ src/volcfg.c	(working copy)
@@ -114,13 +114,8 @@
 	cfg_task = (ocfs_cfg_task *) arg;
 
 	/* initialize the task and submit it */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	INIT_WORK   (&(cfg_task->cfg_wq), ocfs_worker, cfg_task);
-	schedule_work (&cfg_task->cfg_wq);
-#else
-	INIT_TQUEUE (&(cfg_task->cfg_tq), ocfs_worker, cfg_task);
-	schedule_task (&cfg_task->cfg_tq);
-#endif
+	INIT_WORK(&cfg_task->cfg_wq, ocfs_worker, cfg_task);
+	schedule_work(&cfg_task->cfg_wq);
 
 	LOG_EXIT ();
 	return ;
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 1014)
+++ src/inc/ocfs.h	(working copy)
@@ -1439,21 +1430,13 @@
 	__s32 msg_len;
 	__u8 msg[OCFS_MAX_DLM_PKT_SIZE];
 	int status;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	struct work_struct ipc_wq;
-#else
-	struct tq_struct ipc_tq;
-#endif
 }
 ocfs_recv_ctxt;
 
 typedef struct _ocfs_cfg_task
 {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	struct work_struct cfg_wq;
-#else
-	struct tq_struct cfg_tq;
-#endif
 	ocfs_super *osb;
 	__u64 lock_off;
 	__u8 *buffer;
Index: src/inc/ocfs_compat.h
===================================================================
--- src/inc/ocfs_compat.h	(revision 1014)
+++ src/inc/ocfs_compat.h	(working copy)
@@ -62,6 +62,11 @@
 #define io_schedule            schedule
 #endif
 
+#define flush_scheduled_work	flush_scheduled_tasks
+#define work_struct		tq_struct
+#define INIT_WORK(w, f, d)	INIT_TQUEUE(w, f, d)
+#define schedule_work(w)	schedule_task(w)
+
 #ifdef HAVE_NPTL
 static inline void dequeue_signal_lock(struct task_struct *task,
 				       sigset_t *blocked, siginfo_t *info)
Index: src/alloc.c
===================================================================
--- src/alloc.c	(revision 1014)
+++ src/alloc.c	(working copy)
@@ -915,9 +915,7 @@
 	phys_blkno = physicalOffset >> osb->sb->s_blocksize_bits;
 
 	for (i = 0; i < numbhs; i++) {
-		bhs[i] = getblk(OCFS_GET_BLOCKDEV(osb->sb), 
-				phys_blkno + i,
-				osb->sb->s_blocksize);
+		bhs[i] = sb_getblk(osb->sb, phys_blkno + i);
 		if (bhs[i] == NULL) {
 			status = -EIO;
 			LOG_ERROR_STATUS(status);

From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Feb 23 20:14:15 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in nm.c
In-Reply-To: <20040224002331.GG1421@ca-server1.us.oracle.com>
References: <200402200413.i1K4DwFC004269@penguin.co.intel.com>
	<20040224002331.GG1421@ca-server1.us.oracle.com>
Message-ID: <20040224021408.GA18639@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 23, 2004 at 04:23:31PM -0800, Mark Fasheh wrote:
> On Thu, Feb 19, 2004 at 08:13:58PM -0800, Rusty Lynch wrote:
> > The following patch enables inode syncing on 2.6 kernels in the 
> > nm.c file.
> > 
> >     --rusty
> 
> Damn, I missed some of the LINUX_2_5 conditionals that stayed in even after
> the patch... You mind sending me a patch that replaces the rest of them in
> nm.c? I've committed the other parts of the patch so you don't have to worry
> about that :)
> 
> In fact, feel free to send me patches to remove them in the rest of the 
> files ;)
> 	--Mark

Here is a patch to once and for all wipe out all the LINUX_2_5'ish stuff.

    --rusty


Index: src/super.c
===================================================================
--- src/super.c	(revision 33)
+++ src/super.c	(working copy)
@@ -88,7 +88,7 @@
 MODULE_AUTHOR("Oracle Corporation");
 //MODULE_DESCRIPTION("Oracle Clustered FileSystem");
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 module_param (node_name, charp, 0);
 module_param (node_number, uint, 0);
 module_param (debug_context, uint, 0);
@@ -99,7 +99,7 @@
 module_param (guid, charp, 0);
 module_param (cs, uint, 0);
 module_param (comm_voting, uint, 0);
-#else /* LINUX_2_5 */
+#else /* 2.6.x kernel */
 MODULE_PARM (node_name, "s");
 MODULE_PARM_DESC(node_name, "Name of this machine in the cluster");
 MODULE_PARM (node_number, "i");
@@ -140,7 +140,7 @@
 	.clear_inode = ocfs_clear_inode,
 	//put_inode =           force_delete,
 	//delete_inode =        ocfs_delete_inode, 
-#ifndef LINUX_2_5
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 	.read_inode = ocfs_read_inode,
 	.read_inode2 = ocfs_read_inode2,
 #endif
@@ -149,7 +149,7 @@
 };
 
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 
 static struct file_system_type ocfs_fs_type = {
         .owner          = THIS_MODULE,
@@ -332,7 +332,7 @@
 
 
 static DECLARE_FSTYPE (ocfs_fs_type, "ocfs2", ocfs_read_super, FS_REQUIRES_DEV);
-#endif /* #if LINUX_2_5 ... #else */
+#endif /* #if 2.6 kernel ... #else */
 
 
 
@@ -357,7 +357,7 @@
 
 	LOG_TRACE_ARGS("strlen(options) = %d, options = \"%s\"\n", strlen(options), options);
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         while ( (c = strsep(&options, ",")) != NULL)
 #else
         for (c = strtok (options, ","); c != NULL; c = strtok (NULL, ","))
Index: src/inode.c
===================================================================
--- src/inode.c	(revision 33)
+++ src/inode.c	(working copy)
@@ -40,7 +40,7 @@
 static int ocfs_bmap(struct address_space *mapping, long block);
 
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int ocfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t offset, unsigned long nr_segs);
 #elif LINUX_VERSION_CODE >= LinuxVersionCode(2,4,10)
 #if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,20) || defined(SUSE)
@@ -298,7 +298,7 @@
 		    inode->i_size = fe->file_size;
 		    break;
 	    default:
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		    init_special_inode (inode, mode, inode->i_rdev.value);
 #else
 		    init_special_inode (inode, mode, inode->i_rdev);
@@ -310,7 +310,7 @@
 	return;
 }				/* ocfs_populate_inode */
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /*
  * ocfs_read_locked_inode()
  *
@@ -512,7 +512,7 @@
 }				/* ocfs_read_inode() */
 #endif
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /*
  * here's how inodes get read from disk:
  * iget5_locked -> find_actor -> OCFS_FIND_ACTOR
@@ -646,7 +646,7 @@
 	return(inode);
 }
 
-#endif /* LINUX_2_5 stuff */
+#endif /* 2.6 kernel stuff */
 
 
 /*
@@ -699,7 +699,7 @@
 
 void ocfs_sync_blockdev(struct super_block *sb)
 {
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	sync_blockdev (sb->s_bdev);
 #else
 	fsync_no_super (sb->s_dev);
@@ -829,7 +829,7 @@
 	memcpy (kaddr, symname, len - 1);
 	mapping->a_ops->commit_write (NULL, page, 0, len - 1);
 	err = mapping->a_ops->readpage (NULL, page);
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	wait_on_page_locked (page);
 #else
 	wait_on_page (page);
@@ -841,7 +841,7 @@
 	return 0;
 
 fail_map:
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	unlock_page (page);
 #else
 	UnlockPage (page);
@@ -1094,7 +1094,7 @@
 	return(err ? err : disk_block);
 }
 
-#ifndef LINUX_2_5
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
 /*
  * ocfs_get_block2()
  *
@@ -1164,7 +1164,7 @@
  * ocfs_writepage()
  *
  */
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int ocfs_writepage (struct page *page, struct writeback_control *wbc)
 {
 	int ret;
@@ -1191,7 +1191,7 @@
 #endif
 
 
-#if LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /*
  * TODO: Make this into a generic get_blocks function.
  *
Index: src/nm.c
===================================================================
--- src/nm.c	(revision 33)
+++ src/nm.c	(working copy)
@@ -102,7 +102,7 @@
 	}
 
 	/* Flush all scheduled tasks */
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	flush_scheduled_work ();
 #else
 	flush_scheduled_tasks ();
@@ -120,7 +120,7 @@
 	ocfs_super *osb;
 	ocfs_vote_request_ctxt ctxt;
 	__u8 publish_sect[512];
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	struct work_struct ipc_wq;
 #else
 	struct tq_struct ipc_tq;
@@ -192,7 +192,7 @@
 	
 	sv->osb = osb;
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	INIT_WORK (&sv->ipc_wq, ocfs_process_vote_worker, sv);
 	schedule_work (&sv->ipc_wq);
 #else
@@ -416,7 +416,7 @@
 	}
 
         /* Flush all scheduled tasks */
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         flush_scheduled_work ();
 #else
         flush_scheduled_tasks ();
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 33)
+++ src/journal.c	(working copy)
@@ -897,7 +897,7 @@
 		       LO(fe->this_sector));
 	OCFS_BH_PUT_DATA(bh);
 	fe = NULL;
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	inode = ocfs_iget (sb, &args);
 #else
 	inode = ocfs_get_inode_from_offset(osb, args.offset, bh);
@@ -1521,7 +1521,7 @@
 	args.fe_bh = bh;
 	OCFS_BH_PUT_DATA(bh);
 	fe = NULL;
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	inode = ocfs_iget (sb, &args);
 #else
 	inode = ocfs_get_inode_from_offset(osb, args.offset, bh);
@@ -1776,7 +1776,7 @@
 
 
         /* Flush all scheduled tasks */
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
         flush_scheduled_work ();
 #else
         flush_scheduled_tasks ();
Index: src/util.c
===================================================================
--- src/util.c	(revision 33)
+++ src/util.c	(working copy)
@@ -42,7 +42,7 @@
  * ocfs_daemonize() 
  *
  */
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /* yes, len is unused but kept here for backwards compatibility. */
 void ocfs_daemonize (char *name, int len)
 {
Index: src/vote.c
===================================================================
--- src/vote.c	(revision 33)
+++ src/vote.c	(working copy)
@@ -64,7 +64,7 @@
 	LOG_ENTRY ();
 
 	/* Initialize the workitem with our worker routine and Q it. */
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	INIT_WORK (&recv_ctxt->ipc_wq, ocfs_dlm_recv_msg, recv_ctxt);
 #else
 	INIT_TQUEUE (&recv_ctxt->ipc_tq, ocfs_dlm_recv_msg, recv_ctxt);
@@ -95,7 +95,7 @@
 			NIPQUAD (sin.sin_addr.s_addr));
 
 	if (status == 0)
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		schedule_work (&recv_ctxt->ipc_wq);
 #else
 		schedule_task (&recv_ctxt->ipc_tq);
Index: src/file.c
===================================================================
--- src/file.c	(revision 33)
+++ src/file.c	(working copy)
@@ -1454,7 +1454,7 @@
 	return error;
 }				/* ocfs_setattr */
 
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 /*
  * ocfs_getattr() (Linux 2.5 version)
  *
Index: src/volcfg.c
===================================================================
--- src/volcfg.c	(revision 33)
+++ src/volcfg.c	(working copy)
@@ -103,7 +103,7 @@
 	cfg_task = (ocfs_cfg_task *) arg;
 
 	/* initialize the task and submit it */
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	INIT_WORK   (&(cfg_task->cfg_wq), ocfs_worker, cfg_task);
 	schedule_work (&cfg_task->cfg_wq);
 #else
Index: src/hash.c
===================================================================
--- src/hash.c	(revision 33)
+++ src/hash.c	(working copy)
@@ -1772,7 +1772,7 @@
 		 * and insert it into the hash. It's not bound yet --
 		 * read_inode2 binds the actual inode to it. */
 		ino = ocfs_inode_hash_insert(osb, offset, fe_off);
-#ifdef LINUX_2_5
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		inode = ocfs_iget (sb, &args);
 #else
 		inode =

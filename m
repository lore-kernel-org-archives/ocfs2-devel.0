From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar  2 09:13:15 2004
Subject: [Ocfs2-devel] unknown symbol mark_buffer_clean found when compile
	OCFSv2 under kernel 2.6.0
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E5A30D1@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E5A30D1@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040302151258.GA25091@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2004 at 05:01:59PM +0800, Zhang, Sonic wrote:
> 
> Hi Rusty and Mark,
> 
> 	I checked out the latest source code from the svn tree. And I
> also compile the source code under kernel 2.6 successfully with Rusty's
> makefile.	But I failed to insert the ocfs2 module into the kernel
> 2.6.
> 
> My operation:
> [host1]> insmod ocfs2.o node_name=westvile2 ip_address=192.168.1.14
> cs=1793 guid=6B359212647D8D256E190007E903E0ED
> ocfs2: Unknown symbol mark_buffer_clean
> Error inserting 'ocfs2.o': -1 Unknown symbol in module
> 
> 	Routine mark_buffer_clean exits in file include/linux/fs.h of
> kernel 2.4.x, but it is removed in kernel 2.6.x. 

This is one of my remaining patches to make it into the tree.

BTW, you should be loading ocfs2.ko, not ocfs2.o.  Also, if you are using
my makefile that utilized the kernel build system, then you can cd to the
kernel build directory and install ocfs2.ko with a 'make modules_install'.

Try this...


Index: src/io.c
===================================================================
--- src/io.c	(revision 738)
+++ src/io.c	(working copy)
@@ -277,7 +277,17 @@
 		set_buffer_uptodate(bh);
 
 		/* remove from dirty list before I/O. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)		
+		/*
+		 * mark_buffer_clean() doesn't exist in 2.6.x kernels.
+		 * Not many places actually used mark_buffer_clean, but
+		 * at least reiserfs uses clear_buffer_dirty() as
+		 * a replacment.
+		 */
+		clear_buffer_dirty(bh);
+#else
 		mark_buffer_clean(bh);
+#endif
 
 		bh->b_end_io = ocfs_end_buffer_io_sync;
 		submit_bh(WRITE, bh);
@@ -550,7 +560,17 @@
 
 		set_buffer_uptodate(bh);
 		/* remove from dirty list before I/O. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)		
+		/*
+		 * mark_buffer_clean() doesn't exist in 2.6.x kernels.
+		 * Not many places actually used mark_buffer_clean, but
+		 * at least reiserfs uses clear_buffer_dirty() as
+		 * a replacment.
+		 */
+		clear_buffer_dirty(bh);
+#else
 		mark_buffer_clean(bh);
+#endif
 
 		bh->b_end_io = ocfs_end_buffer_io_sync;
 		submit_bh(WRITE, bh);

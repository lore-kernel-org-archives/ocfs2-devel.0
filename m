From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Fri Mar  5 22:38:25 2004
Subject: [Ocfs2-devel] Re: [PATCH]inode binding on 2.6
In-Reply-To: <20040306004430.GB31692@ca-server1.us.oracle.com>
References: <200403042219.i24MJetf006769@penguin.co.intel.com>
	<20040306004430.GB31692@ca-server1.us.oracle.com>
Message-ID: <20040306043809.GA12859@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 05, 2004 at 04:44:30PM -0800, Mark Fasheh wrote:
> On Thu, Mar 04, 2004 at 02:19:40PM -0800, Rusty Lynch wrote:
> <snip>
> Looks good so far...
> 
> > None of these changes should effect the 2.4 build, and this patch does
> > make it possible to mount ocfs2 on a 2.6 box, walk a directory of file
> > put on the file system from a 2.4 build, and cat the files.
> > 
> > There is still a fatal bug that will hang the system just about anytime
> > any kind of clean up happens, which makes the 2.6 build still unusable 
> > (but closer to usable.)
> Can you give me an explanation of the bug?

I still need to properly charactorize the bug, and it is very likely
that there are multiple bugs, but some examples of how to trigger a 
freeze are:

* delete a file
* move a file (even from another filesystem to the ocfs2 mount)
* umount the file system

Normally the last debug message I see is ocfs_iput() exiting, and for
some reason kgdb is unable to walk the stack so I don't really get any
usefull information from the debugger.  Oh yea... On the svn version
from a couple of days ago, I was able to track down the mount hang to
when journal_destroy() calls kfree() on the journal_t (but I have not
tried since on the new tree.)

> 
> 
> > Index: src/inode.c
> > ===================================================================
> > --- src/inode.c	(revision 754)
> > +++ src/inode.c	(working copy)
> <snip>
> > @@ -391,9 +393,15 @@
> >  		    mode |= S_IFREG;
> >  		    break;
> >  	}
> > -	ocfs_populate_inode (inode, entry, mode, newoin, false);
> > +	ocfs_populate_inode (inode, fe, mode, newoin, false);
> > +	voteoff = S_ISDIR (mode) ? fe->extents[0].disk_off : fe->this_sector;
> > +	if (!args->skip_bind)
> > +		ocfs_inode_hash_bind(osb, voteoff, inode);
> Good so far, but aren't you missing the ocfs_inode_hash_bind() call for the
> root inode case in this function? Check out ocfs_read_inode2 to see what I'm
> talking about. You can safely ignore the skip_bind argument for the root
> inode.

got it. 

> <snip>
> > Index: src/inc/ocfs.h
> > ===================================================================
> > --- src/inc/ocfs.h	(revision 754)
> > +++ src/inc/ocfs.h	(working copy)
> > @@ -27,10 +27,6 @@
> >  #ifndef OCFS_H
> >  #define OCFS_H
> >  
> > -/* XXX Hack to avoid warning */
> > -struct mem_dqinfo;
> > -extern inline void mark_info_dirty(struct mem_dqinfo *info);
> > -
> Are you trying to slip an unrelated patch by me?  ;)
> Not that it's not correct (and I'll gladly commit it after you regenerate
> this patch)

My mistake. This is the patch that I sent out earlier.  I've just started
using the latest -mm tree, which breaks without the patch... but since your
willing to take it I left it in :->

> Could I get you to regenerate this against current svn? Also, please add
> that call to ocfs_inode_hash_bind.
> 	--Mark
> mark.fasheh@oracle.com


Index: src/inode.c
===================================================================
--- src/inode.c	(revision 762)
+++ src/inode.c	(working copy)
@@ -317,14 +317,16 @@
  * by this point, i_sb, i_dev, i_ino are filled in
  *
  */
-void ocfs_read_locked_inode (struct inode *inode, ocfs_file_entry *entry)
+void ocfs_read_locked_inode (struct inode *inode, ocfs_find_inode_args *args)
 {
 	struct super_block *sb;
 	ocfs_super *osb;
 	ocfs_inode *newoin;
 	umode_t mode;
+	__u64 voteoff;
+	ocfs_file_entry *fe = NULL;
 
-	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x)\n", inode, entry);
+	LOG_ENTRY_ARGS ("(%p, %p)\n", inode, args);
 
 	if (inode == NULL || inode->i_sb == NULL) {
 		LOG_ERROR_STR ("bad inode");
@@ -351,30 +353,31 @@
 		SET_INODE_OIN (inode, osb->oin_root_dir);
 		SET_INODE_VOTEOFF(inode, osb->vol_layout.root_start_off);
 		SET_INODE_FEOFF(inode, 0);
+		ocfs_inode_hash_bind(osb, GET_INODE_VOTEOFF(inode), inode);
 		goto bail;
 	}
 
 	LOG_TRACE_ARGS("Populating non-root inode (i_ino = %lu)\n", inode->i_ino);
-
-	if (entry == NULL) {
+	if (args)
+		fe = (ocfs_file_entry *) OCFS_BH_GET_DATA_READ(args->fe_bh);
+	if (!fe) {
 		make_bad_inode (inode);
 		goto bail;
 	}
 	
 	newoin = NULL;
 
-	mode = entry->prot_bits;
-
-	switch (entry->attribs) {
+	mode = fe->prot_bits;
+	switch (fe->attribs) {
 	    case OCFS_ATTRIB_DIRECTORY:
 		    mode |= S_IFDIR;
 		    break;
 	    case OCFS_ATTRIB_CHAR:
-		    inode->i_rdev = MKDEV (entry->dev_major, entry->dev_minor);
+		    inode->i_rdev = MKDEV (fe->dev_major, fe->dev_minor);
 		    mode |= S_IFCHR;
 		    break;
 	    case OCFS_ATTRIB_BLOCK:
-		    inode->i_rdev = MKDEV (entry->dev_major, entry->dev_minor);
+		    inode->i_rdev = MKDEV (fe->dev_major, fe->dev_minor);
 		    mode |= S_IFBLK;
 		    break;
 	    case OCFS_ATTRIB_FIFO:
@@ -391,9 +394,15 @@
 		    mode |= S_IFREG;
 		    break;
 	}
-	ocfs_populate_inode (inode, entry, mode, newoin, false);
+	ocfs_populate_inode (inode, fe, mode, newoin, false);
+	voteoff = S_ISDIR (mode) ? fe->extents[0].disk_off : fe->this_sector;
+	if (!args->skip_bind)
+		ocfs_inode_hash_bind(osb, voteoff, inode);
 
 bail:
+	if (fe)
+		OCFS_BH_PUT_DATA(args->fe_bh);
+
 	LOG_EXIT ();
 	return;
 }				/* ocfs_read_locked_inode */
@@ -578,17 +587,20 @@
  * us to sleep.
  * return 0 on success, 1 on failure
  */
-int ocfs_init_locked_inode(struct inode * inode, void * opaque) {
+int ocfs_init_locked_inode(struct inode * inode, void * opaque) 
+{
+	ocfs_find_inode_args *args = (ocfs_find_inode_args *) opaque;
 	int ret = 1;
-	LOG_ENTRY_ARGS("inode = %x, opaque = %x\n", inode, opaque);
+	LOG_ENTRY_ARGS("inode = %p, opaque = %p\n", inode, opaque);
 
 	/* We might be called from ocfs_fill_super in which case, opaque
 	 * will be null (but we'll be looking for the root inode
 	 * anyway... */
-	if (opaque == NULL) {
+	if (args == NULL) {
 		inode->i_ino = OCFS_ROOT_INODE_NUMBER;
+	} else {
+		inode->i_ino = args->ino;
 	}
-
 	ret = 0;
 //bail:
 	LOG_EXIT_STATUS(ret);
@@ -605,8 +617,6 @@
 struct inode * ocfs_iget(struct super_block *sb, ocfs_find_inode_args *args) 
 {
 	struct inode *inode = NULL;
-	__u64 off;
-	ocfs_file_entry *fe = NULL;
 
 	LOG_ENTRY();
 
@@ -616,13 +626,14 @@
 	/* if args == NULL, we want the root inode */
 	if (!args) {
 		LOG_TRACE_STR("looking for root inode");
-		inode = iget5_locked(sb, OCFS_ROOT_INODE_NUMBER, ocfs_find_actor, ocfs_init_locked_inode, NULL);
+		inode = iget5_locked(sb, OCFS_ROOT_INODE_NUMBER, 
+				     ocfs_find_actor, ocfs_init_locked_inode, 
+				     NULL);
 	} else {
 		LOG_TRACE_STR("looking for non-root inode");
-		off = args->offset;
 		/* Need to verify that ocfs_find_inode does the right thing,
 		 * and need to actually write ocfs_init_inode */
-		inode = iget5_locked(sb, LO (off), ocfs_find_actor,
+		inode = iget5_locked(sb, args->ino, ocfs_find_actor,
 				     ocfs_init_locked_inode, args);
 	}
 
@@ -632,11 +643,7 @@
 	/* inode was *not* in the inode cache */
 	if (inode->i_state & I_NEW) {
 		LOG_TRACE_STR("Inode was not in inode cache, reading it.");
-		if (args)
-			fe = OCFS_BH_GET_DATA_READ(args->fe_bh); /* read */
-		ocfs_read_locked_inode(inode, fe);
-		if (args)
-			OCFS_BH_PUT_DATA(args->fe_bh);
+		ocfs_read_locked_inode(inode, args);
 		unlock_new_inode(inode);
 	}
 
Index: src/dcache.c
===================================================================
--- src/dcache.c	(revision 762)
+++ src/dcache.c	(working copy)
@@ -50,10 +50,9 @@
         struct qstr q;
 	struct buffer_head *fe_bh = NULL;
 	int needs_trunc;
+	ocfs_find_inode_args args;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	int flags = nd->flags;
-#else
-	ocfs_find_inode_args args;
 #endif
 
         LOG_ENTRY_ARGS ("(0x%08x, %d, '%*s')\n", dentry, flags,
@@ -134,14 +133,14 @@
                 LOG_TRACE_STR("found the file entry, but it has been deleted or renamed!");
                 ret = 0;  /* it is now officially stale :) */
         } else {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-		ocfs_read_locked_inode (inode, fe);
-#else
 		args.offset = fe->this_sector;
 		args.fe_bh = fe_bh;
 		args.skip_bind = 1;
 		OCFS_BH_PUT_DATA(fe_bh);
 		fe = NULL;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
+		ocfs_read_locked_inode (inode, &args);
+#else
 		ocfs_read_inode2 (inode, (void *) &args);
 #endif
 		ret = 1;
Index: src/journal.c
===================================================================
--- src/journal.c	(revision 762)
+++ src/journal.c	(working copy)
@@ -900,11 +900,7 @@
 		       LO(fe->this_sector));
 	OCFS_BH_PUT_DATA(bh);
 	fe = NULL;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	inode = ocfs_iget (osb->sb, &args);
-#else
 	inode = ocfs_get_inode_from_offset(osb, args.offset, bh);
-#endif
 	if (inode == NULL) {
 		LOG_ERROR_STR("access error");
 		status = -EACCES;
@@ -1539,11 +1535,7 @@
 	args.skip_bind = 0;
 	OCFS_BH_PUT_DATA(bh);
 	fe = NULL;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-	inode = ocfs_iget (osb->sb, &args);
-#else
 	inode = ocfs_get_inode_from_offset(osb, args.offset, bh);
-#endif
 	if (inode == NULL) {
 		LOG_ERROR_STR("access error");
 		status = -EACCES;
Index: src/hash.c
===================================================================
--- src/hash.c	(revision 762)
+++ src/hash.c	(working copy)
@@ -1714,7 +1714,6 @@
 {
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
-	unsigned long ino = 0;
 	__u64 fe_off;
 	ocfs_file_entry *fe;
 	ocfs_find_inode_args args;
@@ -1780,12 +1779,12 @@
 		/* alright, allocate a new inode number for this guy
 		 * and insert it into the hash. It's not bound yet --
 		 * read_inode2 binds the actual inode to it. */
-		ino = ocfs_inode_hash_insert(osb, offset, fe_off);
+		args.ino = ocfs_inode_hash_insert(osb, offset, fe_off);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		inode = ocfs_iget (sb, &args);
 #else
 		inode =
-			iget4 (sb, ino,
+			iget4 (sb, args.ino,
 			       (find_inode_t) ocfs_find_inode, 
 			       (void *) (&args));
 #endif
Index: src/inc/ocfs.h
===================================================================
--- src/inc/ocfs.h	(revision 762)
+++ src/inc/ocfs.h	(working copy)
@@ -27,10 +27,6 @@
 #ifndef OCFS_H
 #define OCFS_H
 
-/* XXX Hack to avoid warning */
-struct mem_dqinfo;
-extern inline void mark_info_dirty(struct mem_dqinfo *info);
-
 /*
 ** System header files
 */
@@ -49,6 +45,9 @@
 #endif
 extern inline int generic_fls(int x);
 extern inline int get_bitmask_order(unsigned int count);
+/* XXX Hack to avoid warning */
+struct mem_dqinfo;
+extern inline void mark_info_dirty(struct mem_dqinfo *info);
 #else /* 2.4 kernel */
 #include <asm/processor.h>
 #endif /* 2.6 kernel */
@@ -2595,6 +2594,7 @@
 	__u64 offset;
 	struct buffer_head *fe_bh;
 	int skip_bind;
+	unsigned long ino;
 }
 ocfs_find_inode_args;
 /* timeout structure taken from Ben's aio.c */
Index: src/inc/proto.h
===================================================================
--- src/inc/proto.h	(revision 762)
+++ src/inc/proto.h	(working copy)
@@ -86,7 +86,7 @@
 
 int ocfs_find_inode (struct inode *inode, unsigned long ino, void *opaque);
 void ocfs_populate_inode (struct inode *inode, ocfs_file_entry *fe, umode_t mode, void *genptr, bool create_ino);
-void ocfs_read_locked_inode (struct inode *inode, ocfs_file_entry *entry);
+void ocfs_read_locked_inode (struct inode *inode, ocfs_find_inode_args *args);
 void ocfs_read_inode2 (struct inode *inode, void *opaque);
 void ocfs_read_inode (struct inode *inode);
 struct inode * ocfs_iget(struct super_block *sb, ocfs_find_inode_args *args);
Index: src/namei.c
===================================================================
--- src/namei.c	(revision 762)
+++ src/namei.c	(working copy)
@@ -74,7 +74,6 @@
 	struct super_block *sb = dir->i_sb;
 	struct dentry *ret;
 	ocfs_super *osb = (ocfs_super *) OCFS_GENERIC_SB_P(sb);
-	unsigned long ino;
 	__u64 inode_off;
 
 	LOG_ENTRY_ARGS ("(0x%08x, 0x%08x, '%*s')\n", dir, dentry,
@@ -125,12 +124,12 @@
 		/* alright, allocate a new inode number for this guy
 		 * and insert it into the hash. It's not bound yet --
 		 * read_inode2 binds the actual inode to it. */
-		ino = ocfs_inode_hash_insert(osb, inode_off, fe_off);
+		args.ino = ocfs_inode_hash_insert(osb, inode_off, fe_off);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 		inode = ocfs_iget (sb, &args);
 #else
 		inode =
-			iget4 (sb, ino,
+			iget4 (sb, args.ino,
 			       (find_inode_t) ocfs_find_inode, 
 			       (void *) (&args));
 #endif

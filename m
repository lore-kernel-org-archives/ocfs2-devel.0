From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar  4 16:19:58 2004
Subject: [Ocfs2-devel] [PATCH]inode binding on 2.6
Message-ID: <200403042219.i24MJetf006769@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ok, the fog is starting to clear and I am starting to get my hands around
how inodes work in ocfs.  On the current tree, a 2.6 build will:
* never set a new inodes i_ino
* never bind the new inode

The reason inode->i_ino is never initialized is because iget5_locked (unlike
iget4) does not set the i_ino when it creates a new inode, but leaves that
job to the passed in set function.

I've made some considerable changes to fix this, including:
* Added a new ino entry to the find_inode_args type.  This allows
  the set function helper for iget5_locked to know how to initialize 
  the i_ino on the new inode
* changed ocfs_read_locked_inode() to take a find_inode_args pointer
  instead of a ocfs_file_entry pointer.  This allows ocfs_read_locked_inode
  to bind new inodes by knowing when not to perform a bind in the case
  of revalidating an inode.
* changed ocfs_init_locked_inode (the iget5_locked set function) to 
  set the new inode i_ino for more then root inodes.
* changed ocfs_iget() to pass in the args.ino instead of the bottom half
  of the offset, and then also to just pass ocfs_read_locked_inode the
  args and let ocfs_read_locked_inode read the file entry
* various places were calling ocfs_iget when they should be calling
  ocfs_get_inode_from_offset() exactly like the 2.4 builds do


None of these changes should effect the 2.4 build, and this patch does
make it possible to mount ocfs2 on a 2.6 box, walk a directory of file
put on the file system from a 2.4 build, and cat the files.

There is still a fatal bug that will hang the system just about anytime
any kind of clean up happens, which makes the 2.6 build still unusable 
(but closer to usable.)

    --rusty

Index: src/inode.c
===================================================================
--- src/inode.c	(revision 754)
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
@@ -355,26 +357,26 @@
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
@@ -391,9 +393,15 @@
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
@@ -578,17 +586,20 @@
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
@@ -605,8 +616,6 @@
 struct inode * ocfs_iget(struct super_block *sb, ocfs_find_inode_args *args) 
 {
 	struct inode *inode = NULL;
-	__u64 off;
-	ocfs_file_entry *fe = NULL;
 
 	LOG_ENTRY();
 
@@ -616,13 +625,14 @@
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
 
@@ -632,11 +642,7 @@
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
--- src/dcache.c	(revision 754)
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
--- src/journal.c	(revision 754)
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
@@ -1531,11 +1527,7 @@
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
--- src/hash.c	(revision 754)
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
--- src/inc/ocfs.h	(revision 754)
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
@@ -49,6 +45,10 @@
 #endif
 extern inline int generic_fls(int x);
 extern inline int get_bitmask_order(unsigned int count);
+
+/* XXX Hack to avoid warning */
+struct mem_dqinfo;
+extern inline void mark_info_dirty(struct mem_dqinfo *info);
 #endif /* 2.4 kernel */
 
 #include  <linux/module.h>
@@ -2589,6 +2589,7 @@
 	__u64 offset;
 	struct buffer_head *fe_bh;
 	int skip_bind;
+	unsigned long ino;
 }
 ocfs_find_inode_args;
 /* timeout structure taken from Ben's aio.c */
Index: src/inc/proto.h
===================================================================
--- src/inc/proto.h	(revision 754)
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
--- src/namei.c	(revision 754)
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

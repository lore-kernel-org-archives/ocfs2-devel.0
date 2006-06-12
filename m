From: Herbert Poetzl <herbert@13thfloor.at>
Date: Mon, 12 Jun 2006 23:41:17 +0200
Subject: [Ocfs2-devel] ext2 attributes for OCFS2
In-Reply-To: <20060611174510.GW3082@ca-server1.us.oracle.com>
References: <20060610123253.GA23924@MAIL.13thfloor.at>
	<20060611174510.GW3082@ca-server1.us.oracle.com>
Message-ID: <20060612214116.GA13582@MAIL.13thfloor.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Jun 11, 2006 at 10:45:10AM -0700, Mark Fasheh wrote:
> Hey Herbert,
> 
> On Sat, Jun 10, 2006 at 02:32:53PM +0200, Herbert Poetzl wrote:
> > did a first hack on adding the iattrs (ext2) to OCFS2. it is
> > currently for Linux-VServer patched kernels and I need to clean it
> > up a little more (and of course test it), but I thought I'd ask you
> > folks what you think about the general idea and the implementation.
> Well it definitely looks like things are going in a good direction :) 

okay, so it looks like the ocfs2 folks are open to such
an extention which for me means that a mainline patch 
makes sense ...

> How many of these attributes were you planning to implement by the
> way? 

the good news here is that some of the attributes (like
the immutable or append) work out of the box once they
are there (i.e. present in the generic inode flags)

> I'm thinking we probably want to cover at least some of the basics -
> immutable, appends... Maybe the vfs already handles those for us -
> I'll have to read more code to figure that out. Patch comments below.
> 
> > here is a link to the patch, if there is some
> > interest from your side, I'll prepare one for
> > mainline ...
> > 
> > http://vserver.13thfloor.at/Experimental/delta-ocfs2-feat01.diff

> You probably want to move the cluster lock in the OCFS2_IOC_SETFLAGS
> case up a bit so that you can be sure your inode image is up to
> date within the cluster. Similarly, you'll probably want to take a
> read-only meta data lock in the OCFS2_IOC_GETFLAGS case.

okay, I moved those parts out of the ocfs2_ioctl
to match the general structure and enhance the
readabilitly - I hope I got the locks right this
time, please double check ...

> OCFS2 makes use of a small area associated with locks (called a Lock
> Value Block) to stuff commonly used inode information. This helps
> the file system avoid a disk read when updating inode information
> due to a new lock acquiry - ocfs2_meta_lock_update() is the function
> responsible for this. These new attributes should be put in the lvb as
> we'll want to be able to test their existence by checking the struct
> inode under cluster lock (as opposed to having to read off disk and
> checking the disk inode flags). Luckily this is pretty easy - you
> already handled the disk cases by updating ocfs2_populate_inode() and
> ocfs2_refresh_inode(). The lvb is a similar process. I'll outline the
> steps below.
>
> At the top of dlmglue.h you'll see the ocfs2_meta_lvb structure
> definition. Just go ahead and take some of the reserved fields for our
> purposes. Be sure to bump the value of OCFS2_LVB_VERSION so that node
> which don't understand the new field know just to ignore the lvb.
>
> The next step is to update __ocfs2_stuff_meta_lvb() to understand how
> to write the values into the lvb, and ocfs2_refresh_inode_from_lvb()
> to take them from the lvb into the inode.
>
> We only need to stuff these new flags into the lvb btw, so don't worry
> about the other ocfs2_dinode->i_flags - they're not nearly as dynamic
> and aren't really checked anywhere we won't already be using the disk.

okay, I added this and hopefully it will work as
expected, it didn't get exercised on my (up to now) 
single node test setup :)

> I'm thinking about whether we want to mark the existence of this
> feature in the superblock (probably as a compat flag). More on this
> later I suppose.

I decided to make this patch a little more agressive
than the last one, using a reserved field of the
on disk structure to store the new attributes, which
actually has two advantages IMHO:

 - the mapping between ext2/3 and ocfs2 isn't required
   anymore, as we an store the ext attrs without fear
   of collisions with existing ocfs2 flags

 - the mixing and separation of ocfs2 flags and ext
   flags can be avoided completely, probably enhancing
   readability while simplifying code

feel free to oject here, in which case I will add back
the mixing/separation code ...

> > note: some attributes (like the noatime) do not (yet) make sense for
> > OCFS2, It's just a generic approach ...

> Right. What's up with the OCFS2_BARRIER_FL and OCFS2_IUNLINK flags? 

ah, I forgot to mention, those are Linux-VServer 
specific too, so they do not apply for mainline
(but they are the primary reason for adding those
attributes to ocfs2 :)

> Am I correct when I don't notice those in ext3?

yup, they are present in Linux-VServer though :)

> Thanks!
> 	--Mark

I also added the ioctl.h to match the ocfs2 coding
style more closely ... enough words now, here is 
the new patch, this time inline for easier review 
and comments ...

TIA,
Herbert


diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/Makefile linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/Makefile
--- linux-2.6.16.20/fs/ocfs2/Makefile	2006-01-18 06:08:34 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/Makefile	2006-06-12 20:28:07 +0200
@@ -16,6 +16,7 @@ ocfs2-objs := \
 	file.o 			\
 	heartbeat.o 		\
 	inode.o 		\
+	ioctl.o 		\
 	journal.o 		\
 	localalloc.o 		\
 	mmap.o 			\
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/dlmglue.c linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/dlmglue.c
--- linux-2.6.16.20/fs/ocfs2/dlmglue.c	2006-01-18 06:08:34 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/dlmglue.c	2006-06-12 22:32:00 +0200
@@ -1321,6 +1321,7 @@ static void __ocfs2_stuff_meta_lvb(struc
 	lvb->lvb_version   = cpu_to_be32(OCFS2_LVB_VERSION);
 	lvb->lvb_isize	   = cpu_to_be64(i_size_read(inode));
 	lvb->lvb_iclusters = cpu_to_be32(oi->ip_clusters);
+	lvb->lvb_iflags    = cpu_to_be32(oi->ip_iflags);
 	lvb->lvb_iuid      = cpu_to_be32(inode->i_uid);
 	lvb->lvb_igid      = cpu_to_be32(inode->i_gid);
 	lvb->lvb_imode     = cpu_to_be16(inode->i_mode);
@@ -1349,12 +1351,14 @@ static void ocfs2_refresh_inode_from_lvb
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_lock_res *lockres = &oi->ip_meta_lockres;
 	struct ocfs2_meta_lvb *lvb;
+	int version;
 
 	mlog_entry_void();
 
 	mlog_meta_lvb(0, lockres);
 
 	lvb = (struct ocfs2_meta_lvb *) lockres->l_lksb.lvb;
+	version = be32_to_cpu(lvb->lvb_version);
 
 	/* We're safe here without the lockres lock... */
 	spin_lock(&oi->ip_lock);
@@ -1368,6 +1372,16 @@ static void ocfs2_refresh_inode_from_lvb
 		inode->i_blocks =
 			ocfs2_align_bytes_to_sectors(i_size_read(inode));
 
+	switch (version) {
+	case 3:
+		oi->ip_iflags = be32_to_cpu(lvb->lvb_iflags);
+		printk("lvb refresh for %p flags %x\n", inode, oi->ip_iflags);
+		break;
+	default:
+		oi->ip_iflags = 0;
+		printk("lvb refresh for %p flags = 0\n", inode);
+	}
+
 	inode->i_uid     = be32_to_cpu(lvb->lvb_iuid);
 	inode->i_gid     = be32_to_cpu(lvb->lvb_igid);
 	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/dlmglue.h linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/dlmglue.h
--- linux-2.6.16.20/fs/ocfs2/dlmglue.h	2006-01-18 06:08:34 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/dlmglue.h	2006-06-12 20:26:51 +0200
@@ -27,7 +27,7 @@
 #ifndef DLMGLUE_H
 #define DLMGLUE_H
 
-#define OCFS2_LVB_VERSION 2
+#define OCFS2_LVB_VERSION 3
 
 struct ocfs2_meta_lvb {
 	__be32       lvb_version;
@@ -40,7 +40,8 @@ struct ocfs2_meta_lvb {
 	__be64       lvb_isize;
 	__be16       lvb_imode;
 	__be16       lvb_inlink;
-	__be32       lvb_reserved[3];
+	__be32       lvb_iflags;
+	__be32       lvb_reserved[2];
 };
 
 /* ocfs2_meta_lock_full() and ocfs2_data_lock_full() 'arg_flags' flags */
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/file.c linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/file.c
--- linux-2.6.16.20/fs/ocfs2/file.c	2006-03-20 17:33:12 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/file.c	2006-06-12 21:18:13 +0200
@@ -44,6 +44,7 @@
 #include "file.h"
 #include "sysfile.h"
 #include "inode.h"
+#include "ioctl.h"
 #include "journal.h"
 #include "mmap.h"
 #include "suballoc.h"
@@ -1182,10 +1183,12 @@ struct file_operations ocfs2_fops = {
 	.open		= ocfs2_file_open,
 	.aio_read	= ocfs2_file_aio_read,
 	.aio_write	= ocfs2_file_aio_write,
+	.ioctl		= ocfs2_ioctl,
 };
 
 struct file_operations ocfs2_dops = {
 	.read		= generic_read_dir,
 	.readdir	= ocfs2_readdir,
 	.fsync		= ocfs2_sync_file,
+	.ioctl		= ocfs2_ioctl,
 };
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/inode.c linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.c
--- linux-2.6.16.20/fs/ocfs2/inode.c	2006-03-20 17:33:12 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.c	2006-06-12 22:52:59 +0200
@@ -71,6 +71,26 @@ static int ocfs2_truncate_for_delete(str
 				    struct inode *inode,
 				    struct buffer_head *fe_bh);
 
+void ocfs2_set_inode_flags(struct inode *inode)
+{
+	unsigned int flags = OCFS2_I(inode)->ip_iflags;
+
+	inode->i_flags &= ~(S_IMMUTABLE |
+		S_SYNC | S_APPEND | S_NOATIME | S_DIRSYNC);
+
+	if (flags & OCFS2_IMMUTABLE_FL)
+		inode->i_flags |= S_IMMUTABLE;
+
+	if (flags & OCFS2_SYNC_FL)
+		inode->i_flags |= S_SYNC;
+	if (flags & OCFS2_APPEND_FL)
+		inode->i_flags |= S_APPEND;
+	if (flags & OCFS2_NOATIME_FL)
+		inode->i_flags |= S_NOATIME;
+	if (flags & OCFS2_DIRSYNC_FL)
+		inode->i_flags |= S_DIRSYNC;
+}
+
 struct inode *ocfs2_ilookup_for_vote(struct ocfs2_super *osb,
 				     u64 blkno,
 				     int delete_vote)
@@ -258,7 +278,6 @@ int ocfs2_populate_inode(struct inode *i
 		inode->i_blocks =
 			ocfs2_align_bytes_to_sectors(le64_to_cpu(fe->i_size));
 	inode->i_mapping->a_ops = &ocfs2_aops;
-	inode->i_flags |= S_NOATIME;
 	inode->i_atime.tv_sec = le64_to_cpu(fe->i_atime);
 	inode->i_atime.tv_nsec = le32_to_cpu(fe->i_atime_nsec);
 	inode->i_mtime.tv_sec = le64_to_cpu(fe->i_mtime);
@@ -273,6 +292,7 @@ int ocfs2_populate_inode(struct inode *i
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	OCFS2_I(inode)->ip_orphaned_slot = OCFS2_INVALID_SLOT;
+	OCFS2_I(inode)->ip_iflags = le32_to_cpu(fe->i_iflags);
 
 	if (create_ino)
 		inode->i_ino = ino_from_blkno(inode->i_sb,
@@ -326,7 +346,8 @@ int ocfs2_populate_inode(struct inode *i
 				  OCFS2_LOCK_TYPE_META, inode);
 	ocfs2_inode_lock_res_init(&OCFS2_I(inode)->ip_data_lockres,
 				  OCFS2_LOCK_TYPE_DATA, inode);
-
+	ocfs2_set_inode_flags(inode);
+	inode->i_flags |= S_NOATIME;
 	status = 0;
 bail:
 	mlog_exit(status);
@@ -1125,6 +1145,7 @@ int ocfs2_mark_inode_dirty(struct ocfs2_
 
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 	fe->i_clusters = cpu_to_le32(OCFS2_I(inode)->ip_clusters);
+	fe->i_iflags = cpu_to_le32(OCFS2_I(inode)->ip_iflags);
 	spin_unlock(&OCFS2_I(inode)->ip_lock);
 
 	fe->i_size = cpu_to_le64(i_size_read(inode));
@@ -1163,6 +1184,9 @@ void ocfs2_refresh_inode(struct inode *i
 	spin_lock(&OCFS2_I(inode)->ip_lock);
 
 	OCFS2_I(inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
+	OCFS2_I(inode)->ip_iflags = le32_to_cpu(fe->i_iflags);
+	ocfs2_set_inode_flags(inode);
+
 	i_size_write(inode, le64_to_cpu(fe->i_size));
 	inode->i_nlink = le16_to_cpu(fe->i_links_count);
 	inode->i_uid = le32_to_cpu(fe->i_uid);
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/inode.h linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.h
--- linux-2.6.16.20/fs/ocfs2/inode.h	2006-04-09 13:49:54 +0200
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.h	2006-06-12 21:08:39 +0200
@@ -56,6 +56,7 @@ struct ocfs2_inode_info
 	struct ocfs2_journal_handle	*ip_handle;
 
 	u32				ip_flags; /* see below */
+	u32				ip_iflags; /* inode attributes */
 
 	/* protected by recovery_lock. */
 	struct inode			*ip_next_orphan;
@@ -142,4 +143,6 @@ int ocfs2_mark_inode_dirty(struct ocfs2_
 int ocfs2_aio_read(struct file *file, struct kiocb *req, struct iocb *iocb);
 int ocfs2_aio_write(struct file *file, struct kiocb *req, struct iocb *iocb);
 
+void ocfs2_set_inode_flags(struct inode *inode);
+
 #endif /* OCFS2_INODE_H */
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/ioctl.c linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/ioctl.c
--- linux-2.6.16.20/fs/ocfs2/ioctl.c	1970-01-01 01:00:00 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/ioctl.c	2006-06-12 22:58:50 +0200
@@ -0,0 +1,130 @@
+/*
+ * linux/fs/ocfs2/ioctl.c
+ *
+ * Copyright (C) 2006 Herbert Poetzl
+ * adapted from Remy Card's ext2/ioctl.c
+ */
+
+#include <linux/fs.h>
+#include <linux/mount.h>
+
+#define MLOG_MASK_PREFIX ML_INODE
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+#include "alloc.h"
+#include "dlmglue.h"
+#include "inode.h"
+#include "journal.h"
+
+#include "ocfs2_fs.h"
+#include <linux/ext2_fs.h>
+
+int ocfs2_get_iflags(struct inode *inode, unsigned *flags)
+{
+	int status;
+
+	status = ocfs2_meta_lock(inode, NULL, NULL, 0);
+	if (status < 0) {
+		mlog_errno(status);
+		return status;
+	}
+	*flags = OCFS2_I(inode)->ip_iflags;
+	ocfs2_meta_unlock(inode, 0);
+
+	mlog_exit(status);
+	return status;
+}
+
+int ocfs2_set_iflags(struct inode *inode, unsigned flags, unsigned mask)
+{
+	struct ocfs2_inode_info *ocfs2_inode = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct ocfs2_journal_handle *handle = NULL;
+	struct buffer_head *bh = NULL;
+	unsigned oldflags;
+	int status;
+
+	status = ocfs2_meta_lock(inode, NULL, &bh, 1);
+	if (status < 0) {
+		mlog_errno(status);
+		goto bail;
+	}
+
+	status = -EROFS;
+	if (IS_RDONLY(inode))
+		goto bail_unlock;
+
+	status = -EACCES;
+	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
+		goto bail_unlock;
+
+	if (!S_ISDIR(inode->i_mode))
+		flags &= ~OCFS2_DIRSYNC_FL;
+
+	handle = ocfs2_start_trans(osb, NULL, OCFS2_INODE_UPDATE_CREDITS);
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		mlog_errno(status);
+		goto bail_unlock;
+	}
+
+	oldflags = ocfs2_inode->ip_iflags;
+	flags = flags & mask;
+	flags |= oldflags & ~mask;
+
+	/*
+	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
+	 * the relevant capability.
+	 */
+	status = -EPERM;
+	if ((oldflags & OCFS2_IMMUTABLE_FL) || ((flags ^ oldflags) &
+		(OCFS2_APPEND_FL | OCFS2_IMMUTABLE_FL))) {
+		if (!capable(CAP_LINUX_IMMUTABLE))
+			goto bail_unlock;
+	}
+
+	ocfs2_inode->ip_iflags = flags;
+	ocfs2_set_inode_flags(inode);
+
+	status = ocfs2_mark_inode_dirty(handle, inode, bh);
+	if (status < 0)
+		mlog_errno(status);
+
+	ocfs2_commit_trans(handle);
+bail_unlock:
+	ocfs2_meta_unlock(inode, 1);
+bail:
+	if (bh)
+		brelse(bh);
+
+	mlog_exit(status);
+	return status;
+}
+
+
+int ocfs2_ioctl(struct inode * inode, struct file * filp,
+	unsigned int cmd, unsigned long arg)
+{
+	unsigned int flags;
+	int status;
+
+	switch (cmd) {
+	case OCFS2_IOC_GETFLAGS:
+		status = ocfs2_get_iflags(inode, &flags);
+		if (status < 0)
+			return status;
+
+		flags &= OCFS2_FL_VISIBLE;
+		return put_user(flags, (int __user *) arg);
+	case OCFS2_IOC_SETFLAGS:
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+
+		return ocfs2_set_iflags(inode, flags,
+			OCFS2_FL_MODIFIABLE);
+	default:
+		return -ENOTTY;
+	}
+}
+
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/ioctl.h linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/ioctl.h
--- linux-2.6.16.20/fs/ocfs2/ioctl.h	1970-01-01 01:00:00 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/ioctl.h	2006-06-12 21:17:50 +0200
@@ -0,0 +1,16 @@
+/*
+ * ioctl.h
+ *
+ * Function prototypes
+ *
+ * Copyright (C) 2006 Herbert Poetzl
+ *
+ */
+
+#ifndef OCFS2_IOCTL_H
+#define OCFS2_IOCTL_H
+
+int ocfs2_ioctl(struct inode * inode, struct file * filp,
+	unsigned int cmd, unsigned long arg);
+
+#endif /* OCFS2_IOCTL_H */
diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/ocfs2_fs.h linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/ocfs2_fs.h
--- linux-2.6.16.20/fs/ocfs2/ocfs2_fs.h	2006-04-09 13:49:54 +0200
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/ocfs2_fs.h	2006-06-12 21:28:30 +0200
@@ -114,6 +114,26 @@
 #define OCFS2_CHAIN_FL		(0x00000400)	/* Chain allocator */
 #define OCFS2_DEALLOC_FL	(0x00000800)	/* Truncate log */
 
+/* Inode attributes, keep in sync with EXT2 */
+#define OCFS2_SECRM_FL		(0x00000001)	/* Secure deletion */
+#define OCFS2_UNRM_FL		(0x00000002)	/* Undelete */
+#define OCFS2_COMPR_FL		(0x00000004)	/* Compress file */
+#define OCFS2_SYNC_FL		(0x00000008)	/* Synchronous updates */
+#define OCFS2_IMMUTABLE_FL	(0x00000010)	/* Immutable file */
+#define OCFS2_APPEND_FL		(0x00000020)	/* writes to file may only append */
+#define OCFS2_NODUMP_FL		(0x00000040)	/* do not dump file */
+#define OCFS2_NOATIME_FL	(0x00000080)	/* do not update atime */
+#define OCFS2_DIRSYNC_FL	(0x00010000)	/* dirsync behaviour (directories only) */
+
+#define OCFS2_FL_VISIBLE	(0x000100FF)	/* User visible flags */
+#define OCFS2_FL_MODIFIABLE	(0x000100FF)	/* User modifiable flags */
+
+/*
+ * ioctl commands
+ */
+#define OCFS2_IOC_GETFLAGS	_IOR('f', 1, long)
+#define OCFS2_IOC_SETFLAGS	_IOW('f', 2, long)
+
 /*
  * Journal Flags (ocfs2_dinode.id1.journal1.i_flags)
  */
@@ -399,7 +419,9 @@ struct ocfs2_dinode {
 	__le32 i_atime_nsec;
 	__le32 i_ctime_nsec;
 	__le32 i_mtime_nsec;
-/*70*/	__le64 i_reserved1[9];
+/*70*/	__le32 i_iflags;		/* inode attr flags */
+	__le32 i_reserved1;
+	__le64 i_reserved2[8];
 /*B8*/	union {
 		__le64 i_pad1;		/* Generic way to refer to this
 					   64bit union */

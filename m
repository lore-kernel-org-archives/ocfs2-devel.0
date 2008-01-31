From: Jeff Mahoney <jeffm@suse.com>
Date: Thu Jan 31 12:55:17 2008
Subject: [Ocfs2-devel] [patch 1/5] ocfs2: add compatibility for lockdep
References: <20080131204634.478915000@suse.com>
Message-ID: <20080131204715.155259000@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 SLES10 doesn't have lockdep support. This patch ifdefs out the lockdep
 annotations when lockdep isn't found.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 Config.make.in    |    1 +
 configure.in      |    5 +++++
 fs/ocfs2/Makefile |    4 ++++
 fs/ocfs2/inode.c  |    4 ++++
 4 files changed, 14 insertions(+)

--- a/Config.make.in	2008-01-31 13:51:13.000000000 -0500
+++ b/Config.make.in	2008-01-31 13:51:15.000000000 -0500
@@ -87,6 +87,7 @@ FILLDIR_T_WITH_INO_T = @FILLDIR_T_WITH_I
 INVALIDATEPAGE_RETURNS_INT = @INVALIDATEPAGE_RETURNS_INT@
 DIO_OLD_GET_BLOCKS = @DIO_OLD_GET_BLOCKS@
 HAS_SYSTEM_UTSNAME = @HAS_SYSTEM_UTSNAME@
+NO_LOCKDEP = @NO_LOCKDEP@
 
 OCFS_DEBUG = @OCFS_DEBUG@
 
--- a/configure.in	2008-01-31 13:51:13.000000000 -0500
+++ b/configure.in	2008-01-31 13:51:15.000000000 -0500
@@ -379,6 +379,11 @@ OCFS2_CHECK_KERNEL([system_utsname in ut
   HAS_SYSTEM_UTSNAME=yes, , [^extern struct new_utsname system_utsname])
 AC_SUBST(HAS_SYSTEM_UTSNAME)
 
+NO_LOCKDEP=
+OCFS2_CHECK_KERNEL([linux/lockdep.h], lockdep.h, ,
+  NO_LOCKDEP=yes, [^struct lock_class {])
+AC_SUBST(NO_LOCKDEP)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
--- a/fs/ocfs2/Makefile	2008-01-31 13:51:13.000000000 -0500
+++ b/fs/ocfs2/Makefile	2008-01-31 13:51:15.000000000 -0500
@@ -136,6 +136,10 @@ ifdef DIO_OLD_GET_BLOCKS
 EXTRA_CFLAGS += -DDIO_OLD_GET_BLOCKS
 endif
 
+ifdef NO_LOCKDEP
+EXTRA_CFLAGS += -DNO_LOCKDEP
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
--- a/fs/ocfs2/inode.c	2008-01-31 13:51:13.000000000 -0500
+++ b/fs/ocfs2/inode.c	2008-01-31 13:51:15.000000000 -0500
@@ -60,7 +60,9 @@ struct ocfs2_find_inode_args
 	unsigned int	fi_sysfile_type;
 };
 
+#ifndef NO_LOCKDEP
 static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
+#endif
 
 static int ocfs2_read_locked_inode(struct inode *inode,
 				   struct ocfs2_find_inode_args *args);
@@ -205,9 +207,11 @@ static int ocfs2_init_locked_inode(struc
 
 	inode->i_ino = args->fi_ino;
 	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
+#ifndef NO_LOCKDEP
 	if (args->fi_sysfile_type != 0)
 		lockdep_set_class(&inode->i_mutex,
 			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
+#endif
 
 	mlog_exit(0);
 	return 0;

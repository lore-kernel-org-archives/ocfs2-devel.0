From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Tue, 22 Dec 2015 15:55:50 -0800
Subject: [Ocfs2-devel] [PATCH] add OCFS2_LOCK_IGNORE_BLOCKED arg_flags to
	ocfs2_cluster_lock() to prevent hang
Message-ID: <1450828550-23168-1-git-send-email-tariq.x.saeed@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Linus Torvalds <torvalds@linux-foundation.org>

Orabug: 21793017

commit 743b5f1434f5 ("ocfs2: take inode lock in ocfs2_iop_set/get_acl()")
introduced this issue.  ocfs2_setattr called by chmod command
holds cluster wide inode lock (Orabug 21685187) when calling
posix_acl_chmod. This latter function in turn calls ocfs2_iop_get_acl
and ocfs2_iop_set_acl.  These two are also called directly from vfs layer
for getfacl/setfacl commands and therefore acquire the cluster wide inode
lock. If a remote conversion request comes after the first inode lock
in ocfs2_setattr, OCFS2_LOCK_BLOCKED will be set in l_flags. This will
cause the second call to inode lock from the  ocfs2_iop_get|set_acl()
to block indefinetly.  The new flag OCFS2_LOCK_IGNORE_BLOCKED will be
used to prevent this blocking.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com> Signed-off-by:
Junxiao Bi <junxiao.bi@oracle.com>
---
 Makefile           |    2 +-
 fs/ocfs2/acl.c     |    7 +++++--
 fs/ocfs2/dlmglue.c |    3 ++-
 fs/ocfs2/dlmglue.h |    2 ++
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 431067a..d5b3739 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 4
 PATCHLEVEL = 3
 SUBLEVEL = 0
-EXTRAVERSION = -rc7
+EXTRAVERSION =
 NAME = Blurry Fish Butt
 
 # *DOCUMENTATION*
diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index 0cdf497..4404d9a 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -37,6 +37,7 @@
 #include "xattr.h"
 #include "acl.h"
 
+
 /*
  * Convert from xattr value to acl struct.
  */
@@ -287,7 +288,8 @@ int ocfs2_iop_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	struct buffer_head *bh = NULL;
 	int status = 0;
 
-	status = ocfs2_inode_lock(inode, &bh, 1);
+	status = ocfs2_inode_lock_full(inode, &bh, 1,
+					OCFS2_LOCK_IGNORE_BLOCKED);
 	if (status < 0) {
 		if (status != -ENOENT)
 			mlog_errno(status);
@@ -309,7 +311,8 @@ struct posix_acl *ocfs2_iop_get_acl(struct inode *inode, int type)
 	osb = OCFS2_SB(inode->i_sb);
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return NULL;
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	ret = ocfs2_inode_lock_full(inode, &di_bh, 0,
+					OCFS2_LOCK_IGNORE_BLOCKED);
 	if (ret < 0) {
 		if (ret != -ENOENT)
 			mlog_errno(ret);
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1c91103..ea79e1b 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1447,7 +1447,8 @@ again:
 	}
 
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
-	    !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
+	    !ocfs2_may_continue_on_blocked_lock(lockres, level) &&
+	    !(arg_flags & OCFS2_LOCK_IGNORE_BLOCKED)) {
 		/* is the lock is currently blocked on behalf of
 		 * another node */
 		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_BLOCKED, 0);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index d293a22..845831f 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -78,6 +78,8 @@ struct ocfs2_orphan_scan_lvb {
 /* don't block waiting for the downconvert thread, instead return -EAGAIN */
 #define OCFS2_LOCK_NONBLOCK		(0x04)
 
+/* if requested level is <= l_level, ignore BLOCKED flag. */
+#define OCFS2_LOCK_IGNORE_BLOCKED		(0x08)
 /* Locking subclasses of inode cluster lock */
 enum {
 	OI_LS_NORMAL = 0,
-- 
1.7.1

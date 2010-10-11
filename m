From: Tristan Ye <tristan.ye@oracle.com>
Date: Mon, 11 Oct 2010 16:46:39 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add a mount option "coherency=*"
	to handle cluster coherency for O_DIRECT writes.
Message-ID: <1286786799-10230-1-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Currently, default behavior of O_DIRECT writes was allowing
concurrent writing among nodes, no cluster coherency guaranteed
(no EX locks was taken), it hurts buffered reads on other nodes
by reading stale data from cache.

The new mount option introduce a chance to choose two different
behaviors for O_DIRECT writes:

    * coherency=full, as the default value, will disallow
                      concurrent O_DIRECT writes by taking
                      EX locks.

    * coherency=buffered, allow concurrent O_DIRECT writes
                          without EX lock among nodes, which
                          gains high performance at risk of
                          getting stale data on other nodes.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 Documentation/filesystems/ocfs2.txt |    7 +++++++
 fs/ocfs2/file.c                     |   29 +++++++++++++++++++++++++++--
 fs/ocfs2/ocfs2.h                    |    3 +++
 fs/ocfs2/super.c                    |   15 +++++++++++++++
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 1f7ae14..5393e66 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -87,3 +87,10 @@ dir_resv_level=	(*)	By default, directory reservations will scale with file
 			reservations - users should rarely need to change this
 			value. If allocation reservations are turned off, this
 			option will have no effect.
+coherency=full  (*)	Disallow concurrent O_DIRECT writes, cluster inode
+			lock will be taken to force other nodes drop cache,
+			therefore full cluster coherency is guaranteed even
+			for O_DIRECT writes.
+coherency=buffered	Allow concurrent O_DIRECT writes without EX lock among
+			nodes, which gains high performance at risk of getting
+			stale data on other nodes.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9a03c15..b39a4e0 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2232,6 +2232,8 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int full_coherency = !(osb->s_mount_opt &
+			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 
 	mlog_entry("(0x%p, %u, '%.*s')\n", file,
 		   (unsigned int)nr_segs,
@@ -2255,14 +2257,37 @@ relock:
 		have_alloc_sem = 1;
 	}
 
-	/* concurrent O_DIRECT writes are allowed */
-	rw_level = !direct_io;
+	/*
+	 * Concurrent O_DIRECT writes are allowed with
+	 * mount_option "coherency=buffered".
+	 */
+	rw_level = (!direct_io || full_coherency);
+
 	ret = ocfs2_rw_lock(inode, rw_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_sems;
 	}
 
+	/*
+	 * O_DIRECT writes with "coherency=full" need to take EX cluster
+	 * inode_lock to guarantee coherency.
+	 */
+	if (direct_io && full_coherency) {
+		/*
+		 * We need to take and drop the inode lock to force
+		 * other nodes to drop their caches.  Buffered I/O
+		 * already does this in write_begin().
+		 */
+		ret = ocfs2_inode_lock(inode, NULL, 1);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_sems;
+		}
+
+		ocfs2_inode_unlock(inode, 1);
+	}
+
 	can_do_direct = direct_io;
 	ret = ocfs2_prepare_inode_for_write(file->f_path.dentry, ppos,
 					    iocb->ki_left, appending,
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index c67003b..2b987be 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -256,6 +256,9 @@ enum ocfs2_mount_options
 						   control lists */
 	OCFS2_MOUNT_USRQUOTA = 1 << 10, /* We support user quotas */
 	OCFS2_MOUNT_GRPQUOTA = 1 << 11, /* We support group quotas */
+
+	OCFS2_MOUNT_COHERENCY_BUFFERED = 1 << 12 /* Allow concurrent O_DIRECT
+						    writes */
 };
 
 #define OCFS2_OSB_SOFT_RO			0x0001
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index fa1be1b..7cb78c6 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -177,6 +177,8 @@ enum {
 	Opt_noacl,
 	Opt_usrquota,
 	Opt_grpquota,
+	Opt_coherency_buffered,
+	Opt_coherency_full,
 	Opt_resv_level,
 	Opt_dir_resv_level,
 	Opt_err,
@@ -205,6 +207,8 @@ static const match_table_t tokens = {
 	{Opt_noacl, "noacl"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_grpquota, "grpquota"},
+	{Opt_coherency_buffered, "coherency=buffered"},
+	{Opt_coherency_full, "coherency=full"},
 	{Opt_resv_level, "resv_level=%u"},
 	{Opt_dir_resv_level, "dir_resv_level=%u"},
 	{Opt_err, NULL}
@@ -1438,6 +1442,12 @@ static int ocfs2_parse_options(struct super_block *sb,
 		case Opt_grpquota:
 			mopt->mount_opt |= OCFS2_MOUNT_GRPQUOTA;
 			break;
+		case Opt_coherency_buffered:
+			mopt->mount_opt |= OCFS2_MOUNT_COHERENCY_BUFFERED;
+			break;
+		case Opt_coherency_full:
+			mopt->mount_opt &= ~OCFS2_MOUNT_COHERENCY_BUFFERED;
+			break;
 		case Opt_acl:
 			mopt->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
 			mopt->mount_opt &= ~OCFS2_MOUNT_NO_POSIX_ACL;
@@ -1536,6 +1546,11 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	if (opts & OCFS2_MOUNT_GRPQUOTA)
 		seq_printf(s, ",grpquota");
 
+	if (opts & OCFS2_MOUNT_COHERENCY_BUFFERED)
+		seq_printf(s, ",coherency=buffered");
+	else
+		seq_printf(s, ",coherency=full");
+
 	if (opts & OCFS2_MOUNT_NOUSERXATTR)
 		seq_printf(s, ",nouser_xattr");
 	else
-- 
1.5.5

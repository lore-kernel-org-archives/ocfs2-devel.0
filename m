From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan 17 14:36:37 2008
Subject: [Ocfs2-devel] [PATCH 20/30] ocfs2: Silence false lockdep warnings
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
Message-ID: <1200609356-17788-21-git-send-email-mark.fasheh@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>

From: Jan Kara <jack@suse.cz>

Create separate lockdep lock classes for system file's i_mutexes. They are
used to guard allocations and similar things and thus rank differently
than i_mutex of a regular file or directory.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/export.c  |    4 ++--
 fs/ocfs2/inode.c   |   10 +++++++++-
 fs/ocfs2/inode.h   |    7 ++++---
 fs/ocfs2/journal.c |    2 +-
 fs/ocfs2/namei.c   |    2 +-
 fs/ocfs2/super.c   |    4 ++--
 fs/ocfs2/sysfile.c |    2 +-
 7 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 1f9e353..67527ce 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -58,7 +58,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 		return ERR_PTR(-ESTALE);
 	}
 
-	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno, 0);
+	inode = ocfs2_iget(OCFS2_SB(sb), handle->ih_blkno, 0, 0);
 
 	if (IS_ERR(inode))
 		return (void *)inode;
@@ -109,7 +109,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 		goto bail_unlock;
 	}
 
-	inode = ocfs2_iget(OCFS2_SB(dir->i_sb), blkno, 0);
+	inode = ocfs2_iget(OCFS2_SB(dir->i_sb), blkno, 0, 0);
 	if (IS_ERR(inode)) {
 		mlog(ML_ERROR, "Unable to create inode %llu\n",
 		     (unsigned long long)blkno);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 00cd5b7..5e19c11 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -57,8 +57,11 @@ struct ocfs2_find_inode_args
 	u64		fi_blkno;
 	unsigned long	fi_ino;
 	unsigned int	fi_flags;
+	unsigned int	fi_sysfile_type;
 };
 
+static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
+
 static int ocfs2_read_locked_inode(struct inode *inode,
 				   struct ocfs2_find_inode_args *args);
 static int ocfs2_init_locked_inode(struct inode *inode, void *opaque);
@@ -106,7 +109,8 @@ void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi)
 		oi->ip_attr |= OCFS2_DIRSYNC_FL;
 }
 
-struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, int flags)
+struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
+			 int sysfile_type)
 {
 	struct inode *inode = NULL;
 	struct super_block *sb = osb->sb;
@@ -126,6 +130,7 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, int flags)
 	args.fi_blkno = blkno;
 	args.fi_flags = flags;
 	args.fi_ino = ino_from_blkno(sb, blkno);
+	args.fi_sysfile_type = sysfile_type;
 
 	inode = iget5_locked(sb, args.fi_ino, ocfs2_find_actor,
 			     ocfs2_init_locked_inode, &args);
@@ -200,6 +205,9 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 
 	inode->i_ino = args->fi_ino;
 	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
+	if (args->fi_sysfile_type != 0)
+		lockdep_set_class(&inode->i_mutex,
+			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
 
 	mlog_exit(0);
 	return 0;
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index a61c044..390a855 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -120,9 +120,10 @@ void ocfs2_delete_inode(struct inode *inode);
 void ocfs2_drop_inode(struct inode *inode);
 
 /* Flags for ocfs2_iget() */
-#define OCFS2_FI_FLAG_SYSFILE		0x4
-#define OCFS2_FI_FLAG_ORPHAN_RECOVERY	0x8
-struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 feoff, int flags);
+#define OCFS2_FI_FLAG_SYSFILE		0x1
+#define OCFS2_FI_FLAG_ORPHAN_RECOVERY	0x2
+struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 feoff, unsigned flags,
+			 int sysfile_type);
 int ocfs2_inode_init_private(struct inode *inode);
 int ocfs2_inode_revalidate(struct dentry *dentry);
 int ocfs2_populate_inode(struct inode *inode, struct ocfs2_dinode *fe,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 8b9ce2a..f31c7e8 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1244,7 +1244,7 @@ static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
 
 	/* Skip bad inodes so that recovery can continue */
 	iter = ocfs2_iget(p->osb, ino,
-			  OCFS2_FI_FLAG_ORPHAN_RECOVERY);
+			  OCFS2_FI_FLAG_ORPHAN_RECOVERY, 0);
 	if (IS_ERR(iter))
 		return 0;
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 74018ca..ae9ad95 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -128,7 +128,7 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 	if (status < 0)
 		goto bail_add;
 
-	inode = ocfs2_iget(OCFS2_SB(dir->i_sb), blkno, 0);
+	inode = ocfs2_iget(OCFS2_SB(dir->i_sb), blkno, 0, 0);
 	if (IS_ERR(inode)) {
 		ret = ERR_PTR(-EACCES);
 		goto bail_unlock;
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 4a091f5..01fe40e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -220,7 +220,7 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 
 	mlog_entry_void();
 
-	new = ocfs2_iget(osb, osb->root_blkno, OCFS2_FI_FLAG_SYSFILE);
+	new = ocfs2_iget(osb, osb->root_blkno, OCFS2_FI_FLAG_SYSFILE, 0);
 	if (IS_ERR(new)) {
 		status = PTR_ERR(new);
 		mlog_errno(status);
@@ -228,7 +228,7 @@ static int ocfs2_init_global_system_inodes(struct ocfs2_super *osb)
 	}
 	osb->root_inode = new;
 
-	new = ocfs2_iget(osb, osb->system_dir_blkno, OCFS2_FI_FLAG_SYSFILE);
+	new = ocfs2_iget(osb, osb->system_dir_blkno, OCFS2_FI_FLAG_SYSFILE, 0);
 	if (IS_ERR(new)) {
 		status = PTR_ERR(new);
 		mlog_errno(status);
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index fd2e846..ab713eb 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -112,7 +112,7 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	inode = ocfs2_iget(osb, blkno, OCFS2_FI_FLAG_SYSFILE);
+	inode = ocfs2_iget(osb, blkno, OCFS2_FI_FLAG_SYSFILE, type);
 	if (IS_ERR(inode)) {
 		mlog_errno(PTR_ERR(inode));
 		inode = NULL;
-- 
1.5.3.6

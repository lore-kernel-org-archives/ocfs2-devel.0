From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:22 2007
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Provide convenience function for
	ino lookup
Message-ID: <200709192012.l8JKCGXI029319@rgmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A couple paths which needed to just match a parent dir + name pair to an
inode number were a bit messy because they had to deal with
ocfs2_find_files_on_disk() which returns a larger number of values. Provide
a convenience function, ocfs2_lookup_ino_from_name() which internalizes all
the extra accounting.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c     |   17 +++++++++++++++++
 fs/ocfs2/dir.h     |    2 ++
 fs/ocfs2/export.c  |    8 +-------
 fs/ocfs2/namei.c   |    9 ++-------
 fs/ocfs2/sysfile.c |   10 +++-------
 5 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 4bb5440..4791683 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -628,6 +628,23 @@ leave:
 	return status;
 }
 
+/*
+ * Convenience function for callers which just want the block number
+ * mapped to a name and don't require the full dirent info, etc.
+ */
+int ocfs2_lookup_ino_from_name(struct inode *dir, const char *name,
+			       int namelen, u64 *blkno)
+{
+	int ret;
+	struct buffer_head *bh = NULL;
+	struct ocfs2_dir_entry *dirent = NULL;
+
+	ret = ocfs2_find_files_on_disk(name, namelen, blkno, dir, &bh, &dirent);
+	brelse(bh);
+
+	return ret;
+}
+
 /* Check for a name within a directory.
  *
  * Return 0 if the name does not exist
diff --git a/fs/ocfs2/dir.h b/fs/ocfs2/dir.h
index 3e65f91..d03eaaa 100644
--- a/fs/ocfs2/dir.h
+++ b/fs/ocfs2/dir.h
@@ -61,6 +61,8 @@ int ocfs2_find_files_on_disk(const char *name,
 			     struct inode *inode,
 			     struct buffer_head **dirent_bh,
 			     struct ocfs2_dir_entry **dirent);
+int ocfs2_lookup_ino_from_name(struct inode *dir, const char *name,
+			       int namelen, u64 *blkno);
 int ocfs2_readdir(struct file *filp, void *dirent, filldir_t filldir);
 int ocfs2_dir_foreach(struct inode *inode, loff_t *f_pos, void *priv,
 		      filldir_t filldir);
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index bc48177..c3bbc19 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -88,8 +88,6 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	struct dentry *parent;
 	struct inode *inode;
 	struct inode *dir = child->d_inode;
-	struct buffer_head *dirent_bh = NULL;
-	struct ocfs2_dir_entry *dirent;
 
 	mlog_entry("(0x%p, '%.*s')\n", child,
 		   child->d_name.len, child->d_name.name);
@@ -105,8 +103,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 		goto bail;
 	}
 
-	status = ocfs2_find_files_on_disk("..", 2, &blkno, dir, &dirent_bh,
-					  &dirent);
+	status = ocfs2_lookup_ino_from_name(dir, "..", 2, &blkno);
 	if (status < 0) {
 		parent = ERR_PTR(-ENOENT);
 		goto bail_unlock;
@@ -131,9 +128,6 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 bail_unlock:
 	ocfs2_meta_unlock(dir, 0);
 
-	if (dirent_bh)
-		brelse(dirent_bh);
-
 bail:
 	mlog_exit_ptr(parent);
 
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index aae6c0b..98aeebc 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -101,10 +101,8 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 {
 	int status;
 	u64 blkno;
-	struct buffer_head *dirent_bh = NULL;
 	struct inode *inode = NULL;
 	struct dentry *ret;
-	struct ocfs2_dir_entry *dirent;
 	struct ocfs2_inode_info *oi;
 
 	mlog_entry("(0x%p, 0x%p, '%.*s')\n", dir, dentry,
@@ -126,9 +124,8 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 		goto bail;
 	}
 
-	status = ocfs2_find_files_on_disk(dentry->d_name.name,
-					  dentry->d_name.len, &blkno,
-					  dir, &dirent_bh, &dirent);
+	status = ocfs2_lookup_ino_from_name(dir, dentry->d_name.name,
+					    dentry->d_name.len, &blkno);
 	if (status < 0)
 		goto bail_add;
 
@@ -183,8 +180,6 @@ bail_unlock:
 	ocfs2_meta_unlock(dir, 0);
 
 bail:
-	if (dirent_bh)
-		brelse(dirent_bh);
 
 	mlog_exit_ptr(ret);
 
diff --git a/fs/ocfs2/sysfile.c b/fs/ocfs2/sysfile.c
index 5df6e35..fd2e846 100644
--- a/fs/ocfs2/sysfile.c
+++ b/fs/ocfs2/sysfile.c
@@ -100,17 +100,14 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 	char namebuf[40];
 	struct inode *inode = NULL;
 	u64 blkno;
-	struct buffer_head *dirent_bh = NULL;
-	struct ocfs2_dir_entry *de = NULL;
 	int status = 0;
 
 	ocfs2_sprintf_system_inode_name(namebuf,
 					sizeof(namebuf),
 					type, slot);
 
-	status = ocfs2_find_files_on_disk(namebuf, strlen(namebuf),
-					  &blkno, osb->sys_root_inode,
-					  &dirent_bh, &de);
+	status = ocfs2_lookup_ino_from_name(osb->sys_root_inode, namebuf,
+					    strlen(namebuf), &blkno);
 	if (status < 0) {
 		goto bail;
 	}
@@ -122,8 +119,7 @@ static struct inode * _ocfs2_get_system_file_inode(struct ocfs2_super *osb,
 		goto bail;
 	}
 bail:
-	if (dirent_bh)
-		brelse(dirent_bh);
+
 	return inode;
 }
 
-- 
1.5.0.6

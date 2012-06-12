From: Jan Kara <jack@suse.cz>
Date: Tue, 12 Jun 2012 16:20:30 +0200
Subject: [Ocfs2-devel] [PATCH 09/27] fs: Push mnt_want_write() outside of
	i_mutex
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Message-ID: <1339510848-16992-10-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, "David S. Miller" <davem@davemloft.net>

Currently, mnt_want_write() is sometimes called with i_mutex held and sometimes
without it. This isn't really a problem because mnt_want_write() is a
non-blocking operation (essentially has a trylock semantics) but when the
function starts to handle also frozen filesystems, it will get a full lock
semantics and thus proper lock ordering has to be established. So move
all mnt_want_write() calls outside of i_mutex.

One non-trivial case needing conversion is kern_path_create() /
user_path_create() which didn't include mnt_want_write() but now needs to
because it acquires i_mutex.  Because there are virtual file systems which
don't bother with freeze / remount-ro protection we actually provide both
versions of the function - one which calls mnt_want_write() and one which does
not.

CC: ocfs2-devel at oss.oracle.com
CC: Mark Fasheh <mfasheh@suse.com>
CC: Joel Becker <jlbec@evilplan.org>
CC: "David S. Miller" <davem@davemloft.net>
BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/namei.c              |  115 +++++++++++++++++++++++++++--------------------
 fs/ocfs2/refcounttree.c |   10 +---
 include/linux/namei.h   |    2 +
 net/unix/af_unix.c      |   13 ++----
 4 files changed, 74 insertions(+), 66 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7d69419..6e65207 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2535,7 +2535,9 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path, int is_dir)
+static struct dentry *do_kern_path_create(int dfd, const char *pathname,
+					  struct path *path, int is_dir,
+					  int freeze_protect)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 	struct nameidata nd;
@@ -2553,6 +2555,14 @@ struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path
 	nd.flags |= LOOKUP_CREATE | LOOKUP_EXCL;
 	nd.intent.open.flags = O_EXCL;
 
+	if (freeze_protect) {
+		error = mnt_want_write(nd.path.mnt);
+		if (error) {
+			dentry = ERR_PTR(error);
+			goto out;
+		}
+	}
+
 	/*
 	 * Do the final lookup.
 	 */
@@ -2581,24 +2591,49 @@ eexist:
 	dentry = ERR_PTR(-EEXIST);
 fail:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+	if (freeze_protect)
+		mnt_drop_write(nd.path.mnt);
 out:
 	path_put(&nd.path);
 	return dentry;
 }
+
+struct dentry *kern_path_create(int dfd, const char *pathname, struct path *path, int is_dir)
+{
+	return do_kern_path_create(dfd, pathname, path, is_dir, 0);
+}
 EXPORT_SYMBOL(kern_path_create);
 
+struct dentry *kern_path_create_thawed(int dfd, const char *pathname, struct path *path, int is_dir)
+{
+	return do_kern_path_create(dfd, pathname, path, is_dir, 1);
+}
+EXPORT_SYMBOL(kern_path_create_thawed);
+
 struct dentry *user_path_create(int dfd, const char __user *pathname, struct path *path, int is_dir)
 {
 	char *tmp = getname(pathname);
 	struct dentry *res;
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	res = kern_path_create(dfd, tmp, path, is_dir);
+	res = do_kern_path_create(dfd, tmp, path, is_dir, 0);
 	putname(tmp);
 	return res;
 }
 EXPORT_SYMBOL(user_path_create);
 
+struct dentry *user_path_create_thawed(int dfd, const char __user *pathname, struct path *path, int is_dir)
+{
+	char *tmp = getname(pathname);
+	struct dentry *res;
+	if (IS_ERR(tmp))
+		return ERR_CAST(tmp);
+	res = do_kern_path_create(dfd, tmp, path, is_dir, 1);
+	putname(tmp);
+	return res;
+}
+EXPORT_SYMBOL(user_path_create_thawed);
+
 int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 {
 	int error = may_create(dir, dentry);
@@ -2653,7 +2688,7 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 	if (S_ISDIR(mode))
 		return -EPERM;
 
-	dentry = user_path_create(dfd, filename, &path, 0);
+	dentry = user_path_create_thawed(dfd, filename, &path, 0);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -2662,12 +2697,9 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 	error = may_mknod(mode);
 	if (error)
 		goto out_dput;
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto out_dput;
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
-		goto out_drop_write;
+		goto out_dput;
 	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(path.dentry->d_inode,dentry,mode,NULL);
@@ -2680,11 +2712,10 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 			error = vfs_mknod(path.dentry->d_inode,dentry,mode,0);
 			break;
 	}
-out_drop_write:
-	mnt_drop_write(path.mnt);
 out_dput:
 	dput(dentry);
 	mutex_unlock(&path.dentry->d_inode->i_mutex);
+	mnt_drop_write(path.mnt);
 	path_put(&path);
 
 	return error;
@@ -2726,24 +2757,20 @@ SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 	struct path path;
 	int error;
 
-	dentry = user_path_create(dfd, pathname, &path, 1);
+	dentry = user_path_create_thawed(dfd, pathname, &path, 1);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto out_dput;
 	error = security_path_mkdir(&path, dentry, mode);
 	if (error)
-		goto out_drop_write;
+		goto out_dput;
 	error = vfs_mkdir(path.dentry->d_inode, dentry, mode);
-out_drop_write:
-	mnt_drop_write(path.mnt);
 out_dput:
 	dput(dentry);
 	mutex_unlock(&path.dentry->d_inode->i_mutex);
+	mnt_drop_write(path.mnt);
 	path_put(&path);
 	return error;
 }
@@ -2838,6 +2865,9 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	}
 
 	nd.flags &= ~LOOKUP_PARENT;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto exit1;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
@@ -2848,19 +2878,15 @@ static long do_rmdir(int dfd, const char __user *pathname)
 		error = -ENOENT;
 		goto exit3;
 	}
-	error = mnt_want_write(nd.path.mnt);
-	if (error)
-		goto exit3;
 	error = security_path_rmdir(&nd.path, dentry);
 	if (error)
-		goto exit4;
+		goto exit3;
 	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
-exit4:
-	mnt_drop_write(nd.path.mnt);
 exit3:
 	dput(dentry);
 exit2:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
+	mnt_drop_write(nd.path.mnt);
 exit1:
 	path_put(&nd.path);
 	putname(name);
@@ -2927,6 +2953,9 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		goto exit1;
 
 	nd.flags &= ~LOOKUP_PARENT;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto exit1;
 
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
@@ -2939,21 +2968,17 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		if (!inode)
 			goto slashes;
 		ihold(inode);
-		error = mnt_want_write(nd.path.mnt);
-		if (error)
-			goto exit2;
 		error = security_path_unlink(&nd.path, dentry);
 		if (error)
-			goto exit3;
+			goto exit2;
 		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
-exit3:
-		mnt_drop_write(nd.path.mnt);
-	exit2:
+exit2:
 		dput(dentry);
 	}
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	if (inode)
 		iput(inode);	/* truncate the inode here */
+	mnt_drop_write(nd.path.mnt);
 exit1:
 	path_put(&nd.path);
 	putname(name);
@@ -3013,23 +3038,19 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 	if (IS_ERR(from))
 		return PTR_ERR(from);
 
-	dentry = user_path_create(newdfd, newname, &path, 0);
+	dentry = user_path_create_thawed(newdfd, newname, &path, 0);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto out_putname;
 
-	error = mnt_want_write(path.mnt);
-	if (error)
-		goto out_dput;
 	error = security_path_symlink(&path, dentry, from);
 	if (error)
-		goto out_drop_write;
+		goto out_dput;
 	error = vfs_symlink(path.dentry->d_inode, dentry, from);
-out_drop_write:
-	mnt_drop_write(path.mnt);
 out_dput:
 	dput(dentry);
 	mutex_unlock(&path.dentry->d_inode->i_mutex);
+	mnt_drop_write(path.mnt);
 	path_put(&path);
 out_putname:
 	putname(from);
@@ -3122,7 +3143,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	if (error)
 		return error;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path, 0);
+	new_dentry = user_path_create_thawed(newdfd, newname, &new_path, 0);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out;
@@ -3130,18 +3151,14 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	error = -EXDEV;
 	if (old_path.mnt != new_path.mnt)
 		goto out_dput;
-	error = mnt_want_write(new_path.mnt);
-	if (error)
-		goto out_dput;
 	error = security_path_link(old_path.dentry, &new_path, new_dentry);
 	if (error)
-		goto out_drop_write;
+		goto out_dput;
 	error = vfs_link(old_path.dentry, new_path.dentry->d_inode, new_dentry);
-out_drop_write:
-	mnt_drop_write(new_path.mnt);
 out_dput:
 	dput(new_dentry);
 	mutex_unlock(&new_path.dentry->d_inode->i_mutex);
+	mnt_drop_write(new_path.mnt);
 	path_put(&new_path);
 out:
 	path_put(&old_path);
@@ -3338,6 +3355,10 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	if (newnd.last_type != LAST_NORM)
 		goto exit2;
 
+	error = mnt_want_write(oldnd.path.mnt);
+	if (error)
+		goto exit2;
+
 	oldnd.flags &= ~LOOKUP_PARENT;
 	newnd.flags &= ~LOOKUP_PARENT;
 	newnd.flags |= LOOKUP_RENAME_TARGET;
@@ -3373,23 +3394,19 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	if (new_dentry == trap)
 		goto exit5;
 
-	error = mnt_want_write(oldnd.path.mnt);
-	if (error)
-		goto exit5;
 	error = security_path_rename(&oldnd.path, old_dentry,
 				     &newnd.path, new_dentry);
 	if (error)
-		goto exit6;
+		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
-exit6:
-	mnt_drop_write(oldnd.path.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
 	dput(old_dentry);
 exit3:
 	unlock_rename(new_dir, old_dir);
+	mnt_drop_write(oldnd.path.mnt);
 exit2:
 	path_put(&newnd.path);
 	putname(to);
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9f32d7c..dd0c588 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4453,7 +4453,7 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 		return error;
 	}
 
-	new_dentry = user_path_create(AT_FDCWD, newname, &new_path, 0);
+	new_dentry = user_path_create_thawed(AT_FDCWD, newname, &new_path, 0);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry)) {
 		mlog_errno(error);
@@ -4466,19 +4466,13 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 		goto out_dput;
 	}
 
-	error = mnt_want_write(new_path.mnt);
-	if (error) {
-		mlog_errno(error);
-		goto out_dput;
-	}
-
 	error = ocfs2_vfs_reflink(old_path.dentry,
 				  new_path.dentry->d_inode,
 				  new_dentry, preserve);
-	mnt_drop_write(new_path.mnt);
 out_dput:
 	dput(new_dentry);
 	mutex_unlock(&new_path.dentry->d_inode->i_mutex);
+	mnt_drop_write(new_path.mnt);
 	path_put(&new_path);
 out:
 	path_put(&old_path);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index ffc0213..432f6bb 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -77,7 +77,9 @@ extern int user_path_at_empty(int, const char __user *, unsigned, struct path *,
 extern int kern_path(const char *, unsigned, struct path *);
 
 extern struct dentry *kern_path_create(int, const char *, struct path *, int);
+extern struct dentry *kern_path_create_thawed(int, const char *, struct path *, int);
 extern struct dentry *user_path_create(int, const char __user *, struct path *, int);
+extern struct dentry *user_path_create_thawed(int, const char __user *, struct path *, int);
 extern int kern_path_parent(const char *, struct nameidata *);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct path *);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 641f2e4..37e65a2 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -866,7 +866,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		 * Get the parent directory, calculate the hash for last
 		 * component.
 		 */
-		dentry = kern_path_create(AT_FDCWD, sun_path, &path, 0);
+		dentry = kern_path_create_thawed(AT_FDCWD, sun_path, &path, 0);
 		err = PTR_ERR(dentry);
 		if (IS_ERR(dentry))
 			goto out_mknod_parent;
@@ -876,19 +876,13 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current_umask());
-		err = mnt_want_write(path.mnt);
-		if (err)
-			goto out_mknod_dput;
 		err = security_path_mknod(&path, dentry, mode, 0);
 		if (err)
-			goto out_mknod_drop_write;
-		err = vfs_mknod(path.dentry->d_inode, dentry, mode, 0);
-out_mknod_drop_write:
-		mnt_drop_write(path.mnt);
-		if (err)
 			goto out_mknod_dput;
+		err = vfs_mknod(path.dentry->d_inode, dentry, mode, 0);
 		mutex_unlock(&path.dentry->d_inode->i_mutex);
 		dput(path.dentry);
+		mnt_drop_write(path.mnt);
 		path.dentry = dentry;
 
 		addr->hash = UNIX_HASH_SIZE;
@@ -925,6 +919,7 @@ out:
 out_mknod_dput:
 	dput(dentry);
 	mutex_unlock(&path.dentry->d_inode->i_mutex);
+	mnt_drop_write(path.mnt);
 	path_put(&path);
 out_mknod_parent:
 	if (err == -EEXIST)
-- 
1.7.1

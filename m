From: J. Bruce Fields <bfields@fieldses.org>
Date: Tue, 3 Jan 2006 13:30:47 -0500
Subject: [Ocfs2-devel] NFS exports of cluster filesystems
In-Reply-To: <20051216211736.GA14415@fieldses.org>
References: <20051216211736.GA14415@fieldses.org>
Message-ID: <20060103183047.GD11551@fieldses.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I got a "holding for moderator approval" message and then nothing else
happened, so I'm resending after subscribing.--Bruce Fields

---

As implementers of the Linux NFSv4 server support, we've found there's
interest in good support for NFS exports of cluster filesystems (via
NFSv4 and earlier versions).

There are a number of obstacles to this, and we're interested in finding
solutions that are acceptable to OCFS2.  (If I've directed this to the
wrong email list, please let me know!)

To give an example--there are a couple of problems with the current VFS
support for posix byte-range locks:

	*  We'd rather not block nfsd or lockd threads for longer than
	   necessary, so it'd be nice to have a way to make lock
	   requests asynchronously.  This might be helpful even for
	   non-blocking locks, since we may not even be able to
	   determine whether a lock is contended without waiting for a
	   response from a remote node.

	*  Given that in the blocking case we want the filesystem to be
	   able to return from ->lock() without having necessarily acquired
	   the lock, we need to be able to handle the case where a
	   process on the client is interrupted and the client cancels
	   the lock.

A patch is appended showing the sort of VFS lock changes we're thinking
about.

This patch allows the filesystem ->lock() method to return -EINPROGRESS
and then call a lock-manager callback if provided, and adds a FL_CANCEL
flag to the struct file_lock to indicate that the caller wants to cancel
the provided lock.

Look reasonable?  Ideas?  What work has anyone else done on this?

--Bruce Fields

Patch follows---

There is currently a filesystem ->lock() method, but it is defined only
by a few filesystems that are not exported via nfs.  So none of the lock
routines that are used by lockd or nfsv4 bother to call those methods.
Cluster filesystems would like to be able define their own ->lock()
methods and also would like to be exportable via NFS.

So we add vfs_lock_file, vfs_test_lock, and vfs_cancel_lock routines
which do call the underlying filesystem's lock routines.  These are
intended to be used by lock managers (lockd and nfsd); lockd and nfsd
changes to take advantage of them are made by later patches.

Acquiring a lock may require comminication with remote hosts, and to avoid
blocking lockd or nfsd threads during such communication, we allow the
results to be returned asynchronously.

When a ->lock() call needs to block, the file system will return
-EINPROGRESS, and then later return the results with a call to the routine
in the fl_vfs_callback of the lock_manager_operations struct.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---

 fs/locks.c         |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    6 ++++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 250ef53..05581c4 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -996,6 +996,85 @@ int posix_lock_file_wait(struct file *fi
 EXPORT_SYMBOL(posix_lock_file_wait);
 
 /**
+ * vfs_lock_file - file byte range lock
+ * @filp: The file to apply the lock to
+ * @fl: The lock to be applied
+ *
+ * To avoid blocking kernel daemons, such as lockd, that need to acquire POSIX
+ * locks, the ->lock() interface may return asynchronously, before the lock has
+ * been granted or denied by the underlying filesystem, if (and only if)
+ * fl_vfs_callback is set. Callers expecting ->lock() to return asynchronously
+ * will only use F_SETLK, not F_SETLKW; they will set FL_SLEEP if (and only if)
+ * the request is for a blocking lock. When ->lock() does return asynchronously,
+ * it must return -EINPROGRESS, and call ->fl_vfs_callback() when the lock
+ * request completes.
+ * If the request is for non-blocking lock the file system should return
+ * -EINPROGRESS then try to get the lock and call the callback routine with
+ * the result. If the request timed out the callback routine will return a
+ * nonzero return code and the file system should release the lock. The file
+ * system is also responsible to keep a corresponding posix lock when it
+ * grants a lock so the VFS can find out which locks are locally held and do
+ * the correct lock cleanup when required.
+ * The underlying filesystem must not drop the kernel lock or call
+ * ->fl_vfs_callback() before returning to the caller with a -EINPROGRESS
+ * return code.
+ */
+int vfs_lock_file(struct file *filp, struct file_lock *fl)
+{
+	if (filp->f_op && filp->f_op->lock)
+		return filp->f_op->lock(filp, F_SETLK, fl);
+	else
+		return __posix_lock_file_conf(filp->f_dentry->d_inode, fl, NULL);
+}
+EXPORT_SYMBOL(vfs_lock_file);
+
+/**
+ * vfs_test_lock - test file byte range lock
+ * @filp: The file to test lock for
+ * @fl: The lock to test
+ * @conf: Place to return a copy of the conflicting lock, if found.
+ */
+int vfs_test_lock(struct file *filp, struct file_lock *fl, struct file_lock *conf)
+{
+	int error;
+
+	conf->fl_type = F_UNLCK;
+	if (filp->f_op && filp->f_op->lock) {
+ 		locks_copy_lock(conf, fl);
+		error = filp->f_op->lock(filp, F_GETLK, conf);
+		if (!error) {
+			if (conf->fl_type != F_UNLCK)
+				error =  1;
+		}
+		return error;
+ 	} else
+		return posix_test_lock(filp, fl, conf);
+}
+EXPORT_SYMBOL(vfs_test_lock);
+
+/**
+ * vfs_cancel_lock - file byte range unblock lock
+ * @filp: The file to apply the unblock to
+ * @fl: The lock to be unblocked
+ *
+ * FL_CANCELED is used to cancel blocked requests
+ */
+void vfs_cancel_lock(struct file *filp, struct file_lock *fl)
+{
+	lock_kernel();
+	fl->fl_flags |= FL_CANCEL;
+	if (filp->f_op && filp->f_op->lock) {
+		/* XXX: check locking */
+		unlock_kernel();
+		filp->f_op->lock(filp, F_SETLK, fl);
+	} else {
+		posix_unblock_lock(filp, fl);
+		unlock_kernel();
+	}
+}
+EXPORT_SYMBOL(vfs_cancel_lock);
+
+/**
  * locks_mandatory_locked - Check for an active lock
  * @inode: the file to check
  *
diff --git a/include/linux/fs.h b/include/linux/fs.h
index cc35b6a..c5307ab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -640,6 +640,7 @@ extern spinlock_t files_lock;
 #define FL_ACCESS	8	/* not trying to lock, just looking */
 #define FL_LOCKD	16	/* lock held by rpc.lockd */
 #define FL_LEASE	32	/* lease held on this file */
+#define FL_CANCEL	64	/* set to request cancelling a lock */
 #define FL_SLEEP	128	/* A blocking lock */
 
 /*
@@ -666,6 +667,7 @@ struct lock_manager_operations {
 	void (*fl_break)(struct file_lock *);
 	int (*fl_mylease)(struct file_lock *, struct file_lock *);
 	int (*fl_change)(struct file_lock **, int);
+	int (*fl_vfs_callback)(struct file_lock *, struct file_lock *, int result);
 };
 
 /* that will die - we need it for nfs_lock_info */
@@ -725,6 +727,10 @@ extern void locks_init_lock(struct file_
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
 extern void locks_remove_posix(struct file *, fl_owner_t);
 extern void locks_remove_flock(struct file *);
+extern int vfs_lock_file(struct file *, struct file_lock *);
+extern int vfs_lock_file_conf(struct file *, struct file_lock *, struct file_lock *);
+extern int vfs_test_lock(struct file *, struct file_lock *, struct file_lock *);
+extern void vfs_cancel_lock(struct file *, struct file_lock *);
 extern struct file_lock *posix_test_lock(struct file *, struct file_lock *);
 extern int posix_lock_file(struct file *, struct file_lock *);
 extern int posix_lock_file_wait(struct file *, struct file_lock *);

From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 12 Mar 2010 17:07:36 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2-1.6: add splice read/write support
In-Reply-To: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
References: <1268384742-3861-1-git-send-email-tiger.yang@oracle.com>
Message-ID: <1268384856-3929-1-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch copied splice code in mainline 2.6.29
to allow support for splice io with enterprise
kernels based on 2.6.18.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 Config.make.in               |    1 +
 configure.in                 |   10 ++-
 fs/ocfs2/Makefile            |    7 +
 fs/ocfs2/compat_splice.c     |  251 ++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c              |   90 ++++-----------
 fs/ocfs2/xattr.c             |    2 +-
 kapi-compat/include/splice.h |   21 ++++
 7 files changed, 314 insertions(+), 68 deletions(-)
 create mode 100644 fs/ocfs2/compat_splice.c
 create mode 100644 kapi-compat/include/splice.h

diff --git a/Config.make.in b/Config.make.in
index 6c556d6..adebda0 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -81,6 +81,7 @@ HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 NO_CONFIRM_IN_PIPE_OPERATIONS = @NO_CONFIRM_IN_PIPE_OPERATIONS@
 NO_INODE_DOUBLE_LOCK = @NO_INODE_DOUBLE_LOCK@
 NO_FILE_REMOVE_SUID = @NO_FILE_REMOVE_SUID@
+NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
 SKIP_SPLICE = @SKIP_SPLICE@
 SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 NO_NAME_IN_BACKING_DEV_INFO=@NO_NAME_IN_BACKING_DEV_INFO@
diff --git a/configure.in b/configure.in
index 36a1867..c71fc00 100644
--- a/configure.in
+++ b/configure.in
@@ -432,9 +432,15 @@ OCFS2_CHECK_KERNEL([file_remove_suid() in fs.h], fs.h,
 AC_SUBST(NO_FILE_REMOVE_SUID)
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_FILE_REMOVE_SUID"
 
+NO_SPLICE_HEADER=
+OCFS2_CHECK_KERNEL([struct splice_desc in splice.h], splice.h,
+ , NO_SPLICE_HEADER=splice.h, [^struct splice_desc ])
+AC_SUBST(NO_SPLICE_HEADER)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $NO_SPLICE_HEADER"
+
 SKIP_SPLICE=
-OCFS2_CHECK_KERNEL([splice.h], splice.h,
-  , SKIP_SPLICE=yes, [struct splice_desc {])
+OCFS2_CHECK_KERNEL([splice_read() in fs.h], fs.h,
+ , SKIP_SPLICE=yes, [ssize_t (\*splice_read)])
 AC_SUBST(SKIP_SPLICE)
 
 mnt_want_write=
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 866f87e..13a9d07 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -124,8 +124,15 @@ ifdef NO_FILE_REMOVE_SUID
 EXTRA_CFLAGS += -DNO_FILE_REMOVE_SUID
 endif
 
+ifdef NO_SPLICE_HEADER
+EXTRA_CFLAGS += -DNO_SPLICE_HEADER
+endif
+
+COMPAT_SOURCES += compat_splice.c
 ifdef SKIP_SPLICE
 EXTRA_CFLAGS += -DSKIP_SPLICE
+else
+FS_SOURCES += compat_splice.c
 endif
 
 ifdef SKIP_BUFFER_TRIGGERS
diff --git a/fs/ocfs2/compat_splice.c b/fs/ocfs2/compat_splice.c
new file mode 100644
index 0000000..9533d37
--- /dev/null
+++ b/fs/ocfs2/compat_splice.c
@@ -0,0 +1,251 @@
+/*
+ * compat_splice.c
+ *
+ * This code has been copied from mainline linux kernel 2.6.29
+ * to allow ocfs2 to build against older kernels. For license,
+ * refer to fs/splice.c in mainline linux kernel.
+ */
+
+void pipe_wait(struct pipe_inode_info *pipe)
+{
+	DEFINE_WAIT(wait);
+
+	/*
+	 * Pipes are system-local resources, so sleeping on them
+	 * is considered a noninteractive wait:
+	 */
+	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
+	if (pipe->inode)
+		mutex_unlock(&pipe->inode->i_mutex);
+	schedule();
+	finish_wait(&pipe->wait, &wait);
+	if (pipe->inode)
+		mutex_lock(&pipe->inode->i_mutex);
+}
+
+/*
+ * This is a little more tricky than the file -> pipe splicing. There are
+ * basically three cases:
+ *
+ *	- Destination page already exists in the address space and there
+ *	  are users of it. For that case we have no other option that
+ *	  copying the data. Tough luck.
+ *	- Destination page already exists in the address space, but there
+ *	  are no users of it. Make sure it's uptodate, then drop it. Fall
+ *	  through to last case.
+ *	- Destination page does not exist, we can add the pipe page to
+ *	  the page cache and avoid the copy.
+ *
+ * If asked to move pages to the output file (SPLICE_F_MOVE is set in
+ * sd->flags), we attempt to migrate pages from the pipe to the output
+ * file address space page cache. This is possible if no one else has
+ * the pipe page referenced outside of the pipe and page cache. If
+ * SPLICE_F_MOVE isn't set, or we cannot move the page, we simply create
+ * a new page in the output file page cache and fill/dirty that.
+ */
+static int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
+			struct splice_desc *sd)
+{
+	struct file *file = sd_file(sd);
+	struct address_space *mapping = file->f_mapping;
+	unsigned int offset, this_len;
+	struct page *page;
+	void *fsdata;
+	int ret;
+
+	/*
+	 * make sure the data in this buffer is uptodate
+	 */
+	ret = buf->ops->kapi_confirm(pipe, buf);
+	if (unlikely(ret))
+		return ret;
+
+	offset = sd->pos & ~PAGE_CACHE_MASK;
+
+	this_len = sd->len;
+	if (this_len + offset > PAGE_CACHE_SIZE)
+		this_len = PAGE_CACHE_SIZE - offset;
+
+	ret = pagecache_write_begin(file, mapping, sd->pos, this_len,
+				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
+	if (unlikely(ret))
+		goto out;
+
+	if (buf->page != page) {
+		/*
+		 * Careful, ->map() uses KM_USER0!
+		 */
+		char *src = buf->ops->map(pipe, buf, 1);
+		char *dst = kmap_atomic(page, KM_USER1);
+
+		memcpy(dst + offset, src + buf->offset, this_len);
+		flush_dcache_page(page);
+		kunmap_atomic(dst, KM_USER1);
+		buf->ops->unmap(pipe, buf, src);
+	}
+	ret = pagecache_write_end(file, mapping, sd->pos, this_len, this_len,
+				page, fsdata);
+out:
+	return ret;
+}
+
+/**
+ * __splice_from_pipe - splice data from a pipe to given actor
+ * @pipe:	pipe to splice from
+ * @sd:		information to @actor
+ * @actor:	handler that splices the data
+ *
+ * Description:
+ *    This function does little more than loop over the pipe and call
+ *    @actor to do the actual moving of a single struct pipe_buffer to
+ *    the desired destination. See pipe_to_file, pipe_to_sendpage, or
+ *    pipe_to_user.
+ *
+ */
+ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			   splice_actor *actor)
+{
+	int ret, do_wakeup, err;
+
+	ret = 0;
+	do_wakeup = 0;
+
+	for (;;) {
+		if (pipe->nrbufs) {
+			struct pipe_buffer *buf = pipe->bufs + pipe->curbuf;
+			const struct pipe_buf_operations *ops = buf->ops;
+
+			sd->len = buf->len;
+			if (sd->len > sd->total_len)
+				sd->len = sd->total_len;
+
+			err = actor(pipe, buf, sd);
+			if (err <= 0) {
+				if (!ret && err != -ENODATA)
+					ret = err;
+
+				break;
+			}
+
+			ret += err;
+			buf->offset += err;
+			buf->len -= err;
+
+			sd->len -= err;
+			sd->pos += err;
+			sd->total_len -= err;
+			if (sd->len)
+				continue;
+
+			if (!buf->len) {
+				buf->ops = NULL;
+				ops->release(pipe, buf);
+				pipe->curbuf = (pipe->curbuf + 1) &
+						(PIPE_BUFFERS - 1);
+				pipe->nrbufs--;
+				if (pipe->inode)
+					do_wakeup = 1;
+			}
+
+			if (!sd->total_len)
+				break;
+		}
+
+		if (pipe->nrbufs)
+			continue;
+		if (!pipe->writers)
+			break;
+		if (!pipe->waiting_writers) {
+			if (ret)
+				break;
+		}
+
+		if (sd->flags & SPLICE_F_NONBLOCK) {
+			if (!ret)
+				ret = -EAGAIN;
+			break;
+		}
+
+		if (signal_pending(current)) {
+			if (!ret)
+				ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (do_wakeup) {
+			smp_mb();
+			if (waitqueue_active(&pipe->wait))
+				wake_up_interruptible_sync(&pipe->wait);
+			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+			do_wakeup = 0;
+		}
+
+		pipe_wait(pipe);
+	}
+
+	if (do_wakeup) {
+		smp_mb();
+		if (waitqueue_active(&pipe->wait))
+			wake_up_interruptible(&pipe->wait);
+		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
+	}
+
+	return ret;
+}
+
+/**
+ * generic_file_splice_write_nolock - generic_file_splice_write without mutexes
+ * @pipe:	pipe info
+ * @out:	file to write to
+ * @ppos:	position in @out
+ * @len:	number of bytes to splice
+ * @flags:	splice modifier flags
+ *
+ * Description:
+ *    Will either move or copy pages (determined by @flags options) from
+ *    the given pipe inode to the given file. The caller is responsible
+ *    for acquiring i_mutex on both inodes.
+ *
+ */
+ssize_t
+generic_file_splice_write_nolock(struct pipe_inode_info *pipe, struct file *out,
+				 loff_t *ppos, size_t len, unsigned int flags)
+{
+	struct address_space *mapping = out->f_mapping;
+	struct inode *inode = mapping->host;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+	};
+	ssize_t ret;
+	int err;
+
+	sd_file(&sd) = out;
+	err = file_remove_suid(out);
+	if (unlikely(err))
+		return err;
+
+	ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
+	if (ret > 0) {
+		unsigned long nr_pages;
+
+		*ppos += ret;
+		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+
+		/*
+		 * If file or inode is SYNC and we actually wrote some data,
+		 * sync it.
+		 */
+		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
+			err = generic_osync_inode(inode, mapping,
+						  OSYNC_METADATA|OSYNC_DATA);
+
+			if (err)
+				ret = err;
+		}
+		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
+	}
+
+	return ret;
+}
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ed8a49d..6c1af9e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -31,8 +31,10 @@
 #include <linux/pagemap.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
-#ifndef SKIP_SPLICE
+#ifndef NO_SPLICE_HEADER
 #include <linux/splice.h>
+#else
+#include <linux/pipe_fs_i.h>
 #endif
 #include <linux/mount.h>
 #include <linux/writeback.h>
@@ -2077,22 +2079,7 @@ out_sems:
 }
 
 #ifndef SKIP_SPLICE
-static int ocfs2_splice_to_file(struct pipe_inode_info *pipe,
-				struct file *out,
-				struct splice_desc *sd)
-{
-	int ret;
-
-	ret = ocfs2_prepare_inode_for_write(filp_dentry(out), &sd->pos,
-					    sd->total_len, 0, NULL, NULL);
-	if (ret < 0) {
-		mlog_errno(ret);
-		return ret;
-	}
-
-	return splice_from_pipe_feed(pipe, sd, pipe_to_file);
-}
-
+/* These two functions have been copied from mainline linux kernel 2.6.29. */
 static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 				       struct file *out,
 				       loff_t *ppos,
@@ -2100,61 +2087,34 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 				       unsigned int flags)
 {
 	int ret;
-	struct address_space *mapping = out->f_mapping;
-	struct inode *inode = mapping->host;
-	struct splice_desc sd = {
-		.total_len = len,
-		.flags = flags,
-		.pos = *ppos,
-		.u.file = out,
-	};
+	struct inode *inode = filp_dentry(out)->d_inode;
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", out, pipe,
 		   (unsigned int)len,
 		   filp_dentry(out)->d_name.len,
 		   filp_dentry(out)->d_name.name);
 
-	if (pipe->inode)
-		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
-
-	splice_from_pipe_begin(&sd);
-	do {
-		ret = splice_from_pipe_next(pipe, &sd);
-		if (ret <= 0)
-			break;
-
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
-		ret = ocfs2_rw_lock(inode, 1);
-		if (ret < 0)
-			mlog_errno(ret);
-		else {
-			ret = ocfs2_splice_to_file(pipe, out, &sd);
-			ocfs2_rw_unlock(inode, 1);
-		}
-		mutex_unlock(&inode->i_mutex);
-	} while (ret > 0);
-	splice_from_pipe_end(pipe, &sd);
-
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
+	inode_double_lock(inode, pipe->inode);
 
-	if (sd.num_spliced)
-		ret = sd.num_spliced;
-
-	if (ret > 0) {
-		unsigned long nr_pages;
-		int err;
+	ret = ocfs2_rw_lock(inode, 1);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out;
+	}
 
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	ret = ocfs2_prepare_inode_for_write(filp_dentry(out), ppos, len, 0,
+					    NULL, NULL);
+	if (ret < 0) {
+		mlog_errno(ret);
+		goto out_unlock;
+	}
 
-		err = generic_write_sync(out, *ppos, ret);
-		if (err)
-			ret = err;
-		else
-			*ppos += ret;
+	ret = generic_file_splice_write_nolock(pipe, out, ppos, len, flags);
 
-		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
-	}
+out_unlock:
+	ocfs2_rw_unlock(inode, 1);
+out:
+	inode_double_unlock(inode, pipe->inode);
 
 	mlog_exit(ret);
 	return ret;
@@ -2166,7 +2126,7 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 				      size_t len,
 				      unsigned int flags)
 {
-	int ret = 0, lock_level = 0;
+	int ret = 0;
 	struct inode *inode = filp_dentry(in)->d_inode;
 
 	mlog_entry("(0x%p, 0x%p, %u, '%.*s')\n", in, pipe,
@@ -2177,12 +2137,12 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 	/*
 	 * See the comment in ocfs2_file_aio_read()
 	 */
-	ret = ocfs2_inode_lock_atime(inode, in->f_vfsmnt, &lock_level);
+	ret = ocfs2_inode_lock(inode, NULL, 0);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto bail;
 	}
-	ocfs2_inode_unlock(inode, lock_level);
+	ocfs2_inode_unlock(inode, 0);
 
 	ret = generic_file_splice_read(in, ppos, pipe, len, flags);
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 3cedf95..b782673 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -27,7 +27,7 @@
 #include <linux/pagemap.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
-#ifndef SKIP_SPLICE
+#ifndef NO_SPLICE_HEADER
 #include <linux/splice.h>
 #endif
 #include <linux/mount.h>
diff --git a/kapi-compat/include/splice.h b/kapi-compat/include/splice.h
new file mode 100644
index 0000000..4aa2e72
--- /dev/null
+++ b/kapi-compat/include/splice.h
@@ -0,0 +1,21 @@
+#ifndef KAPI_SPLICE_H
+#define KAPI_SPLICE_H
+
+#ifndef SKIP_SPLICE
+#include <linux/pipe_fs_i.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
+
+ssize_t generic_file_splice_write_nolock(struct pipe_inode_info *pipe,
+					 struct file *out, loff_t *ppos,
+					 size_t len, unsigned int flags);
+
+#ifdef NO_SPLICE_HEADER
+# define sd_file(i) ((i)->file)
+#else
+# define sd_file(i) ((i)->u.file)
+#endif
+
+#endif /* SKIP_SPLICE */
+
+#endif
-- 
1.5.2.3

From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 15 May 2008 16:52:07 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add splice read/write support.
In-Reply-To: <1210841528-7769-2-git-send-email-tiger.yang@oracle.com>
References: <1210841528-7769-1-git-send-email-tiger.yang@oracle.com>
	<1210841528-7769-2-git-send-email-tiger.yang@oracle.com>
Message-ID: <1210841528-7769-3-git-send-email-tiger.yang@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
---
 configure.in                 |    1 +
 fs/ocfs2/Makefile            |    1 +
 fs/ocfs2/compat_splice.c     |  129 ++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c              |   12 ++--
 kapi-compat/include/splice.h |   16 +++++
 5 files changed, 152 insertions(+), 7 deletions(-)
 create mode 100644 fs/ocfs2/compat_splice.c
 create mode 100644 kapi-compat/include/splice.h

diff --git a/configure.in b/configure.in
index 1a7b2b5..14a0316 100644
--- a/configure.in
+++ b/configure.in
@@ -268,6 +268,7 @@ NO_SPLICE_HEADER=
 OCFS2_CHECK_KERNEL([struct splice_desc in splice.h], splice.h,
   , NO_SPLICE_HEADER=yes, [^struct splice_desc ])
 AC_SUBST(NO_SPLICE_HEADER)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS splice.h"
 
 relatime_compat_header=""
 OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index dd1a8bc..f43da58 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -97,6 +97,7 @@ CFLAGS_file.o += -DNO_VECTORIZED_AIO
 endif
 
 ifdef NO_SPLICE_FROM_PIPE
+SOURCES += compat_splice.c
 EXTRA_CFLAGS += -DNO_SPLICE_FROM_PIPE
 endif
 
diff --git a/fs/ocfs2/compat_splice.c b/fs/ocfs2/compat_splice.c
new file mode 100644
index 0000000..31da274
--- /dev/null
+++ b/fs/ocfs2/compat_splice.c
@@ -0,0 +1,129 @@
+/*
+ * compat_splice.c
+ *
+ * This code has been copied from mainline linux kernel git commit
+ * 40bee44eaef91b6030037c8bb47f909181fb1edc to allow ocfs2 to build
+ * against older kernels. For license, refer to fs/splice.c in mainline
+ * linux kernel.
+ *
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
+				pipe->curbuf = (pipe->curbuf + 1) & (PIPE_BUFFERS - 1);
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
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index af1a037..422c5f1 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -33,6 +33,8 @@
 #include <linux/sched.h>
 #ifndef NO_SPLICE_HEADER
 #include <linux/splice.h>
+#else
+#include <linux/pipe_fs_i.h>
 #endif
 #include <linux/mount.h>
 #include <linux/writeback.h>
@@ -2241,20 +2243,19 @@ out_sems:
 	return written ? written : ret;
 }
 
-#ifndef NO_SPLICE_FROM_PIPE
 static int ocfs2_splice_write_actor(struct pipe_inode_info *pipe,
 				    struct pipe_buffer *buf,
 				    struct splice_desc *sd)
 {
 	int ret, count;
 	ssize_t copied = 0;
-	struct file *file = sd->u.file;
+	struct file *file = sd_file(sd);
 	unsigned int offset;
 	struct page *page = NULL;
 	void *fsdata;
 	char *src, *dst;
 
-	ret = buf->ops->confirm(pipe, buf);
+	ret = buf->ops->kapi_confirm(pipe, buf);
 	if (ret)
 		goto out;
 
@@ -2301,9 +2302,9 @@ static ssize_t __ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 		.total_len = len,
 		.flags = flags,
 		.pos = *ppos,
-		.u.file = out,
 	};
 
+	sd_file(&sd) = out;
 	ret = __splice_from_pipe(pipe, &sd, ocfs2_splice_write_actor);
 	if (ret > 0) {
 		*ppos += ret;
@@ -2390,7 +2391,6 @@ bail:
 	mlog_exit(ret);
 	return ret;
 }
-#endif
 
 static ssize_t __ocfs2_file_aio_read(struct kiocb *iocb,
 				   const struct iovec *iov,
@@ -2550,10 +2550,8 @@ const struct file_operations ocfs2_fops = {
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
 	.flock		= ocfs2_flock,
-#ifndef NO_SPLICE_FROM_PIPE
 	.splice_read	= ocfs2_file_splice_read,
 	.splice_write	= ocfs2_file_splice_write,
-#endif
 #ifdef HAS_FOPS_SENDFILE
 	.sendfile	= ocfs2_file_sendfile,
 #endif
diff --git a/kapi-compat/include/splice.h b/kapi-compat/include/splice.h
new file mode 100644
index 0000000..f1fcdc0
--- /dev/null
+++ b/kapi-compat/include/splice.h
@@ -0,0 +1,16 @@
+#ifndef KAPI_SPLICE_H
+#define KAPI_SPLICE_H
+
+#ifdef NO_SPLICE_FROM_PIPE
+#include <linux/pipe_fs_i.h>
+ssize_t __splice_from_pipe(struct pipe_inode_info *pipe, struct splice_desc *sd,
+			   splice_actor *actor);
+#endif
+
+#ifdef NO_SPLICE_HEADER
+# define sd_file(i) (i)->file
+#else
+# define sd_file(i) (i)->u.file
+#endif
+
+#endif
-- 
1.5.4.4

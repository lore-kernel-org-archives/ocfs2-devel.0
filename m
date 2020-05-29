From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 29 May 2020 07:41:05 +0000
Subject: [Ocfs2-devel] [PATCH 10/13] eventpoll: simplify sysctl declaration
	with register_sysctl_subdir()
In-Reply-To: <20200529074108.16928-1-mcgrof@kernel.org>
References: <20200529074108.16928-1-mcgrof@kernel.org>
Message-ID: <20200529074108.16928-11-mcgrof@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: keescook@chromium.org, yzaikin@google.com, nixiaoming@huawei.com, ebiederm@xmission.com, axboe@kernel.dk, clemens@ladisch.de, arnd@arndb.de, gregkh@linuxfoundation.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch, benh@kernel.crashing.org, rdna@fb.com, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, vbabka@suse.cz, sfr@canb.auug.org.au, jack@suse.cz, amir73il@gmail.com, rafael@kernel.org, tytso@mit.edu
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, julia.lawall@lip6.fr, Luis Chamberlain <mcgrof@kernel.org>, akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org, ocfs2-devel@oss.oracle.com

From: Xiaoming Ni <nixiaoming@huawei.com>

Move epoll_table sysctl to fs/eventpoll.c and remove the
clutter out of kernel/sysctl.c by using register_sysctl_subdir()..

Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/eventpoll.c         | 10 +++++++++-
 include/linux/poll.h   |  2 --
 include/linux/sysctl.h |  1 -
 kernel/sysctl.c        |  7 -------
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12eebcdea9c8..957ebc9700e3 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -299,7 +299,7 @@ static LIST_HEAD(tfile_check_list);
 static long long_zero;
 static long long_max = LONG_MAX;
 
-struct ctl_table epoll_table[] = {
+static struct ctl_table epoll_table[] = {
 	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
@@ -311,6 +311,13 @@ struct ctl_table epoll_table[] = {
 	},
 	{ }
 };
+
+static void __init epoll_sysctls_init(void)
+{
+	register_sysctl_subdir("fs", "epoll", epoll_table);
+}
+#else
+#define epoll_sysctls_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
 static const struct file_operations eventpoll_fops;
@@ -2422,6 +2429,7 @@ static int __init eventpoll_init(void)
 	/* Allocates slab cache used to allocate "struct eppoll_entry" */
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
 		sizeof(struct eppoll_entry), 0, SLAB_PANIC|SLAB_ACCOUNT, NULL);
+	epoll_sysctls_init();
 
 	return 0;
 }
diff --git a/include/linux/poll.h b/include/linux/poll.h
index 1cdc32b1f1b0..a9e0e1c2d1f2 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -8,12 +8,10 @@
 #include <linux/wait.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/sysctl.h>
 #include <linux/uaccess.h>
 #include <uapi/linux/poll.h>
 #include <uapi/linux/eventpoll.h>
 
-extern struct ctl_table epoll_table[]; /* for sysctl */
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
 #ifdef __clang__
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index aa01f54d0442..e5364b69dd95 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -217,7 +217,6 @@ extern int no_unaligned_warning;
 
 extern struct ctl_table sysctl_mount_point[];
 extern struct ctl_table random_table[];
-extern struct ctl_table epoll_table[];
 
 #else /* CONFIG_SYSCTL */
 static inline struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e007375c8a11..5c116904feb7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -3001,13 +3001,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_EPOLL
-	{
-		.procname	= "epoll",
-		.mode		= 0555,
-		.child		= epoll_table,
-	},
-#endif
 #endif
 	{
 		.procname	= "protected_symlinks",
-- 
2.26.2

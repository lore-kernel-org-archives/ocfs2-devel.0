From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 10 Nov 2009 17:38:30 -0800
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2: Handle missing const modifier in
	seq_open()
In-Reply-To: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
References: <1257903510-29198-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1257903510-29198-9-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit 15ad7cdcfd76450d4beebc789ec646664238184d added the const
modifier to struct seq_operations * in seq_open().

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in              |    1 +
 configure.in                |    5 +++++
 fs/ocfs2/cluster/Makefile   |    4 ++++
 fs/ocfs2/cluster/netdebug.c |    8 ++++++++
 fs/ocfs2/dlm/Makefile       |    4 ++++
 fs/ocfs2/dlm/dlmdebug.c     |    4 ++++
 6 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Config.make.in b/Config.make.in
index 32d99a8..2e5ff54 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -69,6 +69,7 @@ SOP_IS_NOT_CONST = @SOP_IS_NOT_CONST@
 EXPORTOP_IS_NOT_CONST = @EXPORTOP_IS_NOT_CONST@
 MATCHTABLE_IS_NOT_CONST = @MATCHTABLE_IS_NOT_CONST@
 VMOP_IS_NOT_CONST = @VMOP_IS_NOT_CONST@
+SEQOP_IS_NOT_CONST = @SEQOP_IS_NOT_CONST@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/configure.in b/configure.in
index e7939c4..cdadf77 100644
--- a/configure.in
+++ b/configure.in
@@ -267,6 +267,11 @@ OCFS2_CHECK_KERNEL([vm_area_struct->vm_ops has the const modifier in mm.h], mm.h
   , VMOP_IS_NOT_CONST=yes, [^.*const struct vm_operations_struct \*vm_ops;])
 AC_SUBST(VMOP_IS_NOT_CONST)
 
+SEQOP_IS_NOT_CONST=
+OCFS2_CHECK_KERNEL([seq_open() has const struct seq_operations * in seq_file.h], seq_file.h,
+ , SEQOP_IS_NOT_CONST=yes, [int seq_open(struct file \*, const struct seq_operations \*);])
+AC_SUBST(SEQOP_IS_NOT_CONST)
+
 
 # End kapi_compat checks
 
diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
index c1f4f31..d89112d 100644
--- a/fs/ocfs2/cluster/Makefile
+++ b/fs/ocfs2/cluster/Makefile
@@ -22,6 +22,10 @@ ifdef NO_DELAYED_WORK_STRUCT
 EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
 endif
 
+ifdef SEQOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DSEQOP_IS_NOT_CONST
+endif
+
 SOURCES +=			\
 	heartbeat.c		\
 	masklog.c		\
diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
index da794bc..cacd83f 100644
--- a/fs/ocfs2/cluster/netdebug.c
+++ b/fs/ocfs2/cluster/netdebug.c
@@ -163,7 +163,11 @@ static void nst_seq_stop(struct seq_file *seq, void *v)
 {
 }
 
+#ifdef SEQOP_IS_NOT_CONST
+static struct seq_operations nst_seq_ops = {
+#else
 static const struct seq_operations nst_seq_ops = {
+#endif
 	.start = nst_seq_start,
 	.next = nst_seq_next,
 	.stop = nst_seq_stop,
@@ -344,7 +348,11 @@ static void sc_seq_stop(struct seq_file *seq, void *v)
 {
 }
 
+#ifdef SEQOP_IS_NOT_CONST
+static struct seq_operations sc_seq_ops = {
+#else
 static const struct seq_operations sc_seq_ops = {
+#endif
 	.start = sc_seq_start,
 	.next = sc_seq_next,
 	.stop = sc_seq_stop,
diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
index b70058d..122b370 100644
--- a/fs/ocfs2/dlm/Makefile
+++ b/fs/ocfs2/dlm/Makefile
@@ -38,6 +38,10 @@ ifdef SOP_IS_NOT_CONST
 EXTRA_CFLAGS += -DSOP_IS_NOT_CONST
 endif
 
+ifdef SEQOP_IS_NOT_CONST
+EXTRA_CFLAGS += -DSEQOP_IS_NOT_CONST
+endif
+
 DLM_SOURCES +=			\
 	dlmast.c		\
 	dlmconvert.c		\
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 42b0bad..f18afe9 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -682,7 +682,11 @@ static int lockres_seq_show(struct seq_file *s, void *v)
 	return 0;
 }
 
+#ifdef SEQOP_IS_NOT_CONST
+static struct seq_operations debug_lockres_ops = {
+#else
 static const struct seq_operations debug_lockres_ops = {
+#endif
 	.start =	lockres_seq_start,
 	.stop =		lockres_seq_stop,
 	.next =		lockres_seq_next,
-- 
1.5.6.5

From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 20 Nov 2009 17:12:52 -0800
Subject: [Ocfs2-devel] [PATCH 05/10] ocfs2: Handle missing struct
	jbd2_buffer_trigger_type
In-Reply-To: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
References: <1258765977-4334-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1258765977-4334-6-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mainline commit e06c8227fd94ec181849ba206bf032be31c4295c added buffer commit
triggers in JBD2. OCFS2 uses these triggers to calculate the metadata checksums.

Patch disables the MetaECC feature temporarily.

TODO: Pull JBD2 source in OCFS2 1.6 repo and re-enable the MetaECC feature.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 Config.make.in                 |    1 +
 Makefile                       |    3 +-
 configure.in                   |    6 +++
 fs/ocfs2/Makefile              |    4 ++
 fs/ocfs2/journal.c             |    2 +
 fs/ocfs2/super.c               |    9 +++++
 kapi-compat/include/triggers.h |   72 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 96 insertions(+), 1 deletions(-)
 create mode 100644 kapi-compat/include/triggers.h

diff --git a/Config.make.in b/Config.make.in
index a2365e4..5a81e44 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -79,6 +79,7 @@ GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN = @GET_RETURNS_U64_IN_SIMPLE_ATTR_OPEN@
 NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
 HAS_FOPS_SENDFILE = @HAS_FOPS_SENDFILE@
 SKIP_SPLICE = @SKIP_SPLICE@
+SKIP_BUFFER_TRIGGERS = @SKIP_BUFFER_TRIGGERS@
 
 
 OCFS_DEBUG = @OCFS_DEBUG@
diff --git a/Makefile b/Makefile
index 8e8b63f..fd34d67 100644
--- a/Makefile
+++ b/Makefile
@@ -37,7 +37,8 @@ KAPI_COMPAT_FILES = \
 	kapi-compat/include/user_path_at.h		\
 	kapi-compat/include/filemap_fdatawait_range.h	\
 	kapi-compat/include/mnt_want_write.h		\
-	kapi-compat/include/hardsect.h
+	kapi-compat/include/hardsect.h			\
+	kapi-compat/include/triggers.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 2826cec..d042f9c 100644
--- a/configure.in
+++ b/configure.in
@@ -429,6 +429,12 @@ OCFS2_CHECK_KERNEL([	bdev_hardsect_size() in blkdev.h], blkdev.h,
  bdev_hardsect_header=hardsect.h, , [static inline int bdev_hardsect_size(struct block_device \*bdev)])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $bdev_hardsect_header"
 
+SKIP_BUFFER_TRIGGERS=
+OCFS2_CHECK_KERNEL([struct jbd2_buffer_trigger_type in jbd2.h], jbd2.h,
+ , SKIP_BUFFER_TRIGGERS=triggers.h, [^struct jbd2_buffer_trigger_type {])
+AC_SUBST(SKIP_BUFFER_TRIGGERS)
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $SKIP_BUFFER_TRIGGERS"
+
 # End kapi_compat checks
 
 # using -include has two advantages:
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index ba2a3ea..1e8fed6 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -118,6 +118,10 @@ ifdef SKIP_SPLICE
 EXTRA_CFLAGS += -DSKIP_SPLICE
 endif
 
+ifdef SKIP_BUFFER_TRIGGERS
+CFLAGS_journal.o += -DSKIP_BUFFER_TRIGGERS
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 67cc5a7..217f30a 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -459,6 +459,7 @@ bail:
 	return status;
 }
 
+#ifndef SKIP_BUFFER_TRIGGERS
 struct ocfs2_triggers {
 	struct jbd2_buffer_trigger_type	ot_triggers;
 	int				ot_offset;
@@ -608,6 +609,7 @@ static struct ocfs2_triggers dl_triggers = {
 	},
 	.ot_offset	= offsetof(struct ocfs2_dx_leaf, dl_check),
 };
+#endif /* SKIP_BUFFER_TRIGGERS */
 
 static int __ocfs2_journal_access(handle_t *handle,
 				  struct ocfs2_caching_info *ci,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index e36bec2..0a7a621 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1017,6 +1017,15 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	brelse(bh);
 	bh = NULL;
 
+#ifdef SKIP_BUFFER_TRIGGERS
+	if(ocfs2_meta_ecc(osb)) {
+		status = -EINVAL;
+		mlog(ML_ERROR, "File system cannot mount volume with the "
+		     "MetaECC feature enabled.\n");
+		goto read_super_error;
+	}
+#endif
+
 	if (!(osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_XATTR))
 		parsed_options.mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
 
diff --git a/kapi-compat/include/triggers.h b/kapi-compat/include/triggers.h
new file mode 100644
index 0000000..d9f3f3f
--- /dev/null
+++ b/kapi-compat/include/triggers.h
@@ -0,0 +1,72 @@
+#ifndef KAPI_TRIGGERS_H
+#define KAPI_TRIGGERS_H
+
+#ifdef SKIP_BUFFER_TRIGGERS
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+
+struct jbd2_buffer_trigger_type {
+	/*
+	 * Fired just before a buffer is written to the journal.
+	 * mapped_data is a mapped buffer that is the frozen data for
+	 * commit.
+	 */
+	void (*t_commit)(struct jbd2_buffer_trigger_type *type,
+			 struct buffer_head *bh, void *mapped_data,
+			 size_t size);
+
+	/*
+	 * Fired during journal abort for dirty buffers that will not be
+	 * committed.
+	 */
+	void (*t_abort)(struct jbd2_buffer_trigger_type *type,
+			struct buffer_head *bh);
+};
+
+struct ocfs2_triggers {
+	struct jbd2_buffer_trigger_type	ot_triggers;
+	int				ot_offset;
+};
+
+#define jbd2_journal_set_triggers(a, b)		do { } while (0)
+
+static struct ocfs2_triggers di_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers eb_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers rb_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers gd_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers db_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers xb_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers dq_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers dr_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+static struct ocfs2_triggers dl_triggers = {
+	.ot_triggers = { .t_commit = NULL, .t_abort = NULL, }, .ot_offset = 0,
+};
+
+#endif
+
+#endif
-- 
1.5.6.5

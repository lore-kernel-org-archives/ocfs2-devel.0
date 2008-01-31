From: Jeff Mahoney <jeffm@suse.com>
Date: Thu Jan 31 12:55:18 2008
Subject: [Ocfs2-devel] [patch 5/5] ocfs2: Add check for type of b_size in
	struct buffer_head
References: <20080131204634.478915000@suse.com>
Message-ID: <20080131204716.022642000@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 SLES10 has a b_size of type u32, not size_t in struct buffer_head. This
 patch adds a check.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 Config.make.in     |    1 +
 configure.in       |    5 +++++
 fs/ocfs2/Makefile  |    4 ++++
 fs/ocfs2/journal.c |    7 ++++++-
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Config.make.in b/Config.make.in
index 98bf410..24740c1 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -77,6 +77,7 @@ AOPS_IS_NOT_CONST = @AOPS_IS_NOT_CONST@
 NO_VECTORIZED_AIO = @NO_VECTORIZED_AIO@
 NO_SPLICE_FROM_PIPE = @NO_SPLICE_FROM_PIPE@
 OLD_BIO_END_IO = @OLD_BIO_END_IO@
+B_SIZE_IS_U32 = @B_SIZE_IS_U32@
 NO_EXPORTFS_HEADER = @NO_EXPORTFS_HEADER@
 WRITEBACK_CONTROL_NO_RANGE_PREFIX = @WRITEBACK_CONTROL_NO_RANGE_PREFIX@
 NO_SYNC_FILE_FLAGS = @NO_SYNC_FILE_FLAGS@
diff --git a/configure.in b/configure.in
index a4b3f0e..c783d4a 100644
--- a/configure.in
+++ b/configure.in
@@ -331,6 +331,11 @@ OCFS2_CHECK_KERNEL([old bio_end_io_t in bio.h], bio.h,
   OLD_BIO_END_IO=yes, , [^typedef int (bio_end_io_t) (struct bio \*, unsigned int, int);])
 AC_SUBST(OLD_BIO_END_IO)
 
+B_SIZE_IS_U32=
+OCFS2_CHECK_KERNEL([b_size is u32 struct buffer_head in buffer_head.h], buffer_head.h,
+ B_SIZE_IS_U32=yes, , [^	u32 b_size;])
+AC_SUBST(B_SIZE_IS_U32)
+
 NO_EXPORTFS_HEADER=
 OCFS2_CHECK_KERNEL([exportfs.h], exportfs.h,
   , NO_EXPORTFS_HEADER=yes, [^struct export_operations {])
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index c8a81c4..af47a25 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -100,6 +100,10 @@ ifdef NO_SPLICE_FROM_PIPE
 EXTRA_CFLAGS += -DNO_SPLICE_FROM_PIPE
 endif
 
+ifdef B_SIZE_IS_U32
+EXTRA_CFLAGS += -DB_SIZE_IS_U32
+endif
+
 ifdef NO_EXPORTFS_HEADER
 EXTRA_CFLAGS += -DNO_EXPORTFS_HEADER
 endif
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 0332505..907a1bf 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -235,7 +235,12 @@ int ocfs2_journal_access(handle_t *handle,
 	BUG_ON(!handle);
 	BUG_ON(!bh);
 
-	mlog_entry("bh->b_blocknr=%llu, type=%d (\"%s\"), bh->b_size = %zu\n",
+	mlog_entry("bh->b_blocknr=%llu, type=%d (\"%s\"), bh->b_size = "
+#ifdef B_SIZE_IS_U32
+		   "%u\n",
+#else
+		   "%zu\n",
+#endif
 		   (unsigned long long)bh->b_blocknr, type,
 		   (type == OCFS2_JOURNAL_ACCESS_CREATE) ?
 		   "OCFS2_JOURNAL_ACCESS_CREATE" :

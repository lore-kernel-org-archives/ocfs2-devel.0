From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed Jan  9 18:00:11 2008
Subject: [Ocfs2-devel] [PATCH 06/30] ocfs2: Include do_sync_mapping_range()
	from mainline
In-Reply-To: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
References: <1199930370-17076-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1199930370-17076-5-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Commit 5b04aa3a64f854244bc40a6f528176ed50b5c4f6 introduced export symbol
do_sync_mapping_range(). This patch allows one to build ocfs2 with kernels
having/not having that change.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Config.make.in                           |    2 +
 Makefile                                 |    3 +-
 configure.in                             |    6 +
 fs/ocfs2/Makefile                        |    6 +
 fs/ocfs2/compat_sync_mapping_range.c     |  157 ++++++++++++++++++++++++++++++
 kapi-compat/include/sync_mapping_range.h |   18 ++++
 6 files changed, 191 insertions(+), 1 deletions(-)
 create mode 100644 fs/ocfs2/compat_sync_mapping_range.c
 create mode 100644 kapi-compat/include/sync_mapping_range.h

diff --git a/Config.make.in b/Config.make.in
index 37412ba..09f02e1 100644
--- a/Config.make.in
+++ b/Config.make.in
@@ -59,6 +59,8 @@ EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
 
 NO_DELAYED_WORK_STRUCT = @NO_DELAYED_WORK_STRUCT@
 
+NO_SYNC_MAPPING_RANGE  = @NO_SYNC_MAPPING_RANGE@
+
 OCFS_DEBUG = @OCFS_DEBUG@
 
 ifneq ($(OCFS_DEBUG),)
diff --git a/Makefile b/Makefile
index b7b86db..3ddb1aa 100644
--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,8 @@ LINUX_INCLUDE_FILES =
 KAPI_COMPAT_FILES = \
 	kapi-compat/include/workqueue.h \
 	kapi-compat/include/compiler.h \
-	kapi-compat/include/highmem.h
+	kapi-compat/include/highmem.h \
+	kapi-compat/include/sync_mapping_range.h
 
 PATCH_FILES =
 
diff --git a/configure.in b/configure.in
index 3d5ee8e..abe848c 100644
--- a/configure.in
+++ b/configure.in
@@ -172,6 +172,12 @@ OCFS2_CHECK_KERNEL([zero_user_page() in highmem.h], highmem.h,
   , highmem_compat_header="highmem.h", [zero_user_page])
 KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $highmem_compat_header"
 
+NO_SYNC_MAPPING_RANGE=
+OCFS2_CHECK_KERNEL([do_sync_mapping_range() in fs.h], fs.h,
+  , NO_SYNC_MAPPING_RANGE=yes, [do_sync_mapping_range(])
+KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS sync_mapping_range.h"
+AC_SUBST(NO_SYNC_MAPPING_RANGE)
+
 # using -include has two advantages:
 #  the source doesn't need to know to include compat headers
 #  the compat header file names don't go through the search path
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 1dc6847..f27b3a1 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -34,6 +34,12 @@ ifdef NO_DELAYED_WORK_STRUCT
 EXTRA_CFLAGS += -DNO_DELAYED_WORK_STRUCT
 endif
 
+COMPAT_SOURCES += compat_sync_mapping_range.c
+ifdef NO_SYNC_MAPPING_RANGE
+SOURCES += compat_sync_mapping_range.c
+EXTRA_CFLAGS += -DNO_SYNC_MAPPING_RANGE
+endif
+
 #
 # Since SUBDIRS means something to kbuild, define them safely.  Do not
 # include trailing slashes.
diff --git a/fs/ocfs2/compat_sync_mapping_range.c b/fs/ocfs2/compat_sync_mapping_range.c
new file mode 100644
index 0000000..839c6a7
--- /dev/null
+++ b/fs/ocfs2/compat_sync_mapping_range.c
@@ -0,0 +1,157 @@
+/*
+ * compat_sync_mapping_range.c
+ *
+ * This code has been copied from mainline linux kernel git commit
+ * e7b34019606ab1dd06196635e931b0c302799228 to allow ocfs2 to build
+ * against older kernels. For license, refer to fs/sync.c in mainline
+ * linux kernel.
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/swap.h>
+#include <linux/writeback.h>
+#include <linux/mpage.h>
+#include <linux/pagemap.h>
+#include <linux/pagevec.h>
+
+/**
+ * wait_on_page_writeback_range - wait for writeback to complete
+ * @mapping:	target address_space
+ * @start:	beginning page index
+ * @end:	ending page index
+ *
+ * Wait for writeback to complete against pages indexed by start->end
+ * inclusive
+ */
+int wait_on_page_writeback_range(struct address_space *mapping,
+				pgoff_t start, pgoff_t end)
+{
+	struct pagevec pvec;
+	int nr_pages;
+	int ret = 0;
+	pgoff_t index;
+
+	if (end < start)
+		return 0;
+
+	pagevec_init(&pvec, 0);
+	index = start;
+	while ((index <= end) &&
+			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			PAGECACHE_TAG_WRITEBACK,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)) != 0) {
+		unsigned i;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/* until radix tree lookup accepts end_index */
+			if (page->index > end)
+				continue;
+
+			wait_on_page_writeback(page);
+			if (PageError(page))
+				ret = -EIO;
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+
+	/* Check for outstanding write errors */
+	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+		ret = -ENOSPC;
+	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+		ret = -EIO;
+
+	return ret;
+}
+
+int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	int ret;
+
+	if (wbc->nr_to_write <= 0)
+		return 0;
+	wbc->for_writepages = 1;
+	if (mapping->a_ops->writepages)
+		ret = mapping->a_ops->writepages(mapping, wbc);
+	else
+		ret = generic_writepages(mapping, wbc);
+	wbc->for_writepages = 0;
+	return ret;
+}
+
+/**
+ * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
+ * @mapping:	address space structure to write
+ * @start:	offset in bytes where the range starts
+ * @end:	offset in bytes where the range ends (inclusive)
+ * @sync_mode:	enable synchronous operation
+ *
+ * Start writeback against all of a mapping's dirty pages that lie
+ * within the byte offsets <start, end> inclusive.
+ *
+ * If sync_mode is WB_SYNC_ALL then this is a "data integrity" operation, as
+ * opposed to a regular memory cleansing writeback.  The difference between
+ * these two operations is that if a dirty page/buffer is encountered, it must
+ * be waited upon, and not just skipped over.
+ */
+int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
+				loff_t end, int sync_mode)
+{
+	int ret;
+	struct writeback_control wbc = {
+		.sync_mode = sync_mode,
+		.nr_to_write = mapping->nrpages * 2,
+		.range_start = start,
+		.range_end = end,
+	};
+
+	if (!mapping_cap_writeback_dirty(mapping))
+		return 0;
+
+	ret = do_writepages(mapping, &wbc);
+	return ret;
+}
+
+/*
+ * `endbyte' is inclusive
+ */
+int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			  loff_t endbyte, unsigned int flags)
+{
+	int ret;
+
+	if (!mapping) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = 0;
+	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
+		ret = wait_on_page_writeback_range(mapping,
+					offset >> PAGE_CACHE_SHIFT,
+					endbyte >> PAGE_CACHE_SHIFT);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (flags & SYNC_FILE_RANGE_WRITE) {
+		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
+						WB_SYNC_NONE);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (flags & SYNC_FILE_RANGE_WAIT_AFTER) {
+		ret = wait_on_page_writeback_range(mapping,
+					offset >> PAGE_CACHE_SHIFT,
+					endbyte >> PAGE_CACHE_SHIFT);
+	}
+out:
+	return ret;
+}
diff --git a/kapi-compat/include/sync_mapping_range.h b/kapi-compat/include/sync_mapping_range.h
new file mode 100644
index 0000000..1ee6f42
--- /dev/null
+++ b/kapi-compat/include/sync_mapping_range.h
@@ -0,0 +1,18 @@
+#ifndef KAPI_SYNC_MAPPING_RANGE_H
+#define KAPI_SYNC_MAPPING_RANGE_H
+
+#ifdef NO_SYNC_MAPPING_RANGE
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/swap.h>
+#include <linux/writeback.h>
+#include <linux/pagemap.h>
+
+int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			  loff_t endbyte, unsigned int flags);
+#endif
+
+#endif
-- 
1.5.2.5

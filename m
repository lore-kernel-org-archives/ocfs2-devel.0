From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 19 Dec 2008 13:54:02 -0800
Subject: [Ocfs2-devel] [PATCH 43/45] ocfs2: Remove JBD compatibility layer
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Message-ID: <1229723644-13630-44-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

JBD2 is fully backwards compatible with JBD and it's been tested enough with
Ocfs2 that we can clean this code up now.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/Kconfig                  |   10 -----
 fs/ocfs2/alloc.c            |    5 ---
 fs/ocfs2/aops.c             |   24 +-----------
 fs/ocfs2/journal.c          |   14 -------
 fs/ocfs2/journal.h          |   11 +-----
 fs/ocfs2/ocfs2_jbd_compat.h |   82 -------------------------------------------
 6 files changed, 3 insertions(+), 143 deletions(-)
 delete mode 100644 fs/ocfs2/ocfs2_jbd_compat.h

diff --git a/fs/Kconfig b/fs/Kconfig
index 3af6024..55dc974 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -258,16 +258,6 @@ config OCFS2_DEBUG_FS
 	  this option for debugging only as it is likely to decrease
 	  performance of the filesystem.
 
-config OCFS2_COMPAT_JBD
-	bool "Use JBD for compatibility"
-	depends on OCFS2_FS
-	default n
-	select JBD
-	help
-	  The ocfs2 filesystem now uses JBD2 for its journalling.  JBD2
-	  is backwards compatible with JBD.  It is safe to say N here.
-	  However, if you really want to use the original JBD, say Y here.
-
 config OCFS2_FS_POSIX_ACL
 	bool "OCFS2 POSIX Access Control Lists"
 	depends on OCFS2_FS
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index e823a27..69d67ab 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -6638,11 +6638,6 @@ static void ocfs2_map_and_dirty_page(struct inode *inode, handle_t *handle,
 		mlog_errno(ret);
 	else if (ocfs2_should_order_data(inode)) {
 		ret = ocfs2_jbd2_file_inode(handle, inode);
-#ifdef CONFIG_OCFS2_COMPAT_JBD
-		ret = walk_page_buffers(handle, page_buffers(page),
-					from, to, &partial,
-					ocfs2_journal_dirty_data);
-#endif
 		if (ret < 0)
 			mlog_errno(ret);
 	}
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index e219f8b..6af79ad 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -474,12 +474,6 @@ handle_t *ocfs2_start_walk_page_trans(struct inode *inode,
 
 	if (ocfs2_should_order_data(inode)) {
 		ret = ocfs2_jbd2_file_inode(handle, inode);
-#ifdef CONFIG_OCFS2_COMPAT_JBD
-		ret = walk_page_buffers(handle,
-					page_buffers(page),
-					from, to, NULL,
-					ocfs2_journal_dirty_data);
-#endif
 		if (ret < 0)
 			mlog_errno(ret);
 	}
@@ -1065,15 +1059,8 @@ static void ocfs2_write_failure(struct inode *inode,
 		tmppage = wc->w_pages[i];
 
 		if (page_has_buffers(tmppage)) {
-			if (ocfs2_should_order_data(inode)) {
+			if (ocfs2_should_order_data(inode))
 				ocfs2_jbd2_file_inode(wc->w_handle, inode);
-#ifdef CONFIG_OCFS2_COMPAT_JBD
-				walk_page_buffers(wc->w_handle,
-						  page_buffers(tmppage),
-						  from, to, NULL,
-						  ocfs2_journal_dirty_data);
-#endif
-			}
 
 			block_commit_write(tmppage, from, to);
 		}
@@ -1912,15 +1899,8 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 		}
 
 		if (page_has_buffers(tmppage)) {
-			if (ocfs2_should_order_data(inode)) {
+			if (ocfs2_should_order_data(inode))
 				ocfs2_jbd2_file_inode(wc->w_handle, inode);
-#ifdef CONFIG_OCFS2_COMPAT_JBD
-				walk_page_buffers(wc->w_handle,
-						  page_buffers(tmppage),
-						  from, to, NULL,
-						  ocfs2_journal_dirty_data);
-#endif
-			}
 			block_commit_write(tmppage, from, to);
 		}
 	}
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 9223bfc..12b62a3 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -434,20 +434,6 @@ int ocfs2_journal_dirty(handle_t *handle,
 	return status;
 }
 
-#ifdef CONFIG_OCFS2_COMPAT_JBD
-int ocfs2_journal_dirty_data(handle_t *handle,
-			     struct buffer_head *bh)
-{
-	int err = journal_dirty_data(handle, bh);
-	if (err)
-		mlog_errno(err);
-	/* TODO: When we can handle it, abort the handle and go RO on
-	 * error here. */
-
-	return err;
-}
-#endif
-
 #define OCFS2_DEFAULT_COMMIT_INTERVAL	(HZ * JBD2_DEFAULT_MAX_COMMIT_AGE)
 
 void ocfs2_set_journal_params(struct ocfs2_super *osb)
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index d4d14e9..8203980 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -27,12 +27,7 @@
 #define OCFS2_JOURNAL_H
 
 #include <linux/fs.h>
-#ifndef CONFIG_OCFS2_COMPAT_JBD
-# include <linux/jbd2.h>
-#else
-# include <linux/jbd.h>
-# include "ocfs2_jbd_compat.h"
-#endif
+#include <linux/jbd2.h>
 
 enum ocfs2_journal_state {
 	OCFS2_JOURNAL_FREE = 0,
@@ -273,10 +268,6 @@ int                  ocfs2_journal_access(handle_t *handle,
  */
 int                  ocfs2_journal_dirty(handle_t *handle,
 					 struct buffer_head *bh);
-#ifdef CONFIG_OCFS2_COMPAT_JBD
-int                  ocfs2_journal_dirty_data(handle_t *handle,
-					      struct buffer_head *bh);
-#endif
 
 /*
  *  Credit Macros:
diff --git a/fs/ocfs2/ocfs2_jbd_compat.h b/fs/ocfs2/ocfs2_jbd_compat.h
deleted file mode 100644
index b91c78f..0000000
--- a/fs/ocfs2/ocfs2_jbd_compat.h
+++ /dev/null
@@ -1,82 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * ocfs2_jbd_compat.h
- *
- * Compatibility defines for JBD.
- *
- * Copyright (C) 2008 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef OCFS2_JBD_COMPAT_H
-#define OCFS2_JBD_COMPAT_H
-
-#ifndef CONFIG_OCFS2_COMPAT_JBD
-# error Should not have been included
-#endif
-
-struct jbd2_inode {
-	unsigned int dummy;
-};
-
-#define JBD2_BARRIER			JFS_BARRIER
-#define JBD2_DEFAULT_MAX_COMMIT_AGE	JBD_DEFAULT_MAX_COMMIT_AGE
-
-#define jbd2_journal_ack_err			journal_ack_err
-#define jbd2_journal_clear_err			journal_clear_err
-#define jbd2_journal_destroy			journal_destroy
-#define jbd2_journal_dirty_metadata		journal_dirty_metadata
-#define jbd2_journal_errno			journal_errno
-#define jbd2_journal_extend			journal_extend
-#define jbd2_journal_flush			journal_flush
-#define jbd2_journal_force_commit		journal_force_commit
-#define jbd2_journal_get_write_access		journal_get_write_access
-#define jbd2_journal_get_undo_access		journal_get_undo_access
-#define jbd2_journal_init_inode			journal_init_inode
-#define jbd2_journal_invalidatepage		journal_invalidatepage
-#define jbd2_journal_load			journal_load
-#define jbd2_journal_lock_updates		journal_lock_updates
-#define jbd2_journal_restart			journal_restart
-#define jbd2_journal_start			journal_start
-#define jbd2_journal_start_commit		journal_start_commit
-#define jbd2_journal_stop			journal_stop
-#define jbd2_journal_try_to_free_buffers	journal_try_to_free_buffers
-#define jbd2_journal_unlock_updates		journal_unlock_updates
-#define jbd2_journal_wipe			journal_wipe
-#define jbd2_log_wait_commit			log_wait_commit
-
-static inline int jbd2_journal_file_inode(handle_t *handle,
-					  struct jbd2_inode *inode)
-{
-	return 0;
-}
-
-static inline int jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode,
-						      loff_t new_size)
-{
-	return 0;
-}
-
-static inline void jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode,
-					       struct inode *inode)
-{
-	return;
-}
-
-static inline void jbd2_journal_release_jbd_inode(journal_t *journal,
-						  struct jbd2_inode *jinode)
-{
-	return;
-}
-
-
-#endif  /* OCFS2_JBD_COMPAT_H */
-- 
1.5.6

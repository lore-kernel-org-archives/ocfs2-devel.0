From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 2 Feb 2015 10:59:57 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] fsck.ocfs2: support append direct io ro
	compat feature
Message-ID: <54CEE82D.5040609@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Support to truncate direct io orphan entry in fsck.ocfs2.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fsck.ocfs2/pass4.c  |  9 +++++++++
 libocfs2/truncate.c | 12 ++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/fsck.ocfs2/pass4.c b/fsck.ocfs2/pass4.c
index 7737cc9..de3f672 100644
--- a/fsck.ocfs2/pass4.c
+++ b/fsck.ocfs2/pass4.c
@@ -100,6 +100,9 @@ out:
 	return;
 }

+#define OCFS2_DIO_ORPHAN_PREFIX "dio-"
+#define OCFS2_DIO_ORPHAN_PREFIX_LEN 4
+
 static int replay_orphan_iterate(struct ocfs2_dir_entry *dirent,
 				 uint64_t blocknr,
 				 int	offset,
@@ -138,6 +141,11 @@ static int replay_orphan_iterate(struct ocfs2_dir_entry *dirent,
 		goto out;
 	}

+	/* do not delete inode in case of dio orphan entry */
+	if (!strncmp(dirent->name, OCFS2_DIO_ORPHAN_PREFIX,
+			OCFS2_DIO_ORPHAN_PREFIX_LEN))
+		goto out_check;
+
 	ret = ocfs2_delete_inode(ost->ost_fs, dirent->inode);
 	if (ret) {
 		com_err(whoami, ret, "while deleting orphan inode %"PRIu64
@@ -148,6 +156,7 @@ static int replay_orphan_iterate(struct ocfs2_dir_entry *dirent,

 	ost->ost_orphan_deleted_count++;

+out_check:
 	/* Only calculate icount in force check. */
 	if (ost->ost_force) {
 		/*
diff --git a/libocfs2/truncate.c b/libocfs2/truncate.c
index 7327253..451db28 100644
--- a/libocfs2/truncate.c
+++ b/libocfs2/truncate.c
@@ -33,6 +33,7 @@
 #include <assert.h>
 #include <errno.h>
 #include "ocfs2/ocfs2.h"
+#include "ocfs2/byteorder.h"

 struct truncate_ctxt {
 	uint64_t ino;
@@ -356,6 +357,16 @@ errcode_t ocfs2_truncate_full(ocfs2_filesys *fs, uint64_t ino,
 	if (ret)
 		goto out;

+	/* in case of dio crashed, force do trucate since blocks may already
+	 * be allocated
+	 */
+	if (ci->ci_inode->i_flags & cpu_to_le32(OCFS2_DIO_ORPHANED_FL)) {
+		ci->ci_inode->i_flags &= ~cpu_to_le32(OCFS2_DIO_ORPHANED_FL);
+		ci->ci_inode->i_dio_orphaned_slot = 0;
+		new_i_size = ci->ci_inode->i_size;
+		goto truncate;
+	}
+
 	if (ci->ci_inode->i_size == new_i_size)
 		goto out;

@@ -364,6 +375,7 @@ errcode_t ocfs2_truncate_full(ocfs2_filesys *fs, uint64_t ino,
 		goto out;
 	}

+truncate:
 	if ((S_ISLNK(ci->ci_inode->i_mode) && !ci->ci_inode->i_clusters) ||
 	    (ci->ci_inode->i_dyn_features & OCFS2_INLINE_DATA_FL))
 		ret = ocfs2_truncate_inline(fs, ino, new_i_size);
-- 
1.8.4.3

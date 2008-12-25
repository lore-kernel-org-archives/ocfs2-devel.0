From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 25 Dec 2008 10:04:21 -0800
Subject: [Ocfs2-devel] [PATCH 06/35] ocfs2: Add journal_access functions
	with jbd2 triggers.
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Message-ID: <1230228290-22803-7-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>

From: Joel Becker <joel.becker@oracle.com>

We create wrappers for ocfs2_journal_access() that are specific to the
type of metadata block.  This allows us to associate jbd2 commit
triggers with the block.  The triggers will compute metadata ecc in a
future commit.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/journal.c |  159 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ocfs2/journal.h |   31 +++++++++--
 2 files changed, 181 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 302f114..2daa584 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -35,6 +35,7 @@
 #include "ocfs2.h"
 
 #include "alloc.h"
+#include "blockcheck.h"
 #include "dir.h"
 #include "dlmglue.h"
 #include "extent_map.h"
@@ -369,10 +370,110 @@ bail:
 	return status;
 }
 
-int ocfs2_journal_access(handle_t *handle,
-			 struct inode *inode,
-			 struct buffer_head *bh,
-			 int type)
+struct ocfs2_triggers {
+	struct jbd2_buffer_trigger_type	ot_triggers;
+	int				ot_offset;
+};
+
+static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
+{
+	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
+}
+
+static void ocfs2_commit_trigger(struct jbd2_buffer_trigger_type *triggers,
+				 struct buffer_head *bh,
+				 void *data, size_t size)
+{
+	struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
+
+	/*
+	 * We aren't guaranteed to have the superblock here, so we
+	 * must unconditionally compute the ecc data.
+	 * __ocfs2_journal_access() will only set the triggers if
+	 * metaecc is enabled.
+	 */
+	ocfs2_block_check_compute(data, size, data + ot->ot_offset);
+}
+
+/*
+ * Quota blocks have their own trigger because the struct ocfs2_block_check
+ * offset depends on the blocksize.
+ */
+static void ocfs2_dq_commit_trigger(struct jbd2_buffer_trigger_type *triggers,
+				 struct buffer_head *bh,
+				 void *data, size_t size)
+{
+	struct ocfs2_disk_dqtrailer *dqt =
+		ocfs2_block_dqtrailer(size, data);
+
+	/*
+	 * We aren't guaranteed to have the superblock here, so we
+	 * must unconditionally compute the ecc data.
+	 * __ocfs2_journal_access() will only set the triggers if
+	 * metaecc is enabled.
+	 */
+	ocfs2_block_check_compute(data, size, &dqt->dq_check);
+}
+
+static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
+				struct buffer_head *bh)
+{
+	mlog(ML_ERROR,
+	     "ocfs2_abort_trigger called by JBD2.  bh = 0x%lx, "
+	     "bh->b_blocknr = %llu\n",
+	     (unsigned long)bh,
+	     (unsigned long long)bh->b_blocknr);
+
+	/* We aren't guaranteed to have the superblock here - but if we
+	 * don't, it'll just crash. */
+	ocfs2_error(bh->b_assoc_map->host->i_sb,
+		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
+}
+
+static struct ocfs2_triggers di_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= offsetof(struct ocfs2_dinode, i_check),
+};
+
+static struct ocfs2_triggers eb_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= offsetof(struct ocfs2_extent_block, h_check),
+};
+
+static struct ocfs2_triggers gd_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= offsetof(struct ocfs2_group_desc, bg_check),
+};
+
+static struct ocfs2_triggers xb_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= offsetof(struct ocfs2_xattr_block, xb_check),
+};
+
+static struct ocfs2_triggers dq_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_dq_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+};
+
+static int __ocfs2_journal_access(handle_t *handle,
+				  struct inode *inode,
+				  struct buffer_head *bh,
+				  struct ocfs2_triggers *triggers,
+				  int type)
 {
 	int status;
 
@@ -418,6 +519,8 @@ int ocfs2_journal_access(handle_t *handle,
 		status = -EINVAL;
 		mlog(ML_ERROR, "Uknown access type!\n");
 	}
+	if (!status && ocfs2_meta_ecc(OCFS2_SB(inode->i_sb)) && triggers)
+		jbd2_journal_set_triggers(bh, &triggers->ot_triggers);
 	mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
 
 	if (status < 0)
@@ -428,6 +531,54 @@ int ocfs2_journal_access(handle_t *handle,
 	return status;
 }
 
+int ocfs2_journal_access_di(handle_t *handle, struct inode *inode,
+			       struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, &di_triggers,
+				      type);
+}
+
+int ocfs2_journal_access_eb(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, &eb_triggers,
+				      type);
+}
+
+int ocfs2_journal_access_gd(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, &gd_triggers,
+				      type);
+}
+
+int ocfs2_journal_access_db(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type)
+{
+	/* Right now, nothing for dirblocks */
+	return __ocfs2_journal_access(handle, inode, bh, NULL, type);
+}
+
+int ocfs2_journal_access_xb(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, &xb_triggers,
+				      type);
+}
+
+int ocfs2_journal_access_dq(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, &dq_triggers,
+				      type);
+}
+
+int ocfs2_journal_access(handle_t *handle, struct inode *inode,
+			 struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, inode, bh, NULL, type);
+}
+
 int ocfs2_journal_dirty(handle_t *handle,
 			struct buffer_head *bh)
 {
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 37013bf..bca370d 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -212,9 +212,12 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
  *  ocfs2_extend_trans     - Extend a handle by nblocks credits. This may
  *                          commit the handle to disk in the process, but will
  *                          not release any locks taken during the transaction.
- *  ocfs2_journal_access   - Notify the handle that we want to journal this
+ *  ocfs2_journal_access* - Notify the handle that we want to journal this
  *                          buffer. Will have to call ocfs2_journal_dirty once
  *                          we've actually dirtied it. Type is one of . or .
+ *                          Always call the specific flavor of
+ *                          ocfs2_journal_access_*() unless you intend to
+ *                          manage the checksum by hand.
  *  ocfs2_journal_dirty    - Mark a journalled buffer as having dirty data.
  *  ocfs2_jbd2_file_inode  - Mark an inode so that its data goes out before
  *                           the current handle commits.
@@ -244,10 +247,28 @@ int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
 #define OCFS2_JOURNAL_ACCESS_WRITE  1
 #define OCFS2_JOURNAL_ACCESS_UNDO   2
 
-int                  ocfs2_journal_access(handle_t *handle,
-					  struct inode *inode,
-					  struct buffer_head *bh,
-					  int type);
+/* ocfs2_inode */
+int ocfs2_journal_access_di(handle_t *handle, struct inode *inode,
+			       struct buffer_head *bh, int type);
+/* ocfs2_extent_block */
+int ocfs2_journal_access_eb(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type);
+/* ocfs2_group_desc */
+int ocfs2_journal_access_gd(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type);
+/* ocfs2_xattr_block */
+int ocfs2_journal_access_xb(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type);
+/* quota blocks */
+int ocfs2_journal_access_dq(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type);
+/* dirblock */
+int ocfs2_journal_access_db(handle_t *handle, struct inode *inode,
+			    struct buffer_head *bh, int type);
+/* Anything that has no ecc */
+int ocfs2_journal_access(handle_t *handle, struct inode *inode,
+			 struct buffer_head *bh, int type);
+
 /*
  * A word about the journal_access/journal_dirty "dance". It is
  * entirely legal to journal_access a buffer more than once (as long
-- 
1.5.6

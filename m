From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:03 +0800
Subject: [Ocfs2-devel] [PATCH 02/41] ocfs2: Add metaecc for
	ocfs2_refcount_block.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add metaecc and journal trigger for ocfs2_refcount_block.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/journal.c |   15 +++++++++++++++
 fs/ocfs2/journal.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 5b6c0e4..54c16b6 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -555,6 +555,14 @@ static struct ocfs2_triggers eb_triggers = {
 	.ot_offset	= offsetof(struct ocfs2_extent_block, h_check),
 };
 
+static struct ocfs2_triggers rb_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= offsetof(struct ocfs2_refcount_block, rf_check),
+};
+
 static struct ocfs2_triggers gd_triggers = {
 	.ot_triggers = {
 		.t_commit = ocfs2_commit_trigger,
@@ -677,6 +685,13 @@ int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 	return __ocfs2_journal_access(handle, ci, bh, &eb_triggers, type);
 }
 
+int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
+			    struct buffer_head *bh, int type)
+{
+	return __ocfs2_journal_access(handle, ci, bh, &rb_triggers,
+				      type);
+}
+
 int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type)
 {
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 6163f28..b2dc125 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -281,6 +281,9 @@ int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
 /* ocfs2_extent_block */
 int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
+/* ocfs2_refcount_block */
+int ocfs2_journal_access_rb(handle_t *handle, struct ocfs2_caching_info *ci,
+			    struct buffer_head *bh, int type);
 /* ocfs2_group_desc */
 int ocfs2_journal_access_gd(handle_t *handle, struct ocfs2_caching_info *ci,
 			    struct buffer_head *bh, int type);
-- 
1.6.2.rc2.16.gf474c

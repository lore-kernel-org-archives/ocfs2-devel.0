From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  3 Apr 2009 07:45:42 +0800
Subject: [Ocfs2-devel] [PATCH 03/42] ocfs2: Add metaecc for
	ocfs2_refcount_block.
In-Reply-To: <49D5CAC2.4010201@oracle.com>
References: <49D5CAC2.4010201@oracle.com>
Message-ID: <1238715981-21488-3-git-send-email-tao.ma@oracle.com>
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
index e2c2d0a..6159cd8 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -467,6 +467,14 @@ static struct ocfs2_triggers eb_triggers = {
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
@@ -575,6 +583,13 @@ int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
 				      type);
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
index 3c08d69..0eef436 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -264,6 +264,9 @@ int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
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

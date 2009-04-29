From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Apr 2009 06:58:14 +0800
Subject: [Ocfs2-devel] [PATCH 02/39] ocfs2: Add metaecc for
	ocfs2_refcount_block.
In-Reply-To: <49F95A79.6040806@oracle.com>
References: <49F95A79.6040806@oracle.com>
Message-ID: <1241045931-24607-2-git-send-email-tao.ma@oracle.com>
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
index 6ae353c..02c5a21 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -551,6 +551,14 @@ static struct ocfs2_triggers eb_triggers = {
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
@@ -673,6 +681,13 @@ int ocfs2_journal_access_eb(handle_t *handle, struct ocfs2_caching_info *ci,
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
index ea22691..08196e0 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -276,6 +276,9 @@ int ocfs2_journal_access_di(handle_t *handle, struct ocfs2_caching_info *ci,
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

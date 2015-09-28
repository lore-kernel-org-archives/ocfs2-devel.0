From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 28 Sep 2015 20:32:06 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: do not include dio entry in case
	of orphan scan
Message-ID: <56093346.5040302@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

dio entry will only do truncate in case of ORPHAN_NEED_TRUNCATE. So do
not include it when doing normal orphan scan to reduce contention.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/journal.c | 15 ++++++++++++---
 fs/ocfs2/namei.c   |  2 --
 fs/ocfs2/namei.h   |  3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index b41056c..bde475f 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -2005,6 +2005,7 @@ struct ocfs2_orphan_filldir_priv {
 	struct dir_context	ctx;
 	struct inode		*head;
 	struct ocfs2_super	*osb;
+	enum ocfs2_orphan_reco_type orphan_reco_type;
 };

 static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
@@ -2020,6 +2021,12 @@ static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
 	if (name_len == 2 && !strncmp("..", name, 2))
 		return 0;

+	/* do not include dio entry in case of orphan scan */
+	if ((p->orphan_reco_type == ORPHAN_NO_NEED_TRUNCATE) &&
+			(!strncmp(name, OCFS2_DIO_ORPHAN_PREFIX,
+			OCFS2_DIO_ORPHAN_PREFIX_LEN)))
+		return 0;
+
 	/* Skip bad inodes so that recovery can continue */
 	iter = ocfs2_iget(p->osb, ino,
 			  OCFS2_FI_FLAG_ORPHAN_RECOVERY, 0);
@@ -2044,14 +2051,16 @@ static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,

 static int ocfs2_queue_orphans(struct ocfs2_super *osb,
 			       int slot,
-			       struct inode **head)
+			       struct inode **head,
+			       enum ocfs2_orphan_reco_type orphan_reco_type)
 {
 	int status;
 	struct inode *orphan_dir_inode = NULL;
 	struct ocfs2_orphan_filldir_priv priv = {
 		.ctx.actor = ocfs2_orphan_filldir,
 		.osb = osb,
-		.head = *head
+		.head = *head,
+		.orphan_reco_type = orphan_reco_type
 	};

 	orphan_dir_inode = ocfs2_get_system_file_inode(osb,
@@ -2154,7 +2163,7 @@ static int ocfs2_recover_orphans(struct ocfs2_super *osb,
 	trace_ocfs2_recover_orphans(slot);

 	ocfs2_mark_recovering_orphan_dir(osb, slot);
-	ret = ocfs2_queue_orphans(osb, slot, &inode);
+	ret = ocfs2_queue_orphans(osb, slot, &inode, orphan_reco_type);
 	ocfs2_clear_recovering_orphan_dir(osb, slot);

 	/* Error here should be noted, but we want to continue with as
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 38b3336..ab428d2 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -106,8 +106,6 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 static void ocfs2_double_unlock(struct inode *inode1, struct inode *inode2);
 /* An orphan dir name is an 8 byte value, printed as a hex string */
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
-#define OCFS2_DIO_ORPHAN_PREFIX "dio-"
-#define OCFS2_DIO_ORPHAN_PREFIX_LEN 4

 static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 				   unsigned int flags)
diff --git a/fs/ocfs2/namei.h b/fs/ocfs2/namei.h
index e173329..1155918 100644
--- a/fs/ocfs2/namei.h
+++ b/fs/ocfs2/namei.h
@@ -26,6 +26,9 @@
 #ifndef OCFS2_NAMEI_H
 #define OCFS2_NAMEI_H

+#define OCFS2_DIO_ORPHAN_PREFIX "dio-"
+#define OCFS2_DIO_ORPHAN_PREFIX_LEN 4
+
 extern const struct inode_operations ocfs2_dir_iops;

 struct dentry *ocfs2_get_parent(struct dentry *child);
-- 
1.8.4.3

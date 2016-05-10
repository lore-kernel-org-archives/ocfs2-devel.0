From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 10 May 2016 12:52:39 -0500
Subject: [Ocfs2-devel] [PATCH 5/5] Fix files when an inode is written in
	file_fix
In-Reply-To: <1462902759-27084-1-git-send-email-rgoldwyn@suse.de>
References: <1462902759-27084-1-git-send-email-rgoldwyn@suse.de>
Message-ID: <1462902759-27084-6-git-send-email-rgoldwyn@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Check that the entriy exists and has been filed for check.
Also perform some code cleanup to remove ocfs2_filecheck_handle_entry()

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/filecheck.c | 41 +++++++++++++++++++++++++----------------
 fs/ocfs2/filecheck.h |  1 +
 fs/ocfs2/sysfs.c     |  2 +-
 3 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 006d521..fc6e183 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -198,22 +198,6 @@ ocfs2_filecheck_handle(struct ocfs2_super *osb,
 	return ret;
 }
 
-static void
-ocfs2_filecheck_handle_entry(struct ocfs2_super *osb,
-			     struct ocfs2_filecheck_entry *entry)
-{
-	if (entry->fe_type == OCFS2_FILECHECK_TYPE_CHK)
-		entry->fe_status = ocfs2_filecheck_handle(osb,
-				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_CHK);
-	else if (entry->fe_type == OCFS2_FILECHECK_TYPE_FIX)
-		entry->fe_status = ocfs2_filecheck_handle(osb,
-				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
-	else
-		entry->fe_status = OCFS2_FILECHECK_ERR_UNSUPPORTED;
-
-	ocfs2_filecheck_done_entry(osb, entry);
-}
-
 int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
 				     unsigned long ino)
 {
@@ -268,3 +252,28 @@ unlock:
 	ocfs2_filecheck_done_entry(osb, entry);
 	return 0;
 }
+
+int ocfs2_filefix_add_inode(struct ocfs2_super *osb,
+				     unsigned long ino)
+{
+	struct ocfs2_filecheck_entry *entry;
+	int ret = -ENOENT;
+
+	spin_lock(&osb->fc_lock);
+	list_for_each_entry(entry, &osb->file_check_entries, fe_list)
+		if (entry->fe_ino == ino) {
+			entry->fe_type = OCFS2_FILECHECK_TYPE_FIX;
+			ret = 0;
+			break;
+		}
+	spin_unlock(&osb->fc_lock);
+	if (ret)
+		return ret;
+
+	entry->fe_status = ocfs2_filecheck_handle(osb,
+			entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
+
+	ocfs2_filecheck_done_entry(osb, entry);
+	return 0;
+}
+
diff --git a/fs/ocfs2/filecheck.h b/fs/ocfs2/filecheck.h
index b1a0d8c..d5f81a7 100644
--- a/fs/ocfs2/filecheck.h
+++ b/fs/ocfs2/filecheck.h
@@ -53,6 +53,7 @@ int ocfs2_filecheck_create_sysfs(struct super_block *sb);
 int ocfs2_filecheck_remove_sysfs(struct super_block *sb);
 int ocfs2_filefix_inode(struct ocfs2_super *osb, unsigned long ino);
 int ocfs2_filecheck_add_inode(struct ocfs2_super *osb, unsigned long ino);
+int ocfs2_filefix_add_inode(struct ocfs2_super *osb, unsigned long ino);
 int ocfs2_filecheck_set_max_entries(struct ocfs2_super *osb, int num);
 int ocfs2_filecheck_show(struct ocfs2_super *osb, unsigned int type, char *buf);
 
diff --git a/fs/ocfs2/sysfs.c b/fs/ocfs2/sysfs.c
index 5632d14..daca819 100644
--- a/fs/ocfs2/sysfs.c
+++ b/fs/ocfs2/sysfs.c
@@ -91,7 +91,7 @@ static ssize_t file_fix_store(struct ocfs2_super *osb,
 	ret = kstrtoul(skip_spaces(buf), 0, &t);
 	if (ret)
 		return ret;
-	ret = ocfs2_filecheck_add_inode(osb, t);
+	ret = ocfs2_filefix_add_inode(osb, t);
 	if (ret)
 		return ret;
 	return count;
-- 
2.6.6

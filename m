From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 25 May 2016 22:10:18 -0500
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Disallow duplicate entries in the
	list
In-Reply-To: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
References: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
Message-ID: <1464232219-12553-5-git-send-email-rgoldwyn@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/ocfs2/filecheck.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 0b41967..006d521 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -217,14 +217,12 @@ ocfs2_filecheck_handle_entry(struct ocfs2_super *osb,
 int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
 				     unsigned long ino)
 {
-	struct ocfs2_filecheck_entry *entry;
+	struct ocfs2_filecheck_entry *entry, *p;
 	ssize_t ret = 0;
 
 	entry = kmalloc(sizeof(struct ocfs2_filecheck_entry), GFP_NOFS);
-	if (!entry) {
-		ret = -ENOMEM;
-		goto exit;
-	}
+	if (!entry)
+		return -ENOMEM;
 
 	spin_lock(&osb->fc_lock);
 	if ((osb->fc_size >= osb->fc_max) &&
@@ -244,6 +242,12 @@ int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
 			 */
 			BUG_ON(!ocfs2_filecheck_erase_entry(osb));
 		}
+		list_for_each_entry(p, &osb->file_check_entries, fe_list)
+			if (p->fe_ino == ino) {
+				ret = -EEXIST;
+				kfree(entry);
+				goto unlock;
+			}
 
 		entry->fe_ino = ino;
 		entry->fe_type = OCFS2_FILECHECK_TYPE_CHK;
@@ -252,11 +256,15 @@ int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
 		list_add_tail(&entry->fe_list, &osb->file_check_entries);
 		osb->fc_size++;
 	}
+unlock:
 	spin_unlock(&osb->fc_lock);
 
-	if (!ret)
-		ocfs2_filecheck_handle_entry(osb, entry);
+	if (ret)
+		return ret;
 
-exit:
-	return ret;
+	entry->fe_status = ocfs2_filecheck_handle(osb,
+			entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_CHK);
+
+	ocfs2_filecheck_done_entry(osb, entry);
+	return 0;
 }
-- 
2.6.6

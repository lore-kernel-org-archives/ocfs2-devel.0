From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 19 13:12:24 2007
Subject: [Ocfs2-devel] [PATCH 10/15] ocfs2: Cleanup dirent size check
Message-ID: <200709192012.l8JKCGOe029334@rgmgw2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The check to see if a new dirent would fit in an old one is pretty ugly, and
it's done at least twice. Clean things up by putting this in it's own
easier-to-read function.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dir.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 31db7e3..4c36eae 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -343,6 +343,31 @@ bail:
 	return status;
 }
 
+/*
+ * Check whether 'de' has enough room to hold an entry of
+ * 'new_rec_len' bytes.
+ */
+static inline int ocfs2_dirent_would_fit(struct ocfs2_dir_entry *de,
+					 unsigned int new_rec_len)
+{
+	unsigned int de_really_needed;
+
+	/* Check whether this is an empty record with enough space */
+	if (le64_to_cpu(de->inode) == 0 &&
+	    le16_to_cpu(de->rec_len) >= new_rec_len)
+		return 1;
+
+	/*
+	 * Record might have free space at the end which we can
+	 * use.
+	 */
+	de_really_needed = OCFS2_DIR_REC_LEN(de->name_len);
+	if (le16_to_cpu(de->rec_len) >= (de_really_needed + new_rec_len))
+	    return 1;
+
+	return 0;
+}
+
 /* we don't always have a dentry for what we want to add, so people
  * like orphan dir can call this instead.
  *
@@ -385,10 +410,8 @@ int __ocfs2_add_entry(handle_t *handle,
 			retval = -EEXIST;
 			goto bail;
 		}
-		if (((le64_to_cpu(de->inode) == 0) &&
-		     (le16_to_cpu(de->rec_len) >= rec_len)) ||
-		    (le16_to_cpu(de->rec_len) >=
-		     (OCFS2_DIR_REC_LEN(de->name_len) + rec_len))) {
+
+		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 			retval = ocfs2_mark_inode_dirty(handle, dir, parent_fe_bh);
 			if (retval < 0) {
@@ -1078,10 +1101,7 @@ int ocfs2_prepare_dir_for_insert(struct ocfs2_super *osb,
 			status = -EEXIST;
 			goto bail;
 		}
-		if (((le64_to_cpu(de->inode) == 0) &&
-		     (le16_to_cpu(de->rec_len) >= rec_len)) ||
-		    (le16_to_cpu(de->rec_len) >=
-		     (OCFS2_DIR_REC_LEN(de->name_len) + rec_len))) {
+		if (ocfs2_dirent_would_fit(de, rec_len)) {
 			/* Ok, we found a spot. Return this bh and let
 			 * the caller actually fill it in. */
 			*ret_de_bh = bh;
-- 
1.5.0.6

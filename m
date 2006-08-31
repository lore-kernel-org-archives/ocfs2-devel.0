From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu Aug 31 19:27:36 2006
Subject: [Ocfs2-devel] a patch for ocfs2_link
Message-ID: <44F79A94.3040101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch remove the redundant "i_nlink >= OCFS2_LINK_MAX" check
and add an unlinked directory check.

Singed-off-by: mfasheh

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 0673862..719a8d2 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -643,11 +643,6 @@ static int ocfs2_link(struct dentry *old
                goto bail;
        }

-       if (inode->i_nlink >= OCFS2_LINK_MAX) {
-               err = -EMLINK;
-               goto bail;
-       }
-
        handle = ocfs2_alloc_handle(osb);
        if (handle == NULL) {
                err = -ENOMEM;
@@ -661,6 +656,11 @@ static int ocfs2_link(struct dentry *old
                goto bail;
        }

+       if (!dir->i_nlink) {
+               err = -ENOENT;
+               goto bail;
+       }
+
        err = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
                                        dentry->d_name.len);
        if (err)

-------------- next part --------------
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 0673862..719a8d2 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -643,11 +643,6 @@ static int ocfs2_link(struct dentry *old
 		goto bail;
 	}
 
-	if (inode->i_nlink >= OCFS2_LINK_MAX) {
-		err = -EMLINK;
-		goto bail;
-	}
-
 	handle = ocfs2_alloc_handle(osb);
 	if (handle == NULL) {
 		err = -ENOMEM;
@@ -661,6 +656,11 @@ static int ocfs2_link(struct dentry *old
 		goto bail;
 	}
 
+	if (!dir->i_nlink) {
+		err = -ENOENT;
+		goto bail;
+	}
+
 	err = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
 					dentry->d_name.len);
 	if (err)

From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Mon, 20 May 2013 10:06:31 -0500
Subject: [Ocfs2-devel] [PATCH] Remove unecessary ERROR when removing
	non-empty directory
Message-ID: <CAJtY7HXOYRsRVKckzAg9V2nBivWwSspk7SJaonqMxWcgqE-m9g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While removing a non-empty directory, the kernel dumps a message:
(rmdir,21743,1):ocfs2_unlink:953 ERROR: status = -39

Suppress the error message from being printed in the dmesg so users
don't panic.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

---
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 04ee1b5..33c7b91 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -947,7 +947,7 @@ leave:
  ocfs2_free_dir_lookup_result(&orphan_insert);
  ocfs2_free_dir_lookup_result(&lookup);

- if (status)
+ if (status && (status != -ENOTEMPTY))
  mlog_errno(status);

  return status;

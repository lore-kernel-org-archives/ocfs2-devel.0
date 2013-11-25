From: Younger Liu <younger.liucn@gmail.com>
Date: Mon, 25 Nov 2013 19:03:15 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2_sync_file() if filesystem is
	readonly
Message-ID: <52932E73.5090902@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


  If filesystem is readonly, there is no need to flush drive's caches
or force any uncommitted transactions.

Signed-off-by: Younger Liu <younger.liucn@gmail.com>
---
 fs/ocfs2/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d54d1bf..618f18f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -185,6 +185,9 @@ static int ocfs2_sync_file(struct file *file, loff_t
start, loff_t end,
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);

+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return 0;
+
 	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (err)
 		return err;
-- 
1.7.9.5

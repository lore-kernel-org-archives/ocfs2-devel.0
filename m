From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Fri, 24 Jan 2014 12:46:59 -0800
Subject: [Ocfs2-devel] [patch 01/11] ocfs2: fix ocfs2_sync_file() if
	filesystem is readonly
Message-ID: <20140124204700.532BA31C1B6@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Younger Liu <younger.liucn@gmail.com>
Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly

If filesystem is readonly, there is no need to flush drive's caches or
force any uncommitted transactions.

Signed-off-by: Younger Liu <younger.liucn@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly
+++ a/fs/ocfs2/file.c
@@ -185,6 +185,9 @@ static int ocfs2_sync_file(struct file *
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return 0;
+
 	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (err)
 		return err;
_

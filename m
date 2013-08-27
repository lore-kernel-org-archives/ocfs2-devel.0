From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:12 -0700
Subject: [Ocfs2-devel] [patch 18/22] ocfs2: free path in
	ocfs2_remove_inode_range()
Message-ID: <20130827210512.887FA31C129@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2: free path in ocfs2_remove_inode_range()

In ocfs2_remove_inode_range(), there is a memory leak.  The variable path
has allocated memory with ocfs2_new_path_from_et(), but it is not free.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/file.c~ocfs2-free-path-in-ocfs2_remove_inode_range fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-free-path-in-ocfs2_remove_inode_range
+++ a/fs/ocfs2/file.c
@@ -1815,6 +1815,7 @@ static int ocfs2_remove_inode_range(stru
 	ocfs2_truncate_cluster_pages(inode, byte_start, byte_len);
 
 out:
+	ocfs2_free_path(path);
 	ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &dealloc);
 
_

From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Tue, 27 Aug 2013 14:05:06 -0700
Subject: [Ocfs2-devel] [patch 13/22] ocfs2: fix a memory leak in
	__ocfs2_move_extents()
Message-ID: <20130827210506.BDC2A31C129@corp2gmr1-1.hot.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: fix a memory leak in __ocfs2_move_extents()

The ocfs2 path is not properly freed which leads to a memory leak at
__ocfs2_move_extents().

This patch stops the leaks of the ocfs2_path structure.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Younger Liu <younger.liu@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ocfs2/move_extents.c~ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents
+++ a/fs/ocfs2/move_extents.c
@@ -152,6 +152,7 @@ static int __ocfs2_move_extent(handle_t
 	}
 
 out:
+	ocfs2_free_path(path);
 	return ret;
 }
 
_

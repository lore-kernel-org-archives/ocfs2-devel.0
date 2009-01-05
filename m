From: Tao Ma <tao.ma@oracle.com>
Date: Mon,  5 Jan 2009 14:45:24 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Access the right buffer_head in
	ocfs2_merge_rec_left.
Message-ID: <1231137924-4779-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In commit "ocfs2: Use metadata-specific ocfs2_journal_access_*()
functions", the wrong buffer_head is accessed. So change it
to the right buffer_head.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 874c0bd..54ff4c7 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3402,8 +3402,8 @@ static int ocfs2_merge_rec_left(struct inode *inode,
 			has_empty_extent = 1;
 	}
 
-	ret = ocfs2_path_bh_journal_access(handle, inode, left_path,
-					   path_num_items(left_path) - 1);
+	ret = ocfs2_path_bh_journal_access(handle, inode, right_path,
+					   path_num_items(right_path) - 1);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
-- 
1.5.5

From: Joel Becker <joel.becker@oracle.com>
Date: Fri, 13 Feb 2009 14:16:20 -0800
Subject: [Ocfs2-devel] [PATCH 33/40] ocfs2: ocfs2_figure_insert_type() no
	longer needs struct inode.
In-Reply-To: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
References: <1234563387-17101-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1234563387-17101-34-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It's not using it, so remove it from the parameter list.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/alloc.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ed0c430..be329a9 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4368,8 +4368,7 @@ set_tail_append:
  * All of the information is stored on the ocfs2_insert_type
  * structure.
  */
-static int ocfs2_figure_insert_type(struct inode *inode,
-				    struct ocfs2_extent_tree *et,
+static int ocfs2_figure_insert_type(struct ocfs2_extent_tree *et,
 				    struct buffer_head **last_eb_bh,
 				    struct ocfs2_extent_rec *insert_rec,
 				    int *free_records,
@@ -4529,7 +4528,7 @@ int ocfs2_insert_extent(struct ocfs2_super *osb,
 		goto bail;
 	}
 
-	status = ocfs2_figure_insert_type(inode, et, &last_eb_bh, &rec,
+	status = ocfs2_figure_insert_type(et, &last_eb_bh, &rec,
 					  &free_records, &insert);
 	if (status < 0) {
 		mlog_errno(status);
-- 
1.5.6.5

From: Tao Ma <tao.ma@oracle.com>
Date: Fri,  9 Jan 2009 07:32:48 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Access and dirty the buffer_head in
	mark_written.
Message-ID: <1231457568-22880-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In __ocfs2_mark_extent_written, when we meet with the situation
of c_split_covers_rec, the old solution just replace the extent
record and forget to access and dirty the buffer_head. This will
cause a problem when the unwritten extent is in an extent block.
So access and dirty it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/alloc.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 54ff4c7..fcffc54 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -4796,6 +4796,29 @@ out:
 	return ret;
 }
 
+static int ocfs2_replace_extent_rec(struct inode *inode,
+				    handle_t *handle,
+				    struct ocfs2_path *path,
+				    struct ocfs2_extent_list *el,
+				    int split_index,
+				    struct ocfs2_extent_rec *split_rec)
+{
+	int ret;
+
+	ret = ocfs2_path_bh_journal_access(handle, inode, path,
+					   path_num_items(path) - 1);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	el->l_recs[split_index] = *split_rec;
+
+	ocfs2_journal_dirty(handle, path_leaf_bh(path));
+out:
+	return ret;
+}
+
 /*
  * Mark part or all of the extent record at split_index in the leaf
  * pointed to by path as written. This removes the unwritten
@@ -4885,7 +4908,9 @@ static int __ocfs2_mark_extent_written(struct inode *inode,
 
 	if (ctxt.c_contig_type == CONTIG_NONE) {
 		if (ctxt.c_split_covers_rec)
-			el->l_recs[split_index] = *split_rec;
+			ret = ocfs2_replace_extent_rec(inode, handle,
+						       path, el,
+						       split_index, split_rec);
 		else
 			ret = ocfs2_split_and_insert(inode, handle, path, et,
 						     &last_eb_bh, split_index,
-- 
1.5.4.GIT

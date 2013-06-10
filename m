From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 10 Jun 2013 14:27:35 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] cannot metex_unlock without mutex_lock in
	ocfs2_remove_btree_range
Message-ID: <51B571D7.1080408@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_remove_btree_range, when calling ocfs2_lock_refcount_tree and
ocfs2_prepare_refcount_change_for_del failed, it goes to out and then
tries to call mutex_unlock without mutex_lock before.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b8a9d87..941e883 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5655,7 +5655,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 					       &ref_tree, NULL);
 		if (ret) {
 			mlog_errno(ret);
-			goto out;
+			goto bail;
 		}

 		ret = ocfs2_prepare_refcount_change_for_del(inode,
@@ -5666,7 +5666,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 							    &extra_blocks);
 		if (ret < 0) {
 			mlog_errno(ret);
-			goto out;
+			goto bail;
 		}
 	}

@@ -5734,7 +5734,7 @@ out_commit:
 	ocfs2_commit_trans(osb, handle);
 out:
 	mutex_unlock(&tl_inode->i_mutex);
-
+bail:
 	if (meta_ac)
 		ocfs2_free_alloc_context(meta_ac);

-- 
1.7.9.7

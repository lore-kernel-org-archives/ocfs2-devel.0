From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 10 Jun 2013 14:30:34 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] should free ref_tree before return in
	ocfs2_remove_btree_range
Message-ID: <51B5728A.4000308@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_remove_btree_range, when ocfs2_reserve_blocks_for_rec_trunc
failed, it should ref_tree before return.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 941e883..17e6bdd 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5674,7 +5674,7 @@ int ocfs2_remove_btree_range(struct inode *inode,
 						 extra_blocks);
 	if (ret) {
 		mlog_errno(ret);
-		return ret;
+		goto bail;
 	}

 	mutex_lock(&tl_inode->i_mutex);
-- 
1.7.9.7

From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 23 Aug 2019 09:09:48 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] fs/ocfs2/dir.c: remove set but not used
	variables
In-Reply-To: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
References: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
Message-ID: <1566522588-63786-4-git-send-email-joseph.qi@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: zhengbin <zhengbin13@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

fs/ocfs2/dir.c: In function ocfs2_dx_dir_transfer_leaf:
fs/ocfs2/dir.c:3653:42: warning: variable new_list set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Changwei Ge <chge@linux.alibaba.com>
---
 fs/ocfs2/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 784426d..bdef72c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3636,7 +3636,7 @@ static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
 	int i, j, num_used;
 	u32 major_hash;
 	struct ocfs2_dx_leaf *orig_dx_leaf, *new_dx_leaf;
-	struct ocfs2_dx_entry_list *orig_list, *new_list, *tmp_list;
+	struct ocfs2_dx_entry_list *orig_list, *tmp_list;
 	struct ocfs2_dx_entry *dx_entry;
 
 	tmp_list = &tmp_dx_leaf->dl_list;
@@ -3645,7 +3645,6 @@ static void ocfs2_dx_dir_transfer_leaf(struct inode *dir, u32 split_hash,
 		orig_dx_leaf = (struct ocfs2_dx_leaf *) orig_dx_leaves[i]->b_data;
 		orig_list = &orig_dx_leaf->dl_list;
 		new_dx_leaf = (struct ocfs2_dx_leaf *) new_dx_leaves[i]->b_data;
-		new_list = &new_dx_leaf->dl_list;
 
 		num_used = le16_to_cpu(orig_list->de_num_used);
 
-- 
1.8.3.1

From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 23 Aug 2019 09:09:47 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] fs/ocfs2/file.c: remove set but not used
	variables
In-Reply-To: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
References: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
Message-ID: <1566522588-63786-3-git-send-email-joseph.qi@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: zhengbin <zhengbin13@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

fs/ocfs2/file.c: In function ocfs2_prepare_inode_for_write:
fs/ocfs2/file.c:2143:9: warning: variable end set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Changwei Ge <chge@linux.alibaba.com>
---
 fs/ocfs2/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index efe9988..2e982db 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2130,7 +2130,6 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = d_inode(dentry);
 	struct buffer_head *di_bh = NULL;
-	loff_t end;
 
 	/*
 	 * We start with a read level meta lock and only jump to an ex
@@ -2194,8 +2193,6 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 			}
 		}
 
-		end = pos + count;
-
 		ret = ocfs2_check_range_for_refcount(inode, pos, count);
 		if (ret == 1) {
 			ocfs2_inode_unlock(inode, meta_level);
-- 
1.8.3.1

From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Fri, 23 Aug 2019 09:09:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] fs/ocfs2/namei.c: remove set but not used
	variables
In-Reply-To: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
References: <1566522588-63786-1-git-send-email-joseph.qi@linux.alibaba.com>
Message-ID: <1566522588-63786-2-git-send-email-joseph.qi@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: zhengbin <zhengbin13@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

fs/ocfs2/namei.c: In function ocfs2_create_inode_in_orphan:
fs/ocfs2/namei.c:2503:23: warning: variable di set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Changwei Ge <chge@linux.alibaba.com>
---
 fs/ocfs2/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6f8e1c4..8ea51cf 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2486,7 +2486,6 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	struct inode *inode = NULL;
 	struct inode *orphan_dir = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
-	struct ocfs2_dinode *di = NULL;
 	handle_t *handle = NULL;
 	char orphan_name[OCFS2_ORPHAN_NAMELEN + 1];
 	struct buffer_head *parent_di_bh = NULL;
@@ -2552,7 +2551,6 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 		goto leave;
 	}
 
-	di = (struct ocfs2_dinode *)new_di_bh->b_data;
 	status = ocfs2_orphan_add(osb, handle, inode, new_di_bh, orphan_name,
 				  &orphan_insert, orphan_dir, false);
 	if (status < 0) {
-- 
1.8.3.1

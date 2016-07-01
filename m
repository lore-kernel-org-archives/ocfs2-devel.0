From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 1 Jul 2016 17:10:02 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove obscure BUG_ON in dlmglue
Message-ID: <5776336A.6030104@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These BUG_ON(!inode) are obscure because we have already used inode to
get osb. And actually we can guarantee here inode is valid in the
context. So we can safely remove them.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/dlmglue.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 1cfa1b6bf..2108960 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1634,7 +1634,6 @@ int ocfs2_create_new_inode_locks(struct inode *inode)
 	int ret;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);

-	BUG_ON(!inode);
 	BUG_ON(!ocfs2_inode_is_new(inode));

 	mlog(0, "Inode %llu\n", (unsigned long long)OCFS2_I(inode)->ip_blkno);
@@ -1677,8 +1676,6 @@ int ocfs2_rw_lock(struct inode *inode, int write)
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);

-	BUG_ON(!inode);
-
 	mlog(0, "inode %llu take %s RW lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
@@ -1721,8 +1718,6 @@ int ocfs2_open_lock(struct inode *inode)
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);

-	BUG_ON(!inode);
-
 	mlog(0, "inode %llu take PRMODE open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno);

@@ -1746,8 +1741,6 @@ int ocfs2_try_open_lock(struct inode *inode, int write)
 	struct ocfs2_lock_res *lockres;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);

-	BUG_ON(!inode);
-
 	mlog(0, "inode %llu try to take %s open lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     write ? "EXMODE" : "PRMODE");
@@ -2325,8 +2318,6 @@ int ocfs2_inode_lock_full_nested(struct inode *inode,
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct buffer_head *local_bh = NULL;

-	BUG_ON(!inode);
-
 	mlog(0, "inode %llu, take %s META lock\n",
 	     (unsigned long long)OCFS2_I(inode)->ip_blkno,
 	     ex ? "EXMODE" : "PRMODE");
-- 
1.8.4.3

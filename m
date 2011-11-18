From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 18 Nov 2011 15:10:39 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Adding d_delete callback function
	ocfs2_dentry_delete
Message-ID: <201111180710.pAI7AZAA009992@acsmt357.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If d_count will become zero, dput() calls the .d_delete callback function,
if it exist, to know if the corresponding file is deleted or to say if we
should remove the in memory dentry. If we should remove the dentry, dput()
calls dentry_kill to free the dentry(and the parents on last ref). Otherwise,
it move the dentry to lrc list to the super block(still holds a ref to
it's parent).

The new added ocfs2_dentry_delete() returns true(Yes, remove the dentry) when
dentry->inode is NULL or the ocfs2_inode_info is with MAYBE_ORPHANED flag.

The problem if we don't have ocfs2_dentry_delete:
Consider the case that we rm a tree from a remote node and the tree(indoes/dentries)
is cached on this node.

dir1
  |--file1

Dentry for file1 is 0 ref(d_count is 0) and dentry for dir1 has 1 ref.
When file1 is remotely removed, dget_dlock/dput are done against the dentry for
file1. And the dput decrement the last ref on the dentry. inode for file1 got
deleted in d_delete(). dentry for file1 is moved to d_sb->s_dentry_lru.
When dir1 is remotely removed, dget_dlock/dput are done against the dentry for
dir1. Before calling d_delete, the d_count is 2, so the inode is not iputed.
Thus untill the inode is removed from memory(by umount or caused by memory
presure), the on disk inode won't get removed.
Though orphan scan job running on this node can remove the disk inode, we should
not depend on it(orphan scan is a bad solution and should be eventually removed).

After adding ocfs2_dentry_delete, dentry for file1 is killed which causes a
decrement on dir1->d_count. So inode for dir1 can then be iputed thus removed
from disk.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/dcache.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e5ba348..283d749 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -531,7 +531,23 @@ out_move:
 	d_move(dentry, target);
 }
 
+static int ocfs2_dentry_delete(const struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct ocfs2_inode_info *oi;
+
+	if (!inode)
+		return 1;
+
+	oi = OCFS2_I(inode);
+	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
+		return 1;
+
+	return 0;
+}
+
 const struct dentry_operations ocfs2_dentry_ops = {
 	.d_revalidate		= ocfs2_dentry_revalidate,
 	.d_iput			= ocfs2_dentry_iput,
+	.d_delete		= ocfs2_dentry_delete,
 };
-- 
1.7.6.4

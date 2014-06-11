From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 11 Jun 2014 15:07:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free inode when i_count becomes zero
Message-ID: <53980026.8050508@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Disk inode deletion may be heavily delayed when one node unlink a file
after the same dentry is freed on another node(say N1) because of
memory shrink but inode is left in memory. This inode can only be freed
while N1 doing the orphan scan work. However, N1 may skip orphan scan
for several times because other nodes may do the work earlier. In our
tests, it may take 1 hour on 4 nodes cluster and this will cause bad
user experience. So We think inode should be freed when i_count becomes
zero to avoid such circumstances.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/inode.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 437de7f..a490bc5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1192,17 +1192,9 @@ void ocfs2_evict_inode(struct inode *inode)
 int ocfs2_drop_inode(struct inode *inode)
 {
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	int res;
-
 	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink, oi->ip_flags);
-
-	if (oi->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)
-		res = 1;
-	else
-		res = generic_drop_inode(inode);
-
-	return res;
+	return 1; 
 }
 
 /*
-- 
1.8.3.4

From: jiangyiwen <jiangyiwen@huawei.com>
Date: Mon, 5 Oct 2015 11:50:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Solve a problem of crossing the
 boundary in updating backups
Message-ID: <5611F380.2050102@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In update_backups func, it exists a problem of crossing the boundary
as follows:
we assume that lun will be resized to 1TB(cluster_size is 32kb),
it will include 0~33554431 cluster, in update_backups func,
it will backup super block in location of 1TB which is the 33554432th
cluster, so the phenomenon of crossing the boundary is happened.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
---
 fs/ocfs2/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index d5da6f6..10ad87b 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -187,7 +187,7 @@ static int update_backups(struct inode * inode, u32 clusters, char *data)
 	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
 		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
 		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
-		if (cluster > clusters)
+		if (cluster >= clusters)
 			break;

 		ret = ocfs2_read_blocks_sync(osb, blkno, 1, &backup);
-- 
1.8.4.3

From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:34 -0700
Subject: [Ocfs2-devel] [patch 18/25] ocfs2: solve a problem of crossing the
 boundary in updating backups
Message-ID: <56f2f8b2.3CfRUirACqGuh43F%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: solve a problem of crossing the boundary in updating backups

In update_backups() there exists a problem of crossing the boundary
as follows:

we assume that lun will be resized to 1TB(cluster_size is 32kb),
it will include 0~33554431 cluster, in update_backups func,
it will backup super block in location of 1TB which is the 33554432th
cluster, so the phenomenon of crossing the boundary happens.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Xue jiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/resize.c~ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups fs/ocfs2/resize.c
--- a/fs/ocfs2/resize.c~ocfs2-solve-a-problem-of-crossing-the-boundary-in-updating-backups
+++ a/fs/ocfs2/resize.c
@@ -196,7 +196,7 @@ static int update_backups(struct inode *
 	for (i = 0; i < OCFS2_MAX_BACKUP_SUPERBLOCKS; i++) {
 		blkno = ocfs2_backup_super_blkno(inode->i_sb, i);
 		cluster = ocfs2_blocks_to_clusters(inode->i_sb, blkno);
-		if (cluster > clusters)
+		if (cluster >= clusters)
 			break;
 
 		ret = ocfs2_read_blocks_sync(osb, blkno, 1, &backup);
_

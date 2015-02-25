From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 25 Feb 2015 17:32:06 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: take inode lock when get clusters
Message-ID: <54ED9696.4090605@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We need take inode lock when calling ocfs2_get_clusters.
And use GFP_NOFS instead of GFP_KERNEL.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 2a618dd..973a636 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -772,10 +772,17 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 		u32 p_cpos = 0;
 		u32 v_cpos = ocfs2_bytes_to_clusters(osb->sb, offset);

+		ret = ocfs2_inode_lock(inode, NULL, 0);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto clean_orphan;
+		}
+
 		ret = ocfs2_get_clusters(inode, v_cpos, &p_cpos,
 				&num_clusters, &ext_flags);
 		if (ret < 0) {
 			mlog_errno(ret);
+			ocfs2_inode_unlock(inode, 0);
 			goto clean_orphan;
 		}

@@ -783,9 +790,11 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,

 		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
 				p_cpos << (osb->s_clustersize_bits - 9),
-				zero_len >> 9, GFP_KERNEL, false);
+				zero_len >> 9, GFP_NOFS, false);
 		if (ret < 0)
 			mlog_errno(ret);
+
+		ocfs2_inode_unlock(inode, 0);
 	}

 clean_orphan:
-- 
1.8.4.3

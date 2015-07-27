From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 27 Jul 2015 11:39:16 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix shift left overflow
Message-ID: <55B5A7E4.6050600@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

cluster pos is defined as u32, when calculate corresponding sector it
should be converted to u64 first, otherwise it may overflow.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/aops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index b57f0c7..b36dcad 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -688,7 +688,7 @@ static int ocfs2_direct_IO_zero_extend(struct ocfs2_super *osb,

 	if (p_cpos && !(ext_flags & OCFS2_EXT_UNWRITTEN)) {
 		u64 s = i_size_read(inode);
-		sector_t sector = (p_cpos << (osb->s_clustersize_bits - 9)) +
+		sector_t sector = ((u64)p_cpos << (osb->s_clustersize_bits - 9)) +
 			(do_div(s, osb->s_clustersize) >> 9);

 		ret = blkdev_issue_zeroout(osb->sb->s_bdev, sector,
@@ -916,7 +916,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 		BUG_ON(!p_cpos || (ext_flags & OCFS2_EXT_UNWRITTEN));

 		ret = blkdev_issue_zeroout(osb->sb->s_bdev,
-				p_cpos << (osb->s_clustersize_bits - 9),
+				(u64)p_cpos << (osb->s_clustersize_bits - 9),
 				zero_len_head >> 9, GFP_NOFS, false);
 		if (ret < 0)
 			mlog_errno(ret);
-- 
1.8.4.3

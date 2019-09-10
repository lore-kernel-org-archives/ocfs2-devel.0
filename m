From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 10 Sep 2019 10:30:46 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: protect get_block with inode cluster
	lock
Message-ID: <20190910173046.27360-1-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Inode cluster lock should be acquired to avoid extent
tree changed by other cluster nodes.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 fs/ocfs2/aops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a4c905d6b575..5ae7253d04b0 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -127,9 +127,15 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
 	int ret = 0;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
+	ret = ocfs2_inode_lock(inode, NULL, 0);
+	if (ret) {
+		mlog_errno(ret);
+		return ret;
+	}
 	down_read(&oi->ip_alloc_sem);
 	ret = ocfs2_get_block(inode, iblock, bh_result, create);
 	up_read(&oi->ip_alloc_sem);
+	ocfs2_inode_unlock(inode, 0);
 
 	return ret;
 }
-- 
2.17.1

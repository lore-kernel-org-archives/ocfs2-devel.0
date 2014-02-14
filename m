From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 14 Feb 2014 10:50:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove unused variable uuid_net_key in
	ocfs2_initialize_super
Message-ID: <52FD848A.9010406@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: joyce.xue <xuejiufei@huawei.com>

Variable uuid_net_key in ocfs2_initialize_super() is not used. Clean
it up.

Signed-off-by: joyce.xue <xuejiufei@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 49d84f8..4b17054 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2077,7 +2077,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 	struct inode *inode = NULL;
 	struct ocfs2_journal *journal;
-	__le32 uuid_net_key;
 	struct ocfs2_super *osb;
 	u64 total_blocks;
 
@@ -2311,8 +2310,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	memcpy(&uuid_net_key, di->id2.i_super.s_uuid, sizeof(uuid_net_key));
-
 	strncpy(osb->vol_label, di->id2.i_super.s_label, 63);
 	osb->vol_label[63] = '\0';
 	osb->root_blkno = le64_to_cpu(di->id2.i_super.s_root_blkno);
-- 1.8.4.3

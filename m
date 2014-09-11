From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 11 Sep 2014 21:33:52 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free vol_lable in ocfs2_delete_osb
Message-ID: <5411A4C0.6010708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

osb->vol_label is malloced in ocfs2_initialize_super but not freed if
error occurs or during umount, thus lead to memory leak.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index c7a89ce..9197e6a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2536,6 +2536,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	kfree(osb->journal);
 	kfree(osb->local_alloc_copy);
 	kfree(osb->uuid_str);
+	kfree(osb->vol_label);
 	ocfs2_put_dlm_debug(osb->osb_dlm_debug);
 	memset(osb, 0, sizeof(struct ocfs2_super));
 }
-- 
1.8.4.3

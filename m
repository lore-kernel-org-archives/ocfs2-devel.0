From: alex chen <alex.chen@huawei.com>
Date: Fri, 22 May 2015 08:28:33 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2net: should remove debugfs in
	o2net_init() out branch
Message-ID: <555E7831.2000403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 56c403a..2d0acd6 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -2204,7 +2204,7 @@ out:
 	kfree(o2net_hand);
 	kfree(o2net_keep_req);
 	kfree(o2net_keep_resp);
-
+	o2net_debugfs_exit();
 	o2quo_exit();
 	return -ENOMEM;
 }
-- 
1.8.4.3

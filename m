From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 11 Sep 2014 21:45:47 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: call o2quo_exit if malloc failed in
	o2net_init
Message-ID: <5411A78B.1060401@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In o2net_init, if malloc failed, it directly returns -ENOMEM.
Then o2quo_exit won't be called in init_o2nm.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Reviewed-by: joyce.xue <xuejiufei@huawei.com>
---
 fs/ocfs2/cluster/tcp.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 681691b..bb84766 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -2113,17 +2113,13 @@ int o2net_init(void)
 	o2quo_init();

 	if (o2net_debugfs_init())
-		return -ENOMEM;
+		goto out;

 	o2net_hand = kzalloc(sizeof(struct o2net_handshake), GFP_KERNEL);
 	o2net_keep_req = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
 	o2net_keep_resp = kzalloc(sizeof(struct o2net_msg), GFP_KERNEL);
-	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp) {
-		kfree(o2net_hand);
-		kfree(o2net_keep_req);
-		kfree(o2net_keep_resp);
-		return -ENOMEM;
-	}
+	if (!o2net_hand || !o2net_keep_req || !o2net_keep_resp)
+		goto out;

 	o2net_hand->protocol_version = cpu_to_be64(O2NET_PROTOCOL_VERSION);
 	o2net_hand->connector_id = cpu_to_be64(1);
@@ -2148,6 +2144,14 @@ int o2net_init(void)
 	}

 	return 0;
+
+out:
+	kfree(o2net_hand);
+	kfree(o2net_keep_req);
+	kfree(o2net_keep_resp);
+
+	o2quo_exit();
+	return -ENOMEM;
 }

 void o2net_exit(void)
-- 
1.8.4.3

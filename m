From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 19 Mar 2014 18:28:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2 : fix type conversion risk when get
	cluster attributes
Message-ID: <53297168.1040302@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In o2nm_cluster, cl_idle_timeout_ms, cl_keepalive_delay_ms, as well as
cl_reconnect_delay_ms, are defined as type of unsigned int. So we should
also use unsigned int in the helper functions.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/cluster/tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2cd2406..b4ab371 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -262,17 +262,17 @@ static void o2net_update_recv_stats(struct
o2net_sock_container *sc)

 #endif /* CONFIG_OCFS2_FS_STATS */

-static inline int o2net_reconnect_delay(void)
+static inline unsigned int o2net_reconnect_delay(void)
 {
 	return o2nm_single_cluster->cl_reconnect_delay_ms;
 }

-static inline int o2net_keepalive_delay(void)
+static inline unsigned int o2net_keepalive_delay(void)
 {
 	return o2nm_single_cluster->cl_keepalive_delay_ms;
 }

-static inline int o2net_idle_timeout(void)
+static inline unsigned int o2net_idle_timeout(void)
 {
 	return o2nm_single_cluster->cl_idle_timeout_ms;
 }
-- 1.8.4.3

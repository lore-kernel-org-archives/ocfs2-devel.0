From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Tue, 17 Feb 2015 16:13:50 +0900
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: remove useless if statement
Message-ID: <20150217071350.GA9568@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

The Local variable "i" in for loop is always less then
O2CB_MAP_STABILIZE_COUNT.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/stack_o2cb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 1724d43..813d726 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -295,8 +295,8 @@ static int o2cb_cluster_check(void)
 		set_bit(node_num, netmap);
 		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
 			return 0;
-		if (i < O2CB_MAP_STABILIZE_COUNT)
-			msleep(1000);
+
+		msleep(1000);
 	}
 
 	printk(KERN_ERR "o2cb: This node could not connect to nodes:");
-- 
1.7.1

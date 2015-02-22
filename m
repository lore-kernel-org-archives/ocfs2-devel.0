From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 23 Feb 2015 08:40:25 +0900
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid a pointless delay in
	o2cb_cluster_check()
Message-ID: <20150222233928.GA4817@devel.8.8.4.4>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@suse.com, akpm@linux-foundation.org
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/stack_o2cb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 1724d43..220cae7 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -295,7 +295,7 @@ static int o2cb_cluster_check(void)
 		set_bit(node_num, netmap);
 		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
 			return 0;
-		if (i < O2CB_MAP_STABILIZE_COUNT)
+		if (i < O2CB_MAP_STABILIZE_COUNT - 1)
 			msleep(1000);
 	}
 
-- 
1.7.1

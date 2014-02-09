From: Rashika Kheria <rashika.kheria@gmail.com>
Date: Sun, 09 Feb 2014 13:17:38 -0000
Subject: [Ocfs2-devel] [PATCH 16/21] fs: Mark function as static in
 ocfs2/cluster/heartbeat.c
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Message-ID: <105d09df399b657f59ede72e355e04a0080b6126.1391949868.git.rashika.kheria@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Joyce <xuejiufei@huawei.com>, Jie Liu <jeff.liu@oracle.com>, Sunil Mushran <sunil.mushran@gmail.com>, Akinobu Mita <akinobu.mita@gmail.com>, Kent Overstreet <kmo@daterainc.com>, Tim Gardner <tim.gardner@canonical.com>, Dong Fang <yp.fangdong@gmail.com>, ocfs2-devel@oss.oracle.com, josh@joshtriplett.org

Mark function as static in ocfs2/cluster/heartbeat.c because it is
not used outside this file.

This eliminates the following warning in ocfs2/cluster/heartbeat.c:
fs/ocfs2/cluster/heartbeat.c:2470:6: warning: no previous prototype for ?o2hb_region_dec_user? [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index bf482df..ca10dec 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2467,7 +2467,7 @@ unlock:
 	return ret;
 }
 
-void o2hb_region_dec_user(const char *region_uuid)
+static void o2hb_region_dec_user(const char *region_uuid)
 {
 	spin_lock(&o2hb_live_lock);
 
-- 
1.7.9.5

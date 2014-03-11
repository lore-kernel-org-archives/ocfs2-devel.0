From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 05:01:32 -0000
Subject: [Ocfs2-devel] [PATCH 08/15] fs/hearbeat: Replace hardcoding of -20
	with MIN_NICE.
In-Reply-To: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
Message-ID: <86b0868b5919c58a3de047205b9adfb5b0a6949b.1394513466.git.yangds.fnst@cn.fujitsu.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, peterz@infradead.org, mingo@kernel.org, tglx@linutronix.de, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, ocfs2-devel@oss.oracle.com, Dong Fang <yp.fangdong@gmail.com>

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: ocfs2-devel at oss.oracle.com
cc: Dong Fang <yp.fangdong@gmail.com>
---
 fs/ocfs2/cluster/heartbeat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index bf482df..7303929 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1107,7 +1107,7 @@ static int o2hb_thread(void *data)
 
 	mlog(ML_HEARTBEAT|ML_KTHREAD, "hb thread running\n");
 
-	set_user_nice(current, -20);
+	set_user_nice(current, MIN_NICE);
 
 	/* Pin node */
 	o2nm_depend_this_node();
-- 
1.8.2.1

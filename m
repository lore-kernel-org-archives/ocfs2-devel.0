From: piaojun <piaojun@huawei.com>
Date: Mon, 10 Oct 2016 17:26:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: clean up useless BUG_ON default
 case in dlm_finalize_reco_handler()
Message-ID: <57FB5EB2.7050002@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The value of 'stage' must be between 1 and 2, so the switch can't reach
the default case.

Signed-off-by: Jun Piao <piaojun@huawei.com>
---
 fs/ocfs2/dlm/dlmrecovery.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index dd5cb8b..74407c6 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2966,8 +2966,6 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
 			spin_unlock(&dlm->spinlock);
 			dlm_kick_recovery_thread(dlm);
 			break;
-		default:
-			BUG();
 	}
 
 	mlog(0, "%s: recovery done, reco master was %u, dead now %u, master now %u\n",
-- 
1.9.5.msysgit.1

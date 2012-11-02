From: Jeff Liu <jeff.liu@oracle.com>
Date: Fri, 02 Nov 2012 23:13:29 +0800
Subject: [Ocfs2-devel] [RESEND_PATCH] OCFS2: submit disk heartbeat bio using
 WRITE_SYNC on behalf of Noboru
Message-ID: <5093E319.4080401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Last year, Noboru once posted a patch to fix OCFS2 unexpected reboot under heavy disk IO, which can be found at:
https://oss.oracle.com/pipermail/ocfs2-devel/2011-December/008438.html

Guru has reproduced this issue and verified that the proposal patch works to fix it.
Could you please accept it? maybe it's better to merge it to stable-kernel.


Thanks,
-Jeff


Signed-off-by: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Acked-by: Tao Ma <tm@tao.ma>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
CC: Srinivas Eeeda <srinivas.eeda@oracle.com>
Reviewd-by: Jie Liu <jeff.liu@oracle.com>
Tested-by: Gurudas Pai <gurudas.pai@oracle.com>

---
 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index f7c648d..567e7af 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -500,7 +500,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE, bio);
+	submit_bio(WRITE_SYNC, bio);
 
 	status = 0;
 bail:
-- 
1.7.9.5

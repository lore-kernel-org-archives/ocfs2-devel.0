From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 30 Aug 2013 10:15:47 +0800
Subject: [Ocfs2-devel] [PATCH RESEND] ocfs2: break useless while loop
Message-ID: <1377828947-12361-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Break the while loop after get the value, or it will waste
cpu time.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Acked-by: Sunil Mushran <sunil.mushran@gmail.com>
---
 fs/ocfs2/dlm/dlmmaster.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 005261c..1fadc39 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -1888,8 +1888,10 @@ ok:
 			 * up nodes that this node contacted */
 			while ((nn = find_next_bit (mle->response_map, O2NM_MAX_NODES,
 						    nn+1)) < O2NM_MAX_NODES) {
-				if (nn != dlm->node_num && nn != assert->node_idx)
+				if (nn != dlm->node_num && nn != assert->node_idx) {
 					master_request = 1;
+					break;
+				}
 			}
 		}
 		mle->master = assert->node_idx;
-- 
1.7.9.5

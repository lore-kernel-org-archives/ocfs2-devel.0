From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 11 Jul 2012 14:49:56 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: break useless while loop
Message-ID: <1341989396-19598-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
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

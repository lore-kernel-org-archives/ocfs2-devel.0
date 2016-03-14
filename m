From: piaojun <piaojun@huawei.com>
Date: Mon, 14 Mar 2016 19:57:07 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix a variable overflow problem in
	dlmdomain.c
Message-ID: <56E6A713.1030604@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In dlm_send_join_cancels(), unsigned int node is assigned -1, this will
lead variable overflow. Although this won't cause any runtime problem,
the code looks a little uncoordinated.

Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
---
 dlm/dlmdomain.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/dlm/dlmdomain.c b/dlm/dlmdomain.c
index 2ee7fe7..61bafa7 100644
--- a/dlm/dlmdomain.c
+++ b/dlm/dlmdomain.c
@@ -1395,8 +1395,7 @@ static int dlm_send_join_cancels(struct dlm_ctxt *dlm,
 				 unsigned long *node_map,
 				 unsigned int map_size)
 {
-	int status, tmpstat;
-	unsigned int node;
+	int status, tmpstat, int node;

 	if (map_size != (BITS_TO_LONGS(O2NM_MAX_NODES) *
 			 sizeof(unsigned long))) {
-- 
1.8.4.3

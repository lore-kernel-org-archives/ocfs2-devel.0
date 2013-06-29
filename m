From: Jeff Liu <jeff.liu@oracle.com>
Date: Sat, 29 Jun 2013 12:01:14 +0800
Subject: [Ocfs2-devel] [RESENT PATCH 3/4] ocfs2: fix a comments typo at
	o2quo_hb_still_up()
Message-ID: <51CE5C0A.7030105@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Jie Liu <jeff.liu@oracle.com>

Fix a comments typo at o2quo_hb_still_up()

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ocfs2/cluster/quorum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index c19897d..1ec141e 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -264,7 +264,7 @@ void o2quo_hb_still_up(u8 node)
 /* This is analogous to hb_up.  as a node's connection comes up we delay the
  * quorum decision until we see it heartbeating.  the hold will be droped in
  * hb_up or hb_down.  it might be perpetuated by con_err until hb_down.  if
- * it's already heartbeating we we might be dropping a hold that conn_up got.
+ * it's already heartbeating we might be dropping a hold that conn_up got.
  * */
 void o2quo_conn_up(u8 node)
 {
-- 
1.7.9.5

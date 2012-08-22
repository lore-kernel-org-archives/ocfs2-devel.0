From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 22 Aug 2012 17:38:54 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: trivial fix a comments typo at
	o2quo_hb_still_up()
Message-ID: <5034A8AE.3040804@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/ocfs2/cluster/quorum.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 8f9cea1..50583d2 100644
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
1.7.4.1

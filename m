From: Zhangyang <zhang.yangB@h3c.com>
Date: Thu, 21 Sep 2017 02:09:33 +0000
Subject: [Ocfs2-devel] [patch] ocfs2: fix qs_holds may could not be zero
Message-ID: <7F50894FD17BEC45AAC26E5BADA6CE330C60F99A@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,



In our test, We fond that , when the network down, qs->qs_holds could not be reduce to zero, it will lead to the node can't do fence.



o2net_idle_timer -> o2quo_conn_err -> qs->qs_holds++, after O2NET_QUORUM_DELAY_MS if qs_holds could be subtract to zero, it could do make_decision.

But if there are many nodes, when one node network down which contains o2net connections may not do o2net_idle_timer at the same time.

So when a o2net_node have done nn->nn_still_up, but the qs_holds is not zero. because the other o2net_node have not done nn->nn_still_up.

So the first o2net_node will do o2net_idle_timer again, and the qs_holds could be add again. And the qs_holds is global variable, so it formed a loop, the node could not do o2quo_make_decision, because of qs_holds never be zero.



I alter the function o2quo_conn_err, take o2quo_set_hold under control of the bit map qs_conn_bm.

Signed-off-by: Yang Zhang <zhang.yangB@h3c.com>
---
fs/ocfs2/cluster/quorum.c | 8 +++++---
1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 3f337e5..0fe531e 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -423,13 +423,15 @@ void o2quo_conn_err(u8 node)
                                     node, qs->qs_connected);
                   clear_bit(node, qs->qs_conn_bm);
+                /*bring set hold within this judgement, in order to avoid qs_hold
+                * could not be zero.
+                */
+                if (test_bit(node, qs->qs_hb_bm))
+                          o2quo_set_hold(qs, node);
         }

                   mlog(0, "node %u, %d total\n", node, qs->qs_connected);

-                 if (test_bit(node, qs->qs_hb_bm))
-                           o2quo_set_hold(qs, node);
-
                   spin_unlock(&qs->qs_lock);
         }
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170921/86286525/attachment.html 

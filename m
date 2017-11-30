From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Thu, 30 Nov 2017 14:24:30 -0800
Subject: [Ocfs2-devel] [patch 07/11] ocfs2: fix qs_holds may could not be
	zero
Message-ID: <5a20851e.upbuwraIKYxYTZhm%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Zhangyang <zhang.yangB@h3c.com>
Subject: ocfs2: fix qs_holds may could not be zero

In our test, We fond that when the network down, qs->qs_holds could not b=
e reduce to zero, it will lead to the node can't do fence.

o2net_idle_timer -> o2quo_conn_err -> qs->qs_holds++, after
O2NET_QUORUM_DE= LAY_MS if qs_holds could be subtract to zero, it could do
make_decision.

But if there are many nodes, when one node network down which contains
o2net connections may not do o2net_idle_timer at the same time.

So when a o2net_node have done nn->nn_still_up, but the qs_holds is not
zero.  because the other o2net_node have not done nn->nn_still_up.  So the
first o2net_node will do o2net_idle_timer again, and the qs_holds could be
add again.  And the qs_holds is global variable, so it formed a loop, the
node could not do o2quo_make_decision, because of qs_holds never be zero.

I alter the function o2quo_conn_err, take o2quo_set_hold under control of
t= he bit map qs_conn_bm.

Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_7F50894FD17BEC45AAC26E5BADA6CE330C60F99A-40H3CMLB12-2DEX.srv.huawei-2D3com.com&d=DwICAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=CYujo6g1PiMEWNoljfzfkpq8GWBXbNNSftl3t-szE9s&s=9JBgEUTtHISAW_NA8cG1Vg9v_7vTHRok4N9hiTmUSHM&e=
Signed-off-by: Yang Zhang <zhang.yangB@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/cluster/quorum.c~ocfs2-fix-qs_holds-may-could-not-be-zero fs/ocfs2/cluster/quorum.c
--- a/fs/ocfs2/cluster/quorum.c~ocfs2-fix-qs_holds-may-could-not-be-zero
+++ a/fs/ocfs2/cluster/quorum.c
@@ -314,13 +314,16 @@ void o2quo_conn_err(u8 node)
 				node, qs->qs_connected);
 
 		clear_bit(node, qs->qs_conn_bm);
+		/*
+		 * Bring set hold within this judgement, in order to avoid
+		 * qs_hold could not be zero.
+		 */
+		if (test_bit(node, qs->qs_hb_bm))
+			o2quo_set_hold(qs, node);
 	}
 
 	mlog(0, "node %u, %d total\n", node, qs->qs_connected);
 
-	if (test_bit(node, qs->qs_hb_bm))
-		o2quo_set_hold(qs, node);
-
 	spin_unlock(&qs->qs_lock);
 }
 
_

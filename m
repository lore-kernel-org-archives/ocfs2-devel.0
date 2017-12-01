From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 1 Dec 2017 01:40:18 +0000
Subject: [Ocfs2-devel] [PATCH resend] renew changelog and title Re: [patch
 07/11] ocfs2: fix qs_holds may could not be zero
References: <5a20851e.upbuwraIKYxYTZhm%akpm@linux-foundation.org>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F3F93B@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,
I helped Yang clean up his changelog and re-send his patch with a 
reworked title.
The Author is still Yang Zhang.

Thanks,
Changwei

Subject: [PATCH] ocfs2/cluster: close a race that fence can't be triggered

When some nodes of cluster face with TCP connection fault, ocfs2 will
pick up a quorum to continue to work and other nodes will be fenced by
resetting host.
In order to decide which node should be fenced, ocfs2 leverages
o2quo_state::qs_holds. If that variable is reduced to zero, then a try
to decide if fence local node is performed.
However, under a specific scenario that local node is not disconnected
from others at the same time, above method has a problem to reduce
::qs_holds to zero.
Because, o2net 90s idle timer corresponding to different nodes is
triggered one after another.

node 2				node 3
90s idle timer elapses
clear ::qs_conn_bm
set hold
				40s is passed
				90 idle timer elapses
				clear ::qs_conn_bm
				set hold
still up timer elapses
clear hold (NOT to zero )
90s idle timer elapses AGAIN
				still up timer elapses.
				clear hold
				still up timer elapses

To solve this issue, a node which has already be evicted from
::qs_conn_bm can't set hold again and again invoked from idle timer.

Signed-off-by: Yang Zhang <zhang.yangB@h3c.com>
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
  fs/ocfs2/cluster/quorum.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 62e8ec619b4c..af2e7473956e 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -314,12 +314,13 @@ void o2quo_conn_err(u8 node)
  				node, qs->qs_connected);

  		clear_bit(node, qs->qs_conn_bm);
+
+		if (test_bit(node, qs->qs_hb_bm))
+			o2quo_set_hold(qs, node);
  	}

  	mlog(0, "node %u, %d total\n", node, qs->qs_connected);

-	if (test_bit(node, qs->qs_hb_bm))
-		o2quo_set_hold(qs, node);

  	spin_unlock(&qs->qs_lock);
  }
-- 
2.11.0

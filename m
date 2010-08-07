From: Julia Lawall <julia@diku.dk>
Date: Sat, 7 Aug 2010 11:09:13 +0200 (CEST)
Subject: [Ocfs2-devel] [PATCH 1/2] fs/ocfs2/dlm: Eliminate update of
 list_for_each_entry loop cursor
Message-ID: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_for_each_entry uses its first argument to move from one element to the
next, so modifying it can break the iteration.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
iterator name list_for_each_entry;
expression x,E;
position p1,p2;
@@

list_for_each_entry at p1(x,...) { <... x =@p2 E ...> }

@@
expression x,E;
position r.p1,r.p2;
statement S;
@@

*x =@p2 E
...
list_for_each_entry at p1(x,...) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
I don't know whether this is the right solution, but it seems plausible
considering the subsequent test on lock.  In any case, setting lock to NULL
and then going back to the top of the loop does not work.

 fs/ocfs2/dlm/dlmrecovery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 9dfaac7..7084a11 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -1792,10 +1792,10 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
 				list_for_each_entry(lock, tmpq, list) {
-					if (lock->ml.cookie != ml->cookie)
+					if (lock->ml.cookie != ml->cookie) {
 						lock = NULL;
-					else
 						break;
+					}
 				}
 				if (lock)
 					break;

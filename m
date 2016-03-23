From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 23 Mar 2016 13:12:54 -0700
Subject: [Ocfs2-devel] [patch 25/25] ocfs2/dlm: move lock to the tail of
 grant queue while doing in-place convert
Message-ID: <56f2f8c6.T/I6hGiWDdw2Uy0U%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: xuejiufei <xuejiufei@huawei.com>
Subject: ocfs2/dlm: move lock to the tail of grant queue while doing in-place convert

We have found a bug when two nodes doing umount one after another.

1) Node 1 migrate a lockres that has 3 locks in grant queue such as
   N2(PR)<->N3(NL)<->N4(PR) to N2.  After migration, lvb of the lock
   N3(NL) and N4(PR) are empty on node 2 because migration target do not
   copy lvb to these two lock.

2) Node 3 want to convert to PR, it can be granted in
   __dlmconvert_master(), and the order of these locks is unchanged.  The
   lvb of the lock N3(PR) on node 2 is copyed from lockres in function
   dlm_update_lvb() while the lvb of lock N4(PR) is still empty.

3) Node 2 want to leave domain, it will migrate this lockres to node 3.
   Then node 2 will trigger the BUG in dlm_prepare_lvb_for_migration()
   when adding the lock N4(PR) to mres with the following message because
   the lvb of mres is already copied from lock N3(PR), but the lvb of lock
   N4(PR) is empty.

"Mismatched lvb in lock cookie=%u:%llu, name=%.*s, node=%u"

[akpm at linux-foundation.org: tweak comment]
Signed-off-by: xuejiufei <xuejiufei@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmconvert.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert fs/ocfs2/dlm/dlmconvert.c
--- a/fs/ocfs2/dlm/dlmconvert.c~ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert
+++ a/fs/ocfs2/dlm/dlmconvert.c
@@ -212,6 +212,12 @@ grant:
 	if (lock->lksb->flags & DLM_LKSB_PUT_LVB)
 		memcpy(res->lvb, lock->lksb->lvb, DLM_LVB_LEN);
 
+	/*
+	 * Move the lock to the tail because it may be the only lock which has
+	 * an invalid lvb.
+	 */
+	list_move_tail(&lock->list, &res->granted);
+
 	status = DLM_NORMAL;
 	*call_ast = 1;
 	goto unlock_exit;
_

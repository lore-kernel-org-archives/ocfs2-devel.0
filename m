From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Wed,  6 Jan 2010 16:34:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead lock
Message-ID: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

there is deadlock possibility in __ocfs2_cluster_lock().
the case is like following.

#in time order
1) node A(the lock owner) is doing an up-convert(UC, PR->EX). it got the lock
but didn't check BUSY flag again.

2) node B requested an UC on the same lock resource. since node A has an EX on
the lockres, a bast is issued and OCFS2_LOCK_BLOCKED flag is set to the lockres
meanting that a DC is should be done. the DC asks for agreement of node A to
release EX. and for now node A refuses that(still in process of getting that
lock:) ).

3) the UC on node A runs into the phrase of checking OCFS2_LOCK_BLOCKED flag and
if it can continue without waiting for any DC. code is:

        if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
            !ocfs2_may_continue_on_blocked_lock(lockres, level)) {

analysis:
the BLOCKED flag is set in 2), and the UC can't continue to get the lock(
ocfs2_may_continue_on_blocked_lock() returns false), so it the DC to finish.

so both UC and DC are waiting for each other --a dead lock.

the deadlock happens when the UC is a PR->EX and there happen to be a DC queued
setting OCFS2_LOCK_BLOCKED flag when the UC checks that flag again.

fix:
fix in this patch is that if the EX lock is got, we don't check OCFS2_LOCK_BLOCKED
flag again. since we have got the EX lock, we don't need to wait for any DC to
finish. and we don't agree to DC the EX lock, so it' can't be DCed. --it's safe.

another solution could be in ocfs2_may_continue_on_blocked_lock().
currently it compares the wanted level and blocking level. we can change that
to check each dlm_lock attached to the lockres and ignore the one for local
then it works. but it's too complex and affects a lot. --give it up.

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e18eadf..269fb47 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1313,6 +1313,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	unsigned long flags;
 	unsigned int gen;
 	int noqueue_attempted = 0;
+	int lock_done = 0;
 
 	mlog_entry_void();
 
@@ -1347,6 +1348,18 @@ again:
 		goto unlock;
 	}
 
+	if (lock_done) {
+		/* cluster lock completed already, don't wait for down-
+		 * convertion to finish.
+		 * if we do, in case another DC happen to be there(not on behalf
+		 * of this lock request), and ocfs2_may_continue_on_blocked_lock()
+		 * returns false(in case we want an EX), we go into deadlock:
+		 * DC is waiting for our release of the EX(check_downconvert())
+		 * and we are waiting for that DC.
+		 */
+		goto update_holders;
+	}
+
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
 	    !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
 		/* is the lock is currently blocked on behalf of
@@ -1414,9 +1427,11 @@ again:
 		catch_signals = 0;
 
 		/* wait for busy to clear and carry on */
+		lock_done = 1;
 		goto again;
 	}
 
+update_holders:
 	/* Ok, if we get here then we're good to go. */
 	ocfs2_inc_holders(lockres, level);
--
1.6.2.5
 

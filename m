From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 Jan 2010 17:59:46 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix __ocfs2_cluster_lock() dead
 lock
In-Reply-To: <20100109180521.GA5148@laptop.oracle.com>
References: <201001060835.o067n0EO000623@rcsinet13.oracle.com>
	<20100107020005.GC20095@mail.oracle.com>
	<20100109180521.GA5148@laptop.oracle.com>
Message-ID: <20100112015946.GE20285@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[Cc'd Mark and Dave]

On Sun, Jan 10, 2010 at 02:05:22AM +0800, Wengang Wang wrote:
> > 2) It sure looks like you're right.
> well, this doesn't sounds like a sob :)

	With good reason, too.  You've got a bug.  Dave Teigland (copied
now) found it while testing with fs/dlm.
	The short description is that you didn't notice the handling of
async -EAGAIN.  Not really your fault, there are no obvious comments.
With o2dlm, you get -EAGAIN from the call to ocfs2_dlm_lock().  That's
safe with your patch.  However, with fs/dlm, EAGAIN comes
asynchronously.  ocfs2_dlm_lock() will return 0.  When the ast fires,
the ast notices the -EAGAIN and clears the locking state for a retry.
In your patch, however, you take the 'lock_done' + !BUSY and immediately
increment the holders - even though the lock hasn't been acquired!
	The fix is pretty simple, though - when lock_done is set, you
know we've at least tried to upconvert.  If the locking level is good,
we know the upconvert succeeded.  We can then go to inc_holders.  I've
attached a new version of your patch that does this.
	I've also modified the patch to reflect that the original
problem you found is actually a livelock, not a deadlock.  And I added a
little comment about the async -EAGAIN.
	I've attached the full patch with my changes.  Dave, please test
my version (the attached one) instead of Wengang's.  Mark, can you do a
sanity check here?
	Here's the diff between your patch and mine:

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 2788b8e..eabe53e 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1313,7 +1313,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
 	unsigned long flags;
 	unsigned int gen;
 	int noqueue_attempted = 0;
-	int lock_done = 0;
+	int lock_attempted = 0;
 
 	mlog_entry_void();
 
@@ -1348,18 +1348,25 @@ again:
 		goto unlock;
 	}
 
-	if (lock_done) {
-		/* cluster lock completed already, don't wait for down-
-		 * convertion to finish.
-		 * if we do, in case another DC happen to be there(not on behalf
-		 * of this lock request), and ocfs2_may_continue_on_blocked_lock()
-		 * returns false(in case we want an EX), we go into deadlock:
-		 * DC is waiting for our release of the EX(check_downconvert())
-		 * and we are waiting for that DC.
+	if (lock_attempted && (lockres->l_level >= level)) {
+		/*
+		 * We've attempted to upconvert, and the lock now has
+		 * a level we can work with.  If we fell through to the
+		 * next checks, we could spin in an upconvert->downconvert
+		 * cycle as other nodes pounded us.  Instead, we jump
+		 * out and let the caller do some work.  If a downconvert
+		 * has come in, it will do its thing as soon as the caller
+		 * is done.
 		 */
 		goto update_holders;
 	}
 
+	/*
+	 * This is either the first pass or our level wasn't good enough.
+	 * Treat both cases as a first pass.
+	 */
+	lock_attempted = 0;
+
 	if (lockres->l_flags & OCFS2_LOCK_BLOCKED &&
 	    !ocfs2_may_continue_on_blocked_lock(lockres, level)) {
 		/* is the lock is currently blocked on behalf of
@@ -1370,6 +1377,13 @@ again:
 	}
 
 	if (level > lockres->l_level) {
+		/*
+		 * If the dlm notifies us of -EAGAIN asynchronously, it
+		 * will have returned 0 from the call to ocfs2_dlm_lock()
+		 * and given us -EAGAIN in the ast.  The ast will clear
+		 * out our state.  We notice that here and return -EAGAIN
+		 * to the caller.
+		 */
 		if (noqueue_attempted > 0) {
 			ret = -EAGAIN;
 			goto unlock;
@@ -1427,7 +1441,7 @@ again:
 		catch_signals = 0;
 
 		/* wait for busy to clear and carry on */
-		lock_done = 1;
+		lock_attempted = 1;
 		goto again;
 	}
 
Joel

-- 

"If you are ever in doubt as to whether or not to kiss a pretty girl, 
 give her the benefit of the doubt"
                                        -Thomas Carlyle

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-fix-__ocfs2_cluster_lock-livelock.patch
Type: text/x-diff
Size: 3646 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100111/1264b243/attachment.bin 

From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 16 Sep 2011 08:42:00 +0800
Subject: [Ocfs2-devel] [PATCH] Wakeup down-convert thread just after
 clearing OCFS2_LOCK_UPCONVERT_FINISHING -v3
In-Reply-To: <4E723412.9060001@oracle.com>
References: <201109150327.p8F3REQA017979@acsmt356.oracle.com>
	<4E7232B0.9080004@oracle.com> <4E723412.9060001@oracle.com>
Message-ID: <20110916004200.GA3433@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

On 11-09-15 10:21, Sunil Mushran wrote:
> http://people.redhat.com/~teigland/make_panic
> 
> This test has been useful in exposing dlmglue issues.
> 
> On 09/15/2011 10:15 AM, Sunil Mushran wrote:
> >I am fine with the kick in recover from dlm error. Not so in cluster lock.
> >We have to be very very sure before meddling with that function. It is
> >a state machine with many hidden gotchas.
> >
> >So is this patch for a bug encountered or just code audit. Also, what kind
> >testing has been done.

Yes, a bug(hang) encountered. After testing and analysis, I found the root cause.
And it's NOT the dlm error case. The hang was fixed by the original patch.
I will email you about the orabug and testcase(pretty easy to reproduce).

I will try http://people.redhat.com/~teigland/make_panic to see if it
can find something.

thanks,
wengang.

> >
> >On 09/14/2011 08:27 PM, Wengang Wang wrote:
> >>When the lockres state UPCONVERT_FINISHING is cleared,
> >>we should wake up the downconvert thread incase that lockres
> >>is in the blocked queue. Currently we are not doing so and thus
> >>are at the mercy of another event waking up the dc thread.
> >>
> >>Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> >>---
> >>   fs/ocfs2/dlmglue.c |    9 ++++++++-
> >>   1 files changed, 8 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> >>index 7642d7c..524bd88 100644
> >>--- a/fs/ocfs2/dlmglue.c
> >>+++ b/fs/ocfs2/dlmglue.c
> >>@@ -1195,6 +1195,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
> >>   						int convert)
> >>   {
> >>   	unsigned long flags;
> >>+	int kick_dc;
> >>
> >>   	spin_lock_irqsave(&lockres->l_lock, flags);
> >>   	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
> >>@@ -1203,9 +1204,12 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
> >>   		lockres->l_action = OCFS2_AST_INVALID;
> >>   	else
> >>   		lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
> >>+	kick_dc = (lockres->l_flags&   OCFS2_LOCK_QUEUED);
> >>   	spin_unlock_irqrestore(&lockres->l_lock, flags);
> >>
> >>   	wake_up(&lockres->l_event);
> >>+	if (kick_dc)
> >>+		ocfs2_wake_downconvert_thread(ocfs2_get_lockres_osb(lockres));
> >>   }
> >>
> >>   /* Note: If we detect another process working on the lock (i.e.,
> >>@@ -1373,6 +1377,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
> >>   	unsigned long flags;
> >>   	unsigned int gen;
> >>   	int noqueue_attempted = 0;
> >>+	int kick_dc;
> >>
> >>   	ocfs2_init_mask_waiter(&mw);
> >>
> >>@@ -1500,8 +1505,10 @@ update_holders:
> >>   	ret = 0;
> >>   unlock:
> >>   	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
> >>-
> >>+	kick_dc = (lockres->l_flags&   OCFS2_LOCK_QUEUED);
> >>   	spin_unlock_irqrestore(&lockres->l_lock, flags);
> >>+	if (kick_dc)
> >>+		ocfs2_wake_downconvert_thread(osb);
> >>   out:
> >>   	/*
> >>   	 * This is helping work around a lock inversion between the page lock
> >
> >_______________________________________________
> >Ocfs2-devel mailing list
> >Ocfs2-devel at oss.oracle.com
> >http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 

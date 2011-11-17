From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 17 Nov 2011 01:33:04 -0800
Subject: [Ocfs2-devel] [PATCH] Wakeup down-convert thread just after
 clearing OCFS2_LOCK_UPCONVERT_FINISHING -v3
In-Reply-To: <201109150327.p8F3REQA017979@acsmt356.oracle.com>
References: <201109150327.p8F3REQA017979@acsmt356.oracle.com>
Message-ID: <20111117093303.GC7319@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Sep 15, 2011 at 11:27:21AM +0800, Wengang Wang wrote:
> When the lockres state UPCONVERT_FINISHING is cleared,
> we should wake up the downconvert thread incase that lockres
> is in the blocked queue. Currently we are not doing so and thus
> are at the mercy of another event waking up the dc thread.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/ocfs2/dlmglue.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index 7642d7c..524bd88 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -1195,6 +1195,7 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
>  						int convert)
>  {
>  	unsigned long flags;
> +	int kick_dc;
>  
>  	spin_lock_irqsave(&lockres->l_lock, flags);
>  	lockres_clear_flags(lockres, OCFS2_LOCK_BUSY);
> @@ -1203,9 +1204,12 @@ static inline void ocfs2_recover_from_dlm_error(struct ocfs2_lock_res *lockres,
>  		lockres->l_action = OCFS2_AST_INVALID;
>  	else
>  		lockres->l_unlock_action = OCFS2_UNLOCK_INVALID;
> +	kick_dc = (lockres->l_flags & OCFS2_LOCK_QUEUED);

	Point 1, you should be checking BLOCKED, which is how we
determine a lock that wants to downconvert.

>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
>  
>  	wake_up(&lockres->l_event);
> +	if (kick_dc)
> +		ocfs2_wake_downconvert_thread(ocfs2_get_lockres_osb(lockres));

	You're waking up the downconvert thread, but you don't know if
it needs it.  You think it *might* need it.  That's not OK in this code.

>  }
>  
>  /* Note: If we detect another process working on the lock (i.e.,
> @@ -1373,6 +1377,7 @@ static int __ocfs2_cluster_lock(struct ocfs2_super *osb,
>  	unsigned long flags;
>  	unsigned int gen;
>  	int noqueue_attempted = 0;
> +	int kick_dc;
>  
>  	ocfs2_init_mask_waiter(&mw);
>  
> @@ -1500,8 +1505,10 @@ update_holders:
>  	ret = 0;
>  unlock:
>  	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
> -
> +	kick_dc = (lockres->l_flags & OCFS2_LOCK_QUEUED);
>  	spin_unlock_irqrestore(&lockres->l_lock, flags);
> +	if (kick_dc)
> +		ocfs2_wake_downconvert_thread(osb);

	Same here.  Frankly, if we were upconverting, the holder is
going to eventually unlock, which will wake the downconvert thread.
That's how the machine works.  See the comment where we set
UPCONVERT_FINISHING.  We want the upconverter to have enough quantum to
get work done.
	You're going to break that, because this thread might want to
get to EX, and it runs before the older thread updates its hold on the
PR.

	Thread 1		Thread 2		Remote
        Asks for PR
	Master grants PR
							Asks for EX,
							setting BLOCKING
							on our node.
	AST sets UPCONVERT
				Asks for EX, sees
				blocking on Remote
				[kicks dc thread]
				clears UPCONVERT
-->
        _cluster_lock wakes,
        clears UPCONVERT,
        increments holders.

The part in [] is what you are changing.  The --> is where the dc thread
can steal the lock before Thread 1 increments the holder count.  We're
right back at the livelock that UPCONVERT_FINISHING was supposed to
prevent.
	I note that Thread 2 can still clear UPCONVERT and be caught by
the dc thread.  But because we're not waking the dc thread, it's a very
unlikely race.  If you wake the dc thread, it's a guaranteed race.
Also, in the current code, while it might race this time around, it
doesn't the next time.  No livelock.
	This is why Sunil said this is a very sensitive state machine.
	Can I get the info on the problem you actually encountered?  I
find it hard to believe the upconverter didn't eventually release his
hold.  That should wake the dc thread.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

			http://www.jlbec.org/
			jlbec at evilplan.org

From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 5 Feb 2010 11:33:13 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Plugs race between the dc thread
	and an unlock ast message
In-Reply-To: <4B6C65F3.8000805@oracle.com>
References: <1265221014-10591-1-git-send-email-sunil.mushran@oracle.com>
	<20100204102729.GA4339@laptop.oracle.com>
	<4B6B21BE.10708@oracle.com> <20100205060148.GA3416@mail.oracle.com>
	<4B6C65F3.8000805@oracle.com>
Message-ID: <20100205193313.GG11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 10:39:47AM -0800, Sunil Mushran wrote:
> Joel Becker wrote:
> >	Why cancel convert?  Why not an actual unlock.  That's what I
> >thought you meant when you proposed the patch.  After all, David's bug
> >was at DLM_LOCK_IV, not NL.
> >	Cancel isn't in play here.  Cancel only happens on the dc
> >thread, and the dc thread has gotten past BUSY.  So the lock isn't busy
> >anymore.  It does downconvert_worker in an unlocked state.  When it
> >comes back to recheck, another thread can't have done a cancel.
> >	That's why I asked about unlink.  Imagine the dc thread is
> >handling a bast while the unlink thread has gotten to clear_inode.
> >Could ocfs2_drop_lock() be racing the downconvert?

Hmm, if busy is being cleared but the downconvert thread is still working on
it, then yes this could be a possibility - ocfs2_drop_lock only really waits
on the busy flag.


> Yes. I forgot the level was IV. So the full fix would be to ensure
> the level is <= NL in the block below. ??
> 
> 
>        /*
>         * How can we block and yet be at NL?  We were trying to upconvert
>         * from NL and got canceled.  The code comes back here, and now
>         * we notice and clear BLOCKING.
>         */
>        if (lockres->l_level == DLM_LOCK_NL) {
>                BUG_ON(lockres->l_ex_holders || lockres->l_ro_holders);
>                lockres->l_blocking = DLM_LOCK_NL;
>                lockres_clear_flags(lockres, OCFS2_LOCK_BLOCKED);
>                spin_unlock_irqrestore(&lockres->l_lock, flags);
>                goto leave;
>        }

I really want to say that we should prevent those two threads from racing in
the first place. How to do that though might be problematic. I'm not sure
simply spinning on OCFS2_LOCK_QUEUED might not be enough - that flag gets
cleared before the ->post_unlock callback...
	--Mark

--
Mark Fasheh

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E638FB1
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Nov 2023 23:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ph61aCmr"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE55221989;
	Thu,  9 Nov 2023 23:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699574283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nVtUe0++z/uMkqi4t3djy4nGdDEtn27q9FxnRHIG5LY=;
	b=Ph61aCmrBZMYCeG6J45zUWb+PKE0knnEEm+9YIyDw2xc1bV89xi+81B/dD/Fp/C2HaCPY+
	Yhz8eRr+Cb/0liDUCLvOvEh/GWEMeVfYp7bQkGui/5EIpygP2zlF1sR3jcwEhfnXJNeF7P
	AMtu6DSxiYDFD2GPGiCaky1U3wp8D2U=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4F649132BE;
	Thu,  9 Nov 2023 23:58:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 7ChRDwtyTWUaZQAAMHmgww
	(envelope-from <ailiop@suse.com>); Thu, 09 Nov 2023 23:58:03 +0000
Date: Fri, 10 Nov 2023 00:58:02 +0100
From: Anthony Iliopoulos <ailiop@suse.com>
To: Srivathsa Dara <srivathsa.d.dara@oracle.com>
Cc: "mark@fasheh.com" <mark@fasheh.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>,
	"joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
	Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Subject: Re: [PATCH] ocfs2: call ocfs2_abort when journal abort
Message-ID: <ZU1yCgOecS4fjdaH@technoir>
References: <20231030120057.928280-1-srivathsa.d.dara@oracle.com>
 <7ABBFC08-4350-4D6C-B740-80DE590F9476@suse.com>
 <MN2PR10MB43491806209E4381F0359573A0AFA@MN2PR10MB4349.namprd10.prod.outlook.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR10MB43491806209E4381F0359573A0AFA@MN2PR10MB4349.namprd10.prod.outlook.com>

On Thu, Nov 09, 2023 at 07:26:16PM +0000, Srivathsa Dara wrote:
> Hi Anthony,
> thanks for the review
> 
> -----Original Message-----
> From: Anthony Iliopoulos <ailiop@suse.com> 
> Sent: Wednesday, November 1, 2023 4:53 AM
> To: Srivathsa Dara <srivathsa.d.dara@oracle.com>
> Cc: mark@fasheh.com; jlbec@evilplan.org; joseph.qi@linux.alibaba.com; 
> Rajesh Sivaramasubramaniom <rajesh.sivaramasubramaniom@oracle.com>; 
> Junxiao Bi <junxiao.bi@oracle.com>; ocfs2-devel@lists.linux.dev
> Subject: Re: [PATCH] ocfs2: call ocfs2_abort when journal abort
> 
> On Mon, Oct 30, 2023 at 12:00:57PM +0000, Srivathsa Dara wrote:
> > From: Ryan Ding <ryan.ding@oracle.com>
> > 
> > 
> > journal can not recover from abort state, so we should take following 
> > action to prevent file system from corruption:
> 
> Could you elaborate on how corruption can occur when the filesystem is
> in this particular state? How could this be reproduced?
> 
> [Srivathsa]: Corruption can occur due to storage failure

How does that failure lead from aborting the journal to causing fs
corruption? What exactly gets corrupted after journal abort? Can you
provide more details and possibly a reproducer on this?

> > 1. change to readonly filesystem when local mount. We can not afford 
> >    further write, so change to RO state is reasonable.
> 
> This is generally the strategy, but unrelated to the code that this commit 
> is touching. The ocfs2_commit_thread() only applies to non-local mounts.
> 
> [Srivathsa]: Yes, you are right, this is only for cluster mode. I will remove 
> all local mount related comments.
> 
> > 2. panic when cluster mount. Because we can not release lock resource in
> >    this state, other node will hung when it require a lock owned by this
> >    node. So panic and remaster is a reasonable choise.
> 
> Panicking is never a reasonable choice :-) Why couldn't a remastering be
> initiated without going through a reboot instead?
> 
> [Srivathsa]: Without reboot, we run into a journal failure, the only option
> is to have fs in read-only mode. Could you suggest any other way to make
> this node release the locks held by it?

Switching to read-only, and self-fencing so that another node will take
over the recovery.

> > ocfs2_abort() will do all the above work.
> > 
> > Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
> > Signed-off-by: Srivathsa Dara <srivathsa.d.dara@oracle.com>
> > ---
> >  fs/ocfs2/journal.c | 27 +++++++++++++++------------
> >  1 file changed, 15 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c index 
> > ce215565d061..6dace475f019 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -14,7 +14,6 @@
> >  #include <linux/kthread.h>
> >  #include <linux/time.h>
> >  #include <linux/random.h>
> > -#include <linux/delay.h>
> >  #include <linux/writeback.h>
> >  
> >  #include <cluster/masklog.h>
> > @@ -2326,7 +2325,7 @@ static int __ocfs2_wait_on_mount(struct 
> > ocfs2_super *osb, int quota)
> >  
> >  static int ocfs2_commit_thread(void *arg)  {
> > -	int status;
> > +	int status = 0;
> >  	struct ocfs2_super *osb = arg;
> >  	struct ocfs2_journal *journal = osb->journal;
> >  
> > @@ -2340,21 +2339,25 @@ static int ocfs2_commit_thread(void *arg)
> >  		wait_event_interruptible(osb->checkpoint_event,
> >  					 atomic_read(&journal->j_num_trans)
> >  					 || kthread_should_stop());
> > +		if (status < 0) {
> > +			/* As we can not terminate by ourself, just enter an
> > +			 * empty loop to wait for stop.
> > +			 */
> > +			continue;
> > +		}
> 
> the above is unnecessary, given that below will induce panic upon failure.
> 
> >  		status = ocfs2_commit_cache(osb);
> >  		if (status < 0) {
> > -			static unsigned long abort_warn_time;
> > -
> > -			/* Warn about this once per minute */
> > -			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
> > -				mlog(ML_ERROR, "status = %d, journal is "
> > -						"already aborted.\n", status);
> >  			/*
> > -			 * After ocfs2_commit_cache() fails, j_num_trans has a
> > -			 * non-zero value.  Sleep here to avoid a busy-wait
> > -			 * loop.
> > +			 * journal can not recover from abort state, there is
> > +			 * no need to keep commit cache. So we should either
> > +			 * change to readonly(local mount) or just panic
> > +			 * (cluster mount).
> 
> commit cache doesn't apply to local mounts.
> 
> > +			 * We should also clear j_num_trans to prevent further
> > +			 * commit.
> 
> that's redundant given that we're about to panic.
> 
> >  			 */
> > -			msleep_interruptible(1000);
> > +			atomic_set(&journal->j_num_trans, 0);
> 
> same here.
> 
> > +			ocfs2_abort(osb->sb, "Detected aborted journal");
> 
> ocfs2_commit_cache returning with an error does not necessarily mean that
> the journal has been aborted; jbd2_journal_flush will return an error for other 
> conditions too, some of which could be recoverable.
> 
> Therefore unconditionally aborting here is not necessarily warranted, and
> presumably this is why the current code is a retry loop.
> 
> [Srivathsa]: Even the journal is not aborted, there is some serious 
> error with the journal, keeping it running at this stage could lead
> to corruption.

How, precisely? Irrespective of the journal state, this should not be
leading to any corruptions, the ocfs2_commit_thread will just keep
unsuccessfully attempting a journal flush. Otherwise there's a bug
somewhere that needs to be directly addressed.

> But even if the journal has been aborted at that point, there's no reason why
> the node cannot self-fence and effectively shutdown the local fs, instead of 
> aborting with a panic.
> 
> [Srivathsa]: By self-fence, did you mean system panic/reboot due 
> to heartbeat loss? If so, that can't be guaranteed that it will happen
> because the storage failure can be intermittent. Even if that happens,
> it will panic or reboot, how effectively it will shutdown the local fs,
> considering the journal is failing?

I mean intentionally stopping the heartbeat and switching to read-only.

> [Srivathsa]: will send a v2 addressing the redundant code.

Apart from the redundant code, I see two separate issues:

- the claim that there is a potential fs corruption bug after a journal
  abort in ocfs2_commit_thread, which needs to be clarified and
  addressed properly.

- the method of handling irrecoverable journal errors.

Regards,
Anthony

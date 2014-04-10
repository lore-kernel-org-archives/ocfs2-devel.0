From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 Apr 2014 15:14:23 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: retry once
 dlm_dispatch_assert_master failed with ENOMEM
In-Reply-To: <5345F0DD.3050800@oracle.com>
References: <5343D3A8.1080302@huawei.com>
	<20140409144459.ffbb36cc9e6c15382d5a2674@linux-foundation.org>
	<5345F0DD.3050800@oracle.com>
Message-ID: <20140410151423.2e8280458f6f5564dcc2aa0a@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 10 Apr 2014 09:16:13 +0800 Wengang <wen.gang.wang@oracle.com> wrote:

> >> @@ -1685,18 +1688,30 @@ int dlm_master_requery_handler(struct o2net_msg *msg, u32 len, void *data,
> >>   
> >>   	hash = dlm_lockid_hash(req->name, req->namelen);
> >>   
> >> +retry:
> >>   	spin_lock(&dlm->spinlock);
> >>   	res = __dlm_lookup_lockres(dlm, req->name, req->namelen, hash);
> >>   	if (res) {
> >>   		spin_lock(&res->spinlock);
> >>   		master = res->owner;
> >>   		if (master == dlm->node_num) {
> >> -			int ret = dlm_dispatch_assert_master(dlm, res,
> >> -							     0, 0, flags);
> >> +			ret = dlm_dispatch_assert_master(dlm, res,
> >> +					0, 0, flags);
> >>   			if (ret < 0) {
> >> -				mlog_errno(-ENOMEM);
> >> -				/* retry!? */
> >> -				BUG();
> >> +				mlog_errno(ret);
> >> +
> >> +				/* ENOMEM returns, retry until
> >> +				 * DISPATCH_ASSERT_RETRY_TIMES reached */
> >> +				if (retries < DISPATCH_ASSERT_RETRY_TIMES) {
> >> +					spin_unlock(&res->spinlock);
> >> +					dlm_lockres_put(res);
> >> +					spin_unlock(&dlm->spinlock);
> >> +					msleep(50);
> >> +					retries++;
> >> +					goto retry;
> >> +				} else {
> >> +					BUG();
> >> +				}
> > urgh, this is not good.  dlm_dispatch_assert_master() uses GFP_ATOMIC
> > and the chances of that failing are relatively high.  The msleep()
> > might save us, but what happens if we cannot get more memory until some
> > writeback occurs to this filesystem?
> >
> > It would be much better to use GFP_KERNEL in
> > dlm_dispatch_assert_master().  That means preallocating the
> > dlm_work_item in the caller before taking the spinlock.
> >
> Though to use GFP_KERNEL is safe, it may block the whole o2cb network 
> message processing(I detailed this in a separated thread).

The code you're proposing can stall for 100ms.  Does GFP_KERNEL ever
take longer than that?

> I think the original GFP_ATOMIC is for that purpose.

Well.  We shouldn't "think" - we should know.  And the way we know is
by adding code comments.  The comments in your proposed patch don't
improve things because they describe "what" the code is doing (which
was obvious anyway) but they do not explain "why".

> So I still persist we find a 
> way to return a EAGAIN-like error code to peer in case of no-mem, and 
> peer retries on receiving the EAGAIN-like error.

There are all sorts of ways around this.  For example, try the
allocation with GFP_ATOMIC|__GFP_NOWARN.  In the very rare case where
this fails, fall back to GFP_KERNEL.  This is probably equivalent to
using GFP_KERNEL|__GFP_HIGH.

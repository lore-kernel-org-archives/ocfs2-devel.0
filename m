From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 20 Jun 2014 15:49:57 -0700
Subject: [Ocfs2-devel] [patch 4/8] ocfs2/dlm: do not purge lockres that
	is queued for	assert master
In-Reply-To: <20140620153346.173373af4f00a7b5286c8663@linux-foundation.org>
References: <20140609200403.6A34D31C75B@corp2gmr1-1.hot.corp.google.com>
	<20140613213144.GM5484@wotan.suse.de> <539E47DD.3070002@huawei.com>
	<20140620153346.173373af4f00a7b5286c8663@linux-foundation.org>
Message-ID: <20140620224957.GT5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 20, 2014 at 03:33:46PM -0700, Andrew Morton wrote:
> On Mon, 16 Jun 2014 09:26:53 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:
> 
> > >>  		spin_unlock(&res->spinlock);
> > >> diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master fs/ocfs2/dlm/dlmthread.c
> > >> --- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-dlm-do-not-purge-lockres-that-is-queued-for-assert-master
> > >> +++ a/fs/ocfs2/dlm/dlmthread.c
> > >> @@ -259,11 +259,14 @@ static void dlm_run_purge_list(struct dl
> > >>  		 * refs on it. */
> > >>  		unused = __dlm_lockres_unused(lockres);
> > >>  		if (!unused ||
> > >> -		    (lockres->state & DLM_LOCK_RES_MIGRATING)) {
> > >> +		    (lockres->state & DLM_LOCK_RES_MIGRATING) ||
> > >> +		    (lockres->inflight_assert_workers != 0)) {
> > > 
> > > If there's any assert master message we will halt purging *all* lock
> > > resources. That seems extreme to me :/
> > > 
> > Not halt purging *all* lock resource, when one lockres is queued for
> > master assert, it will be moved to the tail of the purge list, so
> > dlm_thread can keep purging other lock resources.
> 
> Where are we up to with this one?

I read the code wrong, Xue is correct:

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

Thanks,
	--Mark


--
Mark Fasheh

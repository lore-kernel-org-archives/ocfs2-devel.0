From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 16 Jun 2014 15:06:44 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: fix misuse of	list_move_tail()
	in dlm_run_purge_list()
In-Reply-To: <539E4671.7000002@huawei.com>
References: <539AA7A5.8030607@huawei.com> <20140613211642.GI5484@wotan.suse.de>
	<539E4671.7000002@huawei.com>
Message-ID: <20140616220644.GP5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 16, 2014 at 09:20:49AM +0800, Xue jiufei wrote:
> On 2014/6/14 5:16, Mark Fasheh wrote:
> > On Fri, Jun 13, 2014 at 03:26:29PM +0800, Xue jiufei wrote:
> >> When a lockres in purge list but is still in use, it should be moved to
> >> the tail of purge list. dlm_thread will continue to check next lockres
> >> in purge list. However, code list_move_tail(&dlm->purge_list,
> >> &lockres->purge) will do *no* movements, so dlm_thread will purge the
> >> same lockres in this loop again and again. If it is in use for a long
> >> time, other lockres will not be processed.
> >>
> >> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> >> Signed-off-by: joyce.xue <xuejiufei@huawei.com>
> >> ---
> >>  fs/ocfs2/dlm/dlmthread.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
> >> index 9db869d..ce017de 100644
> >> --- a/fs/ocfs2/dlm/dlmthread.c
> >> +++ b/fs/ocfs2/dlm/dlmthread.c
> >> @@ -264,7 +264,7 @@ static void dlm_run_purge_list(struct dlm_ctxt *dlm,
> >>  			     "used %d, state %d\n", dlm->name,
> >>  			     lockres->lockname.len, lockres->lockname.name,
> >>  			     !unused, lockres->state);
> >> -			list_move_tail(&dlm->purge_list, &lockres->purge);
> >> +			list_move_tail(&lockres->purge, dlm->purge_list);
> > 
> > Erf, good catch!
> > 
> > But this wants to be:
> > 
> > list_move_tail(&lockres->purge, &dlm->purge_list);
> >                                ^^^^
> >                     Notice the extra '&'
> > 
> > correct?
> > 	--Mark
> > 
> Yes, my mistake. I have already sent the version two. 
> Would you please review it? thank you.

No problem, you should've gotten my signoff on the fixed patch already.
	--Mark

--
Mark Fasheh

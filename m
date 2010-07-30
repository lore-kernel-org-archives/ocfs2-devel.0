From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 30 Jul 2010 23:08:36 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove potential deadlock -V3
In-Reply-To: <04A823D0-EA74-4893-ABD0-816DA589CE16@oracle.com>
References: <201007301354.o6U6jmZS027892@rcsinet13.oracle.com>
	<04A823D0-EA74-4893-ABD0-816DA589CE16@oracle.com>
Message-ID: <20100730150836.GA3442@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-07-30 07:45, Sunil Mushran wrote:
> You can also remove the comment that talks about the put. 

Yes, I should.

regards,
wengang.
> 
> On Jul 30, 2010, at 6:53 AM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> 
> > When we need to take both dlm_domain_lock and dlm->spinlock, we should take
> > them in order of: dlm_domain_lock then dlm->spinlock.
> > 
> > There is pathes disobey this order. That is calling dlm_lockres_put() with
> > dlm->spinlock held in dlm_run_purge_list. dlm_lockres_put() calls dlm_put() at
> > the ref and dlm_put() locks on dlm_domain_lock.
> > 
> > Fix:
> > Don't grab/put the dlm when the initialising/releasing lockres.
> > That grab is not required because we don't call dlm_unregister_domain()
> > based on refcount.
> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> > fs/ocfs2/dlm/dlmmaster.c |    3 ---
> > 1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> > index 94b97fc..8408465 100644
> > --- a/fs/ocfs2/dlm/dlmmaster.c
> > +++ b/fs/ocfs2/dlm/dlmmaster.c
> > @@ -511,8 +511,6 @@ static void dlm_lockres_release(struct kref *kref)
> > 
> >    atomic_dec(&dlm->res_cur_count);
> > 
> > -    dlm_put(dlm);
> > -
> >    if (!hlist_unhashed(&res->hash_node) ||
> >        !list_empty(&res->granted) ||
> >        !list_empty(&res->converting) ||
> > @@ -586,7 +584,6 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
> >    res->inflight_locks = 0;
> > 
> >    /* put in dlm_lockres_release */
> > -    dlm_grab(dlm);
> >    res->dlm = dlm;
> > 
> >    kref_init(&res->refs);
> > -- 
> > 1.7.1.1
> > 
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel

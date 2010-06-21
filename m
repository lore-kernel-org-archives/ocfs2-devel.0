From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 21 Jun 2010 21:44:44 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: remove potential deadlock
In-Reply-To: <4C1F15B6.9030007@oracle.com>
References: <201006160654.o5G1s1E0006164@acsinet15.oracle.com>
	<20100621053139.GA2809@laptop.us.oracle.com>
	<4C1F15B6.9030007@oracle.com>
Message-ID: <20100621134444.GA3581@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-21 15:33, Tao Ma wrote:
> hi wengang,
> 
> On 06/21/2010 01:31 PM, Wengang Wang wrote:
> >Why atomic operations on dlm_refs need spinlock's protect?
> >
> >         /* NOTE: Next three are protected by dlm_domain_lock */
> >         struct kref dlm_refs;
> >         enum dlm_ctxt_state dlm_state;
> >         unsigned int num_joins;
> I don't dive into the code, so if there is something wrong, please
> correct me.
> AFAICS, kref_put isn't an atomic operation, it need to call release
> to free the container of kref.

Yes, it's bad :-(.

regards,
wengang.
> 
> Regards,
> Tao
> >
> >regards,
> >wengang.
> >
> >On 10-06-16 14:52, Wengang Wang wrote:
> >>When we need to take both dlm_domain_lock and dlm->spinlock, we should take
> >>them in order of:
> >>dlm_domain_lock then dlm->spinlock.
> >>
> >>There is pathes disobey this order. That is calling dlm_lockres_put with dlm->
> >>spinlock held. dlm_lockres_put() finally calls dlm_put() which take
> >>dlm_domain_lock.
> >>
> >>The fix is moving the locking on dlm_domain_lock to dlm_ctxt_release() from
> >>dlm_put(). dlm_ctxt_release() is only called on the release of the last
> >>reference. Any path should not be holding dlm->spinlock when dropping the "last"
> >>reference.
> >>
> >>Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> >>---
> >>  fs/ocfs2/dlm/dlmdomain.c |   12 ++++--------
> >>  1 files changed, 4 insertions(+), 8 deletions(-)
> >>
> >>diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> >>index ab82add..754baf2 100644
> >>--- a/fs/ocfs2/dlm/dlmdomain.c
> >>+++ b/fs/ocfs2/dlm/dlmdomain.c
> >>@@ -321,28 +321,24 @@ static void dlm_ctxt_release(struct kref *kref)
> >>
> >>  	dlm = container_of(kref, struct dlm_ctxt, dlm_refs);
> >>
> >>+	if (spin_is_locked(&dlm->spinlock))
> >>+		BUG();
> >>  	BUG_ON(dlm->num_joins);
> >>  	BUG_ON(dlm->dlm_state == DLM_CTXT_JOINED);
> >>
> >>+	spin_lock(&dlm_domain_lock);
> >>  	/* we may still be in the list if we hit an error during join. */
> >>  	list_del_init(&dlm->list);
> >>-
> >>  	spin_unlock(&dlm_domain_lock);
> >>
> >>-	mlog(0, "freeing memory from domain %s\n", dlm->name);
> >>-
> >>  	wake_up(&dlm_domain_events);
> >>-
> >>+	mlog(0, "freeing memory from domain %s\n", dlm->name);
> >>  	dlm_free_ctxt_mem(dlm);
> >>-
> >>-	spin_lock(&dlm_domain_lock);
> >>  }
> >>
> >>  void dlm_put(struct dlm_ctxt *dlm)
> >>  {
> >>-	spin_lock(&dlm_domain_lock);
> >>  	kref_put(&dlm->dlm_refs, dlm_ctxt_release);
> >>-	spin_unlock(&dlm_domain_lock);
> >>  }
> >>
> >>  static void __dlm_get(struct dlm_ctxt *dlm)
> >>--
> >>1.6.6.1
> >>
> >>
> >>_______________________________________________
> >>Ocfs2-devel mailing list
> >>Ocfs2-devel at oss.oracle.com
> >>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
> >_______________________________________________
> >Ocfs2-devel mailing list
> >Ocfs2-devel at oss.oracle.com
> >http://oss.oracle.com/mailman/listinfo/ocfs2-devel

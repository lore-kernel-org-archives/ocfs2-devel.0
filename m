From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Fri, 3 May 2013 18:05:18 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix possible memory leak in
	dlm_process_recovery_data
In-Reply-To: <51845E3D.7070701@huawei.com>
References: <51826292.2000001@huawei.com>
	<CAEeiSHXWZgBNaX_zqdFT94eRLfaWFPxgWtF3bM_=QEk9wKsWHA@mail.gmail.com>
	<51845E3D.7070701@huawei.com>
Message-ID: <CAEeiSHXLczfqeq4CAd6Br7xxVCA7GEohHku4J0zA8KhQ_Wi1+w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Any reason we cannot add the existence check to before the create and thus
skip creation altogether.


On Fri, May 3, 2013 at 6:02 PM, Joseph Qi <joseph.qi@huawei.com> wrote:

> Please consider the belowing case:
> dlm_migrate_all_locks -> dlm_empty_lockres -> dlm_migrate_lockres ->
> dlm_send_one_lockres, if we have already sent some locks, say
> DLM_MAX_MIGRATABLE_LOCKS for the first time, and then
> dlm_send_mig_lockres_msg failed because of network down, it will redo
> it. During the redo_bucket, the lockres can be hashed and migrated
> again.
>
> On 2013/5/3 1:19, Sunil Mushran wrote:
> > Do you know under what conditions does it create a new lock when it
> > should not?
> >
> > This code should only trigger if the lockres is/was mastered on another
> > node.
> > Meaning this node will not know about the newlock. Meaning that code
> should
> > never trigger.
> >
> > 1949                         if (lock->ml.cookie == ml->cookie) {
> > This if looks hacky.
> >
> > If you have a reproducible case, it may be worthwhile to get some traces
> > to see
> > under what conditions this happens. Should be straight forward after
> that.
> >
> > Thanks
> > Sunil
> >
> >
> >
> > On Thu, May 2, 2013 at 5:56 AM, Joseph Qi <joseph.qi@huawei.com
> > <mailto:joseph.qi@huawei.com>> wrote:
> >
> >     We found a possible memory leak in dlm_process_recovery_data when
> doing
> >     code review. In dlm_process_recovery_data, it creates newlock each
> time,
> >     but don't free when it is bad, and then it will lead to memory leak.
> >
> >     Cc: stable at vger.kernel.org <mailto:stable@vger.kernel.org>
> >     Signed-off-by: Joseph Qi <joseph.qi@huawei.com> <mailto:
> joseph.qi at huawei.com>
> >     Reviewed-by: Jie Liu <jeff.liu@oracle.com> <mailto:
> jeff.liu at oracle.com>
> >
> >     ---
> >      fs/ocfs2/dlm/dlmrecovery.c |    4 ++++
> >      1 file changed, 4 insertions(+)
> >
> >     diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> >     index eeac97b..9f08523 100644
> >     --- a/fs/ocfs2/dlm/dlmrecovery.c
> >     +++ b/fs/ocfs2/dlm/dlmrecovery.c
> >     @@ -1974,6 +1974,10 @@ skip_lvb:
> >                            res->lockname.len, res->lockname.name <
> http://lockname.name>, ml->node);
> >                       dlm_lockres_set_refmap_bit(dlm, res, ml->node);
> >                       added++;
> >     +         } else {
> >     +                 /* Free the new lock if it is bad */
> >     +                 dlm_lock_put(newlock);
> >     +                 newlock = NULL;
> >               }
> >               spin_unlock(&res->spinlock);
> >       }
> >     --
> >     1.7.9.7
> >
> >
> >     _______________________________________________
> >     Ocfs2-devel mailing list
> >     Ocfs2-devel at oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
> >     https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
> >
>
>
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130503/cdfbfd0c/attachment.html 

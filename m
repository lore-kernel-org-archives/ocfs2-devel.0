From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 8 May 2013 13:23:58 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock rw lock if inode lock failed
In-Reply-To: <20130508123858.f22b8a5157f09f9014e34e25@linux-foundation.org>
References: <5187C19B.4040708@huawei.com>
	<20130508123858.f22b8a5157f09f9014e34e25@linux-foundation.org>
Message-ID: <CAEeiSHXpS9mqYEyAU2B7aWSUdPoKOh_LYxjdTOE5-_GTv3b8Gw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It should almost never trigger. ocfs2_inode_lock() should always succeed and
only return after it has gotten the required lock.


On Wed, May 8, 2013 at 12:38 PM, Andrew Morton <akpm@linux-foundation.org>wrote:

> On Mon, 6 May 2013 22:43:39 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:
>
> > In ocfs2_file_aio_write, it does ocfs2_rw_lock first and then
> > ocfs2_inode_lock. But if ocfs2_inode_lock failed, it goes to out_sems
> > without unlocking rw lock. This will cause a bug in ocfs2_lock_res_free
> > when testing res->l_ex_holders, which is increased in
> > __ocfs2_cluster_lock and decreased in __ocfs2_cluster_unlock.
> >
> > ...
> >
> > --- a/fs/ocfs2/file.c
> > +++ b/fs/ocfs2/file.c
> > @@ -2290,7 +2290,7 @@ relock:
> >               ret = ocfs2_inode_lock(inode, NULL, 1);
> >               if (ret < 0) {
> >                       mlog_errno(ret);
> > -                     goto out_sems;
> > +                     goto out;
> >               }
> >
> >               ocfs2_inode_unlock(inode, 1);
>
> That seems like a fairly serious bug.  How long has it been there and
> what userspace actions are required to trigger it?
>
> (I'm trying to work out which kernel versions we should merge the
> fix into, but the changelog didn't give me enough info to determine
> this)
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130508/4ec622c9/attachment.html 

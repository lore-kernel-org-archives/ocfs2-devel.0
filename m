From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Fri, 13 Mar 2015 20:14:39 +0900
Subject: [Ocfs2-devel] [PATCH 1/4 V2] ocfs2: use retval instead of
	status for checking error
In-Reply-To: <55029CBF.5060400@nod.at>
References: <20150227234840.GA12922@devel.8.8.4.4>
	<CAHb8M2AMPhDwMjgvrT=igUCcCH4CgRHid9683kSjFAWHnpNQZw@mail.gmail.com>
	<55029CBF.5060400@nod.at>
Message-ID: <CAHb8M2DrDWzAj2Fc+3OYzVFPd85YkYQH_gzonZmavdQRHZG2OA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Richard.

Thanks for reply.
Ok. I will keep trying to set the environment for verifying my paches.
But, before I said, it takes some time... Setting this filesystem in my
machine with qemu is too hard for me. :(

Regards,
Daeseok Youn.

2015. 3. 13. ?? 5:16? "Richard Weinberger" <richard@nod.at>?? ??:
>
> Am 13.03.2015 um 04:59 schrieb DaeSeok Youn:
> > Hi,
> >
> > This patch have been pending for 2 weeks.
> > Do I need to check other things?
> >
> > please, check for me.
>
> I cannot speak for OCFS2 folks. But maybe you can give them a
> better feeling if you proof that your patch is tested.
>
> Thanks,
> //richard
>
> > Thanks!
> >
> > regards,
> > Daeseok Youn
> >
> > 2015-02-28 8:48 GMT+09:00 Daeseok Youn <daeseok.youn@gmail.com>:
> >> The use of 'status' in __ocfs2_add_entry() can return wrong
> >> status when some functions are failed.
> >>
> >> If ocfs2_journal_access_db() in __ocfs2_add_entry() is failed,
> >> that status is saved to 'status' but return variable is 'retval'
> >> which is saved 'success' status. In case of this,  __ocfs2_add_entry()
> >> is failed but can be returned as 'success'.
> >>
> >> So replace 'status' with 'retval'.
> >>
> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> >> ---
> >> V2 : update changelog
> >>
> >>  fs/ocfs2/dir.c |   12 ++++++------
> >>  1 files changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> >> index b08050b..1478a50 100644
> >> --- a/fs/ocfs2/dir.c
> >> +++ b/fs/ocfs2/dir.c
> >> @@ -1617,7 +1617,7 @@ int __ocfs2_add_entry(handle_t *handle,
> >>         struct ocfs2_dir_entry *de, *de1;
> >>         struct ocfs2_dinode *di = (struct ocfs2_dinode
*)parent_fe_bh->b_data;
> >>         struct super_block *sb = dir->i_sb;
> >> -       int retval, status;
> >> +       int retval;
> >>         unsigned int size = sb->s_blocksize;
> >>         struct buffer_head *insert_bh = lookup->dl_leaf_bh;
> >>         char *data_start = insert_bh->b_data;
> >> @@ -1695,22 +1695,22 @@ int __ocfs2_add_entry(handle_t *handle,
> >>                         }
> >>
> >>                         if (insert_bh == parent_fe_bh)
> >> -                               status =
ocfs2_journal_access_di(handle,
> >> +                               retval =
ocfs2_journal_access_di(handle,
> >>
INODE_CACHE(dir),
> >>
insert_bh,
> >>
OCFS2_JOURNAL_ACCESS_WRITE);
> >>                         else {
> >> -                               status =
ocfs2_journal_access_db(handle,
> >> +                               retval =
ocfs2_journal_access_db(handle,
> >>
INODE_CACHE(dir),
> >>
insert_bh,
> >>
 OCFS2_JOURNAL_ACCESS_WRITE);
> >>
> >>                                 if (ocfs2_dir_indexed(dir)) {
> >> -                                       status =
ocfs2_dx_dir_insert(dir,
> >> +                                       retval =
ocfs2_dx_dir_insert(dir,
> >>                                                                 handle,
> >>
 lookup);
> >> -                                       if (status) {
> >> -                                               mlog_errno(status);
> >> +                                       if (retval) {
> >> +                                               mlog_errno(retval);
> >>                                                 goto bail;
> >>                                         }
> >>                                 }
> >> --
> >> 1.7.1
> >>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150313/7c2e5ba8/attachment.html 

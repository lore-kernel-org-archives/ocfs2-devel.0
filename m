From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Fri, 28 Jun 2013 15:15:02 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: should call
 ocfs2_journal_access_di() before ocfs2_delete_entry() in ocfs2_orphan_del()
In-Reply-To: <20130628134948.0c822060ccb324debbd1a16d@linux-foundation.org>
References: <51C3012F.3010408@huawei.com>
	<20130628134948.0c822060ccb324debbd1a16d@linux-foundation.org>
Message-ID: <CAEeiSHVOUxyg4fKAmtqCBsGghkbk0-X52RRF2=StdgMww-tN7g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

NAK. Current code looks ok.


On Fri, Jun 28, 2013 at 1:49 PM, Andrew Morton <akpm@linux-foundation.org>wrote:

>
> Folks, 3.10 is nigh.  Could we please have some review and test of this
> patch?
>
>
> From: Younger Liu <younger.liu@huawei.com>
> Subject: ocfs2: should call ocfs2_journal_access_di() before
> ocfs2_delete_entry() in ocfs2_orphan_del()
>
> While deleting a file into orphan dir in ocfs2_orphan_del(), it calls
> ocfs2_delete_entry() before ocfs2_journal_access_di().  If
> ocfs2_delete_entry() succeeded and ocfs2_journal_access_di() failed, there
> would be a inconsistency: the file is deleted from orphan dir, but orphan
> dir dinode is not updated.
>
> So we need to call ocfs2_journal_access_di() before ocfs2_orphan_del().
>
> Signed-off-by: Younger Liu <younger.liu@huawei.com>
> Cc: Jie Liu <jeff.liu@oracle.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/ocfs2/namei.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff -puN
> fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del
> fs/ocfs2/namei.c
> ---
> a/fs/ocfs2/namei.c~ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del
> +++ a/fs/ocfs2/namei.c
> @@ -2095,17 +2095,17 @@ int ocfs2_orphan_del(struct ocfs2_super
>                 goto leave;
>         }
>
> -       /* remove it from the orphan directory */
> -       status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
> +       status = ocfs2_journal_access_di(handle,
> +                                        INODE_CACHE(orphan_dir_inode),
> +                                        orphan_dir_bh,
> +                                        OCFS2_JOURNAL_ACCESS_WRITE);
>         if (status < 0) {
>                 mlog_errno(status);
>                 goto leave;
>         }
>
> -       status = ocfs2_journal_access_di(handle,
> -                                        INODE_CACHE(orphan_dir_inode),
> -                                        orphan_dir_bh,
> -                                        OCFS2_JOURNAL_ACCESS_WRITE);
> +       /* remove it from the orphan directory */
> +       status = ocfs2_delete_entry(handle, orphan_dir_inode, &lookup);
>         if (status < 0) {
>                 mlog_errno(status);
>                 goto leave;
> _
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130628/4c0a2f05/attachment-0001.html 

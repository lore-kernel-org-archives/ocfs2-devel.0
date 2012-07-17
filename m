From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Tue, 17 Jul 2012 12:49:10 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix dlm lock migration crash
In-Reply-To: <1342509026-6170-1-git-send-email-junxiao.bi@oracle.com>
References: <1342509026-6170-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <CAEeiSHVKM7TK0u4Cd_JWVY9Z8bKj3326ay2RG5dqi4z9fXPaHQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 17, 2012 at 12:10 AM, Junxiao Bi <junxiao.bi@oracle.com> wrote:

> In the target node of the dlm lock migration, the logic to find
> the local dlm lock is wrong, it shouldn't change the loop variable
> "lock" in the list_for_each_entry loop. This will cause a NULL-pointer
> accessing crash.
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: stable at vger.kernel.org
> ---
>  fs/ocfs2/dlm/dlmrecovery.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 01ebfd0..0b9cc88 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1762,6 +1762,7 @@ static int dlm_process_recovery_data(struct dlm_ctxt
> *dlm,
>         u8 from = O2NM_MAX_NODES;
>         unsigned int added = 0;
>         __be64 c;
> +       int found;
>
>         mlog(0, "running %d locks for this lockres\n", mres->num_locks);
>         for (i=0; i<mres->num_locks; i++) {
> @@ -1793,22 +1794,23 @@ static int dlm_process_recovery_data(struct
> dlm_ctxt *dlm,
>                         /* MIGRATION ONLY! */
>                         BUG_ON(!(mres->flags & DLM_MRES_MIGRATION));
>
> +                       found = 0;
>                         spin_lock(&res->spinlock);
>                         for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST;
> j++) {
>                                 tmpq = dlm_list_idx_to_ptr(res, j);
>                                 list_for_each_entry(lock, tmpq, list) {
> -                                       if (lock->ml.cookie != ml->cookie)
> -                                               lock = NULL;
> -                                       else
> +                                       if (lock->ml.cookie == ml->cookie)
> {
> +                                               found = 1;
>                                                 break;
> +                                       }
>                                 }
> -                               if (lock)
> +                               if (found)
>                                         break;
>                         }
>
>                         /* lock is always created locally first, and
>                          * destroyed locally last.  it must be on the list
> */
> -                       if (!lock) {
> +                       if (!found) {
>                                 c = ml->cookie;
>                                 mlog(ML_ERROR, "Could not find local lock "
>                                                "with cookie %u:%llu, node
> %u, "
>


https://oss.oracle.com/git/?p=smushran/linux-2.6.git;a=blobdiff;f=fs/ocfs2/dlm/dlmrecovery.c;h=c881be6043a8c27c26ee44d217fb8ecf1eb37e02;hp=01ebfd0bdad72264b99345378f0c6febe246503d;hb=13279667cc8bbaf901591dee96f762d4aab8b307;hpb=a5ae0116eb56ec7c128e84fe15646a5cb9a8cb47

We had decided to go back to list_for_each().
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120717/56e846cb/attachment.html 

From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 22 May 2013 15:46:21 -0700
Subject: [Ocfs2-devel] [PATCH] clean up duplicate declaration in
	dlmrecovery.c
In-Reply-To: <5199EE8C.5050808@huawei.com>
References: <5199EE8C.5050808@huawei.com>
Message-ID: <CAEeiSHVgh+vA+6XjQ4NmgjXfm3YC021qRjqfbHezV9Y3oud7Hg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Sunil Mushran <sunil.mushran@gmail.com>


On Mon, May 20, 2013 at 2:36 AM, Joseph Qi <joseph.qi@huawei.com> wrote:

> Below 3 functions have already been declared in dlmcommon.h, so we have
> no need to declare them again in dlmrecovery.c.
> dlm_complete_recovery_thread
> dlm_launch_recovery_thread
> dlm_kick_recovery_thread
>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>
> ---
>  fs/ocfs2/dlm/dlmrecovery.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 93de2e0..1741c33 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -55,9 +55,6 @@
>  static void dlm_do_local_recovery_cleanup(struct dlm_ctxt *dlm, u8
> dead_node);
>
>  static int dlm_recovery_thread(void *data);
> -void dlm_complete_recovery_thread(struct dlm_ctxt *dlm);
> -int dlm_launch_recovery_thread(struct dlm_ctxt *dlm);
> -void dlm_kick_recovery_thread(struct dlm_ctxt *dlm);
>  static int dlm_do_recovery(struct dlm_ctxt *dlm);
>
>  static int dlm_pick_recovery_master(struct dlm_ctxt *dlm);
> --
> 1.7.9.7
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130522/c6a2a36b/attachment.html 

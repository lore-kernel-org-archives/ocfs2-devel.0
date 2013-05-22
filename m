From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 22 May 2013 15:53:36 -0700
Subject: [Ocfs2-devel] [PATCH] Remove unecessary ERROR when removing
 non-empty directory
In-Reply-To: <CAJtY7HXOYRsRVKckzAg9V2nBivWwSspk7SJaonqMxWcgqE-m9g@mail.gmail.com>
References: <CAJtY7HXOYRsRVKckzAg9V2nBivWwSspk7SJaonqMxWcgqE-m9g@mail.gmail.com>
Message-ID: <CAEeiSHXU-iXgLBmGwOi3+WCA0VcArVf-RjLAogVOns-creaB7w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Sunil Mushran <sunil.mushran@gmail.com>


On Mon, May 20, 2013 at 8:06 AM, Goldwyn Rodrigues <rgoldwyn@gmail.com>wrote:

> While removing a non-empty directory, the kernel dumps a message:
> (rmdir,21743,1):ocfs2_unlink:953 ERROR: status = -39
>
> Suppress the error message from being printed in the dmesg so users
> don't panic.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> ---
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 04ee1b5..33c7b91 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -947,7 +947,7 @@ leave:
>   ocfs2_free_dir_lookup_result(&orphan_insert);
>   ocfs2_free_dir_lookup_result(&lookup);
>
> - if (status)
> + if (status && (status != -ENOTEMPTY))
>   mlog_errno(status);
>
>   return status;
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130522/23383a46/attachment.html 

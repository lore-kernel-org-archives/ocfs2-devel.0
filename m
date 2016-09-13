From: Eric Ren <zren@suse.com>
Date: Tue, 13 Sep 2016 16:56:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: free the mle while the res had one,
 to avoid mle memory leak.
In-Reply-To: <71604351584F6A4EBAE558C676F37CA4A3D3522A@H3CMLB12-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA4A3D3522A@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <0d3f83e9-09f4-2fce-3881-0d56ebb50d89@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
On 09/13/2016 03:52 PM, Guozhonghua wrote:
> In the function dlm_migrate_request_handler, while the ret is --EEXIST, the mle should be freed, otherwise the memory will be leaked.
Keep your commit comments within 75 or 78 (I don't remember clearly but git will warn
if you don't keep its rule) characters per line.
>
> Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
>
> --- ocfs2.orig/dlm/dlmmaster.c  2016-09-13 15:18:13.602684325 +0800
Please use `git format-patch` to create patch. FYI:
http://wiki.openhatch.org/How_to_generate_patches_with_git_format-patch

Sorry, I don't familiar with ocfs2/dlm code, so cannot review this patch.

Eric
> +++ ocfs2/dlm/dlmmaster.c       2016-09-13 15:27:05.014675736 +0800
> @@ -3188,6 +3188,9 @@ int dlm_migrate_request_handler(struct o
>                                      migrate->new_master,
>                                      migrate->master);
>
> +       if (ret < 0)
> +               kmem_cache_free(dlm_mle_cache, mle);
> +
>          spin_unlock(&dlm->master_lock);
>   unlock:
>          spin_unlock(&dlm->spinlock);
>
>
> -------------------------------------------------------------------------------------------------------------------------------------
> ????????????????????????????????????????
> ????????????????????????????????????????
> ????????????????????????????????????????
> ???
> This e-mail and its attachments contain confidential information from H3C, which is
> intended only for the person or entity whose address is listed above. Any use of the
> information contained herein in any way (including, but not limited to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the intended
> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
> by phone or email immediately and delete it!
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

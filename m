From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 11 Mar 2014 10:11:23 -0700
Subject: [Ocfs2-devel] One Patch reported, Anyone review it, thanks
In-Reply-To: <71604351584F6A4EBAE558C676F37CA42EC3CCB9@H3CMLB02-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA42EC3CCB9@H3CMLB02-EX.srv.huawei-3com.com>
Message-ID: <531F43BB.4090701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Guozhonghua, idea of the fix looks good, but the patch doesn't seem to 
meet mainline standards. Can you please follow the instructions that 
Jeff emailed you last time and resubmit the patch.

On 03/11/2014 04:09 AM, Guozhonghua wrote:
>
> I review the code of the kernel 3.11.10.
>
> The difference is as below:
>
> -- ../linux-3.11.10/fs/ocfs2/dlm/dlmdomain.c       2013-11-30 
> 02:42:37.000000000 +0800
>
> +++ ocfs2-ko-3.11/dlm/dlmdomain.c     2014-03-11 18:57:23.323897515 +0800
>
> @@ -1135,6 +1135,9 @@ static int dlm_query_region_handler(stru
>
>       int status = 0;
>
>       int locked = 0;
>
> +    /* Wether domain locked */
>
comment probably not required
>
> +    int domain_locked = 0;
>
> +
>
>       qr = (struct dlm_query_region *) msg->buf;
>
>        mlog(0, "Node %u queries hb regions on domain %s\n", qr->qr_node,
>
> @@ -1150,6 +1153,7 @@ static int dlm_query_region_handler(stru
>
>       status = -EINVAL;
>
> spin_lock(&dlm_domain_lock);
>
> +    domain_locked = 1;
>
>       dlm = __dlm_lookup_domain_full(qr->qr_domain, qr->qr_namelen);
>
>       if (!dlm) {
>
> mlog(ML_ERROR, "Node %d queried hb regions on domain %s "
>
> @@ -1181,9 +1185,12 @@ static int dlm_query_region_handler(stru
>
> bail:
>
>       if (locked)
>
> spin_unlock(&dlm->spinlock);
>
> - spin_unlock(&dlm_domain_lock);
>
> -       kfree(local);
>
> +    if (domain_locked)
>
> + spin_unlock(&dlm_domain_lock);
>
> +
>
> +    if (local)
>
> +        kfree(local);
>
no need to check if (local),  kfree will take care of that part
>
>        return status;
>
> }
>
> -------------------------------------------------------------------------------------------------------------------------------------
> ??????????????????????????,?????????????
> ?????????????????????(??????????????????
> ???)?????????????????,??????????????????
> ??!
> This e-mail and its attachments contain confidential information from 
> H3C, which is
> intended only for the person or entity whose address is listed above. 
> Any use of the
> information contained herein in any way (including, but not limited 
> to, total or partial
> disclosure, reproduction, or dissemination) by persons other than the 
> intended
> recipient(s) is prohibited. If you receive this e-mail in error, 
> please notify the sender
> by phone or email immediately and delete it!
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140311/6b26603f/attachment-0001.html 

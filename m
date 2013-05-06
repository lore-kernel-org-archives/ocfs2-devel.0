From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Mon, 6 May 2013 09:34:24 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: unlock rw lock if inode lock failed
In-Reply-To: <5187C19B.4040708@huawei.com>
References: <5187C19B.4040708@huawei.com>
Message-ID: <CAEeiSHVpotgF51DKASph=dDAVCemCNgo73+f40nUM+8Oa7qXbg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Looks good to me.

Acked-by: Sunil Mushran <sunil.mushran@gmail.com>


On Mon, May 6, 2013 at 7:43 AM, Joseph Qi <joseph.qi@huawei.com> wrote:

> In ocfs2_file_aio_write, it does ocfs2_rw_lock first and then
> ocfs2_inode_lock. But if ocfs2_inode_lock failed, it goes to out_sems
> without unlocking rw lock. This will cause a bug in ocfs2_lock_res_free
> when testing res->l_ex_holders, which is increased in
> __ocfs2_cluster_lock and decreased in __ocfs2_cluster_unlock.
>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
>
> ---
>  fs/ocfs2/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6474cb4..e2cd7a8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2290,7 +2290,7 @@ relock:
>                 ret = ocfs2_inode_lock(inode, NULL, 1);
>                 if (ret < 0) {
>                         mlog_errno(ret);
> -                       goto out_sems;
> +                       goto out;
>                 }
>
>                 ocfs2_inode_unlock(inode, 1);
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130506/5718074c/attachment.html 

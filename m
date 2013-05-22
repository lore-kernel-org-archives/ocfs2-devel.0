From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 22 May 2013 16:05:46 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: goto out_unlock if
 ocfs2_get_clusters_nocache failed in ocfs2_fiemap
In-Reply-To: <5191E2DC.6070200@huawei.com>
References: <5191E2DC.6070200@huawei.com>
Message-ID: <CAEeiSHXNDmK9oxuFzZwW20uq8XKPUyu+Ed_W4cEra1BiA-0cbw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Sunil Mushran <sunil.mushran@gmail.com>


On Tue, May 14, 2013 at 12:08 AM, Joseph Qi <joseph.qi@huawei.com> wrote:

> Last time we found there is a lock/unlock bug in ocfs2_file_aio_write,
> and then we did a thoroughly search for all lock resources in
> ocfs2_inode_info, including rw, inode and open lockres and found this
> bug.
> My kernel version is 3.0.13, and it is also in the lastest version 3.9.
> In ocfs2_fiemap, once ocfs2_get_clusters_nocache failed, it should goto
> out_unlock instead of out, because we need release buffer head, up read
> alloc sem and unlock inode.
>
> Cc: stable at vger.kernel.org
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>
>
> ---
>  fs/ocfs2/extent_map.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index 1c39efb..2487116 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -790,7 +790,7 @@ int ocfs2_fiemap(struct inode *inode, struct
> fiemap_extent_info *fieinfo,
>                                                  &hole_size, &rec,
> &is_last);
>                 if (ret) {
>                         mlog_errno(ret);
> -                       goto out;
> +                       goto out_unlock;
>                 }
>
>                 if (rec.e_blkno == 0ULL) {
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
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130522/775d6888/attachment.html 

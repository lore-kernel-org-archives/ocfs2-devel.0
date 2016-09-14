From: Eric Ren <zren@suse.com>
Date: Wed, 14 Sep 2016 15:57:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix double unlock in case retry
 after free truncate log
In-Reply-To: <57D8CEF8.5010206@huawei.com>
References: <57D8CEF8.5010206@huawei.com>
Message-ID: <836ecbe3-f534-161e-c46c-2902412dd21b@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Joseph,

Thanks for fixing up this.

On 09/14/2016 12:15 PM, Joseph Qi wrote:
> If ocfs2_reserve_cluster_bitmap_bits fails with ENOSPC, it will try to
> free truncate log and then retry. Since ocfs2_try_to_free_truncate_log
> will lock/unlock global bitmap inode, we have to unlock it before
> calling this function. But when retry reserve and it fails with no
You mean the retry succeeds by "retry reserve", right? I fail to understand in which situation
the retry will fail to get global bitmap inode lock. Because I didn't see this problem when I
tested my patch, could you explain a bit more?

Eric
> global bitmap inode lock taken, it will unlock again in error handling
> branch and BUG.
> This issue also exists if no need retry and then ocfs2_inode_lock fails.
> So fix it.
>
> Fixes: 2070ad1aebff ("ocfs2: retry on ENOSPC if sufficient space in
> truncate log"
> Signed-off-by: Jospeh Qi <joseph.qi@huawei.com>
> Signed-off-by: Jiufei Xue <xuejiufei@huawei.com>
> ---
>   fs/ocfs2/suballoc.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index ea47120..041453b 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -1199,14 +1199,23 @@ retry:
>   			inode_unlock((*ac)->ac_inode);
>
>   			ret = ocfs2_try_to_free_truncate_log(osb, bits_wanted);
> -			if (ret == 1)
> +			if (ret == 1) {
> +				iput((*ac)->ac_inode);
> +				(*ac)->ac_inode = NULL;
>   				goto retry;
> +			}
>
>   			if (ret < 0)
>   				mlog_errno(ret);
>
>   			inode_lock((*ac)->ac_inode);
> -			ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
> +			status = ocfs2_inode_lock((*ac)->ac_inode, NULL, 1);
> +			if (status < 0) {
> +				inode_unlock((*ac)->ac_inode);
> +				iput((*ac)->ac_inode);
> +				(*ac)->ac_inode = NULL;
> +				goto bail;
> +			}
>   		}
>   		if (status < 0) {
>   			if (status != -ENOSPC)

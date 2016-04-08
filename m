From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 8 Apr 2016 09:03:41 +0800
Subject: [Ocfs2-devel] [PATCH V2] ocfs2/dlm: return zero if deref_done
 message is successfully handled
In-Reply-To: <57061CDC.6000600@huawei.com>
References: <57061CDC.6000600@huawei.com>
Message-ID: <5707036D.10508@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Thanks, Jiufei.
We'd better add:
Fixes: 60d663cb5273("ocfs2/dlm: add DEREF_DONE message")
Others looks good to me.

Reviewed-by: Joseph Qi <joseph.qi@huawei.com>

On 2016/4/7 16:39, xuejiufei wrote:
> Function dlm_deref_lockres_done_handler() should return zero
> if the message is successfully handled.
> 
> Signed-off-by: xuejiufei <xuejiufei@huawei.com>
> ---
>  fs/ocfs2/dlm/dlmmaster.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 9aed6e2..13719d3 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2455,6 +2455,8 @@ int dlm_deref_lockres_done_handler(struct o2net_msg *msg, u32 len, void *data,
> 
>  	spin_unlock(&dlm->spinlock);
> 
> +	ret = 0;
> +
>  done:
>  	dlm_put(dlm);
>  	return ret;
> 
